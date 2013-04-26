package com.leapmotion.leap.native
{
	import com.leapmotion.leap.Controller;
	import com.leapmotion.leap.Frame;
	import com.leapmotion.leap.interfaces.ILeapConnection;
	import com.leapmotion.leap.namespaces.leapmotion;

	import flash.events.StatusEvent;
	import flash.utils.getDefinitionByName;

	public class LeapNative implements ILeapConnection
	{
		/**
		 * Called when the Controller object connects to the Leap software, or when this Listener object is added to a Controller that is alrady connected.
		 */
		static private const LEAPNATIVE_CONNECTED:String = "onConnect";

		/**
		 * Called when the Controller object disconnects from the Leap software
		 */
		static private const LEAPNATIVE_DISCONNECTED:String = "onDisconnect";

		/**
		 * Called when a new frame of hand and finger tracking data is available.
		 *
		 * Access the new frame data from the public frame property of the event.
		 *
		 * Note, the Controller skips any pending onFrame events while your onFrame
		 * handler executes. If your implementation takes too long to return, one
		 * or more frames can be skipped. The Controller still inserts the skipped
		 * frames into the frame history. You can access recent frames by setting
		 * the history parameter when calling the LeapMotion.frame() function.
		 * You can determine if any pending onFrame events were skipped by
		 * comparing the ID of the most recent frame with the ID of the last
		 * received frame.
		 */
		static private const LEAPNATIVE_FRAME:String = "onFrame";

		/**
		 * Boolean toggle to check if the class has been initialized
		 */
		private static var initialized:Boolean;

		/**
		 * Reference to flash.external.ExtensionContext (only available on AIR)
		 */
		private static var ExtensionContextClass:*;

		/**
		 * Reference to the shared extension context
		 */
		private static var sharedContext:Object;

		/**
		 * The native extension context for the device
		 */
		private var context:Object;

		/**
		 * Most recent Frame received.
		 */
		private var _frame:Frame;

		/**
		 * Whether the Leap is currently connected.
		 */
		private var _isConnected:Boolean = false;

		/**
		 * Event Dispatcher singleton.
		 */
		private var controller:Controller;

		public function LeapNative()
		{
			controller = Controller.getInstance();
			context = tryCreatingExtensionContext();

			if ( context )
				controller.context = context;

			context.addEventListener( StatusEvent.STATUS, contextStatusModeEventHandler, false, 0, true );
		}

		/**
		 * Inline method. Triggered when extension context changes status.
		 * @param event
		 *
		 */
		[Inline]
		final private function contextStatusModeEventHandler( event:StatusEvent ):void
		{
			if ( event.code == LEAPNATIVE_FRAME )
			{
				handleOnFrame();
			}
			else if ( event.code == LEAPNATIVE_CONNECTED )
			{
				handleOnConnect();
			}
			else if ( event.code == LEAPNATIVE_DISCONNECTED )
			{
				handleOnDisconnect();
			}
			else
			{
				trace( "[LeapNative] contextStatusModeEventHandler: ", event.code, event.level );
			}
		}

		/**
		 * Inline method. Triggered when native extension context connects to the Leap
		 *
		 */
		[Inline]
		final private function handleOnConnect():void
		{
			_isConnected = true;
			controller.leapmotion::callback.onConnect( controller );
		}

		/**
		 * Inline method. Triggered when native extension context disconnects from the Leap
		 *
		 */
		[Inline]
		final private function handleOnDisconnect():void
		{
			_isConnected = false;
			controller.leapmotion::callback.onDisconnect( controller );
			controller.leapmotion::callback.onExit( controller );
		}

		/**
		 * Inline method. Triggered when native extension context dispatches a Frame.
		 *
		 */
		[Inline]
		final private function handleOnFrame():void
		{
			// Add frame to history
			if ( controller.frameHistory.length > 59 )
			{
				controller.frameHistory.splice( 59, 1 );
			}

			controller.frameHistory.unshift( _frame );

			_frame = context.call( "getFrame" );

			controller.leapmotion::callback.onFrame( controller, _frame );
		}

		/**
		 * Reports whether the native library is supported.
		 *
		 * @return True if supported; false otherwise.
		 */
		public static function isSupported():Boolean
		{
			if ( !initialized )
			{
				initialized = true;
				if ( tryCreatingExtensionContextClassReference() )
				{
					sharedContext = tryCreatingExtensionContext( "shared" );
					if ( sharedContext )
					{
						try
						{
							var supported:Boolean = sharedContext.call( "isSupported" );
							return supported;
						}
						catch ( error:Error )
						{
							trace( "[LeapNative] Leap Native Extension is not supported." );
							trace( "[LeapNative] If you are on Windows, add the Leap software folder to your PATH." );
							trace( "[LeapNative] Falling back on Socket implementation." );
						}
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * Tries to return a reference to the class object of the class
		 * specified.
		 *
		 * @return True, if definition could be found; False otherwise.
		 *
		 */
		private static function tryCreatingExtensionContextClassReference():Boolean
		{
			try
			{
				ExtensionContextClass = getDefinitionByName( "flash.external.ExtensionContext" );
				return true;
			}
			catch ( error:Error )
			{
				trace( "[LeapNative] tryCreatingExtensionContextClassReference: " + error.message );
			}
			return false;
		}

		/**
		 * Tries to create a LeapNative class context.
		 *
		 * @param contextType
		 * @return
		 *
		 */
		private static function tryCreatingExtensionContext( contextType:String = null ):Object
		{
			try
			{
				var context:Object = ExtensionContextClass.createExtensionContext( "com.leapmotion.leap.air.native.LeapNative", contextType );
				return context;
			}
			catch ( error:Error )
			{
				trace( "[LeapNative] tryCreatingExtensionContext: " + error.message );
			}
			return null;
		}

		/**
		 * Whether the Leap is currently connected.
		 */
		public function get isConnected():Boolean
		{
			return _isConnected;
		}

		/**
		 * Most recent Frame received.
		 */
		[Inline]
		final public function get frame():Frame
		{
			return _frame;
		}

		/**
		 * Enables or disables reporting of a specified gesture type.
		 * By default, all gesture types are disabled. When disabled, gestures of
		 * the disabled type are never reported and will not appear in the frame
		 * gesture list.
		 *
		 * As a performance optimization, only enable recognition for the types
		 * of movements that you use in your application.
		 *
		 * @param type The type of gesture to enable or disable. Must be a member of the Gesture::Type enumeration.
		 * @param enable True, to enable the specified gesture type; False, to disable.
		 *
		 */
		public function enableGesture( gesture:int, enable:Boolean = true ):void
		{
			context.call( "enableGesture", gesture, enable );
		}

		/**
		 * Reports whether the specified gesture type is enabled.
		 *
		 * @param type The Gesture.TYPE parameter.
		 * @return True, if the specified type is enabled; false, otherwise.
		 *
		 */
		public function isGestureEnabled( type:int ):Boolean
		{
			var isEnabled:Boolean = context.call( "isGestureEnabled", type );
			return isEnabled;
		}

		/**
		 * Gets the active policy settings.
		 *
		 * Use this function to determine the current policy state.
		 * Keep in mind that setting a policy flag is asynchronous, so changes are
		 * not effective immediately after calling setPolicyFlag(). In addition, a
		 * policy request can be declined by the user. You should always set the
		 * policy flags required by your application at startup and check that the
		 * policy change request was successful after an appropriate interval.
		 *
		 * If the controller object is not connected to the Leap, then the default
		 * policy state is returned.
		 *
		 * @returns The current policy flags.
		 */
		public function policyFlags():uint
		{
			return context.call( "getPolicyFlags" );
		}

		/**
		 * Requests a change in policy.
		 *
		 * A request to change a policy is subject to user approval and a policy
		 * can be changed by the user at any time (using the Leap settings window).
		 * The desired policy flags must be set every time an application runs.
		 *
		 * Policy changes are completed asynchronously and, because they are subject
		 * to user approval, may not complete successfully. Call
		 * Controller::policyFlags() after a suitable interval to test whether
		 * the change was accepted.
		 *
		 * Currently, the background frames policy is the only policy supported.
		 * The background frames policy determines whether an application
		 * receives frames of tracking data while in the background. By
		 * default, the Leap only sends tracking data to the foreground application.
		 * Only applications that need this ability should request the background
		 * frames policy.
		 *
		 * At this time, you can use the Leap applications Settings window to
		 * globally enable or disable the background frames policy. However,
		 * each application that needs tracking data while in the background
		 * must also set the policy flag using this function.
		 *
		 * This function can be called before the Controller object is connected,
		 * but the request will be sent to the Leap after the Controller connects.
		 *
		 * @param flags A PolicyFlag value indicating the policies to request.
		 */
		public function setPolicyFlags( flags:uint ):void
		{
			trace("call set policy flags");
			context.call( "setPolicyFlags", flags );
		}
	}
}

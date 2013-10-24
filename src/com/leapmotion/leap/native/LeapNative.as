package com.leapmotion.leap.native
{
	import com.leapmotion.leap.Controller;
	import com.leapmotion.leap.Frame;
	import com.leapmotion.leap.interfaces.ILeapConnection;
	import com.leapmotion.leap.namespaces.leapmotion;
	
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.utils.getDefinitionByName;

	public class LeapNative implements ILeapConnection
	{
		/**
		 * Called once, when this Listener object is newly added to a Controller.
		 */
		static private const LEAPNATIVE_INIT:String = "onInit";

		/**
		 * Called when the Controller object connects to the Leap Motion software,
		 * or when this Listener object is added to a Controller that is alrady connected.
		 */
		static private const LEAPNATIVE_CONNECTED:String = "onConnect";

		/**
		 * Called when the Controller object disconnects from the Leap Motion software
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
		 * Called when this application becomes the foreground application.
		 *
		 * <p>Only the foreground application receives tracking data from the
		 * Leap Motion. This function is only called when the
		 * controller object is in a connected state.</p>
		 *
		 */
		static private const LEAPNATIVE_FOCUSGAINED:String = "onFocusGained";

		/**
		 * Called when this application loses the foreground focus.
		 *
		 * <p>Only the foreground application receives tracking data from the
		 * Leap Motion. This function is only called when the
		 * controller object is in a connected state.</p>
		 *
		 */
		static private const LEAPNATIVE_FOCUSLOST:String = "onFocusLost";

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
		 * Whether the Leap Motion is currently connected.
		 */
		private var _isConnected:Boolean = false;

		/**
		 * Event Dispatcher singleton.
		 */
		private var controller:Controller;

		public function LeapNative( _controller:Controller )
		{
			controller = _controller;
			context = tryCreatingExtensionContext();

			if( context )
			{
				controller.context = context;
				context.addEventListener( StatusEvent.STATUS, contextStatusModeEventHandler, false, 0, true );
				var NativeApplicationClass:* = getNativeApplicationClassReference();
				if( NativeApplicationClass )
				{
					NativeApplicationClass.nativeApplication.addEventListener( "exiting", onNativeApplicatonExitHandler );
				}
			}
		}
		
		/**
		 * Tries to return a reference to the class object of the class
		 * specified.
		 *
		 * @return NativeApplication, if definition could be found; null otherwise.
		 *
		 */
		private static function getNativeApplicationClassReference():*
		{
			try
			{
				return getDefinitionByName( "flash.desktop.NativeApplication" );
			}
			catch( error:Error )
			{
				trace( "[LeapNative] getNativeApplicationClassReference: " + error.message );
			}
			return null;
		}
		
		/**
		 * Triggered when application closes.
		 * @param event
		 *
		 */
		private function onNativeApplicatonExitHandler( event:Event ) :void
		{
			try
			{
				context.dispose();
			}
			catch( error:Error )
			{
				
			}
		}

		/**
		 * Inline method. Triggered when extension context changes status.
		 * @param event
		 *
		 */
		[Inline]
		final private function contextStatusModeEventHandler( event:StatusEvent ):void
		{
			if( event.code == LEAPNATIVE_FRAME )
			{
				handleOnFrame();
			}
			else if( event.code == LEAPNATIVE_FOCUSGAINED )
			{
				handleOnFocusGained();
			}
			else if( event.code == LEAPNATIVE_FOCUSLOST )
			{
				handleOnFocusLost();
			}
			else if( event.code == LEAPNATIVE_CONNECTED )
			{
				handleOnConnect();
			}
			else if( event.code == LEAPNATIVE_DISCONNECTED )
			{
				handleOnDisconnect();
			}
			else if( event.code == LEAPNATIVE_INIT )
			{
				handleOnInit();
			}
			else
			{
				trace( "[LeapNative] contextStatusModeEventHandler: ", event.code, event.level );
			}
		}

		/**
		 * Inline method. Called once, when a Listener object is newly added to a Controller.
		 *
		 */
		[Inline]
		final private function handleOnInit():void
		{
			controller.leapmotion::listener.onInit( controller );
		}

		/**
		 * Inline method. Triggered when native extension context connects to the Leap Motion.
		 *
		 */
		[Inline]
		final private function handleOnConnect():void
		{
			_isConnected = true;
			controller.leapmotion::listener.onConnect( controller );
		}

		/**
		 * Inline method. Triggered when native extension context disconnects from the Leap Motion.
		 *
		 */
		[Inline]
		final private function handleOnDisconnect():void
		{
			_isConnected = false;
			controller.leapmotion::listener.onDisconnect( controller );
		}

		/**
		 * Inline method. Triggered when native extension context switches to foreground.
		 *
		 */
		[Inline]
		final private function handleOnFocusGained():void
		{
			controller.leapmotion::listener.onFocusGained( controller );
		}

		/**
		 * Inline method. Triggered when native extension context switches to background.
		 *
		 */
		[Inline]
		final private function handleOnFocusLost():void
		{
			controller.leapmotion::listener.onFocusLost( controller );
		}

		/**
		 * Inline method. Triggered when native extension context dispatches a Frame.
		 *
		 */
		[Inline]
		final private function handleOnFrame():void
		{
			// Add frame to history
			if( controller.frameHistory.length > 59 )
			{
				controller.frameHistory.splice( 59, 1 );
			}

			controller.frameHistory.unshift( _frame );

			_frame = context.call( "getFrame" );

			// Add Controller to frame
			_frame.controller = controller;

			controller.leapmotion::listener.onFrame( controller, _frame );
		}

		/**
		 * Reports whether the native library is supported.
		 *
		 * @return True if supported; false otherwise.
		 */
		public static function isSupported():Boolean
		{
			if( !initialized )
			{
				initialized = true;
				if( tryCreatingExtensionContextClassReference() )
				{
					sharedContext = tryCreatingExtensionContext( "shared" );
					if( sharedContext )
					{
						try
						{
							var supported:Boolean = sharedContext.call( "isSupported" );
							return supported;
						}
						catch( error:Error )
						{
							trace( "[LeapNative] Leap Motion Native Extension is not supported." );
							trace( "[LeapNative] If you are on Windows, add the Leap Motion software folder to your PATH." );
							trace( "[LeapNative] Falling back on Socket implementation." );
							return false;
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
			catch( error:Error )
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
			catch( error:Error )
			{
				trace( "[LeapNative] tryCreatingExtensionContext: " + error.message );
			}
			return null;
		}

		/**
		 * Whether the Leap Motion is currently connected.
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
		 * <p>Use this function to determine the current policy state.
		 * Keep in mind that setting a policy flag is asynchronous, so changes are
		 * not effective immediately after calling <code>setPolicyFlag()</code>. In addition, a
		 * policy request can be declined by the user. You should always set the
		 * policy flags required by your application at startup and check that the
		 * policy change request was successful after an appropriate interval.</p>
		 *
		 * <p>If the controller object is not connected to the Leap, then the default
		 * policy state is returned.</p>
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
		 * <p>A request to change a policy is subject to user approval and a policy
		 * can be changed by the user at any time (using the Leap Motion settings window).
		 * The desired policy flags must be set every time an application runs.</p>
		 *
		 * <p>Policy changes are completed asynchronously and, because they are subject
		 * to user approval, may not complete successfully. Call
		 * <code>Controller.policyFlags()</code> after a suitable interval to test whether
		 * the change was accepted.</p>
		 *
		 * <p>Currently, the background frames policy is the only policy supported.
		 * The background frames policy determines whether an application
		 * receives frames of tracking data while in the background. By
		 * default, the Leap Motion only sends tracking data to the foreground application.
		 * Only applications that need this ability should request the background
		 * frames policy.</p>
		 *
		 * <p>At this time, you can use the Leap Motion applications Settings window to
		 * globally enable or disable the background frames policy. However,
		 * each application that needs tracking data while in the background
		 * must also set the policy flag using this function.</p>
		 *
		 * <p>This function can be called before the Controller object is connected,
		 * but the request will be sent to the Leap Motion after the Controller connects.</p>
		 *
		 * @param flags A PolicyFlag value indicating the policies to request.
		 */
		public function setPolicyFlags( flags:uint ):void
		{
			context.call( "setPolicyFlags", flags );
		}
	}
}

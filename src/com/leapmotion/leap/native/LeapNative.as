package com.leapmotion.leap.native
{
	import com.leapmotion.leap.Frame;
	import com.leapmotion.leap.connection.ILeapConnection;
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.events.LeapProxy;
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.utils.getDefinitionByName;

	public class LeapNative extends EventDispatcher implements ILeapConnection
	{
		/**
		 * Called when the Controller object connects to the Leap software, or when this Listener object is added to a Controller that is alrady connected.
		 */
		static public const LEAPNATIVE_CONNECTED:String = "onConnect";
		
		/**
		 * Called when the Controller object disconnects from the Leap software
		 */
		static public const LEAPNATIVE_DISCONNECTED:String = "onDisconnect";

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
		static public const LEAPNATIVE_FRAME:String = "onFrame";

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
		 * Most recent parsed Frame received from Socket.
		 */
		private var _frame:Frame;

		/**
		 * Whether the Leap is currently connected.
		 */
		private var _isConnected:Boolean = false;

		/**
		 * Event Dispatcher singleton.
		 */
		private var controller:LeapProxy;

		public function LeapNative()
		{
			context = tryCreatingExtensionContext();
			context.addEventListener( StatusEvent.STATUS, contextStatusHandler, false, 0, true );

			controller = LeapProxy.getInstance();
		}

		private function contextStatusHandler( event:StatusEvent ):void
		{
			switch ( event.code )
			{
				case LeapNative.LEAPNATIVE_CONNECTED:
					handleOnConnect();
					break;
				case LeapNative.LEAPNATIVE_DISCONNECTED:
					handleOnDisconnect();
					break;
				case LeapNative.LEAPNATIVE_FRAME:
					handleOnFrame();
					break;
				default:
					trace( "[LeapNative] status", event.code, event.level );
					break;
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
			controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_CONNECTED ));
		}
		
		/**
		 * Inline method. Triggered when native extension context disconnects from the Leap
		 *
		 */
		[Inline]
		final private function handleOnDisconnect():void
		{
			_isConnected = false;
			controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_DISCONNECTED ));
			controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_EXIT ));
		}

		/**
		 * Inline method. Triggered when native extension context dispatches a Frame.
		 *
		 */
		[Inline]
		final private function handleOnFrame():void
		{
			var currentFrame:Frame = context.call( "getFrame" );
			controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_FRAME, currentFrame ));

			// Add frame to history
			if ( controller.frameHistory.length > 59 )
				controller.frameHistory.splice( 59, 1 );

			controller.frameHistory.unshift( _frame );

			_frame = currentFrame;
		}

		/**
		 * Reports whether the native library is supported.
		 *
		 * @return True if supported; false otherwise
		 */
		public static function isSupported():Boolean
		{
			if ( !initialized )
			{
				initialized = true;
				if ( tryCreatingExtensionContextClassReference())
				{
					sharedContext = tryCreatingExtensionContext( "shared" );
					if ( sharedContext )
					{
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
			catch ( event:Error )
			{
				trace( event.message );
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
			catch ( event:Error )
			{
				trace( event.message );
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
		 * Most recent parsed Frame received from Socket.
		 */
		public function get frame():Frame
		{
			return _frame;
		}
	}
}

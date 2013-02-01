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
            trace("[LeapNative] constructor");
            context = tryCreatingExtensionContext();
            context.addEventListener(StatusEvent.STATUS, contextStatusHandler, false, 0, true);
			
			controller = LeapProxy.getInstance();
        }

        private function contextStatusHandler(event:StatusEvent):void
        {
			switch(event.code)
			{
				case "onConnect":
					_isConnected = true;
					controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_CONNECTED ));
					break;
				case "onFrame":
					handleOnFrame();
					break;
				default:
					trace("[LeapNative] status", event.code, event.level);
					break;
			}
        }
		
		private function handleOnFrame():void
		{
			var currentFrame:Frame = context.call("getFrame");
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
            if(!initialized)
            {
                initialized = true;
                if(tryCreatingExtensionContextClassReference())
                {
                    sharedContext = tryCreatingExtensionContext("shared");
                    if(sharedContext)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        private static function tryCreatingExtensionContextClassReference():Boolean
        {
            try
            {
                ExtensionContextClass = getDefinitionByName("flash.external.ExtensionContext");
                return true;
            }
            catch(e:Error)
            {
                trace(e.message);
            }
            return false;
        }

        private static function tryCreatingExtensionContext(contextType:String = null):Object
        {
            try
            {
                var context:Object = ExtensionContextClass.createExtensionContext("com.leapmotion.leap.air.native.LeapNative", contextType);
                return context;
            }
            catch(e:Error)
            {
                trace(e.message);
            }
            return null;
        }

        /**
         * Most recent parsed Frame received from Socket.
         */
        public function get isConnected():Boolean
        {
            return _isConnected;
        }

        /**
         * Whether the Leap is currently connected.
         */
        public function get frame():Frame
        {
            return _frame;
        }
    }
}

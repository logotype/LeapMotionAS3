package com.leapmotion.leap
{

	import com.leapmotion.leap.callbacks.DefaultCallback;
	import com.leapmotion.leap.interfaces.ILeapCallback;
	import com.leapmotion.leap.interfaces.ILeapConnection;
	import com.leapmotion.leap.namespaces.leapmotion;
	import com.leapmotion.leap.native.LeapNative;
	import com.leapmotion.leap.socket.LeapSocket;

	import flash.events.EventDispatcher;

	/**
	 * The main event dispatcher for Leap events.
	 * @author logotype
	 *
	 */
	[Event( name = "leapmotionInit", type = "com.leapmotion.leap.events.LeapEvent" )]
	[Event( name = "leapmotionConnected", type = "com.leapmotion.leap.events.LeapEvent" )]
	[Event( name = "leapmotionDisconnected", type = "com.leapmotion.leap.events.LeapEvent" )]
	[Event( name = "leapmotionTimeout", type = "com.leapmotion.leap.events.LeapEvent" )]
	[Event( name = "leapmotionExit", type = "com.leapmotion.leap.events.LeapEvent" )]
	[Event( name = "leapmotionFrame", type = "com.leapmotion.leap.events.LeapEvent" )]
	public class Controller extends EventDispatcher
	{
		/**
		 * The Listener subclass instance.
		 */
		leapmotion var callback:ILeapCallback;

		/**
		 * Current connection, either native or socket.
		 */
		public var connection:ILeapConnection;

		/**
		 * The singleton instance.
		 */
		static private var instance:Controller;

		/**
		 * History of frame of tracking data from the Leap.
		 */
		public var frameHistory:Vector.<Frame> = new Vector.<Frame>();

		public function Controller()
		{
			leapmotion::callback = new DefaultCallback();
		}

		/**
		 * Initializes connection to the Leap.
		 *
		 * @param host Optional. The host computer with the Leap device
		 * (currently only supported for socket connections).
		 *
		 */
		public function init( host:String = null ):void
		{
			if ( !host && LeapNative.isSupported() )
			{
				connection = new LeapNative();
			}
			else
			{
				connection = new LeapSocket( host );
			}
		}

		/**
		 * Returns a frame of tracking data from the Leap.
		 *
		 * Use the optional history parameter to specify which frame to retrieve.
		 * Call frame() or frame(0) to access the most recent frame; call frame(1)
		 * to access the previous frame, and so on. If you use a history value
		 * greater than the number of stored frames, then the controller returns
		 * an invalid frame.
		 *
		 * @param history The age of the frame to return, counting backwards from
		 * the most recent frame (0) into the past and up to the maximum age (59).
		 *
		 * @return The specified frame; or, if no history parameter is specified,
		 * the newest frame. If a frame is not available at the specified
		 * history position, an invalid Frame is returned.
		 *
		 */
		public function frame( history:int = 0 ):Frame
		{
			var returnValue:Frame;

			if ( history >= frameHistory.length )
				returnValue = Frame.invalid();
			else if ( history == 0 )
				returnValue = connection.frame;
			else
				returnValue = frameHistory[ history ];

			return returnValue;
		}

		/**
		 * Update the object that receives direct updates from the Leap device.
		 * The default callback will make the controller dispatch flash events.
		 * You can override this behaviour, by implementing the IListener interface
		 * in your own classes, and use this method to set the callback to your
		 * own implementation.
		 *
		 * @param callback
		 */
		public function setCallback( callback:ILeapCallback ):void
		{
			this.leapmotion::callback = callback;
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
		public function enableGesture( type:int, enable:Boolean = true ):void
		{
			// TODO: Implement enableGesture
		}

		static public function getInstance():Controller
		{
			if ( instance == null )
				instance = new Controller();

			return instance;
		}
	}
}

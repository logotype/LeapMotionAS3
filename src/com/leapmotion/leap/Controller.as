package com.leapmotion.leap
{

	import com.leapmotion.leap.connection.ILeapConnection;
	import com.leapmotion.leap.native.LeapNative;
	import com.leapmotion.leap.socket.LeapSocket;
	
	import flash.events.EventDispatcher;

	/**
	 * The main event dispatcher for Leap events.
	 * @author logotype
	 *
	 */
	public class Controller extends EventDispatcher
	{
		/**
		 * Using events for data. 
		 */
		static public const MODE_EVENT:int = 0;
		
		/**
		 * Using callbacks for data. 
		 */
		static public const MODE_SUBCLASS:int = 1;
		
		/**
		 * Current mode state. 
		 */
		public var mode:int = MODE_EVENT;
		
		/**
		 * The Listener subclass instance. 
		 */
		public var callback:Listener;
		
		/**
		 * Current connection, either native or socket. 
		 */
		public var connection:ILeapConnection;
		
		/**
		 * The singleton instance variable.
		 */
		static private var instance:Controller;

		/**
		 * History of frame of tracking data from the Leap.
		 */
		public var frameHistory:Vector.<Frame> = new Vector.<Frame>();
		
		public function Controller()
		{
		}
		
		/**
		 * Initializes connection to the Leap.
		 *  
		 * @param host Optional. The host computer with the Leap device
		 * (currently only supported for socket connections).
		 * 
		 */
		public function init( host:String = null ) :void
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

		static public function getInstance():Controller
		{
			if ( instance == null )
				instance = new Controller();

			return instance;
		}
	}
}

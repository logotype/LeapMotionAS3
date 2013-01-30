package com.leapmotion.leap.events
{
	import com.leapmotion.leap.Frame;

	import flash.events.EventDispatcher;

	/**
	 * The main event dispatcher for Leap events.
	 * @author logotype
	 *
	 */
	public class LeapProxy extends EventDispatcher
	{
		/**
		 * The singleton instance variable.
		 */
		static private var instance:LeapProxy;

		/**
		 * History of frame of tracking data from the Leap.
		 */
		public var frameHistory:Vector.<Frame> = new Vector.<Frame>();

		public function LeapProxy()
		{
		}

		static public function getInstance():LeapProxy
		{
			if ( instance == null )
				instance = new LeapProxy();

			return instance;
		}
	}
}

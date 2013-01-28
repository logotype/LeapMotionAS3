package com.leapmotion.leap.events
{
	import flash.events.EventDispatcher;

	/**
	 * The main event dispatcher for Leap events. 
	 * @author logotype
	 * 
	 */
	public class LeapMotionEventProxy extends EventDispatcher
	{
		/**
		 * The singleton instance variable. 
		 */
		static private var instance:LeapMotionEventProxy;

		public function LeapMotionEventProxy()
		{
			super();
		}

		static public function getInstance():LeapMotionEventProxy
		{
			if ( instance == null )
				instance = new LeapMotionEventProxy();

			return instance;
		}
	}
}

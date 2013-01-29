package com.leapmotion.leap.events
{
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

		public function LeapProxy()
		{
			super();
		}

		static public function getInstance():LeapProxy
		{
			if ( instance == null )
				instance = new LeapProxy();

			return instance;
		}
	}
}

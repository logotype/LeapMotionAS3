package com.leapmotion.leap.events
{
	import flash.events.EventDispatcher;

	public class LeapMotionEventProxy extends EventDispatcher
	{
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

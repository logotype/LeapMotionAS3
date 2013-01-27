package com.leapmotion.leap
{
	import com.leapmotion.leap.events.LeapMotionEventProxy;
	import com.leapmotion.leap.socket.LeapSocket;
	
	import flash.events.EventDispatcher;

	public class LeapMotion extends EventDispatcher
	{
		private var socket:LeapSocket;
		public var data:LeapMotionEventProxy;

		public function LeapMotion()
		{
			data = LeapMotionEventProxy.getInstance();
			socket = new LeapSocket();
		}
	}
}

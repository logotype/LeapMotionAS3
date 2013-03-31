package com.leapmotion.leap.callbacks
{
	import com.leapmotion.leap.Controller;
	import com.leapmotion.leap.Frame;
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.interfaces.ILeapCallback;

	public class DefaultCallback implements ILeapCallback
	{

		public function DefaultCallback()
		{
		}

		public function onConnect( controller:Controller ):void
		{
			controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_CONNECTED ) );
		}

		public function onDisconnect( controller:Controller ):void
		{
			controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_DISCONNECTED ) );
		}

		public function onExit( controller:Controller ):void
		{
			controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_EXIT ) );
		}

		public function onFrame( controller:Controller, frame:Frame ):void
		{
			controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_FRAME, frame ) );
		}

		public function onInit( controller:Controller ):void
		{
			controller.dispatchEvent( new LeapEvent( LeapEvent.LEAPMOTION_INIT ) );
		}
	}
}

package com.leapmotion.leap.events
{
	import flash.events.Event;
	import com.leapmotion.leap.Frame;

	public class LeapMotionEvent extends Event
	{
		static public const LEAPMOTION_INIT:String = "onInit";
		static public const LEAPMOTION_CONNECTED:String = "onConnect";
		static public const LEAPMOTION_DISCONNECTED:String = "onDisconnect";
		static public const LEAPMOTION_TIMEOUT:String = "onTimeout";
		static public const LEAPMOTION_EXIT:String = "onExit";
		static public const LEAPMOTION_FRAME:String = "onFrame";

		public var frame:Frame;

		public function LeapMotionEvent( type:String, frame:Frame = null )
		{
			this.frame = frame;
			super( type, true, false );
		}
	}
}
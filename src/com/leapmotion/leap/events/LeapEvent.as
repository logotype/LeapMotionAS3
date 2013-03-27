package com.leapmotion.leap.events
{
	import com.leapmotion.leap.Frame;

	import flash.events.Event;

	public class LeapEvent extends Event
	{
		/**
		 * Called once, when this Listener object is newly added to a Controller.
		 */
		static public const LEAPMOTION_INIT:String = "leapmotionInit";

		/**
		 * Called when the Controller object connects to the Leap software, or when this Listener object is added to a Controller that is alrady connected.
		 */
		static public const LEAPMOTION_CONNECTED:String = "leapmotionConnected";
		/**
		 * The controller can disconnect when the Leap device is unplugged, the user shuts the Leap software down, or the Leap software encounters an unrecoverable error.
		 * Note: When you launch a Leap-enabled application in a debugger, the Leap library does not disconnect from the application. This is to allow you to step through code without losing the connection because of time outs.
		 */
		static public const LEAPMOTION_DISCONNECTED:String = "leapmotionDisconnected";

		/**
		 * Called when the Leap handshake procedure exceeds a specified timeout.
		 */
		static public const LEAPMOTION_TIMEOUT:String = "leapmotionTimeout";

		/**
		 * Called when this Listener object is removed from the Controller or the Controller instance is destroyed.
		 */
		static public const LEAPMOTION_EXIT:String = "leapmotionExit";

		/**
		 * Called when a new frame of hand and finger tracking data is available.
		 *
		 * Access the new frame data from the public frame property of the event.
		 *
		 * Note, the Controller skips any pending onFrame events while your onFrame
		 * handler executes. If your implementation takes too long to return, one
		 * or more frames can be skipped. The Controller still inserts the skipped
		 * frames into the frame history. You can access recent frames by setting
		 * the history parameter when calling the LeapMotion.frame() function.
		 * You can determine if any pending onFrame events were skipped by
		 * comparing the ID of the most recent frame with the ID of the last
		 * received frame.
		 */
		static public const LEAPMOTION_FRAME:String = "leapmotionFrame";

		/**
		 * The most recent Frame object.
		 * @see Frame
		 */
		public var frame:Frame;

		public function LeapEvent( type:String, frame:Frame = null )
		{
			this.frame = frame;
			super( type, false, false );
		}
	}
}
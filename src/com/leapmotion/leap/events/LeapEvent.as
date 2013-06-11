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
		 * Called when the Controller object connects to the Leap Motion software, or when this Listener object is added to a Controller that is alrady connected.
		 */
		static public const LEAPMOTION_CONNECTED:String = "leapmotionConnected";

		/**
		 * The controller can disconnect when the Leap Motion is unplugged, the user shuts the Leap Motion software down, or the Leap Motion software encounters an unrecoverable error.
		 * Note: When you launch a Leap-enabled application in a debugger, the Leap Motion library does not disconnect from the application. This is to allow you to step through code without losing the connection because of time outs.
		 */
		static public const LEAPMOTION_DISCONNECTED:String = "leapmotionDisconnected";

		/**
		 * Called when the Leap Motion handshake procedure exceeds a specified timeout.
		 */
		static public const LEAPMOTION_TIMEOUT:String = "leapmotionTimeout";

		/**
		 * Called when this Listener object is removed from the Controller or the Controller instance is destroyed.
		 */
		static public const LEAPMOTION_EXIT:String = "leapmotionExit";

		/**
		 * Called when this application becomes the foreground application.
		 *
		 * <p>Only the foreground application receives tracking data from the
		 * Leap Motion. This function is only called when the
		 * controller object is in a connected state.</p>
		 */
		static public const LEAPMOTION_FOCUSGAINED:String = "leapmotionFocusGained";

		/**
		 * Called when this application loses the foreground focus.
		 *
		 * <p>Only the foreground application receives tracking data from the
		 * Leap Motion. This function is only called when the
		 * controller object is in a connected state.</p>
		 */
		static public const LEAPMOTION_FOCUSLOST:String = "leapmotionFocusLost";

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

		public function LeapEvent( type:String, _frame:Frame = null )
		{
			frame = _frame;
			super( type, false, false );
		}
	}
}

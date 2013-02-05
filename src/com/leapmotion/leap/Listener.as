package com.leapmotion.leap
{
	import flash.display.Sprite;

	/**
	 * The Listener class defines a set of callback functions that you can
	 * override in a subclass to respond to events dispatched by the Leap.
	 *
	 * To handle Leap events, create an instance of a Listener subclass.
	 * The Controller calls the relevant Listener callback function when
	 * an event occurs, passing in a reference to itself.
	 * You do not have to implement callbacks for events you do not want to handle.
	 *
	 * The Controller object calls these Listener functions from a thread
	 * created by the Leap library, not the thread used to
	 * create or set the Listener instance.
	 *
	 * @author logotype
	 *
	 */
	public class Listener extends Sprite
	{
		/**
		 * The Controller object invoking the callback function(s).
		 */
		protected var controller:Controller;

		public function Listener()
		{
			controller = Controller.getInstance();
			controller.mode = Controller.MODE_SUBCLASS;
			controller.callback = this;
			this.onInit( controller );
		}

		/**
		 * Called when the Controller object connects to the Leap software.
		 *
		 * @param controller The Controller object invoking this callback function.
		 *
		 */
		public function onConnect( controller:Controller ):void
		{
			
		}

		/**
		 * Called when the Controller object disconnects from the Leap software.
		 *
		 * The controller can disconnect when the Leap device is unplugged,
		 * the user shuts the Leap software down, or the Leap software
		 * encounters an unrecoverable error.
		 *
		 * @param controller The Controller object invoking this callback function.
		 *
		 */
		public function onDisconnect( controller:Controller ):void
		{

		}

		/**
		 * Called when this Listener object is removed from the Controller
		 * or the Controller instance is destroyed.
		 *
		 * @param controller The Controller object invoking this callback function.
		 *
		 */
		public function onExit( controller:Controller ):void
		{

		}

		/**
		 * Called when a new frame of hand and finger tracking data is available.
		 *
		 * Access the new frame data using the Controller.frame() function.
		 *
		 * Note, the Controller skips any pending onFrame events while your
		 * onFrame handler executes. If your implementation takes too long to
		 * return, one or more frames can be skipped. The Controller still
		 * inserts the skipped frames into the frame history. You can access
		 * recent frames by setting the history parameter when calling the
		 * Controller.frame() function. You can determine if any pending
		 * onFrame events were skipped by comparing the ID of the most recent
		 * frame with the ID of the last received frame.
		 *
		 * @param controller The Controller object invoking this callback function.
		 *
		 */
		public function onFrame( controller:Controller ):void
		{

		}

		/**
		 * Called once, when this Listener object is newly added to a Controller.
		 *  
		 * @param controller The Controller object invoking this callback function.
		 * 
		 */
		public function onInit( controller:Controller ):void
		{
			
		}
	}
}

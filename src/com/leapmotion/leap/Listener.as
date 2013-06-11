package com.leapmotion.leap
{

	/**
	 * The Listener interface defines a set of callback functions that you can
	 * implement to respond to events dispatched by the Leap Motion.
	 *
	 * <p>To handle Leap Motion events, implement the Listener interface and assign
	 * it to the Controller instance. The Controller calls the relevant Listener
	 * callback function when an event occurs, passing in a reference to itself.
	 * You have to implement callbacks for every method specified in the interface.</p>
	 *
	 * <p>Note: you have to create an instance of the LeapMotion class and set the Listener to your class:</p>
	 *
	 * <listing>
	 * leap = new LeapMotion();
	 * leap.controller.setListener( this );</listing>
	 *
	 * @author logotype
	 *
	 */
	public interface Listener
	{
		/**
		 * Called when the Controller object connects to the Leap Motion software,
		 * or when this Listener object is added to a Controller that is already connected.
		 *
		 * @param controller The Controller object invoking this callback function.
		 *
		 */
		function onConnect( controller:Controller ):void;

		/**
		 * Called when the Controller object disconnects from the Leap Motion software.
		 *
		 * <p>The controller can disconnect when the Leap Motion device is unplugged,
		 * the user shuts the Leap Motion software down, or the Leap software encounters
		 * an unrecoverable error.</p>
		 *
		 * <listing>
		 * public function onDisconnect( controller:Controller ):void {
		 *     trace( "Disconnected" );
		 * }</listing>
		 *
		 * <p>Note: When you launch a Leap-enabled application in a debugger,
		 * the Leap Motion library does not disconnect from the application.
		 * This is to allow you to step through code without losing the connection
		 * because of time outs.</p>
		 *
		 * @param controller The Controller object invoking this callback function.
		 *
		 */
		function onDisconnect( controller:Controller ):void;

		/**
		 * Called when this Listener object is removed from the Controller or
		 * the Controller instance is destroyed.
		 *
		 * <listing>
		 * public function onExit( controller:Controller ):void {
		 *     trace( "Exited" );
		 * }</listing>
		 *
		 * @param controller The Controller object invoking this callback function.
		 *
		 */
		function onExit( controller:Controller ):void;

		/**
		 * Called when this application becomes the foreground application.
		 *
		 * <p>Only the foreground application receives tracking data from the
		 * Leap Motion Controller. This function is only called when the
		 * controller object is in a connected state.</p>
		 *
		 * <listing>
		 * public function onFocusGained( controller:Controller ):void {
		 *     trace( "Focus gained" );
		 * }</listing>
		 *
		 * @param controller The Controller object invoking this callback function.
		 *
		 */
		function onFocusGained( controller:Controller ):void;

		/**
		 * Called when this application loses the foreground focus.
		 *
		 * <p>Only the foreground application receives tracking data from the
		 * Leap Motion Controller. This function is only called when the
		 * controller object is in a connected state.</p>
		 *
		 * <listing>
		 * public function onFocusLost( controller:Controller ):void {
		 *     trace( "Focus lost" );
		 * }</listing>
		 *
		 * @param controller The Controller object invoking this callback function.
		 *
		 */
		function onFocusLost( controller:Controller ):void;

		/**
		 * Called when a new frame of hand and finger tracking data is available.
		 *
		 * <p>Access the new frame data using the <code>controller.frame()</code> function.</p>
		 *
		 * <listing>
		 * public function onFrame( controller:Controller, frame:Frame ):void {
		 *     trace( "New frame" );
		 * }</listing>
		 *
		 * <p>Note, the Controller skips any pending onFrame events while your
		 * onFrame handler executes. If your implementation takes too long to
		 * return, one or more frames can be skipped. The Controller still inserts
		 * the skipped frames into the frame history. You can access recent frames
		 * by setting the history parameter when calling the <code>controller.frame()</code>
		 * function. You can determine if any pending onFrame events were skipped
		 * by comparing the ID of the most recent frame with the ID of the last
		 * received frame.</p>
		 *
		 * @param controller The Controller object invoking this callback function.
		 * @param frame The most recent frame object.
		 *
		 */
		function onFrame( controller:Controller, frame:Frame ):void;

		/**
		 * Called once, when this Listener object is newly added to a Controller.
		 *
		 * <listing>
		 * public function onInit( controller:Controller ):void {
		 *     trace( "Init" );
		 * }</listing>
		 *
		 * @param controller The Controller object invoking this callback function.
		 *
		 */
		function onInit( controller:Controller ):void;
	}
}

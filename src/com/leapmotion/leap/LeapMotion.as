package com.leapmotion.leap
{
	/**
	 * The LeapMotion class is your main interface to the Leap device.
	 *
	 * <p>Create an instance of this LeapMotion class to access frames of tracking
	 * data and configuration information. Frame data can be polled at any time
	 * using the <code>LeapMotion.frame()</code> function. Call <code>frame()</code> or <code>frame(0)</code> to get
	 * the most recent frame. Set the history parameter to a positive integer
	 * to access previous frames. A controller stores up to 60 frames in its
	 * frame history.</p>
	 *
	 * <p>Polling is an appropriate strategy for applications which already have
	 * an intrinsic update loop, such as a game. You can also add an event
	 * listener to LeapMotion.controller to handle events as
	 * they occur. The Leap dispatches events to the listener upon initialization
	 * and exiting, on connection changes, and when a new frame of tracking data
	 * is available.</p>
	 *
	 * <p>The <code>LEAPMOTION_INIT</code> event is dispatched when the Leap is ready for use.
	 * When a connection is established between the controller and the Leap,
	 * the controller dispatches the <code>LEAPMOTION_CONNECTED</code> event. At this point,
	 * your application will start receiving frames of data. The controller
	 * dispatches the <code>LEAPMOTION_FRAME</code> event each time a new frame is available.
	 * If the controller loses its connection with the Leap software or device
	 * for any reason, it dispatches the <code>LEAPMOTION_DISCONNECTED</code> event.
	 * If the listener is removed from the controller or the controller is
	 * destroyed, it dispatches the <code>LEAPMOTION_EXIT</code> event. At that point,
	 * unless the listener is added to another controller again, it will no
	 * longer receive frames of tracking data.</p>
	 *
	 * @author logotype
	 *
	 */
	public class LeapMotion
	{
		public var controller:Controller;

		/**
		 * Constructs a new LeapMotion instance.
		 *  
		 * @param host IP or hostname of the computer running the Leap software.
		 * 
		 */
		public function LeapMotion( host:String = null )
		{
			controller = Controller.getInstance();
			controller.init( host );
		}

		/**
		 * Reports whether this Controller is connected to the Leap device.
		 *
		 * <p>When you first create a Controller object, <code>isConnected()</code> returns false.
		 * After the controller finishes initializing and connects to
		 * the Leap, <code>isConnected()</code> will return true.</p>
		 *
		 * <p>You can either handle the onConnect event using a event listener
		 * or poll the <code>isConnected()</code> function if you need to wait for your
		 * application to be connected to the Leap before performing
		 * some other action.</p>
		 *
		 * @return True, if connected; false otherwise.
		 *
		 */
		public function isConnected():Boolean
		{
			return controller.connection.isConnected;
		}

		/**
		 * Returns a frame of tracking data from the Leap.
		 *
		 * <p>Use the optional history parameter to specify which frame to retrieve.
		 * Call <code>frame()</code> or <code>frame(0)</code> to access the most recent frame;
		 * call <code>frame(1)</code> to access the previous frame, and so on. If you use a history value
		 * greater than the number of stored frames, then the controller returns
		 * an invalid frame.</p>
		 *
		 * @param history The age of the frame to return, counting backwards from
		 * the most recent frame (0) into the past and up to the maximum age (59).
		 *
		 * @return The specified frame; or, if no history parameter is specified,
		 * the newest frame. If a frame is not available at the specified
		 * history position, an invalid Frame is returned.
		 *
		 */
		final public function frame( history:int = 0 ):Frame
		{
			return controller.frame( history );
		}
		
		/**
		 * Enables or disables reporting of a specified gesture type.
		 * 
		 * <p>By default, all gesture types are disabled. When disabled, gestures of
		 * the disabled type are never reported and will not appear in the frame
		 * gesture list.</p>
		 * 
		 * <p>As a performance optimization, only enable recognition for the types
		 * of movements that you use in your application.</p>
		 *  
		 * @param type The type of gesture to enable or disable. Must be a member of the Gesture::Type enumeration.
		 * @param enable True, to enable the specified gesture type; False, to disable.
		 * 
		 */
		public function enableGesture( type:int, enable:Boolean = true ):void
		{
			controller.enableGesture( type, enable );
		}
		
		/**
		 * Reports whether the specified gesture type is enabled.
		 *  
		 * @param type The Gesture.TYPE parameter.
		 * @return True, if the specified type is enabled; false, otherwise.
		 * 
		 */
		public function isGestureEnabled( type:int ):Boolean
		{
			return controller.isGestureEnabled( type );
		}
	}
}

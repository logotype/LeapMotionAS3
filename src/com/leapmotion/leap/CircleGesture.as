package com.leapmotion.leap
{
	/**
	 * The CircleGesture classes represents a circular finger movement.
	 * 
	 * <p>A circle movement is recognized when the tip of a finger draws
	 * a circle within the Leap field of view.</p>
	 * 
	 * <p><strong>Important: To use circle gestures in your application, you must
	 * enable recognition of the circle gesture.</strong><br/>
	 * You can enable recognition with:</p>
	 * 
	 * <code>leap.controller.enableGesture(Gesture.TYPE_CIRCLE);</code>
	 * 
	 * <p>Circle gestures are continuous. The CircleGesture objects for
	 * the gesture have three possible states:</p>
	 * 
	 * <p><code>Gesture.STATE_START</code> – The circle gesture has just started.
	 * The movement has progressed far enough for the recognizer to classify it as a circle.</p>
	 * 
	 * <p><code>Gesture.STATE_UPDATE</code> – The circle gesture is continuing.</p>
	 * 
	 * <p><code>Gesture.STATE_STOP</code> – The circle gesture is finished.</p>
	 *  
	 * @author logotype
	 * @see Gesture
	 * 
	 */
	public class CircleGesture extends Gesture
	{
		/**
		 * The center point of the circle within the Leap frame of reference.<br/>
		 * The center of the circle in mm from the Leap origin. 
		 */
		public var center:Vector3;
		
		/**
		 * The circle gesture type.<br/>
		 * The type value designating a circle gesture. 
		 */
		public var classType:int = Gesture.TYPE_CIRCLE;

		/**
		 * Returns the normal vector for the circle being traced.
		 * 
		 * <p>If you draw the circle clockwise, the normal vector points in the
		 * same general direction as the pointable object drawing the circle.
		 * If you draw the circle counterclockwise, the normal points back
		 * toward the pointable. If the angle between the normal and the
		 * pointable object drawing the circle is less than 90 degrees,
		 * then the circle is clockwise.</p>
		 */
		public var normal:Vector3;
		
		/**
		 * The Finger or Tool performing the circle gesture. 
		 */
		public var pointable:Pointable;
		
		/**
		 * The number of times the finger tip has traversed the circle.
		 * 
		 * <p>Progress is reported as a positive number of the number. For example,
		 * a progress value of .5 indicates that the finger has gone halfway around,
		 * while a value of 3 indicates that the finger has gone around the the
		 * circle three times.</p>
		 * 
		 * <p>Progress starts where the circle gesture began. Since it the circle must
		 * be partially formed before the Leap can recognize it, progress will be
		 * greater than zero when a circle gesture first appears in the frame.</p>
		 */
		public var progress:Number;
		
		/**
		 * The circle radius in mm. 
		 */
		public var radius:Number;
		
		/**
		 * Constructs a new CircleGesture object.
		 * 
		 * <p>An uninitialized CircleGesture object is considered invalid.
		 * Get valid instances of the CircleGesture class from a Frame object.</p> 
		 * 
		 */
		public function CircleGesture()
		{
			pointable = Pointable.invalid();
		}
	}
}
package com.leapmotion.leap
{
	/**
	 * The CircleGesture classes represents a circular finger movement.
	 * 
	 * A circle movement is recognized when the tip of a finger draws
	 * a circle within the Leap field of view.
	 * 
	 * Important: To use circle gestures in your application, you must
	 * enable recognition of the circle gesture. You can enable
	 * recognition with:
	 * 
	 * leap.controller.enableGesture(Gesture.TYPE_CIRCLE);
	 * 
	 * Circle gestures are continuous. The CircleGesture objects for
	 * the gesture have three possible states:
	 * 
	 * State.STATE_START – The circle gesture has just started.
	 * The movement has progressed far enough for the recognizer to classify it as a circle.
	 * 
	 * State.STATE_UPDATE – The circle gesture is continuing.
	 * 
	 * State.STATE_STOP – The circle gesture is finished.
	 *  
	 * @author logotype
	 * @see Gesture
	 * 
	 */
	public class CircleGesture extends Gesture
	{
		/**
		 * The center point of the circle within the Leap frame of reference.
		 * The center of the circle in mm from the Leap origin. 
		 */
		public var center:Vector3;
		
		/**
		 * The circle gesture type.
		 * The type value designating a circle gesture. 
		 */
		public var classType:int = Gesture.TYPE_CIRCLE;

		/**
		 * Returns the normal vector for the circle being traced.
		 * 
		 * If you draw the circle clockwise, the normal vector points in the
		 * same general direction as the pointable object drawing the circle.
		 * If you draw the circle counterclockwise, the normal points back
		 * toward the pointable. If the angle between the normal and the
		 * pointable object drawing the circle is less than 90 degrees,
		 * then the circle is clockwise.
		 * 
		 * var clockwiseness:String;
		 * if (circle.pointable.direction.angleTo(circle.normal) <= Math.PI/4)
		 * { clockwiseness = "clockwise"; } else { clockwiseness = "counterclockwise"; } 
		 */
		public var normal:Vector3;
		
		/**
		 * The Finger or Tool performing the circle gesture. 
		 */
		public var pointable:Pointable;
		
		/**
		 * The number of times the finger tip has traversed the circle.
		 * 
		 * Progress is reported as a positive number of the number. For example,
		 * a progress value of .5 indicates that the finger has gone halfway around,
		 * while a value of 3 indicates that the finger has gone around the the
		 * circle three times.
		 * 
		 * Progress starts where the circle gesture began. Since it the circle must
		 * be partially formed before the Leap can recognize it, progress will be
		 * greater than zero when a circle gesture first appears in the frame.
		 */
		public var progress:Number;
		
		/**
		 * The circle radius in mm. 
		 */
		public var radius:Number;
		
		/**
		 * Constructs a new CircleGesture object.
		 * 
		 * An uninitialized CircleGesture object is considered invalid.
		 * Get valid instances of the CircleGesture class from a Frame object. 
		 * 
		 */
		public function CircleGesture()
		{
		}
	}
}
package com.leapmotion.leap
{
	/**
	 * The Gesture class represents a recognized movement by the user.
	 *
	 * The Leap watches the activity within its field of view for certain movement
	 * patterns typical of a user gesture or command. For example, a movement from
	 * side to side with the hand can indicate a swipe gesture, while a finger poking
	 * forward can indicate a screen tap gesture.
	 *
	 * When the Leap recognizes a gesture, it assigns an ID and adds a Gesture object
	 * to the frame gesture list. For continuous gestures, which occur over many frames,
	 * the Leap updates the gesture by adding a Gesture object having the same ID and
	 * updated properties in each subsequent frame.
	 *
	 * Important: Recognition for each type of gesture must be enabled using the
	 * Controller.enableGesture() function; otherwise no gestures are recognized
	 * or reported.
	 *
	 * Subclasses of Gesture define the properties for the specific movement
	 * patterns recognized by the Leap.
	 *
	 * The Gesture subclasses for include:
	 * CircleGesture – A circular movement by a finger.
	 * SwipeGesture – A straight line movement by the hand with fingers extended.
	 * ScreenTapGesture – A forward tapping movement by a finger.
	 * KeyTapGesture – A downward tapping movement by a finger.
	 *
	 * Circle and swipe gestures are continuous and these objects can have a state
	 * of start, update, and stop.
	 *
	 * The screen tap gesture is a discrete gesture. The Leap only creates a single
	 * ScreenTapGesture object appears for each tap and it always has a stop state.
	 *
	 * Get valid Gesture instances from a Frame object. You can get a list of gestures
	 * with the Frame.gestures() method. You can get a list of gestures since a specified
	 * frame with the Frame.gesturesSince() methods. You can also use the Frame.gesture()
	 * method to find a gesture in the current frame using an ID value obtained
	 * in a previous frame.
	 *
	 * Gesture objects can be invalid. For example, when you get a gesture by ID using
	 * Frame.gesture(), and there is no gesture with that ID in the current frame, then
	 * gesture() returns an Invalid Gesture object (rather than a null value).
	 * Always check object validity in situations where a gesture might be invalid.
	 *
	 * @author logotype
	 * @see CircleGesture
	 * @see SwipeGesture
	 * @see ScreenTapGesture
	 * @see KeyTapGesture
	 *
	 */
	public class Gesture
	{
		/**
		 * An invalid state. 
		 */
		static public const STATE_INVALID:int = 0;
		
		/**
		 * The gesture is starting.
		 * Just enough has happened to recognize it. 
		 */
		static public const STATE_START:int = 1;

		/**
		 * The gesture is in progress.
		 * (Note: not all gestures have updates). 
		 */
		static public const STATE_UPDATE:int = 2;
		
		/**
		 * The gesture has completed or stopped. 
		 */
		static public const STATE_STOP:int = 3;

		/**
		 * An invalid type. 
		 */
		static public const TYPE_INVALID:int = 4;
		
		/**
		 * A straight line movement by the hand with fingers extended. 
		 */
		static public const TYPE_SWIPE:int = 5;
		
		/**
		 * A circular movement by a finger. 
		 */
		static public const TYPE_CIRCLE:int = 6;
		
		/**
		 * A forward tapping movement by a finger. 
		 */
		static public const TYPE_SCREEN_TAP:int = 7;
		
		/**
		 * A downward tapping movement by a finger. 
		 */
		static public const TYPE_KEY_TAP:int = 8;

		/**
		 * The elapsed duration of the recognized movement up to the frame
		 * containing this Gesture object, in microseconds.
		 * 
		 * The duration reported for the first Gesture in the sequence (with
		 * the STATE_START state) will typically be a small positive number
		 * since the movement must progress far enough for the Leap to recognize
		 * it as an intentional gesture. 
		 */
		public var duration:int;

		/**
		 * The elapsed duration in seconds. 
		 */
		public var durationSeconds:Number;
		
		/**
		 * The Frame containing this Gesture instance. 
		 */		
		public var frame:Frame;
		
		/**
		 * The list of hands associated with this Gesture, if any.
		 * 
		 * If no hands are related to this gesture, the list is empty. 
		 */
		public var hands:Vector.<Hand> = new Vector.<Hand>();
		
		/**
		 * The gesture ID.
		 * 
		 * All Gesture objects belonging to the same recognized movement share
		 * the same ID value. Use the ID value with the Frame.gesture() method
		 * to find updates related to this Gesture object in subsequent frames. 
		 */
		public var id:int;

		/**
		 * The list of fingers and tools associated with this Gesture, if any.
		 * 
		 * If no Pointable objects are related to this gesture, the list is empty. 
		 */
		public var pointables:Vector.<Pointable> = new Vector.<Pointable>();

		/**
		 * The gesture state.
		 * 
		 * Recognized movements occur over time and have a beginning, a middle,
		 * and an end. The 'state()' attribute reports where in that sequence
		 * this Gesture object falls. 
		 */
		public var state:int;
		
		/**
		 * The gesture type. 
		 */
		public var type:int;

		/**
		 * Constructs a new Gesture object.
		 *
		 * An uninitialized Gesture object is considered invalid. Get valid
		 * instances of the Gesture class, which will be one of the Gesture
		 * subclasses, from a Frame object.
		 *
		 */
		public function Gesture()
		{
		}

		/**
		 * Compare Gesture object equality/inequality.
		 *
		 * Two Gestures are equal if they represent the same snapshot of
		 * the same recognized movement.
		 *
		 * @param other The Gesture to compare with.
		 * @return True; if equal, False otherwise.
		 *
		 */
		public function isEqualTo( other:Gesture ):Boolean
		{
			return (id == other.id) ? true : false;
		}

		/**
		 * Reports whether this Gesture instance represents a valid Gesture.
		 *
		 * An invalid Gesture object does not represent a snapshot of a recognized
		 * movement. Invalid Gesture objects are returned when a valid object
		 * cannot be provided. For example, when you get an gesture by ID using
		 * Frame.gesture(), and there is no gesture with that ID in the current
		 * frame, then gesture() returns an Invalid Gesture object (rather than
		 * a null value). Always check object validity in situations where an
		 * gesture might be invalid.
		 *
		 * @return True, if this is a valid Gesture instance; false, otherwise.
		 *
		 */
		public function isValid():Boolean
		{
			var returnValue:Boolean = true;

			if( isNaN( durationSeconds ) )
				returnValue = false;

			return returnValue;
		}

		/**
		 * Returns an invalid Gesture object.
		 *
		 * You can use the instance returned by this function in comparisons
		 * testing whether a given Gesture instance is valid or invalid.
		 * (You can also use the Gesture.isValid() function.)
		 *
		 * @return The invalid Gesture instance.
		 *
		 */
		static public function invalid():Gesture
		{
			return new Gesture();
		}

		/**
		 * A string containing a brief, human-readable description of this Gesture.
		 *
		 */
		public function toString():String
		{
			return "[Gesture id:" + id + " duration:" + duration + " type:" + type + "]";
		}
	}
}

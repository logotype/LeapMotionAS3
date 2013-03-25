package com.leapmotion.leap
{
	/**
	 * The KeyTapGesture class represents a tapping gesture by a finger or tool.
	 * 
	 * <p>A key tap gesture is recognized when the tip of a finger rotates down
	 * toward the palm and then springs back to approximately the original
	 * postion, as if tapping. The tapping finger must pause briefly before
	 * beginning the tap.</p>
	 * 
	 * <p><strong>Important: To use key tap gestures in your application, you must enable
	 * recognition of the key tap gesture.</strong><br/>You can enable recognition with:</p>
	 * 
	 * <code>leap.controller.enableGesture(Gesture.TYPE_KEY_TAP);</code>
	 * 
	 * <p>Key tap gestures are discrete. The KeyTapGesture object representing a
	 * tap always has the state, <code>STATE_STOP</code>. Only one KeyTapGesture object
	 * is created for each key tap gesture recognized.</p>
	 *  
	 * @author logotype
	 * 
	 */
	public class KeyTapGesture extends Gesture
	{
		/**
		 * The type value designating a key tap gesture. 
		 */
		public var classType:int = Gesture.TYPE_KEY_TAP;

		/**
		 * The current direction of finger tip motion.
		 * 
		 * <p>At the start of the key tap gesture, the direction points in the
		 * direction of the tap. At the end of the key tap gesture, the direction
		 * will either point toward the original finger tip position or it will
		 * be a zero-vector, which indicates that finger movement stopped before
		 * returning to the starting point.</p>
		 */
		public var direction:Vector3;

		/**
		 * The finger performing the key tap gesture. 
		 */		
		public var pointable:Pointable;
		
		/**
		 * The position where the key tap is registered. 
		 */
		public var position:Vector3;
		
		/**
		 * The progess value is always 1.0 for a key tap gesture. 
		 */
		public var progress:Number = 1;
		
		/**
		 * Constructs a new KeyTapGesture object.
		 * 
		 * <p>An uninitialized KeyTapGesture object is considered invalid.
		 * Get valid instances of the KeyTapGesture class from a Frame object.</p> 
		 * 
		 */
		public function KeyTapGesture()
		{
		}
	}
}
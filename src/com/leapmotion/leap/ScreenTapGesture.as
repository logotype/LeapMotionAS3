package com.leapmotion.leap
{
	/**
	 * The ScreenTapGesture class represents a tapping gesture by a finger or tool.
	 * 
	 * <p>A screen tap gesture is recognized when the tip of a finger pokes forward
	 * and then springs back to approximately the original postion, as if tapping
	 * a vertical screen. The tapping finger must pause briefly before beginning the tap.</p>
	 * 
	 * <strong>Important: To use screen tap gestures in your application, you must enable
	 * recognition of the screen tap gesture.</strong><br/> You can enable recognition with:
	 * 
	 * <code>leap.controller.enableGesture(Gesture.TYPE_SCREEN_TAP);</code>
	 * 
	 * <p>ScreenTap gestures are discrete. The ScreenTapGesture object representing a
	 * tap always has the state, <code>STATE_STOP</code>. Only one ScreenTapGesture object is
	 * created for each screen tap gesture recognized.</p>
	 *  
	 * @author logotype
	 * 
	 */
	public class ScreenTapGesture extends Gesture
	{
		/**
		 * The type value designating a screen tap gesture. 
		 */
		public var classType:int = Gesture.TYPE_SCREEN_TAP;
		
		/**
		 * The direction of finger tip motion. 
		 */
		public var direction:Vector3;
		
		/**
		 * The finger performing the screen tap gesture. 
		 */
		public var pointable:Pointable;
		
		/**
		 * The position where the screen tap is registered. 
		 */
		public var position:Vector3;
		
		/**
		 * The progess value is always 1.0 for a screen tap gesture. 
		 */
		public var progress:Number = 1;
		
		/**
		 * Constructs a new ScreenTapGesture object.
		 * 
		 * <p>An uninitialized ScreenTapGesture object is considered invalid.
		 * Get valid instances of the ScreenTapGesture class from a Frame object.</p> 
		 * 
		 */
		public function ScreenTapGesture()
		{
		}
	}
}
package com.leapmotion.leap
{
	/**
	 * The Frame class represents a set of hand and finger tracking
	 * data detected in a single frame.
	 * 
	 * The Leap detects hands, fingers and tools within the tracking area,
	 * reporting their positions, orientations and motions in frames at
	 * the Leap frame rate.
	 * 
	 * Access Frame objects through a listener of a Leap Controller.
	 * Add a listener to receive events when a new Frame is available.
	 *  
	 * @author logotype
	 * 
	 */
	public class Frame
	{
		/**
		 * The Finger object with the specified ID in this frame. 
		 * @see Finger 
		 */
		public var finger:Finger;

		/**
		 * The list of Finger objects detected in this frame, given in arbitrary order. 
		 */
		public var fingers:Vector.<Pointable> = new Vector.<Pointable>();

		/**
		 * The Hand object with the specified ID in this frame.  
		 */
		public var hand:Hand;

		/**
		 * The list of Hand objects detected in this frame, given in arbitrary order.  
		 */
		public var hands:Vector.<Hand> = new Vector.<Hand>();

		/**
		 * A unique ID for this Frame.  
		 */
		public var id:int;

		/**
		 * The frame capture time in microseconds elapsed since the Leap started.  
		 */
		public var timestamp:Number;
		
		/**
		 * The Tool object with the specified ID in this frame.  
		 */
		public var tool:Tool;

		/**
		 * The list of Tool objects detected in this frame, given in arbitrary order. 
		 */
		public var tools:Vector.<Pointable> = new Vector.<Pointable>();

		/**
		 * Rotation since last Frame.
		 */
		public var r:Vector.<Vector3> = new Vector.<Vector3>();
		
		/**
		 * Scale factor since last Frame. 
		 */		
		public var s:Number;
		
		/**
		 * Translation since last Frame. 
		 */		
		public var t:Vector3;
				
		public function Frame()
		{
		}
	}
}
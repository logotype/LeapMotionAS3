package com.leapmotion.leap
{
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
		
		public var r:Vector.<Vector3> = new Vector.<Vector3>();
		public var s:Number;
		public var t:Vector3;
		
		public var tools:Vector.<Pointable> = new Vector.<Pointable>();
		
		public function Frame()
		{
		}
	}
}
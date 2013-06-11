package com.leapmotion.leap
{
	/**
	 * The InteractionBox class represents a box-shaped region completely within
	 * the field of view of the Leap Motion controller.
	 * 
	 * <p>The interaction box is an axis-aligned rectangular prism and provides
	 * normalized coordinates for hands, fingers, and tools within this box.
	 * The InteractionBox class can make it easier to map positions in the
	 * Leap Motion coordinate system to 2D or 3D coordinate systems used
	 * for application drawing.</p>
 	 * 
	 * <p>The InteractionBox region is defined by a center and dimensions along the x, y, and z axes.</p>
	 *  
	 * @author logotype
	 * 
	 */
	public class InteractionBox
	{
		public var center:Vector3;
		
		public function InteractionBox()
		{
		}
		
		public function denormalizePoint( normalizedPosition:Vector3 ) :Vector3
		{
			return Vector3.invalid();
		}
		
		public function normalizePoint( position:Vector3, clamp:Boolean = true ) :Vector3
		{
			return Vector3.invalid();
		}
		
		public function depth() :Number
		{
			return 0.0;
		}
		
		public function height() :Number
		{
			return 0.0;
		}
		
		public function width() :Number
		{
			return 0.0;
		}
		
		public function isValid() :Boolean
		{
			return false;
		}
		
		/**
		 * Writes a brief, human readable description of the InteractionBox object.
		 * @return
		 *
		 */
		public function toString():String
		{
			return "[InteractionBox depth:" + depth() + " height:" + height() + " width:" + width() + "]";
		}
	}
}
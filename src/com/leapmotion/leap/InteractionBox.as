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
		/**
		 * The center of the InteractionBox in device coordinates (millimeters).
		 * <p>This point is equidistant from all sides of the box.</p> 
		 */
		public var center:Vector3;
		
		/**
		 * The depth of the InteractionBox in millimeters, measured along the z-axis. 
		 * 
		 */
		public var depth:Number;
		
		/**
		 * The height of the InteractionBox in millimeters, measured along the y-axis. 
		 * 
		 */
		public var height:Number;
		
		/**
		 * The width of the InteractionBox in millimeters, measured along the x-axis. 
		 * 
		 */
		public var width:Number;
		
		/**
		 * Constructs a InteractionBox object. 
		 * 
		 */
		public function InteractionBox()
		{
		}
		
		/**
		 * Converts a position defined by normalized InteractionBox coordinates
		 * into device coordinates in millimeters.
		 * 
		 * This function performs the inverse of normalizePoint().
		 *  
		 * @param normalizedPosition The input position in InteractionBox coordinates.
		 * @return The corresponding denormalized position in device coordinates.
		 * 
		 */
		public function denormalizePoint( normalizedPosition:Vector3 ):Vector3
		{
			var vec:Vector3 = Vector3.invalid();
			
		    vec.x = ( normalizedPosition.x - 0.5 ) * width + center.x;
		    vec.y = ( normalizedPosition.y - 0.5 ) * height + center.y;
		    vec.z = ( normalizedPosition.z - 0.5 ) * depth + center.z;

			return vec;
		}
		
		/**
		 * Normalizes the coordinates of a point using the interaction box.
		 * 
		 * <p>Coordinates from the Leap Motion frame of reference (millimeters) are
		 * converted to a range of [0..1] such that the minimum value of the
		 * InteractionBox maps to 0 and the maximum value of the InteractionBox maps to 1.</p>
		 *  
		 * @param position The input position in device coordinates.
		 * @param clamp Whether or not to limit the output value to the range [0,1]
		 * when the input position is outside the InteractionBox. Defaults to true.
		 * @return The normalized position.
		 * 
		 */
		public function normalizePoint( position:Vector3, clamp:Boolean = true ):Vector3
		{
			var vec:Vector3 = Vector3.invalid();
			
		    vec.x = ( ( position.x - center.x ) / width ) + 0.5;
		    vec.y = ( ( position.y - center.y ) / height ) + 0.5;
		    vec.z = ( ( position.z - center.z ) / depth ) + 0.5;

			if( clamp )
			{
				vec.x = Math.min( Math.max( vec.x, 0 ), 1 );
				vec.y = Math.min( Math.max( vec.y, 0 ), 1 );
				vec.z = Math.min( Math.max( vec.z, 0 ), 1 );
			}
			
			return vec;
		}
		
		/**
		 * Reports whether this is a valid InteractionBox object. 
		 * @return True, if this InteractionBox object contains valid data.
		 * 
		 */
		public function isValid():Boolean
		{
			// TODO: Better validity checking
			return center.isValid();
		}
		
		/**
		 * Compare InteractionBox object equality/inequality.
		 * 
		 * <p>Two InteractionBox objects are equal if and only if both InteractionBox
		 * objects represent the exact same InteractionBox and both InteractionBoxes are valid.</p>
		 *  
		 * @param other
		 * @return 
		 * 
		 */
		public function isEqualTo( other:InteractionBox ):Boolean
		{
			if( !this.isValid() || !other.isValid() )
				return false;

			if( !center.isEqualTo( other.center ) )
				return false;
			
			if( depth != other.depth )
				return false;
			
			if( height != other.height )
				return false;
			
			if( width != other.width )
				return false;
			
			return true;
		}
		
		/**
		 * Returns an invalid InteractionBox object.
		 *
		 * <p>You can use the instance returned by this function in comparisons
		 * testing whether a given InteractionBox instance is valid or invalid.
		 * (You can also use the <code>InteractionBox.isValid()</code> function.)</p>
		 *
		 * @return The invalid InteractionBox instance.
		 *
		 */
		static public function invalid():InteractionBox
		{
			return new InteractionBox();
		}

		/**
		 * Writes a brief, human readable description of the InteractionBox object.
		 * @return A description of the InteractionBox as a string.
		 *
		 */
		public function toString():String
		{
			return "[InteractionBox depth:" + depth + " height:" + height + " width:" + width + "]";
		}
	}
}
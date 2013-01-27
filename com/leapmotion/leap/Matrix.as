package com.leapmotion.leap
{
	/**
	 * The Matrix struct represents a transformation matrix.
	 * 
	 * To use this struct to transform a Vector, construct a matrix containing the
	 * desired transformation and then use the Matrix::transformPoint() or
	 * Matrix::transformDirection() functions to apply the transform.
	 * 
	 * Transforms can be combined by multiplying two or more transform matrices
	 * using the multiply() function.
	 * 
	 *  
	 * @author logotype
	 * 
	 */
	public class Matrix
	{
		/**
		 * The translation factors for all three axes.  
		 */
		private var origin:Vector3 = new Vector3( 0, 0, 0 );

		/**
		 * The rotation and scale factors for the x-axis.  
		 */
		private var xBasis:Vector3 = new Vector3( 0, 0, 0 );
		
		/**
		 * The rotation and scale factors for the y-axis.  
		 */
		private var yBasis:Vector3 = new Vector3( 0, 0, 0 );
		
		/**
		 * The rotation and scale factors for the z-axis.  
		 */
		private var zBasis:Vector3 = new Vector3( 0, 0, 0 );

		public function Matrix( x:Vector3 = null, y:Vector3 = null, z:Vector3 = null, origin:Vector3 = null )
		{
			if ( x && y && z )
			{
				this.xBasis = x;
				this.yBasis = y;
				this.zBasis = z;
			}
			if ( origin )
				this.origin = origin;
		}

		/**
		 * Sets this transformation matrix to represent a rotation around the specified vector.  
		 * @param _axis
		 * @param angleRadians
		 * 
		 */
		public function setRotation( _axis:Vector3, angleRadians:Number ):void
		{
			var axis:Vector3 = _axis.normalized();
			var s:Number = Math.sin( angleRadians );
			var c:Number = Math.cos( angleRadians );
			var C:Number = ( 1 - c );

			xBasis = new Vector3( axis.x * axis.x * C + c, axis.x * axis.y * C - axis.z * s, axis.x * axis.z * C + axis.y * s );
			yBasis = new Vector3( axis.y * axis.x * C + axis.z * s, axis.y * axis.y * C + c, axis.y * axis.z * C - axis.x * s );
			zBasis = new Vector3( axis.z * axis.x * C - axis.y * s, axis.z * axis.y * C + axis.x * s, axis.z * axis.z * C + c );
		}

		/**
		 * Transforms a vector with this matrix by transforming its rotation, scale, and translation.  
		 * @param inVector
		 * @return 
		 * 
		 */
		public function transformPoint( inVector:Vector3 ):Vector3
		{
			return new Vector3( xBasis.multiply( inVector.x ).x, yBasis.multiply( inVector.y ).y, zBasis.multiply( inVector.z ).z + origin.z );
		}

		/**
		 * Transforms a vector with this matrix by transforming its rotation and scale only. 
		 * @param inVector
		 * @return 
		 * 
		 */
		public function transformDirection( inVector:Vector3 ):Vector3
		{
			return new Vector3( xBasis.multiply( inVector.x ).x, yBasis.multiply( inVector.y ).y, zBasis.multiply( inVector.z ).z );
		}

		/**
		 * Performs a matrix inverse if the matrix consists entirely of rigid transformations (translations and rotations).  
		 * @return 
		 * 
		 */
		public function rigidInverse():Matrix
		{
			var rotInverse:Matrix = new Matrix( new Vector3( xBasis.x, yBasis.x, zBasis.x ), new Vector3( xBasis.y, yBasis.y, zBasis.y ), new Vector3( xBasis.z, yBasis.z, zBasis.z ));
			rotInverse.origin = rotInverse.transformDirection( origin.opposite());
			return rotInverse;
		}

		/**
		 * Multiply transform matrices.  
		 * @param other
		 * @return 
		 * 
		 */
		public function multiply( other:Matrix ):Matrix
		{
			return new Matrix( transformDirection( other.xBasis ), transformDirection( other.yBasis ), transformDirection( other.zBasis ), transformPoint( other.origin ));
		}

		/**
		 * Write the matrix to a string in a human readable format.  
		 * @return 
		 * 
		 */
		public function toString():String
		{
			return "[Matrix xBasis:" + xBasis.toString() + " yBasis:" + yBasis.toString() + " zBasis:" + zBasis.toString() + " origin:" + origin.toString() + "]";
		}
	}
}

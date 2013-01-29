package com.leapmotion.leap
{

	/**
	 * The Matrix struct represents a transformation matrix.
	 *
	 * To use this struct to transform a Vector, construct a matrix containing the
	 * desired transformation and then use the Matrix.transformPoint() or
	 * Matrix.transformDirection() functions to apply the transform.
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
				xBasis = x;
				yBasis = y;
				zBasis = z;
			}
			if ( origin )
				origin = origin;
		}

		/**
		 * Sets this transformation matrix to represent a rotation around the specified vector.
		 * @param _axis A Vector specifying the axis of rotation.
		 * @param angleRadians The amount of rotation in radians.
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
		 * @param inVector The Vector to transform.
		 * @return A new Vector representing the transformed original.
		 *
		 */
		public function transformPoint( inVector:Vector3 ):Vector3
		{
			return new Vector3( xBasis.multiply( inVector.x ).x, yBasis.multiply( inVector.y ).y, zBasis.multiply( inVector.z ).z + origin.z );
		}

		/**
		 * Transforms a vector with this matrix by transforming its rotation and scale only.
		 * @param inVector The Vector to transform.
		 * @return A new Vector representing the transformed original.
		 *
		 */
		public function transformDirection( inVector:Vector3 ):Vector3
		{
			return new Vector3( xBasis.multiply( inVector.x ).x, yBasis.multiply( inVector.y ).y, zBasis.multiply( inVector.z ).z );
		}

		/**
		 * Performs a matrix inverse if the matrix consists entirely of rigid transformations (translations and rotations).
		 * @return The rigid inverse of the matrix.
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
		 * @param other A Matrix to multiply on the right hand side.
		 * @return A new Matrix representing the transformation equivalent to applying the other transformation followed by this transformation.
		 *
		 */
		public function multiply( other:Matrix ):Matrix
		{
			return new Matrix( transformDirection( other.xBasis ), transformDirection( other.yBasis ), transformDirection( other.zBasis ), transformPoint( other.origin ));
		}

		/**
		 * Multiply transform matrices and assign the product.
		 * @param other A Matrix to multiply on the right hand side.
		 * @return This Matrix representing the transformation equivalent to applying the other transformation followed by this transformation.
		 *
		 */
		public function multiplyAssign( other:Matrix ):Matrix
		{
			xBasis = transformDirection( other.xBasis );
			yBasis = transformDirection( other.yBasis );
			zBasis = transformDirection( other.zBasis );
			origin = transformPoint( other.origin );
			return this;
		}

		/**
		 * Compare Matrix equality/inequality component-wise. 
		 * @param other The Matrix to compare with.
		 * @return True; if equal, False otherwise.
		 * 
		 */
		public function isEqualTo( other:Matrix ):Boolean
		{
			var returnValue:Boolean = true;

			if ( !xBasis.isEqualTo( other.xBasis ))
				returnValue = false;

			if ( !yBasis.isEqualTo( other.yBasis ))
				returnValue = false;

			if ( !zBasis.isEqualTo( other.zBasis ))
				returnValue = false;

			if ( !origin.isEqualTo( other.origin ))
				returnValue = false;

			return returnValue;
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

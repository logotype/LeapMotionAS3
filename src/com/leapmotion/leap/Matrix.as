package com.leapmotion.leap
{
	/**
	 * The Matrix class represents a transformation matrix.
	 *
	 * <p>To use this class to transform a Vector, construct a matrix containing the
	 * desired transformation and then use the <code>Matrix.transformPoint()</code> or
	 * <code>Matrix.transformDirection()</code> functions to apply the transform.</p>
	 *
	 * <p>Transforms can be combined by multiplying two or more transform matrices
	 * using the <code>multiply()</code> function.</p>
	 *
	 *
	 * @author logotype
	 *
	 */
	final public class Matrix
	{
		/**
		 * The translation factors for all three axes.
		 */
		public var origin:Vector3 = new Vector3( 0, 0, 0 );

		/**
		 * The rotation and scale factors for the x-axis.
		 */
		public var xBasis:Vector3 = new Vector3( 0, 0, 0 );

		/**
		 * The rotation and scale factors for the y-axis.
		 */
		public var yBasis:Vector3 = new Vector3( 0, 0, 0 );

		/**
		 * The rotation and scale factors for the z-axis.
		 */
		public var zBasis:Vector3 = new Vector3( 0, 0, 0 );

		/**
		 * Constructs a transformation matrix from the specified basis vectors.
		 * @param x A Vector specifying rotation and scale factors for the x-axis.
		 * @param y A Vector specifying rotation and scale factors for the y-axis.
		 * @param z A Vector specifying rotation and scale factors for the z-axis.
		 * @param _origin A Vector specifying translation factors on all three axes.
		 *
		 */
		public function Matrix( x:Vector3, y:Vector3, z:Vector3, _origin:Vector3 = null )
		{
			xBasis = x;
			yBasis = y;
			zBasis = z;

			if( _origin )
				origin = _origin;
		}

		/**
		 * Sets this transformation matrix to represent a rotation around the specified vector.
		 * This function erases any previous rotation and scale transforms applied to this matrix,
		 * but does not affect translation.
		 *
	 * @param _axis A Vector specifying the axis of rotation.
		  * @param angleRadians The amount of rotation in radians.
		 *
		 */
		final public function setRotation( _axis:Vector3, angleRadians:Number ):void
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
		 * Translation is applied after rotation and scale.
		 *
		 * @param inVector The Vector to transform.
		 * @return A new Vector representing the transformed original.
		 *
		 */
		final public function transformPoint( inVector:Vector3 ):Vector3
		{
			return new Vector3( xBasis.multiply( inVector.x ).x, yBasis.multiply( inVector.y ).y, zBasis.multiply( inVector.z ).z + origin.z );
		}

		/**
		 * Transforms a vector with this matrix by transforming its rotation and scale only.
		 * @param inVector The Vector to transform.
		 * @return A new Vector representing the transformed original.
		 *
		 */
		final public function transformDirection( inVector:Vector3 ):Vector3
		{
			var x:Vector3 = xBasis.multiply( inVector.x );
			var y:Vector3 = yBasis.multiply( inVector.y );
			var z:Vector3 = zBasis.multiply( inVector.z );
			return x.plus( y ).plus( z );
		}

		/**
		 * Performs a matrix inverse if the matrix consists entirely of rigid transformations (translations and rotations).
		 * @return The rigid inverse of the matrix.
		 *
		 */
		final public function rigidInverse():Matrix
		{
			var rotInverse:Matrix = new Matrix( new Vector3( xBasis.x, yBasis.x, zBasis.x ), new Vector3( xBasis.y, yBasis.y, zBasis.y ), new Vector3( xBasis.z, yBasis.z, zBasis.z ) );
			if( origin )
				rotInverse.origin = rotInverse.transformDirection( origin.opposite() );
			return rotInverse;
		}

		/**
		 * Multiply transform matrices.
		 * @param other A Matrix to multiply on the right hand side.
		 * @return A new Matrix representing the transformation equivalent to applying the other transformation followed by this transformation.
		 *
		 */
		final public function multiply( other:Matrix ):Matrix
		{
			var x:Vector3 = transformDirection( other.xBasis );
			var y:Vector3 = transformDirection( other.yBasis );
			var z:Vector3 = transformDirection( other.zBasis );
			var o:Vector3 = origin;

			if( origin && other.origin )
				o = transformPoint( other.origin );

			return new Matrix( x, y, z, o );
		}

		/**
		 * Multiply transform matrices and assign the product.
		 * @param other A Matrix to multiply on the right hand side.
		 * @return This Matrix representing the transformation equivalent to applying the other transformation followed by this transformation.
		 *
		 */
		final public function multiplyAssign( other:Matrix ):Matrix
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
		final public function isEqualTo( other:Matrix ):Boolean
		{
			if( !xBasis.isEqualTo( other.xBasis ) )
				return false;

			if( !yBasis.isEqualTo( other.yBasis ) )
				return false;

			if( !zBasis.isEqualTo( other.zBasis ) )
				return false;

			if( !origin.isEqualTo( other.origin ) )
				return false;

			return true;
		}

		/**
		 * Returns the identity matrix specifying no translation, rotation, and scale.
		 * @return The identity matrix.
		 *
		 */
		static public function identity():Matrix
		{
			var xBasis:Vector3 = new Vector3( 1, 0, 0 );
			var yBasis:Vector3 = new Vector3( 0, 1, 0 );
			var zBasis:Vector3 = new Vector3( 0, 0, 1 );

			return new Matrix( xBasis, yBasis, zBasis );
		}

		/**
		 * Write the matrix to a string in a human readable format.
		 * @return
		 *
		 */
		final public function toString():String
		{
			return "[Matrix xBasis:" + xBasis.toString() + " yBasis:" + yBasis.toString() + " zBasis:" + zBasis.toString() + " origin:" + origin.toString() + "]";
		}
	}
}

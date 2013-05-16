package com.leapmotion.leap.util
{
	import com.leapmotion.leap.Matrix;
	import com.leapmotion.leap.Vector3;

	/**
	 * LeapUtil is a collection of static utility functions.
	 *
	 */
	public class LeapUtil
	{
		/** The constant pi as a single precision floating point number. */
		static public const PI:Number = 3.1415926536;

		/**
		 * The constant ratio to convert an angle measure from degrees to radians.
		 * Multiply a value in degrees by this constant to convert to radians.
		 */
		static public const DEG_TO_RAD:Number = 0.0174532925;

		/**
		 * The constant ratio to convert an angle measure from radians to degrees.
		 * Multiply a value in radians by this constant to convert to degrees.
		 */
		static public const RAD_TO_DEG:Number = 57.295779513;

		/**
		 * Pi &#42; 2.
		 */
		static public const TWO_PI:Number = Math.PI + Math.PI;

		/**
		 * Pi &#42; 0.5.
		 */
		static public const HALF_PI:Number = Math.PI * 0.5;

		/**
		 * Represents the smallest positive single value greater than zero.
		 */
		static public const EPSILON:Number = 0.00001;

		public function LeapUtil()
		{
		}

		/**
		 * Convert an angle measure from radians to degrees.
		 *
		 * @param radians
		 * @return The value, in degrees.
		 *
		 */
		static public function toDegrees( radians:Number ):Number
		{
			return radians * 180 / Math.PI;
		}

		/**
		 * Determines if a value is equal to or less than 0.00001.
		 *
		 * @return True, if equal to or less than 0.00001; false otherwise.
		 */
		static public function isNearZero( value:Number ):Boolean
		{
			return Math.abs( value ) <= EPSILON;
		}

		/**
		 * Determines if all Vector3 components is equal to or less than 0.00001.
		 *
		 * @return True, if equal to or less than 0.00001; false otherwise.
		 */
		static public function vectorIsNearZero( inVector:Vector3 ):Boolean
		{
			return isNearZero( inVector.x ) && isNearZero( inVector.y ) && isNearZero( inVector.z );
		}

		/**
		 * Create a new matrix with just the rotation block from the argument matrix
		 */
		static public function extractRotation( mtxTransform:Matrix ):Matrix
		{
			return new Matrix( mtxTransform.xBasis, mtxTransform.yBasis, mtxTransform.zBasis );
		}

		/**
		 * Returns a matrix representing the inverse rotation by simple transposition of the rotation block.
		 */
		static public function rotationInverse( mtxRot:Matrix ):Matrix
		{
			return new Matrix( new Vector3( mtxRot.xBasis.x, mtxRot.yBasis.x, mtxRot.zBasis.x ), new Vector3( mtxRot.xBasis.y, mtxRot.yBasis.y, mtxRot.zBasis.y ), new Vector3( mtxRot.xBasis.z, mtxRot.yBasis.z, mtxRot.zBasis.z ) );
		}

		/**
		 * Returns a matrix that is the orthonormal inverse of the argument matrix.
		 * This is only valid if the input matrix is orthonormal
		 * (the basis vectors are mutually perpendicular and of length 1)
		 */
		static public function rigidInverse( mtxTransform:Matrix ):Matrix
		{
			var rigidInverse:Matrix = rotationInverse( mtxTransform );
			rigidInverse.origin = rigidInverse.transformDirection( mtxTransform.origin.opposite() );
			return rigidInverse;
		}

		static public function componentWiseMin( vLHS:Vector3, vRHS:Vector3 ):Vector3
		{
			return new Vector3( Math.min( vLHS.x, vRHS.x ), Math.min( vLHS.y, vRHS.y ), Math.min( vLHS.z, vRHS.z ) );
		}

		static public function componentWiseMax( vLHS:Vector3, vRHS:Vector3 ):Vector3
		{
			return new Vector3( Math.max( vLHS.x, vRHS.x ), Math.max( vLHS.y, vRHS.y ), Math.max( vLHS.z, vRHS.z ) );
		}

		static public function componentWiseScale( vLHS:Vector3, vRHS:Vector3 ):Vector3
		{
			return new Vector3( vLHS.x * vRHS.x, vLHS.y * vRHS.y, vLHS.z * vRHS.z );
		}

		static public function componentWiseReciprocal( inVector:Vector3 ):Vector3
		{
			return new Vector3( 1.0 / inVector.x, 1.0 / inVector.y, 1.0 / inVector.z );
		}

		static public function minComponent( inVector:Vector3 ):Number
		{
			return Math.min( inVector.x, Math.min( inVector.y, inVector.z ) );
		}

		static public function maxComponent( inVector:Vector3 ):Number
		{
			return Math.max( inVector.x, Math.max( inVector.y, inVector.z ) );
		}

		/**
		 * Compute the polar/spherical heading of a vector direction in z/x plane
		 */
		static public function heading( inVector:Vector3 ):Number
		{
			return Math.atan2( inVector.z, inVector.x );
		}

		/**
		 * Compute the spherical elevation of a vector direction in y above the z/x plane
		 */
		static public function elevation( inVector:Vector3 ):Number
		{
			return Math.atan2( inVector.y, Math.sqrt( inVector.z * inVector.z + inVector.x * inVector.x ) );
		}

		/**
		 * Set magnitude to 1 and bring heading to [-Pi,Pi], elevation into [-Pi/2, Pi/2]
		 *
		 * @param The Vector3 to convert.
		 * @return The normalized spherical Vector3.
		 *
		 */
		static public function normalizeSpherical( vSpherical:Vector3 ):Vector3
		{
			var fHeading:Number = vSpherical.y;
			var fElevation:Number = vSpherical.z;

			while( fElevation <= -Math.PI )
				fElevation += TWO_PI;
			while( fElevation > Math.PI )
				fElevation -= TWO_PI;

			if( Math.abs( fElevation ) > HALF_PI )
			{
				fHeading += Math.PI;
				fElevation = fElevation > 0 ? ( Math.PI - fElevation ) : -( Math.PI + fElevation );
			}

			while( fHeading <= -Math.PI )
				fHeading += TWO_PI;
			while( fHeading > Math.PI )
				fHeading -= TWO_PI;

			return new Vector3( 1, fHeading, fElevation );
		}

		/**
		 * Convert from Cartesian (rectangular) coordinates to spherical coordinates
		 * (magnitude, heading, elevation).
		 *
		 * @param The Vector3 to convert.
		 * @return The cartesian Vector3 converted to spherical.
		 *
		 */
		static public function cartesianToSpherical( vCartesian:Vector3 ):Vector3
		{
			return new Vector3( vCartesian.magnitude(), heading( vCartesian ), elevation( vCartesian ) );
		}

		/**
		 * Convert from spherical coordinates (magnitude, heading, elevation) to
		 * Cartesian (rectangular) coordinates.
		 *
		 * @param The Vector3 to convert.
		 * @return The spherical Vector3 converted to cartesian.
		 *
		 */
		static public function sphericalToCartesian( vSpherical:Vector3 ):Vector3
		{
			var fMagnitude:Number = vSpherical.x;
			var fCosHeading:Number = Math.cos( vSpherical.y );
			var fSinHeading:Number = Math.sin( vSpherical.y );
			var fCosElevation:Number = Math.cos( vSpherical.z );
			var fSinElevation:Number = Math.sin( vSpherical.z );

			return new Vector3( fCosHeading * fCosElevation * fMagnitude, fSinElevation * fMagnitude, fSinHeading * fCosElevation * fMagnitude );
		}

		/**
		 * Clamps a value between a minimum Number and maximum Number value.
		 *
		 * @param inVal The number to clamp.
		 * @param minVal The minimum value.
		 * @param maxVal The maximum value.
		 * @return The value clamped between minVal and maxVal.
		 *
		 */
		static public function clamp( inVal:Number, minVal:Number, maxVal:Number ):Number
		{
			return ( inVal < minVal ) ? minVal : ( ( inVal > maxVal ) ? maxVal : inVal );
		}

		/**
		 * Linearly interpolates between two Numbers.
		 *
		 * @param a A number.
		 * @param b A number.
		 * @param t The interpolation coefficient [0-1].
		 * @return The interpolated number.
		 *
		 */
		static public function lerp( a:Number, b:Number, coefficient:Number ):Number
		{
			return a + ( ( b - a ) * coefficient );
		}

		/**
		 * Linearly interpolates between two Vector3 objects.
		 *
		 * @param a A Vector3 object.
		 * @param b A Vector3 object.
		 * @param t The interpolation coefficient [0-1].
		 * @return A new interpolated Vector3 object.
		 *
		 */
		static public function lerpVector( vec1:Vector3, vec2:Vector3, coefficient:Number ):Vector3
		{
			return vec1.plus( vec2.minus( vec1 ).multiply( coefficient ) );
		}
	}
}

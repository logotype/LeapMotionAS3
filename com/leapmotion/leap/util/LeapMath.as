package com.leapmotion.leap.util
{
	import com.leapmotion.leap.Vector3;

	public class LeapMath
	{
		public function LeapMath()
		{
		}

		static public function toDegrees( radians:Number ):Number
		{
			return radians * 180 / Math.PI;
		}

		/**
		 * A utility function to multiply a Vector3 represented by a 3-element vector by a scalar.
		 * @param inVector An Vector3 containing x, y and z representing coordinates in 3-dimensional space.
		 * @param scalar A scalar value.
		 * @return The product of a 3-d vector and a scalar.
		 *
		 */
		static public function multiplyVector( inVector:Vector3, scalar:Number ):Vector3
		{
			return new Vector3( inVector.x * scalar, inVector.y * scalar, inVector.z * scalar );
		}

		/**
		 * A utility function to normalize a Vector3 represented by a 3-element vector.
		 *
		 * A normalized vector has the same direction as the original, but a length of 1.0.
		 *
		 * @param inVector An Vector3 containing x, y and z representing coordinates in 3-dimensional space.
		 * @return The normalized vector.
		 *
		 */
		static public function normalizeVector( inVector:Vector3 ):Vector3
		{
			var denom:Number = inVector.x * inVector.x + inVector.y * inVector.y + inVector.z * inVector.z;
			if ( denom <= 0 )
				return Vector3.zero();
			var scalar:Number = 1.0 / Math.sqrt( denom );

			return multiplyVector( inVector, scalar );
		}
	}
}

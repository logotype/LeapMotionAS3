package com.leapmotion.leap.util
{
	import com.leapmotion.leap.Vector3;

	/**
	 * Quaternions are used to represent rotations. 
	 * @author logotype
	 * 
	 */
	public class Quaternion
	{
		/**
		 * X component of the Quaternion. 
		 */
		public var x:Number;

		/**
		 * Y component of the Quaternion. 
		 */
		public var y:Number;

		/**
		 * Z component of the Quaternion. 
		 */
		public var z:Number;

		/**
		 * W component of the Quaternion. 
		 */
		public var w:Number;

		/**
		 * Constructs a new Quaternion with given components. 
		 * @param a
		 * @param b
		 * @param c
		 * @param d
		 * 
		 */
		public function Quaternion( a:Number = 0, b:Number = 0, c:Number = 0, d:Number = 1 )
		{
			x = a ? a : 0;
			y = b ? b : 0;
			z = c ? c : 0;
			w = d ? d : 1;
		}

		/**
		 * Converts Vector3 representing a point to Quaternion.
		 * @param vec
		 * 
		 */
		public function fromVector3Point( vec:Vector3 ):void
		{
			x = vec.x;
			y = vec.y;
			z = vec.z;
			w = 0;
		}

		/**
		 * Converts Vector3 representing angles to Quaternion. 
		 * @param vec
		 * 
		 */
		public function fromVector3Angle( vec:Vector3 ):void
		{
			var sinZ:Number = Math.sin( vec.z * 0.5 );
			var cosZ:Number = Math.cos( vec.z * 0.5 );
			var sinY:Number = Math.sin( vec.y * 0.5 );
			var cosY:Number = Math.cos( vec.y * 0.5 );
			var sinX:Number = Math.sin( vec.x * 0.5 );
			var cosX:Number = Math.cos( vec.x * 0.5 );
			var cosYcosZ:Number = cosY * cosZ;
			var sinYsinZ:Number = sinY * sinZ;
			
			x = sinX * cosYcosZ - cosX * sinYsinZ;
			y = cosX * sinY * cosZ + sinX * cosY * sinZ;
			z = cosX * cosY * sinZ - sinX * sinY * cosZ;
			w = cosX * cosYcosZ + sinX * sinYsinZ;
		}
		
		/**
		 * Converts an axis-angle to Quaternion. 
		 * @param a
		 * @param b
		 * @param c
		 * @param d
		 * 
		 */
		public function fromAxisAngle( x:Number, y:Number, z:Number, angle:Number ):void
		{
			var sa:Number = Math.sin( angle / 2 );
			var ca:Number = Math.cos( angle / 2 );
			var m:Number = Math.sqrt( x * x + y * y + z * z );
			x = x / m * sa;
			y = y / m * sa;
			z = z / m * sa;
			w = ca;
		}

		/**
		 * Converts Euler angles to Quaternion. 
		 * @param ax
		 * @param ay
		 * @param az
		 * 
		 */
		public function fromEuler( ax:Number, ay:Number, az:Number ):void
		{
			var sinZ:Number = Math.sin( az * 0.5 );
			var cosZ:Number = Math.cos( az * 0.5 );
			var sinY:Number = Math.sin( ay * 0.5 );
			var cosY:Number = Math.cos( ay * 0.5 );
			var sinX:Number = Math.sin( ax * 0.5 );
			var cosX:Number = Math.cos( ax * 0.5 );
			var cosYcosZ:Number = cosY * cosZ;
			var sinYsinZ:Number = sinY * sinZ;

			x = sinX * cosYcosZ - cosX * sinYsinZ;
			y = cosX * sinY * cosZ + sinX * cosY * sinZ;
			z = cosX * cosY * sinZ - sinX * sinY * cosZ;
			w = cosX * cosYcosZ + sinX * sinYsinZ;
		}

		/**
		 * Normalize Quaternion. 
		 * 
		 */
		public function normalize():void
		{
			var l:Number = Math.sqrt( x * x + y * y + z * z + w * w );
			x = x / l;
			y = y / l;
			z = z / l;
			w = w / l;
		}

		/**
		 * The pitch angle in radians.
		 * @return 
		 * 
		 */
		public function pitch():Number
		{
			return Math.atan2( 2 * ( y * z + w * x ), w * w - x * x - y * y + z * z );
		}

		/**
		 * The yaw angle in radians.
		 * @return 
		 * 
		 */
		public function yaw():Number
		{
			return Math.asin( -2 * ( x * z - w * y ));
		}

		/**
		 * The roll angle in radians.
		 * @return 
		 * 
		 */
		public function roll():Number
		{
			return Math.atan2( 2 * ( x * y + w * z ), w * w + x * x - y * y - z * z );
		}

		/**
		 * Concatenates two Quaternions; the result represents the
		 * first rotation followed by the second rotation. 
		 * @param other
		 * 
		 */
		public function concatenate( other:Quaternion ):void
		{
			var w1:Number = w;
			var x1:Number = x;
			var y1:Number = y;
			var z1:Number = z;
			var w2:Number = other.w;
			var x2:Number = other.x;
			var y2:Number = other.y;
			var z2:Number = other.z;
			w = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2
			x = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2
			y = w1 * y2 + y1 * w2 + z1 * x2 - x1 * z2
			z = w1 * z2 + z1 * w2 + x1 * y2 - y1 * x2
		}

		/**
		 * Calculate inverse of Quaternion. 
		 * 
		 */
		public function inverse():void
		{
			x = -x;
			y = -y;
			z = -z;
		}

		/**
		 * Copy a Quaternion. 
		 * @return A Quaternion representing the same values.
		 * 
		 */
		public function copy():Quaternion
		{
			return new Quaternion( x, y, z, w );
		}
	}
}

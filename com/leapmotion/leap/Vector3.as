package com.leapmotion.leap
{

	/**
	 * The Vector struct represents a three-component mathematical vector
	 * or point such as a direction or position in three-dimensional space.
	 *
	 * The Leap software employs a right-handed Cartesian coordinate system.
	 * Values given are in units of real-world millimeters. The origin is
	 * centered at the center of the Leap device. The x- and z-axes lie in
	 * the horizontal plane, with the x-axis running parallel to the long edge
	 * of the device. The y-axis is vertical, with positive values increasing
	 * upwards (in contrast to the downward orientation of most computer
	 * graphics coordinate systems). The z-axis has positive values increasing
	 * away from the computer screen.
	 *
	 * @author logotype
	 *
	 */
	public class Vector3
	{
		/**
		 * The horizontal component.
		 */
		public var x:Number;

		/**
		 * The vertical component.
		 */
		public var y:Number;

		/**
		 * The depth component.
		 */
		public var z:Number;

		public function Vector3( x:Number, y:Number, z:Number )
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public function opposite():Vector3
		{
			return new Vector3( -x, -y, -z );
		}

		/**
		 * Add vectors component-wise.
		 * @param other
		 * @return
		 *
		 */
		public function plus( other:Vector3 ):Vector3
		{
			return new Vector3( x + other.x, y + other.y, z + other.z );
		}

		/**
		 * Add vectors component-wise and assign the value.
		 * @param other
		 * @return This Vector3.
		 *
		 */
		public function plusAssign( other:Vector3 ):Vector3
		{
			x + other.x;
			y + other.y;
			z + other.z;
			return this;
		}

		/**
		 * A copy of this vector pointing in the opposite direction.
		 * @param other
		 * @return
		 *
		 */
		public function minus( other:Vector3 ):Vector3
		{
			return new Vector3( x - other.x, y - other.y, z - other.z );
		}

		/**
		 * A copy of this vector pointing in the opposite direction and assign the value.
		 * @param other
		 * @return This Vector3.
		 *
		 */
		public function minusAssign( other:Vector3 ):Vector3
		{
			x - other.x;
			y - other.y;
			z - other.z;
			return this;
		}

		/**
		 * Multiply vector by a scalar.
		 * @param scalar
		 * @return
		 *
		 */
		public function multiply( scalar:Number ):Vector3
		{
			return new Vector3( x * scalar, y * scalar, z * scalar );
		}

		/**
		 * Multiply vector by a scalar and assign the value.
		 * @param scalar
		 * @return This Vector3.
		 *
		 */
		public function multiplyAssign( scalar:Number ):Vector3
		{
			x * scalar;
			y * scalar;
			z * scalar;
			return this;
		}

		/**
		 * Divide vector by a scalar.
		 * @param scalar
		 * @return
		 *
		 */
		public function divide( scalar:Number ):Vector3
		{
			return new Vector3( x / scalar, y / scalar, z / scalar );
		}

		/**
		 * Divide vector by a scalar and assign the value.
		 * @param scalar
		 * @return This Vector3.
		 *
		 */
		public function divideAssign( scalar:Number ):Vector3
		{
			x / scalar;
			y / scalar;
			z / scalar;
			return this;
		}

		/**
		 * Compare Vector equality/inequality component-wise. 
		 * @param other The Vector3 to compare with.
		 * @return True; if equal, False otherwise.
		 * 
		 */
		public function isEqualTo( other:Vector3 ):Boolean
		{
			var returnValue:Boolean = true;

			if ( x != other.x || y != other.y || z != other.z )
				returnValue = false;

			return returnValue;
		}

		/**
		 * The angle between this vector and the specified vector in radians.
		 * @param other
		 * @return
		 *
		 */
		public function angleTo( other:Vector3 ):Number
		{
			var denom:Number = magnitudeSquared() * other.magnitudeSquared();
			if ( denom <= 0.0 )
				return 0.0;

			return Math.acos( dot( other ) / Math.sqrt( denom ));
		}

		/**
		 * The cross product of this vector and the specified vector.
		 * @param other
		 * @return
		 *
		 */
		public function cross( other:Vector3 ):Vector3
		{
			return new Vector3(( y * other.z ) - ( z * other.y ), ( z * other.x ) - ( x * other.z ), ( x * other.y ) - ( y * other.x ));
		}

		/**
		 * The distance between the point represented by this Vector object and a point represented by the specified Vector object.
		 * @param other
		 * @return
		 *
		 */
		public function distanceTo( other:Vector3 ):Number
		{
			return Math.sqrt(( x - other.x ) * ( x - other.x ) + ( y - other.y ) * ( y - other.y ) + ( z - other.z ) * ( z - other.z ));
		}

		/**
		 * The dot product of this vector with another vector.
		 * @param other
		 * @return
		 *
		 */
		public function dot( other:Vector3 ):Number
		{
			return ( x * other.x ) + ( y * other.y ) + ( z * other.z );
		}

		/**
		 * Returns true if all of the vector's components are finite.
		 * @return
		 *
		 */
		public function isValid():Boolean
		{
			return ( x <= Number.MAX_VALUE && x >= -Number.MAX_VALUE ) && ( y <= Number.MAX_VALUE && y >= -Number.MAX_VALUE ) && ( z <= Number.MAX_VALUE && z >= -Number.MAX_VALUE );
		}

		/**
		 * The magnitude, or length, of this vector.
		 * @return
		 *
		 */
		public function magnitude():Number
		{
			return Math.sqrt( x * x + y * y + z * z );
		}

		/**
		 * The square of the magnitude, or length, of this vector.
		 * @return
		 *
		 */
		public function magnitudeSquared():Number
		{
			return x * x + y * y + z * z;
		}

		/**
		 * A normalized copy of this vector.
		 * @return
		 *
		 */
		public function normalized():Vector3
		{
			var denom:Number = magnitudeSquared();
			if ( denom <= 0.0 )
				return new Vector3( 0, 0, 0 );

			denom = 1.0 / Math.sqrt( denom );
			return new Vector3( x * denom, y * denom, z * denom );
		}

		/**
		 * The pitch angle in radians.
		 * @return
		 *
		 */
		public function get pitch():Number
		{
			return Math.atan2( y, -z );
		}

		/**
		 * The yaw angle in radians.
		 * @return
		 *
		 */
		public function get yaw():Number
		{
			return Math.atan2( x, -z );
		}

		/**
		 * The roll angle in radians.
		 * @return
		 *
		 */
		public function get roll():Number
		{
			return Math.atan2( x, -y );
		}

		/**
		 * The zero vector: (0, 0, 0)
		 * @return
		 *
		 */
		static public function zero():Vector3
		{
			return new Vector3( 0, 0, 0 );
		}

		/**
		 * The x-axis unit vector: (1, 0, 0)
		 * @return
		 *
		 */
		static public function xAxis():Vector3
		{
			return new Vector3( 1, 0, 0 );
		}

		/**
		 * The y-axis unit vector: (0, 1, 0)
		 * @return
		 *
		 */
		static public function yAxis():Vector3
		{
			return new Vector3( 0, 1, 0 );
		}

		/**
		 * The z-axis unit vector: (0, 0, 1)
		 * @return
		 *
		 */
		static public function zAxis():Vector3
		{
			return new Vector3( 0, 0, 1 );
		}

		/**
		 * The unit vector pointing left along the negative x-axis: (-1, 0, 0)
		 * @return
		 *
		 */
		static public function left():Vector3
		{
			return new Vector3( -1, 0, 0 );
		}

		/**
		 * The unit vector pointing right along the positive x-axis: (1, 0, 0)
		 * @return
		 *
		 */
		static public function right():Vector3
		{
			return xAxis();
		}

		/**
		 * The unit vector pointing down along the negative y-axis: (0, -1, 0)
		 * @return
		 *
		 */
		static public function down():Vector3
		{
			return new Vector3( 0, -1, 0 );
		}

		/**
		 * The unit vector pointing up along the positive x-axis: (0, 1, 0)
		 * @return
		 *
		 */
		static public function up():Vector3
		{
			return yAxis();
		}

		/**
		 * The unit vector pointing forward along the negative z-axis: (0, 0, -1)
		 * @return
		 *
		 */
		static public function forward():Vector3
		{
			return new Vector3( 0, 0, -1 );
		}

		/**
		 * The unit vector pointing backward along the positive z-axis: (0, 0, 1)
		 * @return
		 *
		 */
		static public function backward():Vector3
		{
			return zAxis();
		}

		/**
		 * Returns a string containing this vector in a human readable format: (x, y, z).
		 * @return
		 *
		 */
		public function toString():String
		{
			return "[Vector3 x:" + x + " y:" + y + " z:" + z + "]";
		}
	}
}

package com.leapmotion.leap
{
	public class Vector3
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;

		public function Vector3( x:Number, y:Number, z:Number )
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public function toString():String
		{
			return "[Vector3 x:" + this.x + " y:" + this.y + " z:" + this.z + "]";
		}

		// OPERATOR METHODS (no overloading yet)
		public function opposite():Vector3
		{
			return new Vector3( -x, -y, -z );
		}

		public function plus( other:Vector3 ):Vector3
		{
			return new Vector3( x + other.x, y + other.y, z + other.z );
		}

		public function minus( other:Vector3 ):Vector3
		{
			return new Vector3( x - other.x, y - other.y, z - other.z );
		}

		public function multiply( scalar:Number ):Vector3
		{
			return new Vector3( x * scalar, y * scalar, z * scalar );
		}

		public function divide( scalar:Number ):Vector3
		{
			return new Vector3( x / scalar, y / scalar, z / scalar );
		}

		// MISCELLANEOUS METHODS
		public function isValid():Boolean
		{
			return ( x <= Number.MAX_VALUE && x >= -Number.MAX_VALUE ) && ( y <= Number.MAX_VALUE && y >= -Number.MAX_VALUE ) && ( z <= Number.MAX_VALUE && z >= -Number.MAX_VALUE );
		}

		// INSTANCE METHODS
		public function magnitude():Number
		{
			return Math.sqrt( x * x + y * y + z * z );
		}

		public function magnitudeSquared():Number
		{
			return x * x + y * y + z * z;
		}

		public function distanceTo( other:Vector3 ):Number
		{
			return Math.sqrt(( x - other.x ) * ( x - other.x ) + ( y - other.y ) * ( y - other.y ) + ( z - other.z ) * ( z - other.z ));
		}

		public function angleTo( other:Vector3 ):Number
		{
			var denom:Number = this.magnitudeSquared() * other.magnitudeSquared();
			if ( denom <= 0.0 )
			{
				return 0.0;
			}
			return Math.acos( this.dot( other ) / Math.sqrt( denom ));
		}

		public function pitch():Number
		{
			return Math.atan2( y, -z );
		}

		public function yaw():Number
		{
			return Math.atan2( x, -z );
		}

		public function roll():Number
		{
			return Math.atan2( x, -y );
		}

		public function dot( other:Vector3 ):Number
		{
			return ( x * other.x ) + ( y * other.y ) + ( z * other.z );
		}

		public function cross( other:Vector3 ):Vector3
		{
			return new Vector3(( y * other.z ) - ( z * other.y ), ( z * other.x ) - ( x * other.z ), ( x * other.y ) - ( y * other.x ));
		}

		public function normalized():Vector3
		{
			var denom:Number = this.magnitudeSquared();
			if ( denom <= 0.0 )
			{
				return new Vector3( 0, 0, 0 );
			}
			denom = 1.0 / Math.sqrt( denom );
			return new Vector3( x * denom, y * denom, z * denom );
		}

		// STATIC METHODS
		static public function zero():Vector3
		{
			return new Vector3( 0, 0, 0 );
		}

		static public function xAxis():Vector3
		{
			return new Vector3( 1, 0, 0 );
		}

		static public function yAxis():Vector3
		{
			return new Vector3( 0, 1, 0 );
		}

		static public function zAxis():Vector3
		{
			return new Vector3( 0, 0, 1 );
		}

		static public function left():Vector3
		{
			return new Vector3( -1, 0, 0 );
		}

		static public function right():Vector3
		{
			return xAxis();
		}

		static public function down():Vector3
		{
			return new Vector3( 0, -1, 0 );
		}

		static public function up():Vector3
		{
			return yAxis();
		}

		static public function forward():Vector3
		{
			return new Vector3( 0, 0, -1 );
		}

		static public function backward():Vector3
		{
			return zAxis();
		}
	}
}

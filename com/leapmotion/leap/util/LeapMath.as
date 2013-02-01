package com.leapmotion.leap.util
{

	public class LeapMath
	{
		public function LeapMath()
		{
		}

		static public function toDegrees( radians:Number ):Number
		{
			return radians * 180 / Math.PI;
		}

		static public function clamp( inVal:Number, minVal:Number, maxVal:Number ) :Number
		{
			return ( inVal < minVal ) ? minVal : (( inVal > maxVal ) ? maxVal : inVal );
		}
	}
}

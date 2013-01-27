package com.leapmotion.leap.util
{

	public class LeapMath
	{
		public function LeapMath()
		{
		}

		public static function toDegrees( radians:Number ):Number
		{
			return radians * 180 / Math.PI;
		}
	}
}

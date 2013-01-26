package com.leapmotion.leap
{

	public class Hand
	{
		public var direction:Vector3;
		public var id:Number;
		public var palmNormal:Vector3;
		public var palmPosition:Vector3;
		public var palmVelocity:Vector3;
		public var sphereCenter:Vector3;
		public var sphereRadius:Number;
		
		// vic
		public var fingers:Vector.<Pointable> = new Vector.<Pointable>();
		public var r:Vector.<Vector3> = new Vector.<Vector3>();
		public var s:Number;
		public var t:Vector3;

		public function Hand()
		{
		}
	}
}
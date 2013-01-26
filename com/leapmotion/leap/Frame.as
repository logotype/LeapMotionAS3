package com.leapmotion.leap
{

	public class Frame
	{
		public var hand:Hand;
		public var hands:Vector.<Hand> = new Vector.<Hand>();
		public var id:int;
		public var timestamp:Number;
		
		public var r:Vector.<Vector3> = new Vector.<Vector3>();
		public var s:Number;
		public var t:Vector3;
		
		public var finger:Finger;
		public var fingers:Vector.<Pointable> = new Vector.<Pointable>();
		public var tools:Vector.<Pointable> = new Vector.<Pointable>();
		
		public function Frame()
		{
		}
	}
}
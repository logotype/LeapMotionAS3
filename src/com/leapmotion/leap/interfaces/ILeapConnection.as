package com.leapmotion.leap.interfaces
{
	import com.leapmotion.leap.Frame;

	public interface ILeapConnection
	{
		function get isConnected():Boolean;
		function get frame():Frame;
		function enableGesture( gesture:int, enable:Boolean = true):void;
	}
}
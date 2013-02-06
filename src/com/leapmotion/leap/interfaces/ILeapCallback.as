package com.leapmotion.leap.interfaces
{
	import com.leapmotion.leap.Controller;
	import com.leapmotion.leap.Frame;

	public interface ILeapCallback
	{
		function onConnect( controller:Controller ):void;

		function onDisconnect( controller:Controller ):void;

		function onExit( controller:Controller ):void;

		function onFrame( controller:Controller, frame:Frame ):void;

		function onInit( controller:Controller ):void;
	}
}
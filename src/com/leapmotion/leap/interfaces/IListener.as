package com.leapmotion.leap.interfaces
{
	import com.leapmotion.leap.Controller;

	public interface IListener
	{
		function onConnect( controller:Controller ) :void;
		function onDisconnect( controller:Controller ) :void;
		function onExit( controller:Controller ) :void;
		function onFrame( controller:Controller ) :void;
		function onInit( controller:Controller ) :void;
	}
}
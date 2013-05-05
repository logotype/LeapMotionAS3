package
{
	import com.leapmotion.leap.*;
	import com.leapmotion.leap.events.*;

	import flash.display.Sprite;

	[SWF(frameRate=60)]
	public class ConfigSample extends Sprite
	{
		private var controller:Controller;

		public function ConfigSample()
		{
			controller = new Controller();
			controller.addEventListener( LeapEvent.LEAPMOTION_INIT, onInit );
			controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, onConnect );
			controller.addEventListener( LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect );
			controller.addEventListener( LeapEvent.LEAPMOTION_EXIT, onExit );
			controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
		}

		private function onInit( event:LeapEvent ):void
		{
			trace( "Initialized" );
		}

		private function onConnect( event:LeapEvent ):void
		{
			trace( "Connected" );
			var configKeys:Vector.<String> = Vector.<String>([
				"Gesture.Circle.MinRadius",
				"Gesture.Circle.MinArc",
				"Gesture.Swipe.MinLength",
				"Gesture.Swipe.MinVelocity",
				"Gesture.KeyTap.MinDownVelocity",
				"Gesture.KeyTap.HistorySeconds",
				"Gesture.KeyTap.MinDistance",
				"Gesture.ScreenTap.MinForwardVelocity",
				"Gesture.ScreenTap.HistorySeconds",
				"Gesture.ScreenTap.MinDistance"
			]);
			for each(var configKey:String in configKeys) {
				trace(configKey, controller.config().getFloat(configKey));
			}
		}

		private function onDisconnect( event:LeapEvent ):void
		{
			trace( "Disconnected" );
		}

		private function onExit( event:LeapEvent ):void
		{
			trace( "Exited" );
		}

		private function onFrame( event:LeapEvent ):void
		{
		}
	}
}
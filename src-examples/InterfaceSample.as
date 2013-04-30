package
{
	import com.leapmotion.leap.Controller;
	import com.leapmotion.leap.Frame;
	import com.leapmotion.leap.Gesture;
	import com.leapmotion.leap.LeapMotion;
	import com.leapmotion.leap.Listener;
	
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	public class InterfaceSample extends Sprite implements Listener
	{
		private var leap:LeapMotion;
		private var startTime:Number;
		private var currentTime:Number;
		private var framesNumber:int = 0;
		
		public function InterfaceSample()
		{
			leap = new LeapMotion();
			leap.controller.setListener( this );
		}
		
		public function onInit( controller:Controller ):void
		{
			trace( "onInit" );
		}
		
		public function onConnect( controller:Controller ):void
		{
			trace( "onConnect" );
			controller.enableGesture( Gesture.TYPE_SWIPE );
			controller.enableGesture( Gesture.TYPE_CIRCLE );
			controller.enableGesture( Gesture.TYPE_SCREEN_TAP );
			controller.enableGesture( Gesture.TYPE_KEY_TAP );
			startTime = getTimer();
		}
		
		public function onDisconnect( controller:Controller ):void
		{
			trace( "onDisconnect" );
		}
		
		public function onExit( controller:Controller ):void
		{
			trace( "onExit" );
		}
		
		public function onFocusGained( controller:Controller ):void
		{
			trace( "onFocusGained" );
		}
		
		public function onFocusLost( controller:Controller ):void
		{
			trace( "onFocusLost" );
		}
		
		public function onFrame( controller:Controller, frame:Frame ):void
		{
			currentTime = ( getTimer() - startTime ) / 1000;
			framesNumber++;
			
			if ( currentTime > 1 )
			{
				trace( "Data FPS: " + ( Math.floor(( framesNumber / currentTime ) * 10.0 ) / 10.0 ));
				startTime = getTimer();
				framesNumber = 0;
			}
		}
	}
}
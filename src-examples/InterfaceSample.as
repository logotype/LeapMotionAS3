package
{
	import com.leapmotion.leap.Controller;
	import com.leapmotion.leap.Frame;
	import com.leapmotion.leap.Gesture;
	import com.leapmotion.leap.Listener;
	
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	[SWF(frameRate=60)]
	public class InterfaceSample extends Sprite implements Listener
	{
		private var controller:Controller;
		private var startTime:Number;
		private var currentTime:Number;
		private var framesNumber:int = 0;
		
		public function InterfaceSample()
		{
			controller = new Controller();
			controller.setListener( this );
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
		
		public function onServiceConnect( controller:Controller ):void
		{
			trace( "onServiceConnect" );
		}
		
		public function onServiceDisconnect( controller:Controller ):void
		{
			trace( "onServiceDisconnect" );
		}
		
		public function onDeviceChange( controller:Controller ):void
		{
			trace( "onDeviceChange" );
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
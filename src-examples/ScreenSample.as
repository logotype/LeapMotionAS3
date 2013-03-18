package
{
	import com.leapmotion.leap.LeapMotion;
	import com.leapmotion.leap.Screen;
	import com.leapmotion.leap.Vector3;
	import com.leapmotion.leap.events.LeapEvent;
	
	import flash.display.Sprite;
	
	[SWF(width='1400', height='700', backgroundColor='#ffffff', frameRate='60')]
	public class ScreenSample extends Sprite
	{
		private var leap:LeapMotion;
		private var screenList:Vector.<Screen>;
		private var screen:Screen;
		private var cursor:Sprite;
		private var currentVector:Vector3;
		
		public function ScreenSample()
		{
			cursor = new Sprite();
			cursor.graphics.beginFill( 0xff0000 );
			cursor.graphics.drawCircle( -5, -5, 10 );
			cursor.graphics.endFill();
			this.addChild( cursor );
			
			leap = new LeapMotion();
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, onConnect );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
		}
		
		private function onConnect( event:LeapEvent ):void
		{
			trace( "Connected" );
			screenList = leap.controller.calibratedScreens();
			screen = screenList[ 0 ];
		}
		
		private function onFrame( event:LeapEvent ):void
		{
			if( event.frame.pointables.length > 0 )
			{
				currentVector = screen.intersect( event.frame.pointables[ 0 ], true );
				cursor.x = stage.stageWidth * currentVector.x;
				cursor.y = stage.stageHeight * ( 1 - currentVector.y );
			}
		}
	}
}
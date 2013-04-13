package
{
	import com.leapmotion.leap.LeapMotion;
	import com.leapmotion.leap.Screen;
	import com.leapmotion.leap.Vector3;
	import com.leapmotion.leap.events.LeapEvent;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;

	[SWF(backgroundColor='#ffffff', frameRate='60')]
	public class ScreenSample extends Sprite
	{
		private var leap:LeapMotion;
		private var screenList:Vector.<Screen>;
		private var screen:Screen;
		private var screenWidth:uint;
		private var screenHeight:uint;
		private var cursor:Sprite;
		private var currentVector:Vector3;

		public function ScreenSample()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

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
			screenList = leap.controller.locatedScreens();
			screen = screenList[ 0 ];
			screenWidth = screen.widthPixels();
			screenHeight = screen.heightPixels();
		}

		private function onFrame( event:LeapEvent ):void
		{
			if ( event.frame.pointables.length > 0 )
			{
				/*
				Optionally, you can call screen.intersect() with a position and direction Vector3:
				screen.intersect( event.frame.pointables[ 0 ].tipPosition, event.frame.pointables[ 0 ].direction, true );
				*/
				currentVector = screen.intersectPointable( event.frame.pointables[ 0 ], true );
				cursor.x = screenWidth * currentVector.x - stage.nativeWindow.x;
				cursor.y = screenHeight * ( 1 - currentVector.y ) - stage.nativeWindow.y;
			}
		}
	}
}
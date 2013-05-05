package samples.swipeGallery
{
	import com.leapmotion.leap.Gesture;
	import com.leapmotion.leap.Controller;
	import com.leapmotion.leap.SwipeGesture;
	import com.leapmotion.leap.events.LeapEvent;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getTimer;

	[SWF(frameRate=60)]
	public class SwipeGallery extends Sprite
	{

		private var controller:Controller;
		private var container:Sprite;
		private var imagesHolder:Sprite;

		private var lastSwipe:int;

		private var _currentImageIndex:int;
		private var numImages:uint = 10;

		public function SwipeGallery()
		{
			container = new Sprite();
			container.mouseChildren = container.mouseEnabled = false;
			imagesHolder = new Sprite();
			container.addChild( imagesHolder );
			for ( var i:uint = 0; i < numImages; i++ )
			{
				var image:Shape = new Shape();
				image.graphics.beginFill( 0xff0000 );
				image.graphics.drawRect( -50, -50, 100, 100 );
				image.graphics.endFill();
				image.x = i * 110;
				imagesHolder.addChild( image );
			}
			addChild( container );

			controller = new Controller();
			controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, leapmotionFrameHandler );
			controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, leapmotionConnectedHandler );

			addEventListener( Event.ENTER_FRAME, enterFrameHandler );

			addStageListeners();
		}

		private function leapmotionConnectedHandler( event:LeapEvent ):void
		{
			controller.enableGesture( Gesture.TYPE_SWIPE );
		}

		public function get currentImageIndex():int
		{
			return _currentImageIndex;
		}

		public function set currentImageIndex( value:int ):void
		{
			value = Math.max( 0, Math.min( (numImages - 1), value ) );
			if ( _currentImageIndex != value )
			{
				_currentImageIndex = value;
				trace( "show image", _currentImageIndex );
				//positioning itself happens in enter frame loop
			}
		}

		protected function leapmotionFrameHandler( event:LeapEvent ):void
		{
			var now:int = getTimer();
			if ( now - lastSwipe > 500 )
			{
				var gestures:Vector.<Gesture> = event.frame.gestures();
				for each( var gesture:Gesture in gestures )
				{
					if ( gesture is SwipeGesture && gesture.state == Gesture.STATE_STOP )
					{
						var swipe:SwipeGesture = gesture as SwipeGesture;
						if ( Math.abs( swipe.direction.x ) > Math.abs( swipe.direction.y ) )
						{
							if ( swipe.direction.x > 0 )
							{
								currentImageIndex--;
							}
							else
							{
								currentImageIndex++;
							}
							lastSwipe = now;
							break;
						}
					}
				}
			}
		}

		private function enterFrameHandler( event:Event ):void
		{
			imagesHolder.x += ((-currentImageIndex * 110) - imagesHolder.x) * .2;
		}

		private function addStageListeners( event:Event = null ):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, addStageListeners );
			if ( !stage )
			{
				addEventListener( Event.ADDED_TO_STAGE, addStageListeners );
				return;
			}
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener( Event.RESIZE, resizeHandler );
			resizeHandler();
		}

		protected function resizeHandler( event:Event = null ):void
		{
			container.x = stage.stageWidth / 2;
			container.y = stage.stageHeight / 2;
		}
	}
}
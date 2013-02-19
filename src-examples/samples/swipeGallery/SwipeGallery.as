package samples.swipeGallery
{
	import com.leapmotion.leap.Hand;
	import com.leapmotion.leap.LeapMotion;
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
		
		private var leap:LeapMotion;
		private var container:Sprite;
		private var imagesHolder:Sprite;
		
		private var lastGestureTime:int;
		
		private var _currentImageIndex:int;
		private var numImages:uint = 10;
		
		public function SwipeGallery()
		{
			container = new Sprite();
			container.mouseChildren = container.mouseEnabled = false;
			imagesHolder = new Sprite();
			container.addChild(imagesHolder);
			for(var i:uint = 0; i < numImages; i++)
			{
				var image:Shape = new Shape();
				image.graphics.beginFill(0xff0000);
				image.graphics.drawRect(-50, -50, 100, 100);
				image.graphics.endFill();
				image.x = i * 110;
				imagesHolder.addChild(image);
			}
			addChild(container);
			
			leap = new LeapMotion();
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, leapmotionFrameHandler );
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			addStageListeners();
		}
		
		public function get currentImageIndex():int
		{
			return _currentImageIndex;
		}

		public function set currentImageIndex(value:int):void
		{
			value = Math.max(0, Math.min((numImages-1), value));
			if(_currentImageIndex != value)
			{
				_currentImageIndex = value;
				trace("show image", _currentImageIndex);
				//positioning itself happens in enter frame loop
			}
		}

		protected function leapmotionFrameHandler( event:LeapEvent ):void
		{
			for each(var hand:Hand in event.frame.hands)
			{
				if(hand.fingers.length > 1)
				{
					if(hand.palmVelocity.x > 500)
					{
						trySwipe("right");
					}
					else if(hand.palmVelocity.x < -500)
					{
						trySwipe("left");
					}
				}
			}
		}
		
		private function trySwipe(direction:String):void
		{
			var now:int = getTimer();
			//prevent multiple gestures executed to fast
			if(now - lastGestureTime > 500)
			{
				lastGestureTime = now;
				if(direction == "left")
				{
					currentImageIndex++;
				}
				else
				{
					currentImageIndex--;
				}
			}
		}
		
		private function enterFrameHandler(event:Event):void
		{
			imagesHolder.x += ((-currentImageIndex * 110) - imagesHolder.x) * .2;
		}
		
		private function addStageListeners( event:Event = null ):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addStageListeners);
			if(!stage)
			{
				addEventListener(Event.ADDED_TO_STAGE, addStageListeners);
				return;
			}
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, resizeHandler);
			resizeHandler();
		}
		
		protected function resizeHandler( event:Event = null ):void
		{
			container.x = stage.stageWidth / 2;
			container.y = stage.stageHeight / 2;
		}
	}
}
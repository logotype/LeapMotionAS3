package samples.fingerVisualizer
{
	import com.greensock.TweenLite;
	import com.leapmotion.leap.CircleGesture;
	import com.leapmotion.leap.Gesture;
	import com.leapmotion.leap.KeyTapGesture;
	import com.leapmotion.leap.LeapMotion;
	import com.leapmotion.leap.Pointable;
	import com.leapmotion.leap.ScreenTapGesture;
	import com.leapmotion.leap.SwipeGesture;
	import com.leapmotion.leap.Vector3;
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.util.LeapMath;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	[SWF(frameRate=60)]
	public class FingerVisualizer extends Sprite
	{
		
		private static const RAD_TO_DEG:Number = 180 / Math.PI;
		
		private var leap:LeapMotion;
		private var container:Sprite;
		
		private var tapGesturesContainer:Sprite;
		private var circleGesturesContainer:Sprite;
		private var swipeGesturesContainer:Sprite;
		
		public function FingerVisualizer()
		{
			tapGesturesContainer = new Sprite();
			tapGesturesContainer.mouseChildren = tapGesturesContainer.mouseEnabled = false;
			addChild(tapGesturesContainer);
			
			circleGesturesContainer = new Sprite();
			circleGesturesContainer.mouseChildren = circleGesturesContainer.mouseEnabled = false;
			addChild(circleGesturesContainer);
			
			swipeGesturesContainer = new Sprite();
			swipeGesturesContainer.mouseChildren = swipeGesturesContainer.mouseEnabled = false;
			addChild(swipeGesturesContainer);
			
			container = new Sprite();
			container.mouseChildren = container.mouseEnabled = false;
			addChild(container);
			
			leap = new LeapMotion();
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, leapmotionFrameHandler );
			
			leap.controller.enableGesture( Gesture.TYPE_CIRCLE );
			leap.controller.enableGesture( Gesture.TYPE_KEY_TAP );
			leap.controller.enableGesture( Gesture.TYPE_SCREEN_TAP );
			leap.controller.enableGesture( Gesture.TYPE_SWIPE );
			
			addStageListeners();
		}
		
		protected function leapmotionFrameHandler( event:LeapEvent ):void
		{
			var startPos:Vector3;
			var endPos:Vector3;
			var startPos2D:Point;
			var endPos2D:Point;
			container.graphics.clear();
			for each ( var pointable:Pointable in event.frame.pointables )
			{
				startPos = pointable.tipPosition;
				endPos = pointable.tipPosition.minus(pointable.direction.multiply(pointable.length));
				
				startPos2D = local3DToGlobal(toVector3D(startPos));
				endPos2D = local3DToGlobal(toVector3D(endPos));
				
				container.graphics.beginFill(0xff0000);
				container.graphics.lineStyle();
				container.graphics.drawCircle(startPos2D.x, startPos2D.y, 6);
				container.graphics.endFill();
				
				container.graphics.lineStyle(1);
				container.graphics.moveTo(startPos2D.x, startPos2D.y);
				container.graphics.lineTo(endPos2D.x, endPos2D.y);
			}
			circleGesturesContainer.removeChildren();
			swipeGesturesContainer.graphics.clear();
			for each ( var gesture:Gesture in event.frame._gestures )
			{
				var gestureVisualization:Shape;
				var pos2D:Point;
				var pos3D:Vector3D;
				if(gesture is CircleGesture )
				{
					var circleGesture:CircleGesture = gesture as CircleGesture;
					pos3D = toVector3D(circleGesture.center);
					
					gestureVisualization = new Shape();
					gestureVisualization.graphics.lineStyle(2, 0x00ff00);
					gestureVisualization.graphics.drawCircle(0, 0, circleGesture.radius);
					gestureVisualization.x = pos3D.x;
					gestureVisualization.y = pos3D.y;
					gestureVisualization.z = pos3D.z;
					gestureVisualization.rotationX = LeapMath.toDegrees(circleGesture.normal.pitch);
					gestureVisualization.rotationY = LeapMath.toDegrees(circleGesture.normal.yaw);
					gestureVisualization.rotationZ = LeapMath.toDegrees(circleGesture.normal.roll);
					circleGesturesContainer.addChild(gestureVisualization);
				}
				else if( gesture is KeyTapGesture )
				{
					var keyTapGesture:KeyTapGesture = gesture as KeyTapGesture;
					pos2D = local3DToGlobal(toVector3D(keyTapGesture.position));
					
					gestureVisualization = new Shape();
					gestureVisualization.graphics.lineStyle(2, 0x0000ff);
					gestureVisualization.graphics.drawCircle(pos2D.x, pos2D.y, 30);
					tapGesturesContainer.addChild(gestureVisualization);
					
					TweenLite.to(gestureVisualization, 1, {alpha: 0, onComplete: tapGesturesContainer.removeChild, onCompleteParams: [gestureVisualization]});
				}
				else if(gesture is ScreenTapGesture )
				{
					var screenTapGesture:ScreenTapGesture = gesture as ScreenTapGesture;
					pos2D = local3DToGlobal(toVector3D(screenTapGesture.position));
					
					gestureVisualization = new Shape();
					gestureVisualization.graphics.lineStyle(2, 0x00ff00);
					gestureVisualization.graphics.drawCircle(pos2D.x, pos2D.y, 30);
					tapGesturesContainer.addChild(gestureVisualization);
					
					TweenLite.to(gestureVisualization, 1, {alpha: 0, onComplete: tapGesturesContainer.removeChild, onCompleteParams: [gestureVisualization]});
				}
				else if( gesture is SwipeGesture )
				{
					var swipeGesture:SwipeGesture = gesture as SwipeGesture;
					startPos = swipeGesture.startPosition;
					endPos = swipeGesture.position;
					
					startPos2D = local3DToGlobal(toVector3D(startPos));
					endPos2D = local3DToGlobal(toVector3D(endPos));
					
					swipeGesturesContainer.graphics.lineStyle(1, 0xff00ff);
					swipeGesturesContainer.graphics.moveTo(startPos2D.x, startPos2D.y);
					swipeGesturesContainer.graphics.lineTo(endPos2D.x, endPos2D.y);
				}
			}
		}
		
		private function toVector3D(vec3:Vector3):Vector3D
		{
			return new Vector3D(stage.stageWidth * .5 + vec3.x, stage.stageHeight - vec3.y, -vec3.z);
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
			root.transform.perspectiveProjection.projectionCenter = new Point( stage.stageWidth * .5, stage.stageHeight * .5 );
		}
	}
}
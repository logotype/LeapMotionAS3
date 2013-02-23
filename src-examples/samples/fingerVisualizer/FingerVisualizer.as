package samples.fingerVisualizer
{
	import com.leapmotion.leap.Gesture;
	import com.leapmotion.leap.LeapMotion;
	import com.leapmotion.leap.Pointable;
	import com.leapmotion.leap.ScreenTapGesture;
	import com.leapmotion.leap.Vector3;
	import com.leapmotion.leap.events.LeapEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	[SWF(frameRate=60)]
	public class FingerVisualizer extends Sprite
	{
		
		private static const RAD_TO_DEG:Number = 180 / Math.PI;
		
		private var leap:LeapMotion;
		private var container:Sprite;
		private var gesturesContainer:Sprite;
		
		public function FingerVisualizer()
		{
			container = new Sprite();
			container.mouseChildren = container.mouseEnabled = false;
			addChild(container);
			
			gesturesContainer = new Sprite();
			gesturesContainer.mouseChildren = container.mouseEnabled = false;
			addChild(gesturesContainer);
			
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
			container.graphics.clear();
			var m:Matrix3D = new Matrix3D();
			for each ( var pointable:Pointable in event.frame.pointables )
			{
				var startPos:Vector3 = pointable.tipPosition;
				var endPos:Vector3 = pointable.tipPosition.minus(pointable.direction.multiply(pointable.length));
				
				var startPos2D:Point = local3DToGlobal(toVector3D(startPos));
				var endPos2D:Point = local3DToGlobal(toVector3D(endPos));
				
				container.graphics.beginFill(0xff0000);
				container.graphics.lineStyle();
				container.graphics.drawCircle(startPos2D.x, startPos2D.y, 6);
				container.graphics.endFill();
				
				container.graphics.lineStyle(1);
				container.graphics.moveTo(startPos2D.x, startPos2D.y);
				container.graphics.lineTo(endPos2D.x, endPos2D.y);
			}
			for each ( var gesture:Gesture in event.frame._gestures )
			{
				if(gesture is ScreenTapGesture )
				{
					var screenTapGesture:ScreenTapGesture = gesture as ScreenTapGesture;
					var pos2D:Point = local3DToGlobal(toVector3D(screenTapGesture.position));
					
					gesturesContainer.graphics.lineStyle(2, 0x00ff00);
					gesturesContainer.graphics.drawCircle(pos2D.x, pos2D.y, 30);
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
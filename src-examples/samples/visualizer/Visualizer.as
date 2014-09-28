package samples.visualizer
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.WireframePlane;

	import com.leapmotion.leap.Frame;
	import com.leapmotion.leap.Hand;
	import com.leapmotion.leap.Controller;
	import com.leapmotion.leap.Pointable;
	import com.leapmotion.leap.Vector3;
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.util.LeapUtil;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	[SWF(frameRate=60)]
	public class Visualizer extends Sprite
	{

		private var _view:View3D;
		private var lightPicker:StaticLightPicker;

		private var controller:Controller;

		private var trails:Vector.<Trail>;
		private var pointable3Ds:Vector.<Pointable3D>;
		private var numPointable3Ds:int = 20;

		private var palm3Ds:Vector.<Mesh>;
		private var numPalm3Ds:int = 4;

		public function Visualizer()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			_view = new View3D();
			_view.backgroundColor = 0xffffff;
			addChild( _view );

			_view.camera.y = 400;
			_view.camera.z = -500;
			_view.camera.lookAt( new Vector3D( 0, 50, 0 ) );
			_view.camera.lens = new PerspectiveLens( 50 );

			_view.antiAlias = 2;

			var backPlane:WireframePlane = new WireframePlane( 500, 300, 10, 6, 0x999999, 1, "xy" );
			backPlane.y = 150;
			_view.scene.addChild( backPlane );
			var floorPlane:WireframePlane = new WireframePlane( 500, 300, 10, 6, 0x999999, 1, "xz" );
			floorPlane.z = -150;
			_view.scene.addChild( floorPlane );

			var light1:DirectionalLight = new DirectionalLight();
			_view.scene.addChild( light1 );
			lightPicker = new StaticLightPicker( [light1] );

			var sphereMaterial:ColorMaterial = new ColorMaterial( 0xff0000 );
			sphereMaterial.lightPicker = lightPicker;
			pointable3Ds = new Vector.<Pointable3D>();
			trails = new Vector.<Trail>();
			var i:int = 0;
			for ( i; i < numPointable3Ds; i++ )
			{
				var pointable3D:Pointable3D = new Pointable3D( sphereMaterial );
				pointable3D.visible = false;
				pointable3Ds.push( pointable3D );
				_view.scene.addChild( pointable3D );
				var trail:Trail = new Trail();
				trails.push( trail );
				_view.scene.addChild( trail );
			}

			var palmMaterial:ColorMaterial = new ColorMaterial( 0x0000ff );
			palmMaterial.lightPicker = lightPicker;
			palm3Ds = new Vector.<Mesh>();
			for ( i = 0; i < numPalm3Ds; i++ )
			{
				var palm3D:Mesh = new Trident( 100 );
				palm3D.visible = false;
				palm3Ds.push( palm3D );
				_view.scene.addChild( palm3D );
			}

			controller = new Controller();
			controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, leapmotionFrameHandler );
			controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, leapmotionConnectedHandler );

			addEventListener( Event.ENTER_FRAME, _onEnterFrame );
			stage.addEventListener( Event.RESIZE, onResize );
			onResize();
		}

		private function leapmotionConnectedHandler( event:LeapEvent ):void
		{
			trace( "connected" );
		}

		private function leapmotionFrameHandler( event:LeapEvent ):void
		{
			var numPointables:int = event.frame.pointables.length;
			var previousFrame:Frame = controller.frame( 1 );
			var hasPreviousFrame:Boolean = (previousFrame != null && previousFrame.isValid());
			var i:int;
			for ( i = 0; i < numPointable3Ds; i++ )
			{
				var pointable3D:Pointable3D = pointable3Ds[i];
				var trail:Trail = trails[i];
				if ( i < numPointables )
				{
					var pointable:Pointable = event.frame.pointables[i];

					var dir:Vector3 = pointable.direction;

					pointable3D.x = pointable.tipPosition.x;
					pointable3D.y = pointable.tipPosition.y;
					pointable3D.z = -pointable.tipPosition.z;

					pointable3D.rotationX = -LeapUtil.RAD_TO_DEG * dir.pitch;
					pointable3D.rotationY = LeapUtil.RAD_TO_DEG * dir.yaw;
					//rotationZ is not usable

					pointable3D.visible = true;

					if ( hasPreviousFrame )
					{
						var previousPointable:Pointable = previousFrame.pointable( pointable.id );
						if ( previousPointable && previousPointable.isValid() )
						{
							trail.getLineSegment().updateSegment(
									createVector3D( previousPointable.tipPosition ),
									createVector3D( pointable.tipPosition ),
									new Vector3D(),
									0xff0000,
									0xff0000,
									2 );
						}
					}
				}
				else
				{
					pointable3D.visible = false;
					trail.getLineSegment().updateSegment( new Vector3D(), new Vector3D(), new Vector3D(), 0, 0, 0 );
				}
			}
			var numHands:int = event.frame.hands.length;
			for ( i = 0; i < numPalm3Ds; i++ )
			{
				var palm3D:Mesh = palm3Ds[i];
				if ( i < numHands )
				{
					var hand:Hand = event.frame.hands[i];

					palm3D.x = hand.palmPosition.x;
					palm3D.y = hand.palmPosition.y;
					palm3D.z = -hand.palmPosition.z;

					palm3D.rotationX = -LeapUtil.RAD_TO_DEG * hand.palmNormal.pitch - 90;
					palm3D.rotationY = LeapUtil.RAD_TO_DEG * hand.direction.yaw;
					palm3D.rotationZ = LeapUtil.RAD_TO_DEG * hand.palmNormal.roll;

					//palm3D.visible = true;
				}
				else
				{
					palm3D.visible = false;
				}
			}
		}

		private function createVector3D( vec3:Vector3 ):Vector3D
		{
			return new Vector3D( vec3.x, vec3.y, -vec3.z );
		}

		private function _onEnterFrame( e:Event ):void
		{
			_view.render();
		}

		private function onResize( event:Event = null ):void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
		}
	}
}

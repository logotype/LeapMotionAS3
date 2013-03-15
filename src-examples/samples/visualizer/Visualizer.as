/**
 * Created with IntelliJ IDEA.
 * User: wouter
 * Date: 12/03/13
 * Time: 12:27
 * To change this template use File | Settings | File Templates.
 */
package samples.visualizer
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.WireframePlane;

	import com.leapmotion.leap.Hand;

	import com.leapmotion.leap.LeapMotion;
	import com.leapmotion.leap.Pointable;
	import com.leapmotion.leap.Vector3;
	import com.leapmotion.leap.events.LeapEvent;
	import com.leapmotion.leap.util.LeapMath;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import samples.visualizer.Pointable3D;

	[SWF(frameRate=60)]
	public class Visualizer extends Sprite
	{

		private var _view:View3D;
		private var lightPicker:StaticLightPicker;

		private var leap:LeapMotion;

		private var pointable3Ds:Vector.<Pointable3D>;
		private var numSpheres:int = 20;

		private var palm3Ds:Vector.<Mesh>;
		private var numPalms:int = 4;

		public function Visualizer()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			_view = new View3D();
			_view.backgroundColor = 0xffffff;
			addChild( _view );

			_view.camera.z = -600;
			_view.camera.y = 200;
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
			//var geometry:ConeGeometry = new ConeGeometry(10, 50);
			//var geometry:CubeGeometry = new CubeGeometry(10, 10, 50);
			//var sphere:SphereGeometry = new SphereGeometry( 10, 16, 12, true );
			var i:int = 0;
			for ( i = 0; i < numSpheres; i++ )
			{
				var pointable3D:Pointable3D = new Pointable3D(sphereMaterial);
				pointable3D.visible = false;
				pointable3Ds.push( pointable3D );
				_view.scene.addChild( pointable3D );
			}

			var i:int = 0;
			for ( i = 0; i < numPalms; i++ )
			{
				var pointable3D:Pointable3D = new Pointable3D(sphereMaterial);
				pointable3D.visible = false;
				pointable3Ds.push( pointable3D );
				_view.scene.addChild( pointable3D );
			}

			leap = new LeapMotion();
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, leapmotionFrameHandler );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, leapmotionConnectedHandler );

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
			var i:int;
			for ( i = 0; i < numSpheres; i++ )
			{
				var pointable3D:Pointable3D = pointable3Ds[i];
				if ( i < numPointables )
				{
					var pointable:Pointable = event.frame.pointables[i];
					//startPos = pointable.tipPosition;
					//endPos = pointable.tipPosition.minus(pointable.direction.multiply(pointable.length));

					var dir:Vector3 = pointable.direction;

					pointable3D.x = pointable.tipPosition.x;
					pointable3D.y = pointable.tipPosition.y;
					pointable3D.z = -pointable.tipPosition.z;

					//pointable3D.rotationX = 90 - LeapMath.RAD_TO_DEG * dir.pitch;
					//pointable3D.rotationX = 90;
					//pointable3D.rotationX = LeapMath.RAD_TO_DEG * dir.pitch;
					//pointable3D.rotationY = LeapMath.RAD_TO_DEG * dir.yaw;
					//pointable3D.rotationZ = LeapMath.RAD_TO_DEG * dir.roll;

					pointable3D.visible = true;
				}
				else
				{
					pointable3D.visible = false;
				}
			}
			var numHands:int = event.frame.hands.length;
			for( i = 0; i < numHands; i++ )
			{
				var hand:Hand = event.frame.hands[i];
			}
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

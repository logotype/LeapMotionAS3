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
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.WireframePlane;

	import com.leapmotion.leap.LeapMotion;
	import com.leapmotion.leap.events.LeapEvent;

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

		private var leap:LeapMotion;

		private var sphereMeshes:Vector.<Mesh>;
		private var numSpheres:int = 20;

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
			sphereMeshes = new Vector.<Mesh>();
			var sphere:SphereGeometry = new SphereGeometry( 10, 16, 12, true );
			for ( var i:int = 0; i < numSpheres; i++ )
			{
				var sphereMesh:Mesh = new Mesh( sphere, sphereMaterial );
				sphereMesh.visible = false;
				sphereMeshes.push( sphereMesh );
				_view.scene.addChild( sphereMesh );
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
			for ( var i:int = 0; i < numSpheres; i++ )
			{
				var sphereMesh:Mesh = sphereMeshes[i];
				if ( i < numPointables )
				{
					sphereMesh.x = event.frame.pointables[i].tipPosition.x;
					sphereMesh.y = event.frame.pointables[i].tipPosition.y;
					sphereMesh.z = -event.frame.pointables[i].tipPosition.z;
					sphereMesh.visible = true;
				}
				else
				{
					sphereMesh.visible = false;
				}
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

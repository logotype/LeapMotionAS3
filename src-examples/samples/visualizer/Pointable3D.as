/**
 * Created with IntelliJ IDEA.
 * User: wouter
 * Date: 12/03/13
 * Time: 16:35
 * To change this template use File | Settings | File Templates.
 */
package samples.visualizer
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.SphereGeometry;

	public class Pointable3D extends ObjectContainer3D
	{

		private static var tipGeometry:SphereGeometry = new SphereGeometry(15);
		private static var lengthGeometry:CubeGeometry = new CubeGeometry(10, 10, 50);

		private var tipMesh:Mesh;
		private var lengthMesh:Mesh;

		public function Pointable3D(m:MaterialBase)
		{
			lengthMesh = new Mesh(lengthGeometry, m);
			lengthMesh.z = -25;
			addChild(lengthMesh);

			tipMesh = new Mesh(tipGeometry, m);
			addChild(tipMesh);

			//addChild(new Trident(100));
		}
	}
}

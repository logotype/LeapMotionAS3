/**
 * Created with IntelliJ IDEA.
 * User: wouter
 * Date: 15/03/13
 * Time: 16:01
 * To change this template use File | Settings | File Templates.
 */
package samples.visualizer
{
	import away3d.entities.SegmentSet;
	import away3d.primitives.LineSegment;

	import flash.geom.Vector3D;

	public class Trail extends SegmentSet
	{

		private var _maxLength:uint;
		private var _counter:int;

		public function Trail( maxLength:uint = 100 )
		{
			_maxLength = maxLength;
			for ( var i:int = 0; i < _maxLength; i++ )
			{
				addSegment( new LineSegment( new Vector3D(), new Vector3D(), 0xff0000, 0xff0000, 2 ) );
			}
		}

		public function getLineSegment():LineSegment
		{
			var lineSegment:LineSegment = getSegment( _counter % _maxLength ) as LineSegment;
			_counter++;
			return lineSegment;
		}
	}
}

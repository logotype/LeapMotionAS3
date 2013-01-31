package com.leapmotion.leap
{
	import com.leapmotion.leap.util.LeapMath;

	/**
	 * The Frame class represents a set of hand and finger tracking
	 * data detected in a single frame.
	 *
	 * The Leap detects hands, fingers and tools within the tracking area,
	 * reporting their positions, orientations and motions in frames at
	 * the Leap frame rate.
	 *
	 * Access Frame objects through a listener of a Leap Controller.
	 * Add a listener to receive events when a new Frame is available.
	 *
	 * @author logotype
	 *
	 */
	public class Frame
	{
		/**
		 * The Finger object with the specified ID in this frame.
		 * @see Finger
		 */
		public var finger:Finger;

		/**
		 * The list of Finger objects detected in this frame, given in arbitrary order.
		 */
		public var fingers:Vector.<Pointable> = new Vector.<Pointable>();

		/**
		 * The Hand object with the specified ID in this frame.
		 */
		public var hand:Hand;

		/**
		 * The list of Hand objects detected in this frame, given in arbitrary order.
		 */
		public var hands:Vector.<Hand> = new Vector.<Hand>();

		/**
		 * A unique ID for this Frame.
		 */
		public var id:int;

		/**
		 * The frame capture time in microseconds elapsed since the Leap started.
		 */
		public var timestamp:Number;

		/**
		 * The Tool object with the specified ID in this frame.
		 */
		public var tool:Tool;

		/**
		 * The list of Tool objects detected in this frame, given in arbitrary order.
		 */
		public var tools:Vector.<Pointable> = new Vector.<Pointable>();

		/**
		 * Rotation matrix.
		 */
		public var rotation:Matrix;

		/**
		 * Scale factor since last Frame.
		 */
		public var scaleFactor:Number;

		/**
		 * Translation since last Frame.
		 */
		public var _translation:Vector3;

		public function Frame()
		{
		}

		/**
		 * The axis of rotation derived from the change in orientation
		 * of this hand, and any associated fingers and tools,
		 * between the current frame and the specified frame.
		 *
		 * The returned direction vector is normalized.
		 *
		 * If a corresponding Hand object is not found in sinceFrame,
		 * or if either this frame or sinceFrame are invalid Frame objects,
		 * then this method returns a zero vector.
		 *
		 * @param sinceFrame The starting frame for computing the relative rotation.
		 * @return A normalized direction Vector representing the heuristically
		 * determined axis of rotational change of the hand between the current
		 * frame and that specified in the sinceFrame parameter.
		 *
		 */
		public function rotationAxis( sinceFrame:Frame ):Vector3
		{
			var returnValue:Vector3 = new Vector3( 0, 0, 0 );

			if ( sinceFrame )
			{
				var vector:Vector3 = new Vector3( rotation.zBasis.y - sinceFrame.rotation.yBasis.z, rotation.xBasis.z - sinceFrame.rotation.zBasis.x, rotation.yBasis.x - sinceFrame.rotation.xBasis.y );
				returnValue = LeapMath.normalizeVector( vector );
			}

			return returnValue;
		}

		/**
		 * The angle of rotation around the rotation axis derived from the
		 * overall rotational motion between the current frame and the specified frame.
		 *
		 * The returned angle is expressed in radians measured clockwise around
		 * the rotation axis (using the right-hand rule) between the
		 * start and end frames. The value is always between 0 and pi radians (0 and 180 degrees).
		 *
		 * The Leap derives frame rotation from the relative change in position
		 * and orientation of all objects detected in the field of view.
		 *
		 * If either this frame or sinceFrame is an invalid Frame object,
		 * then the angle of rotation is zero.
		 *
		 * @param sinceFrame The starting frame for computing the relative rotation.
		 * @param axis Optional. The axis to measure rotation around.
		 * @return A positive value containing the heuristically determined rotational
		 * change between the current frame and that specified in the sinceFrame parameter.
		 *
		 */
		public function rotationAngle( sinceFrame:Frame, axis:Vector3 = null ):Number
		{
			// TODO: Implement rotation angle around axis
			var returnValue:Number = 0;
			var rotationSinceFrameMatrix:Matrix = rotationMatrix( sinceFrame );
			var cs:Number = ( rotationSinceFrameMatrix.xBasis.x + rotationSinceFrameMatrix.yBasis.y + rotationSinceFrameMatrix.zBasis.z ) * 0.5;
			var angle:Number = Math.acos( cs );
			returnValue = angle;
			return returnValue;
		}

		/**
		 * The transform matrix expressing the rotation derived from
		 * the change in orientation of this hand, and any associated
		 * fingers and tools, between the current frame and the specified frame.
		 *
		 * If a corresponding Hand object is not found in sinceFrame,
		 * or if either this frame or sinceFrame are invalid Frame objects,
		 * then this method returns an identity matrix.
		 *
		 * @param sinceFrame
		 * @return
		 *
		 */
		public function rotationMatrix( sinceFrame:Frame ):Matrix
		{
			var returnValue:Matrix = new Matrix();

			if ( sinceFrame.rotation )
				returnValue = rotation.multiply( sinceFrame.rotation );

			return returnValue;
		}

		/**
		 * The change of position of this hand between the current frame and the specified frame.
		 * @param sinceFrame The starting frame for computing the translation.
		 * @return A Vector representing the heuristically determined change
		 * in hand position between the current frame and that specified
		 * in the sinceFrame parameter.
		 *
		 */
		public function translation( sinceFrame:Frame ):Vector3
		{
			var returnValue:Vector3 = new Vector3( 0, 0, 0 );

			if ( sinceFrame._translation )
				returnValue = new Vector3( _translation.x - sinceFrame._translation.x, _translation.y - sinceFrame._translation.y, _translation.z - sinceFrame._translation.z );

			return returnValue;
		}
	}
}

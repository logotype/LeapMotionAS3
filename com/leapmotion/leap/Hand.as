package com.leapmotion.leap
{
	import com.leapmotion.leap.util.LeapMath;

	/**
	 * The Hand class reports the physical characteristics of a detected hand.
	 *
	 * Hand tracking data includes a palm position and velocity; vectors for
	 * the palm normal and direction to the fingers; properties of a sphere fit
	 * to the hand; and lists of the attached fingers and tools.
	 *
	 * Note that Hand objects can be invalid, which means that they do not
	 * contain valid tracking data and do not correspond to a physical entity.
	 * Invalid Hand objects can be the result of asking for a Hand object using
	 * an ID from an earlier frame when no Hand objects with that ID exist in
	 * the current frame. A Hand object created from the Hand constructor is
	 * also invalid. Test for validity with the Hand.isValid() function.
	 *
	 * @author logotype
	 *
	 */
	public class Hand
	{
		/**
		 * The direction from the palm position toward the fingers.
		 */
		public var direction:Vector3;

		/**
		 * The list of Finger objects detected in this frame that are attached to this hand, given in arbitrary order.
		 */
		public var fingers:Vector.<Finger> = new Vector.<Finger>();

		/**
		 * The Frame associated with this Hand.
		 * @see Frame
		 */
		public var frame:Frame;

		/**
		 * A unique ID assigned to this Hand object, whose value remains the same across consecutive frames while the tracked hand remains visible.
		 */
		public var id:Number;

		/**
		 * The normal vector to the palm.
		 */
		public var palmNormal:Vector3;

		/**
		 * The center position of the palm in millimeters from the Leap origin.
		 */
		public var palmPosition:Vector3;

		/**
		 * The rate of change of the palm position in millimeters/second.
		 */
		public var palmVelocity:Vector3;

		/**
		 * The list of Pointable objects (fingers and tools) detected in this
		 * frame that are associated with this hand, given in arbitrary order.
		 *
		 * The list can be empty if no fingers or tools associated with this hand are detected.
		 * Use the Pointable.isFinger() function to determine whether or not an item in the
		 * list represents a finger. Use the Pointable.isTool() function to determine
		 * whether or not an item in the list represents a tool. You can also get
		 * only fingers using the Hand.fingers() function or only tools using
		 * the Hand.tools() function.
		 *
		 */
		public var pointables:Vector.<Pointable> = new Vector.<Pointable>();

		/**
		 * The center of a sphere fit to the curvature of this hand.
		 */
		public var sphereCenter:Vector3;
		/**
		 * The radius of a sphere fit to the curvature of this hand.
		 */
		public var sphereRadius:Number;

		/**
		 * The list of Tool objects detected in this frame that are held by this hand, given in arbitrary order.
		 */
		public var tools:Vector.<Tool> = new Vector.<Tool>();

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
		public var translationVector:Vector3;

		public function Hand()
		{
		}

		/**
		 * Reports whether this is a valid Hand object.
		 * @return True, if this Hand object contains valid tracking data.
		 *
		 */
		public function isValid():Boolean
		{
			var returnValue:Boolean = true;

			if ( !direction.isValid())
				returnValue = false;

			if ( !palmNormal.isValid())
				returnValue = false;

			if ( !palmPosition.isValid())
				returnValue = false;

			if ( !palmVelocity.isValid())
				returnValue = false;

			if ( !sphereCenter.isValid())
				returnValue = false;

			return returnValue;
		}

		/**
		 * The Finger object with the specified ID attached to this hand.
		 *
		 * Use the Hand.finger() function to retrieve a Finger object attached
		 * to this hand using an ID value obtained from a previous frame.
		 * This function always returns a Finger object, but if no finger
		 * with the specified ID is present, an invalid Finger object is returned.
		 *
		 * Note that ID values persist across frames, but only until tracking of
		 * a particular object is lost. If tracking of a finger is lost and
		 * subsequently regained, the new Finger object representing that
		 * finger may have a different ID than that representing the finger in an earlier frame.
		 *
		 * @param id The ID value of a Finger object from a previous frame.
		 * @return The Finger object with the matching ID if one exists for
		 * this hand in this frame; otherwise, an invalid Finger object is returned.
		 *
		 */
		public function finger( id:int ):Finger
		{
			var returnValue:Finger = Finger( Pointable.invalid());
			returnValue.isFinger = true;
			returnValue.isTool = false;
			var i:int = 0;
			var length:int = fingers.length;

			for ( i; i < length; ++i )
			{
				if ( fingers[ i ].id == id )
				{
					returnValue = fingers[ i ];
					break;
				}
			}

			return returnValue;
		}

		/**
		 * The Tool object with the specified ID held by this hand.
		 *
		 * Use the Hand.tool() function to retrieve a Tool object held
		 * by this hand using an ID value obtained from a previous frame.
		 * This function always returns a Tool object, but if no tool
		 * with the specified ID is present, an invalid Tool object is returned.
		 *
		 * Note that ID values persist across frames, but only until
		 * tracking of a particular object is lost. If tracking of a tool
		 * is lost and subsequently regained, the new Tool object
		 * representing that tool may have a different ID than that
		 * representing the tool in an earlier frame.
		 *
		 * @param id The ID value of a Tool object from a previous frame.
		 * @return The Tool object with the matching ID if one exists for
		 * this hand in this frame; otherwise, an invalid Tool object is returned.
		 *
		 */
		public function tool( id:int ):Tool
		{
			var returnValue:Tool = Tool( Pointable.invalid());
			returnValue.isFinger = false;
			returnValue.isTool = true;
			var i:int = 0;
			var length:int = fingers.length;

			for ( i; i < length; ++i )
			{
				if ( tools[ i ].id == id )
				{
					returnValue = tools[ i ];
					break;
				}
			}

			return returnValue;
		}

		/**
		 * The Pointable object with the specified ID associated with this hand.
		 *
		 * Use the Hand::pointable() function to retrieve a Pointable object
		 * associated with this hand using an ID value obtained from a previous frame.
		 * This function always returns a Pointable object, but if no finger or
		 * tool with the specified ID is present, an invalid Pointable object is returned.
		 *
		 * Note that ID values persist across frames, but only until tracking
		 * of a particular object is lost. If tracking of a finger or tool is
		 * lost and subsequently regained, the new Pointable object representing
		 * that finger or tool may have a different ID than that representing
		 * the finger or tool in an earlier frame.
		 *
		 * @param id
		 * @return
		 *
		 */
		public function pointable( id:int ):Pointable
		{
			var returnValue:Pointable = Pointable.invalid();
			var i:int = 0;
			var length:int = pointables.length;

			for ( i; i < length; ++i )
			{
				if ( pointables[ i ].id == id )
				{
					returnValue = pointables[ i ];
					break;
				}
			}

			return returnValue;
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

			if ( sinceFrame.hand )
			{
				var vector:Vector3 = new Vector3( this.rotation.zBasis.y - sinceFrame.hand.rotation.yBasis.z, this.rotation.xBasis.z - sinceFrame.hand.rotation.zBasis.x, this.rotation.yBasis.x - sinceFrame.hand.rotation.xBasis.y );
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
			if ( sinceFrame.hand && sinceFrame.hand.frame )
			{
				var rotationSinceFrameMatrix:Matrix = rotationMatrix( sinceFrame.hand.frame );
				var cs:Number = ( rotationSinceFrameMatrix.xBasis.x + rotationSinceFrameMatrix.yBasis.y + rotationSinceFrameMatrix.zBasis.z ) * 0.5;
				var angle:Number = Math.acos( cs );
				returnValue = angle;
			}
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

			if ( sinceFrame.hand && sinceFrame.hand.rotation )
				returnValue = rotation.multiply( sinceFrame.hand.rotation );

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

			if ( sinceFrame.hand && sinceFrame.hand.translationVector )
				returnValue = new Vector3( translationVector.x - sinceFrame.hand.translationVector.x, translationVector.y - sinceFrame.hand.translationVector.y, translationVector.z - sinceFrame.hand.translationVector.z );

			return returnValue;
		}
	}
}

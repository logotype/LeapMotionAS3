package com.leapmotion.leap
{
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
		 * @see Finger
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
		public var id:int;

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
		 * @see Pointable
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
		 * @see Tool
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
			var returnValue:Boolean = false;

			if ( ( direction && direction.isValid()) && ( palmNormal && palmNormal.isValid()) && ( palmPosition && palmPosition.isValid()) && ( palmVelocity && palmVelocity.isValid()) && ( sphereCenter && sphereCenter.isValid()) )
				returnValue = true;

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
		 * @see Finger
		 *
		 */
		public function finger( id:int ):Finger
		{
			var returnValue:Finger = Finger.invalid();
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
		 * @see Tool
		 *
		 */
		public function tool( id:int ):Tool
		{
			var returnValue:Tool = Tool.invalid();
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
		 * @see Pointable
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
		 * @see Vector3
		 *
		 */
		public function rotationAxis( sinceFrame:Frame ):Vector3
		{
			var returnValue:Vector3 = new Vector3( 0, 0, 0 );

			if ( sinceFrame.hand( id ) )
			{
				var vector:Vector3 = new Vector3( this.rotation.zBasis.y - sinceFrame.hand( id ).rotation.yBasis.z, this.rotation.xBasis.z - sinceFrame.hand( id ).rotation.zBasis.x, this.rotation.yBasis.x - sinceFrame.hand( id ).rotation.xBasis.y );
				returnValue = vector.normalized();
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
			if ( sinceFrame.hand( id ) && sinceFrame.hand( id ).frame )
			{
				var rotationSinceFrameMatrix:Matrix = rotationMatrix( sinceFrame.hand( id ).frame );
				var cs:Number = ( rotationSinceFrameMatrix.xBasis.x + rotationSinceFrameMatrix.yBasis.y + rotationSinceFrameMatrix.zBasis.z ) * 0.5;
<<<<<<< HEAD
				var angle:Number = Math.acos( cs );
				returnValue = ( isNaN( angle ) ? 0 : angle );
=======
				return Math.acos( cs );
>>>>>>> upstream/master
			}
			return 0;
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
		 * @return A transformation Matrix representing the heuristically
		 * determined rotational change of the hand between the current
		 * frame and that specified in the sinceFrame parameter.
		 * @see Matrix
		 * @see Frame
		 *
		 */
		public function rotationMatrix( sinceFrame:Frame ):Matrix
		{
			var returnValue:Matrix = Matrix.identity();

			if ( sinceFrame.hand( id ) && sinceFrame.hand( id ).rotation )
				returnValue = rotation.multiply( sinceFrame.hand( id ).rotation );

			return returnValue;
		}

		/**
		 * The change of position of this hand between the current frame and the specified frame.
		 *
		 * @param sinceFrame The starting frame for computing the translation.
		 * @return A Vector representing the heuristically determined change
		 * in hand position between the current frame and that specified
		 * in the sinceFrame parameter.
		 * @see Vector3
		 *
		 */
		public function translation( sinceFrame:Frame ):Vector3
		{
			var returnValue:Vector3 = new Vector3( 0, 0, 0 );

			if ( sinceFrame.hand( id ) && sinceFrame.hand( id ).translationVector )
				returnValue = new Vector3( translationVector.x - sinceFrame.hand( id ).translationVector.x, translationVector.y - sinceFrame.hand( id ).translationVector.y, translationVector.z - sinceFrame.hand( id ).translationVector.z );

			return returnValue;
		}

		/**
		 * Returns an invalid Hand object.
		 *
		 * You can use the instance returned by this function in comparisons
		 * testing whether a given Hand instance is valid or invalid.
		 * (You can also use the Hand::isValid() function.)
		 *
		 * @return The invalid Hand instance.
		 *
		 */
		static public function invalid():Hand
		{
			return new Hand();
		}
	}
}

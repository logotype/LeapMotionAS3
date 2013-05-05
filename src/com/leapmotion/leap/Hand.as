package com.leapmotion.leap
{
	/**
	 * The Hand class reports the physical characteristics of a detected hand.
	 *
	 * <p>Hand tracking data includes a palm position and velocity; vectors for
	 * the palm normal and direction to the fingers; properties of a sphere fit
	 * to the hand; and lists of the attached fingers and tools.</p>
	 *
	 * <p>Note that Hand objects can be invalid, which means that they do not
	 * contain valid tracking data and do not correspond to a physical entity.
	 * Invalid Hand objects can be the result of asking for a Hand object using
	 * an ID from an earlier frame when no Hand objects with that ID exist in
	 * the current frame. A Hand object created from the Hand constructor is
	 * also invalid. Test for validity with the <code>Hand.isValid()</code> function.</p>
	 *
	 * @author logotype
	 *
	 */
	public class Hand
	{
		/**
		 * The direction from the palm position toward the fingers.
		 * 
		 * <p>The direction is expressed as a unit vector pointing in the same
		 * direction as the directed line from the palm position to the fingers.</p> 
		 */
		public var direction:Vector3;

		/**
		 * The list of Finger objects detected in this frame that are attached
		 * to this hand, given in arbitrary order.
		 * @see Finger
		 */
		public var fingers:Vector.<Finger> = new Vector.<Finger>();

		/**
		 * The Frame associated with this Hand.
		 * @see Frame
		 */
		public var frame:Frame;

		/**
		 * A unique ID assigned to this Hand object, whose value remains
		 * the same across consecutive frames while the tracked hand remains visible.
		 * 
		 * <p>If tracking is lost (for example, when a hand is occluded by another
		 * hand or when it is withdrawn from or reaches the edge of the Leap field
		 * of view), the Leap may assign a new ID when it detects the hand in a future frame.</p>
		 * 
		 * <p>Use the ID value with the <code>Frame.hand()</code> function to find this Hand object
		 * in future frames.</p> 
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
		 * <p>The list can be empty if no fingers or tools associated with this hand are detected.
		 * Use the <code>Pointable.isFinger()</code> function to determine whether or not an item in the
		 * list represents a finger. Use the <code>Pointable.isTool()</code> function to determine
		 * whether or not an item in the list represents a tool. You can also get
		 * only fingers using the <code>Hand.fingers()</code> function or only tools using
		 * the <code>Hand.tools()</code> function.</p>
		 * 
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
		 * @private
		 * Scale factor since last Frame.
		 */
		public var scaleFactorNumber:Number;

		/**
		 * @private
		 * Translation since last Frame.
		 */
		public var translationVector:Vector3;

		/**
		 * @private
		 * Reference to the Controller which created this object. 
		 */
		public var controller:Controller;

		/**
		 * Constructs a Hand object.
		 * 
		 * <p>An uninitialized hand is considered invalid.
		 * 
		 * Get valid Hand objects from a Frame object.</p> 
		 * 
		 */
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
		 * Compare Hand object equality/inequality.
		 * 
		 * <p>Two Hand objects are equal if and only if both Hand objects
		 * represent the exact same physical hand in the same frame
		 * and both Hand objects are valid.</p>
		 *  
		 * @param other The Hand object to compare with.
		 * @return True; if equal. False otherwise.
		 * 
		 */
		public function isEqualTo( other:Hand ):Boolean
		{
			var returnValue:Boolean = false;

			if( id == other.id && frame == other.frame && isValid() && other.isValid() )
				returnValue = true;
			
			return returnValue;
		}
		
		/**
		 * The Finger object with the specified ID attached to this hand.
		 *
		 * <p>Use the <code>Hand.finger()</code> function to retrieve a Finger object attached
		 * to this hand using an ID value obtained from a previous frame.
		 * This function always returns a Finger object, but if no finger
		 * with the specified ID is present, an invalid Finger object is returned.</p>
		 *
		 * <p>Note that ID values persist across frames, but only until tracking of
		 * a particular object is lost. If tracking of a finger is lost and
		 * subsequently regained, the new Finger object representing that
		 * finger may have a different ID than that representing the finger in an earlier frame.</p>
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
		 * <p>Use the <code>Hand.tool()</code> function to retrieve a Tool object held
		 * by this hand using an ID value obtained from a previous frame.
		 * This function always returns a Tool object, but if no tool
		 * with the specified ID is present, an invalid Tool object is returned.</p>
		 *
		 * <p>Note that ID values persist across frames, but only until
		 * tracking of a particular object is lost. If tracking of a tool
		 * is lost and subsequently regained, the new Tool object
		 * representing that tool may have a different ID than that
		 * representing the tool in an earlier frame.</p>
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
		 * <p>Use the <code>Hand.pointable()</code> function to retrieve a Pointable object
		 * associated with this hand using an ID value obtained from a previous frame.
		 * This function always returns a Pointable object, but if no finger or
		 * tool with the specified ID is present, an invalid Pointable object is returned.</p>
		 *
		 * <p>Note that ID values persist across frames, but only until tracking
		 * of a particular object is lost. If tracking of a finger or tool is
		 * lost and subsequently regained, the new Pointable object representing
		 * that finger or tool may have a different ID than that representing
		 * the finger or tool in an earlier frame.</p>
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
		 * <p>The returned direction vector is normalized.</p>
		 *
		 * <p>If a corresponding Hand object is not found in sinceFrame,
		 * or if either this frame or sinceFrame are invalid Frame objects,
		 * then this method returns a zero vector.</p>
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
			var returnValue:Vector3;

			if ( sinceFrame.hand( id ) )
			{
				var vector:Vector3 = new Vector3( rotation.zBasis.y - sinceFrame.hand( id ).rotation.yBasis.z, rotation.xBasis.z - sinceFrame.hand( id ).rotation.zBasis.x, rotation.yBasis.x - sinceFrame.hand( id ).rotation.xBasis.y );
				returnValue = vector.normalized();
			}
			else
			{
				returnValue = new Vector3( 0, 0, 0 );
			}

			return returnValue;
		}

		/**
		 * The angle of rotation around the rotation axis derived from the
		 * overall rotational motion between the current frame and the specified frame.
		 *
		 * <p>The returned angle is expressed in radians measured clockwise around
		 * the rotation axis (using the right-hand rule) between the
		 * start and end frames. The value is always between 0 and pi radians (0 and 180 degrees).</p>
		 *
		 * <p>The Leap derives frame rotation from the relative change in position
		 * and orientation of all objects detected in the field of view.</p>
		 *
		 * <p>If either this frame or sinceFrame is an invalid Frame object,
		 * then the angle of rotation is zero.</p>
		 *
		 * @param sinceFrame The starting frame for computing the relative rotation.
		 * @param axis Optional. The axis to measure rotation around.
		 * @return A positive value containing the heuristically determined rotational
		 * change between the current frame and that specified in the sinceFrame parameter.
		 *
		 */
		public function rotationAngle( sinceFrame:Frame, axis:Vector3 = null ):Number
		{
			if ( !isValid() || !sinceFrame.isValid() )
				return 0;
			
			var returnValue:Number = 0;

			if ( sinceFrame.hand( id ).isValid() && sinceFrame.hand( id ).frame )
			{
				var rotationSinceFrameMatrix:Matrix = rotationMatrix( sinceFrame.hand( id ).frame );
				var cs:Number = ( rotationSinceFrameMatrix.xBasis.x + rotationSinceFrameMatrix.yBasis.y + rotationSinceFrameMatrix.zBasis.z ) * 0.5;
				var angle:Number = Math.acos( cs );
				returnValue = isNaN( angle ) ? 0 : angle;

				if( axis )
				{
					var rotAxis:Vector3 = rotationAxis( sinceFrame.hand( id ).frame );
					returnValue *= rotAxis.dot( axis.normalized() );
				}
			}

			return returnValue;
		}

		/**
		 * The transform matrix expressing the rotation derived from
		 * the change in orientation of this hand, and any associated
		 * fingers and tools, between the current frame and the specified frame.
		 *
		 * <p>If a corresponding Hand object is not found in sinceFrame,
		 * or if either this frame or sinceFrame are invalid Frame objects,
		 * then this method returns an identity matrix.</p>
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
			var returnValue:Matrix;

			if ( sinceFrame.hand( id ) && sinceFrame.hand( id ).rotation )
				returnValue = rotation.multiply( sinceFrame.hand( id ).rotation );
			else
				returnValue = Matrix.identity();

			return returnValue;
		}
		
		/**
		 * The estimated probability that the hand motion between the current
		 * frame and the specified frame is intended to be a rotating motion.
		 * 
		 * <p>If a corresponding Hand object is not found in sinceFrame,
		 * or if either this frame or sinceFrame are invalid Frame objects,
		 * then this method returns zero.</p>
		 *  
		 * @param sinceFrame The starting frame for computing the relative rotation.
		 * @return A value between 0 and 1 representing the estimated probability
		 * that the hand motion between the current frame and the specified frame
		 * is intended to be a rotating motion.
		 * 
		 */
		public function rotationProbability( sinceFrame:Frame ):Number
		{
			if( !controller.context )
				throw new Error( "Method only supported for Native connections." );
			else
				return controller.context.call( "handRotationProbability", id, frame.id, sinceFrame.id );
		}

		/**
		 * The scale factor derived from this hand's motion between
		 * the current frame and the specified frame.
		 * 
		 * <p>The scale factor is always positive. A value of 1.0 indicates no
		 * scaling took place. Values between 0.0 and 1.0 indicate contraction
		 * and values greater than 1.0 indicate expansion.</p>
		 * 
		 * <p>The Leap derives scaling from the relative inward or outward motion
		 * of a hand and its associated fingers and tools (independent of
		 * translation and rotation).</p>
		 * 
		 * <p>If a corresponding Hand object is not found in sinceFrame,
		 * or if either this frame or sinceFrame are invalid Frame objects,
		 * then this method returns 1.0.</p>
		 * 
		 * @param sinceFrame The starting frame for computing the relative scaling.
		 * @return A positive value representing the heuristically determined
		 * scaling change ratio between the current frame and that specified
		 * in the sinceFrame parameter.
		 *
		 */
		public function scaleFactor( sinceFrame:Frame ):Number
		{
			var returnValue:Number;
			if ( sinceFrame && sinceFrame.hand( id ) && sinceFrame.hand( id ).scaleFactorNumber )
				returnValue = Math.exp( scaleFactorNumber - sinceFrame.hand( id ).scaleFactorNumber );
			else
				returnValue = 1;
			
			return returnValue;
		}
		
		/**
		 * The estimated probability that the hand motion between the current
		 * frame and the specified frame is intended to be a scaling motion.
		 * 
		 * <p>If a corresponding Hand object is not found in sinceFrame,
		 * or if either this frame or sinceFrame are invalid Frame objects,
		 * then this method returns zero.</p>
		 *  
		 * @param sinceFrame The starting frame for computing the relative scaling.
		 * @return A value between 0 and 1 representing the estimated probability
		 * that the hand motion between the current frame and the specified frame
		 * is intended to be a scaling motion.
		 * 
		 */
		public function scaleProbability( sinceFrame:Frame ):Number
		{
			if( !controller.context )
				throw new Error( "Method only supported for Native connections." );
			else
				return controller.context.call( "handScaleProbability", id, frame.id, sinceFrame.id );
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
			var returnValue:Vector3;

			if ( sinceFrame.hand( id ) && sinceFrame.hand( id ).translationVector )
				returnValue = new Vector3( translationVector.x - sinceFrame.hand( id ).translationVector.x, translationVector.y - sinceFrame.hand( id ).translationVector.y, translationVector.z - sinceFrame.hand( id ).translationVector.z );
			else
				returnValue = new Vector3( 0, 0, 0 );

			return returnValue;
		}
		
		/**
		 * The estimated probability that the hand motion between the current
		 * frame and the specified frame is intended to be a translating motion.
		 * 
		 * <p>If a corresponding Hand object is not found in sinceFrame,
		 * or if either this frame or sinceFrame are invalid Frame objects,
		 * then this method returns zero.</p>
		 *  
		 * @param sinceFrame The starting frame for computing the translation.
		 * @return A value between 0 and 1 representing the estimated probability
		 * that the hand motion between the current frame and the specified
		 * frame is intended to be a translating motion.
		 * 
		 */
		public function translationProbability( sinceFrame:Frame ):Number
		{
			if( !controller.context )
				throw new Error( "Method only supported for Native connections." );
			else
				return controller.context.call( "handTranslationProbability", id, frame.id, sinceFrame.id );
		}

		/**
		 * Returns an invalid Hand object.
		 *
		 * <p>You can use the instance returned by this function in comparisons
		 * testing whether a given Hand instance is valid or invalid.
		 * (You can also use the <code>Hand.isValid()</code> function.)</p>
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

package com.leapmotion.leap
{

	/**
	 * The Frame class represents a set of hand and finger tracking
	 * data detected in a single frame.
	 *
	 * <p>The Leap Motion detects hands, fingers and tools within the tracking area,
	 * reporting their positions, orientations and motions in frames at
	 * the Leap Motion frame rate.</p>
	 *
	 * <p>Access Frame objects through a listener of a Leap Motion Controller.
	 * Add a listener to receive events when a new Frame is available.</p>
	 *
	 * @author logotype
	 *
	 */
	public class Frame
	{
		/**
		 * The current framerate (in frames per second) of the Leap Motion Controller.
		 * <p>This value may fluctuate depending on available computing resources,
		 * activity within the device field of view, software tracking settings,
		 * and other factors.</p>
		 * <p>An estimate of frames per second of the Leap Motion Controller.</p>
		 */
		public var currentFramesPerSecond:Number;
		
		/**
		 * @private
		 * The list of Finger objects detected in this frame, given in arbitrary order.<br/>
		 * <p>The list can be empty if no fingers are detected.</p>
		 */
		public var fingersVector:Vector.<Finger> = new Vector.<Finger>();
		
		/**
		 * @private
		 * The list of Hand objects detected in this frame, given in arbitrary order.<br/>
		 * <p>The list can be empty if no hands are detected.</p>
		 */
		public var handsVector:Vector.<Hand> = new Vector.<Hand>();

		/**
		 * @private
		 * The Pointable object with the specified ID in this frame.
		 *
		 * <p>Use the <code>Frame.pointable()</code> function to retrieve the Pointable
		 * object from this frame using an ID value obtained from a previous frame.
		 * This function always returns a Pointable object, but if no finger
		 * or tool with the specified ID is present, an invalid Pointable
		 * object is returned.</p>
		 *
		 * <p>Note that ID values persist across frames, but only until tracking
		 * of a particular object is lost. If tracking of a finger or tool is
		 * lost and subsequently regained, the new Pointable object representing
		 * that finger or tool may have a different ID than that representing
		 * the finger or tool in an earlier frame.</p>
		 *
		 * @see Pointable
		 *
		 */
		public var pointablesVector:Vector.<Pointable> = new Vector.<Pointable>();

		/**
		 * @private
		 * The gestures recognized or continuing in this frame.
		 *
		 * <p>Circle and swipe gestures are updated every frame.
		 * Tap gestures only appear in the list when they start.</p>
		 */
		public var gesturesVector:Vector.<Gesture> = new Vector.<Gesture>();

		/**
		 * A unique ID for this Frame.
		 * <p>Consecutive frames processed by the Leap Motion have consecutive increasing values.</p>
		 */
		public var id:int;
		
		/**
		 * The current InteractionBox for the frame.
		 * <p>See the InteractionBox class documentation for more details on how this class should be used.</p>
		 * @see InteractionBox
		 */
		public var interactionBox:InteractionBox;

		/**
		 * The frame capture time in microseconds elapsed since the Leap Motion started.
		 */
		public var timestamp:Number;

		/**
		 * @private
		 * The list of Tool objects detected in this frame, given in arbitrary order.
		 *
		 * @see Tool
		 */
		public var toolsVector:Vector.<Tool> = new Vector.<Tool>();

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
		 * Constructs a Frame object.
		 *
		 * <p>Frame instances created with this constructor are invalid.
		 * Get valid Frame objects by calling the <code>LeapMotion.frame()</code> function.</p>
		 *
		 */
		public function Frame()
		{
		}

		/**
		 * The Hand object with the specified ID in this frame.
		 *
		 * <p>Use the <code>Frame.hand()</code> function to retrieve the Hand object
		 * from this frame using an ID value obtained from a previous frame.
		 * This function always returns a Hand object, but if no hand
		 * with the specified ID is present, an invalid Hand object is returned.</p>
		 *
		 * <p>Note that ID values persist across frames, but only until tracking
		 * of a particular object is lost. If tracking of a hand is lost
		 * and subsequently regained, the new Hand object representing
		 * that physical hand may have a different ID than that
		 * representing the physical hand in an earlier frame.</p>
		 *
		 * @param id The ID value of a Hand object from a previous frame.
		 * @return The Hand object with the matching ID if one exists
		 * in this frame; otherwise, an invalid Hand object is returned.
		 * @see Hand
		 *
		 */
		public function hand( id:int ):Hand
		{
			var i:int = 0;
			var length:int = handsVector.length;

			for( i; i < length; ++i )
			{
				if( handsVector[ i ].id == id )
				{
					return handsVector[ i ];
					break;
				}
			}

			return Hand.invalid();
		}

		/**
		 * The list of Hand objects detected in this frame,
		 * given in arbitrary order.
		 *
		 * <p>The list can be empty if no hands are detected.</p>
		 * @return The Hand vector containing all Hand objects detected in this frame.
		 *
		 */
		public function get hands():Vector.<Hand>
		{
			return handsVector;
		}

		/**
		 * The Finger object with the specified ID in this frame.
		 *
		 * <p>Use the <code>Frame.finger()</code> function to retrieve the Finger
		 * object from this frame using an ID value obtained from a
		 * previous frame. This function always returns a Finger object,
		 * but if no finger with the specified ID is present, an
		 * invalid Finger object is returned.</p>
		 *
		 * <p>Note that ID values persist across frames, but only until
		 * tracking of a particular object is lost. If tracking of a
		 * finger is lost and subsequently regained, the new Finger
		 * object representing that physical finger may have a different
		 * ID than that representing the finger in an earlier frame.</p>
		 *
		 * @param id The ID value of a Finger object from a previous frame.
		 * @return The Finger object with the matching ID if one exists
		 * in this frame; otherwise, an invalid Finger object is returned.
		 * @see Finger
		 *
		 */
		public function finger( id:int ):Finger
		{
			var i:int = 0;
			var length:int = fingersVector.length;

			for( i; i < length; ++i )
			{
				if( fingersVector[ i ].id == id )
				{
					return fingersVector[ i ];
					break;
				}
			}

			return Finger.invalid();
		}

		/**
		 * The list of Finger objects detected in this frame,
		 * given in arbitrary order.
		 *
		 * <p>The list can be empty if no fingers are detected.</p>
		 * @return The Finger vector containing all Finger objects detected in this frame.
		 *
		 */
		public function get fingers():Vector.<Finger>
		{
			return fingersVector;
		}

		/**
		 * The Tool object with the specified ID in this frame.
		 *
		 * <p>Use the <code>Frame.tool()</code> function to retrieve the Tool
		 * object from this frame using an ID value obtained from
		 * a previous frame. This function always returns a Tool
		 * object, but if no tool with the specified ID is present,
		 * an invalid Tool object is returned.</p>
		 *
		 * <p>Note that ID values persist across frames, but only until
		 * tracking of a particular object is lost. If tracking of a
		 * tool is lost and subsequently regained, the new Tool
		 * object representing that tool may have a different ID
		 * than that representing the tool in an earlier frame.</p>
		 *
		 * @param id The ID value of a Tool object from a previous frame.
		 * @return The Tool object with the matching ID if one exists in
		 * this frame; otherwise, an invalid Tool object is returned.
		 * @see Tool
		 *
		 */
		public function tool( id:int ):Tool
		{
			var i:int = 0;
			var length:int = toolsVector.length;

			for( i; i < length; ++i )
			{
				if( toolsVector[ i ].id == id )
				{
					return toolsVector[ i ];
					break;
				}
			}

			return Tool.invalid();
		}

		/**
		 * The list of Tool objects detected in this frame,
		 * given in arbitrary order.
		 *
		 * <p>The list can be empty if no tools are detected.</p>
		 * @return The ToolList containing all Tool objects detected in this frame.
		 *
		 */
		public function get tools():Vector.<Tool>
		{
			return toolsVector;
		}

		/**
		 * The Pointable object with the specified ID in this frame.
		 *
		 * <p>Use the <code>Frame.pointable()</code> function to retrieve the Pointable
		 * object from this frame using an ID value obtained from a previous frame.
		 * This function always returns a Pointable object, but if no finger
		 * or tool with the specified ID is present, an invalid
		 * Pointable object is returned.</p>
		 *
		 * <p>Note that ID values persist across frames, but only until tracking
		 * of a particular object is lost. If tracking of a finger or tool is
		 * lost and subsequently regained, the new Pointable object representing
		 * that finger or tool may have a different ID than that representing
		 * the finger or tool in an earlier frame.</p>
		 *
		 * @param id The ID value of a Pointable object from a previous frame.
		 * @return The Pointable object with the matching ID if one exists
		 * in this frame; otherwise, an invalid Pointable object is returned.
		 *
		 */
		public function pointable( id:int ):Pointable
		{
			var i:int = 0;
			var length:int = pointablesVector.length;

			for( i; i < length; ++i )
			{
				if( pointablesVector[ i ].id == id )
				{
					return pointablesVector[ i ];
					break;
				}
			}

			return Pointable.invalid();
		}

		/**
		 * The list of Pointable objects (fingers and tools) detected in this
		 * frame, given in arbitrary order.
		 *
		 * <p>The list can be empty if no fingers or tools are detected.</p>
		 *
		 * @return The Pointable vector containing all Pointable objects
		 * detected in this frame.
		 */
		public function get pointables():Vector.<Pointable>
		{
			return pointablesVector;
		}

		/**
		 * The Gesture object with the specified ID in this frame.
		 *
		 * <p>Use the <code>Frame.gesture()</code> function to return a Gesture object in this frame
		 * using an ID obtained in an earlier frame. The function always returns a
		 * Gesture object, but if there was no update for the gesture in this frame,
		 * then an invalid Gesture object is returned.</p>
		 *
		 * <p>All Gesture objects representing the same recognized movement share the same ID.</p>
		 *
		 * @param id The ID of an Gesture object from a previous frame.
		 * @return The Gesture object in the frame with the specified ID if one
		 * exists; Otherwise, an Invalid Gesture object.
		 *
		 */
		public function gesture( id:int ):Gesture
		{
			var i:int = 0;
			var length:int = gesturesVector.length;

			for( i; i < length; ++i )
			{
				if( gesturesVector[ i ].id == id )
				{
					return gesturesVector[ i ];
					break;
				}
			}

			return Gesture.invalid();
		}

		/**
		 * Returns a Gesture vector containing all gestures that have occured
		 * since the specified frame.
		 *
		 * <p>If no frame is specifed, the gestures recognized or continuing in
		 * this frame will be returned.</p>
		 *
		 * @param sinceFrame An earlier Frame object. The starting frame must
		 * still be in the frame history cache, which has a default length of 60 frames.
		 * @return The list of gestures.
		 *
		 */
		public function gestures( sinceFrame:Frame = null ):Vector.<Gesture>
		{
			if( !isValid() )
				return new Vector.<Gesture>();

			if( !sinceFrame )
			{
				// The gestures recognized or continuing in this frame.
				return gesturesVector;
			}
			else
			{
				if( !sinceFrame.isValid() )
					return new Vector.<Gesture>();

				// Returns a Gesture vector containing all gestures that have occured since the specified frame.
				var gesturesSinceFrame:Vector.<Gesture> = new Vector.<Gesture>();
				var i:int = 0;
				var j:int = 0;

				for( i; i < controller.frameHistory.length; ++i )
				{
					for( j; j < controller.frameHistory[ i ].gesturesVector.length; ++j )
						gesturesSinceFrame.push( controller.frameHistory[ i ].gesturesVector[ j ] );

					if( sinceFrame == controller.frameHistory[ i ] )
						break;
				}

				return gesturesSinceFrame;
			}
		}

		/**
		 * The axis of rotation derived from the overall rotational
		 * motion between the current frame and the specified frame.
		 *
		 * <p>The returned direction vector is normalized.</p>
		 *
		 * <p>The Leap Motion derives frame rotation from the relative change
		 * in position and orientation of all objects detected in
		 * the field of view.</p>
		 *
		 * <p>If either this frame or sinceFrame is an invalid Frame
		 * object, or if no rotation is detected between the
		 * two frames, a zero vector is returned.</p>
		 *
		 * @param sinceFrame The starting frame for computing the relative rotation.
		 * @return A normalized direction Vector representing the axis of the
		 * heuristically determined rotational change between the current
		 * frame and that specified in the sinceFrame parameter.
		 *
		 */
		public function rotationAxis( sinceFrame:Frame ):Vector3
		{
			if( sinceFrame && sinceFrame.rotation )
			{
				var vector:Vector3 = new Vector3( rotation.zBasis.y - sinceFrame.rotation.yBasis.z, rotation.xBasis.z - sinceFrame.rotation.zBasis.x, rotation.yBasis.x - sinceFrame.rotation.xBasis.y );
				return vector.normalized();
			}
			else
			{
				return new Vector3( 0, 0, 0 );
			}
		}

		/**
		 * The angle of rotation around the rotation axis derived from the
		 * overall rotational motion between the current frame and the specified frame.
		 *
		 * <p>The returned angle is expressed in radians measured clockwise around
		 * the rotation axis (using the right-hand rule) between the
		 * start and end frames. The value is always between 0 and pi radians (0 and 180 degrees).</p>
		 *
		 * <p>The Leap Motion derives frame rotation from the relative change in position
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
			if( !isValid() || !sinceFrame.isValid() )
				return 0.0;

			var returnValue:Number = 0.0;
			var rotationSinceFrameMatrix:Matrix = rotationMatrix( sinceFrame );
			var cs:Number = ( rotationSinceFrameMatrix.xBasis.x + rotationSinceFrameMatrix.yBasis.y + rotationSinceFrameMatrix.zBasis.z - 1 ) * 0.5;
			var angle:Number = Math.acos( cs );
			returnValue = isNaN( angle ) ? 0.0 : angle;

			if( axis )
			{
				var rotAxis:Vector3 = rotationAxis( sinceFrame );
				returnValue *= rotAxis.dot( axis.normalized() );
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
		 * @return
		 *
		 */
		public function rotationMatrix( sinceFrame:Frame ):Matrix
		{
			if( sinceFrame && sinceFrame.rotation )
			{
				return sinceFrame.rotation.multiply( new Matrix( new Vector3( this.rotation.xBasis.x, this.rotation.yBasis.x, this.rotation.zBasis.x ), new Vector3( this.rotation.xBasis.y, this.rotation.yBasis.y, this.rotation.zBasis.y ), new Vector3( this.rotation.xBasis.z, this.rotation.yBasis.z, this.rotation.zBasis.z ) ) );
			}
			else
			{
				return Matrix.identity();
			}
		}

		/**
		 * The estimated probability that the overall motion between
		 * the current frame and the specified frame is intended to
		 * be a rotating motion.
		 *
		 * <p>If either this frame or sinceFrame is an invalid Frame
		 * object, then this method returns zero.</p>
		 *
		 * @param sinceFrame The starting frame for computing the relative rotation.
		 * @return A value between 0 and 1 representing the estimated
		 * probability that the overall motion between the current frame
		 * and the specified frame is intended to be a rotating motion.
		 *
		 */
		public function rotationProbability( sinceFrame:Frame ):Number
		{
			if( !controller.context )
				throw new Error( "Method only supported for Native connections." );
			else
				return controller.context.call( "frameRotationProbability", id, sinceFrame.id );
		}

		/**
		 * The scale factor derived from the overall motion between the
		 * current frame and the specified frame.
		 *
		 * <p>The scale factor is always positive. A value of 1.0 indicates no
		 * scaling took place. Values between 0.0 and 1.0 indicate contraction
		 * and values greater than 1.0 indicate expansion.</p>
		 *
		 * <p>The Leap Motion derives scaling from the relative inward or outward
		 * motion of all objects detected in the field of view (independent
		 * of translation and rotation).</p>
		 *
		 * <p>If either this frame or sinceFrame is an invalid Frame object,
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
			if( sinceFrame && sinceFrame.scaleFactorNumber )
				return Math.exp( scaleFactorNumber - sinceFrame.scaleFactorNumber );
			else
				return 1;
		}

		/**
		 * The estimated probability that the overall motion between the current
		 * frame and the specified frame is intended to be a scaling motion.
		 *
		 * <p>If either this frame or sinceFrame is an invalid Frame object,
		 * then this method returns zero.</p>
		 *
		 * @param sinceFrame The starting frame for computing the relative scaling.
		 * @return A value between 0 and 1 representing the estimated probability
		 * that the overall motion between the current frame and the specified
		 * frame is intended to be a scaling motion.
		 *
		 */
		public function scaleProbability( sinceFrame:Frame ):Number
		{
			if( !controller.context )
				throw new Error( "Method only supported for Native connections." );
			else
				return controller.context.call( "frameScaleProbability", id, sinceFrame.id );
		}

		/**
		 * The change of position derived from the overall linear motion
		 * between the current frame and the specified frame.
		 *
		 * <p>The returned translation vector provides the magnitude and
		 * direction of the movement in millimeters.</p>
		 *
		 * <p>The Leap Motion derives frame translation from the linear motion
		 * of all objects detected in the field of view.</p>
		 *
		 * <p>If either this frame or sinceFrame is an invalid Frame object,
		 * then this method returns a zero vector.</p>
		 *
		 * @param sinceFrame The starting frame for computing the translation.
		 * @return A Vector representing the heuristically determined change
		 * in hand position between the current frame and that specified
		 * in the sinceFrame parameter.
		 *
		 */
		public function translation( sinceFrame:Frame ):Vector3
		{
			if( sinceFrame.translationVector )
				return new Vector3( translationVector.x - sinceFrame.translationVector.x, translationVector.y - sinceFrame.translationVector.y, translationVector.z - sinceFrame.translationVector.z );
			else
				return new Vector3( 0, 0, 0 );
		}

		/**
		 * The estimated probability that the overall motion between the current
		 * frame and the specified frame is intended to be a translating motion.
		 *
		 * <p>If either this frame or sinceFrame is an invalid Frame object,
		 * then this method returns zero.</p>
		 *
		 * @param sinceFrame The starting frame for computing the translation.
		 * @return A value between 0 and 1 representing the estimated probability
		 * that the overall motion between the current frame and the specified
		 * frame is intended to be a translating motion.
		 *
		 */
		public function translationProbability( sinceFrame:Frame ):Number
		{
			if( !controller.context )
				throw new Error( "Method only supported for Native connections." );
			else
				return controller.context.call( "frameTranslationProbability", id, sinceFrame.id );
		}

		/**
		 * Compare Frame object equality.
		 *
		 * <p>Two Frame objects are equal if and only if both Frame objects
		 * represent the exact same frame of tracking data and both
		 * Frame objects are valid.</p>
		 *
		 * @param other The Frame to compare with.
		 * @return True; if equal. False otherwise.
		 *
		 */
		public function isEqualTo( other:Frame ):Boolean
		{
			if( id != other.id || !isValid() || other.isValid() )
				return false;

			return true;
		}

		/**
		 * Reports whether this Frame instance is valid.
		 *
		 * <p>A valid Frame is one generated by the LeapMotion object that contains
		 * tracking data for all detected entities. An invalid Frame contains
		 * no actual tracking data, but you can call its functions without risk
		 * of a null pointer exception. The invalid Frame mechanism makes it
		 * more convenient to track individual data across the frame history.</p>
		 *
		 * <p>For example, you can invoke: <code>var finger:Finger = leap.frame(n).finger(fingerID);</code>
		 * for an arbitrary Frame history value, "n", without first checking whether
		 * frame(n) returned a null object.<br/>
		 * (You should still check that the returned Finger instance is valid.)</p>
		 *
		 * @return True, if this is a valid Frame object; false otherwise.
		 *
		 */
		public function isValid():Boolean
		{
			if( !id )
				return false;

			return true;
		}

		/**
		 * Returns an invalid Frame object.
		 *
		 * <p>You can use the instance returned by this function in comparisons
		 * testing whether a given Frame instance is valid or invalid.
		 * (You can also use the <code>Frame.isValid()</code> function.)</p>
		 *
		 * @return The invalid Frame instance.
		 *
		 */
		static public function invalid():Frame
		{
			return new Frame();
		}
	}
}

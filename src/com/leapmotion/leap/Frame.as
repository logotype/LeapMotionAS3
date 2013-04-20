package com.leapmotion.leap
{

	/**
	 * The Frame class represents a set of hand and finger tracking
	 * data detected in a single frame.
	 *
	 * <p>The Leap detects hands, fingers and tools within the tracking area,
	 * reporting their positions, orientations and motions in frames at
	 * the Leap frame rate.</p>
	 *
	 * <p>Access Frame objects through a listener of a Leap Controller.
	 * Add a listener to receive events when a new Frame is available.</p>
	 *
	 * @author logotype
	 *
	 */
	public class Frame
	{
		/**
		 * The list of Finger objects detected in this frame, given in arbitrary order.<br/>
		 * The list can be empty if no fingers are detected.
		 */
		public var fingers:Vector.<Finger> = new Vector.<Finger>();

		/**
		 * The list of Hand objects detected in this frame, given in arbitrary order.<br/>
		 * The list can be empty if no hands are detected.
		 */
		public var hands:Vector.<Hand> = new Vector.<Hand>();

		/**
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
		public var pointables:Vector.<Pointable> = new Vector.<Pointable>();

		/**
		 * The gestures recognized or continuing in this frame.
		 *
		 * <p>Circle and swipe gestures are updated every frame.
		 * Tap gestures only appear in the list when they start.</p>
		 */
		public var _gestures:Vector.<Gesture> = new Vector.<Gesture>();

		/**
		 * A unique ID for this Frame.
		 * <p>Consecutive frames processed by the Leap have consecutive increasing values.</p>
		 */
		public var id:int;

		/**
		 * The frame capture time in microseconds elapsed since the Leap started.
		 */
		public var timestamp:Number;

		/**
		 * The list of Tool objects detected in this frame, given in arbitrary order.
		 *
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
		public var scaleFactorNumber:Number;

		/**
		 * Translation since last Frame.
		 */
		public var translationVector:Vector3;

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
			var returnValue:Hand = Hand.invalid();

			var i:int = 0;
			var length:int = hands.length;

			for ( i; i < length; ++i )
			{
				if ( hands[ i ].id == id )
				{
					returnValue = hands[ i ];
					break;
				}
			}

			return returnValue;
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
			var returnValue:Gesture = Gesture.invalid();
			var i:int = 0;
			var length:int = _gestures.length;

			for ( i; i < length; ++i )
			{
				if ( _gestures[ i ].id == id )
				{
					returnValue = _gestures[ i ];
					break;
				}
			}

			return returnValue;
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
			if( !sinceFrame )
			{
				// The gestures recognized or continuing in this frame.
				return _gestures;
			}
			else
			{
				// Returns a Gesture vector containing all gestures that have occured since the specified frame.
				var gesturesSinceFrame:Vector.<Gesture> = new Vector.<Gesture>();
				var i:int = 0;
				var j:int = 0;
				var controller:Controller = Controller.getInstance();
				
				for( i; i < controller.frameHistory.length; ++i )
				{
					for( j; j < controller.frameHistory[ i ]._gestures.length; ++j )
						gesturesSinceFrame.push( controller.frameHistory[ i ]._gestures[ j ] );

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
		 * <p>The Leap derives frame rotation from the relative change
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
			var returnValue:Vector3 = new Vector3( 0, 0, 0 );

			if ( sinceFrame && sinceFrame.rotation )
			{
				var vector:Vector3 = new Vector3( rotation.zBasis.y - sinceFrame.rotation.yBasis.z, rotation.xBasis.z - sinceFrame.rotation.zBasis.x, rotation.yBasis.x - sinceFrame.rotation.xBasis.y );
				returnValue = vector.normalized();
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
			var returnValue:Number = 0;
			if ( !axis )
			{
				var rotationSinceFrameMatrix:Matrix = rotationMatrix( sinceFrame );
				var cs:Number = ( rotationSinceFrameMatrix.xBasis.x + rotationSinceFrameMatrix.yBasis.y + rotationSinceFrameMatrix.zBasis.z - 1.0 ) * 0.5;
				var angle:Number = Math.acos( cs );
				returnValue = isNaN( angle ) ? 0 : angle;
			}
			else
			{
				/*
				TODO: Implement rotation angle around axis
				(1) translate space so that the rotation axis passes through the origin
				(2) rotate space about the z-axis so that the rotation axis lies in the xz-plane
				(3) rotate space about the y-axis so that the rotation axis lies along the z-axis
				(4) perform the desired rotation by theta about the z-axis
				(5) apply the inverse of step (3)
				(6) apply the inverse of step (2)
				(7) apply the inverse of step (1) 
				*/
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
			var returnValue:Matrix = Matrix.identity();

			if ( sinceFrame && sinceFrame.rotation )
				returnValue = rotation.multiply( sinceFrame.rotation );

			return returnValue;
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
			if( !Controller.getInstance().context )
				throw new Error( "Method only supported for Native connections." );
			else
				return Controller.getInstance().context.call( "frameRotationProbability", id, sinceFrame.id );
		}

		/**
		 * The scale factor derived from the overall motion between the
		 * current frame and the specified frame.
		 *
		 * <p>The scale factor is always positive. A value of 1.0 indicates no
		 * scaling took place. Values between 0.0 and 1.0 indicate contraction
		 * and values greater than 1.0 indicate expansion.</p>
		 *
		 * <p>The Leap derives scaling from the relative inward or outward
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
			var returnValue:Number = 1;
			if ( sinceFrame && sinceFrame.scaleFactorNumber )
				returnValue = Math.exp( scaleFactorNumber - sinceFrame.scaleFactorNumber );

			return returnValue;
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
			if( !Controller.getInstance().context )
				throw new Error( "Method only supported for Native connections." );
			else
				return Controller.getInstance().context.call( "frameScaleProbability", id, sinceFrame.id );
		}

		/**
		 * The change of position derived from the overall linear motion
		 * between the current frame and the specified frame.
		 *
		 * <p>The returned translation vector provides the magnitude and
		 * direction of the movement in millimeters.</p>
		 *
		 * <p>The Leap derives frame translation from the linear motion
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
			var returnValue:Vector3 = new Vector3( 0, 0, 0 );

			if ( sinceFrame.translationVector )
				returnValue = new Vector3( translationVector.x - sinceFrame.translationVector.x, translationVector.y - sinceFrame.translationVector.y, translationVector.z - sinceFrame.translationVector.z );

			return returnValue;
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
			if( !Controller.getInstance().context )
				throw new Error( "Method only supported for Native connections." );
			else
				return Controller.getInstance().context.call( "frameTranslationProbability", id, sinceFrame.id );
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
			var returnValue:Boolean = true;
			
			if( id != other.id || !isValid() || other.isValid() )
				returnValue = false;
			
			return returnValue;
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
			var returnValue:Boolean = true;

			if(!id)
				returnValue = false;

			return returnValue;
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

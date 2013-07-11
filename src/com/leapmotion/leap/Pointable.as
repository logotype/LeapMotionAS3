package com.leapmotion.leap
{

	/**
	 * The Pointable class reports the physical characteristics of a detected finger or tool.
	 * Both fingers and tools are classified as Pointable objects. Use the Pointable.isFinger
	 * property to determine whether a Pointable object represents a finger. Use the
	 * Pointable.isTool property to determine whether a Pointable object represents a tool.
	 * The Leap Motion classifies a detected entity as a tool when it is thinner, straighter,
	 * and longer than a typical finger.
	 * 
	 * <p>To provide touch emulation, the Leap Motion software associates a floating touch
	 * plane that adapts to the user's finger movement and hand posture. The Leap Motion
	 * interprets purposeful movements toward this plane as potential touch points.
	 * The Pointable class reports touch state with the touchZone and touchDistance values.</p>
	 *
	 * <p>Note that Pointable objects can be invalid, which means that they do not contain valid
	 * tracking data and do not correspond to a physical entity. Invalid Pointable objects
	 * can be the result of asking for a Pointable object using an ID from an earlier frame
	 * when no Pointable objects with that ID exist in the current frame. A Pointable object
	 * created from the Pointable constructor is also invalid. Test for validity with
	 * the <code>Pointable.isValid()</code> function.</p>
	 *
	 * @author logotype
	 *
	 */
	public class Pointable
	{
		/**
		 * The Pointable object is too far from the plane to be considered hovering or touching.
		 * 
		 * <p>Defines the values for reporting the state of a Pointable object in relation to an adaptive touch plane.</p>  
		 */
		static public const ZONE_NONE:int = 0;
		
		/**
		 * The Pointable object is close to, but not touching the plane. 
		 * 
		 * <p>Defines the values for reporting the state of a Pointable object in relation to an adaptive touch plane.</p>  
		 */
		static public const ZONE_HOVERING:int = 1;
		
		/**
		 * The Pointable has penetrated the plane.  
		 * 
		 * <p>Defines the values for reporting the state of a Pointable object in relation to an adaptive touch plane.</p>  
		 */
		static public const ZONE_TOUCHING:int = 2;
		
		/**
		 * The direction in which this finger or tool is pointing.<br/>
		 * The direction is expressed as a unit vector pointing in the
		 * same direction as the tip.
		 */
		public var direction:Vector3;

		/**
		 * The Frame associated with this Pointable object.<br/>
		 * The associated Frame object, if available; otherwise, an invalid
		 * Frame object is returned.
		 * @see Frame
		 */
		public var frame:Frame;

		/**
		 * The Hand associated with this finger or tool.<br/>
		 * The associated Hand object, if available; otherwise, an invalid
		 * Hand object is returned.
		 * @see Hand
		 */
		public var hand:Hand;

		/**
		 * A unique ID assigned to this Pointable object, whose value remains
		 * the same across consecutive frames while the tracked finger or
		 * tool remains visible.
		 *
		 * <p>If tracking is lost (for example, when a finger is occluded by another
		 * finger or when it is withdrawn from the Leap Motion field of view), the Leap
		 * may assign a new ID when it detects the entity in a future frame.</p>
		 *
		 * <p>Use the ID value with the <code>Frame.pointable()</code> function to find this
		 * Pointable object in future frames.</p>
		 * 
		 * <p>IDs should be from 1 to 100 (inclusive). If more than 100 objects are
		 * tracked an IDs of -1 will be used until an ID in the defined range is available.</p>
		 * 
		 */
		public var id:int;

		/**
		 * The estimated length of the finger or tool in millimeters.
		 *
		 * <p>The reported length is the visible length of the finger or tool from
		 * the hand to tip.</p>
		 *
		 * <p>If the length isn't known, then a value of 0 is returned.</p>
		 */
		public var length:Number = 0;

		/**
		 * The estimated width of the finger or tool in millimeters.
		 *
		 * <p>The reported width is the average width of the visible portion
		 * of the finger or tool from the hand to the tip.</p>
		 *
		 * <p>If the width isn't known, then a value of 0 is returned.</p>
		 */
		public var width:Number = 0;

		/**
		 * The tip position in millimeters from the Leap Motion origin.
		 */
		public var tipPosition:Vector3;
		
		/**
		 * The stabilized tip position of this Pointable.
		 * <p>Smoothing and stabilization is performed in order to make this value more suitable for interaction with 2D content.</p>
		 * <p>A modified tip position of this Pointable object with some additional smoothing and stabilization applied.</p> 
		 */
		public var stabilizedTipPosition:Vector3;
		
		/**
		 * The duration of time this Pointable has been visible to the Leap Motion Controller.
		 * <p>The duration (in seconds) that this Pointable has been tracked.</p>
		 */
		public var timeVisible:Number;
		
		/**
		 * The rate of change of the tip position in millimeters/second.
		 */
		public var tipVelocity:Vector3;

		/**
		 * Whether or not the Pointable is believed to be a finger.
		 */
		public var isFinger:Boolean;

		/**
		 * Whether or not the Pointable is believed to be a tool.
		 */
		public var isTool:Boolean;
		
		/**
		 * The current touch zone of this Pointable object.
		 * 
		 * <p>The Leap Motion software computes the touch zone based on a
		 * floating touch plane that adapts to the user's finger movement
		 * and hand posture. The Leap Motion software interprets purposeful
		 * movements toward this plane as potential touch points.
		 * When a Pointable moves close to the adaptive touch plane,
		 * it enters the "hovering" zone. When a Pointable reaches or
		 * passes through the plane, it enters the "touching" zone.</p>
		 * 
		 * <p>The possible states are present in the Zone enum of this class:</p>
		 * 
		 * <code>Zone.NONE – The Pointable is outside the hovering zone.
		 * Zone.HOVERING – The Pointable is close to, but not touching the touch plane.
		 * Zone.TOUCHING – The Pointable has penetrated the touch plane.</code>
		 * 
		 * <p>The touchDistance value provides a normalized indication of the
		 * distance to the touch plane when the Pointable is in the hovering
		 * or touching zones.</p>
		 * 
		 */
		public var touchZone:int = ZONE_NONE;

		/**
		 * A value proportional to the distance between this Pointable
		 * object and the adaptive touch plane.
		 * 
		 * <p>The touch distance is a value in the range [-1, 1].
		 * The value 1.0 indicates the Pointable is at the far edge of
		 * the hovering zone. The value 0 indicates the Pointable is
		 * just entering the touching zone. A value of -1.0 indicates
		 * the Pointable is firmly within the touching zone.
		 * Values in between are proportional to the distance from the plane.
		 * Thus, the touchDistance of 0.5 indicates that the Pointable
		 * is halfway into the hovering zone.</p>
		 * 
		 * <p>You can use the touchDistance value to modulate visual
		 * feedback given to the user as their fingers close in on a
		 * touch target, such as a button.</p>
		 *  
		 */
		public var touchDistance:Number = 0;
		
		public function Pointable()
		{
			direction = Vector3.invalid();
			tipPosition = Vector3.invalid();
			tipVelocity = Vector3.invalid();
		}

		/**
		 * Reports whether this is a valid Pointable object.
		 * @return True if <code>direction</code>, <code>tipPosition</code> and <code>tipVelocity</code> are true.
		 */
		public function isValid():Boolean
		{
			if( ( direction && direction.isValid() ) && ( tipPosition && tipPosition.isValid() ) && ( tipVelocity && tipVelocity.isValid() ) )
				return true;

			return false;
		}

		/**
		 * Compare Pointable object equality/inequality.
		 *
		 * <p>Two Pointable objects are equal if and only if both Pointable
		 * objects represent the exact same physical entities in
		 * the same frame and both Pointable objects are valid.</p>
		 *
		 * @param other The Pointable to compare with.
		 * @return True; if equal, False otherwise.
		 *
		 */
		public function isEqualTo( other:Pointable ):Boolean
		{
			if( !isValid() || !other.isValid() )
				return false;

			if( frame != other.frame )
				return false;

			if( hand != other.hand )
				return false;

			if( !direction.isEqualTo( other.direction ) )
				return false;

			if( length != other.length )
				return false;

			if( width != other.width )
				return false;

			if( id != other.id )
				return false;

			if( !tipPosition.isEqualTo( other.tipPosition ) )
				return false;

			if( !tipVelocity.isEqualTo( other.tipVelocity ) )
				return false;

			if( isFinger != other.isFinger || isTool != other.isTool )
				return false;

			return true;
		}

		/**
		 * Returns an invalid Pointable object.
		 *
		 * <p>You can use the instance returned by this function in
		 * comparisons testing whether a given Pointable instance
		 * is valid or invalid.<br/>
		 * (You can also use the <code>Pointable.isValid()</code> function.)</p>
		 *
		 * @return The invalid Pointable instance.
		 *
		 */
		static public function invalid():Pointable
		{
			return new Pointable();
		}

		/**
		 * A string containing a brief, human readable description of the Pointable object.
		 */
		public function toString():String
		{
			return "[Pointable direction: " + direction + " tipPosition: " + tipPosition + " tipVelocity: " + tipVelocity + "]";
		}
	}
}

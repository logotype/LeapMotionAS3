package com.leapmotion.leap
{
	/**
	 * The Pointable class reports the physical characteristics of a detected finger or tool.
	 * Both fingers and tools are classified as Pointable objects. Use the Pointable::isFinger()
	 * function to determine whether a Pointable object represents a finger. Use the
	 * Pointable::isTool() function to determine whether a Pointable object represents a tool.
	 * The Leap classifies a detected entity as a tool when it is thinner, straighter,
	 * and longer than a typical finger.
	 * 
	 * Note that Pointable objects can be invalid, which means that they do not contain valid
	 * tracking data and do not correspond to a physical entity. Invalid Pointable objects
	 * can be the result of asking for a Pointable object using an ID from an earlier frame
	 * when no Pointable objects with that ID exist in the current frame. A Pointable object
	 * created from the Pointable constructor is also invalid. Test for validity with
	 * the Pointable::isValid() function.
	 *  
	 * @author logotype
	 * 
	 */
	public class Pointable
	{
		/**
		 * The direction in which this finger or tool is pointing.  
		 */		
		public var direction:Vector3;
		
		/**
		 * The Frame associated with this Pointable object. 
		 * @see Frame 
		 */		
		public var frame:Frame;
		/**
		 * The Hand associated with this finger or tool.
		 * @see Hand  
		 */
		public var hand:Hand;
		/**
		 * A unique ID assigned to this Pointable object, whose value remains the same across consecutive frames while the tracked finger or tool remains visible.  
		 */		
		public var id:Number;
		/**
		 * The estimated length of the finger or tool in millimeters.  
		 */		
		public var length:Number;
		/**
		 * The tip position in millimeters from the Leap origin.  
		 */		
		public var tipPosition:Vector3;
		/**
		 * The rate of change of the tip position in millimeters/second.  
		 */		
		public var tipVelocity:Vector3;

		public function Pointable()
		{
		}

		/**
		 * Whether or not the Pointable is believed to be a finger.  
		 */
		public function isFinger():Boolean
		{
			return ( length < 10 ) ? true : false;
		}

		/**
		 * Whether or not the Pointable is believed to be a tool.  
		 */		
		public function isTool():Boolean
		{
			return ( length > 10 ) ? true : false;
		}

		/**
		 * Reports whether this is a valid Pointable object.  
		 * @return true if direction, tipPosition and tipVelocity are true
		 */		
		public function isValid():Boolean
		{
			var returnValue:Boolean = true;

			if ( !direction.isValid())
				returnValue = false;

			if ( !tipPosition.isValid())
				returnValue = false;

			if ( !tipVelocity.isValid())
				returnValue = false;

			return returnValue;
		}
		
		/**
		 * A string containing a brief, human readable description of the Pointable object.  
		 */
		public function toString() :String
		{
			return "[Pointable direction: " + direction + "]";
		}
	}
}

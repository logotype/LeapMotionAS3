package com.leapmotion.leap
{
	/**
	 * The Bone class represents a tracked bone.
	 * 
	 * <p>All fingers contain 4 bones that make up the anatomy of the finger.
	 * Get valid Bone objects from a Finger object.</p>
	 * 
	 * <p>Bones are ordered from base to tip, indexed from 0 to 3. Additionally,
	 * the bone’s Type enum may be used to index a specific bone anatomically.</p>
	 * 
	 * <p>The thumb does not have a base metacarpal bone and therefore contains
	 * a valid, zero length bone at that location.</p>
	 * 
	 * <p>Note that Bone objects can be invalid, which means that they do not
	 * contain valid tracking data and do not correspond to a physical bone.
	 * Invalid Bone objects can be the result of asking for a Bone object
	 * from an invalid finger, indexing a bone out of range, or constructing
	 * a new bone. Test for validity with the Bone::isValid() function.</p>
	 *  
	 * @author logotype
	 * 
	 */
	public class Bone
	{
		/**
		 * Enumerates the names of the bones.
		 *
		 * <p>Members of this enumeration are returned by Bone::type() to identify a
		 * Bone object.</p>
		 */

		/**
		 * Bone connected to the wrist inside the palm
		 */
		static public const TYPE_METACARPAL:int = 0;
		
		/**
		 * Bone connecting to the palm
		 */
		static public const TYPE_PROXIMAL:int = 1;
		
		/**
		 * Bone between the tip and the base
		 */
		static public const TYPE_INTERMEDIATE:int = 2;
		
		/**
		 * Bone at the tip of the finger
		 */
		static public const TYPE_DISTAL:int = 3;
		
		/**
		 * The estimated length of the bone in millimeters.
		 *
		 * @returns The length of the bone in millimeters.
		 * @since 2.0
		 */
		public var length:Number;
		
		/**
		 * The estimated width of the flesh around the bone in millimeters.
		 *
		 * @returns The width of the flesh around the bone in millimeters.
		 * @since 2.0
		 */
		public var width:Number;
		
		/**
		 * The name of this bone.
		 *
		 * @returns The anatomical type of this bone as a member of the Bone::Type
		 * enumeration.
		 * @since 2.0
		 */
		public var type:int;
		
		/**
		 * The base point the bone is anchored to.
		 *
		 * @returns The Vector containing the coordinates of the previous joint position.
		 * @since 2.0
		 */
		public var prevJoint:Vector3;
		
		/**
		 * The end point of the bone towards the tip direction.
		 *
		 * @returns The Vector containing the coordinates of the next joint position.
		 * @since 2.0
		 */
		public var nextJoint:Vector3;
		
		/**
		 * The orientation of the bone as a basis matrix.
		 *
		 * <p>The basis is defined as follows:
		 *   xAxis: Clockwise rotation axis of the bone
		 *   yAxis: Positive above the bone
		 *   zAxis: Positive along the bone towards the wrist
		 *
		 * Note: Since the left hand is a mirror of the right hand, left handed
		 * bones will contain a left-handed basis.</p>
		 *
		 * @returns The basis of the bone as a matrix.
		 * @since 2.0
		 */
		public var basis:Matrix;
		
		public function Bone()
		{
		}
		
		/**
		 * The midpoint in the center of the bone.
		 *
		 * @returns The midpoint in the center of the bone.
		 * @since 2.0
		 */
		public function center():Vector3
		{
			return Vector3.invalid();
		}
		
		/**
		 * The normalized direction of the bone from base to tip.
		 *
		 * @returns The normalized direction of the bone from base to tip.
		 * @since 2.0
		 */
		public function direction():Vector3
		{
			return Vector3.invalid();
		}
		
		/**
		 * Reports whether this is a valid Bone object.
		 *
		 * @returns True, if this Bone object contains valid tracking data.
		 * @since 2.0
		 */
		public function isValid():Boolean
		{
			if( ( direction && direction.isValid() ) && ( center && center.isValid() ) )
				return true;
			
			return false;
		}
		
		/**
		 * Returns an invalid Bone object.
		 *
		 * <p>You can use the instance returned by this function in comparisons testing
		 * whether a given Finger instance is valid or invalid. (You can also use the
		 * Bone::isValid() function.)</p>
		 *
		 * @returns The invalid Bone instance.
		 * @since 2.0
		 */
		static public function invalid():Bone
		{
			return new Bone();
		}
	}
}
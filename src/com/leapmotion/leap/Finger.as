package com.leapmotion.leap
{
	/**
	 * The Finger class represents a tracked finger.
	 *
	 * <p>Fingers are Pointable objects that the Leap has classified as a finger.
	 * Get valid Finger objects from a Frame or a Hand object.</p>
	 *
	 * <p>Note that Finger objects can be invalid, which means that they do not
	 * contain valid tracking data and do not correspond to a physical finger.
	 * Invalid Finger objects can be the result of asking for a Finger object
	 * using an ID from an earlier frame when no Finger objects with that ID
	 * exist in the current frame. A Finger object created from the Finger
	 * constructor is also invalid.<br/>
	 * Test for validity with the <code>Finger.sValid()</code> function.</p>
	 *
	 * @author logotype
	 *
	 */
	public class Finger extends Pointable
	{
		/**
		 * Constructs a Finger object.
		 * 
		 * <p>An uninitialized finger is considered invalid.
		 * Get valid Finger objects from a Frame or a Hand object.</p> 
		 * 
		 */
		public function Finger()
		{
			isFinger = true;
			isTool = false;
		}

		/**
		 * Returns an invalid Finger object.
		 *
		 * <p>You can use the instance returned by this function in
		 * comparisons testing whether a given Finger instance
		 * is valid or invalid.
		 * (You can also use the <code>Finger.isValid()</code> function.)</p>
		 *
		 * @return The invalid Finger instance.
		 *
		 */
		static public function invalid():Finger
		{
			return new Finger();
		}
	}
}
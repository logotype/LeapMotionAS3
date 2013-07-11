package com.leapmotion.leap
{

	/**
	 * The Tool class represents a tracked tool.
	 *
	 * <p>Tools are Pointable objects that the Leap Motion has classified as a tool.
	 * Tools are longer, thinner, and straighter than a typical finger.
	 * Get valid Tool objects from a Frame or a Hand object.</p>
	 * 
	 * <p>Tools may reference a hand, but unlike fingers they are not permanently
	 * associated. Instead, a tool can be transferred between hands while
	 * keeping the same ID.</p>
	 *
	 * <p>Note that Tool objects can be invalid, which means that they do not
	 * contain valid tracking data and do not correspond to a physical tool.
	 * Invalid Tool objects can be the result of asking for a Tool object
	 * using an ID from an earlier frame when no Tool objects with that ID
	 * exist in the current frame. A Tool object created from the Tool
	 * constructor is also invalid. Test for validity with the
	 * <code>Tool.isValid()</code> function.</p>
	 *
	 * @author logotype
	 *
	 */
	public class Tool extends Pointable
	{
		public function Tool()
		{
			isFinger = false;
			isTool = true;
		}

		/**
		 * Returns an invalid Tool object.
		 *
		 * <p>You can use the instance returned by this function in
		 * comparisons testing whether a given Tool instance
		 * is valid or invalid.
		 * (You can also use the Tool.isValid property.)</p>
		 *
		 * @return The invalid Tool instance.
		 *
		 */
		static public function invalid():Tool
		{
			return new Tool();
		}

	}
}

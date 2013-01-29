package com.leapmotion.leap
{
	
	/**
	 * The Tool class represents a tracked tool.
	 * 
	 * Tools are Pointable objects that the Leap has classified as a tool.
	 * Tools are longer, thinner, and straighter than a typical finger.
	 * Get valid Tool objects from a Frame or a Hand object.
	 * 
	 * Note that Tool objects can be invalid, which means that they do not
	 * contain valid tracking data and do not correspond to a physical tool.
	 * Invalid Tool objects can be the result of asking for a Tool object
	 * using an ID from an earlier frame when no Tool objects with that ID
	 * exist in the current frame. A Tool object created from the Tool
	 * constructor is also invalid. Test for validity with the
	 * Tool.isValid() function.
	 *  
	 * @author logotype
	 * 
	 */
	public class Tool extends Pointable
	{
		public function Tool()
		{
		}
	}
}
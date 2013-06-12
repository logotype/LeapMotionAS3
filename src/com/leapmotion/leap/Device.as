package com.leapmotion.leap
{
	/**
	 * The Device class represents a physically connected device.
	 * 
	 * <p>The Device class contains information related to a particular connected device
	 * such as field of view, device id, and calibrated positions.</p>
	 * 
	 * <p>Note that Device objects can be invalid, which means that they do not contain
	 * valid device information and do not correspond to a physical device.
	 * Test for validity with the <code>Device::isValid()</code> function.</p>
	 *  
	 * @author logotype
	 * 
	 */
	public class Device
	{
		/**
		 * @private
		 * Native Extension context.
		 */
		private var context:Object;
		
		/**
		 * Constructs a Device object.
		 * 
		 * <p>An uninitialized device is considered invalid. Get valid Device objects
		 * from a DeviceList object obtained using the <code>controller.devices()</code> method.</p> 
		 * 
		 */
		public function Device( _controller:Controller )
		{
			if( !_controller || !_controller.context )
				throw new Error( "Native Context not available. The Device class is only available in Adobe AIR." );
			else
				context = _controller.context;
		}
		
		/**
		 * The distance to the nearest edge of the Leap Motion controller's view volume.
		 * 
		 * <p>The view volume is an axis-aligned, inverted pyramid centered on the device
		 * origin and extending upward to the range limit. The walls of the pyramid are
		 * described by the horizontalViewAngle and verticalViewAngle and the roof by the range.
		 * This function estimates the distance between the specified input position and
		 * the nearest wall or roof of the view volume.</p>
		 *  
		 * @param position The point to use for the distance calculation.
		 * @return The distance in millimeters from the input position to the nearest boundary.
		 * 
		 */
		public function distanceToBoundary( position:Vector3 ):Number
		{
			return context.call( "getDeviceDistanceToBoundary", position.x, position.y, position.z );
		}
		
		/**
		 * The angle of view along the x axis of this device.
		 * 
		 * <p>The Leap Motion controller scans a region in the shape of an inverted pyramid
		 * centered at the device's center and extending upwards. The <code>horizontalViewAngle</code>
		 * reports the view angle along the long dimension of the device.</p>
		 *  
		 * @return The horizontal angle of view in radians. 
		 * 
		 */
		public function horizontalViewAngle():Number
		{
			return context.call( "getDeviceHorizontalViewAngle" );
		}
		
		/**
		 * The angle of view along the z axis of this device.
		 * 
		 * <p>The Leap Motion controller scans a region in the shape of an inverted pyramid
		 * centered at the device's center and extending upwards. The <code>verticalViewAngle</code>
		 * reports the view angle along the short dimension of the device.</p>
		 *  
		 * @return The vertical angle of view in radians.
		 * 
		 */
		public function verticalViewAngle():Number
		{
			return context.call( "getDeviceVerticalViewAngle" );
		}
		
		/**
		 * Reports whether this is a valid Device object.
		 *  
		 * @return True, if this Device object contains valid data. 
		 * 
		 */
		public function isValid():Boolean
		{
			return context.call( "getDeviceIsValid" );
		}
		
		/**
		 * Compare Device object equality/inequality.
		 * 
		 * <p>Two Device objects are equal if and only if both Device objects
		 * represent the exact same Device and both Devices are valid.</p>
		 *  
		 * @param other
		 * @return 
		 * 
		 */
		public function isEqualTo( other:Device ):Boolean
		{
			return true;
		}
		
		/**
		 * The maximum reliable tracking range.
		 * 
		 * <p>The range reports the maximum recommended distance from the device
		 * center for which tracking is expected to be reliable. This distance is
		 * not a hard limit. Tracking may be still be functional above this
		 * distance or begin to degrade slightly before this distance depending
		 * on calibration and extreme environmental conditions.</p>
		 *  
		 * @return The recommended maximum range of the device in mm. 
		 * 
		 */
		public function range():Number
		{
			return context.call( "getDeviceRange" );
		}
		
		/**
		 * A string containing a brief, human readable description of the Device object.
		 * @return A description of the Device as a string.
		 *
		 */
		public function toString():String
		{
			return "[Device range:" + range() + " horizontalViewAngle:" + horizontalViewAngle() + " verticalViewAngle:" + verticalViewAngle() + "]";
		}
	}
}
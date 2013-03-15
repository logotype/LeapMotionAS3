package com.leapmotion.leap
{
	import flash.utils.getDefinitionByName;

	/**
	 * The Screen class represents a computer monitor screen.
	 * 
	 * The Screen class reports characteristics describing the position and
	 * orientation of the monitor screen within the Leap coordinate system.
	 * These characteristics include the bottom-left corner position of the
	 * screen, direction vectors for the horizontal and vertical axes of the
	 * screen, and the screen's normal vector. The screen must be properly
	 * registered with the Screen Locator for the Leap to report these
	 * characteristics accurately. The Screen class also reports the size
	 * of the screen in pixels, using information obtained from the operating
	 * system.
	 * 
	 * (Run the Screen Locator from the Leap Application Settings dialog,
	 * on the Screen page.)
	 * 
	 * You can get the point of intersection between the screen and a ray
	 * projected from a Pointable object using the Screen.intersect() function.
	 * Likewise, you can get the closest point on the screen to a point in
	 * space using the Screen.distanceToPoint() function. Again, the screen
	 * location must be registered with the Screen Locator for these
	 * functions to return accurate values.
	 * 
	 * Note that Screen objects can be invalid, which means that they do not
	 * contain valid screen coordinate data and do not correspond to a
	 * physical entity. Test for validity with the Screen.isValid() function.
	 *  
	 * @author logotype
	 * 
	 */
	public class Screen
	{
		/**
		 * A unique identifier for this screen based on the screen information
		 * in the configuration.
		 * 
		 * A default screen with ID, 0, always exists and contains default
		 * characteristics, even if no screens have been located. 
		 */
		public var id:int = 0;
		
		/**
		 * Native Extension context. 
		 */		
		private var context:Object;

		/**
		 * Reference to flash.display.Screen (only available on AIR)
		 */
		public static var ScreenClass:*;

		/**
		 * Reference to the AIR builtin Screen instance
		 */
		public var _screen:*;
		
		/**
		 * Constructs a Screen object.
		 * 
		 * An uninitialized screen is considered invalid. Get valid Screen
		 * objects from a ScreenList object obtained using the
		 * Controller.calibratedScreens() method. 
		 * 
		 */
		public function Screen()
		{
			if( !Controller.getInstance().context )
				throw new Error( "Native Context not available. The Screen class is only available in Adobe AIR." );
			else
				context = Controller.getInstance().context;
		}

		/**
		 * Tries to return a reference to the Screen class
		 *
		 * @return True, if definition could be found; False otherwise.
		 *
		 */
		public static function tryCreatingScreenClassReference():Boolean
		{
			try
			{
				ScreenClass = getDefinitionByName( "flash.display.Screen" );
				return true;
			}
			catch ( error:Error )
			{
			}
			return false;
		}
		
		/**
		 * The shortest distance from the specified point to the plane
		 * in which this Screen lies.
		 *  
		 * @param point
		 * @return The length of the perpendicular line segment extending
		 * from the plane this Screen lies in to the specified point.
		 * 
		 */
		public function distanceToPoint( point:Vector3 ):Number
		{
			return context.call( "getScreenDistanceToPoint", id, point.x, point.y, point.z );
		}
		
		/**
		 * The vertical resolution of this screen, in pixels. 
		 * @return The height of this Screen in pixels.
		 * 
		 */
		public function heightPixels():int
		{
			return context.call( "getScreenHeightPixels", id );
		}

		/**
		 * The horizontal resolution of this screen, in pixels.
		 * @return The width of this Screen in pixels.
		 * 
		 */
		public function widthPixels():int
		{
			return context.call( "getScreenWidthPixels", id );
		}

		/**
		 * A Vector representing the horizontal axis of this Screen
		 * within the Leap coordinate system.
		 * 
		 * The magnitude of this vector estimates the physical width of
		 * this Screen in millimeters. The direction of this vector is
		 * parallel to the bottom edge of the screen and points toward
		 * the right edge of the screen.
		 * 
		 * Together, horizontalAxis(), verticalAxis(), and bottomLeftCorner()
		 * describe the physical position, size and orientation of this Screen.
		 *  
		 * @return A Vector representing the bottom, horizontal edge of this Screen.
		 * 
		 */
		public function horizontalAxis():Vector3
		{
			return context.call( "getScreenHorizontalAxis", id );
		}
		
		/**
		 * A Vector representing the vertical axis of this Screen
		 * within the Leap coordinate system.
		 * 
		 * The magnitude of this vector estimates the physical height of
		 * this Screen in millimeters. The direction of this vector is
		 * parallel to the left edge of the screen and points toward
		 * the top edge of the screen.
		 * 
		 * Together, horizontalAxis(), verticalAxis(), and bottomLeftCorner()
		 * describe the physical position, size and orientation of this screen.
		 *  
		 * @return A Vector representing the left, vertical edge of this Screen.
		 * 
		 */
		public function verticalAxis():Vector3
		{
			return context.call( "getScreenVerticalAxis", id );
		}
		
		/**
		 * A Vector representing the bottom left corner of this Screen
		 * within the Leap coordinate system.
		 * 
		 * The point represented by this vector defines the origin of the
		 * screen in the Leap coordinate system.
		 * 
		 * Together, horizontalAxis(), verticalAxis(), and bottomLeftCorner()
		 * describe the physical position, size and orientation of this Screen.
		 *  
		 * @return A Vector containing the coordinates of the bottom-left corner of this Screen.
		 * 
		 */
		public function bottomLeftCorner():Vector3
		{
			return context.call( "getScreenBottomLeftCorner", id );
		}
		
		/**
		 * Returns the intersection between this screen and a ray projecting
		 * from a Pointable object.
		 * 
		 * The projected ray emanates from the Pointable tipPosition along
		 * the Pointable's direction vector.
		 * 
		 * Set the normalize parameter to true to request the intersection
		 * point in normalized screen coordinates. Normalized screen coordinates
		 * are usually values between 0 and 1, where 0 represents the screen's
		 * origin at the bottom-left corner and 1 represents the opposite edge
		 * (either top or right). When you request normalized coordinates,
		 * the z-component of the returned vector is zero. Multiply a normalized
		 * coordinate by the values returned by Screen.widthPixels() or
		 * Screen.heightPixels() to calculate the screen position in pixels
		 * (remembering that many other computer graphics coordinate systems
		 * place the origin in the top-left corner).
		 * 
		 * Set the normalize parameter to false to request the intersection
		 * point in Leap coordinates (millimeters from the Leap origin).
		 * 
		 * If the Pointable object points outside the screen's border (but
		 * still intersects the plane in which the screen lies), the
		 * returned intersection point is clamped to the nearest point on
		 * the edge of the screen.
		 * 
		 * You can use the clampRatio parameter to contract or expand the
		 * area in which you can point. For example, if you set the clampRatio
		 * parameter to 0.5, then the positions reported for intersection
		 * points outside the central 50% of the screen are moved to the border
		 * of this smaller area. If, on the other hand, you expanded the area
		 * by setting clampRatio to a value such as 3.0, then you could point
		 * well outside screen's physical boundary before the intersection
		 * points would be clamped. The positions for any points clamped
		 * would also be placed on this larger outer border. The positions
		 * reported for any intersection points inside the clamping border
		 * are unaffected by clamping.
		 * 
		 * If the Pointable object does not point toward the plane of the
		 * screen (i.e. it is pointing parallel to or away from the screen),
		 * then the components of the returned vector are all set to
		 * NaN (not-a-number).
		 *  
		 * @param pointable 	The pointing finger or tool.
		 * 
		 * @param normalize	 	If true, return normalized coordinates representing
		 * 						the intersection point as a percentage of the screen's
		 * 						width and height. If false, return Leap coordinates
		 * 						(millimeters from the Leap origin, which is located
		 * 						at the center of the top surface of the Leap device).
		 * 						If true and the clampRatio parameter is set to 1.0,
		 * 						coordinates will be of the form (0..1, 0..1, 0).
		 * 						Setting the clampRatio to a different value changes
		 * 						the range for normalized coordinates.
		 * 						For example, a clampRatio of 5.0 changes the range
		 * 						of values to be of the form (-2..3, -2..3, 0).
		 * 
		 * @param clampRatio	Adjusts the clamping border around this screen. By
		 * 						default this ratio is 1.0, and the border corresponds
		 * 						to the actual boundaries of the screen. Setting
		 * 						clampRatio to 0.5 would reduce the interaction area.
		 * 						Likewise, setting the ratio to 2.0 would increase
		 * 						the interaction area, adding 50% around each edge of
		 * 						the physical monitor. Intersection points outside
		 * 						the interaction area are repositioned to the closest
		 * 						point on the clamping border before the vector
		 * 						is returned.
		 * 
		 * @return A Vector containing the coordinates of the intersection
		 * between this Screen and a ray projecting from the specified Pointable object.
		 * 
		 */
		public function intersect( pointable:Pointable, normalize:Boolean, clampRatio:Number ):Vector3
		{
			var pointableTipPositionX:Number = pointable.tipPosition.x;
			var pointableTipPositionY:Number = pointable.tipPosition.y;
			var pointableTipPositionZ:Number = pointable.tipPosition.z;
			
			var pointableDirectionX:Number = pointable.direction.x;
			var pointableDirectionY:Number = pointable.direction.y;
			var pointableDirectionZ:Number = pointable.direction.z;

			return context.call( "getScreenIntersect", id, pointableTipPositionX, pointableTipPositionY, pointableTipPositionZ, pointableDirectionX, pointableDirectionY, pointableDirectionZ, normalize, clampRatio );
		}
		
		/**
		 * Returns an invalid Screen object.
		 * 
		 * You can use the instance returned by this function in comparisons
		 * testing whether a given Hand instance is valid or invalid.
		 * (You can also use the Screen.isValid() function.)
		 *  
		 * @return The invalid Screen instance.
		 * 
		 */
		static public function invalid():Screen
		{
			return new Screen();
		}
		
		/**
		 * Reports whether this is a valid Screen object.
		 * 
		 * Important: A valid Screen object does not necessarily contain
		 * up-to-date screen location information. Location information is
		 * only accurate until the Leap device or the monitor are moved.
		 * In addition, the primary screen always contains default location
		 * information even if the user has never run the screen location
		 * utility.
		 * This default location information will not return accurate results.
		 *  
		 * @return True, if this Screen object contains valid data.
		 * 
		 */
		public function isValid():Boolean
		{
			return context.call( "getScreenIsValid", id );
		}
		
		/**
		 * A Vector normal to the plane in which this Screen lies.
		 * 
		 * The normal vector is a unit direction vector orthogonal to the
		 * screen's surface plane. It points toward a viewer positioned
		 * for typical use of the monitor.
		 *  
		 * @return A Vector representing this Screen's normal vector.
		 * 
		 */
		public function normal():Vector3
		{
			return context.call( "getScreenNormal", id );
		}
		
		/**
		 * Compare Screen object equality/inequality.
		 * 
		 * Two Screen objects are equal if and only if both Screen objects
		 * represent the exact same Screens and both Screens are valid.
		 *  
		 * @param other The Screen to compare with.
		 * @return True, if this Screen object is equal; false otherwise.
		 * 
		 */
		public function isEqualTo( other:Screen ):Boolean
		{
			return ( other.id == this.id );
		}
		
		/**
		 * A string containing a brief, human readable description of the Screen object.
		 *  
		 * @return A description of the Screen as a string.
		 * 
		 */
		public function toString():String
		{
			return "[Screen id:" + id + " widthPixels:" + widthPixels() + " heightPixels:" + heightPixels() + "]";
		}
	}
}
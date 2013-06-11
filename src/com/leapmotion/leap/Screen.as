package com.leapmotion.leap
{
	import flash.utils.getDefinitionByName;

	/**
	 * The Screen class represents a computer monitor screen.
	 *
	 * <p>The Screen class reports characteristics describing the position and
	 * orientation of the monitor screen within the Leap Motion coordinate system.
	 * These characteristics include the bottom-left corner position of the
	 * screen, direction vectors for the horizontal and vertical axes of the
	 * screen, and the screen's normal vector. The screen must be properly
	 * registered with the Screen Locator for the Leap Motion to report these
	 * characteristics accurately. The Screen class also reports the size
	 * of the screen in pixels, using information obtained from the operating
	 * system.</p>
	 *
	 * <p>(Run the Screen Locator from the Leap Motion Settings dialog,
	 * on the Screen page.)</p>
	 *
	 * <p>You can get the point of intersection between the screen and a ray
	 * projected from a Pointable object using the <code>Screen.intersect()</code> function.
	 * Likewise, you can get the closest point on the screen to a point in
	 * space using the <code>Screen.distanceToPoint()</code> function. Again, the screen
	 * location must be registered with the Screen Locator for these
	 * functions to return accurate values.</p>
	 *
	 * <p>Note that Screen objects can be invalid, which means that they do not
	 * contain valid screen coordinate data and do not correspond to a
	 * physical entity. Test for validity with the <code>Screen.isValid()</code> function.</p>
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
		 * <p>A default screen with ID, 0, always exists and contains default
		 * characteristics, even if no screens have been located.</p>
		 */
		public var id:int = 0;

		/**
		 * @private
		 * Native Extension context.
		 */
		private var context:Object;

		/**
		 * @private
		 * Reference to flash.display.Screen (only available on AIR)
		 */
		public static var ScreenClass:*;

		/**
		 * @private
		 * Reference to the AIR builtin Screen instance
		 */
		public var _screen:*;

		/**
		 * @private
		 * Invalidates screen.
		 */
		public var _invalidate:Boolean = false;

		/**
		 * Constructs a Screen object.
		 *
		 * <p>An uninitialized screen is considered invalid. Get valid Screen
		 * objects from a ScreenList object obtained using the
		 * <code>Controller.locatedScreens()</code> method.</p>
		 *
		 */
		public function Screen( _controller:Controller )
		{
			if( !_controller || !_controller.context )
				throw new Error( "Native Context not available. The Screen class is only available in Adobe AIR." );
			else
				context = _controller.context;
		}

		/**
		 * @private
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
			catch( error:Error )
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
		 * within the Leap Motion coordinate system.
		 *
		 * <p>The magnitude of this vector estimates the physical width of
		 * this Screen in millimeters. The direction of this vector is
		 * parallel to the bottom edge of the screen and points toward
		 * the right edge of the screen.</p>
		 *
		 * <p>Together, <code>horizontalAxis()</code>, <code>verticalAxis()</code>, and <code>bottomLeftCorner()</code>
		 * describe the physical position, size and orientation of this Screen.</p>
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
		 * within the Leap Motion coordinate system.
		 *
		 * <p>The magnitude of this vector estimates the physical height of
		 * this Screen in millimeters. The direction of this vector is
		 * parallel to the left edge of the screen and points toward
		 * the top edge of the screen.</p>
		 *
		 * <p>Together, <code>horizontalAxis()</code>, <code>verticalAxis()</code>, and <code>bottomLeftCorner()</code>
		 * describe the physical position, size and orientation of this screen.</p>
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
		 * within the Leap Motion coordinate system.
		 *
		 * <p>The point represented by this vector defines the origin of the
		 * screen in the Leap Motion coordinate system.</p>
		 *
		 * <p>Together, <code>horizontalAxis()</code>, <code>verticalAxis()</code>, and <code>bottomLeftCorner()</code>
		 * describe the physical position, size and orientation of this Screen.</p>
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
		 * <p>The projected ray emanates from the Pointable tipPosition along
		 * the Pointable's direction vector.</p>
		 *
		 * <p>Set the normalize parameter to true to request the intersection
		 * point in normalized screen coordinates. Normalized screen coordinates
		 * are usually values between 0 and 1, where 0 represents the screen's
		 * origin at the bottom-left corner and 1 represents the opposite edge
		 * (either top or right). When you request normalized coordinates,
		 * the z-component of the returned vector is zero. Multiply a normalized
		 * coordinate by the values returned by <code>Screen.widthPixels()</code> or
		 * <code>Screen.heightPixels()</code> to calculate the screen position in pixels
		 * (remembering that many other computer graphics coordinate systems
		 * place the origin in the top-left corner).</p>
		 *
		 * <p>Set the normalize parameter to false to request the intersection
		 * point in Leap Motion coordinates (millimeters from the Leap Motion origin).</p>
		 *
		 * <p>If the Pointable object points outside the screen's border (but
		 * still intersects the plane in which the screen lies), the
		 * returned intersection point is clamped to the nearest point on
		 * the edge of the screen.</p>
		 *
		 * <p>You can use the clampRatio parameter to contract or expand the
		 * area in which you can point. For example, if you set the clampRatio
		 * parameter to 0.5, then the positions reported for intersection
		 * points outside the central 50% of the screen are moved to the border
		 * of this smaller area. If, on the other hand, you expanded the area
		 * by setting clampRatio to a value such as 3.0, then you could point
		 * well outside screen's physical boundary before the intersection
		 * points would be clamped. The positions for any points clamped
		 * would also be placed on this larger outer border. The positions
		 * reported for any intersection points inside the clamping border
		 * are unaffected by clamping.</p>
		 *
		 * <p>If the Pointable object does not point toward the plane of the
		 * screen (i.e. it is pointing parallel to or away from the screen),
		 * then the components of the returned vector are all set to
		 * <code>NaN</code> (not-a-number).</p>
		 *
		 *
		 * @param pointable 	The pointing finger or tool.
		 *
		 * @param normalize	 	If true, return normalized coordinates representing
		 * 						the intersection point as a percentage of the screen's
		 * 						width and height. If false, return Leap Motion coordinates
		 * 						(millimeters from the Leap Motion origin, which is located
		 * 						at the center of the top surface of the Leap Motion Controller).
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
		public function intersectPointable( pointable:Pointable, normalize:Boolean, clampRatio:Number = 1.0 ):Vector3
		{
			return context.call( "getScreenIntersect", id, pointable.tipPosition.x, pointable.tipPosition.y, pointable.tipPosition.z, pointable.direction.x, pointable.direction.y, pointable.direction.z, normalize, clampRatio );
		}

		/**
		 * Returns the intersection between this screen and a ray projecting
		 * from the specified position along the specified direction.
		 *
		 * <p>Set the normalize parameter to true to request the intersection
		 * point in normalized screen coordinates. Normalized screen coordinates
		 * are usually values between 0 and 1, where 0 represents the screen's
		 * origin at the bottom-left corner and 1 represents the opposite edge
		 * (either top or right). When you request normalized coordinates,
		 * the z-component of the returned vector is zero. Multiply a normalized
		 * coordinate by the values returned by <code>Screen.widthPixels()</code> or
		 * <code>Screen.heightPixels()</code> to calculate the screen position in pixels
		 * (remembering that many other computer graphics coordinate systems
		 * place the origin in the top-left corner).</p>
		 *
		 * <p>Set the normalize parameter to false to request the intersection
		 * point in Leap Motion coordinates (millimeters from the Leap Motion origin).</p>
		 *
		 * <p>If the Pointable object points outside the screen's border (but
		 * still intersects the plane in which the screen lies), the
		 * returned intersection point is clamped to the nearest point on
		 * the edge of the screen.</p>
		 *
		 * <p>You can use the clampRatio parameter to contract or expand the
		 * area in which you can point. For example, if you set the clampRatio
		 * parameter to 0.5, then the positions reported for intersection
		 * points outside the central 50% of the screen are moved to the border
		 * of this smaller area. If, on the other hand, you expanded the area
		 * by setting clampRatio to a value such as 3.0, then you could point
		 * well outside screen's physical boundary before the intersection
		 * points would be clamped. The positions for any points clamped
		 * would also be placed on this larger outer border. The positions
		 * reported for any intersection points inside the clamping border
		 * are unaffected by clamping.</p>
		 *
		 * <p>If the Pointable object does not point toward the plane of the
		 * screen (i.e. it is pointing parallel to or away from the screen),
		 * then the components of the returned vector are all set to
		 * <code>NaN</code> (not-a-number).</p>
		 *
		 *
		 * @param position		The position from which to check for screen intersection.
		 *
		 * @param direction		The direction in which to check for screen intersection.
		 *
		 * @param normalize		If true, return normalized coordinates representing
		 * 						the intersection point as a percentage of the screen's
		 * 						width and height. If false, return Leap Motion coordinates
		 * 						(millimeters from the Leap Motion origin, which is located
		 * 						at the center of the top surface of the Leap Motion Controller).
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
		 * @return				A Vector containing the coordinates of the intersection
		 *						between this Screen and a ray projecting from the
		 * 						specified Pointable object.
		 *
		 */
		public function intersect( position:Vector3, direction:Vector3, normalize:Boolean, clampRatio:Number = 1.0 ):Vector3
		{
			return context.call( "getScreenIntersect", id, position.x, position.y, position.z, direction.x, direction.y, direction.z, normalize, clampRatio );
		}

		/**
		 * Returns the projection from the specified position onto this screen.
		 *
		 * <p>Set the normalize parameter to true to request the projection point in
		 * normalized screen coordinates. Normalized screen coordinates are usually
		 * values between 0 and 1, where 0 represents the screen's origin at the
		 * bottom-left corner and 1 represents the opposite edge (either top or right).
		 * When you request normalized coordinates, the z-component of the returned
		 * vector is zero. Multiply a normalized coordinate by the values returned by
		 * <code>Screen.widthPixels()</code> or <code>Screen.heightPixels()</code> to calculate the screen position
		 * in pixels (remembering that many other computer graphics coordinate systems
		 * place the origin in the top-left corner).</p>
		 *
		 * <p>Set the normalize parameter to false to request the projection point in Leap
		 * coordinates (millimeters from the Leap Motion origin).</p>
		 *
		 * <p>If the specified point projects outside the screen's border, the returned
		 * projection point is clamped to the nearest point on the edge of the screen.</p>
		 *
		 * <p>You can use the clampRatio parameter to contract or expand the area in which
		 * you can point. For example, if you set the clampRatio parameter to 0.5, then
		 * the positions reported for projection points outside the central 50% of the
		 * screen are moved to the border of this smaller area. If, on the other hand,
		 * you expanded the area by setting clampRatio to a value such as 3.0, then you
		 * could point well outside screen's physical boundary before the projection
		 * points would be clamped. The positions for any points clamped would also be
		 * placed on this larger outer border. The positions reported for any projection
		 * points inside the clamping border are unaffected by clamping.</p>
		 *
		 * @param position		The position from which to project onto this screen.
		 *
		 * @param normalize		If true, return normalized coordinates representing
		 * 						the projection point as a percentage of the screen's
		 * 						width and height. If false, return Leap Motion coordinates
		 * 						(millimeters from the Leap Motion origin, which is located
		 * 						at the center of the top surface of the Leap Motion Controller).
		 * 						If true and the clampRatio parameter is set to 1.0,
		 * 						coordinates will be of the form (0..1, 0..1, 0).
		 * 						Setting the clampRatio to a different value changes
		 * 						the range for normalized coordinates. For example,
		 * 						a clampRatio of 5.0 changes the range of values to
		 * 						be of the form (-2..3, -2..3, 0).
		 *
		 * @param clampRatio	Adjusts the clamping border around this screen. By
		 * 						default this ratio is 1.0, and the border corresponds
		 * 						to the actual boundaries of the screen. Setting
		 * 						clampRatio to 0.5 would reduce the interaction area.
		 * 						Likewise, setting the ratio to 2.0 would increase the
		 * 						interaction area, adding 50% around each edge of the
		 * 						physical monitor. Projection points outside the
		 * 						interaction area are repositioned to the closest
		 * 						point on the clamping border before the vector
		 * 						is returned.
		 *
		 * @return				A Vector containing the coordinates of the projection
		 * 						between this screen and a ray projecting from the
		 * 						specified position onto the screen along its normal vector.
		 *
		 */
		public function project( position:Vector3, normalize:Boolean, clampRatio:Number = 1 ):Vector3
		{
			return context.call( "getScreenProject", id, position.x, position.y, position.z, normalize, clampRatio );
		}

		/**
		 * Returns an invalid Screen object.
		 *
		 * <p>You can use the instance returned by this function in comparisons
		 * testing whether a given Hand instance is valid or invalid.
		 * (You can also use the <code>Screen.isValid()</code> function.)</p>
		 *
		 * @return The invalid Screen instance.
		 *
		 */
		static public function invalid():Screen
		{
			var invalidScreen:Screen = new Screen( null );
			invalidScreen._invalidate = true;
			return invalidScreen;
		}

		/**
		 * Reports whether this is a valid Screen object.
		 *
		 * <p><strong>Important: A valid Screen object does not necessarily contain
		 * up-to-date screen location information.</strong><br/>Location information is
		 * only accurate until the Leap Motion Controller or the monitor are moved.
		 * In addition, the primary screen always contains default location
		 * information even if the user has never run the screen location
		 * utility.<br/>
		 * This default location information will not return accurate results.</p>
		 *
		 * @return True, if this Screen object contains valid data.
		 *
		 */
		public function isValid():Boolean
		{
			if( _invalidate )
				return false;
			else
				return context.call( "getScreenIsValid", id );
		}

		/**
		 * A Vector normal to the plane in which this Screen lies.
		 *
		 * <p>The normal vector is a unit direction vector orthogonal to the
		 * screen's surface plane. It points toward a viewer positioned
		 * for typical use of the monitor.</p>
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
		 * <p>Two Screen objects are equal if and only if both Screen objects
		 * represent the exact same Screens and both Screens are valid.</p>
		 *
		 * @param other The Screen to compare with.
		 * @return True, if this Screen object is equal; false otherwise.
		 *
		 */
		public function isEqualTo( other:Screen ):Boolean
		{
			return ( ( other.id == id ) && isValid() && other.isValid() );
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

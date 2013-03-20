package com.leapmotion.leap
{
	import com.leapmotion.leap.callbacks.DefaultCallback;
	import com.leapmotion.leap.interfaces.ILeapCallback;
	import com.leapmotion.leap.interfaces.ILeapConnection;
	import com.leapmotion.leap.namespaces.leapmotion;
	import com.leapmotion.leap.native.LeapNative;
	import com.leapmotion.leap.socket.LeapSocket;
	
	import flash.events.EventDispatcher;

	/**
	 * The main event dispatcher for Leap events.
	 * @author logotype
	 *
	 */
	[Event( name = "leapmotionInit", type = "com.leapmotion.leap.events.LeapEvent" )]
	[Event( name = "leapmotionConnected", type = "com.leapmotion.leap.events.LeapEvent" )]
	[Event( name = "leapmotionDisconnected", type = "com.leapmotion.leap.events.LeapEvent" )]
	[Event( name = "leapmotionTimeout", type = "com.leapmotion.leap.events.LeapEvent" )]
	[Event( name = "leapmotionExit", type = "com.leapmotion.leap.events.LeapEvent" )]
	[Event( name = "leapmotionFrame", type = "com.leapmotion.leap.events.LeapEvent" )]
	public class Controller extends EventDispatcher
	{
		/**
		 * The Listener subclass instance.
		 */
		leapmotion var callback:ILeapCallback;

		/**
		 * Current connection, either native or socket.
		 */
		public var connection:ILeapConnection;

		/**
		 * The singleton instance.
		 */
		static private var instance:Controller;

		/**
		 * History of frame of tracking data from the Leap.
		 */
		public var frameHistory:Vector.<Frame> = new Vector.<Frame>();
		
		/**
		 * Native Extension context object. 
		 * 
		 */
		public var context:Object;
		
		/**
		 * List of Screen objects, created by calibratedScreens(). 
		 */
		private var _screenList:Vector.<Screen> = new Vector.<Screen>();

		public function Controller()
		{
			leapmotion::callback = new DefaultCallback();
		}

		/**
		 * Initializes connection to the Leap.
		 *
		 * @param host Optional. The host computer with the Leap device
		 * (currently only supported for socket connections).
		 *
		 */
		public function init( host:String = null ):void
		{
			if ( !host && LeapNative.isSupported() )
			{
				connection = new LeapNative();
			}
			else
			{
				connection = new LeapSocket( host );
			}
		}

		/**
		 * Returns a frame of tracking data from the Leap.
		 *
		 * Use the optional history parameter to specify which frame to retrieve.
		 * Call frame() or frame(0) to access the most recent frame; call frame(1)
		 * to access the previous frame, and so on. If you use a history value
		 * greater than the number of stored frames, then the controller returns
		 * an invalid frame.
		 *
		 * @param history The age of the frame to return, counting backwards from
		 * the most recent frame (0) into the past and up to the maximum age (59).
		 *
		 * @return The specified frame; or, if no history parameter is specified,
		 * the newest frame. If a frame is not available at the specified
		 * history position, an invalid Frame is returned.
		 *
		 */
		public function frame( history:int = 0 ):Frame
		{
			var returnValue:Frame;

			if ( history >= frameHistory.length )
				returnValue = Frame.invalid();
			else if ( history == 0 )
				returnValue = connection.frame;
			else
				returnValue = frameHistory[ history ];

			return returnValue;
		}

		/**
		 * Update the object that receives direct updates from the Leap device.
		 * The default callback will make the controller dispatch flash events.
		 * You can override this behaviour, by implementing the IListener interface
		 * in your own classes, and use this method to set the callback to your
		 * own implementation.
		 *
		 * @param callback
		 */
		public function setCallback( callback:ILeapCallback ):void
		{
			this.leapmotion::callback = callback;
		}
		
		/**
		 * The list of screens whose positions have been identified by using
		 * the Leap application Screen Locator.
		 * 
		 * The list always contains at least one entry representing the
		 * default screen. If the user has not registered the location of
		 * this default screen, then the coordinates, directions, and other
		 * values reported by the functions in its Screen object will not
		 * be accurate. Other monitor screens only appear in the list if
		 * their positions have been registered using the Leap Screen Locator.
		 * 
		 * A Screen object represents the position and orientation of a
		 * display monitor screen within the Leap coordinate system.
		 * For example, if the screen location is known, you can get Leap
		 * coordinates for the bottom-left corner of the screen.
		 * Registering the screen location also allows the Leap to calculate
		 * the point on the screen at which a finger or tool is pointing.
		 * 
		 * A user can run the Screen Locator tool from the Leap application
		 * Settings window. Avoid assuming that a screen location is known
		 * or that an existing position is still correct. The registered
		 * position is only valid as long as the relative position of the
		 * Leap device and the monitor screen remain constant.
		 *  
		 * @return ScreenList A list containing the screens whose positions
		 * have been registered by the user using the Screen Locator tool.
		 * The list always contains at least one entry representing the
		 * default monitor. If the user has not run the Screen Locator or
		 * has moved the Leap device or screen since running it, the
		 * Screen object for this entry only contains default values. 
		 * 
		 */
		public function calibratedScreens():Vector.<Screen>
		{
			if( _screenList.length == 0 )
			{
				if( Screen.tryCreatingScreenClassReference() )
				{
					var screen:Screen;
					var screenArray:Array = Screen.ScreenClass.screens;
					var i:int = 0;
					var length:int = screenArray.length;
					
					for( i; i < length; ++i )
					{
						screen = new Screen();
						screen._screen = screenArray[ i ];
						screen.id = i;
						_screenList.push( screen );
					}
				}
				return _screenList;
			}
			else
			{
				return _screenList;
			}
		}
		
		/**
		 * Gets the closest Screen intercepting a ray projecting from the
		 * specified Pointable object.
		 * 
		 * The projected ray emanates from the Pointable tipPosition along
		 * the Pointable's direction vector. If the projected ray does not
		 * intersect any screen surface directly, then the Leap checks for
		 * intersection with the planes extending from the surfaces of the
		 * known screens and returns the Screen with the closest intersection.
		 * 
		 * If no intersections are found (i.e. the ray is directed parallel
		 * to or away from all known screens), then an invalid Screen object
		 * is returned.
		 * 
		 * Note: Be sure to test whether the Screen object returned by this
		 * method is valid. Attempting to use an invalid Screen object will
		 * lead to incorrect results.
		 *  
		 * @param pointable The Pointable object to check for screen intersection.
		 * @return The closest Screen toward which the specified Pointable object
		 * is pointing, or, if the pointable is not pointing in the direction
		 * of any known screen, an invalid Screen object.
		 * 
		 */
		public function closestScreenHit( pointable:Pointable ):Screen
		{
			var screenId:int = context.call( "getClosestScreenHit", pointable.id );
			var returnValue:Screen = null;
			var screenList:Vector.<Screen> = calibratedScreens();
			
			for each ( var screen:Screen in screenList )
			{
				if( screen.id == screenId )
				{
					returnValue = screen;
					break;
				}
			}
			
			return returnValue;
		}

		/**
		 * Enables or disables reporting of a specified gesture type.
		 * By default, all gesture types are disabled. When disabled, gestures of
		 * the disabled type are never reported and will not appear in the frame
		 * gesture list.
		 * 
		 * As a performance optimization, only enable recognition for the types
		 * of movements that you use in your application.
		 *  
		 * @param type The type of gesture to enable or disable. Must be a member of the Gesture::Type enumeration.
		 * @param enable True, to enable the specified gesture type; False, to disable.
		 * 
		 */
		public function enableGesture( type:int, enable:Boolean = true ):void
		{
			connection.enableGesture( type, enable );
		}
		
		/**
		 * Reports whether the specified gesture type is enabled.
		 *  
		 * @param type The Gesture.TYPE parameter.
		 * @return True, if the specified type is enabled; false, otherwise.
		 * 
		 */
		public function isGestureEnabled( type:int ):Boolean
		{
			return connection.isGestureEnabled( type );
		}

		static public function getInstance():Controller
		{
			if ( instance == null )
				instance = new Controller();

			return instance;
		}
	}
}

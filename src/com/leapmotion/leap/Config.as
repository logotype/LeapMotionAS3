package com.leapmotion.leap
{

	/**
	 * The Config class provides access to Leap Motion system configuration information.
	 *
	 * <p>You can get and set gesture configuration parameters using the Config
	 * object obtained from a connected Controller object. The key strings
	 * required to identify a configuration parameter include:</p>
	 *
	 * <table class="innertable">
	 *   <tr>
	 *    <th>Key string</th>
	 *    <th>Value type</th>
	 *    <th>Default value</th>
	 *    <th>Units</th>
	 *  </tr>
	 *   <tr>
	 *    <td>Gesture.Circle.MinRadius</td>
	 *    <td>float</td>
	 *    <td>5.0</td>
	 *    <td>mm</td>
	 *  </tr>
	 *   <tr>
	 *    <td>Gesture.Circle.MinArc</td>
	 *    <td>float</td>
	 *    <td>1.5&#42;pi</td>
	 *    <td>radians</td>
	 *  </tr>
	 *   <tr>
	 *    <td>Gesture.Swipe.MinLength</td>
	 *    <td>float</td>
	 *    <td>150</td>
	 *    <td>mm</td>
	 *  </tr>
	 *   <tr>
	 *    <td>Gesture.Swipe.MinVelocity</td>
	 *    <td>float</td>
	 *    <td>1000</td>
	 *    <td>mm/s</td>
	 *  </tr>
	 *   <tr>
	 *    <td>Gesture.KeyTap.MinDownVelocity</td>
	 *    <td>float</td>
	 *    <td>50</td>
	 *    <td>mm/s</td>
	 *  </tr>
	 *   <tr>
	 *    <td>Gesture.KeyTap.HistorySeconds</td>
	 *    <td>float</td>
	 *    <td>0.1</td>
	 *    <td>s</td>
	 *  </tr>
	 *   <tr>
	 *    <td>Gesture.KeyTap.MinDistance</td>
	 *    <td>float</td>
	 *    <td>5.0</td>
	 *    <td>mm</td>
	 *  </tr>
	 *   <tr>
	 *    <td>Gesture.ScreenTap.MinForwardVelocity</td>
	 *    <td>float</td>
	 *    <td>50</td>
	 *    <td>mm/s</td>
	 *  </tr>
	 *   <tr>
	 *    <td>Gesture.ScreenTap.HistorySeconds</td>
	 *    <td>float</td>
	 *    <td>0.1</td>
	 *    <td>s</td>
	 *  </tr>
	 *   <tr>
	 *    <td>Gesture.ScreenTap.MinDistance</td>
	 *    <td>float</td>
	 *    <td>3.0</td>
	 *    <td>mm</td>
	 *  </tr>
	 * </table>
	 *
	 * <p>After setting a configuration value, you must call the <code>Config.save()</code> method
	 * to commit the changes. The configuration value changes are not persistent;
	 * your application must set the values everytime it runs.</p>
	 *
	 * @author logotype
	 *
	 */
	public class Config
	{
		/**
		 * The data type is unknown.
		 */
		static public const TYPE_UNKNOWN:int = 0;

		/**
		 * A boolean value.
		 */
		static public const TYPE_BOOLEAN:int = 1;

		/**
		 * A 32-bit integer.
		 */
		static public const TYPE_INT32:int = 2;

		/**
		 * A floating-point number.
		 */
		static public const TYPE_FLOAT:int = 6;

		/**
		 * A string of characters.
		 */
		static public const TYPE_STRING:int = 8;

		/**
		 * @private
		 * Native Extension context.
		 */
		private var context:Object;

		/**
		 * Constructs a Config object.
		 *
		 * @param controller The Controller object reference.
		 *
		 */
		public function Config( controller:Controller )
		{
			if( !controller.context )
				throw new Error( "Native Context not available. The Config class is only available in Adobe AIR." );
			else
				context = controller.context;
		}

		/**
		 * Gets the boolean representation for the specified key.
		 *
		 * @param key
		 * @param value
		 * @return true on success, false on failure.
		 *
		 */
		public function getBool( key:String ):Boolean
		{
			return context.call( "getConfigBool", key );
		}

		/**
		 * Gets the floating point representation for the specified key.
		 * @param key
		 * @param value
		 * @return true on success, false on failure.
		 *
		 */
		public function getFloat( key:String ):Number
		{
			return context.call( "getConfigFloat", key );
		}

		/**
		 * Gets the 32-bit integer representation for the specified key.
		 * @param key
		 * @param value
		 * @return true on success, false on failure.
		 *
		 */
		public function getInt32( key:String ):int
		{
			return context.call( "getConfigInt32", key );
		}

		/**
		 * Gets the string representation for the specified key.
		 * @param key
		 * @param value
		 * @return true on success, false on failure.
		 *
		 */
		public function getString( key:String ):String
		{
			return context.call( "getConfigString", key );
		}

		/**
		 * Sets the boolean representation for the specified key.
		 *
		 * @param key
		 * @param value
		 * @return true on success, false on failure.
		 *
		 */
		public function setBool( key:String, value:Boolean ):Boolean
		{
			return context.call( "setConfigBool", key, value );
		}

		/**
		 * Sets the floating point representation for the specified key.
		 * @param key
		 * @param value
		 * @return true on success, false on failure.
		 *
		 */
		public function setFloat( key:String, value:Number ):Boolean
		{
			return context.call( "setConfigFloat", key, value );
		}

		/**
		 * Sets the 32-bit integer representation for the specified key.
		 * @param key
		 * @param value
		 * @return true on success, false on failure.
		 *
		 */
		public function setInt32( key:String, value:int ):Boolean
		{
			return context.call( "setConfigInt32", key, value );
		}

		/**
		 * Sets the string representation for the specified key.
		 * @param key
		 * @param value
		 * @return true on success, false on failure.
		 *
		 */
		public function setString( key:String, value:String ):Boolean
		{
			return context.call( "setConfigString", key, value );
		}

		/**
		 * Saves the current state of the config.
		 *
		 * Call <code>save()</code> after making a set of configuration changes.
		 * The <code>save()</code> function transfers the configuration changes
		 * to the Leap Motion application. The configuration value changes are not
		 * persistent; your application must set the values everytime it runs.
		 *
		 * @return
		 *
		 */
		public function save():Boolean
		{
			return context.call( "setConfigSave" );
		}

		/**
		 * Reports the natural data type for the value related to the specified key.
		 *
		 * @param key The key for the looking up the value in the configuration dictionary.
		 * @return The native data type of the value, that is, the type that does not require a data conversion.
		 *
		 */
		public function type( key:String ):String
		{
			var returnType:int = context.call( "getConfigType", key );
			switch( returnType )
			{
				case TYPE_BOOLEAN:
					return "[TYPE_BOOLEAN]";
				case TYPE_INT32:
					return "[TYPE_INT32]";
				case TYPE_FLOAT:
					return "[TYPE_FLOAT]";
				case TYPE_STRING:
					return "[TYPE_STRING]";
			}
			return "[TYPE_UNKNOWN]";
		}
	}
}

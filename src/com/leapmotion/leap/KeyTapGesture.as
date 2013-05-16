package com.leapmotion.leap
{

	/**
	 * The KeyTapGesture class represents a tapping gesture by a finger or tool.
	 *
	 * <p>A key tap gesture is recognized when the tip of a finger rotates down
	 * toward the palm and then springs back to approximately the original
	 * postion, as if tapping. The tapping finger must pause briefly before
	 * beginning the tap.</p>
	 *
	 * <p><strong>Important: To use key tap gestures in your application, you must enable
	 * recognition of the key tap gesture.</strong><br/>You can enable recognition with:</p>
	 *
	 * <code>leap.controller.enableGesture(Gesture.TYPE_KEY_TAP);</code>
	 *
	 * <p>Key tap gestures are discrete. The KeyTapGesture object representing a
	 * tap always has the state, <code>STATE_STOP</code>. Only one KeyTapGesture object
	 * is created for each key tap gesture recognized.</p>
	 *
	 * <p>You can set the minimum finger movement and velocity required for a movement
	 * to be recognized as a key tap as well as adjust the detection window for evaluating
	 * the movement using the config attribute of a connected Controller object.
	 * Use the following configuration keys to configure key tap recognition:</p>
	 *
	 * <table class="innertable">
	 *   <tr>
	 *    <th>Key string</th>
	 *    <th>Value type</th>
	 *    <th>Default value</th>
	 *    <th>Units</th>
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
	 * </table>
	 *
	 * <p>The following example demonstrates how to set the screen tap configuration parameters:</p>
	 *
	 * <code>if(controller.config().setFloat(&quot;Gesture.KeyTap.MinDownVelocity&quot;, 40.0) &amp;&amp;
	 *       controller.config().setFloat(&quot;Gesture.KeyTap.HistorySeconds&quot;, .2) &amp;&amp;
	 *       controller.config().setFloat(&quot;Gesture.KeyTap.MinDistance&quot;, 8.0))
	 *        controller.config().save();</code>
	 *
	 * @author logotype
	 *
	 */
	public class KeyTapGesture extends Gesture
	{
		/**
		 * The type value designating a key tap gesture.
		 */
		static public var classType:int = Gesture.TYPE_KEY_TAP;

		/**
		 * The current direction of finger tip motion.
		 *
		 * <p>At the start of the key tap gesture, the direction points in the
		 * direction of the tap. At the end of the key tap gesture, the direction
		 * will either point toward the original finger tip position or it will
		 * be a zero-vector, which indicates that finger movement stopped before
		 * returning to the starting point.</p>
		 */
		public var direction:Vector3;

		/**
		 * The finger performing the key tap gesture.
		 */
		public var pointable:Pointable;

		/**
		 * The position where the key tap is registered.
		 */
		public var position:Vector3;

		/**
		 * The progess value is always 1.0 for a key tap gesture.
		 */
		public var progress:Number = 1;

		/**
		 * Constructs a new KeyTapGesture object.
		 *
		 * <p>An uninitialized KeyTapGesture object is considered invalid.
		 * Get valid instances of the KeyTapGesture class from a Frame object.</p>
		 *
		 */
		public function KeyTapGesture()
		{
		}
	}
}

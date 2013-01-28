package
{
	import com.leapmotion.leap.*;
	import com.leapmotion.leap.util.*;
	import com.leapmotion.leap.events.*;
	import flash.display.Sprite;

	public class Sample extends Sprite
	{
		private var leap:LeapMotion;

		public function Sample()
		{
			leap = new LeapMotion();
			leap.controller.addEventListener( LeapMotionEvent.LEAPMOTION_INIT, onInit );
			leap.controller.addEventListener( LeapMotionEvent.LEAPMOTION_CONNECTED, onConnect );
			leap.controller.addEventListener( LeapMotionEvent.LEAPMOTION_DISCONNECTED, onDisconnect );
			leap.controller.addEventListener( LeapMotionEvent.LEAPMOTION_EXIT, onExit );
			leap.controller.addEventListener( LeapMotionEvent.LEAPMOTION_FRAME, onFrame );
		}

		public function onInit( event:LeapMotionEvent ):void
		{
			trace( "Initialized" );
		}

		public function onConnect( event:LeapMotionEvent ):void
		{
			trace( "Connected" );
		}

		public function onDisconnect( event:LeapMotionEvent ):void
		{
			trace( "Disconnected" );
		}

		public function onExit( event:LeapMotionEvent ):void
		{
			trace( "Exited" );
		}

		public function onFrame( event:LeapMotionEvent ):void
		{
			// Get the most recent frame and report some basic information
			var frame:Frame = event.frame;
			trace( "Frame id: " + frame.id + ", timestamp: " + frame.timestamp + ", hands: " + frame.hands.length + ", fingers: " + frame.fingers.length + ", tools: " + frame.tools.length );

			if ( frame.hands.length > 0 )
			{
				// Get the first hand
				var hand:Hand = frame.hands[ 0 ];

				// Check if the hand has any fingers
				var fingers:Vector.<Finger> = hand.fingers;
				if ( !fingers.length == 0 )
				{
					// Calculate the hand's average finger tip position
					var avgPos:Vector3 = new Vector3( 0, 0, 0 );
					for each ( var finger:Finger in fingers )
						avgPos = avgPos.plus( finger.tipPosition );

					avgPos = avgPos.divide( fingers.length );
					trace( "Hand has " + fingers.length + " fingers, average finger tip position: " + avgPos );
				}

				// Get the hand's sphere radius and palm position
				trace( "Hand sphere radius: " + hand.sphereRadius + " mm, palm position: " + hand.palmPosition );

				// Get the hand's normal vector and direction
				var normal:Vector3 = hand.palmNormal;
				var direction:Vector3 = hand.direction;

				// Calculate the hand's pitch, roll, and yaw angles
				trace( "Hand pitch: " + LeapMath.toDegrees( direction.pitch ) + " degrees, " + "roll: " + LeapMath.toDegrees( normal.roll ) + " degrees, " + "yaw: " + LeapMath.toDegrees( direction.yaw ) + " degrees\n" );
			}
		}
	}
}
package
{
	import com.leapmotion.leap.*;
	import com.leapmotion.leap.events.*;
	import com.leapmotion.leap.util.*;
	
	import flash.display.Sprite;

	[SWF(frameRate=60)]
	public class Sample extends Sprite
	{
		private var leap:LeapMotion;

		public function Sample()
		{
			leap = new LeapMotion();
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_INIT, onInit );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, onConnect );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_EXIT, onExit );
			leap.controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
		}

		private function onInit( event:LeapEvent ):void
		{
			trace( "Initialized" );
		}

		private function onConnect( event:LeapEvent ):void
		{
			trace( "Connected" );
			leap.controller.enableGesture( Gesture.TYPE_SWIPE );
			leap.controller.enableGesture( Gesture.TYPE_CIRCLE );
			leap.controller.enableGesture( Gesture.TYPE_SCREEN_TAP );
			leap.controller.enableGesture( Gesture.TYPE_KEY_TAP );
			leap.controller.setPolicyFlags( Controller.POLICY_BACKGROUND_FRAMES );
		}

		private function onDisconnect( event:LeapEvent ):void
		{
			trace( "Disconnected" );
		}

		private function onExit( event:LeapEvent ):void
		{
			trace( "Exited" );
		}

		private function onFrame( event:LeapEvent ):void
		{
			// Get the most recent frame and report some basic information
			var frame:Frame = event.frame;
			trace( "Frame id: " + frame.id + ", timestamp: " + frame.timestamp + ", hands: " + frame.hands.length + ", fingers: " + frame.fingers.length + ", tools: " + frame.tools.length + ", gestures: " + frame.gestures().length );

			if ( frame.hands.length > 0 )
			{
				// Get the first hand
				var hand:Hand = frame.hands[ 0 ];

				// Check if the hand has any fingers
				var fingers:Vector.<Finger> = hand.fingers;
				if ( !fingers.length == 0 )
				{
					// Calculate the hand's average finger tip position
					var avgPos:Vector3 = Vector3.zero();
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
				trace( "Hand pitch: " + LeapUtil.toDegrees( direction.pitch ) + " degrees, " + "roll: " + LeapUtil.toDegrees( normal.roll ) + " degrees, " + "yaw: " + LeapUtil.toDegrees( direction.yaw ) + " degrees\n" );
			}

			var gestures:Vector.<Gesture> = frame.gestures();
			for ( var i:int = 0; i < gestures.length; i++ )
			{
				var gesture:Gesture = gestures[ i ];

				switch ( gesture.type )
				{
					case Gesture.TYPE_CIRCLE:
						var circle:CircleGesture = CircleGesture( gesture );

						// Calculate clock direction using the angle between circle normal and pointable
						var clockwiseness:String;
						if ( circle.pointable.direction.angleTo( circle.normal ) <= Math.PI / 4 )
						{
							// Clockwise if angle is less than 90 degrees
							clockwiseness = "clockwise";
						}
						else
						{
							clockwiseness = "counterclockwise";
						}

						// Calculate angle swept since last frame
						var sweptAngle:Number = 0;
						if ( circle.state != Gesture.STATE_START )
						{
							var previousGesture:Gesture = leap.frame( 1 ).gesture( circle.id );
							if( previousGesture.isValid() )
							{
								var previousUpdate:CircleGesture = CircleGesture( leap.frame( 1 ).gesture( circle.id ) );
								sweptAngle = ( circle.progress - previousUpdate.progress ) * 2 * Math.PI;
							}
						}

						trace( "Circle id: " + circle.id + ", " + circle.state + ", progress: " + circle.progress + ", radius: " + circle.radius + ", angle: " + LeapUtil.toDegrees( sweptAngle ) + ", " + clockwiseness );
						break;
					case Gesture.TYPE_SWIPE:
						var swipe:SwipeGesture = SwipeGesture( gesture );
						trace( "Swipe id: " + swipe.id + ", " + swipe.state + ", position: " + swipe.position + ", direction: " + swipe.direction + ", speed: " + swipe.speed );
						break;
					case Gesture.TYPE_SCREEN_TAP:
						var screenTap:ScreenTapGesture = ScreenTapGesture( gesture );
						trace( "Screen Tap id: " + screenTap.id + ", " + screenTap.state + ", position: " + screenTap.position + ", direction: " + screenTap.direction );
						break;
					case Gesture.TYPE_KEY_TAP:
						var keyTap:KeyTapGesture = KeyTapGesture( gesture );
						trace( "Key Tap id: " + keyTap.id + ", " + keyTap.state + ", position: " + keyTap.position + ", direction: " + keyTap.direction );
						break;
					default:
						trace( "Unknown gesture type." );
						break;
				}
			}
		}
	}
}

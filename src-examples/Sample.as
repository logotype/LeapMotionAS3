package
{
	import com.leapmotion.leap.*;
	import com.leapmotion.leap.events.*;
	import com.leapmotion.leap.util.*;
	
	import flash.display.Sprite;
	import flash.display.Bitmap;

    [SWF(width="1280", height="480", frameRate="60", backgroundColor="#000000")]
	public class Sample extends Sprite implements Listener
	{
		private var controller:Controller;
		private var bitmap1:Bitmap = new Bitmap();
		private var bitmap2:Bitmap = new Bitmap();

		public function Sample()
		{
			this.addChild( bitmap1 );
			this.addChild( bitmap2 );
			bitmap2.x = 640;
			controller = new Controller();
			controller.setListener( this );
		}

		public function onInit( controller:Controller ):void
		{
			trace( "onInit" );
		}
		
		public function onConnect( controller:Controller ):void
		{
			trace( "onConnect" );
			controller.enableGesture( Gesture.TYPE_SWIPE );
			controller.enableGesture( Gesture.TYPE_CIRCLE );
			controller.enableGesture( Gesture.TYPE_SCREEN_TAP );
			controller.enableGesture( Gesture.TYPE_KEY_TAP );
			controller.setPolicyFlags( Controller.POLICY_IMAGES );
		}
		
		public function onDisconnect( controller:Controller ):void
		{
			trace( "onDisconnect" );
		}
		
		public function onExit( controller:Controller ):void
		{
			trace( "onExit" );
		}
		
		public function onFocusGained( controller:Controller ):void
		{
			trace( "onFocusGained" );
		}
		
		public function onFocusLost( controller:Controller ):void
		{
			trace( "onFocusLost" );
		}
		
		public function onServiceConnect( controller:Controller ):void
		{
			trace( "onServiceConnect" );
		}
		
		public function onServiceDisconnect( controller:Controller ):void
		{
			trace( "onServiceDisconnect" );
		}
		
		public function onDeviceChange( controller:Controller ):void
		{
			trace( "onDeviceChange" );
		}
		
		public function onFrame( controller:Controller, frame:Frame ):void
		{
			// Get the most recent frame and report some basic information
			trace( "Frame id: " + frame.id + ", timestamp: " + frame.timestamp + ", hands: " + frame.hands.length + ", fingers: " + frame.fingers.length + ", tools: " + frame.tools.length + ", gestures: " + frame.gestures().length );

			if ( frame.images.length > 0 )
			{
				var image1:Image = frame.images[0];
				bitmap1.bitmapData = image1.data;
				bitmap1.width = 640;
				bitmap1.height = 480;

				var image2:Image = frame.images[1];
				bitmap2.bitmapData = image2.data;
				bitmap2.width = 640;
				bitmap2.height = 480;
			}

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
					{
						avgPos = avgPos.plus( finger.tipPosition );

						// Skeleton API
						trace( "Skeleton distal: " + finger.dipPosition );
						trace( "Skeleton proximal: " + finger.pipPosition );
						trace( "Skeleton knuckle: " + finger.mcpPosition );
						trace( "Finger type: " + finger.type );
						
						// Bone API
						trace( "Bone metacarpal: " + finger.metacarpal );
						trace( "Bone proximal: " + finger.proximal );
						trace( "Bone intermediate: " + finger.intermediate );
						trace( "Bone distal: " + finger.distal );
					}

					avgPos = avgPos.divide( fingers.length );
					trace( "Hand has " + fingers.length + " fingers, average finger tip position: " + avgPos );
				}

				// Get the hand's sphere radius and palm position
				trace( "Hand sphere radius: " + hand.sphereRadius + " mm, palm position: " + hand.palmPosition );

				// Get the hand's normal vector and direction
				var normal:Vector3 = hand.palmNormal;
				var direction:Vector3 = hand.direction;

				// Calculate the hand's pitch, roll, and yaw angles
				trace( "Hand pitch: " + LeapUtil.toDegrees( direction.pitch ) + " degrees, " + "roll: " + LeapUtil.toDegrees( normal.roll ) + " degrees, " + "yaw: " + LeapUtil.toDegrees( direction.yaw ) + " degrees, " + "arm: " + hand.arm + "\n" );
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
							var previousGesture:Gesture = controller.frame( 1 ).gesture( circle.id );
							if( previousGesture.isValid() && previousGesture.type == Gesture.TYPE_CIRCLE )
							{
								var previousUpdate:CircleGesture = CircleGesture( controller.frame( 1 ).gesture( circle.id ) );
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

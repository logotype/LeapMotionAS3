package com.leapmotion.leap
{

	import com.worlize.websocket.WebSocket;
	import com.worlize.websocket.WebSocketErrorEvent;
	import com.worlize.websocket.WebSocketEvent;

	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	import mx.utils.Base64Encoder;

	public class LeapMotion extends EventDispatcher
	{
		private var websocket:WebSocket;
		private var b64e:Base64Encoder; // Needed for linkage

		public function LeapMotion()
		{
			websocket = new WebSocket( "ws://localhost:6437", "*" );
			websocket.addEventListener( WebSocketEvent.CLOSED, handleWebSocketClosed );
			websocket.addEventListener( WebSocketEvent.OPEN, handleWebSocketOpen );
			websocket.addEventListener( WebSocketEvent.MESSAGE, handleWebSocketMessage );
			websocket.addEventListener( IOErrorEvent.IO_ERROR, handleIOError );
			websocket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, handleSecurityError );
			websocket.addEventListener( WebSocketErrorEvent.CONNECTION_FAIL, handleConnectionFail );
			websocket.debug = true;
		}

		public function init():void
		{
			this.dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_INIT ));
			websocket.connect();
		}

		// Websocket wrapper start
		private function handleWebSocketClosed( event:WebSocketEvent ):void
		{
			this.dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_EXIT ));
		}

		private function handleWebSocketOpen( event:WebSocketEvent ):void
		{
			this.dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_CONNECTED ));
		}

		private function handleWebSocketMessage( event:WebSocketEvent ):void
		{
			parseFrame( event.message.utf8Data );
		}

		private function handleIOError( event:IOErrorEvent ):void
		{
			this.dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_DISCONNECTED ));
			this.dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_EXIT ));
		}

		private function handleSecurityError( event:SecurityErrorEvent ):void
		{
			this.dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_DISCONNECTED ));
			this.dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_EXIT ));
		}

		private function handleConnectionFail( event:WebSocketErrorEvent ):void
		{
			this.dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_DISCONNECTED ));
			this.dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_EXIT ));
		}

		private function parseFrame( rawFrame:String ):void
		{
			var i:uint = 0;
			var j:uint = 0;
			var json:Object = JSON.parse( rawFrame );
			var frame:Frame = new Frame();
			var hand:Hand;
			var finger:Finger;
			var vector:Vector3;

			// Hands
			if ( json.hands )
			{
				for ( i = 0; i < json.hands.length; ++i )
				{
					hand = new Hand();
					hand.direction = new Vector3( json.hands[ i ].direction[ 0 ], json.hands[ i ].direction[ 1 ], json.hands[ i ].direction[ 2 ]);
					hand.id = json.hands[ i ].id;
					hand.palmNormal = new Vector3( json.hands[ i ].palmNormal[ 0 ], json.hands[ i ].palmNormal[ 1 ], json.hands[ i ].palmNormal[ 2 ]);
					hand.palmPosition = new Vector3( json.hands[ i ].palmPosition[ 0 ], json.hands[ i ].palmPosition[ 1 ], json.hands[ i ].palmPosition[ 2 ]);
					hand.palmVelocity = new Vector3( json.hands[ i ].palmPosition[ 0 ], json.hands[ i ].palmPosition[ 1 ], json.hands[ i ].palmPosition[ 2 ]);
					for ( j = 0; j < json.hands[ i ].r.length; ++j )
					{
						vector = new Vector3( json.hands[ i ].r[ j ][ 0 ], json.hands[ i ].r[ j ][ 1 ], json.hands[ i ].r[ j ][ 2 ]);
						hand.r.push( vector );
					}
					hand.s = json.hands[ i ].s;
					hand.sphereCenter = new Vector3( json.hands[ i ].sphereCenter[ 0 ], json.hands[ i ].sphereCenter[ 1 ], json.hands[ i ].sphereCenter[ 2 ]);
					hand.sphereRadius = json.hands[ i ].sphereRadius;
					hand.t = new Vector3( json.hands[ i ].t[ 0 ], json.hands[ i ].t[ 1 ], json.hands[ i ].t[ 2 ]);
					frame.hands.push( hand );

					// Set primary hand
					if ( i == 0 )
						frame.hand = hand;
				}
			}

			// ID
			frame.id = json.id;

			// Pointables
			if ( json.pointables )
			{
				for ( i = 0; i < json.pointables.length; ++i )
				{
					finger = new Finger();
					finger.direction = new Vector3( json.pointables[ i ].direction[ 0 ], json.pointables[ i ].direction[ 1 ], json.pointables[ i ].direction[ 2 ]);
					frame.fingers.push( finger );
					// Set primary finger
					if ( i == 0 )
						frame.finger = finger;
				}
			}

			// R
			if( json.r )
			{
				for ( i = 0; i < json.r.length; ++i )
				{
					vector = new Vector3( json.r[ i ][ 0 ], json.r[ i ][ 1 ], json.r[ i ][ 2 ]);
					frame.r.push( vector );
				}
			}

			// S
			frame.s = json.s;

			// T
			if( json.t )
				frame.t = new Vector3( json.t[ 0 ], json.t[ 1 ], json.t[ 2 ]);

			// Timestamp
			frame.timestamp = json.timestamp;

			this.dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_FRAME, frame ));
		}
	}
}

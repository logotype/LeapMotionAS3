package com.leapmotion.leap.socket
{
	import com.leapmotion.leap.Finger;
	import com.leapmotion.leap.Frame;
	import com.leapmotion.leap.Hand;
	import com.leapmotion.leap.Vector3;
	import com.leapmotion.leap.events.LeapMotionEvent;
	import com.leapmotion.leap.events.LeapMotionEventProxy;
	import com.leapmotion.leap.util.Base64Encoder;
	import com.leapmotion.leap.util.SHA1;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;

	public class LeapSocket extends EventDispatcher
	{
		static public const STATE_CONNECTING:String = "stateConnecting";
		static public const STATE_OPEN:String = "stateOpen";

		private var socket:Socket;
		private var currentState:String;

		private var handshakeBytesReceived:int;
		private var serverHandshakeResponse:String = "";
		private var serverExtensions:Array;
		private var base64nonce:String;
		private var handshakeTimer:Timer;
		private var handshakeTimeout:int = 10000;
		private var currentFrame:LeapSocketFrame = new LeapSocketFrame();
		public var isConnected:Boolean = false;

		public function LeapSocket()
		{
			// Generate nonce
			var nonce:ByteArray = new ByteArray();
			for ( var i:int = 0; i < 16; i++ )
				nonce.writeByte( Math.round( Math.random() * 0xFF ));

			nonce.position = 0;
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes( nonce );
			base64nonce = encoder.flush();

			handshakeTimer = new Timer( handshakeTimeout, 10000 );
			handshakeTimer.addEventListener( TimerEvent.TIMER, handleHandshakeTimer );

			socket = new Socket( "localhost", 6437 );
			socket.addEventListener( Event.CONNECT, onSocketConnectHandler );
			socket.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorHandler );
			socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler );
			socket.addEventListener( ProgressEvent.SOCKET_DATA, onSocketDataHandler );
		}

		private function handleHandshakeTimer( event:TimerEvent ):void
		{
			isConnected = false;
			LeapMotionEventProxy.getInstance().dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_TIMEOUT ));
		}

		private function onSocketConnectHandler( event:Event ):void
		{
			isConnected = false;
			LeapMotionEventProxy.getInstance().dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_INIT ));
			currentState = LeapSocket.STATE_CONNECTING;
			socket.endian = Endian.BIG_ENDIAN;
			sendHandshake();
		}

		private function onIOErrorHandler( event:IOErrorEvent ):void
		{
			isConnected = false;
			LeapMotionEventProxy.getInstance().dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_EXIT ));
			LeapMotionEventProxy.getInstance().dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_DISCONNECTED ));
		}

		private function onSecurityErrorHandler( event:SecurityErrorEvent ):void
		{
			isConnected = false;
			LeapMotionEventProxy.getInstance().dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_EXIT ));
			LeapMotionEventProxy.getInstance().dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_DISCONNECTED ));
		}

		private function onSocketCloseHandler( event:Event ):void
		{
			isConnected = false;
			LeapMotionEventProxy.getInstance().dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_EXIT ));
			LeapMotionEventProxy.getInstance().dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_DISCONNECTED ));
		}

		private function onSocketDataHandler( event:ProgressEvent = null ):void
		{
			if ( currentState == LeapSocket.STATE_CONNECTING )
			{
				readServerHandshake();
				return;
			}

			isConnected = true;
			
			while ( socket.connected && currentFrame.addData( socket ))
			{
				currentFrame.binaryPayload.position = 0;
				var utf8data:String = currentFrame.binaryPayload.readMultiByte( currentFrame.length, "utf-8" );
				var i:uint = 0;
				var j:uint = 0;
				var json:Object = JSON.parse( utf8data );
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
						hand.frame = frame;
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
						finger.frame = frame;
						finger.id = json.pointables[ i ].id;
						finger.hand = getHandByID( frame, int( json.pointables[ i ].handId ));
						finger.direction = new Vector3( json.pointables[ i ].direction[ 0 ], json.pointables[ i ].direction[ 1 ], json.pointables[ i ].direction[ 2 ]);
						frame.fingers.push( finger );
						// Set primary finger
						if ( i == 0 )
						{
							frame.finger = finger;
							if ( frame.hand )
							{
								frame.hand.finger = finger;
								frame.hand.pointable = finger;
							}
						}
					}
				}

				// R
				if ( json.r )
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
				if ( json.t )
					frame.t = new Vector3( json.t[ 0 ], json.t[ 1 ], json.t[ 2 ]);

				// Timestamp
				frame.timestamp = json.timestamp;

				LeapMotionEventProxy.getInstance().dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_FRAME, frame ));

				currentFrame = new LeapSocketFrame();
			}
		}

		private function getHandByID( frame:Frame, id:int ):Hand
		{
			var returnValue:Hand = null;
			for each ( var hand:Hand in frame.hands )
			{
				if ( hand.id == id )
				{
					returnValue = hand;
					break;
				}
			}
			return returnValue;
		}

		private function parseHTTPHeader( line:String ):Object
		{
			var header:Array = line.split( /\: +/ );
			return header.length === 2 ? { name:header[ 0 ], value:header[ 1 ]} : null;
		}

		private function readHandshakeLine():Boolean
		{
			var char:String;
			while ( socket.bytesAvailable )
			{
				char = socket.readMultiByte( 1, "us-ascii" );
				handshakeBytesReceived++;
				serverHandshakeResponse += char;
				if ( char == "\n" )
				{
					return true;
				}
			}
			return false;
		}

		private function sendHandshake():void
		{
			var text:String = "";
			text += "GET / HTTP/1.1\r\n";
			text += "Host: localhost:6437\r\n";
			text += "Upgrade: websocket\r\n";
			text += "Connection: Upgrade\r\n";
			text += "Sec-WebSocket-Key: " + base64nonce + "\r\n";
			text += "Origin: *\r\n";
			text += "Sec-WebSocket-Version: 13\r\n";
			text += "\r\n";

			socket.writeMultiByte( text, "us-ascii" );

			handshakeTimer.stop();
			handshakeTimer.reset();
			handshakeTimer.start();
		}

		private function readServerHandshake():void
		{
			var upgradeHeader:Boolean = false;
			var connectionHeader:Boolean = false;
			var keyValidated:Boolean = false;
			var headersTerminatorIndex:int = -1;

			// Load in HTTP Header lines until we encounter a double-newline.
			while ( headersTerminatorIndex === -1 && readHandshakeLine())
				headersTerminatorIndex = serverHandshakeResponse.search( /\r?\n\r?\n/ );

			// Slice off the trailing \r\n\r\n from the handshake data
			serverHandshakeResponse = serverHandshakeResponse.slice( 0, headersTerminatorIndex );

			var lines:Array = serverHandshakeResponse.split( /\r?\n/ );

			// Validate status line
			var responseLine:String = lines.shift();
			var responseLineMatch:Array = responseLine.match( /^(HTTP\/\d\.\d) (\d{3}) ?(.*)$/i );
			var httpVersion:String = responseLineMatch[ 1 ];
			var statusCode:int = parseInt( responseLineMatch[ 2 ], 10 );
			var statusDescription:String = responseLineMatch[ 3 ];

			// Interpret HTTP Response Headers
			serverExtensions = [];
			try
			{
				while ( lines.length > 0 )
				{
					responseLine = lines.shift();
					var header:Object = parseHTTPHeader( responseLine );
					var lcName:String = header.name.toLocaleLowerCase();
					var lcValue:String = header.value.toLocaleLowerCase();
					if ( lcName === "upgrade" && lcValue === "websocket" )
					{
						upgradeHeader = true;
					}
					else if ( lcName === "connection" && lcValue === "upgrade" )
					{
						connectionHeader = true;
					}
					else if ( lcName === "sec-websocket-accept" )
					{
						var expectedKey:String = SHA1.hashToBase64( base64nonce + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11" );
						if ( header.value === expectedKey )
						{
							keyValidated = true;
						}
					}
				}
			}
			catch ( e:Error )
			{
				trace( "There was an error while parsing the following HTTP Header line:\n" + responseLine );
				return;
			}

			if ( !upgradeHeader )
			{
				trace( "The server response did not include a valid Upgrade: websocket header." );
				return;
			}
			if ( !connectionHeader )
			{
				trace( "The server response did not include a valid Connection: upgrade header." );
				return;
			}
			if ( !keyValidated )
			{
				trace( "Unable to validate server response for Sec-Websocket-Accept header." );
				return;
			}

			serverHandshakeResponse = null;
			currentState = LeapSocket.STATE_OPEN;
			LeapMotionEventProxy.getInstance().dispatchEvent( new LeapMotionEvent( LeapMotionEvent.LEAPMOTION_CONNECTED ));
			return;
		}
	}
}

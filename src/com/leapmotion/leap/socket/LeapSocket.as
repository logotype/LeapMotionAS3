package com.leapmotion.leap.socket
{
	import com.leapmotion.leap.CircleGesture;
	import com.leapmotion.leap.Controller;
	import com.leapmotion.leap.Finger;
	import com.leapmotion.leap.Frame;
	import com.leapmotion.leap.Gesture;
	import com.leapmotion.leap.Hand;
	import com.leapmotion.leap.InteractionBox;
	import com.leapmotion.leap.KeyTapGesture;
	import com.leapmotion.leap.Matrix;
	import com.leapmotion.leap.Pointable;
	import com.leapmotion.leap.ScreenTapGesture;
	import com.leapmotion.leap.SwipeGesture;
	import com.leapmotion.leap.Tool;
	import com.leapmotion.leap.Vector3;
	import com.leapmotion.leap.interfaces.ILeapConnection;
	import com.leapmotion.leap.namespaces.leapmotion;
	import com.leapmotion.leap.util.Base64Encoder;
	import com.leapmotion.leap.util.SHA1;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ThrottleEvent;
	import flash.events.ThrottleType;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * The LeapSocket class handles the communication via WebSockets.
	 *
	 * @author logotype
	 *
	 */
	final public class LeapSocket extends EventDispatcher implements ILeapConnection
	{
		/**
		 * The initial state before handshake.
		 */
		static private const STATE_CONNECTING:int = 0;

		/**
		 * The connection verification state, after handshake process is complete.
		 */
		static private const STATE_VERSION:int = 1;
				
		/**
		 * The established connection state, after configuration process is complete.
		 */
		static private const STATE_OPEN:int = 3;

		/**
		 * The raw socket connection to Leap Motion.
		 */
		private var socket:Socket;

		/**
		 * The current state of the parser.
		 */
		private var currentState:int;

		/**
		 * Event Dispatcher singleton.
		 */
		private var controller:Controller;

		/**
		 * Specifies which host to connect to, default localhost.
		 */
		private var host:String = "localhost";
		
		/**
		 * Specifies which port to connect to, default 6437.
		 */
		private var port:int = 6437;

		/**
		 * Number of bytes of the handshake response.
		 */
		private var handshakeBytesReceived:int;

		/**
		 * The device handshake response from Leap Motion.
		 */
		private var leapMotionDeviceHandshakeResponse:String = "";

		/**
		 * Base64 encoded cryptographic nonce value.
		 */
		private var base64nonce:String;

		/**
		 * Most recent non-parsed Frame received from Socket.
		 */
		private var leapSocketFrame:LeapSocketFrame = new LeapSocketFrame();

		/**
		 * Most recent parsed Frame received from Socket.
		 */
		private var _frame:Frame;

		/**
		 * Whether the Leap Motion is currently connected.
		 */
		private var _isConnected:Boolean = false;

		/**
		 * Whether the Leap Motion is reporting gestures.
		 */
		private var _isGesturesEnabled:Boolean = false;

		/**
		 * Bytearray which is used for sending data over the websocket.
		 */
		private var output:ByteArray;

		/**
		 * Bytearray which is used to encode data as binary data for sending it over the websocket.
		 */
		private var binaryPayload:ByteArray;
		
		/**
		 * Constructs a LeapSocket object.
		 *
		 * @param host IP or hostname of the computer running the Leap Motion software.
		 *
		 */
		final public function LeapSocket( _controller:Controller, host:String = null, port:int = 6437 )
		{
			if( host )
				this.host = host;
			
			if( port )
				this.port = port;

			controller = _controller;

			// Generate nonce
			var nonce:ByteArray = new ByteArray();
			for( var i:int = 0; i < 16; i++ )
				nonce.writeByte( Math.round( Math.random() * 0xFF ) );

			nonce.position = 0;

			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes( nonce );
			base64nonce = encoder.flush();

			binaryPayload = new ByteArray();
			output = new ByteArray();

			socket = new Socket();
			socket.addEventListener( Event.CONNECT, onSocketConnectHandler );
			socket.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorHandler );
			socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler );
			socket.addEventListener( ProgressEvent.SOCKET_DATA, onSocketDataHandler );
			socket.connect( this.host, this.port );
			
			addEventListener( ThrottleEvent.THROTTLE, onThrottleHandler );
		}
		
		/**
		 * Triggered when SWF instance is outside viewport 
		 * @param event
		 * 
		 */
		private function onThrottleHandler( event:ThrottleEvent ) :void
		{
			switch( event.state )
			{
				case ThrottleType.PAUSE:
				case ThrottleType.THROTTLE:
					sendUTF( "{\"focused\": false}" );
					break;
				case ThrottleType.RESUME:
					sendUTF( "{\"focused\": true}" );
					break;
			}
		}
		
		/**
		 * Triggered once the Socket-connection is established, send handshake.
		 * @param event
		 *
		 */
		final private function onSocketConnectHandler( event:Event ):void
		{
			_isConnected = false;
			controller.leapmotion::listener.onInit( controller );
			currentState = STATE_CONNECTING;
			socket.endian = Endian.BIG_ENDIAN;
			sendHandshake();
		}

		/**
		 * Triggered when network-error occurs.
		 * @param event
		 *
		 */
		final private function onIOErrorHandler( event:IOErrorEvent ):void
		{
			_isConnected = false;
			controller.leapmotion::listener.onDisconnect( controller );
			this.removeEventListener( ThrottleEvent.THROTTLE, onThrottleHandler );
		}

		/**
		 * Triggered if socket policy-file is missing, or other security related error occurs.
		 * @param event
		 *
		 */
		final private function onSecurityErrorHandler( event:SecurityErrorEvent ):void
		{
			_isConnected = false;
			controller.leapmotion::listener.onDisconnect( controller );
			this.removeEventListener( ThrottleEvent.THROTTLE, onThrottleHandler );
		}

		/**
		 * Triggered when the socket-connection is closed.
		 *
		 * @param event
		 *
		 */
		final private function onSocketCloseHandler( event:Event ):void
		{
			_isConnected = false;
			controller.leapmotion::listener.onDisconnect( controller );
			controller.leapmotion::listener.onExit( controller );
			this.removeEventListener( ThrottleEvent.THROTTLE, onThrottleHandler );
		}

		/**
		 * Inline method where data is read until a complete LeapSocketFrame is parsed.
		 *
		 * @param event
		 * @see LeapSocketFrame
		 *
		 */
		[Inline]
		final private function onSocketDataHandler( event:ProgressEvent = null ):void
		{
			if( currentState == STATE_CONNECTING )
				readLeapMotionHandshake();

			_isConnected = true;

			var utf8data:String;
			var i:uint;
			var json:Object;
			var currentFrame:Frame;
			var hand:Hand;
			var pointable:Pointable;
			var gesture:Gesture;
			var isTool:Boolean;
			var length:int;
			var type:int;

			// Loop until data has been completely added to the frame
			while( socket.connected && leapSocketFrame.addData( socket ) )
			{
				leapSocketFrame.binaryPayload.position = 0;
				utf8data = leapSocketFrame.binaryPayload.readUTFBytes( leapSocketFrame.length );
				json = JSON.parse( utf8data );

				// Server-side events. Currently only deviceConnect events are supported.
				if( json.event )
				{
					switch( json.event.type )
					{
						case "deviceConnect":
							if( json.event.state == true )
							{
								_isConnected = true;
								controller.leapmotion::listener.onConnect( controller );
							}
							else
							{
								_isConnected = false;
								controller.leapmotion::listener.onDisconnect( controller );
							}
							break;
						default:
							break;
					}
					
					return;
				}
				
				currentFrame = new Frame();
				currentFrame.controller = controller;

				// Hands
				if( json.hands )
				{
					i = 0;
					length = json.hands.length;
					for( i; i < length; ++i )
					{
						hand = new Hand();
						hand.frame = currentFrame;
						hand.direction = new Vector3( json.hands[ i ].direction[ 0 ], json.hands[ i ].direction[ 1 ], json.hands[ i ].direction[ 2 ] );
						hand.id = json.hands[ i ].id;
						hand.palmNormal = new Vector3( json.hands[ i ].palmNormal[ 0 ], json.hands[ i ].palmNormal[ 1 ], json.hands[ i ].palmNormal[ 2 ] );
						hand.palmPosition = new Vector3( json.hands[ i ].palmPosition[ 0 ], json.hands[ i ].palmPosition[ 1 ], json.hands[ i ].palmPosition[ 2 ] );
						hand.stabilizedPalmPosition = new Vector3( json.hands[ i ].stabilizedPalmPosition[ 0 ], json.hands[ i ].stabilizedPalmPosition[ 1 ], json.hands[ i ].stabilizedPalmPosition[ 2 ] );
						hand.palmVelocity = new Vector3( json.hands[ i ].palmPosition[ 0 ], json.hands[ i ].palmPosition[ 1 ], json.hands[ i ].palmPosition[ 2 ] );
						hand.rotation = new Matrix( new Vector3( json.hands[ i ].r[ 0 ][ 0 ], json.hands[ i ].r[ 0 ][ 1 ], json.hands[ i ].r[ 0 ][ 2 ] ), new Vector3( json.hands[ i ].r[ 1 ][ 0 ], json.hands[ i ].r[ 1 ][ 1 ], json.hands[ i ].r[ 1 ][ 2 ] ), new Vector3( json.hands[ i ].r[ 2 ][ 0 ], json.hands[ i ].r[ 2 ][ 1 ], json.hands[ i ].r[ 2 ][ 2 ] ) );
						hand.scaleFactorNumber = json.hands[ i ].s;
						hand.sphereCenter = new Vector3( json.hands[ i ].sphereCenter[ 0 ], json.hands[ i ].sphereCenter[ 1 ], json.hands[ i ].sphereCenter[ 2 ] );
						hand.sphereRadius = json.hands[ i ].sphereRadius;
						hand.timeVisible = json.hands[ i ].timeVisible;
						hand.translationVector = new Vector3( json.hands[ i ].t[ 0 ], json.hands[ i ].t[ 1 ], json.hands[ i ].t[ 2 ] );
						currentFrame.hands.push( hand );
					}
				}

				// The current framerate (in frames per second) of the Leap Motion Controller. 
				currentFrame.currentFramesPerSecond = json.currentFramesPerSecond;
				
				// A unique ID for this Frame.
				currentFrame.id = json.id;
				
				// The InteractionBox class represents a box-shaped region completely within the field of view.
				if( json.interactionBox )
				{
					currentFrame.interactionBox = new InteractionBox();
					currentFrame.interactionBox.center = new Vector3( json.interactionBox.center[ 0 ], json.interactionBox.center[ 1 ], json.interactionBox.center[ 2 ] );
					currentFrame.interactionBox.width = json.interactionBox.size[ 0 ];
					currentFrame.interactionBox.height = json.interactionBox.size[ 1 ];
					currentFrame.interactionBox.depth = json.interactionBox.size[ 2 ];
				}

				// Pointables
				if( json.pointables )
				{
					i = 0;
					length = json.pointables.length;
					for( i; i < length; ++i )
					{
						isTool = json.pointables[ i ].tool;
						if( isTool )
							pointable = new Tool();
						else
							pointable = new Finger();

						pointable.frame = currentFrame;
						pointable.id = json.pointables[ i ].id;
						pointable.hand = getHandByID( currentFrame, json.pointables[ i ].handId );
						pointable.length = json.pointables[ i ].length;
						pointable.direction = new Vector3( json.pointables[ i ].direction[ 0 ], json.pointables[ i ].direction[ 1 ], json.pointables[ i ].direction[ 2 ] );
						pointable.tipPosition = new Vector3( json.pointables[ i ].tipPosition[ 0 ], json.pointables[ i ].tipPosition[ 1 ], json.pointables[ i ].tipPosition[ 2 ] );
						pointable.stabilizedTipPosition = new Vector3( json.pointables[ i ].stabilizedTipPosition[ 0 ], json.pointables[ i ].stabilizedTipPosition[ 1 ], json.pointables[ i ].stabilizedTipPosition[ 2 ] );
						pointable.timeVisible = json.pointables[ i ].timeVisible;
						pointable.touchDistance = json.pointables[ i ].touchDistance;
						switch( json.pointables[ i ].touchZone )
						{
							case "hovering":
								pointable.touchZone = Pointable.ZONE_HOVERING;
								break;
							case "touching":
								pointable.touchZone = Pointable.ZONE_TOUCHING;
								break;
							default:
								pointable.touchZone = Pointable.ZONE_NONE;
								break;
						}
						pointable.tipVelocity = new Vector3( json.pointables[ i ].tipVelocity[ 0 ], json.pointables[ i ].tipVelocity[ 1 ], json.pointables[ i ].tipVelocity[ 2 ] );
						currentFrame.pointables.push( pointable );

						if( pointable.hand )
							pointable.hand.pointables.push( pointable );

						if( isTool )
						{
							pointable.isTool = true;
							pointable.isFinger = false;
							pointable.width = json.pointables[ i ].width;
							currentFrame.tools.push( pointable );
							if( pointable.hand )
								pointable.hand.tools.push( pointable );
						}
						else
						{
							pointable.isTool = false;
							pointable.isFinger = true;
							currentFrame.fingers.push( pointable );
							if( pointable.hand )
								pointable.hand.fingers.push( pointable );
						}
					}
				}

				// Gestures
				if( json.gestures )
				{
					i = 0;
					length = json.gestures.length;
					for( i; i < length; ++i )
					{
						switch( json.gestures[ i ].type )
						{
							case "circle":
								gesture = new CircleGesture();
								type = Gesture.TYPE_CIRCLE;
								var circle:CircleGesture = CircleGesture( gesture );

								circle.center = new Vector3( json.gestures[ i ].center[ 0 ], json.gestures[ i ].center[ 1 ], json.gestures[ i ].center[ 2 ] );
								circle.normal = new Vector3( json.gestures[ i ].normal[ 0 ], json.gestures[ i ].normal[ 1 ], json.gestures[ i ].normal[ 2 ] );
								circle.progress = json.gestures[ i ].progress;
								circle.radius = json.gestures[ i ].radius;
								break;

							case "swipe":
								gesture = new SwipeGesture();
								type = Gesture.TYPE_SWIPE;

								var swipe:SwipeGesture = SwipeGesture( gesture );

								swipe.startPosition = new Vector3( json.gestures[ i ].startPosition[ 0 ], json.gestures[ i ].startPosition[ 1 ], json.gestures[ i ].startPosition[ 2 ] );
								swipe.position = new Vector3( json.gestures[ i ].position[ 0 ], json.gestures[ i ].position[ 1 ], json.gestures[ i ].position[ 2 ] );
								swipe.direction = new Vector3( json.gestures[ i ].direction[ 0 ], json.gestures[ i ].direction[ 1 ], json.gestures[ i ].direction[ 2 ] );
								swipe.speed = json.gestures[ i ].speed;
								break;

							case "screenTap":
								gesture = new ScreenTapGesture();
								type = Gesture.TYPE_SCREEN_TAP;

								var screenTap:ScreenTapGesture = ScreenTapGesture( gesture );
								screenTap.position = new Vector3( json.gestures[ i ].position[ 0 ], json.gestures[ i ].position[ 1 ], json.gestures[ i ].position[ 2 ] );
								screenTap.direction = new Vector3( json.gestures[ i ].direction[ 0 ], json.gestures[ i ].direction[ 1 ], json.gestures[ i ].direction[ 2 ] );
								screenTap.progress = json.gestures[ i ].progress;
								break;

							case "keyTap":
								gesture = new KeyTapGesture();
								type = Gesture.TYPE_KEY_TAP;

								var keyTap:KeyTapGesture = KeyTapGesture( gesture );
								keyTap.position = new Vector3( json.gestures[ i ].position[ 0 ], json.gestures[ i ].position[ 1 ], json.gestures[ i ].position[ 2 ] );
								keyTap.direction = new Vector3( json.gestures[ i ].direction[ 0 ], json.gestures[ i ].direction[ 1 ], json.gestures[ i ].direction[ 2 ] );
								keyTap.progress = json.gestures[ i ].progress;
								break;

							default:
								throw new Error( "unkown gesture type" );
						}

						var j:int = 0;
						var lengthInner:int = 0;

						if( json.gestures[ i ].handIds )
						{
							j = 0;
							lengthInner = json.gestures[ i ].handIds.length;
							for( j; j < lengthInner; ++j )
							{
								var gestureHand:Hand = getHandByID( currentFrame, json.gestures[ i ].handIds[ j ] );
								gesture.hands.push( gestureHand );
							}
						}

						if( json.gestures[ i ].pointableIds )
						{
							j = 0;
							lengthInner = json.gestures[ i ].pointableIds.length;
							for( j; j < lengthInner; ++j )
							{
								var gesturePointable:Pointable = getPointableByID( currentFrame, json.gestures[ i ].pointableIds[ j ] );
								if( gesturePointable )
								{
									gesture.pointables.push( gesturePointable );
								}
							}
							if( gesture is CircleGesture && gesture.pointables.length > 0 )
							{
								( gesture as CircleGesture ).pointable = gesture.pointables[ 0 ];
							}
						}

						gesture.frame = currentFrame;
						gesture.id = json.gestures[ i ].id;
						gesture.duration = json.gestures[ i ].duration;
						gesture.durationSeconds = gesture.duration / 1000000;

						switch( json.gestures[ i ].state )
						{
							case "start":
								gesture.state = Gesture.STATE_START;
								break;
							case "update":
								gesture.state = Gesture.STATE_UPDATE;
								break;
							case "stop":
								gesture.state = Gesture.STATE_STOP;
								break;
							default:
								gesture.state = Gesture.STATE_INVALID;
						}

						gesture.type = type;

						currentFrame.gesturesVector.push( gesture );
					}
				}

				// Rotation (since last frame), interpolate for smoother motion
				if( json.r )
					currentFrame.rotation = new Matrix( new Vector3( json.r[ 0 ][ 0 ], json.r[ 0 ][ 1 ], json.r[ 0 ][ 2 ] ), new Vector3( json.r[ 1 ][ 0 ], json.r[ 1 ][ 1 ], json.r[ 1 ][ 2 ] ), new Vector3( json.r[ 2 ][ 0 ], json.r[ 2 ][ 1 ], json.r[ 2 ][ 2 ] ) );

				// Scale factor (since last frame), interpolate for smoother motion
				currentFrame.scaleFactorNumber = json.s;

				// Translation (since last frame), interpolate for smoother motion
				if( json.t )
					currentFrame.translationVector = new Vector3( json.t[ 0 ], json.t[ 1 ], json.t[ 2 ] );

				// Timestamp
				currentFrame.timestamp = json.timestamp;

				if( currentState == STATE_OPEN )
				{
					// Add frame to history
					if( controller.frameHistory.length > 59 )
						controller.frameHistory.splice( 59, 1 );
					
					controller.frameHistory.unshift( _frame );
					
					_frame = currentFrame;
					
					controller.leapmotion::listener.onFrame( controller, _frame );
				}
				else if( currentState == STATE_VERSION && json.version )
				{
					if( json.version !== 4 )
						throw new Error( "Please update the Leap App (Invalid protocol version)" );

					sendUTF( "{\"focused\": true}" );

					currentState = STATE_OPEN;
					controller.leapmotion::listener.onConnect( controller );
				}
				
				// Release current frame and create a new one
				leapSocketFrame = new LeapSocketFrame();
			}
		}

		/**
		 * Inline method. Finds a Hand object by ID.
		 *
		 * @param frame The Frame object in which the Hand contains
		 * @param id The ID of the Hand object
		 * @return The Hand object if found, otherwise null
		 *
		 */
		[Inline]
		final private function getHandByID( frame:Frame, id:int ):Hand
		{
			for each( var hand:Hand in frame.hands )
			{
				if( hand.id == id )
				{
					return hand;
					break;
				}
			}
			return Hand.invalid();
		}

		/**
		 * Inline method. Finds a Pointable object by ID.
		 *
		 * @param frame The Frame object in which the Pointable contains
		 * @param id The ID of the Pointable object
		 * @return The Pointable object if found, otherwise null
		 *
		 */
		[Inline]
		final private function getPointableByID( frame:Frame, id:int ):Pointable
		{
			for each( var pointable:Pointable in frame.pointables )
			{
				if( pointable.id == id )
				{
					return pointable;
					break;
				}
			}
			return Pointable.invalid();
		}

		/**
		 * Parses the HTTP header received from the Leap Motion.
		 *
		 * @param line
		 * @return
		 *
		 */
		final private function parseHTTPHeader( line:String ):Object
		{
			var header:Array = line.split( /\: +/ );
			return header.length === 2 ? { name:header[ 0 ], value:header[ 1 ] } : null;
		}

		/**
		 * Reads the handshake received from the Leap Motion.
		 *
		 * @return
		 *
		 */
		final private function readHandshakeLine():Boolean
		{
			var char:String;
			while( socket.bytesAvailable )
			{
				char = socket.readMultiByte( 1, "us-ascii" );
				handshakeBytesReceived++;
				leapMotionDeviceHandshakeResponse += char;
				if( char == "\n" )
					return true;
			}
			return false;
		}

		/**
		 * Sends the HTTP handshake to the Leap Motion.
		 *
		 */
		final private function sendHandshake():void
		{
			var text:String = "";
			text += "GET /v4.json HTTP/1.1\r\n";
			text += "Host: " + host + ":" + this.port + "\r\n";
			text += "Upgrade: websocket\r\n";
			text += "Connection: Upgrade\r\n";
			text += "Sec-WebSocket-Key: " + base64nonce + "\r\n";
			text += "Origin: *\r\n";
			text += "Sec-WebSocket-Version: 13\r\n";
			text += "\r\n";
			
			socket.writeMultiByte( text, "us-ascii" );
		}

		/**
		 * Reads the handshake response from the Leap Motion.
		 *
		 */
		final private function readLeapMotionHandshake():void
		{
			var upgradeHeader:Boolean = false;
			var connectionHeader:Boolean = false;
			var keyValidated:Boolean = false;
			var headersTerminatorIndex:int = -1;

			// Load in HTTP Header lines until we encounter a double-newline.
			while( headersTerminatorIndex === -1 && readHandshakeLine() )
				headersTerminatorIndex = leapMotionDeviceHandshakeResponse.search( /\r?\n\r?\n/ );

			// Slice off the trailing \r\n\r\n from the handshake data
			leapMotionDeviceHandshakeResponse = leapMotionDeviceHandshakeResponse.slice( 0, headersTerminatorIndex );

			var lines:Array = leapMotionDeviceHandshakeResponse.split( /\r?\n/ );
			
			// Validate status line
			var responseLine:String = lines.shift();
			var responseLineMatch:Array = responseLine.match( /^(HTTP\/\d\.\d) (\d{3}) ?(.*)$/i );
			var httpVersion:String = responseLineMatch[ 1 ];
			var statusCode:int = parseInt( responseLineMatch[ 2 ], 10 );
			var statusDescription:String = responseLineMatch[ 3 ];

			try
			{
				while( lines.length > 0 )
				{
					responseLine = lines.shift();
					var header:Object = parseHTTPHeader( responseLine );
					var headerName:String = header.name.toLocaleLowerCase();
					var headerValue:String = header.value.toLocaleLowerCase();
					if( headerName === "upgrade" && headerValue === "websocket" )
					{
						upgradeHeader = true;
					}
					else if( headerName === "connection" && headerValue === "upgrade" )
					{
						connectionHeader = true;
					}
					else if( headerName === "sec-websocket-accept" )
					{
						var expectedKey:String = SHA1.hashToBase64( base64nonce + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11" );
						if( header.value === expectedKey )
							keyValidated = true;
					}
				}
			}
			catch( error:Error )
			{
				trace( "There was an error while parsing the following HTTP Header line:\n" + responseLine );
				return;
			}

			if( !upgradeHeader )
			{
				trace( "The Leap Motion response did not include a valid Upgrade: websocket header." );
				return;
			}
			if( !connectionHeader )
			{
				trace( "The Leap Motion response did not include a valid Connection: upgrade header." );
				return;
			}
			if( !keyValidated )
			{
				trace( "Unable to validate Leap Motion response for Sec-Websocket-Accept header." );
				return;
			}

			leapMotionDeviceHandshakeResponse = null;
			currentState = STATE_VERSION;
		}

		/**
		 * Whether the Leap Motion is currently connected.
		 */
		final public function get isConnected():Boolean
		{
			return _isConnected;
		}

		/**
		 * Most recent parsed Frame received from Socket.
		 */
		final public function get frame():Frame
		{
			return _frame;
		}

		/**
		 * Enables or disables reporting of gestures.
		 * By default, all gesture types are disabled. When disabled, gestures of
		 * the disabled type are never reported and will not appear in the frame
		 * gesture list.
		 *
		 * As a performance optimization, only enable recognition for the types
		 * of movements that you use in your application.
		 *
		 * @param type The type of gesture to enable or disable. Not available for Socket connections.
		 * @param enable True, to enable gestures; False, to disable.
		 *
		 */
		final public function enableGesture( gesture:int, enable:Boolean = true ):void
		{
			if( socket.connected )
			{
				_isGesturesEnabled = enable;
				var enableString:String = "{\"enableGestures\": " + enable + "}";
				sendUTF( enableString );
			}
			else
			{
				trace( "Call enableGesture after you've received the leapmotionConnected event." );
			}
		}

		/**
		 * Encodes & sends a string over the websocket connection
		 *
		 * @param str the string to send
		 */
		final private function sendUTF( str:String ):void
		{
			binaryPayload.writeMultiByte( str, 'utf-8' );
			binaryPayload.endian = Endian.BIG_ENDIAN;
			binaryPayload.position = 0;

			var length:uint = binaryPayload.length;

			var lengthByte:int = 0x80;
			if( length <= 125 )
				lengthByte |= ( length & 0x7F );
			else if( length > 125 && length <= 0xFFFF )
				lengthByte |= 126;
			else if( length > 0xFFFF )
				lengthByte |= 127;

			output.writeByte( 0x81 );
			output.writeByte( lengthByte );

			if( length > 125 && length <= 0xFFFF )
				output.writeShort( length );
			else if( length > 0xFFFF )
			{
				output.writeUnsignedInt( 0x00000000 );
				output.writeUnsignedInt( length );
			}

			output.writeUnsignedInt( 0 );
			output.writeBytes( binaryPayload, 0, binaryPayload.length );

			output.position = 0;
			socket.writeBytes( output, 0, output.bytesAvailable );
			socket.flush();
			output.clear();
			binaryPayload.clear();
		}

		/**
		 * Reports whether the specified gesture type is enabled.
		 *
		 * @param type The Gesture.TYPE parameter. Not available for Socket connections.
		 * @return True, if gestures is enabled; false, otherwise.
		 *
		 */
		final public function isGestureEnabled( type:int ):Boolean
		{
			return _isGesturesEnabled;
		}

		/**
		 * Gets the active policy settings.
		 *
		 * <p>Use this function to determine the current policy state.
		 * Keep in mind that setting a policy flag is asynchronous, so changes are
		 * not effective immediately after calling <code>setPolicyFlag()</code>. In addition, a
		 * policy request can be declined by the user. You should always set the
		 * policy flags required by your application at startup and check that the
		 * policy change request was successful after an appropriate interval.</p>
		 *
		 * <p>If the controller object is not connected to the Leap, then the default
		 * policy state is returned.</p>
		 *
		 * @returns The current policy flags.
		 */
		public function policyFlags():uint
		{
			//NOT IMPLEMENTED
			return 0;
		}

		/**
		 * Requests a change in policy.
		 *
		 * <p>A request to change a policy is subject to user approval and a policy
		 * can be changed by the user at any time (using the Leap Motion settings window).
		 * The desired policy flags must be set every time an application runs.</p>
		 *
		 * <p>Policy changes are completed asynchronously and, because they are subject
		 * to user approval, may not complete successfully. Call
		 * <code>Controller.policyFlags()</code> after a suitable interval to test whether
		 * the change was accepted.</p>
		 *
		 * <p>Currently, the background frames policy is the only policy supported.
		 * The background frames policy determines whether an application
		 * receives frames of tracking data while in the background. By
		 * default, the Leap Motion only sends tracking data to the foreground application.
		 * Only applications that need this ability should request the background
		 * frames policy.</p>
		 *
		 * <p>At this time, you can use the Leap Motion applications Settings window to
		 * globally enable or disable the background frames policy. However,
		 * each application that needs tracking data while in the background
		 * must also set the policy flag using this function.</p>
		 *
		 * <p>This function can be called before the Controller object is connected,
		 * but the request will be sent to the Leap Motion after the Controller connects.</p>
		 *
		 * @param flags A PolicyFlag value indicating the policies to request.
		 */
		public function setPolicyFlags( flags:uint ):void
		{
			switch( flags )
			{
				case Controller.POLICY_BACKGROUND_FRAMES:
					sendUTF( "{\"background\": true}" );
					break;
				case Controller.POLICY_DEFAULT:
				default:
					sendUTF( "{\"background\": false}" );
					break;
			}
		}
	}
}

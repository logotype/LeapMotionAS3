package com.leapmotion.leap.socket
{
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * A raw WebSocket frame, not yet parsed to a LeapMotion Frame.
	 *
	 * @author logotype
	 *
	 */
	[Inline]
	final public class LeapSocketFrame
	{
		/**
		 * State representing new frame.
		 */
		static private const NEW_FRAME:int = 0;

		/**
		 * State representing 16-bit length.
		 */
		static private const WAITING_FOR_16_BIT_LENGTH:int = 1;

		/**
		 * State representing waiting for binary payload.
		 */
		static private const WAITING_FOR_PAYLOAD:int = 2;

		/**
		 * State representing complete frame.
		 */
		static private const COMPLETE:int = 3;

		/**
		 * Data length.
		 */
		public var length:int;

		/**
		 * Raw binary data.
		 */
		public var binaryPayload:ByteArray;

		/**
		 * Current parse state.
		 */
		private var parseState:int = NEW_FRAME;

		/**
		 * Constructs a LeapSocketFrame object.
		 *
		 */
		[Inline]
		final public function LeapSocketFrame()
		{
		}

		/**
		 * Adds data to a buffer until a full Frame is assembled.
		 * @param input Socket data
		 * @return Returns true once the Frame is complete
		 *
		 */
		[Inline]
		final public function addData( input:Socket ):Boolean
		{
			if( input.bytesAvailable >= 2 )
			{
				if( parseState === NEW_FRAME )
				{
					var firstByte:int = input.readByte();
					var secondByte:int = input.readByte();

					length = secondByte & 0x7F;

					if( length === 126 )
						parseState = WAITING_FOR_16_BIT_LENGTH;
					else
						parseState = WAITING_FOR_PAYLOAD;
				}
				if( parseState === WAITING_FOR_16_BIT_LENGTH )
				{
					if( input.bytesAvailable >= 2 )
					{
						length = input.readUnsignedShort();
						parseState = WAITING_FOR_PAYLOAD;
					}
				}
				if( parseState === WAITING_FOR_PAYLOAD )
				{
					if( input.bytesAvailable >= length )
					{
						binaryPayload = new ByteArray();
						binaryPayload.endian = Endian.BIG_ENDIAN;
						input.readBytes( binaryPayload, 0, length );
						binaryPayload.position = 0;
						parseState = COMPLETE;
						return true;
					}
				}
			}
			return false;
		}
	}
}

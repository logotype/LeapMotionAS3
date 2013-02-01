package com.leapmotion.leap.socket
{
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * A WebSocket frame, not yet parsed to a LeapMotion Frame.
	 *  
	 * @author logotype
	 * 
	 */
	[Inline]
	final public class LeapSocketFrame
	{
		static private const NEW_FRAME:int = 0;
		static private const WAITING_FOR_16_BIT_LENGTH:int = 1;
		static private const WAITING_FOR_PAYLOAD:int = 2;
		static private const COMPLETE:int = 3;

		private var _length:int;
		public var binaryPayload:ByteArray;
		private var parseState:int = NEW_FRAME;

		public function get length():int
		{
			return _length;
		}

		/**
		 * Adds data to a buffer until a full Frame is assembled 
		 * @param input Socket data
		 * @return Returns true once the Frame is complete
		 * 
		 */
		[Inline]
		final public function addData( input:Socket ):Boolean
		{
			if ( input.bytesAvailable >= 2 )
			{
				if ( parseState === NEW_FRAME )
				{
					var firstByte:int = input.readByte();
					var secondByte:int = input.readByte();

					_length = secondByte & 0x7F;

					if ( _length === 126 )
						parseState = WAITING_FOR_16_BIT_LENGTH;
					else
						parseState = WAITING_FOR_PAYLOAD;
				}
				if ( parseState === WAITING_FOR_16_BIT_LENGTH )
				{
					if ( input.bytesAvailable >= 2 )
					{
						_length = input.readUnsignedShort();
						parseState = WAITING_FOR_PAYLOAD;
					}
				}
				if ( parseState === WAITING_FOR_PAYLOAD )
				{
					if ( input.bytesAvailable >= _length )
					{
						binaryPayload = new ByteArray();
						binaryPayload.endian = Endian.BIG_ENDIAN;
						input.readBytes( binaryPayload, 0, _length );
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

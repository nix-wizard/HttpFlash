package network.nixwiz.http {
	import flash.utils.ByteArray;

	public class HTTPConnections {

		public var connections:Object = undefined;

		public var requestHandler:HTTPRequestHandler = undefined;

		private var currentPosition:uint = 0;

		public function HTTPConnections(requestHandler:HTTPRequestHandler) {
			this.connections = {};
			this.requestHandler = requestHandler;
		}

		public function connect(connectionID:uint):void {
			connections.connectionID = new HTTPConnection(connectionID, this);
		}

		public function disconnect(connectionID:uint):void {
			connections.connectionID = null;
			delete connections.connectionID;
		}

		public function readData(bytes:ByteArray):void {
			var connectionType:uint = bytes.readUnsignedByte();
			var connectionID:uint = bytes.readUnsignedInt();
			var length:uint = undefined;
			var data:ByteArray = undefined;
			
			if (connectionType == HTTPConnection.CONNECTION_CONNECT) {
				connect(connectionID);
			}
			else if (connectionType == HTTPConnection.CONNECTION_DATA) {
				length = bytes.readUnsignedInt();
				data = new ByteArray();
				data.writeBytes(bytes, 0, length);
				connections.connectionID.writeData(data, length);
			}
			else if (connectionType == HTTPConnection.CONNECTION_DISCONNECT) {
				connections.connectionID.disconnect();
			}
		}
	}
}
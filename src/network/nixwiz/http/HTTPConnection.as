package network.nixwiz.http {
	import flash.utils.ByteArray;

	public class HTTPConnection {
		public static const CONNECTION_CONNECT:uint = 0;
		public static const CONNECTION_DISCONNECT:uint = 1;
		public static const CONNECTION_DATA:uint = 2;

		public var connectionID:uint = undefined;

		public var data:ByteArray = undefined;

		private var connections:HTTPConnections = undefined;

		public function HTTPConnection(connectionID:uint, connections:HTTPConnections) {
			this.connectionID = connectionID;
			this.data = new ByteArray();
			this.connections = connections;
		}

		public function writeData(bytes:ByteArray, length:uint):void {
			data.writeBytes(bytes, data.position, length);
		}

		public function disconnect():void {
			this.data = null;
			this.connectionID = 0;
			connections.disconnect(connectionID);
		}
	}
}
package network.nixwiz.engine.bridge {
	import flash.utils.ByteArray;
	import network.nixwiz.engine.io.IReaderInput;
	import network.nixwiz.engine.Promise;
	import flash.net.Socket;
	import network.nixwiz.engine.Logger;
	import flash.errors.EOFError;

	public class Connection implements IReaderInput {
		public var bridge:Bridge;

		public var id:uint;

		public var socket:Socket;

		// called by Bridge
		internal var onData:Function = function(_:*):void { };
		internal var onClose:Function = function():void { };

		function Connection(bridge:Bridge, id:uint) {
			this.bridge = bridge;
			this.id = id;
			socket = bridge.socket;
		}

		public function readChunk():Promise {
			return new Promise(function(resolve:Function, reject:Function):void {
				onData = resolve;
				onClose = function():void { reject(new EOFError()); };
			});
		}

		public function write(data:ByteArray):void {
			socket.writeByte(PacketKind.DATA);
			socket.writeUnsignedInt(id);
			socket.writeUnsignedInt(data.length);
			socket.writeBytes(data);
			socket.flush();
		}

		public function close():void {
			socket.writeByte(PacketKind.DISCONNECT);
			socket.writeUnsignedInt(id);
			socket.flush();
			onClose();
		}

		public function toString():String {
			return 'Connection { id: ' + id + ' }';
		}
	}
}
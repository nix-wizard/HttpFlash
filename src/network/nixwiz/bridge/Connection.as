package network.nixwiz.bridge {
	import flash.utils.ByteArray;
	import network.nixwiz.io.IReaderInput;
	import network.nixwiz.Promise;
	import flash.net.Socket;
	import network.nixwiz.Logger;

	public class Connection implements IReaderInput {
		public var bridge:Bridge;
		public var id:uint;

		public var onData:Function = function(_:*):void { };
		public var onClose:Function = function():void { };

		function Connection(bridge:Bridge, id:uint) {
			this.bridge = bridge;
			this.id = id;
		}

		public function readChunk():Promise {
			return new Promise(function(resolve:Function, reject:Function):void {
				onData = resolve;
				onClose = reject;
			});
		}

		public function write(data:ByteArray):void {
			var socket:Socket = this.bridge.socket;
			socket.writeByte(PacketKind.DATA);
			socket.writeUnsignedInt(data.length);
			socket.writeBytes(data);
		}

		public function close():void {
			this.onClose();
		}

		public function toString():String {
			return 'HTTPConnection { id: ' + id + ' }';
		}
	}
}
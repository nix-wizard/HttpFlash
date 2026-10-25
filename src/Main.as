package {
	import flash.display.Sprite;
	import network.nixwiz.Logger;
	import flash.utils.ByteArray;
	import flash.net.Socket;
	import network.nixwiz.Promise;
	import network.nixwiz.bridge.Bridge;
	import network.nixwiz.bridge.Connection;
	import network.nixwiz.io.Reader;
	import network.nixwiz.http.RequestHead;

	public class Main extends Sprite {
		function Main() {
			Logger.init(this);
			Logger.log('hello');

			var socket:Socket = new Socket('localhost', 6768);
			var bridge:Bridge = new Bridge(socket);
			bridge.onConnection = function(connection:Connection):void {
				var reader:Reader = new Reader(connection);
				var buffer:ByteArray = new ByteArray();

				function loop():Promise {
					Logger.log('loop');
					return reader.readUint8()
						.then(function(byte:uint):* {
							Logger.log('yum');
							buffer.writeByte(byte);
							if (
								buffer.length >= 4 &&
								buffer[buffer.length - 4] === 13 &&
								buffer[buffer.length - 3] === 10 &&
								buffer[buffer.length - 2] === 13 &&
								buffer[buffer.length - 1] === 10
							) {
								Logger.log('end of head');
								return;
							}
							return loop();
						});
				}

				loop().then(function():void {
					var head:RequestHead = RequestHead.fromString(buffer.toString());
					Logger.log(head.url);
				});
			};
			bridge.run();
		}
	}
}
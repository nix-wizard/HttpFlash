package network.nixwiz.http {
    import network.nixwiz.bridge.Bridge;
    import network.nixwiz.bridge.Connection;
    import network.nixwiz.io.Reader;
    import flash.utils.ByteArray;
    import network.nixwiz.Promise;
    import network.nixwiz.Logger;
    import network.nixwiz.Util;
    import flash.system.Capabilities;

    // not sure if this should even be used as an instance... a static run() might do just fine
    public class Server {
        public var bridge:Bridge;

        public var requestHandler:Function;

        /**
         * @param requestHandler A request handler with the signature
		 * <code>function(request:Request):Promise</code> (where the result
		 * resolves to a <code>Response</code>).
         */
        function Server(bridge:Bridge, requestHandler:Function) {
            this.bridge = bridge;
            this.requestHandler = requestHandler;
        }

        public function run():Promise {
            bridge.onConnection = function(connection:Connection):void {
				var reader:Reader = new Reader(connection);

				var headBuffer:ByteArray = new ByteArray();

				function loop():Promise {
					return reader.readUint8()
						.then(function(byte:uint):* {
							headBuffer.writeByte(byte);

                            var length:uint = headBuffer.length;
							if (
								length >= 4 &&
								// \r\n\r\n
								headBuffer[length - 4] === 13 &&
								headBuffer[length - 3] === 10 &&
								headBuffer[length - 2] === 13 &&
								headBuffer[length - 1] === 10
							) { return; }
							return loop();
						});
				}

				loop()
					.then(function():Promise {
						var head:RequestHead = RequestHead.deserialize(headBuffer.toString());
						return Request.read(reader, head);
					})
					.then(function(request:Request):Promise {
						return requestHandler(request);
					})
					.then(function(response:Response):void {
                        connection.write(response.serialize());
						connection.close();
					});
			};
			return bridge.run();
        }
    }
}
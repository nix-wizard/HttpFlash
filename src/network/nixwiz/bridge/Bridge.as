package network.nixwiz.bridge {
    import flash.net.Socket;
    import flash.utils.Dictionary;
    import network.nixwiz.io.Reader;
    import network.nixwiz.io.ReaderInputSocket;
    import network.nixwiz.Promise;
    import flash.utils.ByteArray;
    import network.nixwiz.Logger;
    import network.nixwiz.Util;
    import flash.errors.EOFError;

    public class Bridge {
        public var socket:Socket;

        private var reader:Reader;

        public var connections:Dictionary = new Dictionary();

        public var onConnection:Function = function(_:*):void { };

        function Bridge(socket:Socket) {
            this.socket = socket;
            this.reader = new Reader(new ReaderInputSocket(socket));
        }

        /** @return A <code>void</code> promise. */
        public function run():Promise {
            var this_:Bridge = this;
            var kind:uint;

            return reader.readUint8()
                .fail(function(error:*):void {
                    if (error is EOFError) { return; }
                    throw error;
                })
                .then(function(kind_:uint):Promise {
                    kind = kind_;
                    return reader.readUint32();
                })
                .then(function(id:uint):Promise {
                    switch (kind) {
                        case PacketKind.CONNECT: {
                            var connection1:Connection = new Connection(this_, id);
                            Logger.log('connect:', connection1);
                            onConnection(connection1);
                            connections[id] = connection1;

                            return run();
                        } break;

                        case PacketKind.DISCONNECT: {
                            var connection2:Connection = connections[id];
                            Logger.log('disconnect:', connection2);
                            connection2.close();
                            delete connections[id];

                            return run();
                        } break;

                        case PacketKind.DATA: {
                            return reader.readUint32()
                                .then(function(length:uint):Promise {
                                    return reader.read(length);
                                })
                                .then(function(data:ByteArray):Promise {
                                    var connection3:Connection = connections[id];
                                    Logger.log('data:', connection3, data.length);
                                    connection3.onData(data);

                                    return run();
                                });
                        } break;

                        default: {
                            throw new Error('invalid packet kind ' + kind);
                        }
                    }
                });
        }
    }
}
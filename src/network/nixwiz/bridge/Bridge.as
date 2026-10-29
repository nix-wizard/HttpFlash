package network.nixwiz.bridge {
    import flash.net.Socket;
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

        public var connections:Object = new Object();

        public var onConnection:Function = function(_:*):void { };

        function Bridge(socket:Socket) {
            this.socket = socket;
            this.reader = new Reader(new ReaderInputSocket(socket));
        }

        /** @return A <code>void</code> promise. */
        public function run():Promise {
            var this_:Bridge = this;
            var connection:Connection;
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
                            connection = new Connection(this_, id);
                            onConnection(connection);
                            connections[id] = connection;

                            return run();
                        } break;

                        case PacketKind.DISCONNECT: {
                            connection = connections[id];
                            connection.close();
                            delete connections[id];

                            return run();
                        } break;

                        case PacketKind.DATA: {
                            return reader.readUint32()
                                .then(function(length:uint):Promise {
                                    return reader.read(length);
                                })
                                .then(function(data:ByteArray):Promise {
                                    connection = connections[id];
                                    connection.onData(data);

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
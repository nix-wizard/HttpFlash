internal class PacketKind {
    public static var CONNECT:uint = 0;
    public static var DISCONNECT:uint = 1;
    public static var DATA:uint = 2;
}

package network.nixwiz.http {
    import flash.net.Socket;
    import flash.utils.Dictionary;
    import network.nixwiz.http.io.Reader;
    import network.nixwiz.http.io.ReaderInputSocket;

    public class HTTPBridge {
        public var socket:Socket;
        private var reader:Reader;
        public var connections:Dictionary = new Dictionary();

        function HTTPBridge(socket:Socket) {
            this.socket = socket;
            this.reader = new Reader(new ReaderInputSocket(socket));
        }

        private function loop():void {
            var kind:uint;

            reader.readUint8()
                .then(function(kind_:uint):Promise {
                    kind = kind_;
                    return reader.readUint32();
                })
                .then(function(connectionId:uint):void {
                    switch (kind) {
                        case PacketKind.CONNECT: {
                            connections[connectionId] = new HTTPConnection(connectionId);
                            loop();
                        } break;

                        case PacketKind.DISCONNECT: {
                            delete connections[connectionId];
                        }
                    }
                });
        }
    }
}
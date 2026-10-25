package network.nixwiz.io {
    import flash.net.Socket;
    import flash.events.ProgressEvent;
    import flash.utils.ByteArray;
    import network.nixwiz.io.IReaderInput;
    import network.nixwiz.Promise;
    import flash.errors.EOFError;
    import network.nixwiz.Logger;
    import network.nixwiz.Util;

    public class ReaderInputSocket implements IReaderInput {
        public var socket:Socket;

        function ReaderInputSocket(socket:Socket) {
            this.socket = socket;
        }

        public function readChunk():Promise {
            return new Promise(function(resolve:Function, reject:Function):void {
                function removeListeners():void {
                    socket.removeEventListener('socketData', onSocketData);
                    socket.removeEventListener('close', onClose);
                }

                function onSocketData(event:ProgressEvent):void {
                    var chunk:ByteArray = new ByteArray();
                    chunk.length = event.bytesLoaded;
                    socket.readBytes(chunk);

                    removeListeners();
                    resolve(chunk);
                }

                function onClose(_:*):void {
                    removeListeners();
                    reject(new EOFError());
                }

                socket.addEventListener('socketData', onSocketData);
                socket.addEventListener('close', onClose);
            });
        }
    }
}
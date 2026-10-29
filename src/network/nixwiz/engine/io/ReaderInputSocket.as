package network.nixwiz.engine.io {
    import flash.net.Socket;
    import flash.events.ProgressEvent;
    import flash.utils.ByteArray;
    import network.nixwiz.engine.io.IReaderInput;
    import network.nixwiz.engine.Promise;
    import flash.errors.EOFError;
    import network.nixwiz.engine.Logger;

    public class ReaderInputSocket implements IReaderInput {
        public var socket:Socket;

        private var onData:Function;
        private var onClose:Function;

        function ReaderInputSocket(socket:Socket) {
            this.socket = socket;

            socket.addEventListener('socketData', function(event:ProgressEvent):void {
                var chunk:ByteArray = new ByteArray();
                chunk.length = socket.bytesAvailable;
                socket.readBytes(chunk);
                onData(chunk);
            });

            socket.addEventListener('close', function(_:*):void {
                onClose();
            });
        }

        public function readChunk():Promise {
            return new Promise(function(resolve:Function, reject:Function):void {
                onData = resolve;
				onClose = function():void { reject(new EOFError()); };
            });
        }
    }
}
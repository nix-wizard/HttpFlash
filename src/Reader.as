package {
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.events.ProgressEvent;

    public class Reader {
        public var socket:Socket;
        private var chunks:Array = [];
        private var firstChunkOffset:uint = 0;
        private var length:uint = 0;

        private var received:uint = 0;
        private var required:uint = 0;

        function Reader(socket:Socket) {
            this.socket = socket;
        }

        /**
         * Read data from the socket into <code>chunks</code> until <code>size</code> new bytes are available.
         * @return A <code>void</code> promise.
         */
        private function readChunks(size:uint):Promise {
            required += size;
            return new Promise(function(resolve:Function, reject:Function):void {
                if (received >= required) { resolve(); return; }

                function removeListeners():void {
                    socket.removeEventListener('socketData', onSocketData);
                    socket.removeEventListener('close', onClose);
                }

                function onSocketData(event:ProgressEvent):void {
                    var chunk:ByteArray = new ByteArray();
                    chunk.length = event.bytesLoaded;
                    socket.readBytes(chunk);
                    chunks.push(chunk);

                    length += chunk.length;
                    received += chunk.length;
                    if (received >= required) {
                        removeListeners();
                        resolve();
                    }
                }

                function onClose(_:*):void {
                    removeListeners();
                    reject(new Error()); // XXX
                }

                socket.addEventListener('socketData', onSocketData);
                socket.addEventListener('close', onClose);
            });
        }

        /**
         * Read <code>size</code> bytes from the socket.
         * @return A <code>ByteArray</code> promise.
         */
        public function read(size:uint):Promise {
            return readChunks(size).then(function():ByteArray {
                var result:ByteArray = new ByteArray();
                result.length = size;

                var resultOffset:uint = 0;
                while (resultOffset < size) {
                    var chunk:ByteArray = chunks[0];
                    var count:uint = Math.min(chunk.length - firstChunkOffset, size - resultOffset);

                    result.position = resultOffset;
                    result.writeBytes(chunk, firstChunkOffset, count);
                    resultOffset += count;
                    length -= count;

                    if (count === chunk.length - firstChunkOffset) {
                        chunks.shift();
                        firstChunkOffset = 0;
                    }
                    else {
                        firstChunkOffset += count;
                    }
                }

                Logger.log('result = ' + Util.dumpBytes(result));
                return result;
            });
        }

        /**
         * @return A <code>uint</code> promise.
         */
        public function readUint8():Promise {
            return read(1)
                .then(function(data:ByteArray):uint {
                    return data[0];
                });
        }
        
        /**
         * @return A <code>uint</code> promise.
         */
        public function readUint32():Promise {
            return read(4)
                .then(function(data:ByteArray):uint {
                    return data.readUnsignedInt();
                });
        }
    }
}
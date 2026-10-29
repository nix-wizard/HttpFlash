package network.nixwiz.http {
    import network.nixwiz.io.Reader;
    import flash.utils.ByteArray;
    import network.nixwiz.Promise;
    import network.nixwiz.Logger;

    public class Request extends RequestHead {
        public var body:ByteArray;

        function Request(head:RequestHead, body:ByteArray) {
            super(head.method, head.resource, head.protocol, head.headers);
            this.body = body;
        }

        /** Read the body of the request that <code>head</code> belongs to from <code>reader</code>. */
        public static function read(reader:Reader, head:RequestHead):Promise {
            if (head.headers.hasOwnProperty('content-length')) {
                var length:Number = parseInt(head.headers['content-length']);
                if (isNaN(length)) {
                    throw new ArgumentError('Invalid request: Invalid Content-Length header');
                }

                return reader.read(length)
                    .then(function(body:ByteArray):Request {
                        return new Request(head, body);
                    });
            }
            else {
                return Promise.resolve(new Request(head, null));
            }
        }

        /** Decode the body as UTF-8. */
        public function text():String {
            body.position = 0;
            var ret:String = body.readUTFBytes(body.length);
            body.position = 0;
            return ret;
        }
    }
}
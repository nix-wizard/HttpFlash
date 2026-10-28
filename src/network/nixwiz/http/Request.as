package network.nixwiz.http {
    import flash.utils.Dictionary;
    import network.nixwiz.io.Reader;
    import flash.utils.ByteArray;
    import network.nixwiz.Promise;
    import network.nixwiz.Logger;

    public class Request extends RequestHead {
        public var headerDict:Dictionary;
        public var body:ByteArray;

        function Request(head:RequestHead, headerDict:Dictionary, body:ByteArray) {
            super(head.method, head.url, head.protocol, head.headers);
            this.headerDict = headerDict;
            this.body = body;
        }

        public static function read(reader:Reader, head:RequestHead):Promise {
            var headerDict:Dictionary = new Dictionary();
            for each (var header:Header in head.headers) {
                var normalizedName:String = header.name.toLowerCase();
                if (headerDict.hasOwnProperty(normalizedName)) {
                    throw new ArgumentError('Invalid request: Duplicate headers');
                }
                headerDict[normalizedName] = header.value;
            }

            if (headerDict.hasOwnProperty('content-length')) {
                var length:Number = parseInt(headerDict['content-length']);
                if (isNaN(length)) {
                    throw new ArgumentError('Invalid request: Invalid Content-Length header');
                }

                return reader.read(length)
                    .then(function(body:ByteArray):Request {
                        return new Request(head, headerDict, body);
                    });
            }
            else {
                return Promise.resolve(new Request(head, headerDict, new ByteArray()));
            }
        }

        public function text():String {
            body.position = 0;
            var ret:String = body.readUTFBytes(body.length);
            body.position = 0;
            return ret;
        }
    }
}
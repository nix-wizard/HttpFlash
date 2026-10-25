package network.nixwiz.http {
	import flash.utils.ByteArray;
	import network.nixwiz.http.HTTPHeader;

	public class HTTPRequest {
		public var method:String = undefined;

		public var resource:String = undefined;

		public var protocol:String = undefined

		public var headers:HTTPHeaders = undefined;

		public var data:ByteArray = undefined;

		public function HTTPRequest(method:String, resource:String, protocol:String, headers:HTTPHeaders, data:ByteArray = null) {
			this.method = method;
			this.resource = resource;
			this.protocol = protocol;
			this.headers = headers;
			this.data = data;
		}

		public static function requestFromBytes(request:ByteArray):HTTPRequest {
			var method:String = undefined;
			var resource:String = undefined;
			var protocol:String = undefined;
			var headers:HTTPHeaders = undefined;
			var data:ByteArray = null;

			var headerList:Vector.<HTTPHeader> = new Vector.<HTTPHeader>;

			request.position = 0;
			var requestString:String = request.readUTFBytes(request.bytesAvailable);

			var headerEnd:int = requestString.indexOf("\r\n\r\n");
			if (headerEnd == -1) {
				throw new ArgumentError("Invalid HTTP request: Iissing header terminator.");
			}

			var headerString:String = requestString.substring(0, headerEnd);
			var dataString:String = requestString.substring(headerEnd + 4); // length of \r\n\r\n is 4
			if (dataString != "") {
				data.writeUTFBytes(dataString);
			}

			var headerLines:Array = headerString.split(/\r?\n/);

			for (var index:uint in headerLines) {
				if (index == 0) { // Request
					var requestParams:Array = headerLines[index].split(' ', 3);
					method = requestParams[0];
					resource = requestParams[1];
					protocol = requestParams[2];
					if (protocol != "HTTP/1.1" && protocol != "HTTP/1.0") {
						throw new ArgumentError("Invalid HTTP request: Invalid protocol");
					}
				}
				else { // Headers
					headerList.push(HTTPHeader.headerFromString(headerLines[index]));
				}
			}
			headers = new HTTPHeaders(headerList);

			return new HTTPRequest(method, resource, protocol, headers, data);
		}
	}
}
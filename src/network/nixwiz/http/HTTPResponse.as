package network.nixwiz.http {
	import flash.utils.ByteArray;

	public class HTTPResponse {
		public const protocol:String = "HTTP/1.1";
		
		public var status:HTTPStatus = undefined;

		public var headers:HTTPHeaders = undefined;

		public var data:ByteArray = undefined;

		public function HTTPResponse(status:HTTPStatus, headers:HTTPHeaders = null, data:ByteArray = null) {
			this.status = status;
			this.headers = headers;
			this.data = data;
		}

		public function toByteArray():ByteArray {
			var bytes:ByteArray = new ByteArray();
			var header:String = protocol + ' ' + status.toString() + "\r\n"
			if (headers != null) {
				header = header + headers.toString() + "\r\n\r\n";
			}
			else {
				header = header + "\r\n";
			}

			bytes.writeUTFBytes(header)
			if (data != null) {
				data.position = 0;
				bytes.writeBytes(data);
			}

			bytes.position = 0;
			return bytes;
		}
	}
}
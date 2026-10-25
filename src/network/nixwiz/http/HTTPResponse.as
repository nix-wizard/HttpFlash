package network.nixwiz.http {
	import flash.utils.ByteArray;
	import network.nixwiz.http.HTTPStatus;
	import network.nixwiz.http.HTTPHeaders;

	public class HTTPResponse {
		public const protocol:String = "HTTP/1.1";
		
		public var status:HTTPStatus = undefined;

		public var headers:HTTPHeaders = undefined;

		public var data:ByteArray = undefined;

		public function HTTPResponse(status:HTTPStatus, headers:HTTPHeaders, data:ByteArray = null) {
			this.status = status;
			this.headers = headers;
			this.data = data;
		}

		public function toByteArray():ByteArray {
			var bytes:ByteArray = undefined;
			var beforeData:String =
				protocol + ' ' + status.toString() + "\r\n"
				+ headers.toString() + "\r\n"

			bytes.writeUTFBytes(beforeData)
			if (data != null) {
				bytes.writeBytes(data);
			}

			return bytes;
		}
	}
}
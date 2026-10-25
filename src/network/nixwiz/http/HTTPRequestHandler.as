package network.nixwiz.http {
	import flash.utils.ByteArray;

	public class HTTPRequestHandler {
		public function HTTPRequestHandler() {
		}

		public function sendRequest(request:HTTPRequest):HTTPResponse {
			var status:HTTPStatus = new HTTPStatus(HTTPStatus.HTTP_OK);
			var headers:HTTPHeaders = new HTTPHeaders(new <HTTPHeader>[
				new HTTPHeader("test", "test")
			]);
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes("test");

			return new HTTPResponse(status, headers, data);
		}
	}
}
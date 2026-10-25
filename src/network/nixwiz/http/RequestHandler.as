package network.nixwiz.http {
	import flash.utils.ByteArray;

	public class RequestHandler {
		public function RequestHandler() {
		}

		public function sendRequest(request:RequestHead):Response {
			var status:Status = new Status(Status.HTTP_OK);
			var headers:Headers = new Headers(new <Header>[
				new Header("test", "test")
			]);
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes("test");

			return new Response(status, headers, data);
		}
	}
}
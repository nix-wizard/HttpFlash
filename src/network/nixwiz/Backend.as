package network.nixwiz {
	import network.nixwiz.http.Response;
	import network.nixwiz.http.Status;
	import network.nixwiz.http.Request;
	import flash.utils.ByteArray;

	public class Backend {
		public static function handleRequest(request:Request):Response {
			var data:ByteArray = new ByteArray();
			var response:Response = undefined;

			switch(request.method) {
				case "GET":
					if (Files.filePaths.hasOwnProperty(request.resource)) {
						response = new Response(Status.OK)
							.addHeader("Content-Type", Files.extToMime(Util.getExt(request.resource)))
							.setData(Files.filePaths[request.resource]);
						break;
					}
					if (paths.hasOwnProperty(request.resource)) {
						response = paths[request.resource](request);
						break;
					}
					response = new Response(Status.NOT_FOUND);
					break;
				default:
					response = new Response(Status.NOT_FOUND);
			}

			return response;
		}

		public static const paths:Object = {
			"/test": test
		}

		public static function test(request:Request):Response {
			return new Response(Status.OK)
							.setText("MEOWMOEMWOEMWOEMWOMOEWMO");
		}
	}
}
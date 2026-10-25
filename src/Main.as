package {
	import flash.display.Sprite;
	import network.nixwiz.http.HTTPRequestHandler;
	import network.nixwiz.http.HTTPRequest;
	import flash.utils.ByteArray;

	public class Main extends Sprite {
		function Main() {
			Logger.init(this);
			var requestHandler:HTTPRequestHandler = new HTTPRequestHandler();
			const requestExample:HTTPRequest = new HTTPRequest(
				"GET",
				"/",
				"HTTP/1.1"
			);

			var response:ByteArray = requestHandler.sendRequest(requestExample).toByteArray();
			Logger.log(response.readUTFBytes(response.bytesAvailable));
		}
	}
}
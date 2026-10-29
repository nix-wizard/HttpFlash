package network.nixwiz {
	import flash.display.Sprite;
	import network.nixwiz.Logger;
	import flash.net.Socket;
	import network.nixwiz.Promise;
	import network.nixwiz.bridge.Bridge;
	import network.nixwiz.http.Request;
	import network.nixwiz.http.Server;
	import network.nixwiz.http.Response;

	public class Main extends Sprite {
		function Main() {
			Logger.init(this);
			Logger.log('hello');

			var socket:Socket = new Socket('localhost', 6768);
			var bridge:Bridge = new Bridge(socket);
			var server:Server = new Server(bridge, function(request:Request):Promise {
				var response:Response = Backend.handleRequest(request);
				return Promise.resolve(response);
			});
			server.run();
		}
	}
}
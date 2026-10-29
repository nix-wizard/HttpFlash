package network.nixwiz.app {
	import flash.display.Sprite;
	import network.nixwiz.engine.Logger;
	import flash.net.Socket;
	import network.nixwiz.engine.Promise;
	import network.nixwiz.engine.bridge.Bridge;
	import network.nixwiz.engine.http.Request;
	import network.nixwiz.engine.http.Server;
	import network.nixwiz.engine.http.Response;
	import network.nixwiz.engine.Logger;

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
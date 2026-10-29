package network.nixwiz {
	import flash.display.Sprite;
	import network.nixwiz.Logger;
	import flash.net.Socket;
	import network.nixwiz.Promise;
	import network.nixwiz.bridge.Bridge;
	import network.nixwiz.http.Request;
	import network.nixwiz.http.Server;
	import network.nixwiz.http.Response;
	import network.nixwiz.Util;

	public class Main extends Sprite {
		function Main() {
			Logger.init(this);
			Logger.log('hello');

			var socket:Socket = new Socket('localhost', 6768);
			var bridge:Bridge = new Bridge(socket);
			var server:Server = new Server(bridge, function(request:Request):Promise {
				return Promise.resolve(
					new Response(200)
						.addHeader('content-type', 'text/html')
						.setText(
							<body>
								<h1>meow!</h1>
								<p>you are at {request.url}</p>
							</body>.toXMLString()
						)
				);
			});
			server.run();
		}
	}
}
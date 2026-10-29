package network.nixwiz.app {
	import network.nixwiz.engine.http.Response;
	import network.nixwiz.engine.http.Status;
	import network.nixwiz.engine.http.Request;
	import flash.utils.ByteArray;
	import network.nixwiz.engine.Logger;
	import network.nixwiz.engine.Util;
	import network.nixwiz.app.routes.TestRoute;

	public class Backend {
		public static function handleRequest(request:Request):Response {
			var route:IRoute = routes[request.method + ' ' + request.resource];
			if (route != null) {
				return route.respond(request);
			}

			// Serve a static file

			if (request.method !== 'GET') {
				return new Response(Status.METHOD_NOT_ALLOWED);
			}

			var file:File = Files.files[request.resource];
			if (file != null) {
				// https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/ETag
				var etag:String = '"' + file + '"';

				if (request.headers.hasOwnProperty('if-none-match')){
					var etags:Array = request.headers['if-none-match'].split(/,\s*/);
					if (etags.indexOf(etag) !== -1) {
						return new Response(Status.NOT_MODIFIED);
					}
				}

				return new Response(Status.OK)
					.addHeader("Content-Type", File.extToMime(Util.getExt(request.resource)) + ";charset=utf-8")
					.addHeader("ETag", etag)
					.setBody(file.getContent());
			}

			return new Response(Status.NOT_FOUND);
		}

		public static const routes:Object = {
			"GET /test": new TestRoute()
		}

		public static function test(request:Request):Response {
			return new Response(Status.OK)
				.setText("MEOWMOEMWOEMWOEMWOMOEWMO");
		}
	}
}
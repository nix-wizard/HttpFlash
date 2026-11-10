package network.nixwiz.engine.http {
	import mx.charts.AreaChart;

	internal class RequestHead {
		public var method:String;

		public var resource:String;

		public var queries:Object;

		public var protocol:String;

		public var headers:Object;

		function RequestHead(method:String, resource:String, queries:Object, protocol:String, headers:Object) {
			this.method = method;
			this.resource = resource;
			this.queries = queries;
			this.protocol = protocol;
			this.headers = headers;
		}

		public static function deserialize(str:String):RequestHead {
			var lines:Array = str.split(/\r?\n/);
			if (lines.length === 0) {
				throw new ArgumentError('Invalid request: No lines');
			}

			var firstLineParts:Array = lines[0].split(' ', 3);
			if (firstLineParts.length < 3) {
				throw new ArgumentError('Invalid request: First line must have 3 parts');
			}

			var method:String = firstLineParts[0];
			var resourceParts:Array = firstLineParts[1].split("?", 2);
			var resource:String = resourceParts[0];
			var queries:Object = new Object();
			if (resourceParts.length == 2) {
				for each (var query:String in resourceParts[1].split("&")) {
					var queryParts:Array = query.split("=", 2);
					if (queryParts.length !== 2) {
						throw new ArgumentError('Invalid request: Invalid amount of = in a query string')
					}
					queries[queryParts[0]] = queryParts[1];
				}
			}
			var protocol:String = firstLineParts[2];
			if (protocol != "HTTP/1.1" && protocol != "HTTP/1.0") {
				throw new ArgumentError("Invalid request: Invalid protocol");
			}

			var headers:Object = new Object();
			for each (var line:String in lines.slice(1)) {
				if (line === '') { continue; }

				var parts:Array = line.split(": ", 2);
				if (parts.length !== 2) {
					throw new ArgumentError('Invalid request: Invalid header');
				}

				headers[parts[0].toLowerCase()] = parts[1];
			}

			return new RequestHead(method, resource, queries, protocol, headers);
		}
	}
}
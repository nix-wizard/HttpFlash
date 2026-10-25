package network.nixwiz.http {
	public class RequestHead {
		public var method:String;

		public var url:String;

		public var protocol:String;

		public var headers:Vector.<Header>;

		public function RequestHead(method:String, url:String, protocol:String, headers:Vector.<Header> = null) {
			this.method = method;
			this.url = url;
			this.protocol = protocol;
			this.headers = headers;
		}

		public static function fromString(str:String):RequestHead {
			var lines:Array = str.split(/\r?\n/);

			var firstLineParts:Array = lines[0].split(' ', 3);
			var method:String = firstLineParts[0];
			var url:String = firstLineParts[1];
			var protocol:String = firstLineParts[2];
			if (protocol != "HTTP/1.1" && protocol != "HTTP/1.0") {
				throw new ArgumentError("Invalid HTTP request: Invalid protocol");
			}

			var headers:Vector.<Header> = new <Header>[];
			for each (var line:String in lines) {
				if (line === '') { continue; }
				headers.push(Header.fromString(line));
			}

			return new RequestHead(method, url, protocol, headers);
		}
	}
}
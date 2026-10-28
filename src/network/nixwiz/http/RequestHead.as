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

		public static function deserialize(str:String):RequestHead {
			var lines:Array = str.split(/\r?\n/);
			if (lines.length === 0) {
				throw new ArgumentError('Invalid request: no lines');
			}

			var firstLineParts:Array = lines[0].split(' ', 3);
			if (firstLineParts.length < 3) {
				throw new ArgumentError('Invalid request: first line must have 3 parts');
			}

			var method:String = firstLineParts[0];
			var url:String = firstLineParts[1];
			var protocol:String = firstLineParts[2];
			if (protocol != "HTTP/1.1" && protocol != "HTTP/1.0") {
				throw new ArgumentError("Invalid request: Invalid protocol");
			}

			var headers:Vector.<Header> = new <Header>[];
			for each (var line:String in lines.slice(1)) {
				if (line === '') { continue; }
				headers.push(Header.deserialize(line));
			}

			return new RequestHead(method, url, protocol, headers);
		}
	}
}
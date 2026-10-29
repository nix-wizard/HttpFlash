package network.nixwiz.engine.http {
	import flash.utils.ByteArray;
	import network.nixwiz.engine.Util;

	public class Response {
		public static const protocol:String = "HTTP/1.1";
		
		public var status:uint;

		public var headers:Object = {};

		public var body:ByteArray = null;

		function Response(status:uint = 200) {
			this.status = status;
		}

		public function addHeader(name:String, value:String):Response {
			var normalizedName:String = name.toLowerCase();
			if (headers.hasOwnProperty(normalizedName)) {
				throw new ArgumentError('Header ' + JSON.stringify(name) + ' already exists');
			}
			headers[normalizedName] = value;
			return this;
		}

		public function setBody(body:ByteArray):Response {
			if (this.body != null) {
				throw new ArgumentError('Response body already set');
			}

			this.body = body;
			addHeader('content-length', body.length.toString());
			return this;
		}

		public function setText(text:String):Response {
			return setBody(Util.encodeString(text));
		}

		public function setHTML(html:XML):Response {
			return setText('<!DOCTYPE html>\n' + html.toXMLString());
		}

		public function serialize():ByteArray {
			var bytes:ByteArray = new ByteArray();
			var head:String = protocol + ' ' + status + ' ' + Status.codeToReason(status) + "\r\n";
			for (var name:String in headers) {
				head += name + ": " + headers[name] + "\r\n";
			}
			head += "\r\n";

			bytes.writeUTFBytes(head);
			if (body != null) {
				body.position = 0;
				bytes.writeBytes(body);
			}

			bytes.position = 0;
			return bytes;
		}
	}
}
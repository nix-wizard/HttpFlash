package network.nixwiz.http {
	import flash.utils.ByteArray;
	import network.nixwiz.Util;

	public class Response {
		public static const protocol:String = "HTTP/1.1";
		
		public var status:uint;

		public var headers:Object = new Object();

		public var data:ByteArray = null;

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

		public function setData(data:ByteArray):Response {
			this.data = data;
			addHeader('content-length', data.length.toString());
			return this;
		}

		public function setText(text:String):Response {
			return setData(Util.encodeString(text));
		}

		public function serialize():ByteArray {
			var bytes:ByteArray = new ByteArray();
			var head:String = protocol + ' ' + status + ' ' + Status.codeToReason(status) + "\r\n";
			for (var name:String in headers) {
				head += name + ": " + headers[name] + "\r\n";
			}
			head += "\r\n";

			bytes.writeUTFBytes(head);
			if (data != null) {
				data.position = 0;
				bytes.writeBytes(data);
			}

			bytes.position = 0;
			return bytes;
		}
	}
}
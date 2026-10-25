package network.nixwiz.http {
	import flash.utils.ByteArray;

	public class Response {
		public const protocol:String = "HTTP/1.1";
		
		public var status:uint;

		public var headers:Vector.<Header>;

		public var data:ByteArray;

		public function Response(status:uint = Status.OK, headers:Vector.<Header> = null, data:ByteArray = null) {
			this.status = status;
			this.headers = headers;
			this.data = data;
		}

		public function toByteArray():ByteArray {
			var bytes:ByteArray = new ByteArray();
			var head:String = protocol + ' ' + status + ' ' + Status.codeToReason(status) + "\r\n";
			if (headers != null) {
				head += headers
					.map(function(header:Header, _:*):String { return header.toString(); })
					.join("\r\n");
				head += "\r\n\r\n";
			}
			else {
				head += "\r\n";
			}

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
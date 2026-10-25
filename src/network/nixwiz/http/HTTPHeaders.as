package network.nixwiz.http {
	public class HTTPHeaders {
		public var headers:Vector.<HTTPHeader> = undefined;

		public function HTTPHeaders(headers:Vector.<HTTPHeader>) {
			this.headers = headers;
		}

		public function push(header:HTTPHeader):void {
			headers.push(header);
		}

		public function toString():String {
			var string:String = "";

			for each (var header:HTTPHeader in this.headers) {
				string = string + header.toString() + "\r\n"
			}

			return string;
		}
	}
}
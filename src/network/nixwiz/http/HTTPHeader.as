package network.nixwiz.http {
	import network.nixwiz.Util;

	public class HTTPHeader {
		public var name:String = undefined;

		public var value:String = undefined;

		public function HTTPHeader(name:String, value:String) {
			this.name = name;
			this.value = value;
		}

		public function toString():String {
			return name + ": " + value;
		}

		public static function headerFromString(header:String):HTTPHeader {
			var name:String = undefined;
			var value:String = undefined;

			header = Util.stripNewlines(header);
			var headerData:Array = header.split(": ", 2);

			name = headerData[0];
			value = headerData[1];

			return new HTTPHeader(name, value);
		}
	}
}
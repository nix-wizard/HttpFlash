package network.nixwiz.http {
	import network.nixwiz.Util;

	public class Header {
		public var name:String;

		public var value:String;

		public function Header(name:String, value:String) {
			this.name = name;
			this.value = value;
		}

		public function serialize():String {
			return name + ": " + value;
		}

		public static function deserialize(line:String):Header {
			line = Util.stripNewlines(line);
			var headerData:Array = line.split(": ", 2);
			if (headerData.length !== 2) {
				throw new ArgumentError('Invalid HTTP header');
			}
			return new Header(headerData[0], headerData[1]);
		}
	}
}
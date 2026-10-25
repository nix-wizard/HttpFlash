package network.nixwiz.http {
	import network.nixwiz.Util;

	public class Header {
		public var name:String = undefined;

		public var value:String = undefined;

		public function Header(name:String, value:String) {
			this.name = name;
			this.value = value;
		}

		public function toString():String {
			return name + ": " + value;
		}

		public static function fromString(str:String):Header {
			str = Util.stripNewlines(str);
			var headerData:Array = str.split(": ", 2);
			return new Header(headerData[0], headerData[1]);
		}
	}
}
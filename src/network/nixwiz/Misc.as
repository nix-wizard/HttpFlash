package network.nixwiz {
	public class Misc {
		public static function stripNewlines(string:String):String {
			string.replace(/\r?\n/, '');

			return string;
		}
	}
}
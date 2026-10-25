package network.nixwiz {
	public class Misc {
		public static function stripNewlines(string:String):String {
			string.replace(/\r?\n/, '');

			return string;
		}
		
		public static function escapeHTML(text:String):String {
			return text.replace(/[&<>"']/g, function (match:String, ..._:Array):String {
				return {
					'&': '&amp;',
					'<': '&lt;',
					'>': '&gt;',
					'"': '&quot;',
					"'": '&#039;'
				}[match];
			});
		}
	}
}
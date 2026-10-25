package network.nixwiz {
    import flash.utils.ByteArray;

    public class Util {
        public static function bind(fn:Function, thisArg:*):Function {
            return function(...args):* {
                return fn.apply(thisArg, args);
            }
        }

        public static function dumpBytes(bytes:ByteArray):String {
            var result:String = '';
            for (var i:uint = 0; i < bytes.length; i++) {
                var byte:uint = bytes[i];
                result +=
                    (i === 0 ? '' : ' ') +
                    (byte >>> 4).toString(16) +
                    (byte & 15).toString(16);
            }
            return result;
        }

        public static function stripNewlines(string:String):String {
			return string.replace(/\r?\n/, '');
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
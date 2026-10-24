package {
    public class Util {
        public static function escapeHtml(text:String):String {
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
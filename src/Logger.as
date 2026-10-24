package {
    import flash.text.TextField;
    import flash.text.StyleSheet;
    import flash.display.DisplayObjectContainer;

    public class Logger {
        private static var messages:Array = [];
        public static var textField:TextField;

        public static function init(parent:DisplayObjectContainer):void {
            var ss:StyleSheet = new StyleSheet();
            ss.setStyle('body', {
                fontFamily: '"Noto Sans Mono", "Liberation Mono", "DejaVu Sans Mono", mono',
                color: '#ffffff'
            });

            textField = new TextField();
            textField.styleSheet = ss;
            textField.background = true;
            textField.backgroundColor = 0x222222;
            textField.wordWrap = true;
            textField.width = parent.stage.stageWidth;
            textField.height = parent.stage.stageHeight;
            parent.addChild(textField);
        }

        public static function log(...values):void {
            trace(message);

            var message:String = values
                .map(function(value:*, ..._):String {
                    return value is String ? value : value.toString();
                })
                .join(' ');

            messages.push(message);
            textField.htmlText =
                '<body>' +
                messages.map(function(message:String, ..._):String {
                    return Util.escapeHtml(message);
                }).join('\r') +
                '</body>';

            textField.scrollV = textField.bottomScrollV;
        }
    }
}
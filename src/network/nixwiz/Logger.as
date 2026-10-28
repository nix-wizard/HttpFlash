package network.nixwiz {
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.display.DisplayObjectContainer;
	import network.nixwiz.Util;

	public class Logger {
		private static var traceOnly:Boolean = true;
		private static var messages:Array = [];
		public static var textField:TextField = null;

		public static function init(parent:DisplayObjectContainer):void {
			if (traceOnly) { return; }

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

		private static function valuesToString(values:Array):String {
			return values
				.map(function(value:*, ..._):String { return value + ''; })
				.join(' ');
		}

		private static function write(message:String):void {
			trace(message);
			if (traceOnly) { return; }

			messages.push(message);
			textField.htmlText =
				'<body>' +
				messages.map(function(message:String, ..._):String {
					return Util.escapeHTML(message);
				}).join('\r') +
				'</body>';

            textField.scrollV = textField.maxScrollV;
		}

		public static function log(...values):void {
			write(valuesToString(values));
        }
    }
}
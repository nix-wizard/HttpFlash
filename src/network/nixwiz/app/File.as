package network.nixwiz.app {
    import flash.utils.ByteArray;

    public class File {
        private var cls:Class;

        public var hash:String;

        function File(cls:Class, hash:String) {
            this.cls = cls;
            this.hash = hash;
        }

        public function getContent():ByteArray {
            return new cls();
        }

		private static const extToMimeMap:Object = {
			"html": "text/html",
			"css": "text/css",
			"png": "image/png",
			"jpeg": "image/jpeg",
			"jpg": "image/jpeg",
			"json": "application/json",
			"txt": "text/plain",
			"bin": "application/octet-stream"
		}

		public static function extToMime(ext:String):String {
			return extToMimeMap[ext] || "application/octet-stream";
		}
    }
}
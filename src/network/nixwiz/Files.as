package network.nixwiz {
	import flash.utils.ByteArray;
	public class Files {
		[Embed(source="assets//html/index.html", mimeType="application/octet-stream")] private static const File0:Class;

		public static const filePaths:Object = {
			"/html/index.html": new File0() as ByteArray
		}

		public static const fileTypes:Object = {
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
			if (fileTypes.hasOwnProperty(ext)) {
				return fileTypes[ext];
			}
			return "application/octet-stream";
		}
	}
}

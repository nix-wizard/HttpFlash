package network.nixwiz {
	import flash.utils.ByteArray;
	public class Files {
		[Embed(source="assets/html/index.html", mimeType="application/octet-stream")] private static const File0:Class;

		public static const FilePaths:Object = {
			"html/index.html": new File0() as ByteArray
		}
	}
}

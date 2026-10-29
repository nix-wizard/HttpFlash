// Files.as.template is to be processed by /build.sh

package network.nixwiz.app {
	import flash.utils.ByteArray;
	public class Files {
		[Embed(source="assets/static/meow.html", mimeType="application/octet-stream")]
		private static const file0:Class;
		[Embed(source="assets/static/index.html", mimeType="application/octet-stream")]
		private static const file1:Class;

		public static const files:Object = {
			"/static/meow.html": new File(file0, "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"),
			"/static/index.html": new File(file1, "9af8e005ec47929a8150dedbcf69888ceb307814db809ede9f45781bdd0fbc2b")
		}
	}
}

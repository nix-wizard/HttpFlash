package network.nixwiz.engine.http {
	public class Status {
		// why the fuck does as3 not have enums
		public static const OK:uint = 200;
		public static const NOT_MODIFIED:uint = 304;
		public static const BAD_REQUEST:uint = 400;
		public static const FORBIDDEN:uint = 403;
		public static const NOT_FOUND:uint = 404;
		public static const METHOD_NOT_ALLOWED:uint = 405;

		private static const reasons:Object = {
			200: "OK",
			304: "Not Modified",
			400: "Bad Request",
			403: "Forbidden",
			404: "Not Found",
			405: "Method Not Allowed"
		};

		public static function codeToReason(code:uint):String {
			return reasons[code] || "";
		}
	}
}
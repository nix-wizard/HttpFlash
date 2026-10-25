package network.nixwiz.http {
	public class HTTPStatus {
		// why the fuck does as3 not have enums
		public static const HTTP_OK:uint = 200;
		public static const HTTP_BAD_REQUEST:uint = 400;
		public static const HTTP_FORBIDDEN:uint = 403;
		public static const HTTP_NOT_FOUND:uint = 404;

		private static const reasons:Object = {
			200: "OK",
			400: "Bad Request",
			403: "Forbidden",
			404: "Not Found"
		}

		public var status:uint = undefined;

		private var reason:String = "";

		public function HTTPStatus(status:uint) {
			this.status = status;
			this.reason = statusToReason();
		}

		public function statusToReason():String {
			return reasons[status] != null ? reasons[status] : "";
		}

		public function toString():String {
			var string:String = undefined;
			string = status.toString();
			if (reason != "") {
				string = string + ' ' + reason.toString();
			}
			return string;
		}
	}
}
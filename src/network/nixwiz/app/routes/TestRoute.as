package network.nixwiz.app.routes {
    import network.nixwiz.engine.http.Request;
    import network.nixwiz.engine.http.Response;
    import network.nixwiz.app.IRoute;

    public class TestRoute implements IRoute {
        public var count:uint = 0;

        public function respond(request:Request):Response {
            count++;
            var queries:XMLList = new XMLList();
            for (var key:String in request.queries) {
                queries += <p>{key} = {request.queries[key]}</p>;
            }
            var html:XML = <html>
                <head>
                    <title>MEOWMOEMWOEMWOEMWOMOEWMO</title>
                </head>
                <body>
                    <p>visited {count} times</p>
                    {queries}
                </body>
            </html>;
            return new Response().setHTML(html);
        }
    }
}
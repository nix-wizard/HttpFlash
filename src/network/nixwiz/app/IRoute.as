package network.nixwiz.app {
    import network.nixwiz.engine.http.Response;
    import network.nixwiz.engine.http.Request;

    public interface IRoute {
        function respond(request:Request):Response;
    }
}
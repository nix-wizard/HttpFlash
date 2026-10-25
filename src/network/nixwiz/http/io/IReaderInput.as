package network.nixwiz.http.io {
    import network.nixwiz.http.Promise;

    /** An asynchronous input stream. */
    public interface IReaderInput {
        function readChunk():Promise;
    }
}
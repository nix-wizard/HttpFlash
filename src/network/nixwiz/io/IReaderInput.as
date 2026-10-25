package network.nixwiz.io {
    import network.nixwiz.Promise;

    /** An asynchronous input stream. */
    public interface IReaderInput {
        function readChunk():Promise;
    }
}
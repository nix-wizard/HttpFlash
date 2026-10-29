package network.nixwiz.engine.io {
    import network.nixwiz.engine.Promise;

    /** An asynchronous input stream that yields chunks of indeterminate size. */
    public interface IReaderInput {
        /** @return A <code>ByteArray</code> promise that resolves to a chunk of any size. */
        function readChunk():Promise;
    }
}
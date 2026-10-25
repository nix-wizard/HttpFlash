package network.nixwiz.io {
    import network.nixwiz.Promise;

    /** An asynchronous input stream that yields chunks of indeterminate size. */
    public interface IReaderInput {
        /** @return A <code>ByteArray</code> promise. */
        function readChunk():Promise;
    }
}
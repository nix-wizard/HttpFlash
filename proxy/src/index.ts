import { createServer, Socket } from 'node:net';
import { Reader, StreamEndedError, Writer } from './util';
import { POLICY_FILE } from './policy-file';
import { Readable } from 'node:stream';

enum PacketKind {
    Connect, // connId
    Disconnect, // connId
    Data, // connId, length, data
}

const flashServer = createServer();

flashServer.on('connection', async (flashSocket) => {
    console.log('Flash client connected');

    const writer = new Writer(flashSocket);
    const reader = new Reader(flashSocket);

    const conns: Socket[] = [];

    const publicServer = createServer();

    publicServer.on('connection', async (publicSocket) => {
        const connId = conns.length;
        conns.push(publicSocket);
        console.log(`public client connected: ${connId}`);

        function writePacketHead(kind: PacketKind) {
            writer.writeUint8(kind);
            writer.writeUint32(connId);
        }

        writePacketHead(PacketKind.Connect);
        console.log(`> Connect { connId: ${connId} }`);

        for await (const chunk_ of publicSocket) {
            const chunk = chunk_ as Buffer;

            writePacketHead(PacketKind.Data);
            writer.writeUint32(chunk.length);
            writer.write(chunk);
            await writer.flush();
            console.log(`> Data { connId: ${connId}, length: ${chunk.length} }`);
        }

        writePacketHead(PacketKind.Disconnect);
        await writer.flush();
        console.log(`> Disconnect { connId: ${connId} }`);
    });

    publicServer.listen(6767, () => {
        console.log('public server listening');
    });

    while (true) {
        let kind: number;
        try {
            kind = await reader.readUint8();
        }
        catch (exc) {
            if (exc instanceof StreamEndedError) { break; }
            throw exc;
        }

        let connId: number;

        async function readConn() {
            connId = await reader.readUint32();
            const conn: Socket | undefined = conns[connId];
            if (conn === undefined) {
                throw new Error(`invalid connection ID: ${connId}`);
            }
            return conn;
        }

        switch (kind) {
            case PacketKind.Data: {
                const conn = await readConn();
                const length = await reader.readUint32();
                const data = await reader.read(length);

                console.log(`< Data { connId: ${connId!}, length: ${data.length} }`);

                conn.write(data);
            } break;

            case PacketKind.Disconnect: {
                const conn = await readConn();

                console.log(`< Disconnect { connId: ${connId!} }`);

                conn.end();
            } break;

            case '<'.charCodeAt(0): {
                const expected = 'policy-file-request/>\0';
                const data = await reader.read(expected.length);
                if (data.toString('ascii') !== expected) {
                    throw new Error('message starting with \'<\' was not a policy file request');
                }

                const buffer = Buffer.allocUnsafe(POLICY_FILE.length);
                buffer.write(POLICY_FILE, 'ascii');
                writer.write(buffer);
            } break;

            default: throw new Error(`invalid packet kind: ${kind}`);
        }
    }

    console.log('Flash server disconnected');
    publicServer.close();
});

flashServer.listen(6768, () => {
    console.log('Flash server listening');
});
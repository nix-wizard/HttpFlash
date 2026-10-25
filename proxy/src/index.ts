import { createServer, Socket } from 'node:net';
import { Reader, StreamEndedError, Writer } from './util';
import { POLICY_FILE } from './policy-file';

enum PacketKind {
    CONNECT, // connId
    DISCONNECT, // connId
    DATA, // connId, length, data
}

const flashServer = createServer();

flashServer.on('connection', async (flashSocket) => {
    console.log('Flash client connected');

    const flashWriter = new Writer(flashSocket);
    const flashReader = new Reader(flashSocket);

    const conns: Socket[] = [];

    const publicServer = createServer();

    publicServer.on('connection', async (publicSocket) => {
        const connId = conns.length;
        conns.push(publicSocket);

        function writePacketHead(kind: PacketKind) {
            flashWriter.writeUint8(kind);
            flashWriter.writeUint32(connId);
        }

        writePacketHead(PacketKind.CONNECT);

        for await (const chunk_ of publicSocket) {
            const chunk = chunk_ as Buffer;

            writePacketHead(PacketKind.DATA);
            flashWriter.writeUint32(chunk.length);
            flashWriter.write(chunk);
        }

        writePacketHead(PacketKind.DISCONNECT);
    });

    publicServer.listen(6767, () => {
        console.log('public server listening');
    });

    while (true) {
        let kind: number;
        try {
            kind = await flashReader.readUint8();
        }
        catch (exc) {
            if (exc instanceof StreamEndedError) {
                console.log('Flash server disconnected');
                break;
            }
            throw exc;
        }

        async function readConn() {
            const connId = await flashReader.readUint32();
            const conn: Socket | undefined = conns[connId];
            if (conn === undefined) {
                throw new Error(`invalid connection ID: ${connId}`);
            }
            return conn;
        }

        switch (kind) {
            case PacketKind.DATA: {
                const conn = await readConn();
                const dataLength = await flashReader.readUint32();
                const data = await flashReader.read(dataLength);
                conn.write(data);
            } break;

            case PacketKind.DISCONNECT: {
                const conn = await readConn();
                conn.end();
            } break;

            case '<'.charCodeAt(0): {
                const expected = 'policy-file-request/>\0';
                const data = await flashReader.read(expected.length);
                if (data.toString('ascii') !== expected) {
                    throw new Error('message starting with \'<\' was not a policy file request');
                }

                const buffer = Buffer.allocUnsafe(POLICY_FILE.length);
                buffer.write(POLICY_FILE, 'ascii');
                flashWriter.write(buffer);
            } break;

            default: throw new Error(`invalid packet kind: ${kind}`);
        }
    }
});

flashServer.listen(6768, () => {
    console.log('Flash server listening');
});
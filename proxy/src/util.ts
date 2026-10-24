import type { Readable, Writable } from 'node:stream';

export class StreamEndedError extends Error {
	constructor(...args: Parameters<typeof Error>) {
		super(...args);
		this.name = this.constructor.name;
	}
}

export class Reader {
	iterator: AsyncIterator<Buffer>;
	chunks: Buffer[];
	length: number;

	constructor(stream: Readable) {
		this.iterator = stream[Symbol.asyncIterator]();
		this.chunks = [];
		this.length = 0;
	}

	async read(size: number) {
		if (!Number.isSafeInteger(size) || size < 0) {
			throw new RangeError('size must be a non-negative integer');
		}

		while (this.length < size) {
			const { value, done } = await this.iterator.next();
			if (done) {
				throw new StreamEndedError(`stream ended before ${size} bytes were available`);
			}

			this.chunks.push(value);
			this.length += value.length;
		}

		const result = Buffer.allocUnsafe(size);
		let offset = 0;
		while (offset < size) {
			const chunk = this.chunks[0];
			const count = Math.min(chunk.length, size - offset);

			chunk.copy(result, offset, 0, count);
			offset += count;
			this.length -= count;

			if (count === chunk.length) {
				this.chunks.shift();
			}
			else {
				this.chunks[0] = chunk.subarray(count);
			}
		}

		return result;
	}

	async readUint8() {
		return (await this.read(1)).readUint8(0);
	}

	async readUint32() {
		return (await this.read(4)).readUint32BE(0);
	}
}

export class Writer {
	stream: Writable;

	constructor(stream: Writable) {
		this.stream = stream;
	}

	write(value: ArrayBufferView) {
		this.stream.write(value);
	}

	#writeInt(value: number, size: number) {
		if (value !== ~~value || value < 0 || value >= 2 ** (size * 8)) {
			throw new RangeError('value out of range');
		}

		const buffer = Buffer.allocUnsafe(size);
		buffer.writeUintBE(value, 0, size);
		this.stream.write(buffer);
	}

	writeUint8(value: number) { this.#writeInt(value, 1); }
	writeUint32(value: number) { this.#writeInt(value, 4); }
}
import type { Readable, Writable } from 'node:stream';

export class StreamEndedError extends Error {
	constructor(...args: Parameters<typeof Error>) {
		super(...args);
		this.name = this.constructor.name;
	}
}

export class Reader {
	readonly #iterator: AsyncIterator<Buffer>;
	#chunks: Buffer[];
	#length: number;

	constructor(stream: Readable) {
		this.#iterator = stream[Symbol.asyncIterator]();
		this.#chunks = [];
		this.#length = 0;
	}

	async read(size: number) {
		if (!Number.isSafeInteger(size) || size < 0) {
			throw new RangeError('size must be a non-negative integer');
		}

		while (this.#length < size) {
			const { value, done } = await this.#iterator.next();
			if (done) {
				throw new StreamEndedError(`stream ended before ${size} bytes were available`);
			}

			this.#chunks.push(value);
			this.#length += value.length;
		}

		const result = Buffer.allocUnsafe(size);
		let offset = 0;
		while (offset < size) {
			const chunk = this.#chunks[0];
			const count = Math.min(chunk.length, size - offset);

			chunk.copy(result, offset, 0, count);
			offset += count;
			this.#length -= count;

			if (count === chunk.length) {
				this.#chunks.shift();
			}
			else {
				this.#chunks[0] = chunk.subarray(count);
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
	chunks: Uint8Array[] = [];
	size = 0;
	maxBufferSize = 16384; // auto-flush threshold

	constructor(stream: Writable) {
		this.stream = stream;
	}

	write(view: NodeJS.TypedArray) {
		const buffer = view instanceof Uint8Array ? view : Buffer.copyBytesFrom(view);
		this.chunks.push(buffer);
		this.size += buffer.length;
		if (this.size >= this.maxBufferSize) this.flush();
	}

	writeUint8(value: number) {
		this.write(Buffer.from([value]));
	}

	#writeInt(value: number, size: number) {
		if (value !== ~~value || value < 0 || value >= 2 ** (size * 8)) {
			throw new RangeError('value out of range');
		}
		const buffer = Buffer.allocUnsafe(size);
		buffer.writeUintBE(value, 0, size);
		this.chunks.push(buffer);
		this.size += size;
	}

	writeUint32(value: number) { this.#writeInt(value, 4); }

	flush(): Promise<void> {
		if (this.chunks.length === 0) { return Promise.resolve(); }

		const buffer = Buffer.concat(this.chunks);
		this.chunks = [];
		this.size = 0;
		return new Promise((resolve, reject) => {
			this.stream.write(buffer, (err) => err == null ? resolve() : reject(err));
		});
	}
}
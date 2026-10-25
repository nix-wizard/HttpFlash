Node.js proxy to allow exposing a Flash application as a TCP server

## what/why

Since Flash doesn't let us start a TCP server, we need to use a helper program outside of Flash land to get it going. Indeed, we communicate with Flash by spinning up yet another TCP server.

## protocol

> [!note]
> Perhaps the most boring and banal protocol you will ever lay your eyes upon.

Packet kind is encoded as a uint8. The payload follows.

A new `connId` is issued for every new client. Old IDs are not reused.

| Kind             | Client-bound? | Server-bound? | Payload                                            |
|------------------|---------------|---------------|----------------------------------------------------|
| `CONNECT = 0`    | yes           | no            | `uint32_t connId`                                  |
| `DISCONNECT = 1` | yes           | yes           | `uint32_t connId`                                  |
| `DATA = 2`       | yes           | yes           | `uint32_t connId, uint32_t length, uint8_t data[]` |
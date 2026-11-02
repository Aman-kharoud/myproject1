# Protocol evidence and compatibility assumptions

## Inspected input

User-provided XAPK: `Send+files+to+TV_1.4.22_APKPure.xapk`.

- Package: `com.yablio.sendfilestotv`
- Android version name: `1.4.22`
- Android version code: `69`
- The bundle contains a base APK plus language, density, and architecture splits.
- Inspection was static. The APK was not installed or run.

Only interoperability facts were carried into this project; the Android executable and its extracted code are not redistributed.

## Confirmed in the supplied base APK

| Fact | Location observed |
|---|---|
| Bonjour service `_nitroshare._tcp.` | `discovery.Device.toServiceInfo`, `ShareActivity.DeviceAdapter.start` |
| TCP listening port 40818 | `transfer.TransferServer.run` |
| 4-byte little-endian size, 1-byte type, then payload | `transfer.Packet` constructors and `read` |
| Encoded size includes the type byte (`payload length + 1`) | `transfer.Packet` constructor |
| Incoming payload bounded at 4 MiB | `transfer.Packet.read` |
| JSON transfer header with string fields `name`, `count`, `size` | `transfer.Transfer.sendTransferHeader` |
| File metadata includes `type=file`, `name`, string `size`, `last_modified`, and compatibility fields | `bundle.FileItem` constructors |
| A zero-length received item advances without opening its file | `transfer.Transfer.processItemHeader` |

The packet types are success=0, error=1, JSON=2, binary=3. TVDrop waits for a success packet from the receiver before reporting a completed send.

Example fixtures:

```text
Success with no data:   01 00 00 00 00
Binary payload "ABC":  04 00 00 00 03 41 42 43
```

The sender streams 64 KiB chunks. A transfer contains a transfer-header packet, then a file-header packet and enough binary packets for each file’s declared size. There is no extra end-of-file marker. The receiver replies with success once all declared files are received.

## Published reference

The package’s transfer structure matches [NitroShare for Android](https://github.com/nitroshare/nitroshare-android). Its [Packet.java implementation](https://github.com/nitroshare/nitroshare-android/blob/master/app/src/main/java/net/nitroshare/android/transfer/Packet.java) also includes the packet-type byte in the length. The older prose wiki is ambiguous about that byte, so this project follows the supplied APK and reference implementation.

TVDrop uses Apple Network.framework Bonjour browsing/advertising rather than sending raw multicast packets. Its Info.plist declares the Bonjour service and the purpose of Local Network access. See [Apple’s local network privacy guidance](https://developer.apple.com/documentation/technotes/tn3179-understanding-local-network-privacy).

## Still unverified

Static inspection does not establish live compatibility. Discovery behavior, Android storage permissions, UI behavior, network timeouts, file-provider access on iPhone, device signing, and bidirectional transfers must be checked on real devices. No claim is made that this project is ready for TestFlight or App Store release.

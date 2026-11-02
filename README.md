# TVDrop — native iPhone companion project

TVDrop is an independent SwiftUI iPhone/iPad app project designed to exchange files with the existing **Send Files to TV** Android app. It targets **iOS 16 or later** and uses only Apple frameworks. No account, advertising SDK, or remote server is included in the app.

**Status: source prototype, not a compiled or installable iPhone app.** The supplied Android version 1.4.22 was inspected to establish its packet format, service discovery type, port, and file headers. The source and project received static checks on Windows. Xcode compilation, the included Swift tests, on-device UI checks, and compatibility with a real Android TV have **not** been run. Those are the next gates, not completed validation.

## What is included

- Native send/receive interface, with progress, timeouts, and cancellation.
- File selection through the iPhone Files picker, including documents, videos, and APKs as data files.
- Bonjour discovery of nearby Send Files to TV receivers.
- Manual TV address and port entry if discovery is unavailable.
- Receiving mode that advertises `TVDrop iPhone` to the Android app.
- Received files accessible in Files → On My iPhone → TVDrop → Received, and through the iOS share sheet.
- Streaming transfers in 64 KB chunks, without loading entire files into memory.
- Per-transfer incoming folders, checks against escaping filenames, bounded packets, free-space checks, and cleanup of incomplete incoming transfers.
- Xcode project, shared build scheme, app icon, permission descriptions, privacy manifest, Swift tests, and a GitHub Actions Mac build workflow.

This is a fresh implementation of the transfer behavior. The original Android executable, UI, logo, ads, and billing code are not included.

## Build when you have a Mac

1. Extract the ZIP and open **TVDrop.xcodeproj** in a current Xcode that supports your iPhone’s iOS version.
2. Select the **TVDrop** target, open **Signing & Capabilities**, and select your Apple development team. Change `com.example.TVDrop` to a unique identifier, such as `com.yourname.tvdrop`.
3. Connect and trust your iPhone. Enable Developer Mode on the iPhone if Xcode requests it.
4. Select the iPhone as the run destination, then choose **Product → Run**.
5. Allow **Local Network** access when TVDrop asks.

Xcode runs on macOS. A free Apple account can be used for personal device testing in Xcode, subject to Apple’s Personal Team limits and periodic reinstallation. TestFlight distribution requires the appropriate Apple Developer Program setup. See [Apple’s Xcode requirements](https://developer.apple.com/xcode/system-requirements) and [Apple’s account and Personal Team documentation](https://developer.apple.com/help/account/basics/about-your-developer-account/).

## Cloud build from Windows

**To generate an unsigned IPA for your own sideloading tool, see [GET-IPA.md](GET-IPA.md).** The separate **Build sideloadable IPA** workflow builds for a physical iPhone and provides `TVDrop-unsigned.ipa` as a downloadable artifact. It requires no signing secrets; signing happens later in your sideloading tool. This workflow has been prepared but has not been run here.

The included `.github/workflows/ios-build.yml` can run the first build checks on a hosted Mac:

1. Create a GitHub repository and put **the contents of this TVDrop folder at the repository root**, including `.github`.
2. Open the repository’s **Actions** tab.
3. Choose **Check iOS project → Run workflow**.
4. The workflow runs `swift test` and builds the iOS Simulator app. Fix any compiler/test failures before moving to device installation.

**The downloadable simulator build cannot be installed on a physical iPhone.** This workflow deliberately contains no signing credentials and does not publish an app. Nothing has been uploaded or run on your behalf.

For a later installable build, configure a Mac build service with your unique bundle identifier, Apple signing certificate, and provisioning profile, then archive the `TVDrop` scheme for an iPhone destination and export using that service’s supported signing flow. TestFlight is one delivery option after Apple account setup. Keep signing material in the service’s secret storage, not in source files. [GitHub documents signing on Mac runners here](https://docs.github.com/en/actions/how-tos/deploy/deploy-to-third-party-platforms/sign-xcode-applications).

## Try it with the TV after building

### iPhone → TV

1. Connect the iPhone and TV to the same Wi-Fi network.
2. On the TV, open **Send Files to TV → Receive**.
3. In TVDrop, choose **Send to TV → Choose files**.
4. Tap **Find TVs**, allow Local Network access, and select your TV.
5. Tap **Send** and keep both apps open until the TV confirms the transfer.

If the TV does not appear, find its IP address in the TV’s network settings and use **Enter address manually**. The inspected Android app listens on port **40818**. Guest Wi-Fi/client isolation, a VPN, or multicast filtering can prevent devices from reaching one another.

### TV → iPhone

1. In TVDrop, choose **Receive files → Start receiving**.
2. In the TV app, choose **Send**, select a file, and select **TVDrop iPhone**.
3. Keep TVDrop open until completion.
4. Open the file from TVDrop’s share button or from the Files app.

Receiving mode accepts transfers from devices that can reach it on the local network. Tap **Stop receiving** when finished. File data is unencrypted because this prototype uses the original app’s local transfer protocol; it has no pairing or authentication layer.

## Current boundaries and known compatibility issues

- Foreground transfers only. Leaving TVDrop for another app cancels an active transfer and stops receiving; returning does not automatically restart discovery or receiving.
- Regular files only. Folder trees and URL-transfer items are rejected. To send photos directly from Photos, first save them to Files. There is no Photos picker or share extension in this version.
- Up to 1,000 files and 20 GB in a transfer, subject to available storage. Only one transfer runs at a time.
- Zero-byte files are supported by TVDrop’s protocol code, but the inspected Android receiver skips opening a file when its length is zero. An empty file may therefore not be created on the TV even if the Android app reports success. Use nonempty files for initial tests.
- The Android app can leave partial files on its side after a cancelled send. TVDrop cannot control the Android receiver’s cleanup behavior.
- Received files are saved into a fresh folder per transfer. Folder paths, control characters, and duplicate names within one incoming batch are rejected. Original file timestamps/permissions are not restored on iPhone.
- No resume, pairing, background transfers, App Store submission, or Android-app installation is implemented. Sending an APK transfers the file; it does not install it on the TV or make it runnable on iOS.
- The app identifies itself independently as **TVDrop**. It is not an official release from the Android app’s developer.

## Validation on a Mac

From this folder:

```sh
swift test
xcodebuild -project TVDrop.xcodeproj -scheme TVDrop \
  -configuration Debug -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO build
```

The Swift package contains the same protocol, connection, and transfer engine files used by the app. Tests cover packet fixtures, invalid lengths/types, safe filenames, string-form numeric headers, error packets, cancellation, and an actual localhost TCP round trip with multiple chunks, a Unicode filename, and an empty file. **These test sources are included but were not executed on Windows.** Xcode’s app scheme has no XCTest target; run the core tests with `swift test` or the included workflow.

For a real-device release gate, follow `DEVICE-TEST-CHECKLIST.md`. More protocol evidence and static verification details are in `PROTOCOL-NOTES.md` and `VALIDATION.md`.

## Files

| File/folder | Purpose |
|---|---|
| `TVDrop.xcodeproj` | Open this in Xcode |
| `App/` | SwiftUI screens, app model, icon, permission and privacy files |
| `Core/` | Packet format, network connection, streaming sender/receiver |
| `Tests/` | Protocol and network tests for macOS |
| `Package.swift` | Runs shared core tests with `swift test` |
| `.github/workflows/ios-build.yml` | Hosted Mac checks and simulator build |
| `.github/workflows/build-ipa.yml` | Hosted Mac checks, physical-iPhone build, and unsigned IPA packaging |

Protocol references: [NitroShare’s Android implementation](https://github.com/nitroshare/nitroshare-android) and [Send Files to TV](https://www.sendfilestotv.app/). No third-party runtime libraries are required.

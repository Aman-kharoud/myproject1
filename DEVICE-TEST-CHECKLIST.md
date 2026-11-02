# Device test checklist — not yet performed

Build and core test checks must pass before treating this as a working app.

- [ ] `swift test` passes on a Mac.
- [ ] Xcode simulator build succeeds.
- [ ] Signed build installs and launches on the target iPhone.
- [ ] Local Network permission text appears and denial produces a useful recovery path.
- [ ] Nearby TV is found while Send Files to TV 1.4.22 is on its Receive screen.
- [ ] Manual TV IP plus port 40818 works when discovery is unavailable.
- [ ] Send a small text file, verify the actual file on the TV, and compare content.
- [ ] Send a video larger than 64 KB and compare its size and SHA-256 with the source.
- [ ] Send multiple files with spaces and Unicode characters in their names.
- [ ] Send from the TV to TVDrop and verify the resulting content in Files.
- [ ] An empty incoming file is created on iPhone. Treat empty files sent to Android as a known limitation.
- [ ] Cancel a transfer in both directions; verify the iPhone does not publish partial incoming files.
- [ ] Disconnect Wi-Fi midway; verify the timeout and recovery path.
- [ ] Background the app midway; verify the transfer stops and a later transfer can start cleanly.
- [ ] A nearly full iPhone rejects a transfer without claiming success.
- [ ] Stop receiving; verify the app disappears from the TV’s receiver list after discovery caches expire.
- [ ] Restart TVDrop; completed received files are listed again.
- [ ] Check portrait/landscape, iPad layout, large text, and VoiceOver labels.

Record the iPhone model, iOS version, Android TV model, TV app version, file hashes, and results. A successful simulator build alone does not establish Android TV compatibility.

# Validation status

Prepared on Windows on November 2, 2026.

The package was subsequently updated with a manual physical-iPhone IPA build workflow and `GET-IPA.md`. The workflow was checked as YAML and its project paths and packaging steps were reviewed. It has not been run on a Mac, and no IPA has been generated locally.

## Completed here

- Read the supplied XAPK manifest and inspected the base APK’s DEX methods without executing the Android app.
- Confirmed the service type, listening port, packet framing, payload-size bound, transfer metadata, and file metadata against the supplied version 1.4.22.
- Parsed all seven Swift source/manifest/test files with a Swift syntax parser; no syntax errors reported.
- Parsed Info.plist and PrivacyInfo.xcprivacy as property lists.
- Parsed the shared Xcode scheme as XML and asset catalogs as JSON.
- Checked that every project object reference resolves and every app/core Swift source is included in the Xcode build sources.
- Checked the packaged project’s file inventory and ZIP integrity.

These are static checks. The syntax parser is not the Swift compiler and cannot validate Apple API availability, type checking, actor-isolation rules, linking, signing, or runtime behavior.

## Not completed here

- Xcode build or Swift type checking.
- Execution of the nine included Swift tests, including the TCP loopback test.
- Launching or visually checking the actual iOS app in a simulator or on an iPhone.
- iPhone ↔ Android TV interoperability testing.
- Generating a signed IPA, provisioning a device, running the hosted build workflow, or submitting to TestFlight/App Store.

The development environment has no Mac/Xcode or connected iPhone/TV test session. The included Mac workflow and device test checklist define the next verification steps. Until those pass, this should be treated as a prototype source project.

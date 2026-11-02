# Generate an IPA you can sideload

The project now includes **Build sideloadable IPA**, a manual GitHub Actions workflow that builds for a physical iPhone, checks the executable’s target platform, and packages `TVDrop-unsigned.ipa`.

**No IPA has been compiled yet.** This Windows environment has no Xcode or connected Mac build service. The workflow must finish successfully on a hosted Mac before there is an IPA to download. The workflow runs the shared-code tests first and stops on a test, compiler, or packaging failure.

## Using GitHub from Windows

1. Extract `TVDrop-iOS-Project.zip`.
2. Create a GitHub repository and upload the **contents of the TVDrop folder at the repository root**. Include the `.github` folder, which can be hidden by some file browsers. Keep `TVDrop.xcodeproj`, `App`, `Core`, `Tests`, and `Package.swift` together at the root.
3. Confirm that `.github/workflows/build-ipa.yml` is present on the repository’s default branch.
4. Open **Actions → Build sideloadable IPA → Run workflow**.
5. When it succeeds, open the run and download the **TVDrop-IPA** artifact at the bottom of its page.
6. Extract the downloaded artifact ZIP. The file to give your sideloading tool is **TVDrop-unsigned.ipa** inside it.

GitHub may require you to enable Actions, and hosted-runner availability or charges depend on your account. No Apple signing secrets are needed for this unsigned build. No TestFlight or App Store upload is performed.

If the run fails, download or copy the failed step’s log so the actual compiler or test error can be fixed. A source ZIP or a simulator build cannot be renamed into a usable iPhone IPA.

## Install the generated IPA

Use your preferred sideloading tool that supports signing an app package. For Sideloadly on Windows, follow its current official setup instructions, connect and trust your iPhone, choose the generated IPA, and complete signing in Sideloadly with your own Apple account. Enable Developer Mode and trust the developer profile if prompted. Allow Local Network access on TVDrop’s first use.

An unsigned IPA still requires signing before iOS will run it. With a free Apple account, Sideloadly documents a seven-day installation period before refresh/reinstallation. Enter your credentials in your chosen tool; they are not needed in this chat or the repository.

## What remains to test

The workflow checks the transfer core and compiles a device app, but it cannot establish compatibility with your TV. Test a small file in each direction before sending large files. Refer to `DEVICE-TEST-CHECKLIST.md` for the device checks.

Official references: [Run a GitHub workflow manually](https://docs.github.com/en/actions/how-tos/manage-workflow-runs/manually-run-a-workflow), [Sideloadly](https://sideloadly.io/), and [Sideloadly’s FAQ](https://sideloadly.io/faq.html).

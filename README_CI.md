CI helper

This project includes a GitHub Actions workflow that starts the Firestore emulator and runs the Flutter test suite.

How it works
- `ci/start_emulator.sh` installs `firebase-tools` and starts the Firestore emulator in the background.
- `.github/workflows/firestore-emulator-ci.yml` configures the CI runner (Java + Node), runs `ci/start_emulator.sh`, installs Flutter, and runs `flutter test`.

Locally
1. Install the Firebase CLI and start the emulator manually:

```bash
npm install -g firebase-tools
firebase emulators:start --only firestore
```

2. Run the integration test that targets the emulator:

```bash
flutter test test/integration/firestore_emulator_ingest_test.dart
```

Notes
- The workflow expects the default emulator ports; adjust `ci/start_emulator.sh` and the workflow file if you customize ports or project id.

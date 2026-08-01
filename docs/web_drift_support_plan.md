# Web Target Support Plan — Drift SQLite Web Configuration

## Goal Description
Configure `driftDatabase` in `app_database.dart` to support both native mobile/desktop platforms and the Flutter Web platform. Currently, running on Web throws `Invalid argument(s): When compiling to the web, the web parameter needs to be set.`.

## Proposed Changes

### [Flutter App Core Database]

#### [MODIFY] [app_database.dart](file:///e:/projects/quran_mobile_app/src/quran_mobile_app/lib/src/core/database/app_database.dart)
- Update `driftDatabase(name: 'quran_platform_mobile')` call to include `web: DriftWebOptions(sqlite3Wasm: Uri.parse('sqlite3.wasm'), driftWorker: Uri.parse('drift_worker.js'))`.

## Verification Plan

### Automated Tests
- Run `flutter test` in `src/quran_mobile_app` to ensure unit and database tests pass.

### Manual Verification
- Launch `flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5050`
- Execute `browser_subagent` to open `http://127.0.0.1:5050` and verify the live app rendering in Chrome.

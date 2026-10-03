# GitHub Actions Android APK Build & Script Automation Plan

## 1. Overview & Objective
Enable seamless triggering, compiling, and artifact delivery of the Quran Mobile App release APK through GitHub Actions cloud runners (`ubuntu-latest`), integrated directly with the repository's PowerShell and Python automation scripts in `scripts/`.

---

## 2. Pipeline Architecture & Workflow Triggers

### 2.1 Dedicated APK Pipeline (`.github/workflows/build-apk.yml`)
- **Trigger**: `workflow_dispatch`
- **Inputs**:
  - `abi`: `arm64-v8a` (default), `universal`, `all`
  - `target_url`: Backend target API endpoint (default: `http://localhost:5000`)
  - `send_to_rubika`: Package delivery to Rubika Bot (default: `true`)
- **Jobs**:
  - Setup Java JDK 17 (Temurin)
  - Setup Python 3.11 & install dependencies
  - Setup Flutter SDK (stable channel)
  - Cache Gradle & Flutter artifacts
  - Compile Release APK (`flutter build apk --release --dart-define=API_BASE_URL=$API_URL --no-tree-shake-icons --android-skip-build-dependency-validation`)
  - Package `app-release.apk` and `app-release.zip`
  - Upload build artifacts to GitHub Actions (`actions/upload-artifact@v4`)
  - Execute distribution script `scripts/upload-to-rubika.py`

### 2.2 Unified Mobile Pipeline (`.github/workflows/build-mobile.yml`)
- **Trigger**: Automated on `push` to `master` modifying `src/quran_mobile_app/**` or on-demand `workflow_dispatch`.
- Builds Android APK on Ubuntu and skips iOS macOS runners on push to conserve quota.

---

## 3. Automation Scripts Enhancement (`scripts/`)

### 3.1 `scripts/build-apk.ps1` Enhancement
- Add `-Cloud` and `-GitHubActions` switches:
  - If `-Cloud` / `-GitHubActions` is supplied, check GitHub configuration / token / CLI and trigger the GitHub Actions `build-apk.yml` workflow dispatch event.
  - If omitted, retain full local Windows Flutter release build and tunnel orchestration.
- Support `-Abi` parameter (`arm64-v8a`, `universal`, `all`).
- Provide live run links and instructions to download the compiled release APK.

### 3.2 `scripts/upload-to-rubika.py` CI Optimization
- Detect CI environment (`CI=true` or `GITHUB_ACTIONS=true`).
- In CI runners where Iran domestic intranet IPs or SOCKS5 proxies are inaccessible, fail-fast with a graceful warning within 15 seconds instead of waiting for three 180-second timeout loops (9+ minutes), preserving GitHub Actions runner minutes while allowing local machines to perform full SOCKS5 SSH bridge transfers.

---

## 4. Execution Phases

| Phase | Description | Status |
|---|---|---|
| **Phase 1** | Trigger GitHub Actions `build-apk.yml` and `build-mobile.yml` pipelines | ✅ Completed |
| **Phase 2** | Optimize `scripts/upload-to-rubika.py` with fast CI connectivity pre-check | ✅ Completed |
| **Phase 3** | Enhance `scripts/build-apk.ps1` with `-Cloud` / `-GitHubActions` dispatch support | ✅ Completed |
| **Phase 4** | Document Phase 20 in `README.md` and verify syntax/scripts | ✅ Completed |

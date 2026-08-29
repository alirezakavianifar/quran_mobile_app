# GitHub Actions CI/CD & Deployment Pipeline Implementation Plan

## Goal Description
Establish an automated CI/CD and deployment system for the **Quran Knowledge Platform & Mobile App** following the architecture in `E:\projects\leitner_app`. It encompasses automated Android APK packaging with ABI splitting, iOS building, SSH-based remote production deployment with Docker Compose orchestration, and automated build distribution to Rubika Bot.

---

## 1. Requirements & Architecture

### 1.1 Android APK Build Workflow (`build-apk.yml`)
- Trigger on `workflow_dispatch`.
- Inputs:
  - `abi`: `arm64-v8a`, `universal`, `all` (default: `arm64-v8a`).
  - `target_url`: Target backend API URL (default: `http://localhost:5000` / production URL).
  - `send_to_rubika`: boolean (default: `true`).
- Steps:
  - Checkout repository.
  - Setup Java JDK 17 (Temurin).
  - Setup Python 3.11 with `requests`, `requests_toolbelt`, `urllib3`.
  - Setup Flutter SDK (stable).
  - Clean & prepare `src/quran_mobile_app`.
  - Build release APK with `--split-per-abi` or universal, package into `.zip`.
  - Upload artifacts using `actions/upload-artifact@v4`.
  - Distribute build to Rubika Bot via `scripts/upload-to-rubika.py`.

### 1.2 Unified Mobile Pipeline (`build-mobile.yml`)
- Trigger on push to `main`/`master` and `workflow_dispatch`.
- Jobs:
  - `build-android`: Android build, zip packaging, artifact upload, and Rubika distribution.
  - `build-ios`: macOS runner, iOS packaging (`ipa` / `simulator.zip`), and artifact upload.

### 1.3 Production Server Deployment (`deploy-server.yml`)
- Trigger on push to `main`/`master` and `workflow_dispatch`.
- Inputs: `server_ip`, `server_user`.
- Steps:
  - Configure SSH private key from `secrets.SERVER_SSH_KEY` / `secrets.DEPLOY_SSH_KEY`.
  - Package lightweight deployment archive (`.tar.gz` excluding git, tests, mobile app).
  - SCP archive to server `/tmp/`, extract to `/opt/quran-platform`.
  - Execute `docker compose up -d --build`.
  - Health check probe on `/healthz` and `/api/v1/health`.

### 1.4 Helper Utilities in `scripts/`
- `scripts/upload-to-rubika.py`: Robust Python utility for uploading files to Rubika Bot with chunking and SSH SOCKS5 proxy fallback.
- `scripts/deploy-to-server.ps1`: Local/remote 1-click PowerShell deployment script.

---

## 2. Implementation Steps

### Phase 1: Distribution & Deployment Scripts
- Create `scripts/upload-to-rubika.py` with multi-part chunked upload, progress monitoring, and SOCKS5 proxy support.
- Create `scripts/deploy-to-server.ps1` with archive compression, remote SSH extraction, and container build.

### Phase 2: Workflow Definitions
- Create `.github/workflows/build-apk.yml`.
- Create `.github/workflows/build-mobile.yml`.
- Create `.github/workflows/deploy-server.yml`.

### Phase 3: Documentation Updates
- Update `README.md` with GitHub Actions workflow documentation, inputs, secrets, and deployment guides.

### Phase 4: Validation & Testing
- Validate Python syntax with `py_compile`.
- Validate YAML syntax across workflows.
- Run Flutter test suite to verify no regressions.

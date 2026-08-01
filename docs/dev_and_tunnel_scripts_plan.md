# Dev & Tunnel PowerShell Scripts Implementation Plan

## Overview
This plan outlines the creation of PowerShell helper scripts (`start-tunnel.ps1`, `start-dev.ps1`, and `build-apk.ps1`) for the **Quran Mobile App & Platform** workspace, modeled after the scripts in `leitner-learning-platform`.

## Objectives
1. **`start-tunnel.ps1`**: Forward port 5153 (QuranPlatform.API) via Ngrok to provide a publicly accessible tunnel URL for remote device testing.
2. **`start-dev.ps1`**: Automatically manage local port 5153, start the `.NET` backend in a separate terminal window, wait for backend health check, detect connected Flutter devices, present an interactive menu, and run the Flutter mobile app on the selected target device.
3. **`build-apk.ps1`**: Build release Android APK using Flutter with custom or Ngrok backend target URL support (`--dart-define=API_BASE_URL=...`) and output the APK to the root workspace directory.
4. **`README.md`**: Update project documentation detailing the usage of all PowerShell helper scripts.

## Target Paths & Specifications
- **Workspace Root**: `e:\projects\quran_mobile_app`
- **Backend Project**: `src\QuranPlatform.API\QuranPlatform.API.csproj`
- **Backend URL & Port**: `http://localhost:5153` (Port `5153`)
- **Flutter App Location**: `src\quran_mobile_app`

## Proposed Scripts

### 1. `scripts/start-tunnel.ps1`
- Verifies `ngrok` executable exists in `PATH`.
- Checks if backend process is listening on port `5153`. If not, starts `dotnet run` for `QuranPlatform.API` in a new window.
- Checks if Ngrok is active on `http://127.0.0.1:4040/api/tunnels`.
- Launches Ngrok tunnel on port `5153` if not active and polls until active.
- Outputs public HTTPS/HTTP tunnel URL for use in mobile app or remote testing.

### 2. `scripts/start-dev.ps1`
- Kills any stale process listening on port `5153`.
- Launches `.NET` backend (`QuranPlatform.API`) in a new PowerShell window.
- Polls local endpoint `http://localhost:5153/swagger` (or root/health) until responsive.
- Runs `flutter devices` in `src/quran_mobile_app` to detect target devices (Windows, Chrome, Android, iOS).
- Interactive user prompt to select target device or quit.
- Launches `flutter run -d <target>` in a new PowerShell window.

### 3. `scripts/build-apk.ps1`
- Accepts `-TargetUrl` parameter or detects active Ngrok / local fallback (`http://10.0.2.2:5153`).
- Navigates to `src/quran_mobile_app`.
- Runs `flutter clean` and `flutter pub get`.
- Compiles Flutter APK with release configuration and `--dart-define=API_BASE_URL=$apiBaseUrl`.
- Copies final APK to project root (`app-release.apk`).

## Verification Plan
1. Test script syntax using `Get-Command` or PowerShell dry-run checks.
2. Verify file paths for `.csproj` and `src/quran_mobile_app` resolve correctly relative to `$PSScriptRoot`.
3. Verify documentation in `README.md`.

# Implementation Plan - Launch Admin Panel PowerShell Script

## Goal
Create a dedicated PowerShell script `scripts/start-admin.ps1` that checks backend status, launches the ASP.NET Core API server if it's not already running, waits for it to become ready, and automatically opens the Admin Web Dashboard (`http://localhost:5153/admin/`) in the user's default browser. Update `README.md` to document `start-admin.ps1`.

## Proposed Changes

### Scripts & Documentation

#### [NEW] [start-admin.ps1](file:///e:/projects/quran_mobile_app/scripts/start-admin.ps1)
- Create `scripts/start-admin.ps1`:
  - Check if port `5153` is listening.
  - If listening, verify connection; if not running, start `.NET` backend in a separate terminal using `dotnet run --project src/QuranPlatform.API/QuranPlatform.API.csproj --urls http://localhost:5153`.
  - Wait for `http://localhost:5153/healthz` or `http://localhost:5153/swagger` to respond.
  - Open `http://localhost:5153/admin/` in the default web browser using `Start-Process "http://localhost:5153/admin/"`.
  - Print summary of available URLs (Admin UI, Swagger API, Health Probe).

#### [MODIFY] [README.md](file:///e:/projects/quran_mobile_app/README.md)
- Add `.\scripts\start-admin.ps1` under the Development & Launch Helper Scripts section and Phase 7 documentation.

## Verification Plan

### Automated / Syntax Verification
- Test PowerShell syntax using `powershell -Command "Get-Command -Syntax .\scripts\start-admin.ps1"` or parsing test.

### Manual Verification
- Run `.\scripts\start-admin.ps1` from PowerShell and verify that it starts backend if needed and opens `http://localhost:5153/admin/`.

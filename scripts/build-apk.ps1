# =============================================================================
#  Quran Mobile App - Master 1-Click Tunnel & APK Builder
#  Usage: .\scripts\build-apk.ps1 [-TargetUrl "https://xxxx.ngrok-free.app"]
# =============================================================================

param (
    [string]$TargetUrl = ""
)

$ErrorActionPreference = "Continue"

# -- Paths --------------------------------------------------------------------
$ROOT         = Split-Path $PSScriptRoot -Parent
$MOBILE_DIR   = "$ROOT\src\quran_mobile_app"
$OUTPUT_DIR   = "$ROOT"
$BACKEND_PROJ = "$ROOT\src\QuranPlatform.API\QuranPlatform.API.csproj"
$BACKEND_URL  = "http://localhost:5153"

# -- Helpers ------------------------------------------------------------------
function Write-Header {
    Clear-Host
    Write-Host ""
    Write-Host "  +======================================================+" -ForegroundColor Cyan
    Write-Host "  |   Quran Mobile App  -  Master Tunnel & APK Builder   |" -ForegroundColor Cyan
    Write-Host "  +======================================================+" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step([string]$msg) {
    Write-Host "  >> $msg" -ForegroundColor Yellow
}

function Write-Ok([string]$msg) {
    Write-Host "  [OK] $msg" -ForegroundColor Green
}

function Write-Err([string]$msg) {
    Write-Host "  [ERROR] $msg" -ForegroundColor Red
}

function Write-Info([string]$msg) {
    Write-Host "  [INFO] $msg" -ForegroundColor DarkCyan
}

# -- Logic --------------------------------------------------------------------
Write-Header

$apiBaseUrl = ""

if (-not [string]::IsNullOrWhiteSpace($TargetUrl)) {
    $apiBaseUrl = $TargetUrl.Trim()
    if (-not ($apiBaseUrl.StartsWith("http://") -or $apiBaseUrl.StartsWith("https://"))) {
        $apiBaseUrl = "https://$apiBaseUrl"
    }
    if ($apiBaseUrl.EndsWith("/")) {
        $apiBaseUrl = $apiBaseUrl.Substring(0, $apiBaseUrl.Length - 1)
    }
    Write-Info "Targeting custom specified backend endpoint: $apiBaseUrl"
} else {
    # 1. Verify / Launch Backend on Port 5153 / 5000
    Write-Step "Checking backend process and port status..."
    $apiProc = Get-Process QuranPlatform.API -ErrorAction SilentlyContinue
    $backendListening = netstat -ano | Select-String ":5153\s.*LISTENING|:5000\s.*LISTENING"

    if ($apiProc -or $backendListening) {
        Write-Ok "Backend API process is already running and online."
    } else {
        Write-Step "Launching .NET backend API in background..."
        $backendArgs = "dotnet run --project `"$BACKEND_PROJ`" --urls `"$BACKEND_URL`""
        Start-Process powershell -ArgumentList "-NoExit", "-Command", $backendArgs -WindowStyle Minimized
        Start-Sleep -Seconds 3
    }

    # 2. Check / Start Ngrok Tunnel
    Write-Step "Checking Ngrok public tunnel status..."
    $ngrokUrl = $null
    try {
        $tunnels = Invoke-RestMethod -Uri "http://127.0.0.1:4040/api/tunnels" -TimeoutSec 2 -ErrorAction SilentlyContinue
        if ($tunnels.tunnels) {
            $ngrokUrl = $tunnels.tunnels[0].public_url
            Write-Ok "Active Ngrok tunnel detected: $ngrokUrl"
        }
    } catch {}

    if ($null -eq $ngrokUrl -and (Get-Command ngrok -ErrorAction SilentlyContinue)) {
        Write-Step "Launching background Ngrok tunnel for port 5153..."
        Start-Process cmd -ArgumentList '/k "title Ngrok Tunnel - Quran App & ngrok http 5153"' -WindowStyle Minimized
        
        Write-Step "Waiting for Ngrok tunnel to establish..."
        $attempts = 0
        $maxAttempts = 5
        while ($attempts -lt $maxAttempts) {
            Start-Sleep -Seconds 2
            try {
                $tunnels = Invoke-RestMethod -Uri "http://127.0.0.1:4040/api/tunnels" -TimeoutSec 2
                if ($tunnels.tunnels) {
                    $ngrokUrl = $tunnels.tunnels[0].public_url
                    Write-Ok "Ngrok tunnel established: $ngrokUrl"
                    break
                }
            } catch {}
            $attempts++
        }
    }

    # 3. Resolve API URL
    if ([string]::IsNullOrWhiteSpace($ngrokUrl)) {
        $apiBaseUrl = "http://10.0.2.2:5153"
        Write-Info "Using standalone offline + local emulator loopback: $apiBaseUrl"
    } else {
        $apiBaseUrl = $ngrokUrl.Trim()
        if (-not ($apiBaseUrl.StartsWith("http://") -or $apiBaseUrl.StartsWith("https://"))) {
            $apiBaseUrl = "https://$apiBaseUrl"
        }
        if ($apiBaseUrl.EndsWith("/")) {
            $apiBaseUrl = $apiBaseUrl.Substring(0, $apiBaseUrl.Length - 1)
        }
        Write-Info "Targeting public backend endpoint: $apiBaseUrl"
    }
}

# 4. Build Flutter Release APK
Write-Step "Navigating to mobile application directory..."
Push-Location $MOBILE_DIR

try {
    Write-Step "Building Flutter Release APK with API_BASE_URL=$apiBaseUrl ..."
    flutter build apk --release --no-tree-shake-icons --dart-define=API_BASE_URL=$apiBaseUrl

    $apkPath = "$MOBILE_DIR\build\app\outputs\flutter-apk\app-release.apk"
    $destPath = "$OUTPUT_DIR\app-release.apk"

    if (Test-Path $apkPath) {
        Write-Step "Copying compiled APK to workspace root: $destPath ..."
        Copy-Item -Path $apkPath -Destination $destPath -Force
        
        Write-Ok "Master APK Build Successful!"
        Write-Host ""
        Write-Host "  =======================================================" -ForegroundColor Green
        Write-Host "  APK File Location : $destPath" -ForegroundColor Green
        Write-Host "  Backend Endpoint  : $apiBaseUrl" -ForegroundColor Cyan
        Write-Host "  Offline Datasets  : All 114 Surahs & 6,236 Verses Included" -ForegroundColor Green
        Write-Host "  =======================================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "  How to install:" -ForegroundColor Yellow
        Write-Host "    1. Copy 'app-release.apk' to your Android phone." -ForegroundColor Gray
        Write-Host "    2. Install the APK and enjoy!" -ForegroundColor Gray
        Write-Host ""
    } else {
        Write-Err "Could not locate compiled APK at $apkPath."
    }
}
catch {
    Write-Err "Build failed: $_"
}
finally {
    Pop-Location
}

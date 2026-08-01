# =============================================================================
#  Quran Mobile App - Android APK Builder (Fully Automated)
#  Usage: .\scripts\build-apk.ps1 [-TargetUrl "http://45.94.215.188"]
# =============================================================================

param (
    [string]$TargetUrl = ""
)

$ErrorActionPreference = "Stop"

# -- Paths --------------------------------------------------------------------
$ROOT         = Split-Path $PSScriptRoot -Parent
$MOBILE_DIR   = "$ROOT\src\quran_mobile_app"
$OUTPUT_DIR   = "$ROOT"
$BACKEND_URL  = "http://localhost:5153"

# -- Helpers ------------------------------------------------------------------
function Write-Header {
    Clear-Host
    Write-Host ""
    Write-Host "  +======================================================+" -ForegroundColor Cyan
    Write-Host "  |        Quran Mobile App  -  APK Builder              |" -ForegroundColor Cyan
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
        $apiBaseUrl = "http://$apiBaseUrl"
    }
    if ($apiBaseUrl.EndsWith("/")) {
        $apiBaseUrl = $apiBaseUrl.Substring(0, $apiBaseUrl.Length - 1)
    }
    Write-Info "Targeting custom specified backend endpoint: $apiBaseUrl"
} else {
    # 1. Verify Backend is running
    Write-Step "Checking if backend is running on port 5153..."
    $backendRunning = $false
    try {
        $r = Invoke-WebRequest -Uri "$BACKEND_URL/swagger/index.html" -UseBasicParsing -TimeoutSec 3 -ErrorAction Stop
        if ($r.StatusCode -lt 500) {
            $backendRunning = $true
            Write-Ok "Backend is online and responding at $BACKEND_URL"
        }
    } catch {
        Write-Host "  [WARNING] Backend was not detected on port 5153." -ForegroundColor Yellow
    }

    if (-not $backendRunning) {
        Write-Info "Backend not detected on port 5153. Building standalone offline APK with full Drift SQLite dataset..."
    }

    # 2. Check/Start Ngrok
    Write-Step "Checking if Ngrok is running..."
    $ngrokUrl = $null

    # Check if ngrok is already running and has tunnels
    try {
        $tunnels = Invoke-RestMethod -Uri "http://127.0.0.1:4040/api/tunnels" -TimeoutSec 2 -ErrorAction SilentlyContinue
        if ($tunnels.tunnels) {
            $ngrokUrl = $tunnels.tunnels[0].public_url
            Write-Ok "Detected active Ngrok tunnel: $ngrokUrl"
        }
    } catch {}

    if ($null -eq $ngrokUrl) {
        # Verify ngrok command exists
        if (-not (Get-Command ngrok -ErrorAction SilentlyContinue)) {
            Write-Err "'ngrok' was not found in your system PATH."
            Write-Host "  Please install ngrok or run it manually and pass the URL." -ForegroundColor Yellow
            $ngrokUrl = Read-Host "  Or manually enter your active Ngrok/dev URL (or press Enter for default dev local loopback)"
        } else {
            Write-Step "Starting Ngrok tunnel in background for port 5153..."
            Start-Process ngrok -ArgumentList "http 5153" -WindowStyle Hidden
            
            Write-Step "Waiting for Ngrok tunnel to establish..."
            $attempts = 0
            $maxAttempts = 6
            while ($attempts -lt $maxAttempts) {
                Start-Sleep -Seconds 2
                try {
                    $tunnels = Invoke-RestMethod -Uri "http://127.0.0.1:4040/api/tunnels" -TimeoutSec 2
                    if ($tunnels.tunnels) {
                        $ngrokUrl = $tunnels.tunnels[0].public_url
                        Write-Ok "Ngrok tunnel established successfully!"
                        break
                    }
                } catch {}
                $attempts++
            }
        }
    }

    # 3. Resolve API URL
    if ([string]::IsNullOrWhiteSpace($ngrokUrl)) {
        $apiBaseUrl = "http://10.0.2.2:5153"
        Write-Info "Using default Android emulator loopback: $apiBaseUrl"
    } else {
        $ngrokUrl = $ngrokUrl.Trim()
        if (-not ($ngrokUrl.StartsWith("http://") -or $ngrokUrl.StartsWith("https://"))) {
            $ngrokUrl = "https://$ngrokUrl"
        }
        if ($ngrokUrl.EndsWith("/")) {
            $ngrokUrl = $ngrokUrl.Substring(0, $ngrokUrl.Length - 1)
        }
        $apiBaseUrl = $ngrokUrl
        Write-Info "Targeting backend endpoint: $apiBaseUrl"
    }
}

Write-Step "Navigating to mobile application directory..."
Push-Location $MOBILE_DIR

try {
    Write-Step "Running flutter clean..."
    flutter clean

    Write-Step "Fetching flutter packages..."
    flutter pub get

    Write-Step "Building release APK with API_BASE_URL=$apiBaseUrl ..."
    flutter build apk --release --no-tree-shake-icons --dart-define=API_BASE_URL=$apiBaseUrl

    $apkPath = "$MOBILE_DIR\build\app\outputs\flutter-apk\app-release.apk"
    $destPath = "$OUTPUT_DIR\app-release.apk"

    if (Test-Path $apkPath) {
        Write-Step "Copying generated APK to workspace root..."
        Copy-Item -Path $apkPath -Destination $destPath -Force
        
        Write-Step "Cleaning up intermediate build files to reclaim disk space..."
        flutter clean
        
        Write-Ok "APK built successfully!"
        Write-Host ""
        Write-Host "  Output Location: $destPath" -ForegroundColor Green
        Write-Host "  How to use:" -ForegroundColor Cyan
        Write-Host "    1. Copy '$(Split-Path $destPath -Leaf)' to your Android phone." -ForegroundColor Gray
        Write-Host "    2. Install the APK and enjoy testing with your local backend!" -ForegroundColor Gray
        Write-Host ""
    } else {
        Write-Err "Could not locate the compiled APK at $apkPath."
    }
}
catch {
    Write-Err "Build failed: $_"
}
finally {
    Pop-Location
}

# =============================================================================
#  Quran Mobile App & Platform - Admin Panel Launcher
#  Usage: .\scripts\start-admin.ps1 [-NoBrowser]
#  Starts the .NET backend (if not already running) and opens the Web Admin Panel.
# =============================================================================

param(
    [switch]$NoBrowser
)

$ErrorActionPreference = "Stop"

# -- Paths & Endpoints --------------------------------------------------------
$ROOT         = Split-Path $PSScriptRoot -Parent
$BACKEND_PROJ = "$ROOT\src\QuranPlatform.API\QuranPlatform.API.csproj"
$BACKEND_URL  = "http://localhost:5153"
$ADMIN_URL    = "$BACKEND_URL/admin/"
$SWAGGER_URL  = "$BACKEND_URL/swagger"
$HEALTH_URL   = "$BACKEND_URL/healthz"

# -- Helpers ------------------------------------------------------------------
function Write-Header {
    Clear-Host
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "       Quran Platform - Admin Panel Launcher            " -ForegroundColor Cyan
    Write-Host "========================================================" -ForegroundColor Cyan
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

function Test-BackendReady {
    try {
        $r = Invoke-WebRequest -Uri "$HEALTH_URL" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
        if ($r.StatusCode -lt 500) { return $true }
    } catch {
        try {
            $r2 = Invoke-WebRequest -Uri "$SWAGGER_URL" -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
            if ($r2.StatusCode -lt 500) { return $true }
        } catch { }
    }
    return $false
}

function Wait-ForBackend {
    param([int]$TimeoutSec = 60)
    Write-Step "Waiting for backend to be ready on $BACKEND_URL ..."
    $deadline = (Get-Date).AddSeconds($TimeoutSec)
    while ((Get-Date) -lt $deadline) {
        if (Test-BackendReady) {
            return $true
        }
        Start-Sleep -Milliseconds 800
    }
    return $false
}

# -- 1. Header & Backend Check -----------------------------------------------
Write-Header

Write-Step "Checking backend status on port 5153 ..."
$alreadyRunning = Test-BackendReady

if ($alreadyRunning) {
    Write-Ok "Backend is already running and healthy at $BACKEND_URL"
} else {
    Write-Info "Backend process is not detected on port 5153. Starting .NET backend ..."
    
    # Check for stale listening port without healthy response
    $stale = netstat -ano |
             Select-String ":5153\s.*LISTENING" |
             ForEach-Object { ($_ -split "\s+")[-1] } |
             Select-Object -First 1

    if ($stale) {
        Write-Info "Cleaning up stale process PID $stale on port 5153 ..."
        Stop-Process -Id ([int]$stale) -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
    }

    $backendArgs = "dotnet run --project `"$BACKEND_PROJ`" --urls `"$BACKEND_URL`""
    Start-Process powershell -ArgumentList "-NoExit", "-Command", $backendArgs -WindowStyle Normal

    $ready = Wait-ForBackend -TimeoutSec 60
    if ($ready) {
        Write-Ok "Backend is up and responding at $BACKEND_URL"
    } else {
        Write-Err "Backend did not respond within 60 seconds. Check launched window for errors."
        exit 1
    }
}

Write-Host ""

# -- 2. Display Admin Details -------------------------------------------------
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  Quran Platform Web Admin Panel Ready!                 " -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host "  * Admin Web Dashboard:  " -NoNewline
Write-Host "$ADMIN_URL" -ForegroundColor Cyan
Write-Host "  * OpenAPI / Swagger:    " -NoNewline
Write-Host "$SWAGGER_URL" -ForegroundColor Cyan
Write-Host "  * System Health Probe:  " -NoNewline
Write-Host "$HEALTH_URL" -ForegroundColor Cyan
Write-Host ""

# -- 3. Launch Browser --------------------------------------------------------
if (-not $NoBrowser) {
    Write-Step "Opening Admin Web Dashboard in default browser ..."
    try {
        Start-Process "$ADMIN_URL"
        Write-Ok "Browser launched."
    } catch {
        Write-Err "Could not automatically launch browser. Please open $ADMIN_URL manually."
    }
} else {
    Write-Info "Skipping browser launch (-NoBrowser flag specified)."
}

Write-Host ""

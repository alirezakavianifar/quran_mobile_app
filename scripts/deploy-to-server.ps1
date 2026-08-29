# ==============================================================================
# Quran Platform - Server Deployment Script
# ==============================================================================
# Archives local backend, config, and deployment files, uploads via SCP,
# extracts on the remote server, and executes Docker Compose build & boot.
# ==============================================================================

param (
    [string]$ServerIP = "45.94.215.188",
    [string]$ServerUser = "root",
    [string]$KeyPath = "C:\Users\Administrator\.ssh\id_rsa_deploy"
)

$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

# Root Project Directory
$ProjectRoot = (Get-Item $PSScriptRoot).Parent.FullName

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "Preparing Quran Knowledge Platform Deployment to $ServerIP" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan

function Invoke-ScpWithRetry {
    param (
        [string[]]$Arguments,
        [int]$MaxRetries = 4,
        [int]$DelaySeconds = 2
    )
    for ($i = 1; $i -le $MaxRetries; $i++) {
        & scp $Arguments
        if ($LASTEXITCODE -eq 0) {
            return $true
        }
        if ($i -lt $MaxRetries) {
            Write-Host "    [SCP retry $i/$MaxRetries in ${DelaySeconds}s...]" -ForegroundColor DarkYellow
            Start-Sleep -Seconds $DelaySeconds
        }
    }
    return $false
}

function Invoke-SshWithRetry {
    param (
        [string[]]$Arguments,
        [int]$MaxRetries = 4,
        [int]$DelaySeconds = 2
    )
    for ($i = 1; $i -le $MaxRetries; $i++) {
        & ssh $Arguments
        if ($LASTEXITCODE -eq 0) {
            return $true
        }
        if ($i -lt $MaxRetries) {
            Write-Host "    [SSH retry $i/$MaxRetries in ${DelaySeconds}s...]" -ForegroundColor DarkYellow
            Start-Sleep -Seconds $DelaySeconds
        }
    }
    return $false
}

Set-Location $ProjectRoot

# 1. Create Lightweight Source Archive
Write-Host "Creating lightweight source archive..." -ForegroundColor Yellow
$TempArchiveName = "quran_deploy_$([DateTimeOffset]::UtcNow.ToUnixTimeSeconds()).tar.gz"
$TempArchivePath = Join-Path $ProjectRoot $TempArchiveName

$ExcludeArgs = @(
    "--exclude=*.dll", "--exclude=*.pdb", "--exclude=*.exe", "--exclude=*.apk", "--exclude=*.rar", "--exclude=*.zip",
    "--exclude=*/bin", "--exclude=*/obj", "--exclude=*/dist", "--exclude=*/node_modules", "--exclude=*/TestResults",
    "--exclude=*/.git", "--exclude=bin", "--exclude=obj", "--exclude=dist", "--exclude=node_modules", "--exclude=TestResults", "--exclude=.git",
    "--exclude=src/quran_mobile_app", "--exclude=docs", "--exclude=tests", "--exclude=temp", "--exclude=portfolio"
)

try {
    & tar -czf $TempArchiveName @ExcludeArgs src docker-compose.yml sql .env* 2>$null
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $TempArchivePath)) {
        & tar -czf $TempArchiveName @ExcludeArgs src docker-compose.yml sql
    }
    if (-not (Test-Path $TempArchivePath)) {
        throw "Failed to create source archive."
    }
    $ArchiveSizeKB = [math]::Round((Get-Item $TempArchivePath).Length / 1KB, 2)
    Write-Host "  [OK] Source archive created ($ArchiveSizeKB KB)." -ForegroundColor Green

    # 2. Upload & Extract Archive on Remote Server
    Write-Host "Uploading source archive to server ($ServerIP)..." -ForegroundColor Yellow
    $ScpArgs = @(
        "-i", $KeyPath,
        "-o", "StrictHostKeyChecking=no",
        "-o", "IPQoS=none",
        "-o", "ServerAliveInterval=5",
        "-o", "ServerAliveCountMax=10",
        "-o", "TCPKeepAlive=yes",
        "-o", "Compression=yes",
        "-o", "ConnectTimeout=30",
        $TempArchiveName,
        "${ServerUser}@${ServerIP}:/tmp/$TempArchiveName"
    )
    $uploadOk = Invoke-ScpWithRetry -Arguments $ScpArgs
    if (-not $uploadOk) {
        throw "SCP transfer of source archive failed after retries."
    }

    Write-Host "Extracting source archive on remote server..." -ForegroundColor Yellow
    $ExtractCmd = "mkdir -p /opt/quran-platform && tar -xzf /tmp/$TempArchiveName -C /opt/quran-platform && rm -f /tmp/$TempArchiveName"
    $SshArgs = @(
        "-n",
        "-T",
        "-i", $KeyPath,
        "-o", "StrictHostKeyChecking=no",
        "-o", "IPQoS=none",
        "-o", "ServerAliveInterval=5",
        "-o", "ServerAliveCountMax=10",
        "-o", "TCPKeepAlive=yes",
        "-o", "ConnectTimeout=30",
        "${ServerUser}@${ServerIP}",
        $ExtractCmd
    )
    $extractOk = Invoke-SshWithRetry -Arguments $SshArgs
    if (-not $extractOk) {
        throw "Remote archive extraction failed after retries."
    }
    Write-Host "  [OK] Remote archive extracted into /opt/quran-platform." -ForegroundColor Green

    # 3. Build & Run Docker Containers
    Write-Host "Building & launching Docker Compose services..." -ForegroundColor Yellow
    $DockerCmd = "cd /opt/quran-platform && docker compose -f docker-compose.yml up -d --build"
    $DockerArgs = @(
        "-n",
        "-T",
        "-i", $KeyPath,
        "-o", "StrictHostKeyChecking=no",
        "-o", "ConnectTimeout=60",
        "${ServerUser}@${ServerIP}",
        $DockerCmd
    )
    & ssh $DockerArgs

    # 4. Verify Health Probes
    Write-Host "Verifying service health probes..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    $HealthCmd = "curl -s -o /dev/null -w '%{http_code}' http://localhost:5000/healthz || curl -s -o /dev/null -w '%{http_code}' http://localhost:5000/api/v1/quran/surahs || true"
    $HealthArgs = @(
        "-n",
        "-T",
        "-i", $KeyPath,
        "-o", "StrictHostKeyChecking=no",
        "-o", "ConnectTimeout=15",
        "${ServerUser}@${ServerIP}",
        $HealthCmd
    )
    $statusCode = (& ssh $HealthArgs).Trim()
    Write-Host "  [OK] Health probe response status: $statusCode" -ForegroundColor Green

    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Green
    Write-Host "  Quran Platform deployed successfully! 🎉" -ForegroundColor Green
    Write-Host "======================================================================" -ForegroundColor Green
}
catch {
    Write-Host "  [ERROR] Deployment encountered a failure: $_" -ForegroundColor Red
}
finally {
    if (Test-Path $TempArchivePath) {
        Remove-Item -Path $TempArchivePath -Force -ErrorAction SilentlyContinue
    }
}

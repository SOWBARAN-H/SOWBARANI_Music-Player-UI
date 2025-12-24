param(
    [string]$Message,
    [string]$Remote = "origin",
    [string]$Branch,
    [string]$TargetHost = "github.com",
    [int]$Port = 443,
    [switch]$NoProxyUnset,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Write-Info($msg) { Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Warn($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Ok($msg)   { Write-Host "[ OK ] $msg" -ForegroundColor Green }
function Write-Fail($msg) { Write-Host "[FAIL] $msg" -ForegroundColor Red }

try {
    Write-Info "Testing connectivity to $($TargetHost):$Port"
    $conn = Test-NetConnection $TargetHost -Port $Port
    if (-not $conn.TcpTestSucceeded) { throw "Cannot reach $TargetHost on port $Port" }
    Write-Ok "Network/TLS reachable"

    Write-Info "Resolving DNS for $TargetHost"
    try { $dns = Resolve-DnsName $TargetHost -ErrorAction Stop } catch { $dns = $null }
    if (-not $dns) { throw "DNS resolution failed for $TargetHost" }
    Write-Ok ("DNS resolved: " + ($dns | Where-Object {$_.QueryType -eq 'A'} | Select-Object -First 1 -ExpandProperty IP4Address))

    Write-Info "Checking Git proxy settings"
    $gitHttpProxy = (git config --get http.proxy 2>$null)
    $gitHttpsProxy = (git config --get https.proxy 2>$null)
    $envHttp = $env:HTTP_PROXY
    $envHttps = $env:HTTPS_PROXY
    $envAll = $env:ALL_PROXY

    if ($gitHttpProxy -or $gitHttpsProxy -or $envHttp -or $envHttps -or $envAll) {
        Write-Warn "Proxy detected. Git: http=$gitHttpProxy https=$gitHttpsProxy; Env present=$([bool]($envHttp -or $envHttps -or $envAll))"
        if (-not $NoProxyUnset) {
            Write-Info "Unsetting Git proxy (global and local)"
            git config --global --unset http.proxy 2>$null
            git config --global --unset https.proxy 2>$null
            git config --unset http.proxy 2>$null
            git config --unset https.proxy 2>$null
            Write-Ok "Cleared Git proxies"
        } else {
            Write-Warn "Skipping proxy unset due to -NoProxyUnset"
        }
    } else {
        Write-Ok "No proxy settings detected"
    }

    Write-Info "Determining current branch"
    $currentBranch = if ($Branch) { $Branch } else { (git rev-parse --abbrev-ref HEAD).Trim() }
    if (-not $currentBranch) { throw "Unable to determine current branch" }
    Write-Ok "Branch: $currentBranch"

    Write-Info "Checking working tree status"
    $status = git status --porcelain
    if ($status) {
        if ($Message) {
            Write-Info "Staging and committing changes"
            git add -A
            git commit -m $Message | Out-Null
            Write-Ok "Committed changes"
        } else {
            Write-Warn "Uncommitted changes present. Provide -Message 'your commit' to auto-commit, or commit manually before pushing."
        }
    } else {
        Write-Ok "Working tree clean"
    }

    Write-Info "Checking upstream tracking"
    $hasUpstream = $true
    try { git rev-parse --abbrev-ref --symbolic-full-name '@{u}' | Out-Null } catch { $hasUpstream = $false }

    $pushArgs = @()
    if ($DryRun) { $pushArgs += "--dry-run" }

    if ($hasUpstream) {
        Write-Info "Pushing to tracking upstream"
        git push @pushArgs
    } else {
        Write-Info "Setting upstream to $Remote/$currentBranch and pushing"
        git push -u $Remote $currentBranch @pushArgs
    }

    if ($DryRun) {
        Write-Ok "Dry-run completed. No changes pushed."
    } else {
        Write-Ok "Push completed successfully."
    }
}
catch {
    Write-Fail $_
    exit 1
}
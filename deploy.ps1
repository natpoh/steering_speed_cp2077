param(
  [string]$Game,
  [switch]$Clean
)

$ErrorActionPreference = "Stop"

$repoRoot = $PSScriptRoot
if (-not $repoRoot) { $repoRoot = (Get-Location).Path }
Set-Location $repoRoot

function Info($msg)    { Write-Host "[deploy] $msg" -ForegroundColor Cyan }
function Ok($msg)      { Write-Host "[deploy] $msg" -ForegroundColor Green }
function Warn($msg)    { Write-Host "[deploy] WARN: $msg" -ForegroundColor Yellow }
function Fail($msg)    {
  Write-Host "[deploy] ERROR: $msg" -ForegroundColor Red
  exit 1
}

$version = "1.0.0"

$redsFiles = @(
  "steering_speed_reds\steering_speed_logic.reds",
  "steering_speed_reds\steering_speed_settings.reds"
)

if ($Game) {
  $scriptDir = Join-Path $Game "r6\scripts\steering_speed"

  if ($Clean) {
    if (Test-Path $scriptDir) { Remove-Item -Recurse -Force $scriptDir }
  }

  New-Item -ItemType Directory -Force -Path $scriptDir | Out-Null

  foreach ($r in $redsFiles) {
    $dest = Join-Path $scriptDir (Split-Path $r -Leaf)
    Copy-Item -Force $r $dest
    Info "Deployed reds -> $dest"
  }
  
  Ok "Deploy to Game complete."
  exit 0
}

# Zip mode
$stagingDir = Join-Path $repoRoot "staging"
$distDir    = Join-Path $repoRoot "dist"
$zipPath    = Join-Path $distDir "steering_speed-$version.zip"

if (Test-Path $stagingDir) { Remove-Item -Recurse -Force $stagingDir }
New-Item -ItemType Directory -Force -Path $stagingDir | Out-Null
New-Item -ItemType Directory -Force -Path $distDir    | Out-Null

New-Item -ItemType Directory -Force -Path (Join-Path $stagingDir "r6\scripts\steering_speed") | Out-Null

foreach ($r in $redsFiles) {
  Copy-Item -Force $r (Join-Path $stagingDir (Split-Path $r -Leaf | ForEach-Object { "r6\scripts\steering_speed\$_" }))
}

if (Test-Path $zipPath) { Remove-Item -Force $zipPath }
Compress-Archive -Path (Join-Path $stagingDir "*") -DestinationPath $zipPath -Force

Ok "Package ready: $zipPath"

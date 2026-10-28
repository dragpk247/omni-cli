<#
.SYNOPSIS
    OMNI CLI Native Windows Installer for PowerShell
.DESCRIPTION
    Installs the OMNI PowerShell module and configures the `omni` command.
#>

$ErrorActionPreference = "Stop"

Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host " 🌐 OMNI CLI — Windows PowerShell Installer" -ForegroundColor White
Write-Host "===========================================================" -ForegroundColor Cyan

$ModulePath = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "PowerShell\Modules\Omni"
if (-not (Test-Path $ModulePath)) {
    New-Item -ItemType Directory -Path $ModulePath -Force | Out-Null
}

$RepoUrl = "https://raw.githubusercontent.com/dragpk247/omni-cli/main"
$ModuleFile = Join-Path $ModulePath "Omni.psm1"

Write-Host "[*] Downloading Omni PowerShell module..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "$RepoUrl/windows/Omni.psm1" -OutFile $ModuleFile

# Config setup
$ConfigDir = Join-Path $env:USERPROFILE ".config\omni"
if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

$ConfigFile = Join-Path $ConfigDir "config.env"
if (-not (Test-Path $ConfigFile)) {
    Write-Host "[*] Creating default config at $ConfigFile..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri "$RepoUrl/config.env.example" -OutFile $ConfigFile
}

# Add Import-Module to profile if not present
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$ProfileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if (-not $ProfileContent -or -not ($ProfileContent -match "Import-Module\s+Omni")) {
    Add-Content -Path $PROFILE -Value "`n# OMNI CLI Multi-Device Hub`nImport-Module Omni`n"
    Write-Host "[✓] Added 'Import-Module Omni' to PowerShell Profile ($PROFILE)" -ForegroundColor Green
}

Write-Host ""
Write-Host "[✓] Installation complete! Restart PowerShell or run: Import-Module Omni" -ForegroundColor Green
Write-Host "    Type 'omni' to launch the dashboard." -ForegroundColor White

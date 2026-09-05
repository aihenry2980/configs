#requires -version 5.1
<#
Win11 Dev Setup
Installs the latest available versions via WinGet.

Included:
- Everything
- Git for Windows
- TortoiseGit
- TreeSize Free
- Dropbox
- VS Code
- Notepad++
- Zed
- Sublime Text
- VSCodium
- Chrome
- Firefox
- Vivaldi
- 7-Zip
- Python Install Manager + latest stable Python runtime
- CMake
- Fork
- Android Studio

Visual Studio is intentionally NOT included.
#>

$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

# ------------------------------------------------------------
# Self-elevate
# ------------------------------------------------------------
$principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Administrator permission is required. Opening UAC..." -ForegroundColor Yellow

    $args = @(
        "-NoProfile"
        "-ExecutionPolicy", "Bypass"
        "-File", "`"$PSCommandPath`""
    )

    Start-Process powershell.exe -Verb RunAs -ArgumentList $args
    exit
}

# ------------------------------------------------------------
# Paths / log
# ------------------------------------------------------------
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogFile = Join-Path $ScriptDir ("Install-Log-{0}.txt" -f (Get-Date -Format "yyyyMMdd-HHmmss"))

Start-Transcript -Path $LogFile -Force | Out-Null

function Write-Section {
    param([string]$Text)
    Write-Host ""
    Write-Host ("=" * 64) -ForegroundColor Cyan
    Write-Host " $Text" -ForegroundColor Cyan
    Write-Host ("=" * 64) -ForegroundColor Cyan
}

function Refresh-Path {
    $machine = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $user = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machine;$user"
}

function Install-WingetApp {
    param(
        [Parameter(Mandatory=$true)][string]$Id,
        [Parameter(Mandatory=$true)][string]$Name
    )

    Write-Host ""
    Write-Host ">>> $Name" -ForegroundColor White
    Write-Host "    $Id" -ForegroundColor DarkGray

    & winget install `
        --id $Id `
        --exact `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements `
        --disable-interactivity

    $code = $LASTEXITCODE

    if ($code -eq 0) {
        Write-Host "[OK] $Name" -ForegroundColor Green
        return $true
    }
    elseif ($code -eq -1978335189 -or $code -eq 2316632107) {
        # WinGet commonly returns "already installed/no applicable update"
        Write-Host "[OK] $Name is already installed / no newer version available." -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "[WARNING] $Name returned WinGet exit code: $code" -ForegroundColor Yellow
        Write-Host "          Continuing with the remaining apps." -ForegroundColor Yellow
        return $false
    }
}

Write-Section "Windows 11 Development PC Setup"

# ------------------------------------------------------------
# Basic checks
# ------------------------------------------------------------
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "WinGet was not found." -ForegroundColor Red
    Write-Host "Update/install 'App Installer' from Microsoft Store, then run this script again."
    Stop-Transcript | Out-Null
    Read-Host "Press ENTER to exit"
    exit 1
}

$systemDrive = $env:SystemDrive.TrimEnd(":")
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$($env:SystemDrive)'"
if ($disk) {
    $freeGB = [math]::Round($disk.FreeSpace / 1GB, 1)
    Write-Host "Free space on $($env:SystemDrive): $freeGB GB"

    if ($freeGB -lt 40) {
        Write-Host "WARNING: Less than 40 GB is free. Android SDKs and caches may need more room." -ForegroundColor Yellow
    }
}

Write-Host "Log file: $LogFile"

Write-Section "Updating WinGet sources"
winget source update

# ------------------------------------------------------------
# Main app list
# ------------------------------------------------------------
$Apps = @(
    # Utilities
    @{ Id = "voidtools.Everything";          Name = "Everything" }
    @{ Id = "JAMSoftware.TreeSize.Free";     Name = "TreeSize Free" }
    @{ Id = "7zip.7zip";                     Name = "7-Zip" }

    # Git
    @{ Id = "Git.Git";                       Name = "Git for Windows" }
    @{ Id = "TortoiseGit.TortoiseGit";       Name = "TortoiseGit" }
    @{ Id = "Fork.Fork";                     Name = "Fork" }

    # Cloud
    @{ Id = "Dropbox.Dropbox";               Name = "Dropbox" }

    # Editors
    @{ Id = "Microsoft.VisualStudioCode";     Name = "Visual Studio Code" }
    @{ Id = "Notepad++.Notepad++";           Name = "Notepad++" }
    @{ Id = "ZedIndustries.Zed";             Name = "Zed" }
    @{ Id = "SublimeHQ.SublimeText.4";       Name = "Sublime Text" }
    @{ Id = "VSCodium.VSCodium";             Name = "VSCodium" }

    # Browsers
    @{ Id = "Google.Chrome";                  Name = "Google Chrome" }
    @{ Id = "Mozilla.Firefox";                Name = "Mozilla Firefox" }
    @{ Id = "Vivaldi.Vivaldi";               Name = "Vivaldi" }

    # Development
    @{ Id = "Kitware.CMake";                  Name = "CMake" }
    @{ Id = "Google.AndroidStudio";           Name = "Android Studio" }
)

$success = 0
$failed = @()

foreach ($app in $Apps) {
    if (Install-WingetApp -Id $app.Id -Name $app.Name) {
        $success++
    } else {
        $failed += $app.Name
    }
}

# ------------------------------------------------------------
# Python Install Manager
# ------------------------------------------------------------
Write-Section "Python"

$pythonManagerOK = Install-WingetApp `
    -Id "Python.PythonInstallManager" `
    -Name "Python Install Manager"

Refresh-Path

if ($pythonManagerOK) {
    # Prefer pymanager in automation because it avoids conflicts
    # with the legacy Python launcher.
    $pm = Get-Command pymanager -ErrorAction SilentlyContinue

    if (-not $pm) {
        # Known location for the MSIX command aliases.
        $candidate = Join-Path $env:LOCALAPPDATA `
            "Microsoft\WindowsApps\PythonSoftwareFoundation.PythonManager_3847v3x7pw1km\pymanager.exe"
        if (Test-Path $candidate) {
            $pm = $candidate
        }
    } else {
        $pm = $pm.Source
    }

    if ($pm) {
        Write-Host ""
        Write-Host "Installing latest stable Python runtime..." -ForegroundColor White
        & $pm install default
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Latest stable Python runtime installed." -ForegroundColor Green
        } else {
            Write-Host "[WARNING] Python Manager installed, but runtime installation returned code $LASTEXITCODE." -ForegroundColor Yellow
            Write-Host "          After reboot/opening a new terminal, run: py install default"
        }
    } else {
        Write-Host "[INFO] Python Install Manager was installed." -ForegroundColor Yellow
        Write-Host "       Open a new terminal after this setup and run: py install default"
    }
}

# ------------------------------------------------------------
# Finish
# ------------------------------------------------------------
Write-Section "Setup finished"

Write-Host "Apps completed successfully: $success / $($Apps.Count)" -ForegroundColor Green

if ($failed.Count -gt 0) {
    Write-Host ""
    Write-Host "Apps that may need manual retry:" -ForegroundColor Yellow
    foreach ($name in $failed) {
        Write-Host " - $name" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Important after installation:" -ForegroundColor White
Write-Host "1. Reboot Windows once."
Write-Host "2. Sign in to Dropbox, but use Selective Sync / Online-only if disk space is limited."
Write-Host "3. Launch Android Studio once and install the Android SDK + Platform Tools."
Write-Host "4. If you debug on a real Galaxy phone, you can skip Android Emulator system images."
Write-Host "5. If Python was not installed automatically, open a new terminal and run:"
Write-Host "      py install default"
Write-Host ""
Write-Host "Full log: $LogFile"

Stop-Transcript | Out-Null

Read-Host "Press ENTER to close"

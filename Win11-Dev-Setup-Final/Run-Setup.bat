@echo off
setlocal
cd /d "%~dp0"

echo ================================================
echo   Windows 11 Development PC Setup
echo ================================================
echo.
echo PowerShell will request Administrator permission.
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-All.ps1"

if errorlevel 1 (
    echo.
    echo The setup script returned an error.
    pause
)

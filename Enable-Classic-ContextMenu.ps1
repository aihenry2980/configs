# Windows 11 -> Windows 10 Classic Context Menu

$Key = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"

Write-Host "Enabling Windows 10-style context menu..." -ForegroundColor Cyan

New-Item -Path $Key -Force | Out-Null
Set-ItemProperty -Path $Key -Name "(default)" -Value ""

Write-Host "Restarting Windows Explorer..." -ForegroundColor Yellow

Stop-Process -Name explorer -Force
Start-Process explorer.exe

Write-Host ""
Write-Host "Done. Classic context menu is enabled." -ForegroundColor Green
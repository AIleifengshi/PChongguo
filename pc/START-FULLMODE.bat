@echo off
chcp 65001 >nul
title PChongguo - Full Series Mode
setlocal
pushd "%~dp0"

echo.
echo   PChongguo - Full Series Mode
echo   Starting the optional third-party engine...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$d=Join-Path (Get-Location) 'engine'; $e=Get-ChildItem -LiteralPath $d -Filter '*.exe' -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne 'ffmpeg.exe' -and $_.Name -ne 'MicrosoftEdgeWebview2Setup.exe' } | Sort-Object Length -Descending | Select-Object -First 1; if(-not $e){ Write-Host '  Engine not installed. Run INSTALL-ENGINE.bat first.'; exit 1 }; Write-Host ('  Starting: '+$e.Name); Start-Process -FilePath $e.FullName -WorkingDirectory $d; exit 0"
if errorlevel 1 (
  echo.
  echo   Could not start. See fullmode.html for the manual steps.
  echo.
  pause
  popd
  exit /b 1
)

echo.
echo   Engine started. This window will close in 3 seconds.
echo   Keep PChongguo for channels, your own promo QR and the guide.
ping -n 4 127.0.0.1 >nul
popd

@echo off
chcp 65001 >nul
title PChongguo - Install Full Series Engine
setlocal
pushd "%~dp0"

echo.
echo  ============================================================
echo   PChongguo - Full Series Engine (optional component)
echo  ============================================================
echo   Source : github.com/yangbin1322/hongguo-player  v1.2.25
echo   This is a THIRD-PARTY free program. It is NOT bundled with
echo   PChongguo; you download it from the author's GitHub Release
echo   into the "engine" subfolder of this PChongguo folder.
echo   No system settings / antivirus settings are changed.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$e=Get-ChildItem -LiteralPath '.\engine' -Filter '*.exe' -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne 'ffmpeg.exe' -and $_.Name -ne 'MicrosoftEdgeWebview2Setup.exe' } | Select-Object -First 1; if($e){exit 0}else{exit 1}"
if not errorlevel 1 (
  echo   Engine already installed - nothing to download.
  goto :done
)

echo   Downloading... about 17 MB, please wait.
powershell -NoProfile -ExecutionPolicy Bypass -Command "$zip=Join-Path (Get-Location) 'engine-download.zip'; $urls=@('https://github.com/yangbin1322/hongguo-player/releases/download/v1.2.25/hongguo-v1.2.25-windows-amd64.zip','https://api.github.com/repos/yangbin1322/hongguo-player/releases/assets/721020866'); $ok=$false; foreach($u in $urls){ try { $h=@{'User-Agent'='PChongguo'}; if($u -like '*api.github.com*'){$h['Accept']='application/octet-stream'}; Invoke-WebRequest -Uri $u -OutFile $zip -UseBasicParsing -TimeoutSec 180 -Headers $h; if((Get-Item $zip).Length -gt 1000000){$ok=$true;break} } catch { Write-Host ('  download attempt failed: '+$_.Exception.Message) } }; if($ok){exit 0}else{exit 1}"
if errorlevel 1 goto :fail

echo   Extracting (UTF-8 aware, keeps Chinese filenames)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$z=Join-Path (Get-Location) 'engine-download.zip'; $d=Join-Path (Get-Location) 'engine'; $ok=$false; try { Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory($z,$d,[System.Text.Encoding]::UTF8); $ok=$true } catch { Write-Host ('  utf8 extract unavailable: '+$_.Exception.Message) }; if(-not $ok){ try { Expand-Archive -LiteralPath $z -DestinationPath $d -Force; $ok=$true } catch { Write-Host ('  extract failed: '+$_.Exception.Message) } }; if($ok){exit 0}else{exit 1}"
if errorlevel 1 goto :fail
del "engine-download.zip" >nul 2>&1

echo.
echo   DONE. Run START-FULLMODE.bat (or the desktop icon) to watch.
goto :done

:fail
echo.
echo   Automatic download failed. Do it manually:
echo     1) open  https://github.com/yangbin1322/hongguo-player/releases/latest
echo     2) download the Windows -amd64.zip
echo     3) extract ALL files into the "engine" folder next to this script
echo.

:done
echo.
pause
popd

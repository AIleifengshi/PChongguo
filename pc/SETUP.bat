@echo off
chcp 65001 >nul
title PChongguo Setup
setlocal
set "APPDIR=%~dp0"
set "LNK=%USERPROFILE%\Desktop\PChongguo.lnk"
set "LNK2=%USERPROFILE%\Desktop\PChongguo-Full.lnk"
set "LNK3=%USERPROFILE%\Desktop\PChongguo-FullSeries.lnk"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%LNK%'); $s.TargetPath='%WINDIR%\System32\wscript.exe'; $s.Arguments='\"%APPDIR%PChongguo.vbs\"'; $s.WorkingDirectory='%APPDIR%'; $s.IconLocation='%APPDIR%PChongguo.ico,0'; $s.Description='PChongguo'; $s.Save()"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%LNK2%'); $s.TargetPath='%APPDIR%channels.html'; $s.WorkingDirectory='%APPDIR%'; $s.IconLocation='%APPDIR%PChongguo.ico,0'; $s.Description='PChongguo Channels'; $s.Save()"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%LNK3%'); $s.TargetPath='%APPDIR%START-FULLMODE.bat'; $s.WorkingDirectory='%APPDIR%'; $s.IconLocation='%APPDIR%PChongguo.ico,0'; $s.Description='PChongguo Full Series Mode'; $s.Save()"
echo.
echo   PChongguo is ready - three shortcuts created on your Desktop.
echo   PChongguo            : drama wall on PC
echo   PChongguo-Full       : channels + free full series guide
echo   PChongguo-FullSeries : optional full-series engine (run INSTALL-ENGINE.bat first)
echo.
pause

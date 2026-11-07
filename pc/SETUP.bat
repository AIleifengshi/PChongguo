@echo off
chcp 65001 >nul
title PChongguo Setup
setlocal
set "APPDIR=%~dp0"
set "LNK=%USERPROFILE%\Desktop\PChongguo.lnk"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%LNK%'); $s.TargetPath='%WINDIR%\System32\wscript.exe'; $s.Arguments='\"%APPDIR%PChongguo.vbs\"'; $s.WorkingDirectory='%APPDIR%'; $s.IconLocation='%APPDIR%PChongguo.ico,0'; $s.Description='PChongguo'; $s.Save()"
echo.
echo   PChongguo is ready - shortcut created on your Desktop.
echo   Double-click it to start watching.
echo.
pause

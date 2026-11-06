@echo off
set "BASE=%~dp0"
set "EXT=%BASE%launcher_extension"
set "PROFILE=%BASE%profiles\acc3"

if not exist "%EXT%" mkdir "%EXT%"
if not exist "%PROFILE%" mkdir "%PROFILE%"

if exist "%BASE%tutien2d-helper.user.js" (
    copy /y "%BASE%tutien2d-helper.user.js" "%EXT%\tutien2d-helper.user.js" >nul
)

set "EDGE="
if exist "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" set "EDGE=C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if exist "C:\Program Files\Microsoft\Edge\Application\msedge.exe" set "EDGE=C:\Program Files\Microsoft\Edge\Application\msedge.exe"

start "" "%EDGE%" --app="https://tutien2d.com" --user-data-dir="%PROFILE%" --load-extension="%EXT%" --no-first-run --no-default-browser-check --disable-background-networking --disable-component-update --disable-domain-reliability --disable-sync --enable-gpu-rasterization --ignore-gpu-blocklist --window-size=1280,760

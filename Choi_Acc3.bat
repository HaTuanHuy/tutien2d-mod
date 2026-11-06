@echo off
setlocal
set "BASE=%~dp0"
set "EXT=%BASE%launcher_extension"
set "PROFILE=%BASE%profiles\profile_acc_3"

if not exist "%PROFILE%" mkdir "%PROFILE%"
if not exist "%EXT%" mkdir "%EXT%"

REM 1. Đảm bảo manifest.json luôn tồn tại
if not exist "%EXT%\manifest.json" (
    (
        echo {
        echo   "manifest_version": 3,
        echo   "name": "Tu Tien 2D Helper",
        echo   "version": "1.0",
        echo   "content_scripts": [
        echo     {
        echo       "matches": ["https://tutien2d.com/*", "https://www.tutien2d.com/*"],
        echo       "js": ["tutien2d-helper.user.js"],
        echo       "run_at": "document_start",
        echo       "world": "MAIN"
        echo     }
        echo   ]
        echo }
    ) > "%EXT%\manifest.json"
)

REM 2. Đồng bộ mod (nếu chưa có thì tự động kéo từ GitHub)
if exist "%BASE%tutien2d-helper.user.js" (
    copy /y "%BASE%tutien2d-helper.user.js" "%EXT%\tutien2d-helper.user.js" >nul
) else (
    if not exist "%EXT%\tutien2d-helper.user.js" (
        echo Dang tai ban Mod moi nhat tu GitHub...
        curl.exe -sL "https://raw.githubusercontent.com/HaTuanHuy/tutien2d-mod/main/tutien2d-helper.user.js" -o "%EXT%\tutien2d-helper.user.js"
        copy /y "%EXT%\tutien2d-helper.user.js" "%BASE%tutien2d-helper.user.js" >nul
    )
)

REM 3. Tìm đường dẫn Microsoft Edge có sẵn trên Windows
set "EDGE="
if exist "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" set "EDGE=C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if exist "C:\Program Files\Microsoft\Edge\Application\msedge.exe" set "EDGE=C:\Program Files\Microsoft\Edge\Application\msedge.exe"

REM 4. Khởi động Tài khoản 3 ở chế độ siêu nhẹ độc lập
start "" "%EDGE%" --app="https://tutien2d.com" --user-data-dir="%PROFILE%" --load-extension="%EXT%" --no-first-run --no-default-browser-check --disable-background-networking --disable-component-update --disable-domain-reliability --disable-sync --enable-gpu-rasterization --ignore-gpu-blocklist --window-size=1280,760

@echo off
title Tu Tien 2D Launcher
start "" javaw -jar "%~dp0TuTien2D.jar"
if %errorlevel% neq 0 (
    echo Khong tim thay lenh javaw, dang thu chay bang java...
    java -jar "%~dp0TuTien2D.jar"
    if %errorlevel% neq 0 (
        echo.
        echo [LOI] May tinh cua ban chua cai Java hoac chua them Java vao PATH!
        echo Vui long cai dat Java JRE tu: https://www.java.com
        pause
    )
)


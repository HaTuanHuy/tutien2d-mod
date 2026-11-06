@echo off
title Tu Tien 2D - Da Tai Khoan
chcp 65001 >nul
cls
echo =======================================================
echo          TU TIEN 2D ONLINE - DA TAI KHOAN
echo =======================================================
echo  [1] Vào Game - TÀI KHOẢN 1 (Chính)
echo  [2] Vào Game - TÀI KHOẢN 2 (Phụ)
echo  [3] Vào Game - TÀI KHOẢN 3
echo  [4] Mở Bảng điều khiển Giao diện (Dark Mode GUI)
echo  [5] Cập nhật Mod mới nhất từ GitHub
echo =======================================================
set /p choice="Nhập số tài khoản muốn mở (1, 2, 3) [Mặc định 1]: "

if "%choice%"=="" set choice=1
if "%choice%"=="1" (
    call "%~dp0Choi_Acc1.bat"
    exit
)
if "%choice%"=="2" (
    call "%~dp0Choi_Acc2.bat"
    exit
)
if "%choice%"=="3" (
    call "%~dp0Choi_Acc3.bat"
    exit
)
if "%choice%"=="4" (
    start "" powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0Launcher.ps1"
    exit
)
if "%choice%"=="5" (
    echo Đang kiểm tra cập nhật từ GitHub...
    powershell -ExecutionPolicy Bypass -Command "$client = New-Object System.Net.WebClient; $content = $client.DownloadString('https://raw.githubusercontent.com/HaTuanHuy/tutien2d-mod/main/tutien2d-helper.user.js'); [IO.File]::WriteAllText('%~dp0tutien2d-helper.user.js', $content, [Text.Encoding]::UTF8); echo 'Da cap nhat thanh cong!'"
    pause
    exit
)

call "%~dp0Choi_Acc1.bat"
exit

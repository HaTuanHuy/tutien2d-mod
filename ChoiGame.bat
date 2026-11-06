@echo off
setlocal
set "BASE=%~dp0"
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
    call "%BASE%Choi_Acc1.bat"
    exit
)
if "%choice%"=="2" (
    call "%BASE%Choi_Acc2.bat"
    exit
)
if "%choice%"=="3" (
    call "%BASE%Choi_Acc3.bat"
    exit
)
if "%choice%"=="4" (
    start "" powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%BASE%Launcher.ps1"
    exit
)
if "%choice%"=="5" (
    echo Đang kiểm tra cập nhật từ GitHub...
    curl.exe -sL "https://raw.githubusercontent.com/HaTuanHuy/tutien2d-mod/main/tutien2d-helper.user.js" -o "%BASE%tutien2d-helper.user.js"
    echo Đã cập nhật bản Mod mới nhất thành công!
    pause
    exit
)

call "%BASE%Choi_Acc1.bat"
exit

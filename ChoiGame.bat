@echo off
set "BASE=%~dp0"
title Tu Tien 2D - Da Tai Khoan
cls
echo =======================================================
echo          TU TIEN 2D ONLINE - DA TAI KHOAN
echo =======================================================
echo  [1] Vao Game - TAI KHOAN 1 (Chinh)
echo  [2] Vao Game - TAI KHOAN 2 (Phu)
echo  [3] Vao Game - TAI KHOAN 3
echo  [4] Cap nhat Mod moi nhat tu GitHub
echo  [5] Tao phim tat ra man hinh Desktop
echo =======================================================
set /p choice="Nhap lua chon (1-5, mac dinh 1): "

if "%choice%"=="" set choice=1
if "%choice%"=="1" (
    start "" "%BASE%Choi_Acc1.bat"
    exit
)
if "%choice%"=="2" (
    start "" "%BASE%Choi_Acc2.bat"
    exit
)
if "%choice%"=="3" (
    start "" "%BASE%Choi_Acc3.bat"
    exit
)
if "%choice%"=="4" (
    echo Dang tai ban Mod moi nhat tu GitHub...
    curl.exe -sL "https://raw.githubusercontent.com/HaTuanHuy/tutien2d-mod/main/tutien2d-helper.user.js" -o "%BASE%tutien2d-helper.user.js"
    copy /y "%BASE%tutien2d-helper.user.js" "%BASE%launcher_extension\tutien2d-helper.user.js" >nul
    echo Da cap nhat thanh cong!
    pause
    exit
)
if "%choice%"=="5" (
    call "%BASE%Tao_Phim_Tat_Desktop.bat"
    pause
    exit
)

start "" "%BASE%Choi_Acc1.bat"
exit

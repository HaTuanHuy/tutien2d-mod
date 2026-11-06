@echo off
set "BASE=%~dp0"
echo Dang tao phim tat ra Desktop...
powershell -Command "$ws = New-Object -ComObject WScript.Shell; $d = [Environment]::GetFolderPath('Desktop'); $s1 = $ws.CreateShortcut(\"$d\Tu Tien 2D - Acc 1.lnk\"); $s1.TargetPath = '%BASE%Choi_Acc1.bat'; $s1.WorkingDirectory = '%BASE%'; $s1.Save(); $s2 = $ws.CreateShortcut(\"$d\Tu Tien 2D - Acc 2.lnk\"); $s2.TargetPath = '%BASE%Choi_Acc2.bat'; $s2.WorkingDirectory = '%BASE%'; $s2.Save(); echo 'Da tao thanh cong 2 phim tat ra Desktop!'"

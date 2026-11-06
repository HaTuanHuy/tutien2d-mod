$c = [System.IO.File]::ReadAllText('D:\Tutien2d\tutien2d.com\src\ui\van_tieu.f3dff09e3cd8.js')
Write-Output $c.Substring(0, [Math]::Min(2000, $c.Length))


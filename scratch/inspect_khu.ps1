$c = [System.IO.File]::ReadAllText('D:\Tutien2d\tutien2d.com\src\ui\khu.9b8ccd7f4346.js')
Write-Output $c.Substring(0, [Math]::Min(1500, $c.Length))


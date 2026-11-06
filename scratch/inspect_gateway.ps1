$c = [System.IO.File]::ReadAllText('D:\Tutien2d\tutien2d.com\src\net\gateway.9b66608f1070.js')
Write-Output $c.Substring(32400, 500)

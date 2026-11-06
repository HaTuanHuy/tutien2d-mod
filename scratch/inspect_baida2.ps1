$c = [System.IO.File]::ReadAllText('D:\Tutien2d\tutien2d.com\src\world\map_three_maps.3fbb466c6c1e.js')
$idx = $c.IndexOf('BAI_DA_HANG_GIO')
Write-Output $c.Substring($idx, 2000)


$c = [System.IO.File]::ReadAllText('d:\Tutien2d\Tutien2d.com\tutien2d-helper.user.js')
$idx = $c.IndexOf("hạ người kéo ")
$len = [Math]::Min(1500, $c.Length - $idx)
Write-Output $c.Substring($idx, $len)


$c = [System.IO.File]::ReadAllText('d:\Tutien2d\tutien2d.com\tutien2d-helper.user.js')
$idx = $c.IndexOf("a.step = 'cướp ' + hn")
$start = [Math]::Max(0, $idx - 500)
$len = [Math]::Min(1500, $c.Length - $start)
Write-Output $c.Substring($start, $len)


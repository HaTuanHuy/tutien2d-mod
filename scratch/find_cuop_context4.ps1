$c = [System.IO.File]::ReadAllText('d:\Tutien2d\Tutien2d.com\tutien2d-helper.user.js')
$idx = $c.IndexOf("if (rivals.length) {")
$len = [Math]::Min(1000, $c.Length - $idx)
Write-Output $c.Substring($idx, $len)


$c = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\net\gateway.9b66608f1070.js", [System.Text.Encoding]::UTF8)
$pos = $c.IndexOf(".cmd=")
if ($pos -ne -1) {
    $start = [Math]::Max(0, $pos - 50)
    $len = [Math]::Min(600, $c.Length - $start)
    Write-Host $c.Substring($start, $len)
}


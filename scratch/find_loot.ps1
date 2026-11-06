$content = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\net\gateway.9b66608f1070.js", [System.Text.Encoding]::UTF8)
$pos = 0
while (($pos = $content.IndexOf('"loot"', $pos)) -ne -1) {
    Write-Host "Match at $pos :"
    $start = [Math]::Max(0, $pos - 80)
    $len = [Math]::Min(300, $content.Length - $start)
    Write-Host $content.Substring($start, $len)
    Write-Host "--------------------"
    $pos += 6
}


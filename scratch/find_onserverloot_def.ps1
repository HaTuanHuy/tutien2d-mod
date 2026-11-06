$c = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\scenes\world.149b4b6a3e7b.js", [System.Text.Encoding]::UTF8)
$pos = $c.IndexOf(".onServerLoot=")
if ($pos -eq -1) { $pos = $c.IndexOf("onServerLoot") }
while ($pos -ne -1) {
    Write-Host "Position $pos :"
    $start = [Math]::Max(0, $pos - 50)
    $len = [Math]::Min(1200, $c.Length - $start)
    Write-Host $c.Substring($start, $len)
    Write-Host "===================="
    $pos = $c.IndexOf("onServerLoot", $pos + 12)
}


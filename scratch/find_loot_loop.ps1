$c = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\scenes\world.149b4b6a3e7b.js", [System.Text.Encoding]::UTF8)
$pos = $c.IndexOf('if("bay"!==c.state)')
if ($pos -ne -1) {
    $start = [Math]::Max(0, $pos - 100)
    $len = [Math]::Min(1200, $c.Length - $start)
    Write-Host $c.Substring($start, $len)
}


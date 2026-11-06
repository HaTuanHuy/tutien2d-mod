$files = Get-ChildItem -Path "d:\Tutien2d\tutien2d.com\src" -Recurse -Filter "*.js"
foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    if ($c.Contains("onServerLoot")) {
        Write-Host "Found in $($f.FullName)"
        $pos = $c.IndexOf("onServerLoot")
        $start = [Math]::Max(0, $pos - 100)
        $len = [Math]::Min(500, $c.Length - $start)
        Write-Host $c.Substring($start, $len)
        Write-Host "===================="
    }
}


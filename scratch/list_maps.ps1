$files = Get-ChildItem -Path "d:\Tutien2d\tutien2d.com\src\world" -Filter "*.js"
foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText($f.FullName)
    $pattern = 'MapData\.([A-Z_0-9]+)\s*=\s*\{([^}]+)\}'
    $matches = [System.Text.RegularExpressions.Regex]::Matches($c, 'MapData\.([A-Za-z0-9_]+)\s*=\s*\{')
    foreach ($m in $matches) {
        $name = $m.Groups[1].Value
        # find id: and name: after this match
        $sub = $c.Substring($m.Index, [Math]::Min(500, $c.Length - $m.Index))
        $idM = [System.Text.RegularExpressions.Regex]::Match($sub, 'id\s*:\s*["'']([^"'']+)["'']')
        $nameM = [System.Text.RegularExpressions.Regex]::Match($sub, 'name\s*:\s*["'']([^"'']+)["'']')
        $hasPortals = $sub.Contains('portals')
        Write-Output "File: $($f.Name) | Key: $name | id: $($idM.Groups[1].Value) | name: $($nameM.Groups[1].Value) | hasPortals: $hasPortals"
    }
}


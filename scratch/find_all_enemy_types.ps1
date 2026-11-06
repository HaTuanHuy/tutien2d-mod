$c = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\entities\enemy.7739f83bfc3f.js", [System.Text.Encoding]::UTF8)

# Find all enemy types
$matches = [regex]::Matches($c, '([a-z0-9_]+)\s*:\s*\{[^}]*name\s*:\s*"([^"]+)"')
foreach ($m in $matches) {
    Write-Host "$($m.Groups[1].Value) => $($m.Groups[2].Value)"
}


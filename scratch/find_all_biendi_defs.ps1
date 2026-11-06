$content = [System.IO.File]::ReadAllText('src/entities/enemy.7739f83bfc3f.js')
$matches = [regex]::Matches($content, '([a-z0-9_]+):\s*\{[^{}]*?bienDi[^{}]*?\}')
foreach ($m in $matches) {
    Write-Output $m.Groups[1].Value
}


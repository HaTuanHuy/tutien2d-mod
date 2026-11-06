$content = [System.IO.File]::ReadAllText('src/entities/enemy.7739f83bfc3f.js')
$matches = [regex]::Matches($content, 'bienDi')
foreach ($m in $matches) {
    $idx = $m.Index
    $start = [Math]::Max(0, $idx - 50)
    $len = [Math]::Min(150, $content.Length - $start)
    Write-Output "Pos $idx : $($content.Substring($start, $len))"
}


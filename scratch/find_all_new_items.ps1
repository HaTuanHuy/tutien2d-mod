$content = [System.IO.File]::ReadAllText('src/systems/items.de6f3f9bc95f.js')
$matches = [regex]::Matches($content, '([a-z0-9_]+):\s*\{\s*id:\s*"([a-z0-9_]+)",\s*name:\s*"([^"]+)"')
$items = @()
foreach ($m in $matches) {
    $items += "$($m.Groups[2].Value) -> $($m.Groups[3].Value)"
}
$items | Select-Object -Last 40


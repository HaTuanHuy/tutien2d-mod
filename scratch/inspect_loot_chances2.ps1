$lootNew = Get-Content "src/systems/loot.bf955f23c00a.js" -Raw
$matches = [regex]::Matches($lootNew, '([a-zA-Z0-9_]+_CHANCE[^\,\;\}]+)')
foreach ($m in $matches) {
    Write-Host $m.Groups[1].Value
}


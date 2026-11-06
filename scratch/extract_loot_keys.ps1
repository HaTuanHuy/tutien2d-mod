$lootFile = "d:\Tutien2d\tutien2d.com\src\systems\loot.ef0f82c62597.js"
$content = [System.IO.File]::ReadAllText($lootFile, [System.Text.Encoding]::UTF8)

# Find all string literals that look like item identifiers
$matches = [regex]::Matches($content, '"([a-z0-9_]+)"')
$items = @{}
foreach ($m in $matches) {
    $val = $m.Groups[1].Value
    $items[$val] = $true
}

Write-Host "Total unique string keys in loot.js: $($items.Count)"

$script = @"
const fs = require('fs');
// Let's print using PowerShell directly
"@


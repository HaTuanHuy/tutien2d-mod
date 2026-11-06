$c = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\systems\loot.ef0f82c62597.js", [System.Text.Encoding]::UTF8)

# Find all string values assigned to items, constants, etc.
$script = @"
// We can parse with regex directly in powershell
"@

# All specific constants in loot.js:
$constants = @{}
$regexes = @(
    'n\.([A-Z0-9_]+)\s*=\s*"([^"]+)"',
    'ITEM\s*:\s*"([^"]+)"',
    'ITEMS\s*:\s*\[(.*?)\]',
    'item\s*:\s*"([^"]+)"'
)

foreach ($r in $regexes) {
    $ms = [regex]::Matches($c, $r)
    foreach ($m in $ms) {
        if ($m.Groups.Count -ge 3) {
            Write-Host "$($m.Groups[1].Value) = $($m.Groups[2].Value)"
        } elseif ($m.Groups.Count -ge 2) {
            Write-Host "$($m.Groups[1].Value)"
        }
    }
}


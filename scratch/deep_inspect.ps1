# Deep inspect gateway differences
$gwOld = Get-Content "src/net/gateway.305ce5b88ec9.js" -Raw
$gwNew = Get-Content "src/net/gateway.9d354e508f3b.js" -Raw

Write-Host "=== GATEWAY SIZE ==="
Write-Host "Old length: $($gwOld.Length), New length: $($gwNew.Length)"

# Let's check diff in words/tokens
# Or find strings present in new but not in old
$stringsNew = [regex]::Matches($gwNew, '"([^"\\]{4,50})"') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
$stringsOld = [regex]::Matches($gwOld, '"([^"\\]{4,50})"') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
$diffStrings = $stringsNew | Where-Object { $stringsOld -notcontains $_ }
Write-Host "`nNew string literals in gateway ($($diffStrings.Count)): "
$diffStrings | Select-Object -First 40 | ForEach-Object { Write-Host " + '$_'" }

# Also check single-quoted strings
$sqNew = [regex]::Matches($gwNew, "'([^'\\]{4,50})'") | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
$sqOld = [regex]::Matches($gwOld, "'([^'\\]{4,50})'") | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
$diffSq = $sqNew | Where-Object { $sqOld -notcontains $_ }
Write-Host "`nNew single-quote string literals in gateway ($($diffSq.Count)): "
$diffSq | Select-Object -First 40 | ForEach-Object { Write-Host " + '$_'" }

# Check loot differences
Write-Host "`n=== LOOT COMPARISON ==="
$lootOld = Get-Content "src/systems/loot.6722a6179ae8.js" -Raw
$lootNew = Get-Content "src/systems/loot.bf955f23c00a.js" -Raw
$lootStrsNew = [regex]::Matches($lootNew, '["'']([a-zA-Z0-9_]{3,40})["'']') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
$lootStrsOld = [regex]::Matches($lootOld, '["'']([a-zA-Z0-9_]{3,40})["'']') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
$diffLoot = $lootStrsNew | Where-Object { $lootStrsOld -notcontains $_ }
Write-Host "New loot strings ($($diffLoot.Count)): "
$diffLoot | ForEach-Object { Write-Host " + '$_'" }


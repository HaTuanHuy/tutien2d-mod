$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("LOOT_SPECIAL_SCORES = {")
$endIdx = $helper.IndexOf("};", $idx)
$fullLoot = $helper.Substring($idx, $endIdx - $idx + 2)
[System.IO.File]::WriteAllText("scratch/current_loot.txt", $fullLoot)
Write-Host "Wrote scratch/current_loot.txt, length: $($fullLoot.Length)"


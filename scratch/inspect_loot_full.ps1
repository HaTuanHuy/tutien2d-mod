$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("LOOT_SPECIAL_SCORES = {")
$endIdx = $helper.IndexOf("};", $idx)
Write-Host $helper.Substring($idx, $endIdx - $idx + 2)


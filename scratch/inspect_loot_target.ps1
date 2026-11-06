$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("LOOT_SPECIAL_SCORES = {")
Write-Host $helper.Substring($idx, 600)


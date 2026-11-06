$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("LOOT_SPECIAL_SCORES")
if ($idx -ge 0) {
    Write-Host $helper.Substring($idx, 4000)
}


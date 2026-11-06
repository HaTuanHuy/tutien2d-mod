$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("function calcLootScore")
if ($idx -lt 0) {
    $idx = $helper.IndexOf("LOOT_SPECIAL_SCORES") + 2500
}
Write-Host $helper.Substring($idx, 2000)


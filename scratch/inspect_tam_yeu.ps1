$lootNew = Get-Content "src/systems/loot.bf955f23c00a.js" -Raw
$idx = $lootNew.IndexOf("tam_yeu_linh_boi")
if ($idx -ge 0) {
    Write-Host $lootNew.Substring([Math]::Max(0, $idx - 200), 500)
}


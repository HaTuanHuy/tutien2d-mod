$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, 'LOOT_SPECIAL_SCORES\[')
foreach ($m in $matches) {
    $idx = $m.Index
    Write-Host "--- Match at $idx ---"
    Write-Host $helper.Substring([Math]::Max(0, $idx - 200), 500)
}


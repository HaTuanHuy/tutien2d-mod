$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, 'function\s+autoCast|function\s+useSkill|castSkill|equippedSkills|getSkills')
foreach ($m in $matches) {
    $idx = $m.Index
    Write-Host ("Match at " + $idx + ": " + $m.Value)
    Write-Host $helper.Substring([Math]::Max(0, $idx - 100), 400)
    Write-Host "----------------"
}

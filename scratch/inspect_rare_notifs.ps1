$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, 'tgNotifyRare|tgDrop|notifyRare|rareDrop|nhặt được')
foreach ($m in $matches) {
    $idx = $m.Index
    Write-Host ("Match at " + $idx + ": " + $m.Value)
    Write-Host $helper.Substring([Math]::Max(0, $idx - 50), 200)
    Write-Host "---"
}


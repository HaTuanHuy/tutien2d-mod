$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, 'phong_song_duc')
foreach ($m in $matches) {
    $idx = $m.Index
    Write-Host ("Match at " + $idx)
    Write-Host $helper.Substring([Math]::Max(0, $idx - 50), 150)
    Write-Host "---"
}


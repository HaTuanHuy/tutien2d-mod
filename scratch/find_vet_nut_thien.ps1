$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("khong_gian_vet_nut")
while ($idx -ge 0) {
    Write-Host $helper.Substring([Math]::Max(0, $idx - 100), 250)
    Write-Host "---"
    $idx = $helper.IndexOf("khong_gian_vet_nut", $idx + 1)
}


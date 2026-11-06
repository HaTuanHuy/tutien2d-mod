$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("ruong_phi_hanh: 28000,")
$idxEnd = $helper.IndexOf("thanh_loan: 14800,")
Write-Host $helper.Substring($idx - 50, $idxEnd - $idx + 100)


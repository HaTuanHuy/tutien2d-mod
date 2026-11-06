$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("function isTranAllowed")
if ($idx -ge 0) {
    Write-Host $helper.Substring($idx, 600)
}


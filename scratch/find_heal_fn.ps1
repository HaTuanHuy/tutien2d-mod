$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, 'function\s+[a-zA-Z0-9_]*(?:heal|med|rest|safe)[a-zA-Z0-9_]*\s*\(', "IgnoreCase")
foreach ($f in $matches) {
    Write-Host "Function: $($f.Value)"
}
# Search for vnIn or vn
$matchesVN = [regex]::Matches($helper, '.{0,40}(?:vnIn|vnSt).{0,40}')
foreach ($m in $matchesVN | Select-Object -First 10) {
    Write-Host "VN: $($m.Value.Trim())"
}


$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, '.{0,40}(?:laHuyetTu|ChinhDao|HuyetTu|NhoTu).{0,40}', "IgnoreCase")
Write-Host "Found $($matches.Count) matches:"
foreach ($m in $matches | Select-Object -First 10) {
    Write-Host " -> $($m.Value.Trim())"
}


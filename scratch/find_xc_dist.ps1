$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, '(?:follow|dist|approach)[a-zA-Z0-9_]*xong[a-zA-Z0-9_]*', "IgnoreCase")
foreach ($m in $matches) {
    Write-Host $m.Value
}
if ($matches.Count -eq 0) {
    $matches2 = [regex]::Matches($helper, '25', "IgnoreCase")
    Write-Host "Found $($matches2.Count) occurrences of 25"
    # Find around 'xổng' or 'xong'
    $idx = $helper.IndexOf("xong_chuong")
    if ($idx -ge 0) {
        Write-Host $helper.Substring($idx, 800)
    }
}


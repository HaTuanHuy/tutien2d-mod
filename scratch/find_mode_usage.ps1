$helper = Get-Content "tutien2d-helper.user.js" -Raw
$pattern = 'mode\s*===?\s*[''"][^''"]+[''"]'
$matches = [regex]::Matches($helper, $pattern)
foreach ($m in $matches) {
    $idx = $m.Index
    Write-Host ("Match: " + $m.Value + " at " + $idx)
    Write-Host $helper.Substring([Math]::Max(0, $idx - 100), 300)
    Write-Host "---"
}

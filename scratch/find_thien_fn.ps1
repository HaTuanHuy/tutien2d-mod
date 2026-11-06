$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, '.{0,50}vet_nut.{0,50}')
foreach ($m in $matches) {
    if ($m.Value -match 'thien|thiền|heal|meditat') {
        Write-Host $m.Value.Trim()
    }
}
# Also find all function names with 'thien'
$fnMatches = [regex]::Matches($helper, 'function\s+[a-zA-Z0-9_]*thien[a-zA-Z0-9_]*\s*\(', "IgnoreCase")
foreach ($f in $fnMatches) {
    Write-Host "Function: $($f.Value)"
}


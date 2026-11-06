$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, 'VERSION\s*=\s*[''"][^''"]+[''"]')
foreach ($m in $matches) {
    Write-Host $m.Value
}


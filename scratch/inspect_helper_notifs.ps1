$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, '.{0,50}(?:cập nhật|phiên bản|source).{0,50}', "IgnoreCase")
foreach ($m in $matches) {
    Write-Host $m.Value.Trim()
}


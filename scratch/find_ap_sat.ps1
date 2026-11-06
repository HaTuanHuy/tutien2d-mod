$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, '.{0,60}áp sát.{0,60}')
foreach ($m in $matches) {
    Write-Host $m.Value.Trim()
}


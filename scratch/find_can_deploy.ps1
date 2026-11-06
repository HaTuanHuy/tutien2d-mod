$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, '.{0,40}canDeployTranBan.{0,40}')
foreach ($m in $matches) {
    Write-Host $m.Value.Trim()
}


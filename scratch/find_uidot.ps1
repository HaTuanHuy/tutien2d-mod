$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, 'ui\.dot\.[a-zA-Z0-9_.]+')
foreach ($m in $matches) {
    Write-Output $m.Value
}


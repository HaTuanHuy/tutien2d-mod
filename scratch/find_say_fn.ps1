$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, 'function\s+(?:say|toast|notify|showMsg|alert)\(')
foreach ($m in $matches) {
    Write-Output $m.Value
}


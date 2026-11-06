$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, 'toast\(')
foreach ($m in $matches) {
    $lineNum = ($content.Substring(0, $m.Index) -split "`n").Count
    Write-Output "toast( at line $lineNum"
}


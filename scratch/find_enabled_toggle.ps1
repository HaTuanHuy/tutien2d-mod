$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, 'enabled\s*=\s*(?:!enabled|true|false)')
foreach ($m in $matches) {
    $lineNum = ($content.Substring(0, $m.Index) -split "`n").Count
    Write-Output "$($m.Value) at line $lineNum"
}


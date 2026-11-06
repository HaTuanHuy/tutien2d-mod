$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, 'LOOT_PRIORITY')
foreach ($m in $matches) {
    $lineNum = ($content.Substring(0, $m.Index) -split "`n").Count
    Write-Output "LOOT_PRIORITY at line $lineNum"
}


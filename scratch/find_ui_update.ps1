$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, 'function\s+uiUpdate|function\s+renderStatus|function\s+hudUpdate')
$lines = @()
foreach ($m in $matches) {
    $lineNum = ($content.Substring(0, $m.Index) -split "`n").Count
    $lines += "$($m.Value) at line $lineNum"
}
$lines


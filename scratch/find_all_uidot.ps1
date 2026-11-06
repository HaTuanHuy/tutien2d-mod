$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, 'ui\.dot')
foreach ($m in $matches) {
    $lineNum = ($content.Substring(0, $m.Index) -split "`n").Count
    $idx = $m.Index
    $start = [Math]::Max(0, $idx - 30)
    $len = [Math]::Min(100, $content.Length - $start)
    $sub = $content.Substring($start, $len)
    Write-Output "Line ${lineNum} : ${sub}"
}

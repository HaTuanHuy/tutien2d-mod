$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, 'readNews|bdEvents|thach_quy|bien_di')
$lines = @()
foreach ($m in $matches) {
    # find line number
    $lineNum = ($content.Substring(0, $m.Index) -split "`n").Count
    $lines += "$($m.Value) at line $lineNum"
}
$lines | Select-Object -Unique -First 30


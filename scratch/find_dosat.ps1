$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, '(?i)(do_sat|dosat|tong_mon_lenh)')
$lines = @()
foreach ($m in $matches) {
    $lineNum = ($content.Substring(0, $m.Index) -split "`n").Count
    $lines += "$($m.Value) at line $lineNum"
}
$lines | Select-Object -Unique


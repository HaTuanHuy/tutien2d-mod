$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, '(?i)(he_tu|nho_tu|huyet_tu|he tu|nho tu|huyet tu|mon_phai|sect)')
$lines = @()
foreach ($m in $matches) {
    $lineNum = ($content.Substring(0, $m.Index) -split "`n").Count
    $lines += "$($m.Value) at line $lineNum"
}
$lines | Select-Object -Unique -First 30


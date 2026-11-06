$c = Get-Content 'd:\Tutien2d\tutien2d.com\src\ui\sect.a24f7e1fe20c.js' -Raw -Encoding UTF8
$matches = [regex]::Matches($c, 'sect\.[a-zA-Z0-9_]+')
$cmds = @()
foreach ($m in $matches) {
    $cmds += $m.Value
}
$cmds | Sort-Object -Unique


$c = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\systems\loot.ef0f82c62597.js", [System.Text.Encoding]::UTF8)
$pos = $c.IndexOf("rollKill=function")
$rollKillCode = $c.Substring($pos, [Math]::Min(10000, $c.Length - $pos))

$matches = [regex]::Matches($rollKillCode, 'o\.(push|unshift)\((.*?)\)')
foreach ($m in $matches) {
    Write-Host $m.Value
}

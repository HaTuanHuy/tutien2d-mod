$c = [System.IO.File]::ReadAllText('d:\Tutien2d\tutien2d.com\tutien2d-helper.user.js')
$matches = [System.Text.RegularExpressions.Regex]::Matches($c, 'a\.step\s*=\s*[''"]cướp[^''"]+')
foreach ($m in $matches) {
    Write-Output $m.Value
    $idx = $m.Index
    $start = [Math]::Max(0, $idx - 100)
    $len = [Math]::Min(300, $c.Length - $start)
    Write-Output $c.Substring($start, $len)
    Write-Output "---"
}


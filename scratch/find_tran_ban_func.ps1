$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, 'function\s+[a-zA-Z0-9_]*tran[a-zA-Z0-9_]*\s*\(', "IgnoreCase")
foreach ($m in $matches) {
    Write-Host $m.Value
}
# Also search for 'boss_world' or 'thuong_doi'
$idx = $helper.IndexOf("boss_world")
while ($idx -ge 0) {
    $sub = $helper.Substring([Math]::Max(0, $idx - 50), 200)
    if ($sub -match 'tran_ban|trận bàn|formations') {
        Write-Host "Match at $idx : $sub"
    }
    $idx = $helper.IndexOf("boss_world", $idx + 1)
}


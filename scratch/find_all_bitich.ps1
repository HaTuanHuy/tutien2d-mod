$content = [System.IO.File]::ReadAllText('src/systems/items.de6f3f9bc95f.js')
$matches = [regex]::Matches($content, 'bi_tich_[a-z0-9_]+')
$bws = @()
foreach ($m in $matches) {
    $bws += $m.Value
}
$bws | Select-Object -Unique


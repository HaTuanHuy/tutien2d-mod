$content = [System.IO.File]::ReadAllText('src/systems/hac_thi.26ee3a0d1e05.js')
$matches = [regex]::Matches($content, 'n\.[a-zA-Z0-9_]+\s*=\s*function')
$list = @()
foreach ($m in $matches) {
    $idx = $m.Index
    $len = [Math]::Min(300, $content.Length - $idx)
    $list += $content.Substring($idx, $len)
}
[System.IO.File]::WriteAllLines('scratch/hac_thi_funcs.txt', $list)
Write-Output "Found $($matches.Count) functions"


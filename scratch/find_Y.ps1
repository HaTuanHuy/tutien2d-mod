$content = [System.IO.File]::ReadAllText('src/ui/hacthi.ec6a32726be2.js')
$matches = [regex]::Matches($content, 'Y\s*=')
$list = @()
foreach ($m in $matches) {
    $idx = $m.Index
    $start = [Math]::Max(0, $idx - 50)
    $len = [Math]::Min(200, $content.Length - $start)
    $list += $content.Substring($start, $len)
}
[System.IO.File]::WriteAllLines('scratch/hacthi_Y_set.txt', $list)
Write-Output "Found $($matches.Count) matches"


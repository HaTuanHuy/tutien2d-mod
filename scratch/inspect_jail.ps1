$content = [System.IO.File]::ReadAllText('src/systems/hac_thi.26ee3a0d1e05.js')
$idx = $content.IndexOf('bat_quai_thach_phan')
if ($idx -ge 0) {
    $start = [Math]::Max(0, $idx - 200)
    $len = [Math]::Min(2000, $content.Length - $start)
    $sub = $content.Substring($start, $len)
    [System.IO.File]::WriteAllText('scratch/jail_snippet.txt', $sub)
    Write-Output "Found at $idx, written to scratch/jail_snippet.txt"
} else {
    Write-Output "Not found"
}


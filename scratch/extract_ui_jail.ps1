$content = [System.IO.File]::ReadAllText('src/ui/hacthi.ec6a32726be2.js')
$idx = $content.IndexOf('thiên lao', [System.StringComparison]::OrdinalIgnoreCase)
if ($idx -ge 0) {
    $start = [Math]::Max(0, $idx - 300)
    $len = [Math]::Min(1200, $content.Length - $start)
    $sub = $content.Substring($start, $len)
    [System.IO.File]::WriteAllText('scratch/hacthi_ui_jail.txt', $sub)
    Write-Output "Written to scratch/hacthi_ui_jail.txt"
}


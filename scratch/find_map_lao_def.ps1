$content = [System.IO.File]::ReadAllText('src/world/map_hac_thi.b7fd93384833.js')
$idx = $content.IndexOf('bat_quai_thach_phan')
if ($idx -ge 0) {
    Write-Output $content.Substring([Math]::Max(0, $idx - 100), 800)
}


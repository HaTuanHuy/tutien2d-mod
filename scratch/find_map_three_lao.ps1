$content = [System.IO.File]::ReadAllText('src/world/map_three_maps.3fbb466c6c1e.js')
$idx = $content.IndexOf('bat_quai_thach_phan')
if ($idx -ge 0) {
    Write-Output $content.Substring([Math]::Max(0, $idx - 50), 600)
}


$content = [System.IO.File]::ReadAllText('src/entities/enemy.7739f83bfc3f.js')
$idx = $content.IndexOf('thach_quy')
if ($idx -ge 0) {
    Write-Output $content.Substring([Math]::Max(0, $idx - 50), 300)
}


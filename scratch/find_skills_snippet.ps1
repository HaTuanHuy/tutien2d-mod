$content = [System.IO.File]::ReadAllText('src/systems/skills.c84a17e53a93.js')
$idx = $content.IndexOf('huyet_tu')
if ($idx -ge 0) {
    $start = [Math]::Max(0, $idx - 100)
    $len = [Math]::Min(1000, $content.Length - $start)
    Write-Output $content.Substring($start, $len)
}


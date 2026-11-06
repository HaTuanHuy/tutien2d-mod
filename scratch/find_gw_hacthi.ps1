$content = [System.IO.File]::ReadAllText('src/net/gateway.9b66608f1070.js')
$idx = $content.IndexOf('HacThiUI')
if ($idx -ge 0) {
    $start = [Math]::Max(0, $idx - 100)
    $len = [Math]::Min(400, $content.Length - $start)
    $sub = $content.Substring($start, $len)
    Write-Output $sub
}


$content = [System.IO.File]::ReadAllText('src/net/gateway.9b66608f1070.js')
$idx = $content.IndexOf('case"hacthi":')
if ($idx -ge 0) {
    Write-Output $content.Substring([Math]::Max(0, $idx - 100), 300)
}


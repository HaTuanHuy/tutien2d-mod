$content = [System.IO.File]::ReadAllText('src/net/gateway.9b66608f1070.js')
$idx = $content.IndexOf('onmessage')
if ($idx -ge 0) {
    Write-Output $content.Substring($idx, 600)
}


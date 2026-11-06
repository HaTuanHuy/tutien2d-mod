$content = [System.IO.File]::ReadAllText('src/net/gateway.9b66608f1070.js')
$idx = $content.IndexOf('switch(t.op)')
if ($idx -ge 0) {
    Write-Output $content.Substring($idx, 1500)
}


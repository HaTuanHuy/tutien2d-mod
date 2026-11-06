$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (-not (Test-Path $edgePath)) {
    $edgePath = "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
}

$htmlFile = (Resolve-Path "scratch\test_anti_jail_thach_quy.html").Path
$userDataDir = "$env:TEMP\edge_test_aj_profile"

$args = @(
    "--headless",
    "--disable-gpu",
    "--remote-debugging-port=9225",
    "--user-data-dir=$userDataDir",
    "file:///$htmlFile"
)

$proc = Start-Process -FilePath $edgePath -ArgumentList $args -PassThru -NoNewWindow
Start-Sleep -Seconds 3

try {
    $wsUrl = $null
    for ($i = 0; $i -lt 10; $i++) {
        try {
            $json = Invoke-RestMethod -Uri "http://localhost:9225/json" -ErrorAction Stop
            if ($json -and $json[0].webSocketDebuggerUrl) {
                $wsUrl = $json[0].webSocketDebuggerUrl
                break
            }
        } catch {
            Start-Sleep -Milliseconds 500
        }
    }

    if (-not $wsUrl) {
        Write-Error "Could not connect to Edge DevTools"
        exit 1
    }

    $ws = New-Object System.Net.WebSockets.ClientWebSocket
    $cts = New-Object System.Threading.CancellationTokenSource
    $ws.ConnectAsync([uri]$wsUrl, $cts.Token).Wait()

    function Send-CDP($method, $params) {
        $id = [System.Threading.Interlocked]::Increment([ref]$script:cdpId)
        $msg = @{ id = $id; method = $method; params = $params } | ConvertTo-Json -Compress -Depth 10
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($msg)
        $segment = New-Object System.ArraySegment[byte] -ArgumentList @(,$bytes)
        $ws.SendAsync($segment, [System.Net.WebSockets.WebSocketMessageType]::Text, $true, $cts.Token).Wait()
        
        $buffer = New-Object byte[] 65536
        $resSeg = New-Object System.ArraySegment[byte] -ArgumentList @(,$buffer)
        while ($true) {
            $res = $ws.ReceiveAsync($resSeg, $cts.Token).Result
            $respStr = [System.Text.Encoding]::UTF8.GetString($buffer, 0, $res.Count)
            $respObj = $respStr | ConvertFrom-Json
            if ($respObj.id -eq $id) {
                return $respObj
            }
        }
    }

    $script:cdpId = 0
    Send-CDP "Runtime.enable" @{} | Out-Null

    # Wait for testsDone
    $ret = $null
    for ($i = 0; $i -lt 15; $i++) {
        Start-Sleep -Milliseconds 600
        $check = Send-CDP "Runtime.evaluate" @{ expression = "window.testsDone" }
        if ($check.result.result.value -eq $true) {
            $eval = Send-CDP "Runtime.evaluate" @{ expression = "JSON.stringify({ logs: window.testLogs, text: document.getElementById('results').textContent })" }
            $ret = $eval.result.result.value | ConvertFrom-Json
            break
        }
    }

    if ($ret) {
        Write-Output "Results Text: $($ret.text)"
        foreach ($t in $ret.logs) {
            if ($t.ok) {
                Write-Host "✓ PASS: $($t.name)" -ForegroundColor Green
            } else {
                Write-Host "✗ FAIL: $($t.name)" -ForegroundColor Red
            }
        }
        $failed = @($ret.logs | Where-Object { -not $_.ok })
        if ($failed.Count -gt 0) {
            Write-Error "$($failed.Count) tests failed"
            exit 1
        } else {
            Write-Host "ALL $($ret.logs.Count) TESTS PASSED!" -ForegroundColor Green
        }
    } else {
        Write-Error "Timeout waiting for tests"
        exit 1
    }
} finally {
    if ($ws -and $ws.State -eq 'Open') {
        $ws.CloseAsync([System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure, "Done", $cts.Token).Wait()
    }
    if ($proc -and -not $proc.HasExited) {
        Stop-Process -Id $proc.Id -Force
    }
    if (Test-Path $userDataDir) {
        Remove-Item -Path $userDataDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}


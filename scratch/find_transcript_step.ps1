$lines = Get-Content 'C:\Users\memot\.gemini\antigravity\brain\0de95297-11e3-4966-89ec-4bb2a73959df\.system_generated\logs\transcript.jsonl'
foreach ($line in $lines) {
    if ($line.Contains('"USER_INPUT"') -and $line.Contains('xổng chuồng')) {
        Write-Output "User Input Line: $line"
    }
    if ($line.Contains('"step_index":661') -or $line.Contains('"step_index":662')) {
        $obj = ConvertFrom-Json $line
        if ($obj.content) {
            Write-Output "Step $($obj.step_index): $($obj.content.Substring(0, [Math]::Min(300, $obj.content.Length)))"
        }
    }
}


$lines = Get-Content 'C:\Users\memot\.gemini\antigravity\brain\0de95297-11e3-4966-89ec-4bb2a73959df\.system_generated\logs\transcript.jsonl'
foreach ($line in $lines) {
    if ($line -match '"step_index":(66[4-9][0-9]|67[0-9]{2})') {
        $obj = ConvertFrom-Json $line
        if ($obj.source -eq 'MODEL' -and $obj.content -and $obj.type -eq 'PLANNER_RESPONSE') {
            Write-Output "Step $($obj.step_index):"
            Write-Output $obj.content
            Write-Output "------------------------"
        }
    }
}


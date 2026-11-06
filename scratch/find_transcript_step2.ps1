$lines = Get-Content 'C:\Users\memot\.gemini\antigravity\brain\0de95297-11e3-4966-89ec-4bb2a73959df\.system_generated\logs\transcript.jsonl'
foreach ($line in $lines) {
    if ($line.Contains('"step_index":663') -or $line.Contains('"step_index":664')) {
        $obj = ConvertFrom-Json $line
        if ($obj.content -and $obj.source -eq 'MODEL' -and $obj.type -eq 'PLANNER_RESPONSE') {
            Write-Output "Step $($obj.step_index): $($obj.content)"
        }
    }
}


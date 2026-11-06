$lines = Get-Content 'C:\Users\memot\.gemini\antigravity\brain\0de95297-11e3-4966-89ec-4bb2a73959df\.system_generated\logs\transcript_full.jsonl'
$str = $lines[3836]
$idx = $str.IndexOf('8110:')
if ($idx -lt 0) { $idx = $str.IndexOf('8114:') }
Write-Host $str.Substring($idx, [Math]::Min(1200, $str.Length - $idx))

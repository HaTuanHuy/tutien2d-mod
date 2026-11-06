$c = Get-Content 'scratch/test_optimizations_v6311.ps1' -Raw
Write-Output $c.Substring(0, [Math]::Min(1500, $c.Length))


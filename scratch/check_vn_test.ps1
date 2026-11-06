$c = Get-Content 'scratch/test_vn_door.html' -Raw
Write-Output $c.Substring(0, [Math]::Min(1500, $c.Length))


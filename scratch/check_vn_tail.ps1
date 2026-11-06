$c = Get-Content 'scratch/test_vn_door.html' -Raw
Write-Output $c.Substring([Math]::Max(0, $c.Length - 1500), 1500)


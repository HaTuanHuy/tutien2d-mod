$qd = Get-Content "src/ui/quaydao.83839f46f75f.js" -Raw
Write-Host "Length: $($qd.Length)"
Write-Host $qd.Substring(0, [Math]::Min(1500, $qd.Length))


$htOld = Get-Content "src/systems/hac_thi.26ee3a0d1e05.js" -Raw
$htNew = Get-Content "src/systems/hac_thi.25808332226c.js" -Raw
Write-Host "Old len: $($htOld.Length), New len: $($htNew.Length)"

$sNew = [regex]::Matches($htNew, '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
$sOld = [regex]::Matches($htOld, '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
$diffS = $sNew | Where-Object { $sOld -notcontains $_ }
Write-Host "New strings in hac_thi:"
foreach ($s in $diffS) {
    Write-Host " + '$s'"
}

$diffRemoved = $sOld | Where-Object { $sNew -notcontains $_ }
Write-Host "Removed strings in hac_thi:"
foreach ($s in $diffRemoved) {
    Write-Host " - '$s'"
}


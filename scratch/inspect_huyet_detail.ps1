$huyetTu = Get-Content "src/systems/huyet_tu.1a156cccf04a.js" -Raw
Write-Host $huyetTu.Substring(1000, [Math]::Min(2000, $huyetTu.Length - 1000))


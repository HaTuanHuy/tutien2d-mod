$huyetTu = Get-Content "src/systems/huyet_tu.1a156cccf04a.js" -Raw
Write-Host $huyetTu.Substring([Math]::Max(0, $huyetTu.Length - 2000), 2000)


$chinhDao = Get-Content "src/systems/chinh_dao.c6631ad42090.js" -Raw
Write-Host "=== CHINH DAO ==="
$matches = [regex]::Matches($chinhDao, 'DAO\s*=\s*\[[^\]]+\]')
foreach ($m in $matches) { Write-Host $m.Value }

$nhoTu = Get-Content "src/systems/nho_tu.e992c3b63b47.js" -Raw
Write-Host "`n=== NHO TU ==="
Write-Host $nhoTu.Substring(0, [Math]::Min(1000, $nhoTu.Length))

$huyetTu = Get-Content "src/systems/huyet_tu.1a156cccf04a.js" -Raw
Write-Host "`n=== HUYET TU ==="
Write-Host $huyetTu.Substring(0, [Math]::Min(1000, $huyetTu.Length))


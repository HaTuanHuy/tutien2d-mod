$manifest = Get-Content "assets/manifest.js" -Raw
$matches = [regex]::Matches($manifest, '"(assets/[^"]+)":\s*(\d+)')

$missingSize = 0
$missingCount = 0
foreach ($m in $matches) {
    $rel = $m.Groups[1].Value
    $size = [int64]$m.Groups[2].Value
    $path = Join-Path "d:\Tutien2d\tutien2d.com" ($rel -replace '/', '\')
    if (-not (Test-Path $path)) {
        $missingCount++
        $missingSize += $size
    }
}

Write-Host "Missing assets: $missingCount"
Write-Host "Total missing size: $([Math]::Round($missingSize / 1MB, 2)) MB"


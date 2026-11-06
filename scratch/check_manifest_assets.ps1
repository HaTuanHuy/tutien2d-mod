$manifest = Get-Content "assets/manifest.js" -Raw
$matches = [regex]::Matches($manifest, '"(assets/[^"]+)":\s*(\d+)')
Write-Host "Total assets listed in manifest: $($matches.Count)"

$missing = @()
$found = 0
foreach ($m in $matches) {
    $rel = $m.Groups[1].Value
    $path = Join-Path "d:\Tutien2d\tutien2d.com" ($rel -replace '/', '\')
    if (Test-Path $path) {
        $found++
    } else {
        $missing += $rel
    }
}

Write-Host "Found on disk: $found"
Write-Host "Missing on disk: $($missing.Count)"
if ($missing.Count -gt 0) {
    Write-Host "First 20 missing:"
    $missing | Select-Object -First 20 | ForEach-Object { Write-Host " - $_" }
}


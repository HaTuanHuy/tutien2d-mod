$localRoot = "d:\Tutien2d\tutien2d.com"

# Kiem tra rootfile
$html = Get-Content (Join-Path $localRoot "rootfile") -Raw
$scriptMatches = [regex]::Matches($html, '<script\s+[^>]*src="([^"]+)"')
$linkMatches = [regex]::Matches($html, '<link\s+[^>]*rel="stylesheet"[^>]*href="([^"]+)"')
$linkMatches2 = [regex]::Matches($html, '<link\s+[^>]*href="([^"]+)"[^>]*rel="stylesheet"')

$rootUrls = ($scriptMatches | ForEach-Object { $_.Groups[1].Value }) + 
            ($linkMatches | ForEach-Object { $_.Groups[1].Value }) + 
            ($linkMatches2 | ForEach-Object { $_.Groups[1].Value }) | 
            Where-Object { $_ -notmatch '^https?://' } | 
            Select-Object -Unique

$rootMissing = 0
foreach ($u in $rootUrls) {
    $clean = ($u -split '\?')[0].TrimStart('/', '\')
    $p = Join-Path $localRoot ($clean -replace '/', '\')
    if (-not (Test-Path $p)) { $rootMissing++ }
}

# Kiem tra manifest
$manifest = Get-Content (Join-Path $localRoot "assets/manifest.js") -Raw
$manifestMatches = [regex]::Matches($manifest, '"(assets/[^"]+)":\s*(\d+)')
$manifestMissing = 0
foreach ($m in $manifestMatches) {
    $rel = $m.Groups[1].Value
    $p = Join-Path $localRoot ($rel -replace '/', '\')
    if (-not (Test-Path $p)) { $manifestMissing++ }
}

Write-Host "=== TONG KET KIEM TRA SOURCE TREN MAY ==="
Write-Host "Tai nguyen rootfile (JS/CSS/Webmanifest): $($rootUrls.Count) -> Thieu: $rootMissing"
Write-Host "Tai nguyen manifest (Anh/Bieu tuong/Asset): $($manifestMatches.Count) -> Thieu: $manifestMissing"


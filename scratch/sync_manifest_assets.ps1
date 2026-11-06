$manifest = Get-Content "assets/manifest.js" -Raw
$matches = [regex]::Matches($manifest, '"(assets/[^"]+)":\s*(\d+)')
$baseUrl = "https://tutien2d.com"
$localRoot = "d:\Tutien2d\tutien2d.com"

$missing = @()
foreach ($m in $matches) {
    $rel = $m.Groups[1].Value
    $target = Join-Path $localRoot ($rel -replace '/', '\')
    if (-not (Test-Path $target)) {
        $missing += $rel
    }
}

Write-Host "Missing manifest assets: $($missing.Count)"
if ($missing.Count -eq 0) {
    Write-Host "Tat ca manifest assets da day du!"
    exit 0
}

# Tao curl config file
$configFile = "scratch/curl_manifest.txt"
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("create-dirs")
$lines.Add("silent")

foreach ($rel in $missing) {
    $url = "$baseUrl/$rel"
    $outPath = Join-Path $localRoot ($rel -replace '/', '\')
    $lines.Add("url = `"$url`"")
    $lines.Add("output = `"$outPath`"")
}

[System.IO.File]::WriteAllLines($configFile, $lines)
Write-Host "Da tao curl config voi $($missing.Count) file. Bat dau tai song song..."

$sw = [System.Diagnostics.Stopwatch]::StartNew()
& curl.exe --parallel --parallel-max 24 --config $configFile
$sw.Stop()

Write-Host "Hoan tat tai trong $($sw.ElapsedMilliseconds) ms!"

# Kiem tra lai so luong con thieu
$stillMissing = 0
foreach ($rel in $missing) {
    $target = Join-Path $localRoot ($rel -replace '/', '\')
    if (-not (Test-Path $target)) {
        $stillMissing++
    }
}

Write-Host "So file da tai ve thanh cong: $($missing.Count - $stillMissing)"
Write-Host "So file con thieu: $stillMissing"


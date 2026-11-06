$html = Get-Content "rootfile" -Raw
$baseUrl = "https://tutien2d.com"
$localRoot = "d:\Tutien2d\tutien2d.com"

$urls = @()
$scriptMatches = [regex]::Matches($html, '<script\s+[^>]*src="([^"]+)"')
foreach ($m in $scriptMatches) { $urls += $m.Groups[1].Value }
$linkMatches = [regex]::Matches($html, '<link\s+[^>]*rel="stylesheet"[^>]*href="([^"]+)"')
foreach ($m in $linkMatches) { $urls += $m.Groups[1].Value }
$linkMatches2 = [regex]::Matches($html, '<link\s+[^>]*href="([^"]+)"[^>]*rel="stylesheet"')
foreach ($m in $linkMatches2) { $urls += $m.Groups[1].Value }

$urls = $urls | Select-Object -Unique

foreach ($u in $urls) {
    if ($u -match '^https?://') { continue }
    $cleanPath = ($u -split '\?')[0].TrimStart('/', '\')
    $isHashed = ($cleanPath -match '\.[0-9a-f]{12}\.')
    $targetPath = Join-Path $localRoot ($cleanPath -replace '/', '\')

    if ((Test-Path $targetPath) -and $isHashed) {
        continue
    }

    $fileUrl = $baseUrl + "/" + $u.TrimStart('/', '\')

    Write-Host "Downloading: $cleanPath"
    Write-Host " -> From: $fileUrl"
    Write-Host " -> To:   $targetPath"
    $res = & curl.exe -s -w "%{http_code}" -o $targetPath "$fileUrl"
    Write-Host " -> Result: HTTP $res"
}

# Script kiem tra va dong bo toan bo source game moi nhat tu https://tutien2d.com/?choi

$baseUrl = "https://tutien2d.com"
$localRoot = "d:\Tutien2d\tutien2d.com"

Write-Host "1. Dang tai trang game https://tutien2d.com/?choi..."
$html = curl.exe -s "https://tutien2d.com/?choi"
if (-not $html -or $html.Length -lt 500) {
    Write-Error "Khong tai duoc noi dung tu https://tutien2d.com/?choi"
    exit 1
}

$oldRootPath = Join-Path $localRoot "rootfile"
$oldHtml = ""
if (Test-Path $oldRootPath) {
    $oldHtml = [System.IO.File]::ReadAllText($oldRootPath)
}

if ($oldHtml -eq $html) {
    Write-Host "-> Trang rootfile tren may chu giong 100% voi rootfile hien tai tren may!" -ForegroundColor Yellow
} else {
    Write-Host "-> PHAT HIEN ROOTFILE MOI! Da cap nhat rootfile tren may." -ForegroundColor Green
    [System.IO.File]::WriteAllText($oldRootPath, $html)
}

# Trich xuat tat ca the script va link stylesheet
$urls = @()
$scriptMatches = [regex]::Matches($html, '<script\s+[^>]*src="([^"]+)"')
foreach ($m in $scriptMatches) {
    $urls += $m.Groups[1].Value
}
$linkMatches = [regex]::Matches($html, '<link\s+[^>]*rel="stylesheet"[^>]*href="([^"]+)"')
foreach ($m in $linkMatches) {
    $urls += $m.Groups[1].Value
}
$linkMatches2 = [regex]::Matches($html, '<link\s+[^>]*href="([^"]+)"[^>]*rel="stylesheet"')
foreach ($m in $linkMatches2) {
    $urls += $m.Groups[1].Value
}

$urls = $urls | Select-Object -Unique
Write-Host "2. Tim thay $($urls.Count) tai nguyen trong rootfile."

$downloaded = 0
$updated = 0
$skipped = 0
$failed = 0

foreach ($u in $urls) {
    # Bo qua link ngoai (Google fonts, CDNs...)
    if ($u -match '^https?://') {
        continue
    }

    $cleanPath = ($u -split '\?')[0].TrimStart('/', '\')
    $targetPath = Join-Path $localRoot ($cleanPath -replace '/', '\')
    $parentDir = Split-Path -Path $targetPath -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    # Neu file co content-hash 12 ky tu hex va da ton tai tren may -> giu nguyen
    $isHashed = ($cleanPath -match '\.[0-9a-f]{12}\.')
    if ((Test-Path $targetPath) -and $isHashed) {
        $skipped++
        continue
    }

    $fileUrl = $baseUrl + "/" + $u.TrimStart('/', '\')
    $isExisting = Test-Path $targetPath
    $res = & curl.exe -s -w "%{http_code}" -o $targetPath "$fileUrl"
    if ($res -eq "200") {
        if ($isExisting) {
            $updated++
            Write-Host " [UPDATED] $cleanPath" -ForegroundColor Cyan
        } else {
            $downloaded++
            Write-Host " [DOWNLOADED] $cleanPath" -ForegroundColor Green
        }
    } else {
        $failed++
        Write-Host " [FAIL $res] $cleanPath -> $fileUrl" -ForegroundColor Red
    }
}

Write-Host "========================================="
Write-Host "KET QUA DONG BO TONG THE:"
Write-Host "- File moi da tai: $downloaded"
Write-Host "- File cap nhat lai: $updated"
Write-Host "- File hash cu giu nguyen: $skipped"
Write-Host "- Loi: $failed"
Write-Host "========================================="

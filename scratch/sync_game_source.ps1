# Script đồng bộ toàn bộ codebase mới nhất từ https://tutien2d.com/?choi về thư mục local

$baseUrl = "https://tutien2d.com"
$localRoot = "d:\Tutien2d\tutien2d.com"

Write-Host "1. Đang tải trang game https://tutien2d.com/?choi..."
$html = curl.exe -s "https://tutien2d.com/?choi"
if (-not $html -or $html.Length -lt 500) {
    Write-Error "Không tải được nội dung từ https://tutien2d.com/?choi"
    exit 1
}

# Lưu lại rootfile mới (index.html của game)
Set-Content -Path (Join-Path $localRoot "rootfile") -Value $html -Encoding UTF8
Write-Host "-> Đã cập nhật rootfile mới."

# Trích xuất danh sách scripts và stylesheets
$urls = @()
$urls += [regex]::Matches($html, '<script\s+src="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
$urls += [regex]::Matches($html, '<link\s+rel="stylesheet"\s+href="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }

Write-Host "2. Tổng số tài nguyên client: $($urls.Count) files."

$downloaded = 0
$skipped = 0
$failed = 0

foreach ($u in $urls) {
    $cleanPath = ($u -split '\?')[0]
    $targetPath = Join-Path $localRoot ($cleanPath -replace '/', '\')
    
    if (Test-Path $targetPath) {
        $skipped++
        continue
    }

    $parentDir = Split-Path -Path $targetPath -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    $fileUrl = "$baseUrl/$cleanPath"
    $res = curl.exe -s -w "%{http_code}" -o $targetPath $fileUrl
    if ($res -eq "200") {
        $downloaded++
        Write-Host " [OK] $cleanPath"
    } else {
        $failed++
        Write-Host " [FAIL $res] $cleanPath" -ForegroundColor Red
        if (Test-Path $targetPath) { Remove-Item $targetPath -Force }
    }
}

Write-Host "========================================="
Write-Host "KẾT QUẢ ĐỒNG BỘ:"
Write-Host "- File mới đã tải thành công: $downloaded"
Write-Host "- File cũ giữ nguyên: $skipped"
Write-Host "- Thất bại: $failed"
Write-Host "========================================="


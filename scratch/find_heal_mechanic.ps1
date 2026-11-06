$files = Get-ChildItem -Path "src" -Recurse -Filter "*.js"

foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    # Search for phrases related to the morning update:
    # "Khu Thương Đội và Thú Xổng: nâng trần 100 người, hồi máu theo số người săn"
    if ($content -match '100|thu_xong|xong_chuong|hoiMau|regen|hoi_hp') {
        $matches = [regex]::Matches($content, '.{0,40}(?:hoiMau|hoi_hp|soNguoi|nguoiSan|hoiNguoi).{0,40}', "IgnoreCase")
        if ($matches.Count -gt 0) {
            Write-Host "File: $($f.FullName)"
            foreach ($m in $matches | Select-Object -First 3) {
                Write-Host " -> $($m.Value.Trim())"
            }
        }
    }
}


$file = "d:\Tutien2d\tutien2d.com\tutien2d-helper.user.js"
$content = Get-Content $file -Raw

Write-Host "=== TEST SUITE v0.63.12 ===" -ForegroundColor Cyan
$passed = 0
$total = 0

function Assert-Check($name, $condition) {
    $script:total++
    if ($condition) {
        $script:passed++
        Write-Host " [PASS] $name" -ForegroundColor Green
    }
    else {
        Write-Host " [FAIL] $name" -ForegroundColor Red
    }
}

# 1. Version check
Assert-Check "Version is 0.63.12" ($content -match "@version\s+0\.63\.12" -and $content -match "VERSION\s*=\s*'0\.63\.12'")

# 2. ServerBus handles world_chat and chat with xổng chuồng / thiên đạo
Assert-Check "ServerBus world_chat checks xổng chuồng / thiên đạo" ($content -match "ServerBus\.on\('world_chat',\s*function\s*\(p\)\s*\{[\s\S]*?readServerNews\(p\.text\);")
Assert-Check "ServerBus chat checks xổng chuồng / thiên đạo" ($content -match "ServerBus\.on\('chat',\s*function\s*\(p\)\s*\{[\s\S]*?readServerNews\(p\.text\);")

# 3. pushWorldSay hook exists
Assert-Check "hookChat hooks pushWorldSay" ($content -match "C\.pushWorldSay\s*=\s*function\s*\(id,\s*name,\s*text,\s*tuyen\)")

# 4. mapByName aliases includes Bãi Đá
Assert-Check "MAP_ALIASES includes bai_da and bai_da_hang_gio" ($content -match "'bai da':\s*'bai_da_hang_gio'")

# 5. Point-blank hugging from 100% HP in evEngage
Assert-Check "evEngage hugs close from 100% HP for st.xc / isLastHitOnly" ($content -match "var hugClose = !!\(st\.xc \|\| isLastHitOnly\(t\)\);\s*if \(hugClose \|\| isDying\)")

# 6. smartMove sets reach = 2 for hugClose
Assert-Check "smartMove sets reach = 2 for hugClose" ($content -match "var hugClose = !!\(st\.xc \|\| isLastHitOnly\(t\)\);\s*if \(hugClose\) reach = 2;")

# 7. cướp tiêu safe continuation restored cleanly
Assert-Check "cướp tiêu camp logic restored cleanly" ($content -match "if \(g\.mapId !== map && !hunting\) \{\s*a\.step = 'ra ' \+ mapName\(map\) \+ ' camp';")

Write-Host "=== RESULT: $passed / $total passed ===" -ForegroundColor Yellow
if ($passed -eq $total) { exit 0 } else { exit 1 }



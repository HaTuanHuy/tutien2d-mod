$helperPath = "d:\Tutien2d\tutien2d.com\tutien2d-helper.user.js"
$content = Get-Content $helperPath -Raw

$allPassed = $true

function Assert-Rule($name, $condition) {
    if ($condition) {
        Write-Host "PASS: $name" -ForegroundColor Green
    }
    else {
        Write-Host "FAIL: $name" -ForegroundColor Red
        $global:allPassed = $false
    }
}

# 1. Version is 0.63.11
Assert-Rule "Version header is 0.63.11" ($content -match "// @version\s+0\.63\.11" -and $content -match "var VERSION = '0\.63\.11';")

# 2. ServerBus handles notice
Assert-Rule "ServerBus handles notice packet" ($content -match "ServerBus\.on\('notice',\s*function\s*\(p\)\s*\{\s*if\s*\(p\.text\)\s*\{\s*readServerNews\(p\.text\);")

# 3. mapGraph handles late loading & dynamic maps
Assert-Rule "mapGraph handles dynamic maps and safe fallback" ($content -match "Object\.keys\(st\.graph\)\.length >= mdKeys\.length")

# 4. mapByName handles 1-argument call and null fallback
Assert-Rule "mapByName handles single argument and safe fallback" ($content -match "if \(typeof P === 'string' && txt === undefined\)")

# 5. Cướp Tiêu hauling check placed before vtActive early return
Assert-Rule "tickCuopTieu hauls stolen cart before early return check" ($content -match "if \(cfg\.ctRun && vtChuyen\(P\)\)[\s\S]*?if \(vtActive\(g\) \|\| st\.vt \|\| \(cfg\.vtRun && !st\.ct\)\) return false;")

# 6. lootable accepts force parameter and bypasses !cfg.runLoot && ownPull
Assert-Rule "lootable accepts force and bypasses ownPull restriction" ($content -match "function lootable\(g, r, force\)" -and $content -match "if \(!cfg\.runLoot && !force && ownPull\(P, r\)\) return false;")

# 7. tickLoot passes force to lootable
Assert-Rule "tickLoot passes force to lootable" ($content -match "!lootable\(g, r0, force\)" -and $content -match "!lootable\(g, r, force\)")

# 8. LEAVE_LOOT_R is 800
Assert-Rule "LEAVE_LOOT_R is 800" ($content -match "var LEAVE_LOOT_R = 800;")

# 9. tickXongChuong actively approaches loot before repatrol or chasing next beast
Assert-Rule "tickXongChuong actively approaches drops" ($content -match "tiến tới nhặt đồ rơi xổng chuồng" -and $content -match "if \(nearDrops\.length > 0 && tickLoot\(g, true\)\)")

if ($allPassed) {
    Write-Host "ALL 9/9 V6311 STATIC CODE ASSERTIONS PASSED!" -ForegroundColor Cyan
}
else {
    Write-Host "SOME ASSERTIONS FAILED!" -ForegroundColor Red
    exit 1
}


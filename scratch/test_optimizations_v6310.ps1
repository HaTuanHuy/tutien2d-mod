$helperPath = "d:\Tutien2d\tutien2d.com\tutien2d-helper.user.js"
$content = Get-Content $helperPath -Raw

$allPassed = $true

function Assert-Rule($name, $condition) {
    if ($condition) {
        Write-Host "PASS: $name" -ForegroundColor Green
    } else {
        Write-Host "FAIL: $name" -ForegroundColor Red
        $global:allPassed = $false
    }
}

# 1. Version is 0.63.10
Assert-Rule "Version header is 0.63.10" ($content -match "// @version\s+0\.63\.10" -and $content -match "var VERSION = '0\.63\.10';")

# 2. ServerBus handles notice
Assert-Rule "ServerBus handles notice packet" ($content -match "ServerBus\.on\('notice',\s*function\s*\(p\)\s*\{\s*if\s*\(p\.text\)\s*\{\s*readServerNews\(p\.text\);")

# 3. mapGraph handles late loading & dynamic maps
Assert-Rule "mapGraph handles dynamic maps and safe fallback" ($content -match "Object\.keys\(st\.graph\)\.length >= mdKeys\.length")

# 4. mapByName handles 1-argument call and null fallback
Assert-Rule "mapByName handles single argument and safe fallback" ($content -match "if \(typeof P === 'string' && txt === undefined\)")

# 5. Cướp Tiêu hauling check placed before vtActive early return
Assert-Rule "tickCuopTieu hauls stolen cart before early return check" ($content -match "if \(cfg\.ctRun && vtChuyen\(P\)\)[\s\S]*?if \(vtActive\(g\) \|\| st\.vt \|\| \(cfg\.vtRun && !st\.ct\)\) return false;")

# 6. ctEventName yields to xổng chuồng
Assert-Rule "ctEventName yields to xcPending" ($content -match "if \(st\.xc \|\| \(cfg\.xcHunt && xcPending\(\)\.length\)\) return 'săn xổng chuồng';")

# 7. tickXongChuong repatrols if less than 60s since spawn
Assert-Rule "tickXongChuong repatrols if less than 60s" ($content -match "timeSinceSpawn < 60000")

if ($allPassed) {
    Write-Host "ALL 7/7 V6310 STATIC CODE ASSERTIONS PASSED!" -ForegroundColor Cyan
} else {
    Write-Host "SOME ASSERTIONS FAILED!" -ForegroundColor Red
    exit 1
}


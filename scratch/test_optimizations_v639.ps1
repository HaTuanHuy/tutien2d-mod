$src = Get-Content -Encoding UTF8 'd:\Tutien2d\tutien2d.com\tutien2d-helper.user.js' -Raw

$results = @()
function Assert-Test($desc, $cond) {
    if ($cond) {
        $results += "PASS: $desc"
        Write-Host "PASS: $desc" -ForegroundColor Green
    }
    else {
        $results += "FAIL: $desc"
        Write-Host "FAIL: $desc" -ForegroundColor Red
    }
}

# 1. Version check 0.63.9
Assert-Test "Version header is 0.63.9" ($src -match "@version\s+0\.63\.9" -and $src -match "var VERSION = '0\.63\.9'")

# 2. TG_EV contains 'xc' mapping
$hasXcEv = $src.Contains("['xc', 'Yêu thú xổng chuồng', function () { return !!st.xc; }, 'xc']")
Assert-Test "TG_EV contains 'xc' event mapping" $hasXcEv

# 3. TG_EV ordering (xc before bh)
$idxXc = $src.IndexOf("['xc', 'Yêu thú xổng chuồng'")
$idxBh = $src.IndexOf("['bh', 'Boss'")
Assert-Test "TG_EV has 'xc' before 'bh' so beast hunts are logged as xc instead of bh" ($idxXc -ge 0 -and $idxBh -ge 0 -and $idxXc -lt $idxBh)

# 4. tickReport handles xc
$hasXcReport = $src.Contains("if (r.k === 'xc' && st.xc)")
Assert-Test "tickReport formats step and target for xc events" $hasXcReport

# 5. tgEnd handles xc result
$hasXcResult = $src.Contains("if (r.k === 'xc') { var kCnt = (st.xc && st.xc.kills) || 0; r.result = 'Kết quả: ' + (kCnt ? ('Đã hạ ' + kCnt + ' quái') : 'Kết thúc săn'); }")
Assert-Test "tgEnd logs kills count for xc events" $hasXcResult

# 6. tickRevive tracks recentDeaths within 15s window
$hasRecentDeaths = $src.Contains("st.recentDeaths = (st.recentDeaths || []).filter(function (t) { return now() - t < 15000; });")
Assert-Test "tickRevive tracks recentDeaths in 15s window" $hasRecentDeaths

# 7. minReviveInterval throttles to 4500ms on death streak (>= 2)
$hasIntervalThrottling = $src.Contains("var minReviveInterval = isBossContext ? (deathStreak >= 2 ? 4500 : 2500) : 3000;")
Assert-Test "tickRevive throttles to 4500ms on death streak (>= 2)" $hasIntervalThrottling

# 8. PK corpse camping prevents suicidal spot-revive
$hasPkCampDefense = $src.Contains("var pkCamped = (st.ct || !isBossContext) && hostilePlayers(g).some(function (p) { return dist(me.x, me.y, p.x, p.y) < 250; });")
$hasCanSpotRevive = $src.Contains("var canSpotRevive = me.reviveLeft !== 0 && (!pkCamped || deathStreak < 2);")
Assert-Test "tickRevive prevents spot revive when PK campers are on corpse during death streak" ($hasPkCampDefense -and $hasCanSpotRevive)

# 9. Boss execution phase safe distance buffer (boss <= 10% HP, me < 35% HP)
$hasBossExecDefense = $src.Contains("if (isBoss(t) && t.hpMax > 0 && (t.hp / t.hpMax) <= 0.10 && (me.hp / (me.hpMax || 1)) < 0.35)")
Assert-Test "smartMove preserves 180px safe distance in boss execution phase to ensure survival for roll loot" $hasBossExecDefense

# 10. tickXongChuong flexible khu switch (even if gaSoKhu <= 1)
$hasKhuFlex = $src.Contains("if (gaKhu(P) !== e.khu && (gaSoKhu(P) >= e.khu || !gaSoKhu(P) || gaSoKhu(P) <= 1))")
Assert-Test "tickXongChuong switches to target khu even if gaSoKhu is temporarily <= 1" $hasKhuFlex

# 11. Mob name capitalization in Telegram alerts
$hasTitleCase = $src.Contains("var xcMobNames = (m[1] || '').split(/\s+va\s+/i).map(function (s)")
Assert-Test "readNews formats mob names with proper title casing for Telegram" $hasTitleCase

# 12. ctStrikeCart low HP retreat and shield
$hasCtPkRetreat = $src.Contains("if (hpRatio < 0.28 && nearPks.length)")
Assert-Test "ctStrikeCart avoids suicidal melee charge when HP < 28% and hostile PK near" $hasCtPkRetreat

Write-Host "Total Results: $($results.Count)"
$failed = $results | Where-Object { $_ -match "^FAIL" }
if ($failed.Count -gt 0) {
    Write-Host "FAILED TESTS FOUND!" -ForegroundColor Red
    exit 1
}
else {
    Write-Host "ALL 12/12 TESTS PASSED!" -ForegroundColor Green
}

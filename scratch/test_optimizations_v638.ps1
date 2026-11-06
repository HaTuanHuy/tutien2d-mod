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

# 1. Version check
Assert-Test "Version header is 0.63.8" ($src -match "@version\s+0\.63\.8" -and $src -match "var VERSION = '0\.63\.8'")

# 2. TG_EV ordering (vt before ct)
$idxVt = $src.IndexOf("['vt', 'Vận Tiêu'")
$idxCt = $src.IndexOf("['ct', 'Cướp tiêu'")
Assert-Test "TG_EV has 'vt' before 'ct' to prioritize escort over rob" ($idxVt -ge 0 -and $idxCt -ge 0 -and $idxVt -lt $idxCt)

# 3. tickStandalone before tickCuopTieu in tick()
$idxTickStandalone = $src.IndexOf("if (tickStandalone(g)) return;")
$idxTickCuopTieu = $src.IndexOf("if (tickCuopTieu(g)) return;")
Assert-Test "tick() calls tickStandalone(g) before tickCuopTieu(g)" ($idxTickStandalone -ge 0 -and $idxTickCuopTieu -ge 0 -and $idxTickStandalone -lt $idxTickCuopTieu)

# 4. tickCuopTieu yields if vtActive or st.vt
$hasVtCheckInCt = $src.Contains("if (vtActive(g) || st.vt || (cfg.vtRun && !st.ct)) return false;")
Assert-Test "tickCuopTieu() immediately yields if vtActive(g) or st.vt" $hasVtCheckInCt

# 5. Cross-map camp navigation in tickCuopTieu
$hasCrossMapCamp = $src.Contains("if (cp && cp.map && cp.map !== g.mapId)")
$hasStartTravelCamp = $src.Contains("startTravel(cp.map, cp.x, cp.y, 'Cướp tiêu: sang ' + mapName(cp.map) + ' camp');")
Assert-Test "tickCuopTieu() starts travel when camp map differs from current map" ($hasCrossMapCamp -and $hasStartTravelCamp)

# 6. ctStation returns camp point across maps
$hasCampFallback = $src.Contains("return cp || ctCamp(g);")
Assert-Test "ctStation() preserves cp across maps without forcing ctCamp" $hasCampFallback

# 7. Role reset in tickCuopTieu when cart is lost
$hasRoleReset = $src.Contains("if (a.role === 'hạ người kéo' || a.role === 'đánh xe') { a.role = null; a.pk = false; }")
Assert-Test "tickCuopTieu() clears stale 'hạ người kéo' role when cart is lost" $hasRoleReset

# 8. World Boss post-revive safety buffer
$hasReviveGrace = $src.Contains("st.reviveGraceUntil = now() + 3500;")
$hasReachGrace = $src.Contains("if (now() < (st.reviveGraceUntil || 0) && isBoss(t) && me.hp / (me.hpMax || 1) < 0.45)")
$hasKiteGrace = $src.Contains("if (wbk && !(now() < (st.reviveGraceUntil || 0) && me.hp / (me.hpMax || 1) < 0.40))")
Assert-Test "tickRevive() sets st.reviveGraceUntil = now() + 3500" $hasReviveGrace
Assert-Test "smartMove() keeps 180px safe reach during grace period for low HP" $hasReachGrace
Assert-Test "tickKite() allows kiting buffer during grace period for low HP" $hasKiteGrace

# 9. Smart free movement & stayFarm pause
$hasManualTracking = $src.Contains("if (g && g.P && g.P.Input && g.P.Input.hasManualMove && g.P.Input.hasManualMove()) { st.lastManualAt = now(); }")
$hasManualGraceInStayFarm = $src.Contains("var manualRecent = (now() - (st.lastManualAt || 0)) < 15000;")
$hasStayFarmPaused = $src.Contains("st.stayFarmPaused = true;")
$hasUnpauseSetFarm = $src.Contains("st.stayFarmPaused = false;")
Assert-Test "tick() tracks st.lastManualAt on manual input" $hasManualTracking
Assert-Test "tickStayFarm() respects 15s manual movement grace period" $hasManualGraceInStayFarm
Assert-Test "tickStayFarm() pauses when player manually travels to another map" $hasStayFarmPaused
Assert-Test "setFarm and revive reset st.stayFarmPaused" $hasUnpauseSetFarm

# 10. Chat hook Thiên Đạo robustness
$hasChatHookRobust = $src.Contains("var isTd = (o && o.authorId === 'thien_dao') || (who && plainVi(who) === 'thien dao') || /^(?:\[?(?:thien dao|he thong)\]?|thien dao:|he thong:)/i.test(plainVi(text));")
Assert-Test "hookChat captures Thiên Đạo even without who or with custom prefix" $hasChatHookRobust

# 11. Escaped beasts announcement regex verification
$rawMsg = "Thiên Đạo: Ba Xích Nhãn Ngưu và ba Bạch Hổ Tuyết sắp xổng chuồng tại Bãi Đá, khu 20 (20 giây nữa)!"
$plain = [System.Text.Encoding]::ASCII.GetString([System.Text.Encoding]::GetEncoding("Cyrillic").GetBytes($rawMsg.Normalize([System.Text.NormalizationForm]::FormD)))
$t = [regex]::Replace($rawMsg.ToLower(), "[\u0300-\u036f]", "")
$t = $t.Replace("đ", "d").Replace("Đ", "d")
$t = [regex]::Replace($t, "^(?:\[?(?:thien dao|he thong|thong bao)\]?|\(thien dao\))[\s:–-]*", "").Trim()
$m = [regex]::Match($t, "^(.+?)\s+(?:vua|sap|da)?\s*(?:xong chuong|xuat hien|giang the|tu tap)\s+(?:tai|o)\s+(.+?),?\s*khu\s+(\d+)")
Assert-Test "Regex parses beasts announcement correctly" ($m.Success -and $m.Groups[1].Value.Trim() -eq "ba xich nhan nguu va ba bach ho tuyet" -and $m.Groups[2].Value.Trim() -eq "bai da" -and $m.Groups[3].Value -eq "20")

Write-Host "Total Results: $($results.Count)"
$failed = $results | Where-Object { $_ -match "^FAIL" }
if ($failed.Count -gt 0) {
    Write-Host "FAILED TESTS FOUND!" -ForegroundColor Red
    exit 1
}
else {
    Write-Host "ALL TESTS PASSED!" -ForegroundColor Green
}


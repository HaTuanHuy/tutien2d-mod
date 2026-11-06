$msg = "Thiên Đạo: Ba Xích Nhãn Ngưu và ba Bạch Hổ Tuyết sắp xổng chuồng tại Bãi Đá, khu 20 (20 giây nữa)!"

# Let's inspect plainVi logic from helper
# Helper plainVi:
# function plainVi(s) {
#   return String(s || '').toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd');
# }

$plainVi = {
    param($s)
    $normalized = $s.Normalize([System.Text.NormalizationForm]::FormD)
    $sb = New-Object System.Text.StringBuilder
    foreach ($ch in $normalized.ToCharArray()) {
        $cat = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($ch)
        if ($cat -ne [System.Globalization.UnicodeCategory]::NonSpacingMark) {
            [void]$sb.Append($ch)
        }
    }
    return $sb.ToString().ToLower().Replace('đ', 'd').Replace('Đ', 'd')
}

$t = & $plainVi $msg
Write-Output "plainVi: $t"

# Step 1: line 5154:
# t = t.replace(/^(?:\[?(?:thien dao|he thong|thong bao)\]?|\(thien dao\))[\s:–-]*/i, '').trim();
$tClean = [System.Text.RegularExpressions.Regex]::Replace($t, '^(?:\[?(?:thien dao|he thong|thong bao)\]?|\(thien dao\))[\s:–-]*', '').Trim()
Write-Output "Cleaned t: $tClean"

# Step 2: line 5177 regex:
# /^(.+?)\s+(?:vua|sap|da)?\s*(?:xong chuong|xuat hien|giang the|tu tap)\s+(?:tai|o)\s+(.+?),?\s*khu\s+(\d+)/
$pattern = '^(.+?)\s+(?:vua|sap|da)?\s*(?:xong chuong|xuat hien|giang the|tu tap)\s+(?:tai|o)\s+(.+?),?\s*khu\s+(\d+)'
$match = [System.Text.RegularExpressions.Regex]::Match($tClean, $pattern)
if ($match.Success) {
    Write-Output "Match success!"
    Write-Output "m[1] (what): $($match.Groups[1].Value)"
    Write-Output "m[2] (map): $($match.Groups[2].Value)"
    Write-Output "m[3] (khu): $($match.Groups[3].Value)"
    
    $delayM = [System.Text.RegularExpressions.Regex]::Match($tClean, '\((\d+)\s*giay\s*nua\)')
    if ($delayM.Success) {
        Write-Output "delayM: $($delayM.Groups[1].Value) seconds"
    }
} else {
    Write-Output "Regex did NOT match!"
}


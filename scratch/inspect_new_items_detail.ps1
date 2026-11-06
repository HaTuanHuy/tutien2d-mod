$itemsNew = Get-Content "src/systems/items.180013ea6985.js" -Raw
$newIds = @(
  "tam_yeu_linh_boi", "huyen_thiet_phu", "thanh_minh_kiem", "dan_hon_dang",
  "hang_ma_xu", "hong_lang", "hao_nhien_truc_gian", "bach_van_phat_tran",
  "huyet_dao", "huyet_kich", "bi_tich_huyet_mau_xuyen_tam", "bi_tich_huyet_hai_phien_thien",
  "bi_tich_huyet_te_ma_dong", "bi_tich_huyet_co_phe_tam", "bi_tich_huyet_anh_tam_cham",
  "bi_tich_thanh_an_ho_the", "bi_tich_thien_thu_giang_the", "bi_tich_truc_gian_tam_tinh",
  "bi_tich_chu_phe_dinh_toi", "bi_tich_hao_nhien_thuan", "bi_tich_thien_dia_vi_ky",
  "bi_tich_hoa_dia_vi_lao", "bi_tich_mac_truc_binh_phong", "bi_tich_thanh_long_ngam_nho",
  "bi_tich_son_ha_nhap_hoa_nho", "van_khuc_thu", "mac_tu", "huyet_phach_chau", "huyet_hon"
)

foreach ($id in $newIds) {
    # Find definition in itemsNew
    $regex = [regex]"$id\s*:\s*\{([^}]+)\}"
    $match = $regex.Match($itemsNew)
    if ($match.Success) {
        $body = $match.Groups[1].Value
        $nameMatch = [regex]::Match($body, 'name\s*:\s*["'']([^"'']+)["'']')
        $gradeMatch = [regex]::Match($body, 'grade\s*:\s*["'']([^"'']+)["'']')
        $typeMatch = [regex]::Match($body, 'type\s*:\s*["'']([^"'']+)["'']')
        Write-Host "$id -> name: '$($nameMatch.Groups[1].Value)', grade: '$($gradeMatch.Groups[1].Value)', type: '$($typeMatch.Groups[1].Value)'"
    } else {
        Write-Host "$id -> NOT MATCHED BY SIMPLE REGEX"
    }
}


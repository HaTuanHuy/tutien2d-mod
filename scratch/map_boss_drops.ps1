$lootContent = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\systems\loot.ef0f82c62597.js", [System.Text.Encoding]::UTF8)
$itemsContent = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\systems\items.a77e8598ad05.js", [System.Text.Encoding]::UTF8)

# Helper function to get item info
function Get-ItemInfo($id) {
    $pat = '(?s)"' + [regex]::Escape($id) + '"\s*:\s*\{name\s*:\s*"([^"]+)"(?:,\s*kind\s*:\s*"([^"]+)")?(?:,\s*grade\s*:\s*"([^"]+)")?'
    if ($itemsContent -match $pat) {
        return "$($matches[1]) | Grade: $($matches[3]) | Kind: $($matches[2])"
    }
    return "(Not in items.js or different format)"
}

Write-Host "=== 1. BOSS THẾ GIỚI (WORLD BOSSES) ==="
$wb = @(
    "than_thu_xich_long", "linh_ho_tran_son", "nhen_bach_ngoc", "song_duc_ma_bao"
)

Write-Host "--- A. THAN THU XICH LONG ---"
$xich_long_items = @(
    "hoang_lan_giap", "xich_long_huyet", "bach_nguyet_hong_lien", "van_lo_lao_ma_bao",
    "tong_mon_lenh", "yeu_dan_cap_3", "linh_thach",
    "bi_tich_van_kiem_quy_tong", "bi_tich_ma_bao_an", "bi_tich_thien_quan_truy", "bi_tich_mong_diep_me_tran",
    "tay_tam_dan", "pha_canh_dan"
)
foreach ($it in $xich_long_items) { Write-Host "  - $it : $(Get-ItemInfo $it)" }

Write-Host "`n--- B. LINH HO TRAN SON ---"
$linh_ho_items = @(
    "ngua_hac_tho", "yeu_dan_cap_4", "yeu_huyet_cap_4", "tong_mon_lenh", "linh_thach",
    "bach_nguyet_hong_lien", "van_lo_lao_ma_bao",
    "nhan_xich_viem", "nhan_huyen_nham", "nhan_thanh_moc", "giay_xich_viem", "giay_thanh_moc", "giay_huyen_nham",
    "bi_tich_van_kiem_quy_tong", "bi_tich_ma_bao_an", "bi_tich_thien_quan_truy", "bi_tich_mong_diep_me_tran",
    "tay_tam_dan", "phi_dao", "bich_nguc_ta_dao", "pha_canh_dan"
)
foreach ($it in $linh_ho_items) { Write-Host "  - $it : $(Get-ItemInfo $it)" }

Write-Host "`n--- C. NHEN BACH NGOC ---"
$nhen_items = @(
    "yeu_dan_cap_5", "linh_thach", "tong_mon_lenh",
    "hoa_kim_thuong", "hoang_loi_thuong", "bang_linh_kiem", "thanh_tieu_ngoc_cam", "hac_vu_ma_phien", "pha_son_chuy", "huyet_lien_tram",
    "nhan_xich_viem", "nhan_huyen_nham", "nhan_thanh_moc", "giay_xich_viem", "giay_thanh_moc", "giay_huyen_nham",
    "co_bich_moc", "tran_than_thach", "xuyen_son_thiet_giap", "xich_viem_song_kich", "huyet_ma_phu", "hu_anh_phi_hanh"
)
foreach ($it in $nhen_items) { Write-Host "  - $it : $(Get-ItemInfo $it)" }

Write-Host "`n--- D. SONG DUC MA BAO ---"
$song_duc_items = @(
    "yeu_dan_cap_6", "ruong_phi_hanh", "phong_song_duc", "yeu_huyet_cap_6", "tong_mon_lenh", "linh_thach",
    "quan_dui", "tuyet_son_kiem_y", "man_ho_tu_y", "than_kiem_y", "thanh_tam_y",
    "nhan_xich_viem", "nhan_huyen_nham", "nhan_thanh_moc", "giay_xich_viem", "giay_thanh_moc", "giay_huyen_nham",
    "bi_tich_huyen_anh_ma_tram", "bi_tich_phi_long_tai_thien", "bi_tich_cuu_u_ma_trao", "bi_tich_ma_hon_phe",
    "bi_tich_nguyet_quang", "bi_tich_kim_quang_cu_kiem", "bi_tich_ngu_sac_than_chuong", "bi_tich_loi_thuong_quan_dia",
    "bi_tich_ngu_loi_thuong_vu", "bi_tich_huyet_nguyet_am_thuc", "bi_tich_am_huyet_ma_chuong", "bi_tich_ngu_hoa_thuong_vu",
    "bi_tich_ham_thien_thu", "bi_tich_bang_son_quyen", "bi_tich_xich_nhat_quyen_an", "bi_tich_khai_bi_chuong",
    "bi_tich_thien_ma_lien_vu", "bi_tich_hong_tu_doat_menh", "bi_tich_ho_diep_phe_tam", "bi_tich_diep_anh_bo",
    "hoang_loi_thuong", "bang_linh_kiem", "tay_tam_dan", "phi_dao", "bich_nguc_ta_dao", "pha_canh_dan"
)
foreach ($it in $song_duc_items) { Write-Host "  - $it : $(Get-ItemInfo $it)" }


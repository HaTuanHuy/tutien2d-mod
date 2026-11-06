$lootContent = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\systems\loot.ef0f82c62597.js", [System.Text.Encoding]::UTF8)

# Let's extract all keys and arrays from loot.js
$patterns = @(
    'RARE_GEAR\s*=\s*\[(.*?)\]',
    'HUYET_SAC_BOSSES\s*=\s*\[(.*?)\]',
    'MA_BAO_Y_PHUC\s*=\s*\[(.*?)\]',
    'MA_BAO_BI_TICH_KET_DAN\s*=\s*\[(.*?)\]',
    'ROI_THE_TU\s*=\s*\[(.*?)\]',
    'ROI_HOP_HOAN\s*=\s*\[(.*?)\]',
    'NHEN_BACH_NGOC_THUONG\s*=\s*\[(.*?)\]',
    'GIOI_NGOA_YEU_THU\s*=\s*\{(.*?)\}',
    'HO_PHAP_MA_BAO\s*=\s*\{(.*?)\}',
    'YEU_HUYET\s*=\s*\{(.*?)\}',
    'TONG_MON_LENH\s*=\s*\{(.*?)\}',
    'BOSS_LINH_THACH\s*=\s*\{(.*?)\}',
    'GIUA_TRAN\s*=\s*\{(.*?)\}',
    'GLOW_ITEMS\s*=\s*\{(.*?)\}',
    'PHU_CHU_ROI\s*=\s*\[(.*?)\]',
    'YEU_DAN\s*=\s*\{(.*?)\}',
    'YEU_DAN_CHOT_HA\s*=\s*\{(.*?)\}',
    'RUONG_CHOT_HA\s*=\s*\{(.*?)\}',
    'BOC_THAM_TUI\s*=\s*\{(.*?)\}'
)

foreach ($pat in $patterns) {
    if ($lootContent -match $pat) {
        Write-Host "MATCH: $pat"
        Write-Host $matches[0]
        Write-Host "--------------------------------"
    }
}


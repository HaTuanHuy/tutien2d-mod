$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("Chủ động áp sát chạm tâm rơi d <= 2px NGAY TỪ ĐẦU")
if ($idx -ge 0) {
    Write-Host $helper.Substring([Math]::Max(0, $idx - 200), 1000)
}


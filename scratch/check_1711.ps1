# Read scan_telegram_new.ps1 results or query Telegram for messages around 17:10 - 17:15
$token = "9150216542:AAHeVP98CJGWalj8GobUnuYGTgYD-RULCjM"
$chatId = "-1004343654191"

# Let's inspect the files in scratch or check downloaded messages
$files = Get-ChildItem "d:\Tutien2d\tutien2d.com\scratch\*.txt" | Where-Object { $_.Name -match '171[12]' }
foreach ($f in $files) {
    Write-Output "=== File: $($f.Name) ==="
    Get-Content $f.FullName | Select-Object -First 20
}


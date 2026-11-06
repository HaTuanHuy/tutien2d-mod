# Search message IDs from 50 to 320 for "khu 20" or "Bãi Đá"
$token = "9150216542:AAHeVP98CJGWalj8GobUnuYGTgYD-RULCjM"
$chatId = "-1004343654191"

for ($i = 100; $i -le 250; $i++) {
    try {
        $body = @{
            chat_id      = $chatId
            from_chat_id = $chatId
            message_id   = $i
        } | ConvertTo-Json
        $res = Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/forwardMessage" -Method Post -ContentType "application/json" -Body $body
        $txt = $res.result.text
        if ($res.result.caption) { $txt = "[Caption: " + $res.result.caption + "]" }
        $dupId = $res.result.message_id
        Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/deleteMessage?chat_id=$chatId&message_id=$dupId" | Out-Null
        
        if ($txt -match 'xổng chuồng|xong chuong|khu 20') {
            $dateStr = (Get-Date "1970-01-01 00:00:00").AddSeconds($res.result.date).ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss")
            Write-Output ("[$dateStr] Msg $i : $txt")
        }
    }
    catch {
    }
}


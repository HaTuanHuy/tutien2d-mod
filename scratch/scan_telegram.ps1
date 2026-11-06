$token = "9150216542:AAHeVP98CJGWalj8GobUnuYGTgYD-RULCjM"
$chatId = "-1004343654191"

Write-Output "Scanning Telegram messages from 38 to 250..."

$found = 0
for ($i = 38; $i -le 250; $i++) {
    try {
        $body = @{
            chat_id      = $chatId
            from_chat_id = $chatId
            message_id   = $i
        } | ConvertTo-Json
        $res = Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/forwardMessage" -Method Post -ContentType "application/json" -Body $body
        $txt = $res.result.text
        if ($res.result.caption) { $txt = "[Caption: " + $res.result.caption + "]" }
        $doc = $res.result.document
        $docName = if ($doc) { $doc.file_name } else { "" }
        $fileId = if ($doc) { $doc.file_id } else { "" }
        Write-Output ("Msg {0}: text={1} | doc={2} | fileId={3}" -f $i, ($txt -replace "`n", " / "), $docName, $fileId)
        $found++
        $dupId = $res.result.message_id
        Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/deleteMessage?chat_id=$chatId&message_id=$dupId" | Out-Null
    }
    catch {
        # ignore missing IDs
    }
}
Write-Output "Scan complete. Found $found messages."


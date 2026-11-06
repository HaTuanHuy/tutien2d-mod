$token = "9150216542:AAHeVP98CJGWalj8GobUnuYGTgYD-RULCjM"
$chatId = "-1004343654191"

for ($i = 4; $i -le 25; $i++) {
    try {
        $body = @{
            chat_id = $chatId
            from_chat_id = $chatId
            message_id = $i
        } | ConvertTo-Json
        $res = Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/forwardMessage" -Method Post -ContentType "application/json" -Body $body
        Write-Output ("Found msg {0}: text={1}, hasDoc={2}" -f $i, $res.result.text, [bool]$res.result.document)
        if ($res.result.document) {
            $docJson = $res.result.document | ConvertTo-Json -Depth 3
            Write-Output ("Doc: " + $docJson)
        }
        # Delete forwarded copy
        $dupId = $res.result.message_id
        Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/deleteMessage?chat_id=$chatId&message_id=$dupId" | Out-Null
    } catch {
        # ignore missing message IDs
    }
}


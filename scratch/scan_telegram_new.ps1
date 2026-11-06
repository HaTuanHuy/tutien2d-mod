$token = "9150216542:AAHeVP98CJGWalj8GobUnuYGTgYD-RULCjM"
$chatId = "-1004343654191"

Write-Output "Scanning Telegram messages from 170 to 400..."

$found = 0
$docs = @()
for ($i = 170; $i -le 400; $i++) {
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
        
        $dateStr = (Get-Date "1970-01-01 00:00:00").AddSeconds($res.result.date).ToLocalTime().ToString("HH:mm:ss")
        Write-Output ("[{0}] Msg {1}: text={2} | doc={3} | fileId={4}" -f $dateStr, $i, ($txt -replace "`n", " / "), $docName, $fileId)
        $found++
        if ($doc) {
            $docs += @{
                msgId = $i
                fileName = $docName
                fileId = $fileId
                date = $dateStr
            }
        }
        $dupId = $res.result.message_id
        Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/deleteMessage?chat_id=$chatId&message_id=$dupId" | Out-Null
    }
    catch {
        # ignore missing IDs
    }
}
Write-Output "Scan complete. Found $found messages."

if ($docs.Count -gt 0) {
    Write-Output "Downloading $($docs.Count) documents..."
    foreach ($d in $docs) {
        try {
            $finfo = Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/getFile?file_id=$($d.fileId)" -Method Get
            $fpath = $finfo.result.file_path
            $outPath = "d:\Tutien2d\tutien2d.com\scratch\$($d.fileName)"
            Invoke-WebRequest -Uri "https://api.telegram.org/file/bot$token/$fpath" -OutFile $outPath
            Write-Output "Saved: $outPath ($($d.fileName))"
        } catch {
            Write-Output "Failed to download $($d.fileName): $_"
        }
    }
}


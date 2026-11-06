$token = "9150216542:AAHeVP98CJGWalj8GobUnuYGTgYD-RULCjM"
$chatId = "-1004343654191"

# Get updates
$res = Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/getUpdates?offset=-100" -Method Get
Write-Host "Total updates received: $($res.result.Count)"

$messages = @()
foreach ($u in $res.result) {
    $m = $u.message
    if (-not $m) { $m = $u.channel_post }
    if (-not $m) { $m = $u.edited_message }
    if ($m) {
        $messages += $m
    }
}

Write-Host "Found $($messages.Count) messages."

# Show summary of latest messages
$recent = $messages | Sort-Object message_id -Descending | Select-Object -First 35
foreach ($m in ($recent | Sort-Object message_id)) {
    $time = (Get-Date "1970-01-01 00:00:00").AddSeconds($m.date).ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss")
    $text = $m.text
    $caption = $m.caption
    $doc = $m.document
    if ($doc) {
        Write-Host "[$time] (ID: $($m.message_id)) [DOC: $($doc.file_name) ($($doc.file_size) bytes)] Caption: $caption" -ForegroundColor Yellow
    }
    elseif ($text) {
        $firstLine = ($text -split "`n")[0]
        if ($text.Length -gt 100) { $firstLine = $text.Substring(0, 100) + "..." }
        Write-Host "[$time] (ID: $($m.message_id)) $firstLine"
    }
}


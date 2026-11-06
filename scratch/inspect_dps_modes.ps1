$helper = Get-Content "tutien2d-helper.user.js" -Raw

# 1. Inspect choose around mode
$idx1 = $helper.IndexOf("var mode = player || boss")
if ($idx1 -ge 0) {
    Write-Host "--- choose() context ---"
    Write-Host $helper.Substring([Math]::Max(0, $idx1 - 200), 500)
}

# 2. Inspect autoMpTal usage
$idx2 = $helper.IndexOf("autoMpTal")
while ($idx2 -ge 0) {
    Write-Host "`n--- autoMpTal context at $idx2 ---"
    Write-Host $helper.Substring([Math]::Max(0, $idx2 - 100), 300)
    $idx2 = $helper.IndexOf("autoMpTal", $idx2 + 1)
}


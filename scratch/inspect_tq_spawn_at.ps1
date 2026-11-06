$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("ev.spawnAt")
while ($idx -ge 0) {
    Write-Host $helper.Substring([Math]::Max(0, $idx - 50), 300)
    Write-Host "---"
    $idx = $helper.IndexOf("ev.spawnAt", $idx + 1)
}


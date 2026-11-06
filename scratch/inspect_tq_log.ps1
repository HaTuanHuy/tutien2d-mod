$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("tqLog")
while ($idx -ge 0) {
    Write-Host $helper.Substring([Math]::Max(0, $idx - 50), 300)
    Write-Host "---"
    $idx = $helper.IndexOf("tqLog", $idx + 1)
}


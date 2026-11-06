$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("bdEvents")
if ($idx -ge 0) {
    Write-Host $helper.Substring([Math]::Max(0, $idx - 100), 700)
}


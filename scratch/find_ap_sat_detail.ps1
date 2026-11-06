$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("áp sát chạm tâm boss px = 0")
if ($idx -ge 0) {
    Write-Host $helper.Substring([Math]::Max(0, $idx - 300), 1000)
}


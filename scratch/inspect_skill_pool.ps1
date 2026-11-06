$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("function skillPool")
if ($idx -ge 0) {
    Write-Host $helper.Substring($idx, 2000)
}


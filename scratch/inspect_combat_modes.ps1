$helper = Get-Content "tutien2d-helper.user.js" -Raw

# Search for mode in choose function
$idx = $helper.IndexOf("var mode =")
if ($idx -ge 0) {
    Write-Host $helper.Substring($idx - 100, 300)
}

# Search for healHp default
$idx2 = $helper.IndexOf("healHp")
if ($idx2 -ge 0) {
    Write-Host $helper.Substring($idx2 - 50, 200)
}


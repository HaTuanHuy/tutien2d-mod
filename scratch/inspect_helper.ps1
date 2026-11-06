$helper = Get-Content "tutien2d-helper.user.js" -Raw
Write-Host "Helper length: $($helper.Length) characters"

# Search for sect references
$sects = @("kiem", "the", "quy", "hop", "nho", "huyet")
foreach ($s in $sects) {
    $count = ([regex]::Matches($helper, $s, "IgnoreCase")).Count
    Write-Host "Match '$s': $count"
}

# Search for LOOT_SPECIAL_SCORES
if ($helper -match 'LOOT_SPECIAL_SCORES\s*=\s*\{([^}]+)\}') {
    Write-Host "`nLOOT_SPECIAL_SCORES found:"
    Write-Host $matches[1]
}


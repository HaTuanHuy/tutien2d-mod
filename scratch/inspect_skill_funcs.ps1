$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, '(?:cast|dung|chieu|skill)[a-zA-Z0-9_]*\s*\(')
$set = [System.Collections.Generic.HashSet[string]]::new()
foreach ($m in $matches) {
    if ($set.Add($m.Value)) {
        Write-Host $m.Value
    }
}


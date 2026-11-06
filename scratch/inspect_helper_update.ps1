$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, '(?:phiên bản|codebase|source|mới|update|sync)[a-zA-Z0-9_]*', "IgnoreCase")
$set = [System.Collections.Generic.HashSet[string]]::new()
foreach ($m in $matches) {
    if ($set.Add($m.Value)) {
        Write-Host $m.Value
    }
}


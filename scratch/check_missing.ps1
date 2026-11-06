$rootHtml = Get-Content "rootfile" -Raw
$matches = [regex]::Matches($rootHtml, '(src|href)=["'']([^"'']+\.(?:js|css))["'']')
$total = $matches.Count
$missing = @()
foreach ($m in $matches) {
    $path = $m.Groups[2].Value.TrimStart('/')
    if (-not (Test-Path $path)) {
        $missing += $path
    }
}
Write-Host "Total assets referenced in rootfile: $total"
Write-Host "Missing assets: $($missing.Count)"
foreach ($miss in $missing) {
    Write-Host " - $miss"
}


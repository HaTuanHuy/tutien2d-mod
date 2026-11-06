$html = Get-Content "rootfile" -Raw
$matches = [regex]::Matches($html, '<script[^>]*src="[^"]*(?:runtime-config|manifest|supabase)[^"]*"')
foreach ($m in $matches) {
    Write-Host $m.Value
}


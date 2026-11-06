$baseUrl = "https://tutien2d.com"
$files = @("runtime-config.js", "vendor/supabase.js", "assets/manifest.js")

foreach ($f in $files) {
    $target = Join-Path "d:\Tutien2d\tutien2d.com" ($f -replace '/', '\')
    $dir = Split-Path $target -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    
    $url = "$baseUrl/$f"
    $res = curl.exe -s -w "%{http_code}" -o $target $url
    Write-Host "$f : HTTP $res (Size: $((Get-Item $target).Length) bytes)"
}


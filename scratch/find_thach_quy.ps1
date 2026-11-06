$files = Get-ChildItem -Path 'src' -Recurse -Filter '*.js'
foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    $matches = [regex]::Matches($content, '(?i)(thach_quy|thạch quỷ|bien_di|biến dị)')
    if ($matches.Count -gt 0) {
        Write-Output "$($f.Name): $($matches.Count) matches"
    }
}


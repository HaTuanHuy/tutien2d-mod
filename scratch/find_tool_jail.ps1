$files = Get-ChildItem -Path 'src' -Recurse -Filter '*.js'
foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    $matches = [regex]::Matches($content, '(?i)(phat\s*tu|thiên\s*lao|thien\s*lao|giam\s*giu|cai_nguc)')
    if ($matches.Count -gt 0) {
        Write-Output "$($f.Name): $($matches.Count) matches"
    }
}


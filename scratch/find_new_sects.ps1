$files = Get-ChildItem -Path 'src' -Recurse -Filter '*.js'
foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    if ($content.Contains('nho_tu') -or $content.Contains('huyet_tu') -or $content.Contains('Nho Tu') -or $content.Contains('Huyết Tu')) {
        Write-Output "File: $($f.Name)"
    }
}


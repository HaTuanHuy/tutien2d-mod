$files = Get-ChildItem -Path 'src' -Recurse -Filter '*.js'
foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    if ($content.Contains('.HacThiUI') -or $content.Contains('.HacThi') -and $content.Contains('act:"giam"')) {
        Write-Output "File: $($f.Name)"
    }
}


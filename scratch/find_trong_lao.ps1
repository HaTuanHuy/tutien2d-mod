$files = Get-ChildItem -Path 'src' -Recurse -Filter '*.js'
foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    $idx = $content.IndexOf('trongLao')
    if ($idx -ge 0) {
        $start = [Math]::Max(0, $idx - 50)
        $len = [Math]::Min(200, $content.Length - $start)
        Write-Output "$($f.Name): $($content.Substring($start, $len))"
    }
}


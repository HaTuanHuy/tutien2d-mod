$files = Get-ChildItem -Path 'src/world' -Filter '*.js'
foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    $idx = $content.IndexOf('bat_quai_thach_phan')
    if ($idx -ge 0) {
        Write-Output "$($f.Name): $idx"
    }
}


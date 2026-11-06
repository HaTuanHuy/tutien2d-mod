$files = Get-ChildItem 'd:\Tutien2d\tutien2d.com\src\world\*.js'
foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    $idx = $content.IndexOf('bai_da_hang_gio')
    if ($idx -ge 0) {
        $start = [Math]::Max(0, $idx - 50)
        $len = [Math]::Min(200, $content.Length - $start)
        Write-Output ($f.Name + " : " + $content.Substring($start, $len))
    }
}


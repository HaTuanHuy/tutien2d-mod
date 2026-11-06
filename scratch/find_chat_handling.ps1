$files = Get-ChildItem -Path "d:\Tutien2d\tutien2d.com\src" -Recurse -Filter "*.js"
foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText($f.FullName)
    if ($c.Contains("world_chat") -or $c.Contains("thien_dao") -or $c.Contains("Thiên Đạo")) {
        Write-Output "Found in $($f.FullName)"
    }
}


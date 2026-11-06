$files = Get-ChildItem -Path "d:\Tutien2d\tutien2d.com\src" -Recurse -Filter "*.js"
foreach ($f in $files) {
    $c = [System.IO.File]::ReadAllText($f.FullName)
    if ($c.Contains("KhuUI") -or $c.Contains("soKhu")) {
        Write-Output "Found in $($f.FullName)"
    }
}


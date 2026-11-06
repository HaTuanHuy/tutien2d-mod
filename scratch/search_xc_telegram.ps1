# Check what scan_telegram_new downloaded or printed
$files = Get-ChildItem "d:\Tutien2d\tutien2d.com\scratch\*.txt"
$found = 0
foreach ($f in $files) {
    $c = Get-Content $f.FullName -Raw
    if ($c -match 'xổng chuồng|xong chuong') {
        Write-Output "Found in $($f.Name):"
        Write-Output ($c.Substring(0, [Math]::Min(300, $c.Length)))
        $found++
    }
}
if ($found -eq 0) {
    Write-Output "NO scratch txt file contains 'xổng chuồng' or 'xong chuong'!"
}


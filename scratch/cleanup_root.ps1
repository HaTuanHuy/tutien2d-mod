$localRoot = "d:\Tutien2d\tutien2d.com"

# Xoa 997 file rac Tutien2d_* o thu muc goc
$mangledFiles = Get-ChildItem -Path $localRoot -Filter "Tutien2d_*"
Write-Host "Dang xoa $($mangledFiles.Count) file Tutien2d_* rac o thu muc goc..."
foreach ($f in $mangledFiles) {
    Remove-Item -Path $f.FullName -Force
}

# Di chuyen cac file log test o thu muc goc vao scratch
$logs = @("test_sec_out.txt", "test_speed_caravan_stderr.log", "test_speed_caravan_stdout.log")
foreach ($l in $logs) {
    $src = Join-Path $localRoot $l
    if (Test-Path $src) {
        $dest = Join-Path $localRoot "scratch" $l
        Move-Item -Path $src -Destination $dest -Force
        Write-Host "Da chuyen $l vao scratch/"
    }
}

Write-Host "Hoan tat don dep thu muc goc!"


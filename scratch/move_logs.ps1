Move-Item "d:/Tutien2d/tutien2d.com/test_sec_out.txt" "d:/Tutien2d/tutien2d.com/scratch/" -Force -ErrorAction SilentlyContinue
Move-Item "d:/Tutien2d/tutien2d.com/test_speed_caravan_stderr.log" "d:/Tutien2d/tutien2d.com/scratch/" -Force -ErrorAction SilentlyContinue
Move-Item "d:/Tutien2d/tutien2d.com/test_speed_caravan_stdout.log" "d:/Tutien2d/tutien2d.com/scratch/" -Force -ErrorAction SilentlyContinue
Write-Host "Moved logs to scratch."


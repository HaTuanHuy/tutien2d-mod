$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$url = "file:///d:/Tutien2d/tutien2d.com/scratch/test_v6316.html"

$output = & $edge --headless --disable-gpu --virtual-time-budget=3000 --allow-file-access-from-files --dump-dom $url
$output | Out-File -FilePath "scratch/test_output.txt" -Encoding utf8
Write-Host "Output length: $($output.Length)"
$output | Select-String "PASS|FAIL|SUMMARY"

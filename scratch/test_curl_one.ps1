$fileUrl = "https://tutien2d.com/runtime-config.js?v=7280d5320cd5"
$targetPath = "d:\Tutien2d\tutien2d.com\runtime-config.js"

$res = & curl.exe -s -w "%{http_code}" -o $targetPath "$fileUrl"
Write-Host "Result: '$res'"
Write-Host "Target length: $((Get-Item $targetPath).Length)"


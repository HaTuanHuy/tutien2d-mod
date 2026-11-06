$c = Get-Content "d:\Tutien2d\tutien2d.com\src\net\gateway.9b66608f1070.js" -Raw
$idx = $c.IndexOf('case"world_chat":')
if ($idx -ge 0) {
    Write-Host $c.Substring($idx, 200)
}
$idx2 = $c.IndexOf('case"world_say":')
if ($idx2 -ge 0) {
    Write-Host $c.Substring($idx2, 200)
}

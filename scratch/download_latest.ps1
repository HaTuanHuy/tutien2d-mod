$token = "9150216542:AAHeVP98CJGWalj8GobUnuYGTgYD-RULCjM"
$files = @(
  @{ Name = "bh-memooo-0337.txt"; Id = "BQACAgUAAyEGAAMBAubnLwADI2rqRrd7SnDNkC2XieOMyM_pAAEo3QACSx4AAlkbUFffFseYAAH1I3k9BA" },
  @{ Name = "LOI-bh-mewmew-0337.txt"; Id = "BQACAgUAAyEGAAMBAubnLwADJWrqRrsLsXi3yb-lkJIBCz3Do6AsAAJMHgACWRtQV3iVw1rRKc22PQQ" }
)
foreach ($f in $files) {
  $info = Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/getFile?file_id=$($f.Id)"
  $path = $info.result.file_path
  $out = "d:\Tutien2d\tutien2d.com\scratch\$($f.Name)"
  Invoke-WebRequest -Uri "https://api.telegram.org/file/bot$token/$path" -OutFile $out
  Write-Output ("Downloaded " + $f.Name + " (" + (Get-Item $out).Length + " bytes)")
}


$token = "9150216542:AAHeVP98CJGWalj8GobUnuYGTgYD-RULCjM"
$files = @(
  @{ Name = "vt-mewmew-1321.txt"; Id = "BQACAgUAAyEGAAMBAubnLwADrmrqz0JJNp7LUDqxMUIdem4qQIs5AALLIQACWRtYVwgDrZ16RFIsPQQ" },
  @{ Name = "LOI-ct-memooo-1316.txt"; Id = "BQACAgUAAyEGAAMBAubnLwADsGrqz7TQHbM4ajLL3-P2OFL_odYeAALNIQACWRtYVwEnaK4knI7hPQQ" },
  @{ Name = "LOI-bh-mewmew-1240.txt"; Id = "BQACAgUAAyEGAAMBAubnLwADhWrqxd_bYqiqVyaI9J7YU4E27mxoAAJ4HwACWRtQV5F9jl3CEvetPQQ" },
  @{ Name = "LOI-bh-mewmew-1228.txt"; Id = "BQACAgUAAyEGAAMBAubnLwADgGrqwqEsCqPAMFNTuadDeRc1TV-uAAJxHwACWRtQVxVYyg55zcrQPQQ" }
)
foreach ($f in $files) {
    try {
        $info = Invoke-RestMethod -Uri ("https://api.telegram.org/bot$token/getFile?file_id=" + $f.Id)
        $path = $info.result.file_path
        $out = "d:\Tutien2d\tutien2d.com\scratch\" + $f.Name
        Invoke-WebRequest -Uri ("https://api.telegram.org/file/bot$token/" + $path) -OutFile $out
        Write-Output ("Downloaded " + $f.Name + " (" + (Get-Item $out).Length + " bytes)")
    } catch {
        Write-Output ("Error downloading " + $f.Name + ": " + $_.Exception.Message)
    }
}

$c = [System.IO.File]::ReadAllText("D:\Tutien2d\tutien2d.com\src\ui\chat.e7461f3afc6b.js")
$idx = 0
while (($idx = $c.IndexOf("line", $idx)) -ge 0) {
    $start = [Math]::Max(0, $idx - 50)
    $len = [Math]::Min(150, $c.Length - $start)
    Write-Output "--- line at $idx ---"
    Write-Output $c.Substring($start, $len)
    $idx += 4
}


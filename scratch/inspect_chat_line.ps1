$c = [System.IO.File]::ReadAllText('D:\Tutien2d\tutien2d.com\src\ui\chat.e7461f3afc6b.js')
$idx = $c.IndexOf('chat-line', 16000)
Write-Output $c.Substring($idx, 600)

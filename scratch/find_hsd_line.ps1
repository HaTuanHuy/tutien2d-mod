$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$idx = $content.IndexOf('function handleServerData')
$lineNum = ($content.Substring(0, $idx) -split "`n").Count
Write-Output "handleServerData at line $lineNum"


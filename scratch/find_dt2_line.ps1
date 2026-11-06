$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$idx = $content.IndexOf('function doingText(')
$lineNum = ($content.Substring(0, $idx) -split "`n").Count
Write-Output "doingText at line $lineNum"


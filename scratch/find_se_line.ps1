$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$idx = $content.IndexOf('function setEnabled(')
$lineNum = ($content.Substring(0, $idx) -split "`n").Count
Write-Output "setEnabled at line $lineNum"


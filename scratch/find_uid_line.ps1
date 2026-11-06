$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$idx = $content.IndexOf('ui.doing.textContent = doingText(g);')
$lineNum = ($content.Substring(0, $idx) -split "`n").Count
Write-Output "ui.doing at line $lineNum"


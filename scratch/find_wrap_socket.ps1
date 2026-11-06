$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$idx = $content.IndexOf('function wrapSocketInstance')
if ($idx -ge 0) {
    Write-Output $content.Substring($idx, 1000)
}


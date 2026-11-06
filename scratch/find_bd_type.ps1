$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$idx = $content.IndexOf('function bdTypeByName')
Write-Output $content.Substring($idx, 400)


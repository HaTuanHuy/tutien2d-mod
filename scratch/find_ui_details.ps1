$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$idx = $content.IndexOf('host.id = ''ttbot-host''')
if ($idx -ge 0) {
    # search next 2000 chars
    Write-Output $content.Substring($idx, 1500)
}


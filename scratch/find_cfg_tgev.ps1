$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$idx = $content.IndexOf('tgEv_')
if ($idx -ge 0) {
    Write-Output $content.Substring([Math]::Max(0, $idx - 50), 300)
}


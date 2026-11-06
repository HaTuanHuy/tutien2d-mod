$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, 'tgEv_[a-zA-Z0-9_]+')
$matches | Select-Object -ExpandProperty Value -Unique


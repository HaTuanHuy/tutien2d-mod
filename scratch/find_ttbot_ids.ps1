$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, 'ttbot-[a-z]+')
$matches | Select-Object -ExpandProperty Value -Unique


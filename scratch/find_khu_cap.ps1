$content = [System.IO.File]::ReadAllText('tutien2d-helper.user.js')
$matches = [regex]::Matches($content, '(?i)(suc\s*chua|toi\s*da|max\s*nguoi|so\s*nguoi|100|50|20)')
$matches | Select-Object -First 20


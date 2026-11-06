$c = [System.IO.File]::ReadAllText('d:\Tutien2d\tutien2d.com\tutien2d-helper.user.js')

$idx = $c.IndexOf('function mapGraph')
if ($idx -ge 0) {
    Write-Output $c.Substring($idx, 800)
}


$content = [System.IO.File]::ReadAllText('src/systems/chinh_dao.67c4739d377f.js')
Write-Output $content.Substring(0, [Math]::Min(2000, $content.Length))


$helper = Get-Content "tutien2d-helper.user.js" -Raw
$matches = [regex]::Matches($helper, '.{0,40}tq.{0,40}', "IgnoreCase")
foreach ($m in $matches) {
    if ($m.Value -match '20|adv|thach_quy|báo') {
        Write-Host $m.Value.Trim()
    }
}


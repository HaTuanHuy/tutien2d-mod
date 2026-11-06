$content = Get-Content "scratch/out_v6316.html" -Raw
$matches = [regex]::Matches($content, '\[(PASS|FAIL|INFO)\][^<]+')
foreach ($m in $matches) {
    Write-Host $m.Value
}


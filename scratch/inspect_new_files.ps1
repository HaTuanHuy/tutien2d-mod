$files = @(
    "src/systems/nho_tu.e992c3b63b47.js",
    "src/systems/huyet_tu.1a156cccf04a.js",
    "src/systems/the_tu.39527648b118.js",
    "src/systems/hop_hoan.c6a317ae8580.js",
    "src/systems/chinh_dao.c6631ad42090.js",
    "src/systems/hac_thi.25808332226c.js",
    "src/ui/quaydao.83839f46f75f.js"
)

foreach ($f in $files) {
    Write-Host "=== $f ===" -ForegroundColor Yellow
    $c = [System.IO.File]::ReadAllText($f)
    Write-Host $c.Substring(0, [Math]::Min(500, $c.Length))
    Write-Host "`n"
}


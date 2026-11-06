$localRoot = "d:\Tutien2d\tutien2d.com"

$items = Get-ChildItem -Path $localRoot
$legit = @(
    "assets", "landing-assets", "scratch", "src", "styles", "vendor",
    "manifest.webmanifest", "rootfile", "runtime-config.js", "tutien2d-helper.user.js",
    "LICH_SU_PHIEN_LAM_VIEC.md"
)

$mangled = @()
$stray = @()

foreach ($it in $items) {
    if ($legit -contains $it.Name) {
        continue
    }
    if ($it.Name -like "Tutien2d_*") {
        $mangled += $it
    } else {
        $stray += $it
    }
}

Write-Host "Mangled Tutien2d_* files: $($mangled.Count)"
Write-Host "Other stray files ($($stray.Count)):"
foreach ($s in $stray) {
    Write-Host " - $($s.Name) ($($s.Length) bytes)"
}


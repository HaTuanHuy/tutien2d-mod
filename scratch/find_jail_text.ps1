$files = Get-ChildItem -Path 'src' -Recurse -Filter '*.js'
$patterns = @('thiên lao', 'thien lao', 'phạt tù', 'phat tu', 'bị giam', 'bi giam', 'giamDen', 'cai_nguc')
foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    foreach ($p in $patterns) {
        $idx = $content.IndexOf($p, [System.StringComparison]::OrdinalIgnoreCase)
        if ($idx -ge 0) {
            Write-Output "File: $($f.Name), Pattern: $p, Pos: $idx"
        }
    }
}


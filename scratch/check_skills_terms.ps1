$content = [System.IO.File]::ReadAllText('src/systems/skills.c84a17e53a93.js')
foreach ($term in @('nho_tu', 'huyet_tu', 'Nho Tu', 'Huyết Tu')) {
    $idx = $content.IndexOf($term)
    if ($idx -ge 0) {
        Write-Output "Term: $term at $idx"
        $start = [Math]::Max(0, $idx - 100)
        $len = [Math]::Min(300, $content.Length - $start)
        Write-Output $content.Substring($start, $len)
    }
}


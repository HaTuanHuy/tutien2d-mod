foreach ($file in @('chinh_dao.67c4739d377f.js', 'forge.b58d3289fffd.js', 'items.de6f3f9bc95f.js')) {
    $path = "src/systems/$file"
    $content = [System.IO.File]::ReadAllText($path)
    Write-Output "=== $file ==="
    foreach ($term in @('nho_tu', 'huyet_tu', 'Nho Tu', 'Huyết Tu')) {
        $idx = $content.IndexOf($term)
        if ($idx -ge 0) {
            Write-Output "Term: $term at $idx"
            $start = [Math]::Max(0, $idx - 50)
            $len = [Math]::Min(250, $content.Length - $start)
            Write-Output $content.Substring($start, $len)
        }
    }
}


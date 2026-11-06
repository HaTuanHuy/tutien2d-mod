# Compare gateway files
$gwOld = Get-Content "src/net/gateway.305ce5b88ec9.js" -Raw
$gwNew = Get-Content "src/net/gateway.9d354e508f3b.js" -Raw

Write-Host "=== GATEWAY COMPARISON ==="
# Search for packet names / opcodes / message handlers
# In PNTT Gateway, messages usually have handlers or socket.send/emit patterns
$patterns = @("thienLao", "bat_quai", "nhoTu", "huyetTu", "theTu", "hopHoan", "quayDao", "doSat", "tongMonLenh", "thachQuy")
foreach ($pat in $patterns) {
    $inOld = $gwOld.Contains($pat)
    $inNew = $gwNew.Contains($pat)
    Write-Host "Pattern '$pat': Old=$inOld, New=$inNew"
}

# Find new functions or properties on Gateway
Write-Host "`n=== ITEMS COMPARISON ==="
$itemsOld = Get-Content "src/systems/items.de6f3f9bc95f.js" -Raw
$itemsNew = Get-Content "src/systems/items.180013ea6985.js" -Raw

# Extract item IDs (like "id": "..." or id:"..." or [key]={...})
$matchesNew = [regex]::Matches($itemsNew, '([a-zA-Z0-9_]+)\s*:\s*\{\s*id\s*:\s*["'']([^"'']+)["'']')
$matchesOld = [regex]::Matches($itemsOld, '([a-zA-Z0-9_]+)\s*:\s*\{\s*id\s*:\s*["'']([^"'']+)["'']')

$oldIds = [System.Collections.Generic.HashSet[string]]::new()
foreach ($m in $matchesOld) { [void]$oldIds.Add($m.Groups[2].Value) }

$newIds = [System.Collections.Generic.List[string]]::new()
foreach ($m in $matchesNew) {
    $id = $m.Groups[2].Value
    if (-not $oldIds.Contains($id)) {
        $newIds.Add($id)
    }
}
Write-Host "Found $($newIds.Count) new item IDs. Examples:"
$newIds | Select-Object -First 30 | ForEach-Object { Write-Host " - $_" }

Write-Host "`n=== SKILLS COMPARISON ==="
$skillsOld = Get-Content "src/systems/skills.c84a17e53a93.js" -Raw
$skillsNew = Get-Content "src/systems/skills.d1dc49e1f175.js" -Raw

$skMatchesNew = [regex]::Matches($skillsNew, '([a-zA-Z0-9_]+)\s*:\s*\{\s*id\s*:\s*["'']([^"'']+)["'']')
$skMatchesOld = [regex]::Matches($skillsOld, '([a-zA-Z0-9_]+)\s*:\s*\{\s*id\s*:\s*["'']([^"'']+)["'']')

$oldSkIds = [System.Collections.Generic.HashSet[string]]::new()
foreach ($m in $skMatchesOld) { [void]$oldSkIds.Add($m.Groups[2].Value) }

$newSkIds = [System.Collections.Generic.List[string]]::new()
foreach ($m in $skMatchesNew) {
    $id = $m.Groups[2].Value
    if (-not $oldSkIds.Contains($id)) {
        $newSkIds.Add($id)
    }
}
Write-Host "Found $($newSkIds.Count) new skill IDs. Examples:"
$newSkIds | Select-Object -First 30 | ForEach-Object { Write-Host " - $_" }


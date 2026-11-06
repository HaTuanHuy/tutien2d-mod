$itemsContent = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\systems\items.a77e8598ad05.js", [System.Text.Encoding]::UTF8)
$lootContent = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\systems\loot.ef0f82c62597.js", [System.Text.Encoding]::UTF8)

# Parse all items in items.a77e8598ad05.js:
# Pattern: ([a-z0-9_]+):\{id:"([^"]+)",name:"([^"]+)"(?:,type:"([^"]+)")?(?:,slot:"([^"]+)")?(?:,grade:"([^"]+)")?
$matches = [regex]::Matches($itemsContent, '([a-z0-9_]+):\{id:"\1",name:"([^"]+)"(?:,type:"([^"]+)")?(?:,slot:"([^"]+)")?(?:,grade:"([^"]+)")?')

$allGameItems = @{}
foreach ($m in $matches) {
    $id = $m.Groups[1].Value
    $name = $m.Groups[2].Value
    # Extract grade
    $grade = "Phàm phẩm"
    $itemSub = $itemsContent.Substring($m.Index, [Math]::Min(500, $itemsContent.Length - $m.Index))
    if ($itemSub -match 'grade:"([^"]+)"') {
        $grade = $matches[1]
    }
    $allGameItems[$id] = @{
        id = $id
        name = $name
        grade = $grade
    }
}

Write-Host "Total items parsed from items.js: $($allGameItems.Count)"

# Find all string keys in loot.ef0f82c62597.js that match game items
$lootKeys = [regex]::Matches($lootContent, '"([a-z0-9_]+)"')
$droppedItems = @{}
foreach ($lk in $lootKeys) {
    $k = $lk.Groups[1].Value
    if ($allGameItems.ContainsKey($k)) {
        $droppedItems[$k] = $allGameItems[$k]
    }
}

Write-Host "Total items appearing in loot.js: $($droppedItems.Count)"
foreach ($k in $droppedItems.Keys | Sort-Object) {
    $it = $droppedItems[$k]
    Write-Host "  $($it.id) => $($it.name) [Grade: $($it.grade)]"
}


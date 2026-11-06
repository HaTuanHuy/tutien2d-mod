$itemsContent = [System.IO.File]::ReadAllText("d:\Tutien2d\tutien2d.com\src\systems\items.a77e8598ad05.js", [System.Text.Encoding]::UTF8)

# Extract items dictionary
# Pattern: "item_id": { name: "...", grade: "...", ... }
$regex = '(?s)"([a-z0-9_]+)"\s*:\s*\{([^}]+)\}'
$matches = [regex]::Matches($itemsContent, $regex)

Write-Host "Found $($matches.Count) items in items.js"


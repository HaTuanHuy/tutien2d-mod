$helper = Get-Content "tutien2d-helper.user.js" -Raw
$idx = $helper.IndexOf("function evalSkill")
if ($idx -ge 0) {
    Write-Host $helper.Substring($idx, 1500)
}


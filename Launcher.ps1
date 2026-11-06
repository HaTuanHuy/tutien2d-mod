param(
    [string]$Acc = ""
)

$ErrorActionPreference = "SilentlyContinue"

$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $baseDir) { $baseDir = (Get-Location).Path }

$extDir = Join-Path $baseDir "launcher_extension"
$profilesDir = Join-Path $baseDir "profiles"
$sourceMod = Join-Path $baseDir "tutien2d-helper.user.js"
$destMod = Join-Path $extDir "tutien2d-helper.user.js"
$configFile = Join-Path $baseDir "config.ini"

# 1. Đảm bảo thư mục extension và manifest.json chuẩn chỉnh
if (-not (Test-Path $extDir)) {
    New-Item -ItemType Directory -Path $extDir -Force | Out-Null
}

$manifestPath = Join-Path $extDir "manifest.json"
$manifestJson = @'
{
  "manifest_version": 3,
  "name": "Tu Tien 2D Helper",
  "version": "1.0",
  "content_scripts": [
    {
      "matches": ["https://tutien2d.com/*", "https://www.tutien2d.com/*"],
      "js": ["tutien2d-helper.user.js"],
      "run_at": "document_start",
      "world": "MAIN"
    }
  ]
}
'@
[System.IO.File]::WriteAllText($manifestPath, $manifestJson)

# 2. Đồng bộ mod từ file gốc tutien2d-helper.user.js
if (Test-Path $sourceMod) {
    Copy-Item $sourceMod $destMod -Force
}

# 3. Đồng bộ ngầm từ GitHub nếu có cấu hình update_url trong config.ini
function Sync-OnlineMod {
    try {
        if (Test-Path $configFile) {
            $lines = Get-Content $configFile
            $url = ""
            foreach ($line in $lines) {
                if ($line -like "update_url=*") {
                    $url = $line.Substring(11).Trim()
                    break
                }
            }
            if ($url) {
                $url = $url -replace "github\.com/([^/]+)/([^/]+)/blob/", "raw.githubusercontent.com/`$1/`$2/"
                $client = New-Object System.Net.WebClient
                $client.Headers.Add("User-Agent", "TuTienLauncher")
                $onlineContent = $client.DownloadString($url)
                if ($onlineContent -and $onlineContent.Length -gt 1000 -and $onlineContent.Contains("Tu Tien 2D")) {
                    [System.IO.File]::WriteAllText($destMod, $onlineContent, [System.Text.Encoding]::UTF8)
                    [System.IO.File]::WriteAllText($sourceMod, $onlineContent, [System.Text.Encoding]::UTF8)
                }
            }
        }
    } catch {
        # Offline hoặc mạng lag thì dùng bản local có sẵn
    }
}

# 4. Hàm khởi động Edge với profile độc lập
function Start-TuTienAcc([string]$targetAcc) {
    $edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    if (-not (Test-Path $edgePath)) {
        $edgePath = "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
    }

    $accProfile = Join-Path $profilesDir ("profile_acc_" + $targetAcc)
    if (-not (Test-Path $accProfile)) {
        New-Item -ItemType Directory -Path $accProfile -Force | Out-Null
    }

    $edgeArgs = @(
        "--app=https://tutien2d.com",
        "--user-data-dir=`"$accProfile`"",
        "--load-extension=`"$extDir`"",
        "--no-first-run",
        "--no-default-browser-check",
        "--disable-background-networking",
        "--disable-component-update",
        "--disable-domain-reliability",
        "--disable-sync",
        "--enable-gpu-rasterization",
        "--ignore-gpu-blocklist",
        "--window-size=1280,760"
    ) -join " "

    Start-Process -FilePath $edgePath -ArgumentList $edgeArgs
}

# Nếu có tham số Acc (ví dụ: Launcher.ps1 -Acc 1) thì mở thẳng tài khoản đó
if ($Acc -ne "") {
    Start-TuTienAcc $Acc
    exit 0
}

# Nếu không có tham số: Hiển thị bảng điều khiển Dark Mode chọn tài khoản
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Tu Tiên 2D - Trợ Thủ & Đa Tài Khoản"
$form.Size = New-Object System.Drawing.Size(380, 340)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(24, 20, 18)
$form.ForeColor = [System.Drawing.Color]::FromArgb(240, 210, 122)

$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "TU TIÊN 2D ONLINE"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = [System.Drawing.Color]::FromArgb(240, 210, 122)
$lblTitle.TextAlign = "MiddleCenter"
$lblTitle.Size = New-Object System.Drawing.Size(360, 35)
$lblTitle.Location = New-Object System.Drawing.Point(0, 15)
$form.Controls.Add($lblTitle)

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = "Trợ thủ v0.63.21 · Chống xung đột đa tài khoản"
$lblStatus.Font = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Regular)
$lblStatus.ForeColor = [System.Drawing.Color]::FromArgb(170, 160, 150)
$lblStatus.TextAlign = "MiddleCenter"
$lblStatus.Size = New-Object System.Drawing.Size(360, 20)
$lblStatus.Location = New-Object System.Drawing.Point(0, 50)
$form.Controls.Add($lblStatus)

function New-TuTienButton($text, $top, $color, [scriptblock]$action) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.BackColor = $color
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.Size = New-Object System.Drawing.Size(310, 42)
    $btn.Location = New-Object System.Drawing.Point(26, $top)
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btn.Add_Click($action)
    return $btn
}

$btnAcc1 = New-TuTienButton "⚔ Vào Game - TÀI KHOẢN 1 (Chính)" 85 ([System.Drawing.Color]::FromArgb(46, 125, 50)) {
    Start-TuTienAcc "1"
}

$btnAcc2 = New-TuTienButton "⚔ Vào Game - TÀI KHOẢN 2 (Phụ)" 140 ([System.Drawing.Color]::FromArgb(21, 101, 192)) {
    Start-TuTienAcc "2"
}

$btnAcc3 = New-TuTienButton "⚔ Vào Game - TÀI KHOẢN 3" 195 ([System.Drawing.Color]::FromArgb(106, 27, 154)) {
    Start-TuTienAcc "3"
}

$btnSync = New-TuTienButton "🔄 Cập nhật Mod từ GitHub" 250 ([System.Drawing.Color]::FromArgb(60, 60, 60)) {
    $lblStatus.Text = "Đang kiểm tra cập nhật từ GitHub..."
    Sync-OnlineMod
    $lblStatus.Text = "Đã đồng bộ bản Mod mới nhất thành công!"
}
$btnSync.Size = New-Object System.Drawing.Size(310, 32)
$btnSync.Font = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Regular)

$form.Controls.Add($btnAcc1)
$form.Controls.Add($btnAcc2)
$form.Controls.Add($btnAcc3)
$form.Controls.Add($btnSync)

# Đồng bộ nhẹ mod từ GitHub khi khởi động
Sync-OnlineMod

[System.Windows.Forms.Application]::EnableVisualStyles()
$form.ShowDialog() | Out-Null

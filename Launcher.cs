using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Net;
using System.Windows.Forms;

namespace TuTienLauncher {
    public class MainForm : Form {
        private Label lblTitle;
        private Label lblStatus;
        private Button btnAcc1;
        private Button btnAcc2;
        private Button btnAcc3;
        private Button btnUpdate;
        private string baseDir;
        private string extDir;
        private string profilesDir;

        public MainForm() {
            baseDir = AppDomain.CurrentDomain.BaseDirectory;
            extDir = Path.Combine(baseDir, "launcher_extension");
            profilesDir = Path.Combine(baseDir, "profiles");

            this.Text = "Tu Tiên 2D - Đa Tài Khoản & Trợ Thủ";
            this.Size = new Size(390, 360);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.BackColor = Color.FromArgb(24, 20, 18);
            this.ForeColor = Color.FromArgb(240, 210, 122);

            lblTitle = new Label();
            lblTitle.Text = "TU TIÊN 2D ONLINE";
            lblTitle.Font = new Font("Segoe UI", 16, FontStyle.Bold);
            lblTitle.ForeColor = Color.FromArgb(240, 210, 122);
            lblTitle.TextAlign = ContentAlignment.MiddleCenter;
            lblTitle.Size = new Size(390, 35);
            lblTitle.Location = new Point(0, 15);
            this.Controls.Add(lblTitle);

            lblStatus = new Label();
            lblStatus.Text = "Bản Mod v0.63.21 · Sandbox Đa Tài Khoản";
            lblStatus.Font = new Font("Segoe UI", 9, FontStyle.Regular);
            lblStatus.ForeColor = Color.FromArgb(170, 160, 150);
            lblStatus.TextAlign = ContentAlignment.MiddleCenter;
            lblStatus.Size = new Size(390, 20);
            lblStatus.Location = new Point(0, 50);
            this.Controls.Add(lblStatus);

            btnAcc1 = CreateButton("⚔ Vào Game - TÀI KHOẢN 1 (Chính)", 85, Color.FromArgb(46, 125, 50), () => LaunchAcc("acc1"));
            btnAcc2 = CreateButton("⚔ Vào Game - TÀI KHOẢN 2 (Phụ)", 140, Color.FromArgb(21, 101, 192), () => LaunchAcc("acc2"));
            btnAcc3 = CreateButton("⚔ Vào Game - TÀI KHOẢN 3", 195, Color.FromArgb(106, 27, 154), () => LaunchAcc("acc3"));

            btnUpdate = new Button();
            btnUpdate.Text = "🔄 Cập nhật Mod từ GitHub";
            btnUpdate.Font = new Font("Segoe UI", 9, FontStyle.Regular);
            btnUpdate.ForeColor = Color.FromArgb(240, 210, 122);
            btnUpdate.BackColor = Color.FromArgb(55, 50, 48);
            btnUpdate.FlatStyle = FlatStyle.Flat;
            btnUpdate.FlatAppearance.BorderSize = 0;
            btnUpdate.Size = new Size(330, 34);
            btnUpdate.Location = new Point(25, 255);
            btnUpdate.Cursor = Cursors.Hand;
            btnUpdate.Click += (s, e) => UpdateMod();
            this.Controls.Add(btnUpdate);

            this.Controls.Add(btnAcc1);
            this.Controls.Add(btnAcc2);
            this.Controls.Add(btnAcc3);

            PrepareExtension();
        }

        private Button CreateButton(string text, int top, Color backColor, Action onClick) {
            Button btn = new Button();
            btn.Text = text;
            btn.Font = new Font("Segoe UI", 10, FontStyle.Bold);
            btn.ForeColor = Color.White;
            btn.BackColor = backColor;
            btn.FlatStyle = FlatStyle.Flat;
            btn.FlatAppearance.BorderSize = 0;
            btn.Size = new Size(330, 42);
            btn.Location = new Point(25, top);
            btn.Cursor = Cursors.Hand;
            btn.Click += (s, e) => onClick();
            return btn;
        }

        private string FindBrowser() {
            // 1. Dò tìm qua Registry của Windows
            string[] regKeys = new string[] {
                @"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe",
                @"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe"
            };
            foreach (string rk in regKeys) {
                try {
                    using (var key = Microsoft.Win32.Registry.LocalMachine.OpenSubKey(rk)) {
                        if (key != null) {
                            object val = key.GetValue("");
                            if (val != null && File.Exists(val.ToString())) return val.ToString();
                        }
                    }
                    using (var key = Microsoft.Win32.Registry.CurrentUser.OpenSubKey(rk)) {
                        if (key != null) {
                            object val = key.GetValue("");
                            if (val != null && File.Exists(val.ToString())) return val.ToString();
                        }
                    }
                } catch { }
            }

            // 2. Dò tìm các đường dẫn cài đặt phổ biến của Edge, Chrome, Cốc Cốc, Brave
            string localApp = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            string progFiles = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles);
            string progFilesX86 = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86);

            string[] candidates = new string[] {
                Path.Combine(progFilesX86, @"Microsoft\Edge\Application\msedge.exe"),
                Path.Combine(progFiles, @"Microsoft\Edge\Application\msedge.exe"),
                Path.Combine(localApp, @"Microsoft\Edge\Application\msedge.exe"),
                Path.Combine(progFiles, @"Google\Chrome\Application\chrome.exe"),
                Path.Combine(progFilesX86, @"Google\Chrome\Application\chrome.exe"),
                Path.Combine(localApp, @"Google\Chrome\Application\chrome.exe"),
                Path.Combine(localApp, @"CocCoc\Browser\Application\browser.exe"),
                Path.Combine(progFiles, @"CocCoc\Browser\Application\browser.exe"),
                Path.Combine(progFilesX86, @"CocCoc\Browser\Application\browser.exe"),
                Path.Combine(progFiles, @"BraveSoftware\Brave-Browser\Application\brave.exe"),
                Path.Combine(progFilesX86, @"BraveSoftware\Brave-Browser\Application\brave.exe")
            };

            foreach (string p in candidates) {
                if (!string.IsNullOrEmpty(p) && File.Exists(p)) return p;
            }

            return null;
        }

        private void PrepareExtension() {
            try {
                if (!Directory.Exists(extDir)) Directory.CreateDirectory(extDir);
                string manifest = Path.Combine(extDir, "manifest.json");
                string json = "{\r\n  \"manifest_version\": 3,\r\n  \"name\": \"Tu Tien 2D Helper\",\r\n  \"version\": \"1.0\",\r\n  \"content_scripts\": [\r\n    {\r\n      \"matches\": [\"https://tutien2d.com/*\", \"https://www.tutien2d.com/*\"],\r\n      \"js\": [\"tutien2d-helper.user.js\"],\r\n      \"run_at\": \"document_start\",\r\n      \"world\": \"MAIN\"\r\n    }\r\n  ]\r\n}";
                File.WriteAllText(manifest, json);

                string sourceMod = Path.Combine(baseDir, "tutien2d-helper.user.js");
                string destMod = Path.Combine(extDir, "tutien2d-helper.user.js");

                if (File.Exists(sourceMod)) {
                    File.Copy(sourceMod, destMod, true);
                } else if (!File.Exists(destMod)) {
                    // Nếu máy mới chưa có file mod thì tự động tải từ GitHub về
                    DownloadModSync();
                }
            } catch { }
        }

        private static void EnableTls() {
            try {
                ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072; // TLS 1.2
            } catch {
                try {
                    ServicePointManager.SecurityProtocol = (SecurityProtocolType)768 | SecurityProtocolType.Tls;
                } catch { }
            }
        }

        private string DownloadCode() {
            // Tầng 1: WebClient với TLS 1.2
            try {
                EnableTls();
                using (WebClient wc = new WebClient()) {
                    wc.Headers.Add("User-Agent", "TuTienLauncher");
                    string s = wc.DownloadString("https://raw.githubusercontent.com/HaTuanHuy/tutien2d-mod/main/tutien2d-helper.user.js");
                    if (!string.IsNullOrEmpty(s) && s.Length > 1000) return s;
                }
            } catch { }

            // Tầng 2: Fallback bằng curl.exe có sẵn trên Windows 10 / 11
            try {
                ProcessStartInfo psi = new ProcessStartInfo("curl.exe", "-sL https://raw.githubusercontent.com/HaTuanHuy/tutien2d-mod/main/tutien2d-helper.user.js") {
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };
                using (Process p = Process.Start(psi)) {
                    string s = p.StandardOutput.ReadToEnd();
                    p.WaitForExit(10000);
                    if (!string.IsNullOrEmpty(s) && s.Length > 1000) return s;
                }
            } catch { }

            // Tầng 3: Fallback bằng PowerShell Invoke-WebRequest
            try {
                ProcessStartInfo psi = new ProcessStartInfo("powershell.exe", "-NoProfile -Command \"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/HaTuanHuy/tutien2d-mod/main/tutien2d-helper.user.js')\"") {
                    RedirectStandardOutput = true,
                    UseShellExecute = false,
                    CreateNoWindow = true
                };
                using (Process p = Process.Start(psi)) {
                    string s = p.StandardOutput.ReadToEnd();
                    p.WaitForExit(10000);
                    if (!string.IsNullOrEmpty(s) && s.Length > 1000) return s;
                }
            } catch { }

            return null;
        }

        private void DownloadModSync() {
            try {
                string code = DownloadCode();
                if (!string.IsNullOrEmpty(code)) {
                    File.WriteAllText(Path.Combine(baseDir, "tutien2d-helper.user.js"), code);
                    File.WriteAllText(Path.Combine(extDir, "tutien2d-helper.user.js"), code);
                }
            } catch { }
        }

        private void LaunchAcc(string accId) {
            try {
                PrepareExtension();
                string browserPath = FindBrowser();
                if (string.IsNullOrEmpty(browserPath) || !File.Exists(browserPath)) {
                    MessageBox.Show(
                        "Không tìm thấy trình duyệt Microsoft Edge hoặc Google Chrome trên máy này!\n\nVui lòng cài đặt Microsoft Edge hoặc Google Chrome để mở game.",
                        "Thông báo",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Warning
                    );
                    return;
                }

                string profile = Path.Combine(profilesDir, accId);
                if (!Directory.Exists(profile)) Directory.CreateDirectory(profile);

                string args = string.Format(
                    "--app=\"https://tutien2d.com\" " +
                    "--user-data-dir=\"{0}\" " +
                    "--load-extension=\"{1}\" " +
                    "--no-first-run " +
                    "--no-default-browser-check " +
                    "--disable-background-networking " +
                    "--disable-component-update " +
                    "--disable-domain-reliability " +
                    "--disable-sync " +
                    "--disable-renderer-backgrounding " +
                    "--disable-backgrounding-occluded-windows " +
                    "--enable-low-end-device-mode " +
                    "--enable-gpu-rasterization " +
                    "--ignore-gpu-blocklist " +
                    "--autoplay-policy=no-user-gesture-required " +
                    "--window-size=1280,760",
                    profile, extDir
                );

                Process.Start(new ProcessStartInfo(browserPath, args) { UseShellExecute = false });
                string bName = Path.GetFileNameWithoutExtension(browserPath);
                lblStatus.Text = string.Format("Đã mở {0} thành công qua {1}!", accId.ToUpper(), bName);
            } catch (Exception ex) {
                MessageBox.Show("Lỗi mở game: " + ex.Message);
            }
        }

        private void UpdateMod() {
            lblStatus.Text = "Đang tải bản Mod mới từ GitHub...";
            System.Threading.ThreadPool.QueueUserWorkItem(delegate {
                try {
                    string code = DownloadCode();
                    if (!string.IsNullOrEmpty(code) && code.Length > 1000) {
                        File.WriteAllText(Path.Combine(baseDir, "tutien2d-helper.user.js"), code);
                        File.WriteAllText(Path.Combine(extDir, "tutien2d-helper.user.js"), code);
                        this.BeginInvoke((MethodInvoker)delegate {
                            lblStatus.Text = "Cập nhật Mod mới nhất thành công!";
                            MessageBox.Show("Đã cập nhật bản Mod mới nhất từ GitHub thành công!");
                        });
                        return;
                    } else {
                        this.BeginInvoke((MethodInvoker)delegate {
                            lblStatus.Text = "Không thể tải Mod từ GitHub, vui lòng thử lại sau.";
                        });
                    }
                } catch (Exception ex) {
                    this.BeginInvoke((MethodInvoker)delegate {
                        lblStatus.Text = "Lỗi cập nhật: " + ex.Message;
                    });
                }
            });
        }
    }

    static class Program {
        [STAThread]
        static void Main() {
            try {
                ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
            } catch { }
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }
}

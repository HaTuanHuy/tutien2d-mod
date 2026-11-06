using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Net;
using System.Windows.Forms;

namespace TuTienLauncher {
    public class LauncherForm : Form {
        private Label lblTitle;
        private Label lblStatus;
        private Button btnAcc1;
        private Button btnAcc2;
        private Button btnAcc3;
        private string baseDir;
        private string extDir;

        public LauncherForm() {
            baseDir = AppDomain.CurrentDomain.BaseDirectory;
            extDir = Path.Combine(baseDir, "launcher_extension");

            // Thiết lập Form giao diện tối chuẩn Tu Tiên
            this.Text = "Tu Tiên 2D - Trợ Thủ & Đa Tài Khoản";
            this.Size = new Size(360, 320);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.BackColor = Color.FromArgb(24, 20, 18);
            this.ForeColor = Color.FromArgb(240, 210, 122);

            lblTitle = new Label();
            lblTitle.Text = "TU TIÊN 2D ONLINE";
            lblTitle.Font = new Font("Segoe UI", 14, FontStyle.Bold);
            lblTitle.ForeColor = Color.FromArgb(240, 210, 122);
            lblTitle.TextAlign = ContentAlignment.MiddleCenter;
            lblTitle.Size = new Size(340, 35);
            lblTitle.Location = new Point(0, 15);
            this.Controls.Add(lblTitle);

            lblStatus = new Label();
            lblStatus.Text = "Trợ thủ v0.63.21 · Chống xung đột đa tài khoản";
            lblStatus.Font = new Font("Segoe UI", 8.5f, FontStyle.Regular);
            lblStatus.ForeColor = Color.FromArgb(170, 160, 150);
            lblStatus.TextAlign = ContentAlignment.MiddleCenter;
            lblStatus.Size = new Size(340, 20);
            lblStatus.Location = new Point(0, 50);
            this.Controls.Add(lblStatus);

            btnAcc1 = CreateButton("⚔ Vào Game - TÀI KHOẢN 1 (Chính)", 85, Color.FromArgb(46, 125, 50), () => LaunchGame("1"));
            btnAcc2 = CreateButton("⚔ Vào Game - TÀI KHOẢN 2 (Phụ)", 140, Color.FromArgb(21, 101, 192), () => LaunchGame("2"));
            btnAcc3 = CreateButton("⚔ Vào Game - TÀI KHOẢN 3", 195, Color.FromArgb(106, 27, 154), () => LaunchGame("3"));

            this.Controls.Add(btnAcc1);
            this.Controls.Add(btnAcc2);
            this.Controls.Add(btnAcc3);

            // Kiểm tra cập nhật ngầm từ GitHub khi bật launcher
            SyncModOnline();
        }

        private Button CreateButton(string text, int top, Color backColor, Action onClick) {
            Button btn = new Button();
            btn.Text = text;
            btn.Font = new Font("Segoe UI", 9.5f, FontStyle.Bold);
            btn.ForeColor = Color.White;
            btn.BackColor = backColor;
            btn.FlatStyle = FlatStyle.Flat;
            btn.FlatAppearance.BorderSize = 0;
            btn.Size = new Size(300, 42);
            btn.Location = new Point(22, top);
            btn.Cursor = Cursors.Hand;
            btn.Click += (s, e) => onClick();
            return btn;
        }

        private void SyncModOnline() {
            new System.Threading.Thread(() => {
                try {
                    string configFile = Path.Combine(baseDir, "config.ini");
                    string sourceMod = Path.Combine(baseDir, "tutien2d-helper.user.js");
                    string onlineUrl = "";
                    if (File.Exists(configFile)) {
                        foreach (string line in File.ReadAllLines(configFile)) {
                            string trimmed = line.Trim();
                            if (trimmed.StartsWith("update_url=", StringComparison.OrdinalIgnoreCase)) {
                                onlineUrl = trimmed.Substring(11).Trim();
                            }
                        }
                    }

                    if (!string.IsNullOrEmpty(onlineUrl) && onlineUrl.Contains("github.com") && onlineUrl.Contains("/blob/")) {
                        onlineUrl = onlineUrl.Replace("github.com", "raw.githubusercontent.com").Replace("/blob/", "/");
                    }

                    if (!string.IsNullOrEmpty(onlineUrl)) {
                        ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
                        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(onlineUrl);
                        req.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) TuTien2D-Launcher";
                        req.Timeout = 4000;
                        using (HttpWebResponse resp = (HttpWebResponse)req.GetResponse()) {
                            if (resp.StatusCode == HttpStatusCode.OK) {
                                using (StreamReader reader = new StreamReader(resp.GetResponseStream())) {
                                    string remoteCode = reader.ReadToEnd();
                                    if (remoteCode.Contains("// ==UserScript==")) {
                                        File.WriteAllText(sourceMod, remoteCode);
                                    }
                                }
                            }
                        }
                    }
                } catch { }
            }).Start();
        }

        private void LaunchGame(string accId) {
            try {
                string sourceMod = Path.Combine(baseDir, "tutien2d-helper.user.js");
                string destMod = Path.Combine(extDir, "tutien2d-helper.user.js");

                Directory.CreateDirectory(extDir);
                string manifestPath = Path.Combine(extDir, "manifest.json");
                string manifestContent = "{\r\n  \"manifest_version\": 3,\r\n  \"name\": \"Tu Tien 2D Helper\",\r\n  \"version\": \"1.0\",\r\n  \"content_scripts\": [\r\n    {\r\n      \"matches\": [\"https://tutien2d.com/*\", \"https://www.tutien2d.com/*\"],\r\n      \"js\": [\"tutien2d-helper.user.js\"],\r\n      \"run_at\": \"document_start\",\r\n      \"world\": \"MAIN\"\r\n    }\r\n  ]\r\n}";
                File.WriteAllText(manifestPath, manifestContent);

                if (File.Exists(sourceMod)) {
                    File.Copy(sourceMod, destMod, true);
                }

                string edgePath = @"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe";
                if (!File.Exists(edgePath)) {
                    edgePath = @"C:\Program Files\Microsoft\Edge\Application\msedge.exe";
                }
                if (!File.Exists(edgePath)) {
                    MessageBox.Show("Không tìm thấy Microsoft Edge!");
                    return;
                }

                // Cô lập hoàn toàn Profile cho từng Acc để không đá nhau
                string profileDir = Path.Combine(baseDir, "profiles", "profile_acc_" + accId);
                Directory.CreateDirectory(profileDir);

                string argsFormatted = string.Format(
                    "--app=\"https://tutien2d.com\" " +
                    "--user-data-dir=\"{0}\" " +
                    "--load-extension=\"{1}\" " +
                    "--no-first-run " +
                    "--no-default-browser-check " +
                    "--disable-background-networking " +
                    "--disable-component-update " +
                    "--disable-domain-reliability " +
                    "--disable-sync " +
                    "--enable-gpu-rasterization " +
                    "--ignore-gpu-blocklist " +
                    "--window-size=1280,760",
                    profileDir, extDir
                );

                Process.Start(new ProcessStartInfo(edgePath, argsFormatted) { UseShellExecute = false });
            } catch (Exception ex) {
                MessageBox.Show("Lỗi: " + ex.Message);
            }
        }
    }

    static class Program {
        [STAThread]
        static void Main(string[] args) {
            // Nếu có tham số dòng lệnh (ví dụ TuTien2D.exe 1 hoặc TuTien2D.exe 2 từ file .bat): Mở thẳng acc đó!
            if (args.Length > 0 && !string.IsNullOrEmpty(args[0])) {
                string accId = args[0].Trim();
                LaunchDirect(accId);
                return;
            }

            // Nếu nhấp đúp trực tiếp vào TuTien2D.exe không kèm tham số: Hiện bảng chọn Acc 1 / Acc 2 cực kỳ đẹp mắt!
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new LauncherForm());
        }

        private static void LaunchDirect(string accId) {
            try {
                string baseDir = AppDomain.CurrentDomain.BaseDirectory;
                string extDir = Path.Combine(baseDir, "launcher_extension");
                string sourceMod = Path.Combine(baseDir, "tutien2d-helper.user.js");
                string destMod = Path.Combine(extDir, "tutien2d-helper.user.js");

                Directory.CreateDirectory(extDir);
                string manifestPath = Path.Combine(extDir, "manifest.json");
                string manifestContent = "{\r\n  \"manifest_version\": 3,\r\n  \"name\": \"Tu Tien 2D Helper\",\r\n  \"version\": \"1.0\",\r\n  \"content_scripts\": [\r\n    {\r\n      \"matches\": [\"https://tutien2d.com/*\", \"https://www.tutien2d.com/*\"],\r\n      \"js\": [\"tutien2d-helper.user.js\"],\r\n      \"run_at\": \"document_start\",\r\n      \"world\": \"MAIN\"\r\n    }\r\n  ]\r\n}";
                File.WriteAllText(manifestPath, manifestContent);

                if (File.Exists(sourceMod)) {
                    File.Copy(sourceMod, destMod, true);
                }

                string edgePath = @"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe";
                if (!File.Exists(edgePath)) {
                    edgePath = @"C:\Program Files\Microsoft\Edge\Application\msedge.exe";
                }

                string profileDir = Path.Combine(baseDir, "profiles", "profile_acc_" + accId);
                Directory.CreateDirectory(profileDir);

                string argsFormatted = string.Format(
                    "--app=\"https://tutien2d.com\" " +
                    "--user-data-dir=\"{0}\" " +
                    "--load-extension=\"{1}\" " +
                    "--no-first-run " +
                    "--no-default-browser-check " +
                    "--disable-background-networking " +
                    "--disable-component-update " +
                    "--disable-domain-reliability " +
                    "--disable-sync " +
                    "--enable-gpu-rasterization " +
                    "--ignore-gpu-blocklist " +
                    "--window-size=1280,760",
                    profileDir, extDir
                );

                Process.Start(new ProcessStartInfo(edgePath, argsFormatted) { UseShellExecute = false });
            } catch { }
        }
    }
}

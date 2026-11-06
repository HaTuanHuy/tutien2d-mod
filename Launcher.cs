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
                }
            } catch { }
        }

        private void LaunchAcc(string accId) {
            try {
                PrepareExtension();
                string profile = Path.Combine(profilesDir, accId);
                if (!Directory.Exists(profile)) Directory.CreateDirectory(profile);

                string edge = @"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe";
                if (!File.Exists(edge)) {
                    edge = @"C:\Program Files\Microsoft\Edge\Application\msedge.exe";
                }

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
                    "--enable-gpu-rasterization " +
                    "--ignore-gpu-blocklist " +
                    "--window-size=1280,760",
                    profile, extDir
                );

                Process.Start(new ProcessStartInfo(edge, args) { UseShellExecute = false });
                lblStatus.Text = "Đã mở " + accId.ToUpper() + " thành công!";
            } catch (Exception ex) {
                MessageBox.Show("Lỗi mở game: " + ex.Message);
            }
        }

        private void UpdateMod() {
            lblStatus.Text = "Đang tải bản Mod mới từ GitHub...";
            System.Threading.ThreadPool.QueueUserWorkItem(delegate {
                try {
                    ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072 | (SecurityProtocolType)12288 | SecurityProtocolType.Tls;
                    using (WebClient wc = new WebClient()) {
                        wc.Headers.Add("User-Agent", "TuTienLauncher");
                        string code = wc.DownloadString("https://raw.githubusercontent.com/HaTuanHuy/tutien2d-mod/main/tutien2d-helper.user.js");
                        if (!string.IsNullOrEmpty(code) && code.Length > 1000) {
                            File.WriteAllText(Path.Combine(baseDir, "tutien2d-helper.user.js"), code);
                            File.WriteAllText(Path.Combine(extDir, "tutien2d-helper.user.js"), code);
                            this.BeginInvoke((MethodInvoker)delegate {
                                lblStatus.Text = "Cập nhật Mod mới nhất thành công!";
                                MessageBox.Show("Đã cập nhật bản Mod mới nhất từ GitHub thành công!");
                            });
                            return;
                        }
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
                ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072 | (SecurityProtocolType)12288 | SecurityProtocolType.Tls;
            } catch { }
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }
}


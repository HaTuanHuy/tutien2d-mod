using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading;
using System.Windows.Forms;

namespace TuTienLauncher {
    static class Program {
        [STAThread]
        static void Main(string[] args) {
            try {
                string baseDir = AppDomain.CurrentDomain.BaseDirectory;
                string sourceMod = Path.Combine(baseDir, "tutien2d-helper.user.js");
                string extDir = Path.Combine(baseDir, "launcher_extension");
                string destMod = Path.Combine(extDir, "tutien2d-helper.user.js");
                string configFile = Path.Combine(baseDir, "config.ini");

                // Xác định tài khoản (Acc 1, Acc 2, Acc 3...) để tách riêng biệt Profile
                string accId = "1";
                if (args.Length > 0 && !string.IsNullOrEmpty(args[0])) {
                    accId = args[0].Trim();
                }

                // 1. Đọc config.ini
                string onlineUrl = "";
                if (File.Exists(configFile)) {
                    foreach (string line in File.ReadAllLines(configFile)) {
                        string trimmed = line.Trim();
                        if (trimmed.StartsWith("update_url=", StringComparison.OrdinalIgnoreCase)) {
                            onlineUrl = trimmed.Substring(11).Trim();
                        }
                    }
                }

                // Tự động chuyển link github.com/.../blob/... sang raw.githubusercontent.com
                if (!string.IsNullOrEmpty(onlineUrl) && onlineUrl.Contains("github.com") && onlineUrl.Contains("/blob/")) {
                    onlineUrl = onlineUrl.Replace("github.com", "raw.githubusercontent.com").Replace("/blob/", "/");
                }

                // 2. Tự động kiểm tra và tải bản cập nhật ngầm từ GitHub
                if (!string.IsNullOrEmpty(onlineUrl)) {
                    try {
                        ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072; // TLS 1.2
                        HttpWebRequest req = (HttpWebRequest)WebRequest.Create(onlineUrl);
                        req.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) TuTien2D-Launcher";
                        req.Timeout = 4000;
                        req.ReadWriteTimeout = 4000;
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
                    } catch {
                        // Mất mạng hoặc link lỗi thì dùng tiếp bản mod đã có sẵn trên máy
                    }
                }

                // 3. Tự động sao chép bản mod mới nhất vào thư mục extension của launcher
                Directory.CreateDirectory(extDir);
                string manifestPath = Path.Combine(extDir, "manifest.json");
                string manifestContent = "{\r\n  \"manifest_version\": 3,\r\n  \"name\": \"Tu Tien 2D Helper\",\r\n  \"version\": \"1.0\",\r\n  \"content_scripts\": [\r\n    {\r\n      \"matches\": [\"https://tutien2d.com/*\", \"https://www.tutien2d.com/*\"],\r\n      \"js\": [\"tutien2d-helper.user.js\"],\r\n      \"run_at\": \"document_start\",\r\n      \"world\": \"MAIN\"\r\n    }\r\n  ]\r\n}";
                File.WriteAllText(manifestPath, manifestContent);

                if (File.Exists(sourceMod)) {
                    File.Copy(sourceMod, destMod, true);
                }

                // 4. Tìm trình duyệt Edge Chromium
                string edgePath = @"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe";
                if (!File.Exists(edgePath)) {
                    edgePath = @"C:\Program Files\Microsoft\Edge\Application\msedge.exe";
                }
                if (!File.Exists(edgePath)) {
                    MessageBox.Show("Không tìm thấy Microsoft Edge trên máy tính để chạy game!");
                    return;
                }

                // Tách biệt hoàn toàn thư mục profile của từng tài khoản để chống xung đột Cookie/Session/Mod
                string profileDir = Path.Combine(baseDir, "profiles", "profile_acc_" + accId);
                Directory.CreateDirectory(profileDir);

                // 5. Cấu hình tối ưu tài nguyên tối đa (giảm RAM, ép GPU gánh Canvas, chặn tiến trình rác)
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

                ProcessStartInfo psi = new ProcessStartInfo(edgePath, argsFormatted) {
                    UseShellExecute = false
                };
                Process.Start(psi);
            } catch (Exception ex) {
                MessageBox.Show("Lỗi khởi động Launcher: " + ex.Message);
            }
        }
    }
}

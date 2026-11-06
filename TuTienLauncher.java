import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class TuTienLauncher extends JFrame {
    private JLabel lblStatus;
    private File baseDir;
    private File extDir;
    private File profilesDir;

    public TuTienLauncher() {
        super("Tu Tiên 2D - Đa Tài Khoản & Trợ Thủ");
        
        try {
            baseDir = new File(TuTienLauncher.class.getProtectionDomain().getCodeSource().getLocation().toURI()).getParentFile();
            if (baseDir == null || !baseDir.exists()) {
                baseDir = new File(".");
            }
        } catch (Exception e) {
            baseDir = new File(".");
        }
        extDir = new File(baseDir, "launcher_extension");
        profilesDir = new File(baseDir, "profiles");

        setSize(390, 360);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setResizable(false);
        getContentPane().setBackground(new Color(24, 20, 18));
        setLayout(null);

        JLabel lblTitle = new JLabel("TU TIÊN 2D ONLINE", SwingConstants.CENTER);
        lblTitle.setBounds(0, 15, 390, 35);
        lblTitle.setFont(new Font("Segoe UI", Font.BOLD, 18));
        lblTitle.setForeground(new Color(240, 210, 122));
        add(lblTitle);

        lblStatus = new JLabel("Bản Mod v0.63.21 · Sandbox Đa Tài Khoản", SwingConstants.CENTER);
        lblStatus.setBounds(0, 50, 390, 20);
        lblStatus.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        lblStatus.setForeground(new Color(170, 160, 150));
        add(lblStatus);

        add(createButton("⚔ Vào Game - TÀI KHOẢN 1 (Chính)", 85, new Color(46, 125, 50), new ActionListener() {
            public void actionPerformed(ActionEvent e) { launchAccount("acc1"); }
        }));

        add(createButton("⚔ Vào Game - TÀI KHOẢN 2 (Phụ)", 140, new Color(21, 101, 192), new ActionListener() {
            public void actionPerformed(ActionEvent e) { launchAccount("acc2"); }
        }));

        add(createButton("⚔ Vào Game - TÀI KHOẢN 3", 195, new Color(106, 27, 154), new ActionListener() {
            public void actionPerformed(ActionEvent e) { launchAccount("acc3"); }
        }));

        JButton btnUpdate = new JButton("🔄 Cập nhật Mod từ GitHub");
        btnUpdate.setBounds(25, 255, 330, 34);
        btnUpdate.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        btnUpdate.setBackground(new Color(55, 50, 48));
        btnUpdate.setForeground(new Color(240, 210, 122));
        btnUpdate.setFocusPainted(false);
        btnUpdate.setBorderPainted(false);
        btnUpdate.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnUpdate.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) { updateMod(); }
        });
        add(btnUpdate);

        prepareExtension();
    }

    private JButton createButton(String text, int top, Color bg, ActionListener listener) {
        JButton btn = new JButton(text);
        btn.setBounds(25, top, 330, 42);
        btn.setFont(new Font("Segoe UI", Font.BOLD, 13));
        btn.setBackground(bg);
        btn.setForeground(Color.WHITE);
        btn.setFocusPainted(false);
        btn.setBorderPainted(false);
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btn.addActionListener(listener);
        return btn;
    }

    private String findBrowser() {
        // Ưu tiên Google Chrome hàng đầu, kế tiếp là Microsoft Edge, Cốc Cốc, Brave
        String localApp = System.getenv("LOCALAPPDATA");
        String progFiles = System.getenv("ProgramFiles");
        String progFilesX86 = System.getenv("ProgramFiles(x86)");

        String[] candidates = new String[] {
            progFiles != null ? progFiles + "\\Google\\Chrome\\Application\\chrome.exe" : null,
            progFilesX86 != null ? progFilesX86 + "\\Google\\Chrome\\Application\\chrome.exe" : null,
            localApp != null ? localApp + "\\Google\\Chrome\\Application\\chrome.exe" : null,
            progFilesX86 != null ? progFilesX86 + "\\Microsoft\\Edge\\Application\\msedge.exe" : null,
            progFiles != null ? progFiles + "\\Microsoft\\Edge\\Application\\msedge.exe" : null,
            localApp != null ? localApp + "\\Microsoft\\Edge\\Application\\msedge.exe" : null,
            localApp != null ? localApp + "\\CocCoc\\Browser\\Application\\browser.exe" : null,
            progFiles != null ? progFiles + "\\CocCoc\\Browser\\Application\\browser.exe" : null,
            progFilesX86 != null ? progFilesX86 + "\\CocCoc\\Browser\\Application\\browser.exe" : null,
            progFiles != null ? progFiles + "\\BraveSoftware\\Brave-Browser\\Application\\brave.exe" : null,
            progFilesX86 != null ? progFilesX86 + "\\BraveSoftware\\Brave-Browser\\Application\\brave.exe" : null
        };

        for (String c : candidates) {
            if (c != null && new File(c).exists()) return c;
        }

        return null;
    }

    private void prepareExtension() {
        try {
            if (!extDir.exists()) extDir.mkdirs();
            File manifest = new File(extDir, "manifest.json");
            String json = "{\n  \"manifest_version\": 3,\n  \"name\": \"Tu Tien 2D Helper\",\n  \"version\": \"1.0\",\n  \"content_scripts\": [\n    {\n      \"matches\": [\"https://tutien2d.com/*\", \"https://www.tutien2d.com/*\"],\n      \"js\": [\"tutien2d-helper.user.js\"],\n      \"run_at\": \"document_start\",\n      \"world\": \"MAIN\"\n    }\n  ]\n}";
            writeToFile(manifest, json);

            File sourceMod = new File(baseDir, "tutien2d-helper.user.js");
            File destMod = new File(extDir, "tutien2d-helper.user.js");
            if (sourceMod.exists()) {
                copyFile(sourceMod, destMod);
            } else {
                boolean extracted = extractEmbeddedMod(destMod);
                if (extracted) {
                    try { copyFile(destMod, sourceMod); } catch (Exception ignored) {}
                }
            }
        } catch (Exception ignored) {}
    }

    private boolean extractEmbeddedMod(File target) {
        try {
            InputStream in = TuTienLauncher.class.getResourceAsStream("/tutien2d-helper.user.js");
            if (in == null) in = TuTienLauncher.class.getResourceAsStream("tutien2d-helper.user.js");
            if (in != null) {
                OutputStream out = new FileOutputStream(target);
                byte[] buf = new byte[8192];
                int len;
                while ((len = in.read(buf)) > 0) {
                    out.write(buf, 0, len);
                }
                in.close();
                out.close();
                return true;
            }
        } catch (Exception ignored) {}
        return false;
    }

    private void launchAccount(String accId) {
        try {
            prepareExtension();
            String browserPath = findBrowser();
            if (browserPath == null) {
                JOptionPane.showMessageDialog(this,
                    "Không tìm thấy trình duyệt Google Chrome hoặc Microsoft Edge trên máy này!\nVui lòng cài đặt Google Chrome hoặc Microsoft Edge để mở game.",
                    "Thông báo", JOptionPane.WARNING_MESSAGE);
                return;
            }

            File profile = new File(profilesDir, accId);
            if (!profile.exists()) profile.mkdirs();

            String[] cmd = new String[] {
                browserPath,
                "--app=https://tutien2d.com",
                "--user-data-dir=" + profile.getAbsolutePath(),
                "--load-extension=" + extDir.getAbsolutePath(),
                "--enable-extensions",
                "--no-first-run",
                "--no-default-browser-check",
                "--disable-background-networking",
                "--disable-component-update",
                "--disable-domain-reliability",
                "--disable-sync",
                "--disable-renderer-backgrounding",
                "--disable-backgrounding-occluded-windows",
                "--enable-low-end-device-mode",
                "--enable-gpu-rasterization",
                "--ignore-gpu-blocklist",
                "--autoplay-policy=no-user-gesture-required",
                "--window-size=1280,760"
            };

            Runtime.getRuntime().exec(cmd);
            String bName = new File(browserPath).getName().replace(".exe", "");
            lblStatus.setText("Đã mở " + accId.toUpperCase() + " thành công qua " + bName + "!");
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Lỗi mở game: " + ex.getMessage());
        }
    }

    private void updateMod() {
        lblStatus.setText("Đang tải bản Mod mới từ GitHub...");
        new Thread(new Runnable() {
            public void run() {
                try {
                    URL u = new URL("https://raw.githubusercontent.com/HaTuanHuy/tutien2d-mod/main/tutien2d-helper.user.js");
                    HttpURLConnection conn = (HttpURLConnection) u.openConnection();
                    conn.setRequestProperty("User-Agent", "TuTienLauncher");
                    conn.setConnectTimeout(10000);
                    conn.setReadTimeout(15000);
                    if (conn.getResponseCode() == 200) {
                        File sourceMod = new File(baseDir, "tutien2d-helper.user.js");
                        File destMod = new File(extDir, "tutien2d-helper.user.js");
                        
                        InputStream in = conn.getInputStream();
                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        byte[] buf = new byte[8192];
                        int len;
                        while ((len = in.read(buf)) > 0) {
                            baos.write(buf, 0, len);
                        }
                        in.close();
                        byte[] data = baos.toByteArray();

                        if (data.length > 1000) {
                            FileOutputStream fos1 = new FileOutputStream(sourceMod);
                            fos1.write(data);
                            fos1.close();

                            FileOutputStream fos2 = new FileOutputStream(destMod);
                            fos2.write(data);
                            fos2.close();

                            SwingUtilities.invokeLater(new Runnable() {
                                public void run() {
                                    lblStatus.setText("Cập nhật Mod mới nhất thành công!");
                                    JOptionPane.showMessageDialog(TuTienLauncher.this, "Đã cập nhật bản Mod mới nhất từ GitHub thành công!");
                                }
                            });
                            return;
                        }
                    }
                    throw new IOException("HTTP " + conn.getResponseCode());
                } catch (final Exception ex) {
                    SwingUtilities.invokeLater(new Runnable() {
                        public void run() {
                            lblStatus.setText("Lỗi cập nhật: " + ex.getMessage());
                        }
                    });
                }
            }
        }).start();
    }

    private static void copyFile(File src, File dst) throws IOException {
        InputStream in = new FileInputStream(src);
        OutputStream out = new FileOutputStream(dst);
        byte[] buf = new byte[8192];
        int len;
        while ((len = in.read(buf)) > 0) {
            out.write(buf, 0, len);
        }
        in.close();
        out.close();
    }

    private static void writeToFile(File f, String text) throws IOException {
        FileOutputStream fos = new FileOutputStream(f);
        OutputStreamWriter osw = new OutputStreamWriter(fos, "UTF-8");
        osw.write(text);
        osw.close();
    }

    public static void main(String[] args) {
        System.setProperty("https.protocols", "TLSv1.2,TLSv1.3");
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ignored) {}
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                new TuTienLauncher().setVisible(true);
            }
        });
    }
}

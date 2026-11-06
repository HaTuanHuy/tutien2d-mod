# Tu Tiên 2D Helper 🚀

Trợ thủ tự động hóa toàn diện dành cho game **Tu Tiên 2D Online** (`https://tutien2d.com`).

---

## 🌟 Tính Năng Nổi Bật Của Bản Mod (v0.63.21)

1. **Auto Trận Bàn Thông Minh**:
   - Tự động kích hoạt khi săn **Boss Thế Giới**, **Thương Đội**, **Yêu Thú Xổng Chuồng** và **Sỹ Sách Điện / Hư Thiên Điện**.
   - Khóa chặn cứng 3 tầng: **Tuyệt đối không dùng Trận Bàn khi farm quái thường** (Thạch Quy, Xuyên Sơn Giáp, Heo Rừng, Sơn Chuột...), tiết kiệm 100% Linh Thạch.
2. **Khô Máu Dồn DPS Tranh Last-Hit**:
   - Tự động chuyển chế độ dồn sát thương cực đại, áp sát quái $\le 2\text{px}$ ngay từ 100% máu để khắc chế cơ chế hồi máu của quái và cướp đòn kết liễu giành 100% đồ rơi.
3. **Săn Yêu Thú Xổng Chuồng & Thương Đội**:
   - Tự động nhận diện thông báo Thiên Đạo, tìm đúng khu, tự động chuyển mục tiêu dứt điểm.
4. **Tối Ưu Chuyên Sâu Sỹ Sách Điện (Hư Thiên Điện)**:
   - Chống vòng lặp tử thần sảnh an toàn, gom ngọc phù Ải 1, focus fire trụ Ải 2, tự động PK tự vệ bung Trận Bàn Ải 3/4, né đòn nộ FireNova $\le 22\%$, bảo kê đứng yên nhặt bảo vật cực hiếm.
5. **Cảm Biến Thiên Lao & Kill-switch Chống Ban**:
   - Tự ngắt khẩn cấp toàn bộ auto khi bị phạt tù Thiên Lao / Bát Quái Thạch Bàn.
6. **Đón Đầu Thạch Quỷ Biến Dị Trước 20s**:
   - Đọc bản tin toàn khu, tự tìm đến khu vực đón đầu.

---

## ⚡ Bộ Khởi Động Đóng Gói (TuTien2D.jar & TuTien2D.exe)

Dành cho người chơi muốn cắm farm đa tài khoản (2-3 nick) siêu nhẹ, tiết kiệm ~85% RAM:

### 1. Bản Java: `TuTien2D.jar` (Khuyên Dùng Nhất 🌟)
- **Ưu điểm**: Chạy qua máy ảo Java (`javaw.exe`) của Oracle nên **Windows 11 Smart App Control KHÔNG BAO GIỜ chặn**.
- **Cách dùng**: Nhấp đúp chuột vào file [`TuTien2D.jar`](file:///d:/Tutien2d/tutien2d.com/TuTien2D.jar) để mở bảng điều khiển Dark Mode chọn tài khoản 1, 2, 3 và cập nhật Mod từ GitHub.

### 2. Bản Windows Executable: `TuTien2D.exe`
- **Cách dùng**: Nhấp đúp chuột vào file [`TuTien2D.exe`](file:///d:/Tutien2d/tutien2d.com/TuTien2D.exe).
- Nếu Windows 11 hiện cảnh báo Smart App Control, hãy sử dụng bản `TuTien2D.jar`.

> **Cơ chế Sandbox Profile**: Cả 2 bản đều tự động cách ly cookies và cấu hình bot vào thư mục `profiles/` riêng biệt cho từng nick, hỗ trợ cắm song song 2-3 tài khoản mà không sợ bị đá nick hay xung đột cấu hình.

---

## 🛠 Hướng Dẫn Cài Đặt Trợ Thủ Trên Trình Duyệt (Tampermonkey)

Chơi trực tiếp trên mọi trình duyệt Chromium (Google Chrome, Microsoft Edge, Cốc Cốc, Brave, Kiwi Browser...):
1. Cài đặt tiện ích **[Tampermonkey](https://www.tampermonkey.net/)** cho trình duyệt của bạn.
2. Thêm script mới và dán toàn bộ mã nguồn file [`tutien2d-helper.user.js`](https://raw.githubusercontent.com/HaTuanHuy/tutien2d-mod/main/tutien2d-helper.user.js).
3. Truy cập `https://tutien2d.com`, đăng nhập vào game và bấm phím `` ` `` (hoặc `F8`) để mở bảng điều khiển trợ thủ.

---

## 👥 Hướng Dẫn Treo Đa Tài Khoản (Multi-Account) Không Bị Xung Đột

Để treo 2 hoặc nhiều tài khoản cùng lúc mà không bị văng nick hay đè cấu hình:
1. Trên trình duyệt Chrome / Edge: Nhấp vào **biểu tượng Avatar (Hồ sơ người dùng)** ở góc trên cùng bên phải.
2. Chọn **"Thêm" (Add Profile)** để tạo một hồ sơ người dùng mới (ví dụ: *Tu Tiên Acc 2*).
3. Cài tiện ích Tampermonkey và nạp script trên hồ sơ mới này.
4. Mỗi hồ sơ người dùng là một không gian độc lập 100% (Cookies, tài khoản và cài đặt Mod riêng biệt), bạn có thể mở song song 2 cửa sổ để treo cả ngày mà không bao giờ bị đá nhau!


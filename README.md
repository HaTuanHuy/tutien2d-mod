# Tu Tiên 2D Helper & Ultra-Light Launcher 🚀

Trợ thủ tự động hóa toàn diện và Launcher siêu nhẹ (tiết kiệm ~85% RAM) dành cho game **Tu Tiên 2D Online** (`https://tutien2d.com`).

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

## ⚡ Hướng Dẫn Sử Dụng Launcher Siêu Nhẹ (TuTien2D.exe)

Launcher sử dụng nhân Microsoft Edge Chromium ở chế độ App độc lập:
- **Tiêu tốn RAM**: Chỉ **~120MB** (so với 1.2GB của Chrome).
- **Tiêu tốn CPU**: Chỉ **1% - 2%** (Card đồ họa GPU gánh Canvas).
- **Tự động cập nhật**: Game tải trực tiếp từ `tutien2d.com`, mod tự động cập nhật từ GitHub repository này.

### 🎮 Cách Chơi:
- **Tài khoản 1**: Nhấp đúp vào `Choi_Acc1.bat` (hoặc `TuTien2D.exe`).
- **Tài khoản 2 (Chạy song song không xung đột)**: Nhấp đúp vào `Choi_Acc2.bat`.
- **Tài khoản 3**: Nhấp đúp vào `Choi_Acc3.bat`.

> Các tài khoản được cách ly hoàn toàn dữ liệu (Cookies, mật khẩu và cài đặt bot riêng biệt), không bao giờ bị văng nick hay đè cấu hình.

---

## 🛠 Cài Đặt Trên Trình Duyệt Bằng Tampermonkey

Nếu bạn vẫn muốn chơi trên Chrome / Edge / Kiwi Browser:
1. Cài đặt tiện ích **Tampermonkey**.
2. Thêm script mới và dán toàn bộ nội dung file [`tutien2d-helper.user.js`](https://raw.githubusercontent.com/HaTuanHuy/tutien2d-mod/main/tutien2d-helper.user.js) vào.
3. Truy cập `https://tutien2d.com` và bấm phím `` ` `` (hoặc `F8`) để mở bảng điều khiển trợ thủ.

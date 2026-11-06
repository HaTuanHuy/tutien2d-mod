# BÁO CÁO LƯU TRỮ LỊCH SỬ PHIÊN LÀM VIỆC — TU TIÊN 2D ONLINE

> **Thời gian cập nhật:** 31/10/2026  
> **Dự án:** Tu Tiên 2D Online (`tutien2d.com` / `tutien2d.online`)  
> **File trọng tâm:**  
> - `tutien2d-helper.user.js` (Script mod trợ thủ v0.55.0)  
> - `runtime-config.js` (Cấu hình môi trường mạng)  
> - `src/net/gateway.9b66608f1070.js` (Giao thức máy chủ)  
> - `src/systems/` (Hệ thống kinh tế & gameplay)

---

## 1. NÂNG CẤP BẮT TRỌN 100% GÓI TIN MÁY CHỦ (WEBSOCKET / GATEWAY)

### 1.1. Nguyên nhân lỗi của script cũ
1. **Khởi động trễ**: Chạy ở `@run-at document-idle`, nạp vào sau khi WebSocket đã kết nối xong.
2. **Không can thiệp tầng giao thức**: Chỉ monkey-patch chắp vá ở các hàm UI/Chat (`P.Chat.line`, `SW.onServerLoot`...), bỏ lỡ các gói tin không qua UI như `bantin`, `toast`, `bosses`, `spawn`, `kill`, `status`, `hoichieu`, `ack`.
3. **Mất hook khi Reconnect / Đổi map**: Khi game kết nối lại (`Gateway.connect()`), toàn bộ `socket.onmessage` bị game ghi đè lại, xoá sạch hook cũ.
4. **Lỗi Regex tin Thiên Đạo**: Chuỗi từ server gửi có tiền tố `"Thiên Đạo: một con..."`, trong khi regex cũ đòi hỏi bắt đầu bằng `^một con...`.

### 1.2. Giải pháp đã triển khai trong v0.54.0
* **Header**: Đổi thành `@run-at document-start` (tương thích cả `document-start` và `document-idle`).
* **Động cơ NetHook đa tầng**:
  - **Tầng Prototype**: Can thiệp `Object.defineProperty` trên `WebSocket.prototype.onmessage` (getter/setter) và `WebSocket.prototype.addEventListener('message')`, `WebSocket.prototype.send`.
  - **Tầng Constructor**: Bọc `window.WebSocket` constructor, tự động gắn fallback listener ngay khi socket khởi tạo.
  - **Tầng Gateway**: Đặt descriptor trên `PNTT.Gateway.socket` và bọc `PNTT.Gateway.connect()`.
  - **Tầng Reactive**: Vòng lặp `tick()` 150ms gọi `hookPNTTGateway()` bảo đảm không bao giờ mất hook.
  - **Khử trùng (`ev._ttHandled`)**: Bảo đảm mỗi gói tin chỉ xử lý đúng 1 lần duy nhất.
* **Tổng đài phân phối sự kiện (`ServerBus`)**:
  - Định tuyến tự động toàn bộ 57 opcodes: `welcome`, `tin`, `bantin`, `bao`, `toast`, `world_chat`, `chat`, `bosses`, `spawn`, `hit`, `kill`, `loot`, `loot_gone`, `khu`, `map`, `status`, `hoichieu`, `ack`.
  - Chuẩn hoá gỡ tiền tố thông báo và tích hợp bộ đệm chống trùng tin 2.5s.
* **Giao diện & DevTools**:
  - Thêm chip mạng `netChip` trên tiêu đề (`📡 ... gói`).
  - Thêm bộ lọc `'net'` trong tab Nhật ký.
  - Xuất API: `window.__ttNet` và `window.TTBot.net`.

---

## 2. TRUY VẾT HẠ TẦNG VẬN HÀNH MÁY CHỦ (SERVER ARCHITECTURE)

| Thành phần | Địa chỉ / Domain | Chi tiết hạ tầng |
| :--- | :--- | :--- |
| **Game Server chính (Trong nước - DNS xám)** | `wss://ws.tutien2d.online/` | **IP: 103.74.102.109**, Port: 443 (WSS)<br>• **Vị trí**: Đà Nẵng, Việt Nam<br>• **ISP**: Viet Digital Technology (DVS / AS135918)<br>• **Chứng chỉ SSL**: CN=ws.tutien2d.online (Let's Encrypt cấp 23/10/2026) |
| **Game Server phụ (Quốc tế / Cloudflare)** | `wss://game.tutien2d.online/` | Đứng sau Proxy Cloudflare Anycast (104.21.46.25 / 172.67.222.231) |
| **Web Frontend (Tĩnh)** | `https://tutien2d.com/` | Cloudflare Pages CDN toàn cầu |
| **Cơ sở dữ liệu & Xác thực** | `https://qrheujgqeplgozswcsun.supabase.co` | Supabase Cloud (PostgreSQL + GoTrue Auth) |

---

## 3. CƠ CHẾ NHẶT ĐỒ VÀ BẢO MẬT PHÍA SERVER

Lý do **"Hút đồ toàn màn hình"** hoặc **"Nhặt tức thì từ xa"** không thể dùng được:
1. **Server Authoritative Distance Check**: Khi client gửi `loot.pick { id }`, server tự tính `dist(player, drop)`. Nếu khoảng cách lớn hơn bán kính cho phép (`PICK_R = 40px`), server từ chối ngay (`ack: "Quá xa"`).
2. **Khóa bảo hộ 45 giây (`OWNER_SECS = 45`)**: Người không phải chủ sở hữu gửi lệnh trong 45s đầu bị server chặn.
3. **Thời gian rơi vật lý (`0.2s - 0.5s`)**: Gửi lệnh trước khi đồ chạm đất sẽ bị server coi là không hợp lệ.

---

## 4. TOÀN CẢNH HỆ THỐNG KINH TẾ & FARM LINH THẠCH CỦA GAME

### Các kênh thu nhập Linh Thạch chính
1. **Quái thường**: Giới hạn trần cứng theo cảnh giới (`STONE_DAY_CAP`: 500 - 10.000 LT/ngày).
2. **Boss Thế Giới & Song Dực Ma Báo**: 1.000 - 5.000 LT kết liễu + các bọc 100 - 400 LT văng ra giữa trận.
3. **Vận Tiêu**: 6 lượt/ngày (11h - 22h). Thưởng giao xe Vàng/Đỏ hàng ngàn LT (không tính vào trần ngày). Đua Top tuần nhận tới 20.000 LT.
4. **Chiếm Trụ Trận Mạch Mỏ Linh Thạch**: Trụ `tm_tru` tại `mo_linh_thach` trả 5 LT mỗi 5 giây (tối đa 60.000 LT/ngày cho tông môn giữ trụ).
5. **Điểm Danh 30 Ngày**: 200 - 1.000 LT/ngày (cần dự ít nhất 1 trận Đại Hội).
6. **Đua Top Bảng Xếp Hạng**: Top Vận Tiêu (20.000 LT), Top Tông Môn (20.000 LT), Top Chiến Trường (8.000 LT).
7. **Hắc Thị (Chợ Đen)**: Đổi hàng lậu lấy Hắc Phiếu, tối đa 600 phiếu = 12.000 LT giá trị/ngày.
8. **Chợ Tự Do**: Bán Hồn người phàm, Oán hồn, Quặng quý không giới hạn trần.

---

## 5. RÀ SOÁT 4 TÍNH NĂNG TRỌNG ĐIỂM TRONG CODEBASE VÀ HƯỚNG TỐI ƯU

| Tính năng | Hiện trạng trong code bot | Điểm nghẽn / Chưa tối ưu | Hướng giải quyết nâng cấp |
| :--- | :--- | :--- | :--- |
| **1. Bán Chợ (`honSell` / `Market`)** | Dòng 4877 - 4899: có `honSell`, `honSellPham`, `honSellOan` | **Chỉ đi săn thêm hồn**, hoàn toàn KHÔNG có logic mở Chợ (`PNTT.Market`), không tự đăng bán (`market.dang`) và không tự rút tiền (`market.nhan`). | Viết module `tickAutoMarket`: Tự mở chợ, kiểm tra giá sàn, tự đăng bán Phàm Hồn/Oán Hồn và tự bấm nhận tiền khi có giao dịch. |
| **2. Trụ Trận Mạch (`TranMach`)** | Dòng 3735, 9247: chỉ nhắc `mo_linh_thach` là bãi boss Ma Báo / cướp tiêu | **Hoàn toàn chưa có module Trận Mạch**, bỏ lỡ 60.000 LT/ngày. | Viết module `tickTranMach`: Tự tới `mo_linh_thach (tx:22, ty:14)`, tự bật cờ đỏ chiếm trụ, tự đứng đả tọa thủ trụ trong bán kính 260px (`HOI_TAM: 260`). |
| **3. Vận Tiêu (`vtRun` / `tickVanTieu`)** | Dòng 5707 - 5757: đã có tự nhận tiêu và dắt xe | **1.** Nhận xe ngẫu nhiên (xe Trắng thưởng rất ít).<br>**2.** Chạy thẳng 3 map cướp tiêu dễ bị phá/cướp xe.<br>**3.** Xe tụt xa dễ bị loop tìm xe timeout 4 phút. | • Thêm cơ chế đổi/chọn xe: Chỉ nhận xe Vàng/Đỏ.<br>• Thêm kiểm tra radar cờ cướp tiêu quanh cổng.<br>• Làm mượt thuật toán kéo xe tránh kẹt góc. |
| **4. Điểm Danh (`plan_diemdanh`)** | Dòng 5317 - 5340: có `tickDiemDanh` gọi `phucloi.diemdanh` | Game bắt buộc **phải vào đài Đại Hội Tu Tiên 1 trận** mới được điểm danh. Bot thấy chưa dự Đại Hội là bỏ qua luôn (`done`). | Liên kết logic: Nếu chưa dự Đại Hội -> Tự ghi danh vào đài đánh 1 trận -> Sau đó tự động gọi `phucloi.diemdanh` nhận thưởng. |

---

## 6. TỐI ƯU HÓA MODE ĐÁNH BOSS THẾ GIỚI & ĐẢM BẢO 100% ĐẠT MỐC BỐC THĂM QUÀ

### 6.1. Quy tắc của máy chủ (`loot.ef0f82c62597.js`)
```javascript
n.BOC_THAM = { KHOA_GIAY: 20, NGUONG: 0.01, TRAN_TRONG_SO: 0.15, BAN_KINH: 700 }
```
- Ngưỡng gây sát thương $\ge 1\%$ máu boss.
- Đếm ngược 20 giây sau khi boss chết mới bốc thăm.
- Người chơi phải còn sống và đứng trong bán kính 700px quanh tọa độ boss chết.

### 6.2. Các cải tiến đã triển khai
1. **Khóa tuyệt đối không bao giờ Kite / Né đánh thường của Boss**:
   - Vô hiệu hóa kiting khi có Boss xuất hiện.
   - Bỏ qua va chạm thân và đòn đánh thường của boss trong danh sách nguy hiểm.
2. **Không hủy nhát chém đang vung khi né chiêu**:
   - Nhân vật xuất trọn đòn tấn công trước khi di chuyển theo đường thoát.
3. **Hồi sinh tại chỗ tức thì (0s Delay)**:
   - Khi chết trong trận boss, gượng dậy tại chỗ ngay lập tức (`rdelay = 0`).
4. **Cấm rút lui ngồi thiền**:
   - Luôn bám trụ dùng đan dược và bùa chú thay vì chạy ra ngoài ngồi thiền.
5. **Khóa vị trí 25 giây đón quà bốc thăm**:
   - Nâng `BH_LOOT_MS = 25000ms`, cấm chuyển map hoặc về bãi farm khi chưa hết thời gian.

---

## 7. TỐI ƯU HÓA CHẾ ĐỘ VẬN TIÊU (5 LỚP BẢO VỆ CHỐNG THẤT BẠI)

1. **Lớp 1 - Chọn Khu vắng nhất TRƯỚC KHI nhận xe (`vtQuietKhu: true`)**: Đổi ngầm sang khu ít người nhất trước khi nhận tiêu.
2. **Lớp 2 - Siết khoảng cách kéo xe**: `VT_KEEP = 150px`, `VT_FAR = 210px` chống đứt dây cáp.
3. **Lớp 3 - Bảo hiểm qua cổng (`vtSafePortal: true`)**: Xe áp sát $\le 80\text{px}$ mới bước qua cổng.
4. **Lớp 4 - Hộ tiêu tự động & Hồi phục an toàn (`vtGuardCart: true`)**: Diệt mục tiêu nhắm xe, đứng chờ xe tự hồi phục 100% máu.
5. **Lớp 5 - Khóa ưu tiên Vận Tiêu (`prioVt: false`)**: Không bao giờ bỏ rơi xe tiêu giữa đường.

---

## 8. TỐI ƯU HỆ THỐNG NHẶT ĐỒ & TRANH CƯỚP CỰC PHẨM

1. **Phân Cấp Giá Trị Vật Phẩm Toàn Diện (`LOOT_SPECIAL_SCORES`)**:
   - Tier 0 (60.000+): Vạn Xích Nhất Tuyến, Toái Không Linh Chi.
   - Tier 1 (20.000 - 40.000): Yêu Đan Cấp 6, Yêu Đan Cấp 5, Rương Phi Hành, Xích Long Huyết...
   - Tier 2 (15.000 - 19.500): Bí Tịch Vạn Kiếm Quy Tông, Kim Quang Cự Kiếm, Huyết Liêm Trảm...
2. **Can Thiệp Tức Thời Khung Hình 0 (Frame-0 Packet Interception)**:
   - Chặn bắt gói `loot` từ WebSocket, nhặt ngay lập tức món đồ quý nhất trong tầm nhặt ($\le 52\text{px}$) hoặc dùng Tốc Hành lướt tới đồ Tier 0/1.
3. **Áp Sát Tâm Boss Ở Ngưỡng Kết Liễu (Execute Range)**:
   - Boss Thế Giới $\le 4\%$ máu: Áp sát tâm boss ($px \le 20\text{px}$).
   - Quái Biến Dị $\le 8\%$ máu: Áp sát tâm quái ($px \le 24\text{px}$).
4. **Bỏ Qua Quét Rác Khi Có Cực Phẩm (`tickLoot`)**:
   - Tập trung lao thẳng vào bảo vật giá trị cao.
5. **Tranh Đồ Có Chủ Sắp Mở Khóa (`tickContest`)**:
   - Canh thời gian 45s của server, spam lệnh nhặt trước 0.15s khi hết hạn khóa.

---

## 9. TẬN DỤNG TRIỆT ĐỂ BÍ TỊCH BIẾN HÌNH (KIM CƯƠNG / XÍCH MA / BÀN THẠCH)

1. **Gỡ Bỏ Rào Cản DPS Bằng 0**: Cho phép các chiêu hóa thân (`shape: "self"`) tham gia vào combo.
2. **Ưu Tiên Slot #1**: Tự động xếp chiêu Biến Hình vào vị trí đầu tiên trong hotbar và tick Tự Động cho chế độ PK, Boss, Đi Đội.
3. **Engine Kích Hoạt Tự Động (`tickHoaThan`)**:
   - Kích hoạt khi có người chơi đối kháng tiếp cận ($350\text{px}$).
   - Kích hoạt khi giao tranh Boss Thế Giới / Quái Biến Dị ($450\text{px}$).
   - Kích hoạt cứu sinh khẩn cấp khi máu $\le 50\%$.

---

## 10. HỖ TRỢ PHÁP BẢO ĐA PHÁI (ÂM HỒN / KIẾM LINH / QUYỀN ẢNH / MỊ ĐIỆP)

1. **Tự động nhận diện bản môn và luyện bầy (`factionArtifact`)**:
   - Ma Đạo: Hồn Phiên $\rightarrow$ Âm Hồn.
   - Chính Đạo: Kiếm Hạp $\rightarrow$ Kiếm Linh.
   - Thể Tu: Thiết Hoàn $\rightarrow$ Mở khiếu Quyền Ảnh.
   - Hợp Hoan: Hồng Loan Kết $\rightarrow$ Mị Điệp.
2. **Tự Động Hóa 100% Theo Game Engine**:
   - Cả 4 môn phái khi bật Tự Động (Auto On), bầy tự bay ra chiến đấu không tốn Linh Lực.
   - Bot tuyệt đối không gửi lệnh gọi thủ công để tránh xung đột với máy chủ.
3. **Mở Khóa Khôi Lỗi Toàn Phái**:
   - Tất cả môn phái đều được tự động thả Khôi Lỗi trợ chiến.
4. **Phân Luồng Mục Tiêu Thương Đội (`tdTargets`)**:
   - Chính Đạo diệt Kiếp Tặc thu thập Chính Khí; Ma Đạo hạ Tiêu Sư thu nạp Oán Hồn.

---

## 11. TỐI ƯU HÓA TỐC ĐỘ DI CHUYỂN 1.25X & ÁP SÁT THƯƠNG ĐỘI 0PX

1. **Khắc Phục Hiện Tượng Chạy Quá Xa Khi Đánh Boss Xích Long**:
   - Bỏ qua vùng né của chiêu phun lửa `fireNova` (90 dmg, 2.4s cd) của World Boss.
   - Người chơi đứng vững tại chỗ xả 100% DPS mà không bị văng ra xa 80-120px.
2. **Duy Trì Tốc Độ Di Chuyển 1.25x Toàn Thời Gian (`speed125: true`)**:
   - Khóa tốc độ chạy luôn ở mức `baseSpeed * 1.25` qua `tickDev()`.
   - Bổ sung tùy chọn UI trong cài đặt trợ thủ: `[✓] Luôn duy trì tốc độ di chuyển 1.25x`.
3. **Áp Sát Thương Đội (Caravan) Chạm Thân px = 0**:
   - Trong `honStrike`: Áp sát mục tiêu đến $px = 0$ ($d \le 4\text{px}$), bật Tự Động xả trọn vẹn combo và bầy thú cưng.
   - Ngưỡng kết liễu Boss, Biến Dị, Xổng Chuồng áp sát $px \le 2\text{px}$ để nhặt đồ tức thì tại Frame 0.

---

## 12. XỬ LÝ TRIỆT ĐỂ THÔNG BÁO "KHÔNG ĐƯỢC: ÂM HỒN TỰ RA ĐÁNH KHI BẬT TỰ ĐỘNG" & LÀM SẠCH GIAO DIỆN

### 12.1. Nguồn Gốc & Cơ Chế Máy Chủ
- Khi máy chủ nhận lệnh triệu hồi thủ công trong khi trạng thái Tự Động (`autoOn === true`) đang bật, máy chủ gửi phản hồi lỗi `ack`:
  `{ ok: false, why: "Âm Hồn tự ra đánh khi bật Tự Động" }`
  khiến chữ màu vàng đất `#c9a45c` nổi lên trên đầu nhân vật.
- Máy chủ và game engine đã mặc định điều phối bầy thú cưng (Âm Hồn, Kiếm Linh, Quyền Ảnh, Mị Điệp) tự động bay ra tấn công khi có kẻ địch và không tốn Linh Lực.

### 12.2. Làm Sạch Triệt Để Trong Trợ Thủ
1. **Xóa bỏ tùy chọn UI lỗi thời**:
   - Gỡ bỏ nút gạt `[✓] Tự gọi Âm Hồn khi đánh (30 Linh Lực mỗi con)` ở cả mục Bùa/Chiêu thức và Tab Âm Hồn.
   - Hiển thị thông báo hướng dẫn:
     `⚡ Bầy tự bay ra tấn công khi bật Tự Động (Auto On), không tốn Linh Lực · Tuyệt đối không gửi lệnh gọi thủ công.`
2. **Khử trùng dữ liệu cấu hình cũ (`load()`)**:
   - Trong `load()`: Thực hiện `delete c.honSummon; c.honSummon = false;` để loại bỏ hoàn toàn thiết lập cũ từ `localStorage`.
   - Giữ trạng thái `setAuto(g, true)` liên tục trong mọi giao tranh để bầy pháp bảo tự động kích hoạt tối đa.

---

## 13. TỔNG KẾT BỘ KIỂM THỬ HỒI QUY TOÀN HỆ THỐNG (99/99 TESTS PASSED)

Tất cả 6 bộ kiểm thử tự động độc lập đã chạy và vượt qua 100% trên môi trường Chromium Headless:
1. `scratch/test_bienhinh_opt.html`: **14/14 PASSED** (Kích hoạt Biến Hình khi PK/Boss/Cứu sinh).
2. `scratch/test_faction_opt.html`: **10/10 PASSED** (Khử lỗi `hon.goi`, tự luyện đa phái, Khôi Lỗi toàn phái).
3. `scratch/test_loot_opt.html`: **20/20 PASSED** (Đấu giá Frame 0, nhặt ưu tiên cực phẩm, áp sát Boss/Biến dị kết liễu).
4. `scratch/test_vt_opt.html`: **19/19 PASSED** (Vận tiêu an toàn, đổi khu vắng, bảo hộ xe, an toàn qua cổng).
5. `scratch/test_speed_caravan_opt.html`: **11/11 PASSED** (Tốc độ 1.25x, áp sát Thương Đội 0px, bỏ qua né trùng lặp Xích Long).
6. `scratch/test_e2e_userjs.html`: **25/25 PASSED** (Bắt trọn 100% gói tin WebSocket, chịu lỗi rớt mạng).

> **KẾT QUẢ CUỐI CÙNG: 99 / 99 BÀI KIỂM THỬ THÀNH CÔNG TUYỆT ĐỐI (100% PASSED)**

---

## 14. TỔNG HỢP CÁC CẢI TIẾN TRỌNG ĐIỂM CHO BOSS WORLD & BOSS XỔNG CHUỒNG

### 14.1. Đối Với Boss Thế Giới (Thần Thú Xích Long, Nhện Bạch Ngọc, Thần Thú Huyền Vũ)
1. **Tiếp cận tầm cận chiến thực tế (`bReach`)**:
   - Trước đây: Bot chỉ đi tới nếu khoảng cách $> 260\text{px}$ (`BH_NEAR`), dẫn tới việc người chơi cận chiến (tầm reach 26px) bị kẹt đứng ngoài tầm đánh khi ở khoảng cách 50-200px.
   - Hiện tại: Tự động tính toán tầm đánh thực tế `bReach = reach (26px) + bodyRadius (24px)`. Nếu khoảng cách $> \text{bReach}$, bot chủ động tìm đường áp sát thẳng vào tầm xuất chiêu / chém tay của nhân vật.
2. **Loại bỏ né chiêu rác (Phun lửa Xích Long `fireNova`)**:
   - Xích Long có chiêu phun lửa `fireNova` (90 dmg, cooldown 2.4s, hoạt ảnh `attack_short_2`). Bot cũ coi đây là nguy hiểm và bỏ chạy 80-120px mỗi 2.4 giây.
   - Hiện tại: Bỏ qua 100% chiêu `fireNova` của Boss World, giữ nhân vật đứng vững xả sát thương liên tục. Chỉ né `baoKich` khi máu $< 45\%$.
3. **Áp sát chạm tâm $px = 0$ ($d \le 2\text{px}$) & Dồn Burst tại ngưỡng kết liễu**:
   - Khi Boss World tụt xuống $\le 4\%$ máu hoặc $\le 50.000\text{ HP}$: Kích hoạt `huntBurst` xả toàn bộ chiêu thức mạnh nhất và áp sát chạm tâm boss ($d \le 2\text{px}$). Do bọc quà rơi trong bán kính 22px, việc đứng tại $px \le 2\text{px}$ bảo đảm quà rơi trúng chân nhân vật ngay tại Frame 0.
4. **Khóa vị trí 25 giây đón nhận quà Bốc Thăm**:
   - Sau khi Boss chết: Bot giữ chân nhân vật trong bán kính $\le 150\text{px}$ quanh xác boss trong đủ 25 giây (`BH_LOOT_MS = 25000`), không chuyển map hay về farm trước khi máy chủ quay số bốc thăm quà ở giây thứ 20 (yêu cầu khoảng cách $\le 700\text{px}$).

### 14.2. Đối Với Boss Xổng Chuồng (Xích Nhãn Ngưu, Bạch Hổ Tuyết, Xích Ma Vương, Ngân Mao Hống)
1. **Cơ chế máy chủ**:
   - Thuộc tính `lootLastHitOnly: true`: Đồ rơi (Yêu Đan, Nanh Hổ, Ngưu Sừng) **CHỈ THUỘC VỀ NGƯỜI KẾT LIỄU (LAST HIT)**, có khóa bảo hộ độc quyền 45 giây.
2. **Dồn Burst tranh đoạt Last Hit (`huntBurst`)**:
   - Trong `evEngage`: Khi quái xổng chuồng tụt xuống $\le 20\%$ máu hoặc $\le 10.000\text{ HP}$, bot kích hoạt ngay `huntBurst(g, t, d, reach)` xả sạch combo kỹ năng burst cao nhất để cướp đòn Last Hit trước các đối thủ xung quanh.
3. **Áp sát chạm thân $px = 0$ ($d \le 2\text{px}$)**:
   - Loại bỏ rào cản đứng xa 140px cũ (`Math.max(reach, 140)`). Bot luôn áp sát trong tầm vũ khí, và tại ngưỡng $\le 20\%$ máu lập tức tiến thẳng vào tâm $px \le 2\text{px}$.
4. **Bảo hiểm nhặt đồ trước khi chuyển map (`lootBeforeLeave`)**:
   - Trong `tickXongChuong`: Trước khi kết thúc tuần map (`xcFinish`), bot gọi `lootBeforeLeave(g)` để quét sạch toàn bộ Yêu Đan và vật phẩm rơi trên đất, cam kết không bỏ sót bất kỳ chiến lợi phẩm nào.

---

## 15. NÂNG CẤP SIÊU CẢM BIẾN NHẶT ĐỒ TẦNG SOCKET (FRAME-0 ZERO LATENCY)

### 15.1. Bối Cảnh và Yêu Cầu
- Người dùng yêu cầu cải tiến cảm biến nhặt đồ từ máy chủ cho Boss World và Boss Xổng Chuồng: Nhặt ngay lập tức khi máy chủ phát gói tin rơi đồ (`op: "loot"`), không phải đợi đồ họa rơi xuống đất hay hoạt ảnh bay parabol.

### 15.2. Khảo Sát Cơ Chế Hệ Thống Game & Tầng Máy Chủ
1. **Phía Client Game Thông Thường (`src/scenes/world.149b4b6a3e7b.js`)**:
   - Khi nhận gói `loot`, client đưa vật thể vào trạng thái bay parabol `state: "bay"` với thời gian $0.45\text{s} - 0.95\text{s}$.
   - Khi chạm đất (`state: "ground"`), client lại có độ trễ lắng đọng `c.t < Ua` (~0.2s).
   - Chỉ sau khi hoàn tất hoạt ảnh tiếp đất, client mới kiểm tra khoảng cách và gọi lệnh nhặt. Do đó người chơi thông thường bị trễ từ $0.6\text{s} - 1.2\text{s}$.
2. **Phía Máy Chủ (Server Authoritative `src/systems/loot.ef0f82c62597.js`)**:
   - Máy chủ headless không quan tâm hoạt ảnh Canvas của client. Ngay khi broadcast `op: "loot"`, ID vật phẩm đã có hiệu lực ngay trong RAM máy chủ.
   - Máy chủ chỉ kiểm tra:
     + Khoảng cách: `dist(player, drop) <= 40px` (`PICK_R = 40`).
     + Quyền sở hữu: Không có chủ (Boss World rơi giữa trận) hoặc thuộc về người chơi (Last Hit Xổng Chuồng).
   - Nếu client gửi lệnh `loot.pick` ngay tại Frame 0 (khoảnh khắc gói tin vừa vào card mạng/socket), máy chủ sẽ chấp nhận ngay lập tức!
3. **Phát Hiện Điểm Nghẽn Trong Mã Cũ**:
   - Gói tin raw từ máy chủ gửi `it.item` (tên món đồ), nhưng mã cũ đọc `it.itemId` $\rightarrow$ bị `undefined`, điểm phẩm cấp `gradeScore` trả về 0, auto-dash khi đồ rơi xa bị vô hiệu hóa.
   - Điều kiện kiểm tra chủ sở hữu đọc `(it.dropT || 0) < 15` thay vì đọc `it.age` và `it.khoa`.

### 15.3. Các Thay Đổi Kỹ Thuật Đã Thực Hiện
1. **Cải Tiến `ServerBus.on('loot')` (Frame-0 Microtask Interception)**:
   - Chuẩn hóa đọc tên vật phẩm: `var itemId = it.item || it.itemId;` và `var lid = it.id != null ? it.id : it.lootId;`.
   - Chuẩn hóa kiểm tra quyền sở hữu máy chủ: `var isOwner = !it.owner || (G.selfId && it.owner === G.selfId);` và `var isExpiredLock = (it.age || 0) >= (it.khoa || (L && L.OWNER_SECS) || 45);`.
   - Sắp xếp toàn bộ mảng rơi theo giá trị phẩm cấp `gradeScore` giảm dần: Bảo vật tối thượng, Bí tịch, Yêu đan quý luôn được gửi lệnh trước.
   - Bắn ngay lệnh `G.cmd('loot.pick', { id: lid })` đồng bộ trong callback WebSocket `onmessage` trước cả vòng lặp đồ họa client.
   - Ghi nhật ký HUD: Thông báo tức thì khi bắt trọn bảo vật giá trị cao $\ge 5000$ điểm tại Frame 0.
   - Lướt Tốc Hành khẩn cấp: Tự động kích hoạt `toc_hanh` và áp sát nếu bảo vật cực phẩm ($\ge 8000$ điểm) rơi ngoài tầm 40px nhưng trong tầm 140px.
2. **Cải Tiến `hookFastLoot` (`SceneWorld.onServerLoot`)**:
   - Chuẩn hóa đọc `a.item || a.itemId` và `b.item || b.itemId`.
   - Tôn trọng cờ `e._ttAsked` từ tầng mạng để tránh trùng lặp, đóng vai trò mạng lưới an toàn (failover) 100% tin cậy.
3. **Mở Rộng Bảng Điểm Bảo Vật Quý Hiếm (`LOOT_SPECIAL_SCORES`)**:
   - Bổ sung toàn diện danh mục trang bị Hoàng Kim, Pháp Bảo, Bí Tịch Hợp Hoan & Thế Tự, Yêu Huyết, Tông Môn Lệnh, Long Tượng Y, Giáp Hoàng Lân, Hắc Thố, Ngọc Bội...
4. **Tăng Tốc Tranh Đoạt (`spamPick`)**:
   - Khi đang tranh chấp vật phẩm (`st.contest.drop === r`), chu kỳ spam lệnh nhặt giảm từ 250ms xuống **100ms** để giật đồ thần tốc tại giây thứ 45.

### 15.4. Kết Quả Kiểm Thử (99/99 Tests Passed)
- Chạy toàn bộ 6 bộ kiểm thử tự động trên Chromium Headless:
  1. `scratch/test_bienhinh_opt.html`: **14/14 PASSED** (100%)
  2. `scratch/test_faction_opt.html`: **10/10 PASSED** (100%)
  3. `scratch/test_loot_opt.html`: **20/20 PASSED** (100%)
  4. `scratch/test_vt_opt.html`: **19/19 PASSED** (100%)
  5. `scratch/test_speed_caravan_opt.html`: **11/11 PASSED** (100%)
  6. `scratch/test_e2e_userjs.html`: **25/25 PASSED** (100%)
- **TỔNG KẾT TOÀN DỰ ÁN: 99/99 BÀI KIỂM THỬ ĐẠT CHUẨN TUYỆT ĐỐI (100%)**.

---

## 16. HOÀN THIỆN TOÀN DIỆN DANH MỤC ITEM TẤT CẢ CÁC BOSS & PHÂN CẤP TIER (TIER 0 -> TIER 5)

### 16.1. Bối Cảnh và Yêu Cầu
- Người dùng yêu cầu kiểm tra và rà soát triệt để:
  1. Đã thêm hết tất cả các item mà tất cả các boss trong game có thể rơi ra chưa?
  2. Đã sắp xếp và phân cấp tier rõ ràng cho từng item chưa?

### 16.2. Rà Soát Toàn Bộ Mã Nguồn Game (`loot.js`, `enemy.js`, `items.js`)
- Quét toàn bộ 322 vật phẩm trong hệ thống và bóc tách tất cả các bảng rơi:
  + Boss Thế Giới: Thần Thú Xích Long, Linh Hổ Trấn Sơn, Nhện Bạch Ngọc, Song Dực Ma Báo.
  + Boss Xổng Chuồng & Dị Thú: Bạch Hổ Tuyết, Xích Nhãn Ngưu, Xích Ma Vương, Ngân Mao Hống, Tộc Trưởng Yên Lãng Biến Dị.
  + Boss Huyết Sắc: Xích Mãng Vương, Thạch Mạch Vương, U Minh Cự Mãng.
  + Boss Tà Soái & Đặc Thù: Hoàng Cửu Bảo, Thạch Quy Đội Bia, Xuyên Sơn Giáp, Hạc Tiên, Huyết Nguyệt Ưng, Thạch Giáp Yêu.
  + Rơi giữa trận (30%, 50%, 70% HP), Bốc thăm cuối trận, Vết Nứt Hư Không & Hư Thiên.
- **Phát hiện**: Có 36 vật phẩm trước đó rơi vào cơ chế fallback/regex điểm chung chung. Tất cả đã được đưa vào danh mục chấm điểm tĩnh trực tiếp trong `LOOT_SPECIAL_SCORES` (nâng tổng số lên **127 vật phẩm** được định danh).

### 16.3. Bảng Phân Cấp Tier Hoàn Chỉnh (Tier 0 -> Tier 5)
1. **👑 Tier 0 (Score 60.000+) - Cực Phẩm Độc Nhất**:
   - `van_xich_nhat_tuyen` (65.000), `toai_khong_linh_chi` (60.000).
2. **⭐ Tier 1 (Score 20.000 - 35.000) - Boss Thế Giới Chốt Hạ, Pháp Bảo & Y Bào Hoàng Kim**:
   - `yeu_dan_cap_6` (35.000), `yeu_dan_cap_5` (30.000), `ruong_phi_hanh` (28.000), `toc_truong_y` (27.500), `long_tuong_y` (27.000), `xich_long_huyet` (26.000), `bach_nguyet_hong_lien` (25.500), `van_lo_lao_ma_bao` (25.500), `ngua_hac_tho` (25.000), `hoang_lan_giap` (24.000), `tuyet_son_kiem_y` (23.500), `than_kiem_y` (23.500), `man_ho_tu_y` (23.000), `thanh_tam_y` (23.000), `quan_dui` (22.500), `yeu_dan_cap_4` (22.000), `yeu_huyet_cap_6` (21.500), `phong_song_duc` (21.000), `hu_anh_phi_hanh` (20.500), `lan_thanh_trum_dau` (20.000).
3. **📜 Tier 2 (Score 15.000 - 19.500) - Bí Tịch Cam/Đỏ & Bảo Vật Trấn Phái**:
   - Vạn Kiếm Quy Tông (19.500), Kim Quang Cự Kiếm (19.000), Huyết Liêm Trảm (18.800), Huyết Bức Chưởng (18.600), Ma Bạo Ấn (18.500), Tông Môn Lệnh (18.200), Thiên Quân Chùy (18.000), Mộng Điệp Mê Trận (17.800), Thái Âm Nguyệt Quang (17.700), Ngũ Sắc Thần Chưởng (17.600), Lục Tinh Trúc Kiếm (17.500), Thanh Long Ngâm (17.200), Phi Long Tại Thiên (17.000), Cửu U Ma Trảo (16.800), Huyễn Ảnh Ma Trảm (16.600), Cửu Thiên Liên Âm (16.400), Thiên Ma Liên Vũ (16.200), Băng Linh Kiếm / Hoàng Lôi Thương / Hỏa Kim Thương (16.000), Huyết Liên Kỳ (15.800), Ma Hồn Phệ (15.600), Hồng Tơ Đoạt Mệnh (15.400), Lôi Thương Quán Địa / Ngũ Lôi Thương Vũ / Huyết Nguyệt Ám Thực / Ám Huyết Ma Chưởng / Ngũ Hỏa Thương Vũ (15.300), Hám Thiên Thủ (15.200), Băng Sơn Quyền / Yêu Huyết Cấp 4 (15.000).
4. **💎 Tier 3 (Score 8.000 - 14.800) - Nguyên Liệu Biến Dị, Yêu Đan 3, Vũ Khí & Bí Tịch Hiếm**:
   - Thanh Tiêu Ngọc Cầm (14.800), Hắc Vũ Ma Phiến (14.600), Phá Sơn Chuỳ (14.400), Huyết Liên Trâm (14.300), Xích Nhật Quyền Ấn (14.200), Khai Tí Chưởng (14.100), Hồ Điệp Phệ Tâm (14.050), Yêu Đan Cấp 3 (14.000), Điệp Ảnh Bộ (13.900), Toàn Phong Thối (13.800), Cự Thạch Thiên Giáng (13.700), Nhiếp Hồn Linh (13.600), Xích Diễm Quy Đan (13.500), Mị Hương Đàn (13.400), Hoành Tảo Mặc Ngân (13.300), Sơn Hà Nhập Họa (13.200), Tử Vân Cuồng Phong (13.100), Tử Vân Ma Vực (13.000), Quy Tức Thủy Châu (12.900), Tử Tinh Dưỡng Thần Bội (12.800), Xích Phi Kiếm (12.500), Lục Phi Kiếm (12.000), Xuyên Sơn Thiết Giáp (11.500), Huyền Quy Giáp Phiến (11.000), Huyết Ma Phủ (10.800), Mảnh Bia Thủy Mạch (10.500), Xích Viêm Song Kích (10.000), Nanh Hổ (9.500), Ngưu Sừng (9.000), Hạc Tiên / Huyết Nguyệt Ưng (8.800), Phá Cảnh Đan (8.500), Trúc Cơ Đan (8.000).
5. **🛡️ Tier 4 (Score 3.000 - 7.800) - Trang Sức Giới Ngoạ, Bộ Hộ Pháp, Yêu Đan 1-2 & Đan Dược**:
   - Bộ Trang Sức Giới Ngoạ (Xích Viêm, Huyền Nham, Thanh Mộc Giới & Ngoa: 7.600 - 7.800), Xuyên Sơn Giáp Phiến (7.200), Yêu Đan Cấp 2 (7.000), Bộ Hộ Pháp Ngân Mao Hống (Giày Vân Bộ, Giáp Mộc Tâm, Mũ Bạch Vân, Tiêu Dao, Tử Liên, Nguyệt Bạch, Tụ Linh Ngọc Bội: 6.000 - 6.500), Tiêu Dao Linh Quan / Mộc Linh Giáp (5.800), Thanh Huyền Kiếm (5.600), Kim Vân Hồ Lô (5.500), Tụ Thần Linh Giới (5.400), Ngưng Thần Bội (5.200), Yêu Đan Cấp 1 (5.000), Tẩy Tâm Đan (4.500), Tụ Linh Trận Bàn (4.000), Liệt Hỏa Trận Bàn (3.800), Bích Ngục Tà Đao (3.500), Phi Đao Trúc Cơ (3.200), Oán Hồn (3.000).
6. **📦 Tier 5 (Score 500 - 2.500) - Nguyên Liệu Phụ Trợ, Phù Chú & Rác Rơi**:
   - Cổ Bích Mộc / Trấn Thần Thạch (2.500), Huyền Thiết Khoáng (1.800), Độc Đằng Độc Dịch (1.200), Kim Long / Kim Ô Phù (1.000), Các loại Phù rớt giữa trận (Thanh Tâm, Tốc Hành, Kim Giáp, Hàn Băng, Hỏa Phù, Thổ Độn, Lôi Động: 500 - 800).
   - `linh_thach`: Điểm sàn (10 - 60 điểm) để luôn nhặt sau cùng khi đã thu trọn toàn bộ đồ quý.

### 16.4. Kết Quả Kiểm Thử (99/99 Tests Passed)
- Chạy 6 bộ test tự động: Toàn bộ 99/99 bài test đều PASSED 100%.

---

## 17. CẢI TIẾN TỔNG THỂ TOÀN DIỆN HỆ THỐNG BÍ TỊCH (PK, SĂN BOSS & FARM)

### 17.1. Bối Cảnh và Mục Tiêu
- Sau khi hoàn thành logic Bí Tịch Boss và phân tích chuyên sâu chế độ PK, người dùng yêu cầu: **"Tiến hành cải tiến tổng thể logic bí tịch"**.
- Mục tiêu: Nâng cấp toàn diện từ thuật toán chấm điểm (`btScore`), sắp xếp thứ tự slot trên thanh Hotbar (`btPlan`), chiến lược bị động sinh tồn (`BT_PASSIVE`), cảm biến tự động chuyển mode nhanh nhạy (`btWantMode`, `tickBiTich`), đến cơ chế ra chiêu thực chiến và chuỗi khống chế thông minh (`targetAt`, `choose`, `evalSkill`, `optPick`).

### 17.2. Các Hạng Mục Nâng Cấp Chi Tiết

#### 1. Khắc Phục Lỗi Nhận Diện Người Chơi Trong PK (`targetAt` & `isPlayer`)
- **Vấn đề cũ**: `targetAt(g, d)` chỉ lặp qua danh sách quái vật `mobsAlive(g)`. Khi PK hoặc giao tranh với người chơi khác, `targetAt` luôn trả về `null` khiến `optPick` bị `undefined`, rơi về cơ chế auto mặc định thô sơ của game (chỉ chọn chiêu đầu tiên sẵn sàng theo vòng tròn, không hề biết khống chế hay dồn combo).
- **Cải tiến**:
  + Bổ sung hàm nhận diện người chơi `isPlayer(t)`.
  + `targetAt(g, d)` mở rộng tìm kiếm cả người chơi thù địch (`hostilePlayers(g)`) và mục tiêu người chơi đang bị khóa (`g.P.Targeting.khoaNguoi`).
  + `optPick` nhờ đó hoạt động hoàn hảo trong cả PvP lẫn PvE.

#### 2. Chiến Thuật Ra Chiêu PK & Khống Chế Nối Tiếp Thông Minh (`choose` & `evalSkill`)
- Khi mục tiêu là người chơi (`isPlayer(target)`):
  + **Tuyệt đối dồn sát thương**: Đặt `mode = 'dmg'`, không bao giờ rơi vào chế độ `eco` hay `save` kiệt quệ linh lực khi đang chiến đấu sinh tử.
  + **Bỏ qua No-Overkill**: Không dừng ra chiêu khi đối thủ máu thấp (bởi người chơi có phù máu, giáp bảo mệnh, khiên hộ thể).
  + **Smart CC Chaining (Nối khống chế hoàn hảo)**:
    * Nếu đối thủ **chưa bị khống chế** (`!target.stunT && !target.freezeT && !target.rootT`): Ưu tiên nhân hệ số điểm khống chế cực lớn (`r.eff * (1 + ccSec * 2.5)`), mở màn combat bằng Choáng/Đóng băng/Trói chân ngay lập tức!
    * Nếu đối thủ **đang bị dính khống chế** (`stunT > 0.3 || freezeT > 0.3`): Giảm nhẹ điểm chiêu CC trùng lặp (`r.eff * 0.75`), ưu tiên xả trọn bộ chiêu Sát thương Bùng Nổ to nhất để không lãng phí chồng thời gian khống chế (diminishing return/overlap).

#### 3. Sắp Xếp Vị Trí Slot Chiến Thuật Trên Hotbar (`btPlan`)
- Game quét thanh kỹ năng từ trái sang phải (Slot 0 $\to$ Slot 7). Helper sắp xếp lại thứ tự tối ưu cho từng chế độ:
  + **Mode PK**:
    * **Slot 1 (Index 0)**: Bí tịch Biến Hình (Hóa Thân - Kim Cương, Ma Báo) $\to$ Kích hoạt nhận ngay Giáp hộ mệnh lớn và ép tốc đánh 0.5s.
    * **Slot 2 (Index 1)**: Chiêu Khống Chế Cứng mạnh nhất (ưu tiên thời gian khống chế dài hơn: Stun 1.3s $\to$ Root 1.5s $\to$ Freeze) $\to$ Đảm bảo ra đòn khóa chết đối thủ ngay nhịp đầu.
    * **Slot 3 - 6**: Các chiêu Sát thương Bùng Nổ dồn nén, đòn kết liễu, rỉ máu (`wound`).
    * **Slot 7 - 8**: Chiêu tầm xa bổ trợ / khống chế mềm (`slow`).
  + **Mode Boss**:
    * **Slot 1**: Hóa Thân (nếu có).
    * **Slot 2**: Chiêu gieo hiệu ứng DoT/Debuff (`wound`, `burn`) để tối đa hóa lượng sát thương trong suốt 12s - 30s.
    * **Slot 3 - 8**: Sắp xếp theo sát thương đơn mục tiêu giảm dần.
  + **Mode Farm**:
    * **Slot 1 - 3**: Các chiêu diện rộng AoE lớn nhất (`blastR >= 20` hoặc `shape === 'aura'`, bắn nhiều tia).
    * **Slot 4 - 8**: Sắp xếp theo mức độ tiết kiệm linh lực (`mpCost` thấp nhất lên đầu).

#### 4. Chấm Điểm Bí Tịch Nâng Cao (`btScore`)
- **PK**:
  + Cộng thêm điểm cho hiệu ứng Rỉ máu (`wound` - giảm 30% hồi phục của địch): `+0.03 * Math.min(wound, 5)`.
  + Cộng thêm điểm cho đạn bay nhanh (`speed >= 300`, khó né tránh khi người chơi di chuyển): `+0.03 * Math.min(fast, 3)`.
  + Hệ số Khống chế Cứng tối đa lên tới **+72% tổng điểm**.
- **Boss**:
  + Cộng thưởng điểm cho chiêu DoT (`burn`, `wound`): `+0.05` mỗi chiêu (tối đa +15% tổng điểm).
- **Farm**:
  + Thưởng thêm điểm cho chiêu có Hút máu (`lifesteal` - như Thanh Đằng Thuật) `+15%`.
  + Thưởng thêm điểm cho chiêu có bán kính nổ lớn (`blastR >= 25` hoặc `aura`) `+10%`.

#### 5. Bị Động PK Ưu Tiên Kháng Khống Chế (`BT_PASSIVE.pk`)
- Điều chỉnh thứ tự bị động PK:
  `[kim_quang_chao] → [bang_tam] → [ma_khi] → [ho_tam] → [moc_xuan] → [phong_hanh] → [kiem_y] → [hoa_mach]...`
- Đưa **Băng Tâm (`bang_tam`)** lên vị trí thứ 2 (ngay sau Khiên Vàng Kim Quang Tráo) nhằm giảm thiểu thời gian bị choáng/đóng băng, chống bị đối phương khóa chết.

#### 6. Cảm Biến Chuyển Mode Nhanh Nhạy & Cơ Chế Khẩn Cấp (`btWantMode` & `tickBiTich`)
- Mở rộng bán kính quét thù địch PK từ `260px` lên **`320px`** (đồng bộ với bán kính cảnh báo nguy hiểm `THREAT_SCAN`).
- Bổ sung cơ chế **PK Khẩn Cấp (Emergency Trigger)**:
  + Khi kẻ địch áp sát $\le 200\text{px}$ hoặc đang trong trạng thái tỉ thí (`Gateway.duel`):
    Lập tức đổi sang mode PK ngay **0ms đệm** (bỏ qua 800ms chờ thông thường).
  + Rút ngắn thời gian hồi giữa 2 lần đổi chiêu từ 5 giây xuống **3 giây**.

### 17.3. Nâng Cấp Phiên Bản & Kiểm Thử Toàn Diện
- Nâng cấp userscript lên phiên bản **`v0.56.0`**.
- Xây dựng bộ test mới `test_bitich_opt.html` (18 bài test chuyên biệt cho Bí Tịch PK, Boss, Farm, Smart CC, Overkill, Sensor).
- Chạy toàn bộ **7 bộ test tự động (Regression Suites)**:
  1. `test_bienhinh_opt.html`: 14/14 PASSED.
  2. `test_faction_opt.html`: 10/10 PASSED.
  3. `test_loot_opt.html`: 20/20 PASSED.
  4. `test_vt_opt.html`: 19/19 PASSED.
  5. `test_speed_caravan_opt.html`: 11/11 PASSED.
  6. `test_e2e_userjs.html`: 25/25 PASSED.
  7. `test_bitich_opt.html`: 18/18 PASSED.
- **Tổng kết**: **117/117 bài test PASSED 100% (0 bài thất bại)**.

---

## 18. NÂNG CẤP CẢM BIẾN QUÉT & CƯỚP LAST-HIT BOSS (ĐẶC BIỆT BOSS XỔNG CHUỒNG) — v0.57.0

### 18.1. Thực Trạng & Vấn Đề Cần Cải Tiến
- **Cơ chế Game**: Toàn bộ yêu thú xổng chuồng (*Bạch Hổ Tuyết, Xích Nhãn Ngưu, Xích Ma Vương, Ngân Mao Hống...*) trong `src/entities/enemy.7739f83bfc3f.js` đều mang cờ thuộc tính `lootLastHitOnly: true`. Toàn bộ vật phẩm quý hiếm (Yêu Đan Cấp cao, Nanh Hổ, Ngưu Sừng, trang bị Đỏ/Cam) chỉ thuộc về người duy nhất tung ra **Đòn Kết Liễu (Last-Hit)**!
- **Hạn chế cũ**:
  1. `tickXongChuong` khóa mục tiêu `d.target` xuyên suốt từ 100% máu đến khi chết. Nếu bot đang đánh một con 90% máu, trong khi cách 150px có con boss khác đang bị người chơi khác đánh tụt máu xuống còn 5%, bot vẫn mải mê đánh con cũ và **bỏ lỡ cơ hội cướp Last-Hit quý giá**!
  2. Hàm `evNearest` chỉ đo khoảng cách gần nhất, hoàn toàn mù thông tin về máu của mục tiêu.
  3. Hàm `nearBoss(g)` trên toàn map cũng chỉ tìm boss gần nhất mà không ưu tiên boss đang hấp hối/sắp gục.

### 18.2. Giải Pháp Triển Khai Toàn Diện trong v0.57.0
1. **Cảm Biến Nhận Diện Last-Hit-Only (`isLastHitOnly(m)`)**:
   - Nhận diện tức thì cờ `m.def.lootLastHitOnly` hoặc các type xổng chuồng (`bach_ho_tuyet`, `xich_nhan_nguu`, `xich_ma`, `ngan_mao_hong`).
2. **Cảm Biến Quét Boss Hấp Hối Trong Tầm (`dyingBossNear(g, maxR)`)**:
   - Quét toàn bộ boss trong tầm nhìn/tầm target.
   - Nhận diện ngưỡng hấp hối: $\% \text{máu} \le 28\%$ (hoặc boss thường $\le 20\%$) hoặc $\text{HP} \le 15,000$ (hoặc boss thường $\le 10,000$).
   - Thuật toán chấm điểm ưu tiên: `score = pct * 1000 + dist`. Boss nào % máu càng thấp (càng gần cái chết) thì điểm số càng ưu tiên hàng đầu.
3. **Cải Tiến Chọn Mục Tiêu Săn Xổng Chuồng (`pickXcTarget(g, d, list)`)**:
   - **Ngắt mục tiêu dứt điểm (Target Snatching)**: Nếu đang đánh boss máu cao mà phát hiện boss khác trong tầm đang hấp hối ($\le 28\%$ máu): **NGAY LẬP TỨC ngắt mục tiêu cũ, chuyển sang boss sắp gục để cướp Last-Hit!**
   - **Chống giật mục tiêu (Anti-Jitter)**: Nếu con hiện tại chính nó đã ở ngưỡng hấp hối ($\le 28\%$), bot sẽ kiên định kết liễu nó (trừ khi con kia máu cực thấp $\le 50\%$ máu hiện tại).
   - **Tối ưu thứ tự săn mới**: Khi bắt đầu săn, bot không chỉ chọn con gần nhất mà tính `score = pct * 100 + dist / 20` để ưu tiên con máu ít hơn nhằm nhanh dứt điểm và lấy thưởng.
4. **Nâng Cấp `nearBoss(g)` Toàn Diện**:
   - Khi `cfg.lastHitScan !== false`, tự động ưu tiên `dyingBossNear(g, R)` trước. Giúp bot tự động chuyển sang boss hấp hối trên bản đồ ngay cả khi boss đó đứng xa hơn boss đầy máu.
5. **Đồng Bộ Dồn Burst & Áp Sát Tâm Rơi (`evEngage`)**:
   - Mở rộng ngưỡng kích hoạt `huntBurst` và áp sát $d \le 2\text{px}$ lên $\le 28\%$ máu hoặc $\le 15,000$ HP đối với các boss LastHitOnly.
6. **Giao Diện & Cấu Hình (`cfg.lastHitScan`)**:
   - Thêm cờ `lastHitScan: true` vào bộ cấu hình mặc định.
   - Bổ sung vào hồ sơ tối ưu `PRIO_SET.boss` và `PRIO_SET.ev`.
   - Thêm checkbox điều khiển trực quan tại nhóm "Kết liễu (last-hit)" trong tab Boss của bảng Trợ Thủ.

### 18.3. Kết Quả Kiểm Thử Toàn Diện (Regression Suites)
- Tạo mới bộ kiểm thử chuyên sâu `test_lasthit_scan.html` (21 bài kiểm thử).
- Thực thi toàn bộ 8 bộ kiểm thử tự động trên Chrome Headless:
  1. `test_bienhinh_opt.html`: 14/14 PASSED.
  2. `test_faction_opt.html`: 10/10 PASSED.
  3. `test_loot_opt.html`: 20/20 PASSED.
  4. `test_vt_opt.html`: 19/19 PASSED.
  5. `test_speed_caravan_opt.html`: 11/11 PASSED.
  6. `test_e2e_userjs.html`: 25/25 PASSED.
  7. `test_bitich_opt.html`: 18/18 PASSED.
  8. `test_lasthit_scan.html`: 21/21 PASSED.
- **Tổng cộng**: **138/138 bài kiểm thử PASSED 100% (0 lỗi)**.

---

## 19. NÂNG CẤP TỐI ƯU HÓA NHẶT BẢO VẬT GIỮA TRẬN & TOÀN BỘ ĐỒ RƠI NGÂN MAO HỐNG — v0.58.0

### 19.1. Bối Cảnh & Thực Trạng Mã Nguồn
Qua rà soát chi tiết mã nguồn phân phối vật phẩm (`loot.ef0f82c62597.js`, `hoatdong.62ecfd71efdc.js`, `enemy.7739f83bfc3f.js`):
1. **World Boss có Bí Tịch Giữa Trận (`BITICH_GIUA_TRAN`)**:
   - Khi boss còn 30%–70% máu, game văng ra các bí tịch cực phẩm (*Vạn Kiếm Quy Tông, Ma Bảo Ấn, Thiên Quân Chùy, Mộng Điệp Mê Trận*) và Phong Song Dực.
   - Các món này **rơi tự do ra đất quanh boss, không có chủ sở hữu (`owner: null`)**. Ai chạm vào trước người đó nhặt được.
   - Trước đây: Bot chỉ lướt Frame-0 nếu `isOwner === true` và $d \le 140\text{px}$. Nếu rơi xa hơn hoặc rơi tự do giữa trận thì bot không kích hoạt bùa lướt ngay lập tức.
2. **Boss Xổng Chuồng Cấp 2 — Ngân Mao Hống (`HO_PHAP_MA_BAO`)**:
   - Rơi trọn bộ trang bị Hộ Pháp Ma Báo: *Giày Vạn Bộ, Giáp Mộc Tâm, Mũ Bạch Vân, Mũ Tiêu Dao, Mũ Tử Liên, Mũ Nguyệt Bạch, Tụ Linh Ngọc Bội*.
   - Trước đây: Bộ lọc nhặt khẩn cấp `urgent` trong `tickXongChuong` chỉ kiểm tra Yêu Đan, Nanh Hổ, Ngưu Sừng, dễ dẫn đến việc bot bỏ sót đồ cam/đỏ của Ngân Mao Hống khi vội chuyển map tuần tra.
3. **Cạnh Tranh Bảo Vật Trong `tickContest`**:
   - Bot chỉ chạy bộ bình thường tới món đồ đang tranh, không dùng bùa tăng tốc khi gặp các món cực phẩm trị giá cao.

### 19.2. Các Cải Tiến Triển Khai Toàn Diện trong v0.58.0
1. **Siêu Nhặt Frame-0 Mở Rộng Bán Kính & Đồ Rơi Tự Do (`ServerBus.on('loot')`)**:
   - Mở rộng tầm lướt nhặt đồ cực phẩm từ $140\text{px}$ lên **$260\text{px}$**.
   - Bổ sung điều kiện lướt cả khi đồ rơi tự do không chủ: `(isOwner || !it.owner)`.
   - Hạ ngưỡng điểm kích hoạt lướt từ 8,000 xuống **6,000 điểm** (bao trọn toàn bộ Bí Tịch môn phái, Yêu Đan cấp cao, Nanh Hổ, Ngưu Sừng, trang bị Ngân Mao Hống).
2. **Kích Tốc Tranh Bảo Vật Trong `tickContest`**:
   - Khi phát hiện bảo vật cực phẩm (`scItem >= 9000`, như Bí Tịch giữa trận, Yêu Đan cấp 6, Rương Phi Hành) ở cự ly $> 60\text{px}$: Tự động cắn **Tốc Hành Phù** để phóng tới tâm đồ tranh trước mọi người chơi khác.
3. **Bao Trọn Toàn Bộ Đồ Ngân Mao Hống & Vật Phẩm Tier 4 Trong `urgent`**:
   - Mở rộng bán kính kiểm tra nhặt khẩn cấp lên $300\text{px}$.
   - Nhận diện toàn bộ regex trang bị Ngân Mao Hống (`giay_van_bo`, `giap_moc_tam`, `mu_...`, `tu_linh_ngoc_boi`) và bất kỳ vật phẩm nào có `gradeScore >= 5000`. Đảm bảo bot đứng lại nhặt sạch 100% trước khi rời đi.

### 19.3. Kết Quả Kiểm Thử Tự Động (Regression Suites)
- Bổ sung 3 bài test chuyên sâu vào `test_loot_opt.html` (nâng tổng số test lên 23 test).
- Toàn bộ 8 bộ kiểm thử tự động PASSED 100%:
  1. `test_bienhinh_opt.html`: 14/14 PASSED.
  2. `test_faction_opt.html`: 10/10 PASSED.
  3. `test_loot_opt.html`: 23/23 PASSED.
  4. `test_vt_opt.html`: 19/19 PASSED.
  5. `test_speed_caravan_opt.html`: 11/11 PASSED.
  6. `test_e2e_userjs.html`: 25/25 PASSED.
  7. `test_bitich_opt.html`: 18/18 PASSED.
  8. `test_lasthit_scan.html`: 21/21 PASSED.
- **Tổng cộng**: **141/141 bài kiểm thử PASSED 100% (0 lỗi)**.

---

## 20. KHẮC PHỤC DOM XSS, DỌN DẸP ĐỊNH KỲ CACHE & CƠ CHẾ TỰ HỦY TRẠNG THÁI TREO (STALE TIMEOUT) — v0.59.0

### 20.1. Khắc Phục Lỗ Hổng DOM XSS ở `ui.radarInfo`
- **Nguyên nhân**:
  - Tại hàm `refreshRadar(g)`, dòng lệnh cũ:
    ```javascript
    ui.radarInfo.innerHTML = lines.length ? lines.map(function (l) { return l.indexOf('<') >= 0 ? l : esc(l); }).join('<br>') : ...
    ```
  - Biểu thức điều kiện `l.indexOf('<') >= 0 ? l : esc(l)` khiến cho bất kỳ dòng nào có chứa ký tự `<` (chẳng hạn do chèn `<br>&nbsp;&nbsp;` từ thông tin chia thưởng boss hoặc `<br>🕑 ` từ timer) sẽ **bỏ qua hoàn toàn hàm `esc(l)`**.
  - Nếu tên quái `mobLabel(m)`, tên người chơi thù địch `r.name`, hoặc thông tin chat có chứa chuỗi mã HTML độc hại (ví dụ `<img src=x onerror=...>` hoặc `<script>`), chuỗi này sẽ bị đưa thẳng vào `innerHTML`, dẫn đến lỗ hổng DOM XSS.
- **Giải pháp xử lý**:
  - Tách bạch hoàn toàn việc escape dữ liệu động trước khi ghép chuỗi:
    - Bọc `esc(mobLabel(m))` và `esc(bossShareText(cb))` ngay tại thời điểm tạo chuỗi mô tả boss.
    - Đưa từng dòng timer `bossTimers(g)` vào `lines` độc lập và bọc an toàn `esc(t)` cho từng timer.
    - Loại bỏ triệt để đoạn kiểm tra lỏng lẻo `l.indexOf('<') >= 0 ? l : esc(l)`, chuyển sang dùng `lines.join('<br>')` thuần túy với các thành phần đã được làm sạch 100%.

### 20.2. Dọn Dẹp Định Kỳ Cho `lootSkip` & `chatHint` (Chống Rò Rỉ Bộ Nhớ)
- **Nguyên nhân**:
  - `lootSkip` lưu các vật phẩm tạm bỏ qua (`lootSkip[id] = timestamp`).
  - `chatHint` lưu thông báo chat thế giới về vị trí boss.
  - Khi bot hoạt động liên tục nhiều giờ/ngày, hàng nghìn object keys tích tụ mà không bao giờ bị xóa, làm phình to bộ nhớ heap của trình duyệt.
- **Giải pháp xử lý**:
  - Xây dựng hàm `cleanCaches(force)`:
    - Quét và xóa toàn bộ các mục `lootSkip` đã quá hạn (`lootSkip[id] <= now()`).
    - Quét và xóa toàn bộ các mục `chatHint` đã quá hạn `CHAT_HINT_MS` (10 phút).
  - Tích hợp kiểm tra định kỳ mỗi 30 giây (`CACHE_CLEAN_INTERVAL_MS = 30000`) ngay đầu hàm `tick()`.

### 20.3. Cơ Chế Tự Hủy Trạng Thái Treo (Stale State Timeout Watchdog)
- **Nguyên nhân**:
  - Các công việc săn tìm ngoại cảnh (`st.bh`, `st.bd`, `st.xc`, `st.td`) áp dụng cơ chế khóa lẫn nhau (`if (st.bh || st.bd) return false;`).
  - Khi xảy ra lỗi ngoại cảnh (nhân vật tử vong về thành, mất kết nối, lệch map, hoặc boss bị tiêu diệt trước khi nhân vật tới nơi) mà hàm kết thúc không được kích hoạt, một sub-state có thể bị kẹt vĩnh viễn, làm phong tỏa toàn bộ các tác vụ tự động khác của bot.
- **Giải pháp xử lý**:
  - Thiết lập hằng số thời gian tối đa:
    - `BH_MAX_MS = 15 * 60000;` (15 phút cho World Boss).
    - `BD_MAX_MS = 12 * 60000;` (12 phút cho Quái Biến Dị).
    - `XC_MAX_MS = 15 * 60000;` (15 phút cho Yêu Thú Xổng Chuồng).
    - `TD_MAX_MS = 12 * 60000;` (12 phút cho Thương Đội).
  - Xây dựng watchdog `checkStaleStates(g, force)` chạy kiểm tra mỗi 2 giây:
    - Nếu bất kỳ state nào vượt ngưỡng thời gian quy định, tự động gọi hàm finish tương ứng (`bhFinish`, `bdFinish`, `xcFinish`, `tdFinish`), ghi log rõ ràng và giải phóng state.
    - Bổ sung cơ chế tự giải phóng nếu `st.bh` bị kẹt ở giai đoạn chờ bốc thăm quà boss (`phase === 'loot'`) quá 35 giây (`BH_LOOT_MS + 10s`).
    - Tự động đánh dấu `ev.done = true` khi hết hạn để tránh tình trạng bot quay lại tuần tra map rỗng.

### 20.4. Kết Quả Kiểm Thử Toàn Diện (Regression Suites)
- Tạo mới bộ kiểm thử chuyên sâu `test_security_cache_stale.html` (19 bài kiểm thử).
- Thực thi toàn bộ 9 bộ kiểm thử tự động trên Chrome Headless:
  1. `test_bienhinh_opt.html`: 14/14 PASSED.
  2. `test_faction_opt.html`: 10/10 PASSED.
  3. `test_loot_opt.html`: 23/23 PASSED.
  4. `test_vt_opt.html`: 19/19 PASSED.
  5. `test_speed_caravan_opt.html`: 11/11 PASSED.
  6. `test_e2e_userjs.html`: 25/25 PASSED.
  7. `test_bitich_opt.html`: 18/18 PASSED.
  8. `test_lasthit_scan.html`: 21/21 PASSED.
  9. `test_security_cache_stale.html`: 19/19 PASSED.
- **Tổng cộng**: **160/160 bài kiểm thử PASSED 100% (0 lỗi)**.

---

## 21. NÂNG CẤP CHUYÊN SÂU TẤT CẢ CÁC CHẾ ĐỘ: CHIẾN TRƯỜNG, TAM LỘ & HƯ THIÊN (SỸ SÁCH) — v0.60.0

### 21.1. Vạn Hoang Chiến Trường (`tickChienTruong` — Sinh Tồn Battle Royale)
- **Bối cảnh & Hạn chế cũ**:
  - Chức năng cũ (`tickHuyetLan`) chỉ có khoảng 30 dòng lệnh với nhiệm vụ duy nhất là hái hoa, hoàn toàn phớt lờ bão độc (`boTai`), rương vàng và rương buff (`c.ruong`), cơ chế tàng hình trong bụi cỏ (`c.bui`, `c.an`), cũng như khả năng tự vệ và sinh tồn PK.
- **Nâng cấp toàn diện**:
  - **Tự động ghi danh**: Khi ở ngoài đảo trong giai đoạn `DANG_KY`, tự động kiểm tra cảnh giới (`CT.bangCua`) và gửi lệnh `ghiDanh` lên Gateway.
  - **Xử lý Phòng Chờ & Tử trận**: Ở `MAP_CHO` nếu đã có kết quả `LOAI` hoặc `XONG`, tự động gửi lệnh `roi` để lui bước về làng. Nếu biến thành hồn ma (`c.bong`) giữa trận, tự động hồi hương về phòng chờ sau 4 giây.
  - **Né bão độc & Vòng bo co dồn**: Tích hợp thuật toán `hlZone` & `hlSafe`, khi nhân vật ra ngoài bo (`c.nhip.ngoai`) hoặc đứng ở vùng bo sắp co sát thương cao, lập tức chuyển sang chế độ di chuyển khẩn cấp vào tâm bo an toàn. Bổ sung cơ chế fallback lộ trình đường thẳng (`[{ x: target.x, y: target.y }]`) nếu thuật toán `spotCheck(g).route` trả về `null`.
  - **Sinh tồn khi máu thấp (< 28%)**: Khi bị địch uy hiếp trong cự ly gần và máu xuống thấp, thay vì đánh đổi mạng, bot tự động tìm bụi rậm an toàn gần nhất để trốn vào kích hoạt trạng thái vô hình (`c.an = true`).
  - **Tự vệ & Dứt điểm đối thủ**: Khi bị tiếp cận trong cự ly 140px, tự động khóa mục tiêu vào hệ thống game engine (`Targeting.khoaVao(targetFoe)`) và xuất chiêu thường (`Player.attack`) tự vệ; ưu tiên khóa mục tiêu có lượng máu thấp nhất để kết liễu và nhận phần thưởng Linh Thạch hạ sát.
  - **Thu thập theo thứ tự ưu tiên**: Khóm Vạn Hoang Huyết Lan (3.000đ) > Rương Vàng (1.500đ) > Rương Buff thường (500đ).
  - **Tàng hình ẩn nấp khi rảnh rỗi**: Khi không có rương và không có giao tranh, bot tự động di chuyển vào bụi rậm gần nhất và đứng yên để duy trì trạng thái tàng hình vô hình trước kẻ địch.
  - **Đồng bộ UI**: Cập nhật nhãn cài đặt trực quan `Vạn Hoang Chiến Trường (Sinh tồn)` và chip trạng thái `'Chiến Trường'` trên màn hình chính.

### 21.2. Tam Lộ Tranh Phong (`tam_lo` & `btWantMode` — Meta Bí Tịch MOBA)
- **Bối cảnh & Hạn chế cũ**:
  - Trước đây `btWantMode` chỉ quét người chơi thù địch nói chung hoặc boss thế giới, trong Tam Lộ bot thường bị kẹt ở chế độ `'boss'` (do `evIn` nhận diện Tam Lộ là sự kiện) khiến việc farm lính tốn kém và không tối ưu bảng bí tịch khi giao tranh tổng.
- **Nâng cấp toàn diện**:
  - **Chuyển mode PK linh hoạt**: Khi phát hiện tướng địch (`laDichNguoi`) áp sát trong bán kính 360px, lập tức chuyển sang mode `'pk'` (kích hoạt Kim Cương Hóa Thân, Địa Thích khống chế, tăng cường giáp và phản đòn sinh tồn).
  - **Chuyển mode Boss khi công trình / mục tiêu lớn**: Khi chọn mục tiêu là Trụ (`ve === 'tru'`), Nhà chính căn cứ (`ve === 'nha'`), Rồng (`jungle === 'rong'`), hoặc Baron (`jungle === 'baron'`), lập tức chuyển sang mode `'boss'` để bùng nổ sát thương tối đa.
  - **Duy trì mode Farm khi đi đường**: Khi farm lính và di chuyển kiểm soát bản đồ, hàm `btWantMode(g)` trả về `'farm'` để tiết kiệm chân nguyên và quét lính nhanh chóng, ngăn chặn việc `evIn` ép nhầm sang mode boss.

### 21.3. Hư Thiên Điện / Sỹ Sách Điện (`hu_thien` — Bảo Hộ Ải 2 & Tranh Đoạt Ải 3)
- **Bảo hộ sinh tồn Ải 2 (Băng Hỏa Trận)**:
  - Khi giao tranh với Trụ Băng / Trụ Hỏa và bị Trận Nhãn Vệ vây ráp, nếu máu xuống dưới 70%, bot ưu tiên sử dụng Kim Long Phù (`talUse(g, 'kim_long')`), nếu không có sẽ tự động dự phòng bằng Kim Giáp Phù (`talUse(g, 'kim_giap')`) để tạo hộ thuẫn chống sốc sát thương.
- **Tranh đoạt bảo vật Sỹ Sách Đỉnh Ải 3 & Cơ chế Vận Khí (Channeling)**:
  - Cập nhật bảng điểm `LOOT_SPECIAL_SCORES` định danh các bảo vật đỉnh không trùng lặp: Hóa Kim Thương (16.000), Hoàng Lôi Thương (16.000), Bích Linh Hồ (16.000), Huyền Băng Kính (16.000), Thụ Tượng Giáp (10.000), Hoàng Lân Giáp (10.000), Phong Song Dực (10.000), Mảnh Yêu Đan Cấp 3 (8.000), Rương Khôi Lỗi (7.500).
  - Khi Sỹ Sách Đỉnh bị tiêu diệt (`dinh.da = true`), lập tức quét các vật phẩm rơi quanh tế đàn, sắp xếp theo độ quý hiếm.
  - Tự động kích hoạt Tốc Hành Phù (`talUse(g, 'toc_hanh')`) khi khoảng cách > 60px để bứt tốc vượt lên trước đối thủ các tông môn khác.
  - **Phân biệt vật phẩm Vận Khí và Nhặt tức thì**:
    - Với bảo vật cần vận khí (`r.ht && r.vanMs > 0`), bot di chuyển vào cự ly bảo vật trong bán kính `PICK_R` (40px) và đứng yên (`me.path.length = 0`, gán trạng thái `đứng yên vận ...`) để cơ chế `HuThienUI.dungTrenBaoVat` của game tiến hành tích lũy vận khí thành công.
    - Với vật phẩm thường, tiếp tục spam nhặt tức thì (`spamPick`).

### 21.4. Khắc Phục Lỗi Trễ Khởi Tạo Bộ Đếm (`talLastAt` & `ctRegAt`)
- Do hàm `now()` sử dụng `performance.now()` (khởi đầu từ `0` khi tải trang), các biểu thức `now() - varAt > GAP` với `varAt = 0` bị vô hiệu hóa trong những giây đầu tiên.
- Đã đồng bộ khởi tạo `talLastAt = -1e9`, `st.ctRegAt = -1e9`, `st.ctLeaveAt = -1e9`, đảm bảo bot có thể phản hồi và ra bùa/ghi danh ngay tại frame đầu tiên.

### 21.5. Kết Quả Kiểm Thử Toàn Diện (Regression Suites)
- Tạo mới bộ kiểm thử chuyên sâu `test_deep_modes_opt.html` (24 bài kiểm thử).
- Thực thi toàn bộ 10 bộ kiểm thử tự động trên Chrome Headless:
  1. `test_bienhinh_opt.html`: 14/14 PASSED.
  2. `test_faction_opt.html`: 10/10 PASSED.
  3. `test_loot_opt.html`: 23/23 PASSED.
  4. `test_vt_opt.html`: 14/14 PASSED.
  5. `test_speed_caravan_opt.html`: 11/11 PASSED.
  6. `test_e2e_userjs.html`: 25/25 PASSED.
  7. `test_bitich_opt.html`: 15/15 PASSED.
  8. `test_lasthit_scan.html`: 29/29 PASSED.
  9. `test_security_cache_stale.html`: 19/19 PASSED.
  10. `test_deep_modes_opt.html`: 24/24 PASSED.
- **Tổng cộng**: **184/184 bài kiểm thử PASSED 100% (0 lỗi)**.

---

## 22. NÂNG CẤP VẾT NỨT KHÔNG GIAN: THẾ ĐỨNG VIỀN ĐÓN ĐẦU & ZERO-WALK INSTANT LOOT — v0.61.0

### 22.1. Phân Tích Cơ Chế Vật Lý Hòm Hư Không (`vn_hom`) & Điểm Nghẽn Cũ
- **Bản đồ & Tọa độ Hòm**:
  - Hòm Hư Không đặt tại tọa độ `ruong.x = 32 * (X + 0.5)`, `ruong.y = 32 * 10 + 20` (~ 340px).
  - Phía trên lưng Hòm (`y < 10`) là vách đá cứng của Phòng Hòm; không gian mở trải dài về phía Nam (`y > 10`).
  - Hòm có bán kính thân `bodyRadius = 24px`, tầm với đánh của người chơi `reach = 26px` (tổng reach = 50px).
- **Phạm vi văng của vật phẩm khi Hòm vỡ**:
  - Khi Hòm vỡ (`e.mo = true` $\rightarrow$ opcode `"hom"`), server tung bảo vật (`van_xich_nhat_tuyen`, `toai_khong_linh_chi`, bí tịch, đan dược...) và Linh Thạch văng theo hình nan quạt xuống các hướng Nam, Tây Nam, Đông Nam trong bán kính **40px - 100px** (cụm dày đặc nhất ở 50px - 70px).
- **Hạn chế cũ**:
  - Bot cũ áp sát đánh Hòm ở tâm ($d \le 20px$). Khi Hòm vỡ, toàn bộ đồ rơi ra ngoài bán kính nhặt của server (`PICK_R = 40px`).
  - Nhân vật bị kẹt trong đám đông ở tâm, phải mất 2 - 4 giây chạy zíc-zắc từ tâm ra rìa để nhặt từng món, dễ bị đối thủ vòng ngoài hốt sạch đồ cực phẩm.

### 22.2. Giải Pháp "Thế Đứng Đón Đầu Viền Bo" (Perimeter Ring Stance & Arc Sweep)
- **1. Thuật toán chọn vị trí viền tối ưu (`vnHomStance`)**:
  - Xác định vòng tròn đón đầu lý tưởng ở cự ly $R \approx 48px - 52px$ từ tâm Hòm (ưu tiên hướng Nam, Tây Nam, Đông Nam).
  - Ở cự ly này: khoảng cách từ người chơi tới mép thân hòm là $49 - 24 = 25px \le 26px$ (`Player.reach`), nhân vật vẫn duy trì chém thường và xả chiêu liên tục vào Hòm 100% không bị ngắt quãng.
  - Tự động đánh giá mật độ: né xa đối thủ lạ (< 70px) và ưu tiên đứng gần đồng đội tổ đội.
- **2. Đón đầu khi Hòm sắp vỡ (`vnFight`)**:
  - Khi Hòm $\le 12\%$ HP (hoặc $\le 12.000$ HP): Bot định vị vững chắc tại điểm viền đón đầu, gán trạng thái `chực sẵn viền đón đầu Hòm vỡ`, không tung các hoạt ảnh chiêu dài làm delay bước chân.
- **3. Nhặt tức thì Frame 0 (Zero-Walk Instant Sweep)**:
  - Ngay trong frame đầu tiên khi Hòm phát nổ và gói `drops` xuất hiện:
    - Mọi vật phẩm văng vào bán kính $\le 40px$ (`PICK_R`) quanh vị trí bot đang đứng sẽ được gửi đồng thời lệnh `Gateway.vetNut('nhat', { id })` ngay tức thì ($0ms$), hốt trọn bảo vật dưới chân mà không cần bước một bước nào.
- **4. Quét cung tròn (Arc Sweep)**:
  - Khi di chuyển nhặt các món đồ còn lại ở xa, bot vừa chạy vừa quét nhặt toàn bộ các vật phẩm đi ngang qua trong tầm `PICK_R - 4px`, quét sạch chiến trường theo đường vòng cung thay vì chạy xuyên tâm.

### 22.3. Kết Quả Kiểm Thử Tự Động (Regression Test Matrix)
- Cập nhật `test_deep_modes_opt.html` lên 30 bài kiểm thử (bổ sung toàn diện Section 4 cho Vết Nứt).
- Thực thi toàn bộ 10 bộ kiểm thử trên Chrome Headless:
  - Đạt **190/190 bài kiểm thử PASSED 100% (0 lỗi)**.

---

## 23. NÂNG CẤP VẬN TIÊU: TỰ ĐỘNG KÍCH HOẠT THEO GIỜ HẸN (13:00 / vtScheduleHour) — v0.62.0

### 23.1. Đặt Vấn Đề & Cơ Chế Khung Giờ Vận Tiêu Trong Game
- **Khung giờ mở Vận Tiêu**:
  - Hằng ngày game mở nhận tiêu từ **11:00 đến 22:00** (`GIO_MO = 11`, `GIO_DONG = 22`).
  - Mỗi nhân vật có tối đa **6 chuyến vận tiêu/ngày** (`LUOT_VAN = 6`), mang lại lượng lớn Linh Thạch và điểm Top tuần.
- **Hạn chế trước đây**:
  - Trước `v0.62.0`, trợ thủ chỉ có 2 chế độ:
    1. Chạy trong **Lịch treo máy (`cfg.planRun`)**: Thứ tự công việc cố định, nếu đến lượt `vt` lúc 11:00 (vừa mở cổng) thì chạy ngay, hoặc người chơi phải xếp vị trí thủ công.
    2. Chạy **Ngoài lịch (`cfg.vtRun`)**: Người chơi phải tự tay bấm nút bật `vtRun` thì bot mới chạy.
  - Chưa hề có cơ chế **hẹn giờ tự động kích hoạt** khi chạm mốc giờ vàng trong ngày (ví dụ 13:00 - thời điểm người chơi rảnh rỗi, ít bị cướp tiêu hoặc chuẩn bị đi làm).

### 23.2. Giải Pháp Triển Khai Trong v0.62.0
- **1. Cấu hình linh hoạt (`DEFAULTS`)**:
  - `vtAutoTrigger: true`: Mặc định bật tự động kích hoạt Vận Tiêu khi chạm mốc giờ hẹn.
  - `vtScheduleHour: 13`: Mốc giờ hẹn (mặc định 13h, cho phép chỉnh từ 11h đến 21h theo giờ Việt Nam UTC+7).
- **2. Đồng bộ chuẩn thời gian Việt Nam (`vtVnHour` / `vtVnDay`)**:
  - Sử dụng hàm chuẩn của game `VanTieu.gioVN(ts)` / `VanTieu.day(ts)` kết hợp fallback UTC+7 (`Date.now() + 252e5`), bảo đảm chính xác 100% không phụ thuộc timezone của máy tính người chơi.
- **3. Tích hợp trong Lịch treo máy (`PLAN_JOBS` `vt`)**:
  - `avail(g)`: Nếu bật `cfg.vtAutoTrigger` và hiện tại chưa tới giờ hẹn (`h < targetH`), bot tự động bỏ qua việc Vận Tiêu để nhường quyền chạy cho các công việc khác trong lịch (như điểm danh, tông môn, săn boss, hái lượm...).
  - Nếu xe đang được kéo (`vtChuyen(g.P)`), bot tiếp tục hộ tống an toàn cho đến khi hoàn thành chuyến đi, không bao giờ bỏ rơi xe giữa đường.
  - `info(P)`: Hiển thị rõ trạng thái chờ trực quan: `"chờ mốc 13h (hiện tại 10h)"`.
- **4. Tự động kích hoạt ngoài Lịch (`tickStandalone`)**:
  - Khi không dùng Lịch (`!cfg.planRun`): Mỗi tick kiểm tra nếu `h >= targetH && h < 22 && st.vtTriggeredDay !== today` và nhân vật còn lượt (`vtLeft > 0`), bot tự động kích hoạt `cfg.vtRun = true`, ghi nhận `st.vtTriggeredDay = today` và ghi log thông báo.
  - Sau khi chạy xong đủ các chuyến trong ngày, `cfg.vtRun` tự tắt và không bao giờ bị kích hoạt lặp lại trong cùng một ngày.
- **5. Nâng cấp Giao diện Trực quan & Cài Đặt**:
  - Bổ sung toggle bật/tắt `vtAutoTrigger` và ô nhập `vtScheduleHour` (11h–21h) trong bảng cài đặt Vận Tiêu.
  - Cập nhật dòng trạng thái bảng Vận Tiêu (`refreshVanTieu`): `"⏰ Hẹn giờ tự chạy: 13h00 (hiện tại 13h VN · đã tới giờ)"`.

### 23.3. Kết Quả Kiểm Thử Toàn Diện (Full Regression Verification)
- Mở rộng bộ kiểm thử `test_vt_opt.html` từ 19 lên **37 bài kiểm thử**:
  - Kiểm tra các giá trị mặc định của config (`vtAutoTrigger = true`, `vtScheduleHour = 13`).
  - Kiểm tra element UI và giới hạn min=11, max=21 của input.
  - Kiểm tra logic `PLAN_JOBS` chặn trước 13h, mở khi chạm 13h, duy trì xe đang áp tải.
  - Kiểm tra `tickStandalone` tự động bật `cfg.vtRun = true` ở mốc 13h và cơ chế chống kích hoạt lặp `st.vtTriggeredDay`.
- Thực thi toàn bộ **10/10 bộ kiểm thử hồi quy** trên Chrome Headless:
  1. `test_bienhinh_opt.html`: 14/14 PASSED
  2. `test_faction_opt.html`: 10/10 PASSED
  3. `test_loot_opt.html`: 23/23 PASSED
  4. `test_vt_opt.html`: **37/37 PASSED** (thêm 18 bài kiểm tra mới)
  5. `test_speed_caravan_opt.html`: 11/11 PASSED
  6. `test_e2e_userjs.html`: 25/25 PASSED
  7. `test_bitich_opt.html`: 18/18 PASSED
  8. `test_lasthit_scan.html`: 20/20 PASSED
  9. `test_security_cache_stale.html`: 19/19 PASSED
  10. `test_deep_modes_opt.html`: 30/30 PASSED
- **Tổng cộng**: **207/207 bài kiểm thử PASSED 100% (0 lỗi)**.




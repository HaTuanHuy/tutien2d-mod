/* ============================================================================
 *  runtime-config.js — CẤU HÌNH CÔNG KHAI CỦA MÔI TRƯỜNG CHẠY
 * ----------------------------------------------------------------------------
 *  Nạp TRƯỚC mọi script game. Chỉ chứa giá trị CÔNG KHAI:
 *  Project URL + anon (publishable) key của Supabase. Anon key vốn được thiết
 *  kế để lộ ra trình duyệt — an toàn nằm ở Row Level Security phía máy chủ.
 *
 *  TUYỆT ĐỐI KHÔNG đặt service_role key vào đây.
 *
 *  Cách điền:  Supabase Dashboard -> Project Settings -> API
 *      Project URL   -> supabaseUrl
 *      anon public   -> supabaseAnonKey
 *
 *  Để trống thì game vẫn chạy được ở chế độ NGOẠI TUYẾN (lưu localStorage như
 *  cũ, không có tài khoản, không thấy người chơi khác).
 * ==========================================================================*/
window.PNTT_RUNTIME_CONFIG = {
  supabaseUrl: 'https://qrheujgqeplgozswcsun.supabase.co',
  supabaseAnonKey: 'sb_publishable_v4IGMcr9d15bJCrzq83itw_JfwhpjcZ',

  /* ------------------------------------------------------------------
   *  MÁY CHỦ GAME CÓ THẨM QUYỀN (server/main.js)
   *
   *  Nơi đàn quái sống, sát thương được tính và tiến trình nhân vật được
   *  chốt. Máy khách chỉ gửi ý định lên và vẽ lại phán quyết.
   *
   *      ''                       không có máy chủ game — chơi một mình,
   *                               tự lưu localStorage rồi đẩy lên Supabase
   *                               (đường lui, không chống được gian lận)
   *      'auto'                   cùng nơi đang phát trang này. Đúng cho lúc
   *                               chạy `node server/main.js`, vì nó phát cả
   *                               file tĩnh lẫn WebSocket trên một cổng.
   *      'wss://game.mien.vn/'    máy chủ đặt riêng — dùng khi phần tĩnh nằm
   *                               trên Cloudflare Pages còn máy chủ ở VPS.
   *
   *  Phải là wss:// nếu trang mở bằng https, bằng không trình duyệt chặn.
   * ------------------------------------------------------------------ */
  serverUrl: 'wss://game.tutien2d.online/',

  /* Đường TRONG NƯỚC tới CÙNG máy chủ ấy (23/10/2026): cửa trung chuyển ở VN,
   * DNS xám, không qua Cloudflare — Cloudflare hay dời người chơi VN sang PoP
   * châu Âu rồi cắt cả loạt. Máy khách thử đường này trước, không mở được thì
   * lùi về serverUrl (src/net/gateway.js). Bỏ trống = chỉ đi serverUrl. Bản
   * build trỏ máy chủ khác (máy test) tự để trống: xem tools/build_web.js. */
  serverUrlTrongNuoc: 'wss://ws.tutien2d.online/',

  /* Nhịp đồng bộ — chỉnh được nếu muốn tiết kiệm băng thông */
  saveIntervalSec: 20,     // tự lưu tiến trình lên đám mây mỗi 20 giây
  netTickHz: 10,           // số lần/giây phát vị trí cho người chơi khác
  /* Trần TỔNG số gói mỗi giây khai với Supabase Realtime. Phải lớn hơn tổng
   * của mọi loại gói cộng lại (toạ độ + esync + hit + act), không phải bằng
   * netTickHz. Nếu dự án Supabase đang để trần 10 events/second thì phải nới
   * trong Dashboard -> Realtime Settings, bằng không máy chủ vẫn chặn phần
   * vượt và đòn đánh sẽ vào máu trễ ở màn hình người khác. */
  eventBudgetHz: 30,
  /* Khoá site (công khai) Cloudflare Turnstile cho "Quên mật khẩu". Trống thì
   * nút ẩn. build_web lấy từ TURNSTILE_SITE_KEY trong .dev.vars. */
  turnstileSiteKey: '0x4AAAAAAFKScO6muiFlFKDy',
  /* Mã game do GIG/Gamota cấp (dạng CPxxx) cho màn nạp trong app GIG —
   * src/net/gig.js. Trống thì nút Nạp vẫn mở màn nạp nhưng thiếu game_id. */
  gigGameId: '',
  /* Đăng nhập + nạp bằng Gamota SDK JS (src/net/gamota.js). null = tắt. Chỉ
   * build_web --gamota điền vào, từ GAMOTA_* trong .dev.vars. */
  gamota: null,
  environment: 'production'
};

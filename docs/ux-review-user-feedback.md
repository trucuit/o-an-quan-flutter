# Phản hồi UX — đóng vai người dùng

Chạy thực tế trên Android emulator (1080×2160), đi qua từng màn, ghi lại các điểm **chưa hài lòng**. Ưu tiên xuyên suốt: **dùng icon, hạn chế text** (theo yêu cầu).

Ảnh chụp: `review_01_menu.png` … `review_10_*` ở thư mục gốc dự án.

Mức độ: 🔴 Cao · 🟡 Trung bình · ⚪ Thấp

---

## ✅ Trạng thái sửa (cập nhật sau "fix all")

Đã sửa & kiểm chứng trên emulator (ảnh `review_fix_01`…`review_fix_06`):

| # | Vấn đề | Trạng thái |
|---|--------|-----------|
| 1 | Ô "Hướng dẫn" lạc lõng | ✅ Đổi thành thanh full-width gọn ở đáy |
| 2 | Máy dễ/khó trùng icon+màu | ✅ 4 màu riêng (chàm/xanh/vàng/đỏ) + badge cột sóng 1/2/3 |
| 6 | Badge "×N" thừa mọi ô | ✅ Chỉ hiện khi >8 sỏi; còn lại chỉ sỏi |
| 7 | Thanh điểm mờ trên gỗ | ✅ Chip giấy đục + đổ bóng, tăng tương phản |
| 8 | Ô Quan có chữ "quan"/giống cờ | ✅ Bỏ chữ, chỉ còn viên quan vàng tròn |
| 9 | Top bar còn text chế độ | ✅ Chỉ icon (+ badge độ khó), nhãn vào tooltip |
| 11 | Nút chọn chiều ↺/↻ mơ hồ | ✅ Đổi thành mũi tên ← → rõ ràng |
| 14 | Bàn portrait bị kéo dãn | ✅ AspectRatio giữ tỉ lệ ô, căn giữa |
| 16 | Tutorial dùng text thay sỏi | ✅ Vẽ bàn gỗ + sỏi thật như game |

Còn lại (🟡/⚪, chưa làm): #5 ô landscape rộng-trống, #10 chỉ báo lượt (đã cải thiện qua tương phản), #12/#13 vài chỗ text ngữ cảnh (tiêu đề dialog, status), #15/#17 thẻ tutorial còn khoảng trống. `flutter analyze` sạch, 38 test pass.

---

## 1. Menu (`review_01` landscape, `review_07` portrait)

| # | Mức | Điểm chưa hài lòng | Gợi ý |
|---|-----|--------------------|-------|
| 1 | 🔴 | Ô thứ 5 "Hướng dẫn" lạc lõng: lưới 2×2 + 1 ô giữa → ô thứ 5 bị kéo dãn (portrait thành "viên thuốc" cao, landscape thành ô nhỏ lẻ loi). Bố cục 5 ô gãy. | Lưới đều, hoặc đưa "Hướng dẫn" thành nút icon nhỏ ở thanh tiêu đề/góc. |
| 2 | 🔴 | **"Máy dễ" và "Máy khó" dùng CÙNG icon robot + CÙNG màu xanh** → không phân biệt độ khó bằng hình, phải đọc chữ. | Icon thể hiện cấp độ (1/2/3 chấm·vạch sóng·sao) hoặc màu riêng từng độ khó. |
| 3 | 🟡 | Badge độ khó (mũi tên trên "Máy TB", lục giác trên "Máy khó") nhỏ, khó hiểu, không nhất quán ("Máy dễ" không có badge). | Bộ badge cấp độ thống nhất, rõ nghĩa. |
| 4 | 🟡 | Vẫn dùng **text nhãn** ("Chơi Hai Người", "Máy dễ"…) — trái ưu tiên icon. | Icon đủ rõ + nhãn ngắn gọn, hoặc bỏ nhãn nếu icon đã đủ nghĩa. |
| 5 | ⚪ | Landscape: ô quá rộng, nhiều khoảng trống, icon+nhãn lọt thỏm giữa thẻ. | Giới hạn bề rộng ô / căn nội dung. |

## 2. Bàn chơi — Landscape (`review_02`, `review_05`)

| # | Mức | Điểm chưa hài lòng | Gợi ý |
|---|-----|--------------------|-------|
| 6 | 🔴 | **Badge "×5" hiện trên MỌI ô** cùng lúc với sỏi đã thấy → thừa, rối, phá vẻ tự nhiên của bàn sỏi. | Bỏ badge khi đã đếm được sỏi (chỉ hiện khi >8), hoặc chỉ hiện khi chạm/giữ ô. |
| 7 | 🔴 | **Thanh điểm người chơi tương phản thấp** trên nền gỗ — số "0"/"6" và icon mờ, đặc biệt người không tới lượt (mờ ~55%). Khó đọc điểm. | Nền chip sáng hơn/viền đậm, tăng tương phản chữ; chỉ báo lượt rõ hơn. |
| 8 | 🟡 | Ô Quan hiện hình vàng **giống lá cờ/bookmark + chữ "quan"** — không giống viên quan tròn lớn; "quan" là text. | Vẽ viên quan tròn lớn rõ; bỏ/đổi nhãn chữ. |
| 9 | 🟡 | Top bar giữa hiện icon + **TEXT "Hai người"** — có thể chỉ icon. | Icon-only cho chế độ chơi. |
| 10 | ⚪ | Khi rảnh không có chỉ báo lượt rõ (chỉ đổi độ mờ rail) → người mới khó biết tới lượt ai. | Viền/đèn nền sáng ở rail người đang đi. |

## 3. Chọn chiều rải (`review_03`)

| # | Mức | Điểm chưa hài lòng | Gợi ý |
|---|-----|--------------------|-------|
| 11 | 🔴 | **Hai nút xoay ↺/↻ mơ hồ** — không rõ nút nào rải về phía nào trên bàn; hai icon nhìn na ná nhau. | Mũi tên chỉ hướng trực quan ngay trên bàn / preview đường rải / nhãn mũi tên trái–phải. |
| 12 | 🟡 | Tiêu đề "Ô dưới 2 — chọn chiều rải" là **text**; cách đánh số ô khó hiểu (chọn "Ô dưới 2" nhưng status báo "Ô dưới 5"). | Trực quan hoá bằng highlight ô đã chọn thay vì gọi tên bằng số. |

## 4. Hiệu ứng rải / trạng thái (`review_04`)

| # | Mức | Điểm chưa hài lòng | Gợi ý |
|---|-----|--------------------|-------|
| 13 | 🟡 | Status "Rải từ Ô dưới 5" là **text nhỏ, tương phản thấp** ở góc dưới-trái → dễ bỏ lỡ. | Dùng icon hành động (nhặt/rải/ăn) + animation thay vì chỉ text. |

## 5. Bàn chơi — Portrait (`review_06`) — **nặng nhất**

| # | Mức | Điểm chưa hài lòng | Gợi ý |
|---|-----|--------------------|-------|
| 14 | 🔴 | **Bàn portrait bị kéo dãn**: các ô cao & hẹp bất thường, sỏi dồn lên đầu ô, ô Quan co thành chấm nhỏ ở giữa hai cạnh (mất hình bán nguyệt), badge "×6" lơ lửng trong ô rỗng cao. | Giữ tỉ lệ ô gần vuông (giới hạn aspect), **hoặc xoay bố cục bàn 90°** trong portrait (2 cột dọc), căn giữa sỏi. |

## 6. Hướng dẫn (`review_08`)

| # | Mức | Điểm chưa hài lòng | Gợi ý |
|---|-----|--------------------|-------|
| 15 | 🔴 | Bước 1: sơ đồ bàn nhỏ xíu **trôi giữa thẻ giấy rất rộng**, thừa khoảng trống trên/dưới → mất cân đối. | Phóng to sơ đồ / thu gọn thẻ. |
| 16 | 🔴 | Sơ đồ dùng **TEXT "5", "P1", "P2", "Q"** thay vì sỏi/icon thật → không nhất quán với bàn thật, trái ưu tiên icon. | Vẽ **sỏi thật** như trong game; ô Quan có viên quan thật. |
| 17 | 🟡 | Các bước 2–6 (1 icon lớn + caption) cũng dư khoảng trống trong thẻ. | Cân lại bố cục thẻ. |

---

## Tổng kết ưu tiên sửa

1. 🔴 **Portrait bàn cờ bị kéo dãn** (#14) — ảnh hưởng trực tiếp trải nghiệm chơi.
2. 🔴 **Badge "×N" thừa trên mọi ô** (#6) — phá thẩm mỹ sỏi.
3. 🔴 **Máy dễ/khó trùng icon + màu** (#2) — không phân biệt được.
4. 🔴 **Tương phản thanh điểm thấp** (#7) — khó đọc.
5. 🔴 **Nút chọn chiều mơ hồ** (#11) — khó hiểu thao tác.
6. 🔴 **Ô "Hướng dẫn" lạc lõng** (#1) + **tutorial dùng text thay sỏi** (#16).

## Theo yêu cầu "dùng icon không dùng text"
Các chỗ còn dùng text có thể chuyển/giảm sang icon: top bar chế độ (#9), tiêu đề dialog chọn chiều (#12), nhãn "quan" trên ô Quan (#8), sơ đồ tutorial (#16), status hành động (#13), nhãn độ khó ở menu (#2/#4).

## Ghi chú
- Tông màu giấy/gỗ/sỏi tổng thể **đẹp và đúng chất truyền thống** — phần lớn vấn đề là bố cục, tương phản, và text-thay-vì-icon, không phải bảng màu.
- Âm thanh SFX hiện là file tổng hợp tạm (chưa kiểm chứng qua ảnh).

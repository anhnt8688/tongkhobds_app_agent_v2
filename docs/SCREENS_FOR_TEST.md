# Danh sách màn hình — TongkhoBDS Agent (v2) để phân công test

> Mục đích: PM dùng để tạo task & phân tester. Mỗi dòng = 1 màn/luồng có thể tạo 1 task test.
> Cập nhật: 2026-06-03.

## 0. Xác thực & khởi động (Auth)
| # | Màn hình | Route | Vào từ đâu | Điểm test chính |
|---|---|---|---|---|
| A1 | Splash | `/splash` | Mở app | Tự điều hướng đúng (login / onboarding / home) |
| A2 | Onboarding | `/onboarding` | Lần đầu cài app | 3 slide, "Bỏ qua"/"Bắt đầu" → Login; chỉ hiện lần đầu |
| A3 | Đăng nhập | `/login` | Chưa đăng nhập | Đăng nhập mật khẩu, lỗi sai mật khẩu, hiện/ẩn mật khẩu |
| A4 | Đăng nhập OTP | `/otp` | Login → "Đăng nhập bằng OTP" | Nhập SĐT → gửi OTP → xác thực → vào app |
| A5 | Quên mật khẩu | `/forgot` | Login → "Quên mật khẩu" | Luồng đặt lại mật khẩu |
| A6 | Đăng ký | `/register` | Login → "Đăng ký" | Form họ tên/SĐT/mật khẩu/email/ngày sinh/khu vực → OTP |
| A7 | Đăng nhập sinh trắc học | `/login` | Login (sau khi bật ở Profile) | Nút vân tay/Face ID → vào app; token hết hạn → đòi mật khẩu |
| A8 | Đổi domain (ẩn) | `/login` | Bấm chữ "Hoặc" 10 lần | Chọn 3 domain preset / nhập tay → lưu → đăng nhập lại đúng domain |

## 1. Tab chính (Bottom navigation)
| # | Màn hình | Route | Điểm test chính |
|---|---|---|---|
| T1 | Trang chủ | `/home` | KPI, banner, lưới công cụ nhanh (17 mục), BĐS hot, hoạt động gần đây, thẻ "việc cần làm" theo thông báo |
| T2 | Bảng hàng (tìm BĐS) | `/search` | Tìm kiếm, bộ lọc động, tab phân loại, chip Nổi bật/Xác thực, list/grid, mở bản đồ |
| T3 | Đăng tin | `/post` | Tạo/đăng tin BĐS |
| T4 | Thông báo | `/notifications` | 2 tab Giao dịch/Hệ thống (+count), đọc 1/đọc tất cả, xoá, ngưng nhận, phân trang |
| T5 | Cá nhân | `/profile` | Thẻ user, award/KYC banner, 3 nhóm menu, đăng xuất |

## 2. Bất động sản
| # | Màn hình | Route | Vào từ đâu | Điểm test chính |
|---|---|---|---|---|
| B1 | Chi tiết BĐS | `/property/:id` | Tap item ở Bảng hàng/Kho tin | Ảnh, giá, mô tả, bản đồ, liên hệ, yêu thích |
| B2 | Kho tin của tôi | `/my-listings` | Home / Profile | List tin của mình |
| B3 | Yêu thích | `/favorites` | Home / Profile | Nhóm yêu thích + đếm + chip màu |
| B4 | Chi tiết nhóm yêu thích | `/favorite-group/:id` | Tap nhóm yêu thích | List BĐS trong nhóm |
| B5 | Bản đồ BĐS | `/map` | Home / Bảng hàng | Marker giá, cụm theo viewport, tap marker |
| B6 | So sánh BĐS | `/compare` | Home | Chọn 2 BĐS → bảng so sánh |

## 3. Dự án
| # | Màn hình | Route | Điểm test chính |
|---|---|---|---|
| P1 | Danh sách dự án | `/projects` | List dự án (cha/con) |
| P2 | Chi tiết dự án | `/project/:code` · `/project-detail/:code` | Thông tin, bảng hàng/phân lô, đăng ký |

## 4. Khách hàng & Nhu cầu
| # | Màn hình | Route | Điểm test chính |
|---|---|---|---|
| C1 | Khách hàng | `/customers` | Danh sách khách |
| C2 | Nhu cầu mua | `/demands` | Tab trạng thái, lọc, tìm |
| C3 | Tạo nhu cầu mua | `/demand/create` | Form tạo nhu cầu |
| C4 | Chi tiết nhu cầu mua | `/demand/:id` | Tabs (BĐS làm việc/hoạt động/ghi chú), thao tác |
| C5 | Nhu cầu bán | `/nhu-cau-ban` | Tab trạng thái, lọc |
| C6 | Tạo nhu cầu bán | `/nhu-cau-ban/create` | Form tạo |
| C7 | Chi tiết nhu cầu bán | `/nhu-cau-ban/:id` | Gán đầu chủ/phụ trách, hoạt động, đóng |

## 5. Lịch hẹn & Hợp đồng
| # | Màn hình | Route | Điểm test chính |
|---|---|---|---|
| L1 | Lịch hẹn | `/appointments` | List theo trạng thái |
| L2 | Tạo lịch hẹn | `/appointments/create` | Chọn khách + BĐS + ngày giờ |
| L3 | Chi tiết lịch hẹn | `/appointments/:id` | Đổi trạng thái |
| H1 | Quản lý hợp đồng | `/contracts` | List HĐ, trạng thái ký |
| H2 | Chi tiết hợp đồng | `/contract/:id` | Nội dung HĐ |
| H3 | Ký hợp đồng | `/contract/sign` | Ký tay → upload → tạo HĐ; OTP |
| H4 | Thư viện hợp đồng | `/contract-library/:id` | Xem HTML/PDF |

## 6. Đội nhóm & Quản lý xác thực BĐS
| # | Màn hình | Route | Điểm test chính |
|---|---|---|---|
| D1 | Đội nhóm | `/team` | Tổng quan + cây thành viên |
| D2 | Chi tiết thành viên | `/team/member/:id` | 4 tab (giao dịch/kho/hoạt động) |
| V1 | Quản lý xác thực BĐS | `/real-estate-verification` | Tab trạng thái, bộ lọc đầy đủ, card 3 chip, gán đầu chủ/trưởng phòng |
| V2 | Bài đăng + Thông tin xác thực | `…/article` | 2 tab; thanh thao tác theo quyền: Sửa/Từ chối/Xác nhận/Duyệt/Xác thực lại |
| V3 | Form bổ sung xác thực | `…/form` | Ảnh, vị trí, giá/phí, loại pháp lý (bìa đỏ/HĐ/khác), chủ nhà → gửi |
| V4 | Duyệt thành công | `…/approve-success` | "Tạo lịch hẹn" / "Quay lại" |

## 7. Công cụ
| # | Màn hình | Route | Điểm test chính |
|---|---|---|---|
| U1 | Tiện ích | `/utilities` | Chọn công cụ → form động → "Tính" → kết quả HTML (lãi suất/chi phí/xem tuổi/phong thủy) |
| U2 | Tra cứu pháp lý | `/legal-search` | Tìm kiếm + list + chi tiết HTML |
| U3 | Ký gửi/Đặt cọc | `/deposit` | Tab theo trạng thái + list |
| U4 | Chi tiết ký gửi | `/deposit/:id` | Thông tin cọc + huỷ (khi chờ thanh toán) |

## 8. Giao dịch
| # | Màn hình | Route | Điểm test chính |
|---|---|---|---|
| G1 | Giao dịch | `/transactions` | List giao dịch |
| G2 | Chi tiết giao dịch | `/transaction/:id` | Thông tin + bình luận |

## 9. Hồ sơ (Profile) & Tài khoản
| # | Màn hình | Route | Điểm test chính |
|---|---|---|---|
| F1 | Cập nhật thông tin | `/edit-profile` | Sửa hồ sơ + avatar |
| F2 | Xác thực KYC | `/kyc` | Chụp/tải CCCD 2 mặt → gửi |
| F3 | Đổi mật khẩu | `/change-password` | Mật khẩu cũ/mới |
| F4 | Cấp hạng | `/rank` | Hạng + quyền lợi |
| F5 | Quyền lợi (award) | `/award-benefits` | HTML quyền lợi |
| F6 | Giới thiệu môi giới | `/referral` | 2 tab QR/người giới thiệu, lưu QR, quét QR camera + ảnh, nhập mã |
| F7 | Cập nhật MST | `/profile` (sheet) | Nhập mã số thuế → lưu |
| F8 | Bật/tắt sinh trắc học | `/profile` (toggle) | Bật → xác thực → lưu; tắt |
| F9 | Yêu cầu xoá tài khoản | `/profile` | Xác nhận → xoá → đăng xuất |
| F10 | Chọn khu vực | `/locations` | Picker tỉnh/huyện/xã |

---

## Ghi chú cho PM
- **Đã có & sẵn sàng test**: tất cả mục ở trên.
- **CHƯA làm (đừng tạo task test)**: nhóm **Tài chính** — Ví, Điểm thưởng, Vay vốn, Đối soát giao dịch; và **Chat/Tin nhắn**, **Sự kiện + vé**, **Check-in vé**, **Webview tools động** (sẽ bổ sung sau).
- **Lưu ý môi trường**: dùng tính năng **Đổi domain (A8)** để test trên `dev`/`nentang` nếu cần.
- **Thiết bị**: iOS 14+ và Android. Có dùng camera (quét QR, KYC, ảnh xác thực), vân tay/Face ID, thư viện ảnh, bản đồ Google.

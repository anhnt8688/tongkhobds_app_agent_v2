# Đăng tin — v1 UI parity (field-level)

Make v2 `lib/features/post/` look "y hệt" v1 `create_news`. Decisions (owner, 2026-07-04):
keep **3 steps** (drop commission step 4); **rebuild step 3 review rich** like v1.

v1 source: `/Users/mac/Developer/tongkhobds_agent/lib/features/create_news/`.
Parity rule: use `AppTextStyles.{semibold,medium,regular,bold}(size,color:)` (ls -0.4) — NOT `AppTypography.*`.
v1 layering: page bg `neutral100` (#F5F5F4); section card bg `#FAFAF9`; title `semibold(20)`; price accent `AppColors.price` (#F58229).

## Phase 1 — Assets + SectionCard
- Copy from v1 `assets/images/`: `ic_ai.png`, `libraryIcon.png` (review counter), `selected_icon.png`, `unSelectedIcon.png`, `arrow_up_icon.png`, `arrow_down_icon.png`. (pubspec globs assets/images/, no pubspec edit.)
- `section_card.dart`: bg `#FAFAF9`, radius16, title `semibold(20)`, add optional `collapsible`/`initiallyExpanded` chevron (keyboard_arrow_up/down_sharp) for Mô tả chính / Mô tả thêm / Nội dung tin đăng.

## Phase 2 — Step 1 (Thông tin) parity
- All `AppTypography.*` → `AppTextStyles.*`.
- Nhu cầu: FA `tag`/`key` icons, label `semibold(13)`, selected bg primary / unselected bg `#FAFAF9`, no border.
- AI button: Row[left "Tạo nội dung tự động" `semibold(15)`, Expanded gradient pill radius40 [#FF5858,#F09819] + `ic_ai.png` 24 + "Tạo tự động" `semibold(17)` white].
- Number fields → v1 look (fill neutral100, suffix `semibold(15)`); price-suggestion chips already exist.
- Description preview box: neutral100 bg + neutral200 border + open icon.

## Phase 3 — Step 2 (Hình ảnh) parity
- Dashed placeholder via small CustomPainter (no new dep): bg `#FAFAF9`, dashed neutral200, FA `arrowUpFromBracket` neutral400, label `regular(15)` neutral400 ("Tải ảnh"/"Tải video"/"Tải file đính kèm").
- Headers `semibold(20)` + subtitle `regular(15)` neutral400; legal section only after ≥1 image.
- Thumbnails radius16, delete = red cancel icon top-right.

## Phase 4 — Step 3 (Xác nhận) rich rebuild
- Carousel (PageView) 1:1 + counter overlay bottom-right (`libraryIcon` + "i/n", black@0.2 radius4).
- White card: title `semibold(17)`; location row (`location_icon` + `regular(13)`); price `semibold(20)` `AppColors.price` + per-m² `regular(15)`; 3 boxes bed/bath/area (`bed_room_icon`/`bad_room_icon`/`area_icon` + `medium(13)` neutral400).
- Dividers 0.5 neutral200; "Mô tả chi tiết" `semibold(20)` + HtmlWidget; legal docs block.
- Map "Vị trí trên bản đồ" `semibold(20)` + `google_maps_flutter` preview 200h marker at lat/lng → new `widgets/listing_location_map.dart`.

## Phase 5 — polish
- `flutter analyze` → 0 errors. Manual visual pass vs v1 screenshots.

## Deferred / not in scope
- Step 4 commission UI (owner dropped). AI page already ~faithful (minor: ic_ai on button).

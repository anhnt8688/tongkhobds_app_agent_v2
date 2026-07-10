# V1 Flutter "Hợp đồng" (Contracts) UI Spec – Mobile App

**Source:** `/Users/mac/Developer/tongkhobds_agent/lib/features/contract*` (GetX)  
**Timezone:** Asia/Saigon  
**Platform:** Flutter/Dart, macOS target

---

## COLOR & TEXT STYLE TOKENS

### AppTextStyles Helpers (SF-Pro-Display font family)
- `regular8()` – regular, 8px, letterSpacing -0.4
- `regular11()`, `regular12()`, `regular13()`, `regular14()`, `regular15()`, `regular16()`, `regular17()`, `regular18()`, `regular19()`, `regular20()`, `regular22()`
- `medium9()`, `medium11()` through `medium20()`
- `semibold11()` through `semibold22()`
- `bold11()` through `bold28()`

### AppColors Tokens
- `primaryColor` = `#F26F21` (orange)
- `primaryColor2` = `#F3802F`, `primaryColor3` = `#F1913D` (orange variants)
- `neutral800` = `#292524`, `neutral700` = `#44403C`, `neutral600` = `#57534E`, `neutral500` = `#78716C`, `neutral400` = `#A8A29E`, `neutral300` = `#D6D3D1`, `neutral200` = `#E7E5E4`, `neutral100` = `#F5F5F4`, `neutral50` = `#FAFAF9`
- `green` = `#34C759`
- `red` = `#FF3B30`
- `priceColor` = `#F58229`
- `orange100` = `#FFEDD5`
- `success` = `#12B76A`, `warning` = `#F79009`, `error` = `#EF4444`, `info` = `#2E90FA`
- `backgroundColor` = `#FAFAF9`, `backgroundSecondary` = `#F4F7FA`, `tabBackground` = `#F5F5F4`

---

## SECTION A: CONTRACT MANAGEMENT (contract/*_page.dart)

### Screen 1: `ContractPage` (Danh sách hợp đồng)

#### 1.1 Scaffold Shell
- **Scaffold**: `backgroundColor: Colors.white`
- **AppBar**: Custom `_ContractAppBar` (white bg, no elevation)
  - Title: "Danh sách hợp đồng" (`AppTextStyles.bold20()`, `AppColors.neutral800`)
  - Search toggle: search icon (top-right) → when active, hides title, shows search TextField
  - Back button: left-aligned arrow when not searching

#### 1.2 AppBar Variants
- **Normal state**: 
  - Title: "Danh sách hợp đồng" (bold20)
  - Back icon (black) on left
  - Search icon on right
- **Search state**:
  - Back icon hidden
  - Search box replaces title (height: 40, radius: 12, bg: `#F1F5F8`)
  - Placeholder: "Tìm kiếm" (regular16, `AppColors.neutral400`)
  - Search icon (prefix, `#9CA3AF`, 20px)
  - Cancel button on right ("Huỷ bỏ", regular16, `AppColors.stone800`)
  - TextField: regular16, onChanged triggers search filter

#### 1.3 Body: Grid Layout
- Empty state (when no contracts): 
  - RefreshIndicator (scrollable)
  - Centered text: "Không có hợp đồng nào" / "Không tìm thấy hợp đồng phù hợp" (regular14, `AppColors.neutral500`)
- List present:
  - RefreshIndicator with GridView.builder
  - 2-column grid (crossAxisCount: 2)
  - Responsive padding/spacing per screen width:
    - width < 360px: padding 12, spacing 10, mainSpacing 12, aspectRatio 0.72
    - 360–390px: padding 14, spacing 10, mainSpacing 14, aspectRatio 0.75
    - 390–415px: padding 16, spacing 12, mainSpacing 16, aspectRatio 0.70
    - ≥415px: padding 16, spacing 12, mainSpacing 16, aspectRatio 0.68

#### 1.4 Contract Grid Card
**Container** (GestureDetector on tap):
- **Decoration**: 
  - bg: white
  - radius: 12
  - border: 1px `AppColors.neutral200`
  - boxShadow: (black 0.05 opacity, blur 4, offset 0,2)
- **Padding**: responsive (10–14px horizontal/vertical)
- **Structure** (Stack):
  - **Image section** (top):
    - Network image (dimensions vary by screen: 110–140px height)
    - **Status badge** (if signedStatus == 1, top-right positioned):
      - Padding: responsive 7–10px horiz, 3–6px vert
      - Bg: `AppColors.green` (solid pill, radius 8)
      - Text: "Đã ký" (medium12, white, adjusted fontSize 10–12px)
  - **Content column** (rest):
    - Spacing: responsive 6–12px below image
    - **Row 1**: Title + "|" + Price
      - Title: title (maxLines 1, ellipsis, semibold14, `AppColors.neutral800`, adjusted 12–14px)
      - Separator: "|" (regular14, `AppColors.neutral400`, 3–6px padding)
      - Price: formatted (semibold14, `AppColors.neutral800`, 12–14px)
    - **Row 2**: Address (maxLines 1, ellipsis, regular13, `AppColors.neutral600`, adjusted 11–13px)
    - **Row 3**: Name + Contract Type Badge
      - Name: nameSale (maxLines 1, ellipsis, regular13, `AppColors.neutral500`, 11–13px)
      - Badge: contractTypeName in pill (border matching color)
        - **Colors**:
          - "Độc quyền" → red.shade600
          - "Thông thường" → blue.shade600
        - **Pill**: padding 5–8px horiz, 2px vert, radius 6, medium12/semibold, size 10–12px
  - **Overlay** (if signedStatus == 0, full-screen overlay):
    - Semi-transparent black (50% opacity), radius 12
    - Centered button box:
      - Bg: white, radius 12, border 1.5px `#FF8C42`
      - Padding: responsive 12–20px horiz, 8–12px vert
      - Text: "Ký hợp đồng" (semibold14, `#FF8C42`, 13–16px)
      - BoxShadow: black 0.1, blur 8, offset 0,2

#### 1.5 Navigation on Tap
- Route to `ContractPreviewPage` with args:
  - `viewOnly: signedStatus == 1`
  - `contractId`, `contractType`, `signingMethod`, `contractCode`, `pdf_url`, `title`

#### 1.6 Status Mapping
- **signedStatus == 0**: "Chưa ký" → overlay ("Ký hợp đồng" button)
- **signedStatus == 1**: "Đã ký" → green badge, no overlay

---

### Screen 2: `ContractPreviewPage` (Nội dung hợp đồng – Info Review)

#### 2.1 Scaffold Shell
- **Scaffold**: `backgroundColor: Colors.white`
- **AppBar**: `CustomAppBar(title: 'Nội dung hợp đồng')`
- **Body**: SingleChildScrollView, `padding: EdgeInsets.all(16)`
- **BottomBar**: `_BottomBar` (conditional, only if not viewOnly)

#### 2.2 Body Content Container
- White rounded box (radius 16, padding 12 bottom)
- Vertical sections stacked with 6–12px spacing

#### 2.3 Section: "Thông tin hợp đồng"
- **Header** (`_SectionHeader`):
  - Left accent bar (width 6, height 14, bg `#FF7A37`, radius 3)
  - Text: "Thông tin hợp đồng" (semibold16, `#292524`)
  - Padding: 12px top/bottom, 12px left, 8px right
- **Divider**: 1px height, `#F0F2F5`
- **Key-Value rows** (`_KVRow`):
  - "Loại hợp đồng" → contractType
  - "Phương thức ký" → signMethod
  - "Giá trị hợp đồng" → contractValue (bold value, semibold15)
  - "Phí môi giới (hoa hồng)" → brokerageFee
- **Note card** (if commissionPaymentText present):
  - Padding: 16px horiz, 4px vert
  - Icon: sticky note (Icons.sticky_note_2_outlined, 18px, `#CA8A04`)
  - Text: commissionPaymentText (regular14, `#78350F`)

#### 2.4 Key-Value Row Style (`_KVRow`)
- Padding: 16px horiz, 7px vert
- Label (flex 11): regular14, `#9AA3AF`
- Value (flex 13): regular15 or semibold15 (isBoldValue), `#111827`

#### 2.5 Section: "Thông tin bên A" (Company/Office)
- **Header** (same as above): "Thông tin bên A"
- **Rows**:
  - "Tên công ty" → companyName (bold value)
  - "Mã số doanh nghiệp" → businessCode
  - **If !viewOnly**: Show all rows (address, representative, position)
  - **If viewOnly**:
    - Initially hidden; "Xem thêm" button (expand)
    - When expanded: show address, representative, position; show "Thu gọn" button (collapse)
    - Icon: expand_more_rounded (18px, `AppColors.primaryColor`) for expand; expand_less_rounded for collapse

#### 2.6 Section: "Thông tin bên B" (Individual/Agent)
- **Header**: "Thông tin bên B"
- **Rows** (always visible):
  - "Ông/Bà" → fullName (bold value)
  - "Ngày sinh" → birthday
  - "CCCD" → cccd
  - "Cấp ngày" → cccdIssueDate
- **Expandable** (similar to Side A):
  - "Xem thêm" / "Thu gọn" toggle
  - Hidden: "Nơi cấp", "Địa chỉ thường trú", "Số điện thoại"

#### 2.7 Bottom Navigation Bar (`_BottomBar`)
- **If viewOnly == false**: `SizedBox.shrink()` (hidden)
- **If viewOnly == true**:
  - SafeArea (top: false, bottom: false)
  - Container (bg white, padding left/right 16, top 10, boxShadow: black 0x0A, blur 8, offset 0,-2)
  - Two-button Row:
    - Left: `AppButton("Quay lại", type: outline, onPressed: Get.back)`
    - Right: `AppButton("Xem hợp đồng", type: primary, onPressed: navigateToContractReader)`
  - Gap: 12px

---

## SECTION B: CONTRACT LIBRARY (contract_library/*)

### Screen 3: `ContractLibraryPage` (Thư viện hợp đồng)

#### 3.1 Scaffold Shell
- **CustomScreen** wrapper (custom header)
- **Title**: "Thư viện hợp đồng"

#### 3.2 Body Structure
- **Column** (spacing: 16):
  1. **Control row** (`_control`) – Segmented button tabs
  2. **Search box** (`_buildSearch`)
  3. **List** (Expanded, `_buildListContract`)

#### 3.3 Segmented Button Tabs (`_control`)
- **SegmentedButtonSlide**:
  - Entries: ["Mua bán", "Đặt cọc", "Thuê"]
  - Height: 36
  - Padding: all 4
  - Radius: 14
  - Bar color: `AppColors.tabBackground` (`#F5F5F4`)
  - Background selected: `AppColors.neutral800` (`#292524`)
  - Selected text: semibold13, `AppColors.neutral50` (white)
  - Unselected text: regular13, `AppColors.neutral500` (gray)
  - onChange: trigger `controller.changeIndex(selectedIndex)`

#### 3.4 Search Box (`_buildSearch`)
- **TitleDefaultTextField**:
  - Padding: 16px horiz
  - Placeholder: "Bạn muốn tra cứu hợp đồng nào" 
  - Prefix icon: Icons.search
  - onChanged: trigger `fetchContractLibrary(type: "search")`
  - Debounce: 500ms

#### 3.5 List View (`_buildListContract`)
- **SmartRefresher** (pull-down enabled, WaterDropHeader)
- Empty state (if no contracts): `NoDataView()`
- **ListView.builder**:
  - Padding: horizontal 16, top 24, zero elsewhere
  - Item margin: bottom 16

#### 3.6 Contract Library Item (`_buildItemContract`)
- **Container**:
  - Padding: all 16
  - Bg: white
  - Radius: 16
  - BoxShadow: black 0.1, blur 10, offset 0,4
- **Content** (Column, spacing 16):
  - Title: `model.name` (semibold17)
  - Info row 1: "Version " + `model.versionDocs` (regular15 + semibold15)
  - Info row 2: "Cập nhật " + formatted date (regular15 + semibold15)
  - **Detail button** (full-width):
    - Bg: `AppColors.orange100` (`#FFEDD5`)
    - Radius: 12
    - Padding: vertical 9
    - Text: "Chi tiết" (semibold17, `AppColors.primaryColor`)
    - onTap: navigate to `Routes.detailContractLibrary` with `{"id": model.id}`

---

### Screen 4: `DetailContractLibraryPage` (Chi tiết hợp đồng)

#### 4.1 Scaffold Shell
- **CustomScreen** wrapper
- **Title**: "Chi tiết hợp đồng"

#### 4.2 Body
- **SingleChildScrollView**:
  - Padding: horiz 16, vert 24
- **HTML Content** (flutter_html): `controller.contractDetail.value.htmlContent`
- **File Gallery**:
  - ListView generated from `listGallery`
  - Item margin: bottom 16
  - **File item container**:
    - Padding: all 16
    - Width: full
    - Bg: `AppColors.neutral200` (`#E7E5E4`)
    - Radius: 12
    - **Row**:
      - Left: file name (semibold15, Expanded)
      - Right: icon toggle
        - If downloaded: `FontAwesomeIcons.checkCircle` (18px, `AppColors.primaryColor`)
        - Else: `FontAwesomeIcons.fileDownload` (18px, `AppColors.primaryColor`)
    - onTap: navigate to `FilePreview` with URL + download callback

---

### Screen 5: `FilePreview` (Xem trước tệp)

#### 5.1 Structure
- **CustomScreen** wrapper
- **File type detection**:
  - **PDF**: `SfPdfViewer.network(url)`
  - **DOC/DOCX**: Google Docs embedded viewer (WebViewController)
  - **Unsupported**: Error message

#### 5.2 Loading & Error States
- Spinner + progress during load
- Error message with "Thử lại" button
- Download progress indicator (circular_percent_indicator)

---

### Screen 6: `ContractSignPage` (Ký hợp đồng)

#### 6.1 Scaffold Shell
- **AppBar**: 
  - Title: "Ký hợp đồng" (centered)
  - Bg: `AppColors.primaryColor` (orange)
  - Text: white

#### 6.2 Body Sections
- **Info card** (top):
  - Bg: white
  - Padding: all 12
  - Radius: 12
  - **Key-Value rows**:
    - "Bên B" → fullName
    - "Mã số thuế" → mst or user.tax_code
  - Gap between rows: 6px

#### 6.3 Signature Display (center)
- **If no signature**:
  - Icon: Icons.gesture_rounded (56px, `#9AA3AF`)
  - Text: "Chưa có chữ ký" (regular15, `#6B7280`)
- **If signature present**:
  - ClipRRect (radius 12)
  - Image.memory (width 70% of screen, contain fit)

#### 6.4 Signature Dialog (modal)
- **Dialog**:
  - Padding: 12–8px
  - Radius: 12
  - insetPadding: 16px horiz
- **Header**:
  - Text: "Ký hợp đồng" (semibold18, `#111827`, centered)
  - Close button (top-right)
- **Signature pad**:
  - AspectRatio: 3/1
  - Border: 1px `#E5E7EB`
  - Bg: white
  - Radius: 8
  - SignatureController: penStrokeWidth 3.0, penColor black87, exportBg white
- **Controls**:
  - Thickness slider (1–8 range)
  - Clear button (OutlinedButton.icon with refresh icon)
  - **Footer buttons**:
    - "Hủy" (OutlinedButton)
    - "Áp dụng" (ElevatedButton, bg `AppColors.primaryColor`, white text)

#### 6.5 Sign Button
- **ElevatedButton.icon**:
  - Icon: Icons.edit
  - Label: "Ký ngay" (if no sig) / "Ký lại" (if sig present)
  - Bg: `AppColors.primaryColor`, white text
  - Padding: vert 12
  - Radius: 12
  - Full width (SizedBox(width: double.infinity))

#### 6.6 Bottom Navigation Bar
- SafeArea (top: false)
- Container (padding left/right 16, top 10, bg white, radius top 16, boxShadow)
- Two-button Row:
  - "Quay lại" (OutlinedButton, border `#E5E7EB`)
  - "Tiếp tục" (ElevatedButton, disabled if no signature, bg `AppColors.primaryColor`)

---

### Screen 7: `ContractSignSuccessPage` (Ký hợp đồng thành công)

#### 7.1 Scaffold Shell
- **Scaffold**: `backgroundColor: Colors.white`
- **SafeArea**: bottom: false

#### 7.2 Body Layout
- **Expanded** (center content):
  - Image: `AssetConstants.contractSuccess` (64px × 64px, contain)
  - Text 1: "Ký hợp đồng thành công" (fontSize 22, weight 700, `#111827`, textAlign center, height 1.25)
  - Text 2: "Hệ thống sẽ rà soát thông tin hợp đồng của bạn để đảm bảo tính chính xác trước khi kích hoạt hợp đồng" (fontSize 15, `#9CA3AF`, textAlign center, height 1.4)

#### 7.3 Bottom Action Bar
- SafeArea (top: false, bottom: false)
- Padding: left/right 16, vert 16
- **Two-button Row**:
  - Left: TextButton "Danh sách"
    - Bg: `#F3F4F6`, text `#111827`
    - Padding: vert 16
    - Radius: 16
    - onPressed: navigate to home + ContractPage
  - Right: ElevatedButton "Xem hợp đồng"
    - Bg: `AppColors.priceColor` (`#F58229`), text white
    - Disabled bg: `#F1D8C8`
    - Padding: vert 16
    - Radius: 16
    - onPressed: navigate to contractReader if PDF URL available
  - Gap: 12px

---

## SECTION C: ASSET REFERENCES

### Images Referenced
- `AssetConstants.contractSuccess` = `'assets/images/contract_success.png'` (success icon, 64px)
- `AssetConstants.waitingContract` = `'assets/images/waiting_contract.png'`
- `AssetConstants.icInfo` = `'assets/images/ic_info.png'`
- Contract type thumbnail images (network URL from API)

### Icons (Material + FontAwesome)
- `Icons.search`, `Icons.arrow_back`, `Icons.close`, `Icons.expand_more_rounded`, `Icons.expand_less_rounded`, `Icons.gesture_rounded`, `Icons.sticky_note_2_outlined`, `Icons.edit`, `Icons.hourglass_empty_rounded`, `Icons.download_rounded`
- `FontAwesomeIcons.checkCircle`, `FontAwesomeIcons.fileDownload` (for file status)

---

## V2 SCREEN MAPPING (Inferred)

| V1 Screen | Likely V2 File |
|-----------|----------------|
| ContractPage (grid list) | `contracts_screen.dart` |
| Contract grid card | `contract_grid_card.dart` |
| ContractPreviewPage | `contract_preview_screen.dart` |
| _KVRow + sections | `contract_info_section.dart` |
| ContractLibraryPage | `contract_library_screen.dart` |
| DetailContractLibraryPage | `library_detail_screen.dart` |
| FilePreview | `library_file_preview_screen.dart` |
| ContractSignPage | `contract_sign_screen.dart` |
| Signature dialog | `signature_pad_dialog.dart` |
| ContractSignSuccessPage | `contract_sign_success_screen.dart` |
| OTP screen (inferred) | `contract_otp_screen.dart` + `otp_code_field.dart` |
| ContractReaderPage (PDF view) | `contract_join_preview_screen.dart` (or part of preview) |

---

## STYLING SUMMARY

### Fonts
- **Font family**: SF-Pro-Display
- **Weights**: Regular (400), Medium (500), Semibold (600), Bold (700)
- **Letter spacing**: -0.4px (base)

### Spacing
- **Container padding**: 12–24px (context-dependent)
- **Gap/spacing**: 4px–16px (small to large)
- **Border radius**: 6px–16px (components to cards)

### Shadows & Borders
- **Card shadow**: blur 4–10px, offset 0,2–0,4, opacity 0.05–0.1
- **Border colors**: neutral200 / neutral300 / #E5E7EB
- **Accent bar**: 6px width, `#FF7A37` (orange)

### Status Indicators
- **Signed**: green badge (`#34C759`), pill shape, semibold 12px
- **Unsigned**: semi-transparent overlay (50% black) + centered button ("Ký hợp đồng", `#FF8C42` border/text)
- **Contract types**: colored borders (Độc quyền → red, Thông thường → blue)

---

## APPENDIX: APP TEXT STYLES USED (Full List)

- `bold20()` – contract list title
- `semibold14()` – contract card title, dialog titles
- `semibold15()` – key-value values, library item details
- `semibold16()` – section headers, library card titles
- `semibold17()` – library item title, detail button text
- `semibold18()` – signature dialog title
- `regular12()` – various labels
- `regular13()` – address, seller name
- `regular14()` – hints, labels, body text
- `regular15()` – key-value labels, info text
- `regular16()` – search bar text
- `medium12()` – status badge text
- All colors override default `neutral800` with context-specific grays/oranges

---

**End of V1 UI Spec**

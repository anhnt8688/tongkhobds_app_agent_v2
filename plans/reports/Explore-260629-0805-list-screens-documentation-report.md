# V2 List Screens: Implementation & Data Layer Documentation

## Summary

This report documents TWO list screens from the v2 Flutter app, providing complete widget structure, Riverpod providers, data models, API methods, status enums, and helper functions. Goal: UI rewrite while keeping all providers, models, API, and helpers unchanged.

---

## 1. NHUÙ CẦU MUA (Demands) Screen

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/presentation/demands_screen.dart`  
**Route:** `/demands`

### 1.1 Widget Structure

**Screen Class:** `DemandsScreen` (ConsumerStatefulWidget)

**AppBar:**
- Title: "Nhu cầu mua"
- Filter icon (toggles color if `hasFilters=true`)
- **Custom PreferredSize bottom** (96px height):
  - **Search TextField** (line 266–276):
    - Hint: "Mã nhu cầu, SĐT khách hàng..."
    - Prefix icon: Icons.search
    - onChange → `_c.setSearch(value)`
  - **Horizontal Status Tab ListView** (line 280–296):
    - 4 default tabs: "all", "new", "active", "completed"
    - Dynamic tab labels with count: `"${t.name}${count > 0 ? ' (${count})' : ''}"`
    - Tab component: `_Tab` widget (line 465–492)
    - On tap → `_c.setStatus(status)`

**FAB (FloatingActionButton.extended):**
- Route: `/demand/create`
- Label: "Tạo nhu cầu"
- On pop → `_c.refresh()`

**Body (_body method, line 315–363):**
- Loading state: `CircularProgressIndicator`
- Error state: Icon + message + "Thử lại" button
- Empty state: Text "Chưa có nhu cầu"
- List: `ListView.separated` with:
  - Scroll listener: triggers `loadMore()` at 300px from bottom
  - Item count: `items.length + 1` (for loading indicator)
  - Separator: `SizedBox(height: 12)`
  - Item builder: `_DemandCard` (line 494–582)
  - Bottom loading: `CircularProgressIndicator` or `SizedBox(24)`

**Filter Sheet (_FilterSheet, line 377–463):**
- Modal bottom sheet with:
  - Location picker (→ `/locations` route)
  - Date range picker
  - "Xoá lọc" and "Xong" buttons
  - Calls: `controller.setLocation()`, `controller.setDateRange()`, `controller.clearFilters()`

**Card Component (_DemandCard, line 494–582):**
- Material + InkWell for tap
- Border + padding (12px)
- Rows:
  1. Code (caption, muted) + Status badge (right)
  2. Customer name (title) + phone (caption, muted)
  3. Budget icon + range text + area icon + area range text
  4. Location (if any): icon + location names joined by ", "
  5. Tags (if any): wrapped chips using `demandTagChip(tag)`

### 1.2 State Management

**State Class:** `DemandListState` (line 18–99)  
**Controller:** `DemandListController` (AutoDisposeNotifier) (line 101–193)  
**Provider:** `demandListControllerProvider` (line 195–197)

**State fields:**
```dart
status: String = 'all'
search: String = ''
cityId, districtId, wardId: String?
locationLabel: String?
startDate, endDate: String?
items: List<Demand> = []
statusTabs: List<StatusTab> = []
total: int = 0
page: int = 1
totalPages: int = 1
isLoading: bool = false
isLoadingMore: bool = false
error: Object?
```

**Computed getters:**
- `hasMore`: `page < totalPages`
- `hasFilters`: `cityId != null || startDate != null || endDate != null`

**Controller methods:**
- `refresh()`: Set `isLoading=true`, fetch page 1, update state
- `loadMore()`: Fetch next page, append items
- `setStatus(s)`: Update status, auto-refresh
- `setSearch(s)`: Debounce 400ms, then refresh
- `setLocation(cityId, label, districtId?, wardId?)`: Update location, refresh
- `setDateRange(start?, end?)`: Update dates, refresh
- `clearFilters()`: Reset location & dates, refresh

**Providers watched in UI:**
- `demandListControllerProvider` (line 239)

### 1.3 Data Model: Demand

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/data/models/demand.dart`  
**Main class:** `Demand` (line 69–158)

**All fields (list item only):**
```dart
id: int                           // Required
code: String?                     // Consultation code
customerName: String?             // Full name
customerPhone: String?            // Phone number
status: String?                   // API status enum ('new', 'active', etc.)
statusName: DemandStatusName?      // Backend status with hex color
budgetMin: double?
budgetMax: double?
areaMin: num?                      // Can be int or double
areaMax: num?
locationNames: List<String>        // Flattened location names
tags: List<DemandTag>              // Colored tag chips
supportName: String?               // Support agent name
officeName: String?                // Post office name
createdAt: String?                 // ISO date
```

**Computed getters:**
- `statusEnum`: `DemandStatus.fromApi(status)` → enum with label + tone
- `statusLabel`: `statusName?.name ?? statusEnum?.label ?? status`

**Helper classes:**
- `DemandStatusName` (line 26–33): `name: String?`, `color: String?` (hex)
- `DemandTag` (line 36–49): `id: int`, `name: String`, `color: String?` (hex), `icon: String?`
- `StatusTab` (line 52–66): `id: String`, `name: String`, `count: int`, `color: String?`

**Related model:** `PagedDemands` (line 161–176)
```dart
items: List<Demand>
total: int
page: int
totalPages: int
statusTabs: List<StatusTab>  // Tabs to display
```

### 1.4 API Methods: DemandsApi

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/data/demands_api.dart`  
**Provider:** `demandsApiProvider` (line 196–197)

**List endpoint (line 37–88):**
```dart
Future<PagedDemands> list({
  String? status,        // 'all' (default), 'new', 'active', 'completed', 'in_transaction', 'cancelled'
  String? search,        // Q parameter: code or phone
  int page = 1,
  int limit = 20,
  int? officeId,
  String? salesOff,
  String? createdBy,
  String? startDate,     // YYYY-MM-DD format
  String? endDate,
  String? cityId,
  String? districtId,
  String? wardId,
  List<int> tagIds = const [],
  String? orAnd,         // 'or' or 'and'
})
```
- **Endpoint:** `${AppConfig.agent}/get_list_consultation`
- **Returns:** `PagedDemands` with items parsed as `Demand.fromJson`

**Example call (line 146–155):**
```dart
_api.list(
  status: state.status,
  search: state.search,
  page: page,
  cityId: state.cityId,
  districtId: state.districtId,
  wardId: state.wardId,
  startDate: state.startDate,
  endDate: state.endDate,
)
```

### 1.5 Status Enum & Labels

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/data/models/demand.dart` (line 5–23)

**DemandStatus enum:**
```dart
enum DemandStatus {
  newd('new', 'Mới', StatusTone.blue),
  active('active', 'Đang diễn ra', StatusTone.amber),
  inTransaction('in_transaction', 'Đang giao dịch', StatusTone.amber),
  completed('completed', 'Kết thúc', StatusTone.green),
  cancelled('cancelled', 'Đã huỷ', StatusTone.red);

  final String api;      // Query param value
  final String label;    // UI label (Vietnamese)
  final StatusTone tone; // Color tone for pill
}
```

**StatusTone enum:**
**File:** `/Users/mac/Developer/mobile_app_v2/lib/core/widgets/status_pill.dart` (line 7)
```dart
enum StatusTone { amber, blue, green, red, neutral }
```

**Status badge implementation:**  
Uses `demandStatusBadge()` helper (line 586–602 in demands_screen.dart):
- If backend `hex` color provided → custom colored pill
- Else → use `StatusTone` pill via `StatusPill` widget

### 1.6 Helper Functions & Widgets

**Budget formatter:** `budgetRangeText(double? min, double? max) → String`  
**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/data/models/demand.dart` (line 343–357)
- Returns: "1 tỷ - 2 tỷ" or "Thỏa thuận" if both null
- Formats large numbers: ≥1e9 as "X tỷ", ≥1e6 as "X triệu"

**Area formatter:** `areaRangeText(num? min, num? max) → String`  
**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/data/models/demand.dart` (line 359–365)
- Returns: "100 - 200 m²" or "—" if both null

**Status badge:** `demandStatusBadge(String label, String? hex, StatusTone? tone) → Widget`  
**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/presentation/demands_screen.dart` (line 586–602)
- Parses hex color via `hexColor()`, builds soft pill if found
- Falls back to `StatusPill` with tone

**Tag chip:** `demandTagChip(DemandTag t) → Widget`  
**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/presentation/demands_screen.dart` (line 604–616)
- Colored container with tag name and hex-parsed background

**Hex color parser:** `hexColor(String? hex) → Color?`  
**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/presentation/demands_screen.dart` (line 619–626)
- Parses "#RRGGBB", "RRGGBB", or padded formats into Color

---

## 2. NHU CẦU BÁN (Sell Leads) Screen

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/consultation_sell/presentation/sell_leads_screen.dart`  
**Route:** `/nhu-cau-ban`

### 2.1 Widget Structure

**Screen Class:** `SellLeadsScreen` (ConsumerStatefulWidget)

**AppBar:**
- Title: "Nhu cầu bán"
- **Custom PreferredSize bottom** (96px height):
  - **Search TextField** (line 173–183):
    - Hint: "Mã, tên / SĐT chủ nhà..."
    - Prefix icon: Icons.search
    - onChange → `_c.setSearch(value)`
  - **Horizontal Status Tab ListView** (line 185–204):
    - 5 fixed tabs: "all", "new", "pending", "consulting", "closed"
    - Dynamic tab labels with count fetched from `sellStatusCountsProvider`
    - Tab component: `_Tab` widget (line 279–303)
    - On tap → `_c.setStatus(status)`

**FAB (FloatingActionButton.extended):**
- Route: `/nhu-cau-ban/create`
- Label: "Tạo nhu cầu bán"
- On pop → `_c.refresh()` + `ref.invalidate(sellStatusCountsProvider)`

**Body (_body method, line 225–276):**
- Loading state: `CircularProgressIndicator`
- Error state: Icon + message + "Thử lại" button
- Empty state: Text "Chưa có nhu cầu bán"
- List: `ListView.separated` with:
  - Scroll listener: triggers `loadMore()` at 300px from bottom
  - Item count: `items.length + 1`
  - Separator: `SizedBox(height: 12)`
  - Item builder: `_SellCard` (line 305–421)
  - RefreshIndicator: calls `_c.refresh()` + `ref.invalidate(sellStatusCountsProvider)`

**Card Component (_SellCard, line 305–421):**
- Material + InkWell for tap
- Border + padding (12px)
- Rows:
  1. Code (caption, muted) + Status pill (right)
  2. Customer name (title) + phone (caption, muted)
  3. Property info: icon + type + area + price (formatted)
  4. Address (if any): icon + fullAddress
  5. Mini tags: listing manager (unassigned muted) + source (if any)

**Mini tag helper:** `_miniTag(IconData icon, String text, bool muted) → Widget`  
**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/consultation_sell/presentation/sell_leads_screen.dart` (line 404–420)
- Small icon + text chip with muted styling when needed

### 2.2 State Management

**State Class:** `SellListState` (line 15–60)  
**Controller:** `SellListController` (AutoDisposeNotifier) (line 62–115)  
**Provider:** `sellListControllerProvider` (line 117–119)

**State fields:**
```dart
status: String = 'all'
search: String = ''
items: List<SellLead> = []
total: int = 0
page: int = 1
hasMore: bool = false
isLoading: bool = false
isLoadingMore: bool = false
error: Object?
```

**Controller methods:**
- `refresh()`: Set `isLoading=true`, fetch page 1 via API
- `loadMore()`: Fetch next page, append items
- `setStatus(s)`: Update status, auto-refresh
- `setSearch(s)`: Debounce 400ms, then refresh

**Providers watched in UI:**
- `sellListControllerProvider` (line 160)
- `sellStatusCountsProvider` (line 161) → counts for tab labels

### 2.3 Data Model: SellLead

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/consultation_sell/data/models/sell_lead.dart`  
**Main class:** `SellLead` (line 95–184)

**All fields (list item only):**
```dart
id: int                    // Required
code: String?              // Demand code
status: String?            // API status enum ('new', 'pending', 'consulting', 'closed')
customerName: String?      // Customer name
customerPhone: String?     // Customer phone
propertyTypeName: String?  // e.g., "Nhà đất", "Chung cư"
area: num?                 // Square meters (int or double)
price: double?             // VND price
address: String?           // Street address
cityName: String?          // City/province
districtName: String?      // District
wardName: String?          // Ward
listingManagerName: String?// Assigned listing manager or null
source: String?            // Lead source (Website, Facebook, etc.)
officeName: String?        // Office name
supportName: String?       // Salesman support name
tags: List<SellTag>        // Tag chips
updatedOn: String?         // ISO date
createdOn: String?         // ISO date
```

**Computed getters:**
- `statusEnum`: `SellStatus.fromApi(status)` → enum with label + tone
- `statusLabel`: `statusEnum?.label ?? status`
- `fullAddress`: Joined parts: address + ward + district + city

**Helper classes:**
- `SellTag` (line 39–49): `id: int`, `name: String`, `color: String?`
- `StatusCount` (line 51–61): `status: String`, `count: int`, `label: String?`
- `ListingManager` (line 63–76): `id: int`, `name: String`, `phone: String?`, `officeName: String?`

**Related model:** `PagedSellLeads` (line 318–325)
```dart
items: List<SellLead>
total: int
page: int
hasMore: bool
```

### 2.4 API Methods: ConsultationSellApi

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/consultation_sell/data/consultation_sell_api.dart`  
**Provider:** `consultationSellApiProvider` (line 211–212)

**List endpoint (line 34–65):**
```dart
Future<PagedSellLeads> list({
  String? status,        // 'all' (default), 'new', 'pending', 'consulting', 'closed'
  String? search,        // Search term
  int page = 1,
  int limit = 20,
  int? officeId,
  int? listingManagerId,
  String? source,        // Lead source filter
  String? startDate,
  String? endDate,
})
```
- **Endpoint:** `${AppConfig.agent}/list_consultation_sell`
- **Returns:** `PagedSellLeads` with items parsed as `SellLead.fromJson`

**Status counts endpoint (line 67–74):**
```dart
Future<List<StatusCount>> statusCounts()
```
- **Endpoint:** `${AppConfig.agent}/get_consultation_sell_status_counts`
- **Returns:** List of `StatusCount` for tab badges

**Example calls (line 76, 92–93):**
```dart
// Initial load
_api.list(status: state.status, search: state.search, page: 1);

// Load more
_api.list(status: state.status, search: state.search, page: state.page + 1);
```

### 2.5 Status Enum & Labels

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/consultation_sell/data/models/sell_lead.dart` (line 5–22)

**SellStatus enum:**
```dart
enum SellStatus {
  newd('new', 'Mới', StatusTone.blue),
  pending('pending', 'Chờ xử lý', StatusTone.amber),
  consulting('consulting', 'Đang tư vấn', StatusTone.blue),
  closed('closed', 'Đã đóng', StatusTone.neutral);

  final String api;      // Query param value
  final String label;    // UI label (Vietnamese)
  final StatusTone tone; // Color tone for pill
}
```

**Status badge implementation:**  
Uses `StatusPill` widget directly (line 336–338 in sell_leads_screen.dart):
```dart
StatusPill(
  label: d.statusLabel,
  tone: st?.tone ?? StatusTone.neutral,
)
```

### 2.6 Helper Functions & Widgets

**Status counts provider:** `sellStatusCountsProvider`  
**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/consultation_sell/data/consultation_sell_api.dart` (line 214–217)
```dart
final sellStatusCountsProvider = FutureProvider.autoDispose<List<StatusCount>>((ref) {
  return ref.watch(consultationSellApiProvider).statusCounts();
});
```

**Tab count lookup (line 161–163 in sell_leads_screen.dart):**
```dart
final counts = ref.watch(sellStatusCountsProvider).valueOrNull ?? const [];
int countFor(String s) =>
  counts.firstWhere((c) => c.status == s, orElse: () => const StatusCount(status: '')).count;
```

**Price formatter (inline, line 357–360 in sell_leads_screen.dart):**
```dart
d.price! >= 1e9
  ? '${(d.price! / 1e9).toStringAsFixed(1)} tỷ'
  : '${(d.price! / 1e6).toStringAsFixed(0)} tr'
```

---

## 3. Shared Theme & Widget Utilities

### 3.1 StatusPill Widget

**File:** `/Users/mac/Developer/mobile_app_v2/lib/core/widgets/status_pill.dart`

```dart
class StatusPill extends StatelessWidget {
  const StatusPill({required this.label, this.tone = StatusTone.neutral});
  final String label;
  final StatusTone tone;
}
```

**Tone → color mapping:**
- `amber` → `amberBg` / `amberFg`
- `blue` → `blueBg` / `blueFg`
- `green` → `greenBg` / `greenFg`
- `red` → `redBg` / `redFg`
- `neutral` → Gray `#F5F5F4` / `textSecondary`

### 3.2 AppColors

**File:** `/Users/mac/Developer/mobile_app_v2/lib/core/theme/app_colors.dart`

**Key colors used:**
- Primary: `#F26F21` (orange)
- Surface: `#FFFFFF`
- Border: `#E7E5E4`
- Text tones: text, textSecondary, textMute
- Status backgrounds/foregrounds (amberBg/Fg, blueBg/Fg, greenBg/Fg, redBg/Fg)

**Hex parser:** `AppColors.fromHex(String? hex) → Color`  
(Alternative to `hexColor()` in demands_screen.dart)

---

## 4. Navigation Routes

**Demands List:**
- List screen: `/demands`
- Detail: `/demand/:id` (push on card tap)
- Create: `/demand/create` (push FAB, expect bool return)

**Sell Leads List:**
- List screen: `/nhu-cau-ban`
- Detail: `/nhu-cau-ban/:id` (push on card tap)
- Create: `/nhu-cau-ban/create` (push FAB, expect bool return)

---

## 5. Summary Table: Reusable Pieces for UI Rewrite

| Component | Type | Location | Notes |
|-----------|------|----------|-------|
| `demandListControllerProvider` | Provider | demands_screen.dart:195 | Riverpod AutoDisposeNotifier; watch for list state |
| `sellListControllerProvider` | Provider | sell_leads_screen.dart:117 | Riverpod AutoDisposeNotifier; watch for list state |
| `sellStatusCountsProvider` | FutureProvider | consultation_sell_api.dart:214 | Fetch tab counts; invalidate on refresh |
| `Demand` model | Class | demand.dart:69 | Parse from API; has statusEnum, statusLabel getters |
| `SellLead` model | Class | sell_lead.dart:95 | Parse from API; has statusEnum, statusLabel, fullAddress getters |
| `DemandStatus` enum | Enum | demand.dart:5 | api, label, tone; use `fromApi(status)` |
| `SellStatus` enum | Enum | sell_lead.dart:5 | api, label, tone; use `fromApi(status)` |
| `StatusTone` enum | Enum | status_pill.dart:7 | Defines amber, blue, green, red, neutral |
| `StatusPill` widget | Widget | status_pill.dart:10 | Renders tone-based status badges |
| `budgetRangeText()` | Function | demand.dart:343 | Format double? min/max → Vietnamese text |
| `areaRangeText()` | Function | demand.dart:359 | Format num? min/max → Vietnamese text |
| `demandStatusBadge()` | Function | demands_screen.dart:586 | Render status badge with hex or tone fallback |
| `demandTagChip()` | Function | demands_screen.dart:604 | Render colored tag chip |
| `hexColor()` | Function | demands_screen.dart:619 | Parse hex string → Color or null |
| `DemandsApi.list()` | Method | demands_api.dart:37 | Fetch paged demands; returns PagedDemands |
| `ConsultationSellApi.list()` | Method | consultation_sell_api.dart:34 | Fetch paged sell leads; returns PagedSellLeads |
| `AppColors` | Class | app_colors.dart | Design tokens: primary, surface, status colors |

---

## 6. Key Implementation Details for UI Rewrite

### Demands Screen
1. **Watch provider:** `demandListControllerProvider`
2. **Call methods:** `setStatus()`, `setSearch()`, `setLocation()`, `setDateRange()`, `clearFilters()`, `refresh()`, `loadMore()`
3. **Render model:** `Demand` → use `budgetRangeText()`, `areaRangeText()`, `demandStatusBadge()`, `demandTagChip()`
4. **Status enum:** `d.statusEnum` (DemandStatus) for tone, `d.statusLabel` for display text
5. **Pagination:** Check `state.hasMore`, call `loadMore()` on scroll
6. **Filters:** Location + date range in bottom sheet, clear button

### Sell Leads Screen
1. **Watch providers:** `sellListControllerProvider` + `sellStatusCountsProvider` for tab counts
2. **Call methods:** `setStatus()`, `setSearch()`, `refresh()`, `loadMore()`
3. **Render model:** `SellLead` → use `d.fullAddress`, `d.statusLabel`, inline price formatter
4. **Status enum:** `d.statusEnum` (SellStatus) for tone, `d.statusLabel` for display
5. **Pagination:** Check `state.hasMore`, call `loadMore()` on scroll
6. **Status counts:** Invalidate `sellStatusCountsProvider` on refresh/create

### Both Screens
- **Debounced search:** Timer 400ms in controller
- **RefreshIndicator:** Pull-to-refresh calls `refresh()`
- **Loading states:** Show spinner or "Thử lại" button on error
- **Navigation:** Push `/demand/{id}` or `/nhu-cau-ban/{id}` on card tap
- **FAB navigation:** Push create routes, expect bool return for refresh


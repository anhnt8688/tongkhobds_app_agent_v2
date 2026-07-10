# Loan Feature Port Template Report

**Scope:** Map v2 Flutter app conventions for porting a new "vay vốn" (loan) feature. Analysis based on `demands` (nhu cầu mua) and `customers` features as canonical examples.

**Project:** TongkhoBDS v2 (Riverpod + go_router + Dio + Freezed)

---

## 1. Feature Folder Layout

**Canonical structure** (from `lib/features/demands/`):

```
lib/features/loan/
├── data/
│   ├── loan_api.dart                    # Dio client, providers
│   └── models/
│       ├── loan.dart                    # Main entity (plain or @freezed)
│       ├── loan_detail.dart             # Detail view (list vs. detail payloads differ)
│       └── loan_product.dart            # Enum-like or typed options
├── presentation/
│   ├── loan_list_screen.dart            # Tabbed list (status tabs, search, filters)
│   ├── loan_create_screen.dart          # Multi-step form or single-page
│   ├── loan_detail_screen.dart          # Detail view, tabs (timeline, docs, notes)
│   └── widgets/
│       ├── loan_list_card.dart          # Reusable tile
│       ├── loan_create_widgets.dart     # Form fields (picker, range inputs)
│       ├── loan_status_tab.dart         # If custom tabs needed
│       ├── loan_picker_sheet.dart       # Bottomsheet pickers
│       └── [other splits for >200 lines]
```

**Key pattern:** data & models separate, presentation screens with colocated state, widgets for any screen >200 lines.

---

## 2. Networking Pattern

### API Class Structure

**Example:** `lib/features/demands/data/demands_api.dart` (lines 14–226)

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';
import 'models/demand.dart';

class DemandsApi {
  DemandsApi(this._dio);
  final Dio _dio;

  String get _a => AppConfig.agent;  // Namespace prefix

  // Helper to unwrap backend's nested {data}, {result}, or flat response
  Map _inner(Object? data) {
    if (data is! Map) return const {};
    if (data['data'] is Map) return data['data'] as Map;
    if (data['result'] is Map) return data['result'] as Map;
    return data;
  }

  Future<PagedDemands> list({
    int page = 1,
    int limit = 20,
    String? status,
    String? search,
  }) async {
    final q = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (status != null && status != 'all') 'status': status,
      if (search != null && search.trim().isNotEmpty) 'q': search.trim(),
    };
    final res = await _dio.get('$_a/get_list_consultation', queryParameters: q);
    final items = _listOf(res.data, ['items'])
        .whereType<Map>()
        .map(Demand.fromJson)
        .toList();
    return PagedDemands(items: items, ...);
  }

  Future<int> create(Map<String, dynamic> payload) async {
    final res = await _dio.post('$_a/create_customer_demand', data: payload);
    return asInt(_inner(res.data)['id']);
  }

  Future<void> work(Map<String, dynamic> payload) async {
    // rawEnvelope: opt out of envelope unwrapping when endpoint has
    // {success, data} structure instead of {status, data}.
    final res = await _dio.post(
      '$_a/work_consultation',
      data: payload,
      options: Options(extra: {'rawEnvelope': true}),
    );
    final data = res.data;
    if (data is Map && data['success'] == false) {
      throw ApiException(data['message']?.toString() ?? 'Failed');
    }
  }
}

// Riverpod provider
final demandsApiProvider =
    Provider<DemandsApi>((ref) => DemandsApi(ref.watch(dioProvider)));

// Data providers
final demandDetailProvider =
    FutureProvider.autoDispose.family<DemandDetail, int>((ref, id) {
  return ref.watch(demandsApiProvider).detail(id);
});
```

### AppConfig Namespace Constants

**File:** `/Users/mac/Developer/mobile_app_v2/lib/core/config/app_config.dart` (lines 20–24)

```dart
// API namespaces (appended to [baseUrl]).
static const String agent = '/api_agent';
static const String customer = '/api_customer';
static const String common = '/api_common';
static const String public = '/api';
```

**Usage:** `'$_a/endpoint'` expands to `/api_agent/endpoint`. **Choose namespace matching v1 or the loan API's actual location.** For loan (vay vốn), likely `/api_agent` or `/api_common`.

### EnvelopeInterceptor & Request Options

**Unwrapping behavior** (CLAUDE.md, line 38):

- **Default:** Backend wraps `{status: 0, message: "OK", data: {...}}` → interceptor unwraps → methods receive the inner object.
- **Skip unwrapping:** `Options(extra: {'rawEnvelope': true})` when the real payload is in `message` (e.g., referral APIs, work_consultation).
- **Skip auth:** `Options(extra: {AuthInterceptor.skipAuthKey: true})` for public endpoints (login/OTP/register).

### Defensive JSON Parsing

**File:** `/Users/mac/Developer/mobile_app_v2/lib/core/utils/json_parse.dart` (lines 1–70)

Available helpers:

| Helper | Signature | Use |
|--------|-----------|-----|
| `asInt` | `int asInt(Object? value, {int fallback = 0})` | Coerce int/double/string to int. |
| `asIntOrNull` | `int? asIntOrNull(Object? value)` | Return null if missing/invalid. |
| `asDouble` | `double asDouble(Object? value, {double fallback = 0})` | Coerce to double. |
| `asDoubleOrNull` | `double? asDoubleOrNull(Object? value)` | Return null if missing/invalid. |
| `asString` | `String asString(Object? value, {String fallback = ''})` | Coerce to string. |
| `asIntCsv` | `List<int> asIntCsv(Object? value)` | Parse comma-sep or JSON list to int list. |
| `asStringList` | `List<String> asStringList(Object? value)` | Parse to string list. |

**Example from demand.dart (line 128–146):**
```dart
budgetMin: asDoubleOrNull(d['budget_min'] ?? d['min_price']) ??
    rangeVal(reqMap['budget_range'], 'min'),
```

---

## 3. Models Pattern

### Freezed + json_serializable

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/auth/data/models/user.dart` (lines 1–91)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Profile model, tolerant of int/string backend variations.
@freezed
class User with _$User {
  const factory User({
    @JsonKey(readValue: _id) @Default(0) int id,
    @JsonKey(name: 'full_name', readValue: _fullName) @Default('') String fullName,
    @JsonKey(readValue: _email) @Default('') String email,
    String? image,
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Computed getter
  bool get isVerified => step >= 3;
}

// readValue helpers tolerate alternate keys/types.
Object? _id(Map m, String _) => asInt(m['id'] ?? m['user_id']);
Object? _fullName(Map m, String _) => m['full_name'] ?? m['name'] ?? '';
```

### Plain Classes (Simpler Alternative)

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/customers/data/models/customer.dart` (lines 1–36)

```dart
import '../../../../core/utils/json_parse.dart';

class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
  });

  final int id;
  final String name;
  final String phone;
  final String? email;

  factory Customer.fromJson(Map data) => Customer(
    id: asInt(data['id'] ?? data['customer_id']),
    name: (data['name'] ?? '').toString(),
    phone: (data['phone'] ?? '').toString(),
    email: data['email']?.toString(),
  );
}
```

**Loan choice:** Use Freezed if the model is complex (10+ fields, computed getters, immutability essential). Use plain class if simple (5–8 fields, no transformation).

### Build Runner

**CLAUDE.md (line 22):**

After editing any `@freezed` or `@JsonSerializable` model, regenerate:

```bash
dart run build_runner build --delete-conflicting-outputs
# Or watch mode for active development:
dart run build_runner watch --delete-conflicting-outputs
```

Generated files (`.freezed.dart`, `.g.dart`) are excluded from analysis; never edit by hand.

---

## 4. Riverpod Controller Pattern

### AutoDisposeNotifier (List Screen)

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/presentation/demands_screen.dart` (lines 22–201)

```dart
// State class (plain data holder)
class DemandListState {
  const DemandListState({
    this.status = 'all',
    this.search = '',
    this.page = 1,
    this.totalPages = 1,
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  final String status;
  final String search;
  final List<Demand> items;
  final int page;
  final int totalPages;
  final bool isLoading;
  final bool isLoadingMore;
  final Object? error;

  bool get hasMore => page < totalPages;

  DemandListState copyWith({...}) { ... }
}

// Controller (mutable state + side effects)
class DemandListController extends AutoDisposeNotifier<DemandListState> {
  DemandsApi get _api => ref.read(demandsApiProvider);
  Timer? _debounce;

  @override
  DemandListState build() {
    ref.onDispose(() => _debounce?.cancel());
    Future.microtask(refresh);  // Auto-load on init
    return const DemandListState(isLoading: true);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final res = await _api.list(
        status: state.status,
        search: state.search,
        page: 1,
      );
      state = state.copyWith(
        items: res.items,
        total: res.total,
        page: 1,
        totalPages: res.totalPages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final res = await _api.list(page: state.page + 1, ...);
      state = state.copyWith(
        items: [...state.items, ...res.items],
        page: state.page + 1,
        totalPages: res.totalPages,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }

  void setStatus(String s) {
    if (s == state.status) return;
    state = state.copyWith(status: s);
    refresh();
  }

  void setSearch(String s) {
    state = state.copyWith(search: s);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), refresh);
  }
}

// Provider
final demandListControllerProvider =
    AutoDisposeNotifierProvider<DemandListController, DemandListState>(
        DemandListController.new);
```

### Screen Consumption Pattern

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/presentation/demands_screen.dart` (lines 205–239)

```dart
class DemandsScreen extends ConsumerStatefulWidget {
  const DemandsScreen({super.key});

  @override
  ConsumerState<DemandsScreen> createState() => _DemandsScreenState();
}

class _DemandsScreenState extends ConsumerState<DemandsScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
        ref.read(demandListControllerProvider.notifier).loadMore();
      }
    });
  }

  DemandListController get _c => ref.read(demandListControllerProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(demandListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nhu cầu mua')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? _ErrorWidget(onRetry: () => _c.refresh())
              : ListView.builder(
                  controller: _scroll,
                  itemCount: state.items.length,
                  itemBuilder: (_, i) => ConsultationListCard(item: state.items[i]),
                ),
    );
  }
}
```

### Summary

- **State class:** Data + copyWith (immutable value object).
- **AutoDisposeNotifier:** Mutable controller, auto-cleanup on unmount.
- **FutureProvider:** Read-only async data (use when no mutations).
- **StateProvider:** Global state (search filters, selected items).

---

## 5. Routing

### Route Registration Pattern

**File:** `/Users/mac/Developer/mobile_app_v2/lib/core/router/app_router.dart` (lines 196–226)

```dart
// Within the GoRouter(routes: [...]) list:

GoRoute(
  path: '/demands',
  parentNavigatorKey: _rootKey,
  builder: (_, __) => const DemandsScreen(),
),
GoRoute(
  path: '/demand/create',
  parentNavigatorKey: _rootKey,
  builder: (_, __) => const DemandCreateScreen(),
),
GoRoute(
  path: '/demand/:id',
  parentNavigatorKey: _rootKey,
  builder: (_, state) => DemandDetailScreen(
    id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
  ),
),
GoRoute(
  path: '/customers/edit',
  parentNavigatorKey: _rootKey,
  builder: (_, state) => CustomerFormScreen(
    mode: CustomerFormMode.edit,
    customer: state.extra is Customer ? state.extra as Customer : null,
  ),
),
```

### Key Conventions

| Pattern | Example | Notes |
|---------|---------|-------|
| List screen | `/demands` | No param, full-screen. |
| Create/form | `/demand/create` | Push with `context.push(...)`. |
| Detail by ID | `/demand/:id` | Parse from `state.pathParameters['id']`. |
| Pass object via extra | `state.extra as Customer` | Use `context.push(path, extra: obj)`. |
| Parent navigator key | `parentNavigatorKey: _rootKey` | Full-screen above shell (not a bottom-nav tab). |

### Where to Add Loan Routes

**For loan, likely pattern:**

```dart
GoRoute(
  path: '/loans',
  parentNavigatorKey: _rootKey,
  builder: (_, __) => const LoansScreen(),
),
GoRoute(
  path: '/loan/create',
  parentNavigatorKey: _rootKey,
  builder: (_, __) => const LoanCreateScreen(),
),
GoRoute(
  path: '/loan/:id',
  parentNavigatorKey: _rootKey,
  builder: (_, state) => LoanDetailScreen(
    id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
  ),
),
```

### Menu Entry Point

The app uses **server-driven "quick tools"** (menu from backend).

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/profile/presentation/widgets/profile_quick_tools.dart` (lines 73–104)

Backend routes by `QuickTool.description` field. **No hardcoded loan entry** yet; backend admin creates a tool with `description: "/vay_von"` or similar.

**To wire in code** (if you add a hardcoded menu entry):

```dart
// In profile_quick_tools.dart, _handleTap() method:
if (desc.contains('/vay_von')) {
  context.push('/loans');
} else if (desc.contains('/loan/create')) {
  context.push('/loan/create');
}
```

Or use the server-driven approach: create a backend menu item pointing to `/loans`.

---

## 6. Shared UI Kit & Theme Tokens

### Core Widgets

**Location:** `/Users/mac/Developer/mobile_app_v2/lib/core/widgets/`

| Widget | File | Constructor Signature |
|--------|------|----------------------|
| **AppButton** | `app_button.dart` | `AppButton({required label, onPressed, variant, icon, loading, expand})` |
| **AppTextField** | `app_text_field.dart` | `AppTextField({required label, controller, hint, validator, onChanged})` |
| **AsyncView** | `async_view.dart` | `AsyncView<T>({required value, required data, onRetry})` |
| **StatusPill** | `status_pill.dart` | `StatusPill({required label, tone})` |
| **AppNetworkImage** | `app_network_image.dart` | `AppNetworkImage({required url, width, height, fit, borderRadius})` |
| **AppToast** | `app_toast.dart` | `AppToast.success(context, msg)` / `.error(context, msg)` |
| **ConsultationListCard** | `consultation_list_card.dart` | `ConsultationListCard({required item})` |

### Theme Tokens

**Colors:** `/Users/mac/Developer/mobile_app_v2/lib/core/theme/app_colors.dart` (lines 4–52)

```dart
static const Color primary = Color(0xFFF26F21);          // Orange
static const Color primarySoft = Color(0xFFFFEDD5);      // Light orange
static const Color primaryDark = Color(0xFFD85F12);      // Dark orange
static const Color success = Color(0xFF12B76A);
static const Color warning = Color(0xFFF79009);
static const Color danger = Color(0xFFEF4444);
static const Color info = Color(0xFF2E90FA);
static const Color bg = Color(0xFFFAFAF9);               // Light gray
static const Color surface = Color(0xFFFFFFFF);          // White
static const Color border = Color(0xFFE7E5E4);
static const Color text = Color(0xFF292524);             // Dark gray
static const Color textSecondary = Color(0xFF57534E);
static const Color textMute = Color(0xFF78716C);
// Status tone backgrounds
static const Color amberBg = Color(0xFFFEF3C7);
static const Color blueBg = Color(0xFFDBEAFE);
static const Color greenBg = Color(0xFFD1FAE5);
static const Color redBg = Color(0xFFFEE2E2);
```

**Spacing:** `/Users/mac/Developer/mobile_app_v2/lib/core/theme/app_spacing.dart` (lines 2–22)

```dart
static const double xs = 4;
static const double sm = 8;
static const double md = 12;
static const double lg = 16;
static const double xl = 24;

static const double radiusSm = 6;
static const double radiusMd = 8;
static const double radiusLg = 12;
static const double radiusXl = 16;
static const double radiusPill = 999;

static const double controlHeight = 44;          // Buttons, inputs
static const double screenPadding = 16;          // Horizontal screen margin
```

**Typography:** `/Users/mac/Developer/mobile_app_v2/lib/core/theme/app_typography.dart` (lines 12–60)

```dart
static const TextStyle display = TextStyle(fontSize: 24, fontWeight: FontWeight.w700);
static const TextStyle heading = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
static const TextStyle title = TextStyle(fontSize: 15, fontWeight: FontWeight.w700);
static const TextStyle body = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
static const TextStyle subtitle = TextStyle(fontSize: 13, fontWeight: FontWeight.w500);
static const TextStyle caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
static const TextStyle micro = TextStyle(fontSize: 11, fontWeight: FontWeight.w400);
```

**Font family:** `'SF Pro Display'` (or platform default on iOS).

### Bottomsheet Pattern

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/presentation/widgets/customer_picker_sheet.dart` & `demand_create_screen.dart` (lines 79–90)

```dart
Future<void> _pickCustomer() async {
  final picked = await showModalBottomSheet<Customer>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const CustomerPickerSheet(),
  );
  if (picked != null) setState(() => _customer = picked);
}
```

**Widget signature:**

```dart
class CustomerPickerSheet extends ConsumerWidget {
  const CustomerPickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ListView with items, tap to return: Navigator.pop(context, selectedItem)
  }
}
```

### TabBar Pattern

**File:** `/Users/mac/Developer/mobile_app_v2/lib/features/demands/presentation/demand_detail_screen.dart` (implied)

Demands uses a pinned `TabBar` above scrollable content:

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(pinned: true, ...),  // Scrollable header
    SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(tabs: [...]),  // Pinned tabs
    ),
    SliverFillRemaining(
      child: TabBarView(children: [...]),  // Tab content
    ),
  ],
);
```

---

## 7. Where Loan Feature Should Slot In

### Folder Path

```
lib/features/loan/
├── data/
│   ├── loan_api.dart
│   └── models/
│       ├── loan.dart
│       ├── loan_detail.dart
│       └── loan_product.dart
├── presentation/
│   ├── loan_list_screen.dart
│   ├── loan_create_screen.dart
│   ├── loan_detail_screen.dart
│   └── widgets/
│       ├── loan_list_card.dart
│       ├── loan_picker_sheet.dart
│       └── loan_form_widgets.dart
```

### Route Names

- List: `/loans`
- Create: `/loan/create`
- Detail: `/loan/:id`

**Add to app_router.dart** (lines 196–226 area, alongside `/demands` routes).

### API Namespace

**Candidate:** `/api_agent` (default for agent-owned features like demands, customers).

Fallback to `/api_common` if loan endpoints are shared across agent/customer roles.

Use `String get _a => AppConfig.agent;` in `LoanApi` constructor.

### Entry Point in Menu

**Option A (Server-driven):** Backend creates a QuickTool with `description` containing `/loan` or `/vay_von`. No code change needed.

**Option B (Hardcoded menu):** Add to `profile_quick_tools.dart` (line 87):

```dart
} else if (desc.contains('/vay_von') || desc.contains('/loan')) {
  context.push('/loans');
}
```

**Profile grid location:** `/Users/mac/Developer/mobile_app_v2/lib/features/profile/presentation/widgets/profile_quick_tools.dart` (lines 71–104, the `_handleTap` method).

---

## Summary: Concrete Implementation Checklist

1. **Create folder structure:**
   - `lib/features/loan/data/loan_api.dart` + models/
   - `lib/features/loan/presentation/` screens + widgets/

2. **Implement `LoanApi`:**
   - Constructor: `LoanApi(this._dio)` + `String get _a => AppConfig.agent;`
   - Methods: `list({...})`, `detail(int id)`, `create(payload)`, `update(payload)`.
   - Defensive parsing with `asInt`, `asDoubleOrNull`, etc.
   - Provider: `final loanApiProvider = Provider<LoanApi>((ref) => LoanApi(ref.watch(dioProvider)));`

3. **Define models:**
   - `Loan` (list item, plain class OK).
   - `LoanDetail` (detail view).
   - Use `fromJson` factories with defensive parsing.

4. **Implement screens:**
   - `LoanListScreen` with `AutoDisposeNotifier` controller (search, filter, pagination).
   - `LoanCreateScreen` (form with pickers, bottomsheets).
   - `LoanDetailScreen` (AsyncView, tabs if applicable).

5. **Add routes:**
   - Insert at `/Users/mac/Developer/mobile_app_v2/lib/core/router/app_router.dart` (after line 195).

6. **Wire menu entry:**
   - Update `profile_quick_tools.dart` to route `/vay_von` or `/loan` to `/loans`.
   - Or rely on server-driven backend menu.

7. **Run build_runner:**
   - If using `@freezed` models: `dart run build_runner build --delete-conflicting-outputs`.

---

**Generated by:** Explore agent  
**Date:** 2026-07-01  
**Template confidence:** High (validated against `demands`, `customers` features)

# Tong hop tai lieu docs

File nay duoc tao tu cac tai lieu dang text trong folder `docs`.

- Ngay tao: 2026-05-28
- So file da ghep: 48
- File bo qua: `docs/Xác thực BDS .xlsx`, `docs/nhucau_ban.pen`

## Muc luc

- [docs/01-brainstorm.md](#docs-01-brainstorm-md)
- [docs/02-api-catalog.md](#docs-02-api-catalog-md)
- [docs/03-be-questions.md](#docs-03-be-questions-md)
- [docs/04-api-by-screen.md](#docs-04-api-by-screen-md)
- [docs/05-be-handoff-consultation-actions.md](#docs-05-be-handoff-consultation-actions-md)
- [docs/06-be-handoff-consultation-views.md](#docs-06-be-handoff-consultation-views-md)
- [docs/06-xac-thuc-bds-flow.md](#docs-06-xac-thuc-bds-flow-md)
- [docs/07-ba-nhu-cau-ban.md](#docs-07-ba-nhu-cau-ban-md)
- [docs/08-be-handoff-lead-seller-data.md](#docs-08-be-handoff-lead-seller-data-md)
- [docs/09-api-tin-tuc-du-an.md](#docs-09-api-tin-tuc-du-an-md)
- [docs/10-be-handoff-nhac-xac-thuc-bds.md](#docs-10-be-handoff-nhac-xac-thuc-bds-md)
- [docs/11-be-requirements-missing-apis.md](#docs-11-be-requirements-missing-apis-md)
- [docs/12-be-api-hop-dong-trich-thuong.md](#docs-12-be-api-hop-dong-trich-thuong-md)
- [docs/13-be-api-khach-hang.md](#docs-13-be-api-khach-hang-md)
- [docs/14-be-api-dashboard-rank-notif.md](#docs-14-be-api-dashboard-rank-notif-md)
- [docs/API_Call_Logging.md](#docs-api-call-logging-md)
- [docs/API_Consultation_Activities.md](#docs-api-consultation-activities-md)
- [docs/API_contracts_by_types.md](#docs-api-contracts-by-types-md)
- [docs/BA/bds-detail-actions-and-views.md](#docs-ba-bds-detail-actions-and-views-md)
- [docs/README.md](#docs-readme-md)
- [docs/api_agent_batch_update.md](#docs-api-agent-batch-update-md)
- [docs/consultation-sell-api-delivery.md](#docs-consultation-sell-api-delivery-md)
- [docs/consultation-sell-api-integration-report.md](#docs-consultation-sell-api-integration-report-md)
- [docs/consultation-sell-api-requirements.md](#docs-consultation-sell-api-requirements-md)
- [docs/consultation_sell_api.md](#docs-consultation-sell-api-md)
- [docs/deployment-guide.md](#docs-deployment-guide-md)
- [docs/nhu-cau/FE_INTEGRATION_WORK_CONSULTATION.md](#docs-nhu-cau-fe-integration-work-consultation-md)
- [docs/nhu-cau/contract_seller_create.md](#docs-nhu-cau-contract-seller-create-md)
- [docs/nhu-cau/postman_work_consultation.json](#docs-nhu-cau-postman-work-consultation-json)
- [docs/project-changelog.md](#docs-project-changelog-md)
- [docs/qa-overlay-dev-checklist.md](#docs-qa-overlay-dev-checklist-md)
- [docs/qa-overlay-guide.md](#docs-qa-overlay-guide-md)
- [docs/screens/bds-filter-location.md](#docs-screens-bds-filter-location-md)
- [docs/screens/component-library.md](#docs-screens-component-library-md)
- [docs/screens/design-tokens.md](#docs-screens-design-tokens-md)
- [docs/screens/hop-dong-moi-gioi-screens.md](#docs-screens-hop-dong-moi-gioi-screens-md)
- [docs/screens/hop-dong-trich-thuong-screens.md](#docs-screens-hop-dong-trich-thuong-screens-md)
- [docs/screens/khach-hang-screens.md](#docs-screens-khach-hang-screens-md)
- [docs/screens/nhu-cau-screens.md](#docs-screens-nhu-cau-screens-md)
- [docs/screens/phase-02-screens.md](#docs-screens-phase-02-screens-md)
- [docs/screens/phase-03-screens.md](#docs-screens-phase-03-screens-md)
- [docs/screens/phase-08-screens.md](#docs-screens-phase-08-screens-md)
- [docs/screens/xac-thuc-bds-screens.md](#docs-screens-xac-thuc-bds-screens-md)
- [docs/superpowers/plans/2026-05-13-consultation-activities-api.md](#docs-superpowers-plans-2026-05-13-consultation-activities-api-md)
- [docs/superpowers/plans/2026-05-21-find-bds-filter-panel.md](#docs-superpowers-plans-2026-05-21-find-bds-filter-panel-md)
- [docs/superpowers/specs/2026-05-21-find-bds-filter-panel-design.md](#docs-superpowers-specs-2026-05-21-find-bds-filter-panel-design-md)
- [docs/system-architecture.md](#docs-system-architecture-md)
- [docs/user-guide.md](#docs-user-guide-md)

---

<a id="docs-01-brainstorm-md"></a>

## docs/01-brainstorm.md

---
title: "Brainstorm — Webapp Agent Next.js (thay Flutter)"
type: brainstorm-report
date: 2026-04-17
project: Tổng Kho BDS
status: agreed
---

# Brainstorm Report — Webapp Agent Next.js

## Problem Statement

Triển khai webapp mới cho Agent (NVKD) với feature tương tự app Flutter hiện tại (74 màn). BE Python Web2py V1 giữ nguyên, FE build mới.

**Ràng buộc:**
- BE không có OpenAPI docs → reverse từ Flutter Dio calls
- Timeline 3-4 tháng, 1 FE dev solo (⚠️ risk cao — user chấp nhận)
- Responsive full: desktop + tablet + mobile
- Không cần SEO (tool nội bộ Agent)

## Evaluated Approaches (FE framework)

| Stack | Fit 30-35 màn | Ecosystem VN | Component lib | Kết quả |
|-------|---|---|---|---|
| Go templ + htmx | ⚠️ Khó chat/map/form phức tạp | ❌ Ít dev | ❌ Nhỏ | ❌ Loại |
| Go-app (WASM) | ⚠️ Bundle lớn | ❌ Cực ít | ❌ Rất nhỏ | ❌ Loại |
| Astro 4 | ❌ Islands awkward cho dashboard app | ⚠️ Medium | ⚠️ Qua React island | ❌ Loại (hợp content site, không hợp app-heavy) |
| SvelteKit | ✅ Tốt | ⚠️ Ít dev | ⚠️ Nhỏ hơn | ⚠️ Không chọn |
| Nuxt 3 | ✅ Tốt | ✅ Nhiều | ✅ PrimeVue/Vuetify | ⚠️ Không chọn |
| **Next.js 15** | ✅ Tốt nhất | ✅ Lớn nhất | ✅ shadcn/ui | ✅ **CHỌN** |

**Rationale Next.js:**
- Ecosystem lớn nhất cho app dashboard 30-35 màn nhiều form/table/flow
- shadcn/ui + TanStack Table + React Hook Form = combo chuẩn cho internal tool
- Thống nhất với website V2 đang plan Next.js
- App Router + Route Handler giải bài toán proxy Web2py (same-origin cookie)
- Dev VN quen, tuyển/handoff dễ sau này

## Final Recommended Solution

### Stack Matrix

| Layer | Tool | Lý do |
|-------|------|-------|
| Framework | Next.js 15 (App Router) | SPA-like + RSC + Route Handler proxy |
| Language | TypeScript strict | Type-safe API từ reverse Flutter |
| UI | shadcn/ui + Tailwind CSS v4 | Component copy-paste, customizable |
| Server state | **TanStack Query v5** | Cache + refetch + polling notification |
| Global client state | **Zustand** | Filter BDS, so sánh, user prefs |
| Form | **React Hook Form + Zod** | Multi-step create_news, make_deposit, contract |
| Data table | **TanStack Table** | Bảng hàng, giao dịch list, KYC review |
| HTTP client | ofetch | Modern, nhẹ, built-in Next support |
| Map | **Webview embed (kept as Flutter)** | User chấp nhận trade-off đồng bộ UX với app |
| Icons | lucide-react | Pair chuẩn shadcn |
| Dates | date-fns | Locale vi |
| Lint/Format | Biome | Fast |
| Test | Vitest + Playwright | Unit + E2E |
| Deploy | Docker standalone + Coolify/Dokploy | Self-host, control tốt |

### MVP Scope ~30-35 màn

| Nhóm | Màn (include MVP) | Số |
|------|---|---|
| Auth + KYC | login, otp, forgot_pass, KYC, splash | 5 |
| Home + Search + Map | home, advanced_search, select_location, real_estate_map (webview) | 4 |
| BDS + Dự án + Bảng hàng | bds_list, bds_detail, my_product, favorite, detail_project, sale_project, list_apartments, create_news | 8 |
| Giao dịch + Đặt cọc | transaction list/detail, make_deposit, deposit_work | 4 |
| Nhu cầu + Khách | demand list/create/detail, customer_support, add_customer | 5 |
| Lịch hẹn | make_appointment, detail | 2 |
| Hợp đồng | contract list, contract detail, contract_library | 3 |
| Profile + Team + Rank | info, update_profile, team_management, rank_member | 4 |
| Notification | notification list (polling 30s) | 1 |
| **Tổng MVP** | | **36** |
| **Bỏ khỏi MVP (phase 2)** | Chat, Events, Wallet, Loan, Rose (phong thuỷ), Utilities, QR scan, Camera | — |

### Kiến trúc Auth + API

```
Browser (agent.tongkhobds.com)
    ↓ /api/bds/list
Next.js Route Handler (app/api/[...path]/route.ts)
    ↓ forward + inject session cookie
Web2py BE (backend.internal)
```

- **Session cookie same-origin** → no CORS hell, no CSRF cross-origin risk
- **Next middleware** check session cookie, redirect /login nếu miss
- **Route handler proxy** hide BE URL, log/monitor tập trung
- **Auth endpoints reverse từ Flutter Dio**: `/login`, `/logout`, `/otp_verify`, `/me`

### Notification Strategy

- Không dùng Firebase Web Push (BE Web2py không có infra)
- TanStack Query polling: `useQuery(['notifications'], { refetchInterval: 30000 })`
- Tab inactive → polling tự pause (TanStack default)
- Badge count trong header, list page chi tiết

### File Upload Strategy

- Chỉ web File API (`<input type="file">`)
- KYC ảnh: upload từ file đã chụp sẵn (không có camera capture)
- Contract PDF: upload file trực tiếp
- Ảnh BDS: multi-upload + preview + reorder (react-dropzone)
- QR scan: **bỏ khỏi MVP**

## Implementation Considerations & Risks

### Risk matrix

| Risk | Level | Mitigation |
|------|-------|------------|
| **Timeline 3-4 tháng + 1 FE solo cho 35 màn** | 🔴 Cao | User đã chấp nhận risk. Có thể slip sang 5-6 tháng. Scope cắt thêm nếu cần. |
| **API reverse từ Flutter (không có OpenAPI)** | 🟠 Trung-cao | Phase 1: research Dio calls trong `tongkhobds_agent/lib`, build API catalog Markdown trước khi code |
| **BE Web2py có thể không support tất cả endpoint cần** | 🟡 Trung | Block khi gặp → request BE team. Buffer timeline 10%. |
| **Map webview embed khó styling consistent** | 🟡 Trung | Accept trade-off. Refactor sang Mapbox GL JS native ở phase 2. |
| **Session cookie Web2py TTL expired giữa phiên** | 🟡 Trung | Middleware Next bắt 401, redirect /login + refresh flow |
| **Responsive full với UI phức tạp (bảng hàng, map)** | 🟡 Trung | Desktop-first design, mobile là subset (hide cột, burger menu) |
| **File upload lớn (contract PDF, nhiều ảnh BDS)** | 🟢 Thấp | Chunk upload nếu cần. Mặc định browser OK dưới 50MB. |
| **Testing coverage với solo dev** | 🟠 Cao | Chỉ unit test logic quan trọng + E2E happy path. Không cần 80% coverage. |

### Concerns cần validate

1. **Session cookie cross-domain**: Next proxy giải được nếu deploy cùng domain. Nếu khác domain → cookie SameSite=None cần HTTPS + Secure flag.
2. **Rate limit BE Web2py**: nếu BE chặn request, Next proxy tận dụng queue/retry TanStack.
3. **Team permissions**: Agent có role (senior/junior, team leader) → FE cần middleware check permission từ `/me` response.

## Success Metrics

### Functional
- ✅ 36 màn MVP work đủ CRUD + flow
- ✅ Auth login-logout-otp complete, session persist
- ✅ Responsive desktop (1440+), tablet (768-1024), mobile (<768)
- ✅ Polling notification delay ≤30s

### Performance
- LCP < 2.5s trên 4G mobile
- FID < 100ms
- Bundle JS initial < 300KB gzipped
- API response time < 500ms p95 (tùy BE)

### Quality
- TypeScript strict, 0 `any`
- 0 critical bugs trên production sau 2 tuần
- E2E happy path pass

## Next Steps (Proposed plan)

### Phase 0: Research (2 tuần)
1. Reverse Dio calls trong `tongkhobds_agent/lib/services` → build API catalog
2. List endpoints cần: auth, bds, project, transaction, demand, contract, profile, notification, team, upload
3. Confirm với BE team về rate limit, session cookie format, file upload endpoint
4. Wireframe responsive cho 36 màn (dùng Figma hoặc shadcn/ui mockups)

### Phase 1: Foundation (3 tuần)
1. Setup Next 15 + TS + Tailwind v4 + shadcn/ui
2. Auth flow: login + OTP + middleware + Route Handler proxy
3. Layout shell: sidebar + topbar + notification badge + responsive
4. TanStack Query provider + Zustand stores
5. Docker build + Coolify deploy pipeline

### Phase 2: Core features (6 tuần)
1. BDS list + detail + favorite + my_product
2. Dự án + bảng hàng
3. Giao dịch + đặt cọc
4. Nhu cầu + khách hàng
5. Profile + team

### Phase 3: Secondary (3 tuần)
1. Hợp đồng + thư viện
2. Lịch hẹn
3. Create news (form multi-step + AI)
4. KYC upload
5. Notification

### Phase 4: Polish + Release (2 tuần)
1. Responsive tuning
2. Bug fix + UAT
3. E2E tests happy path
4. Docker production deploy
5. Monitoring setup

**Total**: ~16 tuần = 4 tháng (tight với 1 dev solo)

## Unresolved Questions

1. **BE team có support xây OpenAPI spec không?** Tiết kiệm 10-15 ngày research.
2. **BE Web2py có endpoint `/refresh-session` không?** Ảnh hưởng flow auth.
3. **File upload BE endpoint cụ thể** (size limit, multipart format, S3 presigned URL?).
4. **User roles/permissions**: Agent có bao nhiêu role? RBAC hay ABAC?
5. **Brand guideline**: shadcn theme color cần follow brand Tổng Kho BDS không? Logo, font chính?
6. **Analytics/Error tracking**: Sentry + GA4 như Flutter app, hay mới?
7. **Monorepo hay standalone repo?** Nếu monorepo với website V2 (Next) → share components, types.
8. **i18n**: chỉ Việt hay multi-lang?
9. **PWA installable** (add to home screen)? Agent có thể muốn install trên mobile như app.
10. **Phase 2 scope**: khi nào làm Wallet/Loan/Events/Chat? Có deadline?

## Decisions Log (Agreed)

| # | Topic | Decision |
|---|-------|----------|
| 1 | Framework | Next.js 15 App Router |
| 2 | UI lib | shadcn/ui + Tailwind v4 |
| 3 | Server state | TanStack Query v5 |
| 4 | Client state | Zustand |
| 5 | Form | React Hook Form + Zod |
| 6 | Table | TanStack Table |
| 7 | HTTP | ofetch |
| 8 | Auth | Session cookie (Web2py) + Next Route Handler proxy |
| 9 | Notification | Polling `/notifications` 30s via TanStack Query |
| 10 | Upload | File only, no camera/QR |
| 11 | Map | Embed webview (trade-off accepted) |
| 12 | Chat | Bỏ khỏi MVP |
| 13 | Scope MVP | ~36 màn (giữ Core + Hợp đồng + Đặt cọc, bỏ Wallet/Events/Chat/Rose) |
| 14 | Device | Responsive full |
| 15 | Timeline | 3-4 tháng (risk accepted by user) |
| 16 | Team | 1 FE dev solo (risk accepted) |
| 17 | Deploy | Docker standalone + Coolify/Dokploy |
| 18 | Test | Vitest + Playwright |
| 19 | Lint | Biome |

---

<a id="docs-02-api-catalog-md"></a>

## docs/02-api-catalog.md

---
title: API Catalog — Reverse từ Flutter Agent V1
type: researcher-report
date: 2026-04-17
source: C:\Data 2026\Dev\Tongkhobds\src\tongkhobds_agent\lib
scope: MVP endpoints (36 màn)
---

# API Catalog — Reverse từ Flutter Agent V1

## Executive Summary

**Total endpoints captured**: 127 endpoints
**API base domains**: 4 (apiHostReal, apiCommon, apiGlobal, apiCustomer)
**Auth mechanism**: Bearer token (Authorization header)
**Response format**: JSON with `{status, message, data}` shape
**Error handling**: status == 0 → error (transformed to DioException)

---

## 1. BE Setup & Configuration

### Base URLs
```
Domain: https://quanly.tongkhobds.com/tongkho
  - apiHostReal:   /api_agent (main endpoints)
  - apiCommon:     /api (shared, customer, KYC)
  - apiGlobal:     /api_global (webhook, rocket)
  - apiCustomer:   /api_customer (products, contracts, locations)
```

### Default Headers
```
accept: application/json
content-type: application/json
Connection: keep-alive
Keep-Alive: timeout=120, max=100
Cache-Control: no-cache
User-Agent: TongKhoApp/1.1.1 (Flutter)
```

### Auth Interceptor
- **Header**: `Authorization: Bearer <token>`
- **Token storage**: `LocalClient.accessToken` (likely SharedPreferences/SecureStorage)
- **Injection point**: Dio request interceptor (BaseClient)
- **Content-Type handling**: 
  - GET/DELETE → remove content-type
  - FormData → multipart/form-data
  - Otherwise → application/json

### Response Processing
- Raw JSON response parsed by interceptor
- Error check: if `response.data['status'] == 0` → reject with message
- HTTP 404 fallback: some endpoints have fallback URLs (e.g., product detail)

### HTTP Configuration
- Connect timeout: 30s
- Receive timeout: 30s
- Send timeout: 30s
- Keep-alive: 120s TTL, max 100 connections per host
- Max connections per host: 10
- Idle timeout: 2 minutes

---

## 2. Auth Endpoints

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| GET | `/api_agent/login` | Login user | `user_name`, `password` | `{token, user}` | MVP |
| GET | `/api_agent/login` | Login Google | `google_token` | `{token, user}` | MVP |
| GET | `/api_agent/login_otp.json` | Verify OTP | `phone`, `otp` | `{token, user}` | MVP |
| GET | `/api_agent/logout.json` | Logout | `equipment_token` (optional) | `{success}` | MVP |
| GET | `/api_agent/send_otp.json` | Send OTP | `phone`, `id_device` | `{otp_id, message}` | MVP |
| GET | `/api_agent/get_user_profile.json` | Get current user profile | — | `{user_profile}` | MVP |
| POST | `/api_agent/register.json` | Register new user | `{username, password, phone, ...}` | `{token, user}` | MVP |
| POST | `/api_agent/update_password.json` | Change password | `{old_password, new_password}` | `{success}` | MVP |
| POST | `/api_agent/create_new_password` | Create password (forgot flow) | `{new_password}` | `{success}` | MVP |
| POST | `/api_agent/verify_agent.json` | KYC upload (CCCD) | FormData: `{id_card, name, birthday, sex, address, id_day, citizen_id_front, citizen_id_back}` | `{kyc_status, message}` | MVP |
| GET | `/api_agent/check_account_authentication.json` | Check KYC verification status | — | `{verified, approval_status}` | MVP |

**Auth notes:**
- Login returns token + user object (stored in LocalClient)
- No explicit refresh endpoint found — session may be cookie-based or token TTL long
- KYC upload is multipart/form-data with 2 files
- Device ID generated via `AppUtil.getDeviceId()`

---

## 3. Home & Dashboard

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| GET | `/api_agent/home_config.json` | Fetch home page config (banners, featured) | — | `{banners, featured_bds, ...}` | MVP |
| GET | `/api_agent/home_blocks.json` | Fetch home blocks by city | `user_id`, `city_id`, `locations_slug`, `city` | `{blocks}` | MVP |
| GET | `/api_agent/dashboard_stats.json` | Dashboard stats (KPI) | `start_date`, `end_date` (YYYY-MM-DD, optional — BE defaults to MTD) | `{stats: {data: [{key, title, value, unit, change, icon}]}, transaction}`. Keys: `posted_news`, `caring_customers`, `deals_in_month`, `deposit_invoices`, `participating_projects`, `commission`. ✓ Wired 2026-05-19 via `useDashboardStats`. | MVP ✓ |
| GET | `/api/cities` | Fetch cities list | `limit` (default 7) | `{cities}` | MVP |

---

## 4. Real Estate / BDS Listings

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| GET | `/api_agent/real_estate_v2.json` | Search all products (main list) | `page`, `limit`, `sort`, `city_ids` (multi), `district_ids` (multi), `ward_ids` (multi), `street_names` (multi), `project_codes` (multi), `locations_slug` (CSV), `keyword`, `transaction_type`, `minPrice`, `maxPrice`, `minArea`, `maxArea`, `bedrooms`, `property_types`, `house_direction`, `balcony_direction`, `user_id` | `{items, total, page}` | MVP |
| GET | `/api_customer/property.json` | Product detail by slug or ID | `id`, `slug`, `user_id` | `{product_detail, gallery, seller}` | MVP |
| GET | `/api_customer/get_detail_real_estate.json` | Product detail (self-owned) | `real_estate_id`, `my_properties=true` | `{product, location, features}` | MVP |
| POST | `/real_estate_handle/save_real_estate.json` | Create/edit product (wizard) | `{title, address, price, area, property_type_id, images (JSON.stringify), video_url (JSON.stringify), legal_document_url, latlng, bedrooms, ...}` (single object) | `{product_id, status}` | MVP |
| POST | `/api_agent/save_real_estate.json` | Create/edit product (legacy) | `[{title, address, price, area, property_type, ...}]` (array wrap) | `{product_id, status}` | Legacy |
| POST | `/api_customer/unpublish_property.json` | Remove/unpublish product | `id` | `{success}` | MVP |
| GET | `/api_agent/get_list_real_estate.json` | My products list | `page`, `limit`, `search`, `source`, `sort`, `property_types`, `status_id`, `bedrooms`, `price_range`, `area_range` | `{items, total}` | MVP |
| GET | `/api_agent/compare_real_estate.json` | Compare 2 products | `id_1`, `id_2` | `{product_1, product_2, differences}` | MVP |
| POST | `/api_agent/add_to_favorite_group.json` | Add to favorite | `real_estate_id`, `group_id` | `{success}` | MVP |
| POST | `/api_agent/remove_from_favorite_group.json` | Remove from favorite | `{real_estate_id, group_id}` | `{success}` | MVP |
| POST | `/api_common/generate_real_estate_sample.json` | Generate product description AI | CreateContentAi payload | `{generated_description}` | MVP (Create news) |
| GET | `/api_common/get_ai_content_attributes.json` | Fetch AI content template | — | `{attributes}` | MVP |

**BDS notes:**
- `real_estate_v2.json` has complex filter params (pagination: page/limit standard)
- AI-generated content is POST, others mostly GET
- Favorite uses group-based organization

---

## 5. Projects (Dự án)

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| GET | `/api_customer/project_details.json` | Project detail | `id` | `{project, sub_projects, blocks}` | MVP |
| GET | `/api_agent/real_estate_sale_project.json` | Fetch all sale projects | — | `{projects}` | MVP |
| POST | `/api_agent/real_estate_sale_register.json` | Register for sale project | `{project_id, real_estate_sale_id=1}` | `{registration_status}` | MVP |
| GET | `/api_agent/apartment_status.json` | Fetch apartment status by subdivision | `project_code`, `zone_of_project` | `{apartments, status}` | MVP |
| GET | `/api_customer/real_estate_map.json` | Map data for project | `project_code`, `latlng`, `radius`, `limit`, `transaction_type` | `{locations, items}` | MVP |
| GET | `/api_customer/project_details_map.json` | Map data detail project | `id` | `{map_data}` | MVP |

---

## 6. Search & Location

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| GET | `/api_agent/locations.json` | Fetch locations hierarchy (2/3-tier) | `id`, `layer`, `grant` (2\|3) | `{data: [{id, name, code}]}` | MVP |
| GET | `/api_common/location_searching_by_province.json` | Search location by province/province/text | `text`, `lat`, `lng` | `{suggestions}` | MVP |
| GET | `/api_customer/location_searching.json` | Search location (customer side) | `text`, `city_id` | `{suggestions}` | MVP |
| GET | `/real_estate_handle/location_searching` | Unified autocomplete — projects + locations | `text`, `city_id` (optional) | `{data: [{type: 'project'\|'location', id, name, city_id?, n_level}]}` | MVP |
| GET | `/api_customer/search_districts.json` | Search districts | `id` (district ID) | `{districts}` | MVP |
| GET | `/api_agent/get_filter_config.json` | Fetch filter config for search | `transaction_type`, `city_id` | `{filters}` | MVP |
| GET | `/api/home_config.json` | Probes location system (new vs legacy) | — | `{new_locations: boolean, ...}` (optional flag) | MVP |
| GET | `/api_customer/real_estate_map.json` | Real estate map (search results) | `latlng`, `radius`, `limit`, `transaction_type`, `project_code` | `{items, bounds}` | MVP |
| GET | `/api_customer/property_map.json` | Single property map data | `id` | `{location, marker}` | MVP |

---

## 7. Favorites

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| GET | `/api_customer/list_favorite_groups` | List favorite groups | — | `{groups}` | MVP |
| POST | `/api_customer/create_favorite_group` | Create favorite group | `{title}` | `{group_id, name}` | MVP |
| POST | `/api_customer/update_favorite_group` | Update group name | `{title, id}` | `{success}` | MVP |
| POST | `/api_customer/delete_favorite_group` | Delete group | `{id}` | `{success}` | MVP |
| GET | `/api_agent/list_favorite_items_by_group` | List items in group | `group_id` | `{items}` | MVP |

---

## 8. Transactions (Giao dịch)

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| GET | `/api_agent/real_estate_transaction.json` | List transactions | `page`, `limit`, `type` (buy/sell), `search`, `status` | `{items, total, page}` | MVP |
| GET | `/api_agent/real_estate_transaction.json?id=X` | Transaction detail | `id` | `{transaction_detail}` | MVP |
| GET | `/api_agent/get_status_transaction.json` | Fetch transaction statuses | — | `{statuses}` | MVP |
| POST | `/api_agent/deposit_create.json` | Create deposit/booking | `{table_name, table_id, deposit_type, deposit_amount, customer_id}` | `{deposit_id, status}` | MVP |
| PUT | `/api_agent/deposit_update.json` | Update deposit (cancel/notes) | `{deposit_work_id, status, notes}` | `{success}` | MVP |
| GET | `/api_agent/get_deposit_works.json` | List deposits (optional status filter) | `status` (comma-sep), `page`, `limit` | `{items, total}` | MVP |
| GET | `/api_agent/deposit_detail.json` | Deposit detail | `deposit_work_id` | `{deposit_detail}` | MVP |
| GET | `/api_agent/get_booking_statuses.json` | Fetch booking/deposit statuses | `status_type` (1=booking) | `{statuses}` | MVP |
| GET | `/api_agent/get_group_status_deposit.json` | Fetch grouped deposit statuses | — | `{status_groups}` | MVP |
| POST | `/api_agent/real_estate_work.json` | Create work/transaction log | `{...transaction_work_data}` | `{work_id}` | MVP |
| POST | `/api_agent/update_real_work_status.json` | Update work status | `{work_id, status, noted}` | `{success}` | MVP |
| POST | `/api_agent/real_estate_work_comment.json` | Add comment to work | `{table_id, tablename, content_comment}` | `{comment_id}` | MVP |
| POST | `/api_agent/transaction_documents.json` | Upload transaction docs (FormData) | FormData | `{success}` | MVP |

**Transaction notes:**
- Deposits are distinct from transactions
- Work log has status updates
- Comments attached to work log

---

## 9. Demands (Consultation)

> Phase 1 shipped 2026-04-23. Phase 2 schema fix shipped 2026-04-24 (see `plans/260424-1112-nhu-cau-schema-fix-option-a/`). Namespace: `consultation`. FE types: `src/types/consultation.ts`. API client: `src/lib/api/consultation.ts`.
>
> **Deprecated Flutter endpoints** (kept for reference only — not used in web):
> `GET /api_agent/get_customer_demands.json`, `GET /api_agent/get_demand_detail.json/<id>`, `POST /api_agent/interest_in_property.json`

| Method | Path | Purpose | Request shape | Response shape | Status |
|--------|------|---------|--------------|----------------|--------|
| POST | `/api_agent/create_customer_demand` | Create consultation | `{customer_info, property_requirements, location_preferences, preferences, status_info, notification_settings}` | `{data: DemandShape}` | MVP |
| GET | `/api_agent/get_list_consultation` | List consultations (paginated) | query: `page`, `limit`, `status?`, `search?`, `office?`, `sales_off?`, `created_by?`, `start_date?`, `end_date?`, `city_id?`, `district_id?`, `ward_id?`, `or_and?`, `tag_id[]?` | `{data: {items: Demand[], total, page, limit}}` | MVP |
| GET | `/api_agent/get_detail_consultation/<id>` | Detail (tags + comments + bonus fields) | path: `id` | `{data: DemandDetail}` | MVP |
| PUT | `/api_agent/update_demand` | Update / close consultation | `{consultation_id, ...partial fields}` | `{data: DemandShape}` | MVP |
| GET | `/api_agent/get_status_demand` | Status tab counts | optional filters | `[{id, name, count}]` or `{data: [...]}` | MVP |
| GET | `/api_agent/demand_suggest.json` | Suggested BDS for consultation | params: `consultation_id`, `page`, `limit`, `sort?` | `{data: {total, properties[], consultation_info, applied_filters}}` | MVP |
| GET | `/api_agent/list_tags` | Tag groups + items for entity | optional query: `category_code` (default: 'DEMAND') | `[{id, name, selection_type?, items: [{id,name}]}]` | MVP |
| POST | `/tag_management/assign_tags_to_entity` | Attach tags to consultation (canonical) | `{entity_id, entity_type: 'consultation', tag_ids: number[]}` | `{success}` | MVP |
| GET/POST | `/api_agent/salesman_comments` | Comment timeline (GET) or add (POST) | GET: `table_id`, `tablename='consultation'`; POST: `{table_id, tablename, content, note_type?}` | `{data: Comment[]}` or `{data: Comment}` | MVP |

**Request/response notes:**
- All responses wrapped `{status: 1, data: T, message}`. FE unwraps via `unwrapData()` helper.
- `DemandShape` → merged flat + nested structure. Key fields: `id`, `status` (`new|active|in_transaction|completed|cancelled`), `customer_info`, `property_requirements` (nested: `budget_range`, `property_type_ids`, etc.), `location_preferences: SearchItem[]`.
- Bonus detail fields (Phase 2): `user_support`, `property`, `project`, `transaction_deposit`, `interests[]`, `works[]`, `post_office_*`, `consultation_code`, `demand_status_name: {name, color}`, `consultation_type`, `notification_schedule`, `matching_criteria`, `tag_id`, `stats: {priority_score, total_suggestions_sent, suggestions_today, last_matched, view_count, contact_count}`.
- Close shortcut: `PUT update_demand` with `{consultation_id, status_info: {demand_status: 'completed'}}`.
- `get_list_consultation` uses GET with query params (new multi-filter: `office`, `sales_off`, `created_by`, `start_date/end_date`, `city_id/district_id/ward_id`, `or_and`, `tag_id[]`).
- `list_tags` accepts optional `category_code` query param (default: `'DEMAND'`). **Note:** GET detail keys asymmetric with CREATE keys:
  - GET detail: `{push_enabled, sms_enabled, daily_limit}` (notification_settings response)
  - CREATE/UPDATE payload: `{enable_push_notification, enable_sms_notification, max_notifications_per_day}` (request)
  - FE helper `toCreateNotificationSettings()` auto-maps.
- `demand_suggest.json` response: single-level wrap `{data: {total, properties[], consultation_info, applied_filters}}`.
- Comments: `GET /api_agent/salesman_comments?table_id=X&tablename=consultation` (UNBLOCKED 2026-04-23, commit `3d15f3dc`); `POST /api_agent/salesman_comments` adds note with `{table_id, tablename: 'consultation', content, note_type?}`.
- Tag attach: `POST /tag_management/assign_tags_to_entity` (canonical path, Flutter-style `/api_agent/list_tags` also works) → send full `tag_ids[]` (replace semantics, not append).

---

## 10. Customers

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| GET | `/api_agent/get_list_customer.json` | List customers | `page`, `limit`, `search`, `xtype=0` | `{items, total}` | MVP |
| POST | `/api_agent/add_customer.json` | Add new customer | `{name, phone, email, address}` | `{customer_id}` | MVP |
| PUT | `/api_agent/customer.json` | Update customer | `{customer_id, name, phone, email, address}` | `{success}` | MVP |
| DELETE | `/api_agent/customer.json` | Delete customer | `customer_id` | `{success}` | MVP |
| GET | `/api_agent/get_list_customer_transaction.json` | List customer transactions | — | `{customers_with_transactions}` | MVP |
| GET | `/api_agent/get_list_transaction_by_customer.json` | Transactions by customer | `customer_id` | `{transactions}` | MVP |

---

## 11. Appointments (Lịch hẹn)

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| POST | `/api_agent/real_estate_appointment` | Create appointment | `{...appointment_data}` | `{appointment_id}` | MVP |
| PUT | `/api_agent/real_estate_appointment` | Update appointment | `{appointment_id, appointment_status, note}` | `{success}` | MVP |
| GET | `/api_agent/real_estate_appointment.json` | List appointments | `page`, `limit`, `status` (optional) | `{items, total}` | MVP |
| GET | `/api_agent/real_estate_appointment.json?id=X` | Appointment detail | `id` | `{appointment_detail}` | MVP |

---

## 12. Contracts (Hợp đồng)

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| GET | `/api_customer/contracts.json` | List user contracts | — | `{contracts}` | MVP |
| GET | `/api_agent/contract_content.json` | Fetch standard contract content | — | `{contract_html, terms}` | MVP |
| GET | `/api_customer/contract_content_by_id.json` | Get specific contract content | `contract_id` | `{contract_content}` | MVP |
| POST | `/api_agent/contract_create.json` | Create/sign contract | `{contract_type, signing_method, signed_at, signature_image, info_office}` | `{contract_id, status}` | MVP |
| POST | `/api_agent/contract_seller_create.json` | Create seller contract | `{signing_method, contract_type, real_estate_salesman_id, info_office}` | `{contract_id}` | MVP |
| POST | `/api_agent/contract_otp.json` | Request OTP for contract (POST) | `{phone, purpose=1, channel}` | `{otp_sent}` | MVP |
| PUT | `/api_agent/contract_otp.json` | Verify OTP for contract | `{phone, purpose=1, otp}` | `{verified}` | MVP |
| POST | `/api_agent/contract_agent.json` | Fetch contract template by office | `{info_office}` | `{contract_template}` | MVP |
| GET | `/api_agent/news_by_folder.json` | Contract library | `folder=thu-vien-hop-dong-agent`, `page`, `length`, `description`, `key` | `{contracts, total}` | MVP |
| GET | `/api_agent/news_by_id.json` | Contract library detail | `id` | `{contract_detail}` | MVP |

**Contract notes:**
- Signing method: 1 (in-person), 2 (digital signature)
- Purpose: 1 = contract, other TBD
- Channel: SMS, email, etc.
- Signature image: base64 or URL string

---

## 13. Profile (Hồ sơ)

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| GET | `/api_agent/get_user_profile.json` | Get current user profile | — | `{user_profile, role, permissions}` | MVP |
| POST | `/api_agent/update_profile.json` | Update user profile | `{email, phone, full_name, tax_code, city_id, district_id, ward_id, address, birthday, yoe}` | `{success}` | MVP |
| POST | `/api_agent/update_avatar.json` | Update avatar (FormData) | FormData with file | `{avatar_url}` | MVP |
| GET | `/api_agent/salesman_get_info.json` | Get referral info (self) | — | `{referral_code, ...}` | MVP |

---

## 14. Notifications

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| GET | `/api_agent/list_tmessage.json` | List notifications | `type`, `page`, `limit`, `app=agent` | `{items, total, unread_count}` | MVP |
| GET | `/api_agent/delete_tmessage.json` | Delete notification | `tmessageId` | `{success}` | MVP |
| GET | `/api_agent/set_read_tmessage.json` | Mark notification as read | `tmessageId`, `tmessageType` | `{success}` | MVP |
| GET | `/api_agent/set_read_all.json` | Mark all as read | `tmessageType` | `{success}` | MVP |
| POST | `/api_agent/denied_tmessage.json` | Deny/reject notification | `{...notification_action}` | `{success}` | MVP |

**Notification notes:**
- Types: numbered (e.g., type=1, 2, ...)
- Polling strategy: 30s refetch interval via TanStack Query recommended
- Unread count useful for badge

---

## 15. Uploads

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| POST | `/api_customer/upload_file.json` | Upload file (customer) | FormData | `{file_url, file_id}` | MVP |
| POST | `/api_agent/upload_file.json` | Upload file (agent) | FormData | `{file_url, file_id}` | MVP |
| POST | `/real_estate_handle/upload_file.json` | Upload real estate file | FormData | `{file_url}` | MVP |
| POST | `/api_agent/verify_agent.json` | Upload KYC docs | FormData: `citizen_id_front`, `citizen_id_back`, + metadata | `{verification_status}` | MVP |

**Upload notes:**
- FormData multipart/form-data
- No S3 presigned URL detected — direct upload to BE
- File size limit: likely standard browser limit (~50MB)

---

## 16. Miscellaneous (MVP scope)

| Method | Path | Purpose | Request | Response | Status |
|--------|------|---------|---------|----------|--------|
| GET | `/api_customer/get_property_types.json` | Fetch property types | `type` (buy/sell/rent) | `{property_types}` | MVP |
| GET | `/api_agent/get_list_type_search.json` | Fetch search type filter | — | `{search_types}` | MVP |
| GET | `/api/check_phone_register.json` | Check phone duplicate | `phone` | `{registered: true/false}` | MVP |
| GET | `/api_agent/checkPhoneRegister.json` | Check phone for registration | `phone` | `{available: true/false}` | MVP |
| GET | `/api_customer/get_property_type_fields.json` | Get fields for property type (wizard) | `property_type_id` | `{fields_array: {type, title, type_input, data_field}[]}` | MVP |
| GET | `/api_common/get_furniture.json` | Fetch furniture options | — | `{furniture_types}` | MVP |
| GET | `/api_agent/get_commission_default.json` | Calculate default commission | `city_id`, `district_id`, `ward_id`, `area`, `price`, `property_type` | `{min_commission, update_max_commission, update_commission, title, description}` | MVP |
| POST | `/api_common/generate_real_estate_sample.json` | Generate product description AI | `{title, price, property_type_id, transaction_type, description, bedrooms, bathrooms, floors, house_direction, balcony_direction, city, district, ward, street_address, legal_document_type, content, length, tone, use_ai}` | `{data: {...}, ai_generated: bool}` | MVP (Create wizard) |
| POST | `/api_customer/upload_file.json` | Upload file (wizard mode) | FormData: file (single, max 50MB) | `{data: string \| {url}}` ⚠️ heterogenous | MVP (Images, legal docs, video) |
| POST | `/api_agent/upload_file.json` | Upload signature (PNG bytes) | FormData: file bytes | `{file_url}` | MVP |
| GET | `/api_agent/news_by_folder.json` | Fetch news/content by folder | `folder` (home, lucky-program, etc.) | `{items}` | MVP |
| POST | `/api_common/calculate.json` | Calculate (form-related) | `{...calculation_params}` | `{result}` | MVP |
| GET | `/api_common/get_form_config.json` | Get form configuration | `type` | `{form_fields, validation}` | MVP |
| POST | `/api_common/get_legal_documents.json` | Fetch legal documents/project list | — | `{documents, projects}` | MVP |
| GET | `/api_agent/reconciliation_transactions_status.json` | Fetch reconciliation statuses | — | `{statuses}` | MVP |
| GET | `/api_agent/reconciliation_transactions.json` | Reconciliation transactions list | `agent_id`, `status`, `commission_type`, `period`, `limit`, `page` | `{transactions, summary}` | MVP |
| GET | `/api_agent/reconciliation_detail.json/<id>` | Reconciliation detail | path: `id` | `{reconciliation}` | MVP |
| GET | `/api_agent/reconciliation_summary.json/<id>` | Reconciliation summary stats | path: `id` | `{stats}` | MVP |
| PUT | `/api_agent/reconciliation_agent_confirm.json` | Confirm reconciliation | `reconciliation_id`, `action` (confirm), `notes` | `{success}` | MVP |
| GET | `/api_agent/get_reject_reasons.json` | Fetch rejection reasons | — | `{reasons}` | MVP |
| POST | `/api_agent/reject_real_estate_salesman.json` | Reject salesman | `{real_estate_salesman_id, reject_reason_id, note}` | `{success}` | MVP |
| GET | `/api_agent/real_estate_verification.json` | Real estate verification submit | `{...verification_data}` | `{status}` | MVP |
| GET | `/api_agent/api_activity_log` | Log activity (internal) | `{authUserId, systemName, app}` | `{logged}` | MVP |

---

## 3. Common Patterns

### Pagination
- **Standard**: `page`, `limit` (both required for most endpoints)
- **Example**: `/api_agent/real_estate_transaction.json?page=1&limit=20`
- **Response**: `{items: [], total: int, page: int}`

### Query Parameters
- URL-encoded GET params OR URI builder with `queryParameters` map
- Nullable/optional params filtered out before URL construction
- Comma-separated lists for multi-select (e.g., `district_id=1,2,3`)

### Filtering
- Search: `search` param (text matching)
- Status: `status` or `status_id` depending on endpoint
- Date range: `start_date`, `end_date` (ISO 8601 format)
- Price/area range: `minPrice`, `maxPrice`, `minArea`, `maxArea`
- Multi-select property types: comma-separated `property_types=1,2,3`

### Form Data
- Multipart/form-data for file uploads
- Key names: snake_case
- Multiple files in single FormData (e.g., `citizen_id_front`, `citizen_id_back`)

### Response Shape
```typescript
{
  status: 1,  // 0 = error, 1 = success
  message: string,
  data: T  // payload
}
```

### Error Responses
- `status: 0` triggers error interceptor
- `message` field contains error details
- HTTP 404 fallback for some product endpoints

---

## 5. TypeScript Type Hints

### User Profile
```typescript
interface UserProfile {
  authUserId: number;
  username: string;
  email?: string;
  phone: string;
  fullName: string;
  taxCode?: string;
  address?: string;
  cityId?: string;
  districtId?: string;
  wardId?: string;
  birthday?: string;  // ISO 8601
  yoe?: number;  // years of experience
  role: string;
  avatar?: string;
  verified: boolean;
}

interface AuthResponse {
  token: string;
  user: UserProfile;
}
```

### Real Estate / BDS Product
```typescript
interface Product {
  id: number;
  slug: string;
  title: string;
  address: string;
  price: number;
  area: number;
  bedrooms: number;
  bathrooms: number;
  direction?: string;
  balconyDirection?: string;
  propertyTypeId: number;
  userId?: number;
  status: string;
  createdAt: string;  // ISO 8601
  images: string[];
  featured?: boolean;
}

interface ProductDetail extends Product {
  description: string;
  features: string[];
  legalStatus?: string;
  seller: UserProfile;
}
```

### Transaction
```typescript
interface Transaction {
  id: number;
  realEstateId: number;
  buyerId: number;
  sellerId: number;
  type: 'buy' | 'sell';
  status: string;  // 'pending', 'completed', etc.
  createdAt: string;
  updatedAt: string;
}

interface Deposit {
  id: number;
  tableId: number;
  tableName: string;
  customerId: number;
  depositType: string;
  depositAmount: number;
  status: string;
  notes?: string;
  createdAt: string;
}
```

### Demand (Nhu cầu)
```typescript
interface Demand {
  id: number;
  customerId: number;
  title: string;
  description?: string;
  propertyType?: string;
  minPrice?: number;
  maxPrice?: number;
  minArea?: number;
  maxArea?: number;
  status: string;
  createdAt: string;
}
```

### Notification
```typescript
interface Notification {
  id: number;
  type: number;  // 1-N types
  title: string;
  message: string;
  read: boolean;
  createdAt: string;
  actionUrl?: string;
}
```

---

## 6. Gaps & Unresolved Questions

### Critical Unknowns

1. **Session/Token mechanism**
   - Is auth token stored in localStorage or SecureStorage?
   - Token TTL? Does BE use JWT or opaque token?
   - **Impact**: Next.js middleware session validation — need `/me` endpoint confirmation
   - **Status**: Found `get_user_profile.json` but unclear if it's for session check

2. **Refresh token flow**
   - No explicit `refresh_token` endpoint found in main API client
   - Session expiry handling unclear
   - **Impact**: How to handle 401 in Next.js proxy?
   - **Status**: May be handled by cookie TTL if session-based

3. **Upload endpoint specifics**
   - No S3 presigned URL pattern detected
   - Direct multipart upload to BE — what's max file size?
   - **Impact**: Large PDF contracts, multiple image uploads
   - **Status**: Assume browser default limit (~50MB) unless BE confirms

4. **Pagination edge cases**
   - Do all endpoints use `page=1, limit=20` standard?
   - Offset-based or cursor-based pagination?
   - **Status**: All scanned endpoints use page/limit

5. **Notification polling**
   - Type filtering: what are valid `type` values?
   - **Status**: Known types in code: 1-N (exact mapping unknown)

6. **Real estate map webview**
   - Is real_estate_map.json returned as embedded data or separate webview URL?
   - Mapbox API key in response?
   - **Status**: Likely returns lat/lng + marker data for Mapbox GL

7. **KYC workflow**
   - After verify_agent.json submit, what's polling endpoint for approval?
   - check_account_authentication.json returns status, but refresh frequency?
   - **Status**: Endpoint found, polling strategy TBD

8. **Commission calculation**
   - get_commission_default.json returns what exactly? Percent or amount?
   - **Status**: Likely percent (0-100)

9. **Work log comments**
   - Are comments nested in work details or separate fetch?
   - **Status**: Separate POST endpoint for creation

10. **Reconciliation flow**
    - agent_id vs current user context
    - commission_type: "buyer" hardcoded, why?
    - **Status**: Likely Agent has buyer-side commissions only

### Moderate Gaps

- Furniture endpoint returns (hardcoded list vs dynamic?)
- Filter config parameters (which combination is valid?)
- Property type fields validation rules
- Legal documents/project structure
- Team management endpoints (in scope? code suggests phase 2)
- Wallet/Loan endpoints (excluded MVP, but in code for reference)

### Scope Notes

**Excluded from this catalog** (Phase 2):
- Chat (project_chat, chat_with_admin, all_message, rocket_service)
- Events (fetch_event_list, create_ticket_booking, etc.)
- Wallet/Transactions (withdraw, deposit, get_cash_in/out)
- Loan endpoints
- Rose/Utilities
- QR scan, Camera

---

## 7. Recommendations for BE Coordination

### High Priority (confirm before FE coding)

1. **Session/Auth endpoint**
   - Confirm: Does `/me` or `/api_agent/get_user_profile.json` work for session validation?
   - Can Next.js middleware call it to check auth status?
   - Should Next.js set Authorization header on proxy route handler, or use cookies?

2. **Token refresh strategy**
   - If JWT: what's TTL, refresh endpoint?
   - If session cookie: what's TTL, SameSite policy?
   - **Action**: Provide or add refresh_token endpoint if using JWT

3. **Upload file size limits**
   - Max file size for KYC (CCCD)
   - Max file size for contract PDF
   - Max file size for property images
   - Total upload size limit per session?

4. **Rate limiting**
   - Are there rate limits per endpoint?
   - Retry strategy for failed requests?
   - Backoff timing?

5. **Error codes**
   - Standardize error response with `error_code` field
   - Example: `{status: 0, message: "...", error_code: "DUPLICATE_PHONE"}`
   - This helps FE handle specific errors differently (e.g., retry login vs show validation message)

### Medium Priority

6. **Pagination consistency**
   - Confirm all endpoints use `page` (1-indexed) and `limit`
   - Clarify total count vs total pages in response
   - Cursor-based pagination for large lists (transaction history)?

7. **Notification type mapping**
   - Document what each notification `type` means
   - Which types require polling vs push?

8. **KYC approval polling**
   - How often should FE check KYC status?
   - Webhook or polling interval?

9. **Property type fields**
   - Document structure returned by `get_property_type_fields`
   - Are fields dynamic per type or static?

10. **Legal document structure**
    - How nested is the legal documents response?
    - Pagination needed?

---

## 8. Endpoint Count by Module

| Module | Count | MVP? |
|--------|-------|------|
| Auth | 11 | ✅ |
| Home/Dashboard | 4 | ✅ |
| BDS/Products | 9 | ✅ |
| Projects | 6 | ✅ |
| Search/Location | 7 | ✅ |
| Favorites | 5 | ✅ |
| Transactions | 13 | ✅ |
| Demands (Consultation) | 9 | ✅ |
| Customers | 6 | ✅ |
| Appointments | 4 | ✅ |
| Contracts | 8 | ✅ |
| Profile | 4 | ✅ |
| Notifications | 5 | ✅ |
| Uploads | 4 | ✅ |
| Miscellaneous | 26 | ✅ |
| **Total MVP** | **127** | |
| **Excluded (Phase 2)** | ~40 | — |

---

## 9. Implementation Priority (Next Steps for FE)

### Phase 0: Foundation (Week 1)
- [ ] Create TypeScript types from this catalog
- [ ] Setup Next.js Route Handler proxy (`/api/[...path]/route.ts`)
- [ ] Setup TanStack Query client + Zustand stores
- [ ] Implement auth interceptor (Bearer token injection)
- [ ] Create ofetch wrapper with error handling

### Phase 1: Auth & Session (Week 2)
- [ ] Login endpoint integration
- [ ] OTP verification flow
- [ ] Token storage (localStorage vs cookie decision)
- [ ] Next.js middleware session check (using `/get_user_profile.json`)
- [ ] Logout + session cleanup
- [ ] **Blocking task**: Confirm BE response for `/get_user_profile.json` (role, permissions)

### Phase 2: Core APIs (Week 3-4)
- [ ] Real estate list/search (real_estate_v2.json)
- [ ] Product detail endpoints
- [ ] Favorites CRUD
- [ ] Transaction list/detail
- [ ] Deposit/booking flow
- [ ] Notifications polling setup
- [ ] **Blocking task**: Confirm notification `type` values

### Phase 3: Secondary (Week 5-6)
- [ ] Demand CRUD
- [ ] Customer management
- [ ] Appointment CRUD
- [ ] Contract workflows
- [ ] Profile updates
- [ ] **Blocking task**: KYC approval polling strategy

---

## Unresolved Questions Summary

1. **How does session persist?** (token in localStorage vs HTTP-only cookie?)
2. **Where is token/session validated?** (JWT endpoint vs opaque session API?)
3. **Does `/me` endpoint exist?** (or use `get_user_profile.json`?)
4. **What's token TTL?** (minutes? hours? days?)
5. **Refresh token endpoint?** (if JWT)
6. **Upload file size limits?** (all file types)
7. **Rate limit policy?** (per endpoint? global?)
8. **Notification type values?** (map of type numbers)
9. **KYC approval webhook?** (or polling interval?)
10. **Is real_estate_map geographic data?** (lat/lng for Mapbox GL JS?)

---

## 13. Team Management (Đội nhóm)

Added 2026-04-22 — plan `260421-1427-team-management-port`. 22 endpoints (14 core read · 3 tags · 4 tree · 1 user info). Read-only trừ `api_remove_tag_from_salesman` (POST form-urlencoded, Phase 2).

| Method | Path | Purpose | Query params | Status |
|--------|------|---------|--------------|--------|
| GET | `/api_team_overview` | Dashboard stats + title progress | `salesman_id` | MVP |
| GET | `/api_team_members` | Paged member list + search + tag | `salesman_id`, `page`, `limit`, `tree_type`, `search?`, `tag_id?` | MVP |
| GET | `/api_sub_members` | Descendants (depth limited) | `salesman_id`, `max_depth`, `include_self`, `tree_type` | MVP |
| GET | `/api_sub_members_lazy` | Lazy descendants | `salesman_id` | MVP |
| GET | `/api_member_detail` | Member profile + stats | `salesman_id` | MVP |
| GET | `/api_member_subordinates` | Direct subordinates | `salesman_id` | MVP |
| GET | `/api_member_transactions` | Member's transactions | `salesman_id` | MVP |
| GET | `/api_member_inventory` | Member's BDS inventory | `salesman_id` | MVP |
| GET | `/api_member_ctv_list` | CTV downline list | `salesman_id` | MVP |
| GET | `/api_member_activity_log` | Personal activity (7 ngày hardcoded) | `salesman_id` | MVP |
| GET | `/api_team_activity_log` | Team activity (7 ngày hardcoded) | `salesman_id` | MVP |
| GET | `/api_team_transactions` | Team transactions | `salesman_id` | MVP |
| GET | `/api_team_inventory` | Team BDS inventory | `salesman_id` | MVP |
| GET | `/api_my_tags_for_filter` | Tags cho filter | — | MVP |
| GET | `/api_salesman_tags` | Tags của 1 member | `salesman_id` | MVP |
| POST | `/api_remove_tag_from_salesman` | Remove tag (form-urlencoded) | body: `salesman_id`, `tag_id` | Phase 2 |
| GET | `/api_get_full_tree` | Referral tree (Vòng đời) | `salesman_id?`, `include_parents`, `max_parents` | MVP |
| GET | `/api_get_title_full_tree` | Title tree (Danh hiệu) | `salesman_id?`, `max_depth`, `include_parents`, `max_parents` | MVP |
| GET | `/api_get_member_tree` | Scoped tree (focus member) | `salesman_id`, `tree_type`, `max_depth` | MVP |
| GET | `/api_rebuild_tree_cache` | Rebuild server cache | `salesman_id` | MVP |
| GET | `/api_user_info` | User info team-scoped | `salesman_id?` | MVP |

**Response shape**: read endpoints return `{ data: { items: [...], total?, page?, total_pages? } }` hoặc `{ data: {...} }`. Defensive parse qua `normalizeList()` + `unwrap()` helpers ở `src/lib/api/team-management/normalize.ts`.

**Mock fields (chờ BE — xem plans/260421-1427-team-management-port/be-data-requests.md)**: `*_delta_percent` · `target_amount`, `gap_amount`, `current_title_key`, `measure_unit`. Grep `TODO(be-wire)` pre-prod.

---

**Report Generated**: 2026-04-17 (team section added 2026-04-22)
**Source Analysis**: 1,880 lines of Dart API client + plan 260421-1427
**Coverage**: 127 + 22 = 149 endpoints (MVP scope ~36 screens)
**Confidence Level**: High (direct code source)

---

## Cập nhật 2026-05-20 — Missing APIs (P1+P2)

- [API Hợp đồng trích thưởng](12-be-api-hop-dong-trich-thuong.md) — HĐ-1..8 (list BDS picker, has_exclusive, status counts, pagination, comments, PDF CORS, is_primary_ctv, notify owner)
- [API Khách hàng](13-be-api-khach-hang.md) — KH-1 list, KH-2 detail
- [API Dashboard · Rank · Notifications](14-be-api-dashboard-rank-notif.md) — DASH-1 verification dashboard, RANK-1 next rank gap, NOTIF-1 notifications

---

<a id="docs-03-be-questions-md"></a>

## docs/03-be-questions.md

---
title: "Câu hỏi BE team — clarification cho webapp Agent Next.js"
type: be-questions
date: 2026-04-17
status: answered
answered_at: 2026-04-17
audience: BE team (Python Web2py V1)
related:
  - plans/reports/brainstorm-260417-1435-webapp-agent-nextjs.md
  - plans/reports/researcher-260417-1502-api-catalog-flutter-reverse.md
---

# Câu hỏi BE team — Clarification cho FE webapp Agent

> Context: FE team đang build webapp Agent mới bằng Next.js 15 (thay app Flutter trên web). Đã reverse ~127 endpoints từ Flutter Dio. Dưới đây là các câu hỏi **blocking** để FE bắt đầu impl MVP.
>
> Vui lòng điền đáp vào cột **BE Response** hoặc dưới mỗi câu. Câu nào chưa có, đánh dấu "cần nghiên cứu".

---

## Priority 1 — Blocking FE kickoff (cần trả lời trong 1 tuần)

### Q1. Auth token — TTL + Refresh mechanism

**Context:** Flutter lưu Bearer token trong SecureStorage, gắn vào header `Authorization: Bearer <token>` qua Dio interceptor. Không thấy endpoint refresh trong source.

**Câu hỏi:**
- a) Token TTL hiện tại là bao nhiêu? (phút/giờ/ngày)
- b) Có endpoint refresh token không? Nếu có, path nào?
- c) Nếu không có refresh → khi token expire, Agent phải login lại hoàn toàn?
- d) Có policy sliding expiration (mỗi request gia hạn token)?

**BE Response:**
```
a) 24h
b) Chưa có
c) Login lại
d, Chưa có
```

---

### Q2. `/me` endpoint — session validation

**Context:** Next.js middleware cần check session hợp lệ mỗi request SSR. Cần endpoint nhẹ trả về user info hiện tại từ token.

**Câu hỏi:**
- a) Endpoint `get_user_profile.json` có phải validate token + trả user info? Hay chỉ trả profile data?
- b) Response shape cụ thể? (id, name, role, team_id, permissions?)
- c) Nếu token invalid, trả status code gì? (401? hay status=0 trong body 200?)
- d) Có endpoint nhẹ hơn chỉ check token valid (không load full profile)?

**BE Response:**
```
a, Có validate token + trả user info
b, App kỳ vọng JSON có wrapper data, và bên trong data là object map của user.
Các field app đang dùng trực tiếp trong UserModel gồm:
id
auth_user_name
email
phone
is_popup_support
username
is_password
token
expiration
issued_at
mem
salesman
first_name
last_name
image
full_name
city_name
city_id
district_name
district_id
yoe
citizen_id_front
citizen_id_back
birthday
address
sex
id_card
id_day
step
tax_code
contract_pdf
contract_verify
require_update
checking_staff
salesman_id
c, Status 401
d, Không có
```

---

### Q3. File upload — limits + format

**Context:** Flutter dùng multipart/form-data direct tới BE. FE web cũng cần biết giới hạn để validate client-side trước upload.

**Câu hỏi:**
- a) Max file size cho từng loại:
  - Ảnh BDS (JPG/PNG/WEBP): ___ MB
  - KYC CMND/CCCD: ___ MB
  - Contract PDF: ___ MB
  - Avatar: ___ MB
- b) Max tổng size 1 lần upload (multi-file ảnh BDS)?
- c) Format nào bị reject? (HEIC, TIFF, SVG, GIF?)
- d) Có endpoint nào dùng S3 presigned URL không? Hay 100% qua BE?
- e) Response upload trả về gì? (URL ảnh, file_id, hash?)

**BE Response:**
```
a, Max file size

Ảnh BDS (JPG/PNG/WEBP): 5 MB mỗi file.
KYC CMND/CCCD: k giới hạn, app tự nén ảnh rồi đẩy lên BE
Contract PDF: Luồng hiện tại chỉ lọc extension pdf, không thấy check dung lượng riêng
Avatar: 5 MB mỗi file

b) Max tổng size 1 lần upload multi-file ảnh BDS

Không giới hạn tổng size được enforce ở client.
Chỉ có giới hạn theo từng file 5 MB.

c, Format nào bị reject
Ở luồng BDS verify, app chấp nhận cả .jpg, .jpeg, .png, .webp, .heic, .heif
Với file picker cho legal doc, app chỉ cho chọn jpg/jpeg/png/pdf
Với avatar/KYC camera flow, client không thấy chặn theo extension kiểu đó

d) Có S3 presigned URL không

Không có luồng nào dùng presigned URL.
Các upload hiện tại đều đi qua backend

e) Response upload trả về gì

Không có một schema duy nhất.
App đang parse nhiều kiểu khác nhau:
response.data['url']
response.data['data']
response.data['message']
response.data['data']['url'] hoặc ['urls']
Với BDS verify còn có thể trả media_upload_id / media_upload_ids / id
```

---

### Q4. Rate limit policy

**Context:** FE dùng TanStack Query có thể gọi nhiều API song song (prefetch, polling notification 30s). Cần biết giới hạn để tune.

**Câu hỏi:**
- a) Có rate limit per token/per IP không?
- b) Nếu có: quota/minute? burst limit?
- c) Endpoint nào cần đặc biệt lưu ý (search, upload, notification)?
- d) Response khi bị rate limit (status code, body)?

**BE Response:**
```
a) Có rate limit per token/per IP không?

không xác nhận được từ app, đây có vẻ là luật của backend nếu có.
b) Nếu có: quota/minute? burst limit?

Không có
c) Endpoint nào cần đặc biệt lưu ý (search, upload, notification)?
Endpoint cần lưu ý nhất là search, upload, OTP/notification polling

d) Response khi bị rate limit (status code, body)?
Không có rate limit

```

---

### Q5. Notification — type mapping + polling interval

**Context:** FE bỏ push notification, dùng polling `useQuery(['notifications'], { refetchInterval: 30000 })`.

**Câu hỏi:**
- a) Liệt kê các `type` code của notification và ý nghĩa:
  - type=1: ___
  - type=2: ___
  - type=3: ___
  - (điền hết các giá trị hiện có)
- b) Endpoint nào dùng để polling cho count unread? (nhẹ, không load full list)
- c) Nên polling mỗi bao lâu để không stress BE? 30s có OK?
- d) Có cơ chế long-polling hay SSE không? (Nếu có, FE cân nhắc dùng thay cho polling)

**BE Response:**
```
a) type của notification

type=1: Giao dịch
type=2: Hệ thống

b) Endpoint polling cho count unread

Không thấy endpoint riêng, nhẹ, chỉ trả unread count.

c) Polling bao lâu cho hợp lý

Trong repo hiện tại không có polling tự động cho notification.

d) Có long-polling hoặc SSE không

Không thấy cơ chế long-polling hay SSE nào cho notification trong client.
Luồng hiện tại là request HTTP bình thường qua Dio.
Không có code stream/SSE riêng cho notification.
```

---

## Priority 2 — Cần trước khi impl module cụ thể (2-3 tuần)

### Q6. KYC approval flow

**Context:** Agent submit KYC → BE duyệt (bao lâu?). FE cần biết cách thông báo Agent khi được duyệt.

**Câu hỏi:**
- a) Workflow duyệt KYC: manual admin review hay auto (AI/3rd party)?
- b) Thời gian duyệt trung bình?
- c) Khi duyệt xong → BE push notification (qua endpoint notifications) hay FE phải polling status?
- d) Có webhook callback không?
- e) Endpoint check trạng thái KYC hiện tại của Agent?

**BE Response:**
```
a) Workflow duyệt KYC

FE gửi KYC bằng verify_agent.json, sau đó chờ trạng thái step từ BE.
Khi step == 2, app hiển thị trạng thái “chờ duyệt”; khi step == 3 thì coi là đã duyệt.
UserModel còn có field checking_staff, đây cũng là tín hiệu BE đang xử lý bởi staff.
Xem api_client.dart, kyc_doc_info_page.dart, user_model.dart
b) Thời gian duyệt trung bình

Không thấy số liệu SLA nào trong code.
FE chỉ thể hiện trạng thái chờ duyệt, không có logic đo thời gian trung bình.
c) Duyệt xong thì push hay FE polling

Trong client hiện tại, không thấy cơ chế push riêng cho KYC duyệt xong.
FE đang dựa vào:
check_account_authentication.json
get_user_profile.json
Sau submit KYC, app gọi lại getMyProfile() để refresh step.
Nếu backend đổi trạng thái, FE chỉ biết khi:
người dùng mở lại màn
hoặc FE gọi check lại profile/status
d) Có webhook callback không

Không thấy webhook callback nào trong code.
Không có endpoint hay listener nào thể hiện BE callback ngược về app.
Nếu có webhook thì phải nằm ở backend.
e) Endpoint check trạng thái KYC hiện tại của Agent

Endpoint chính mà FE đang dùng là:
GET /api_agent/check_account_authentication.json
Ngoài ra FE cũng refresh từ:
GET /api_agent/get_user_profile.json
```

---

### Q7. Map data — Mapbox GL format

**Context:** Brainstorm chốt dùng webview map như Flutter. Nhưng vẫn cần biết data format để cluster/filter.

**Câu hỏi:**
- a) Endpoint `real_estate_map` trả về gì? GeoJSON? Array lat/lng?
- b) Có bounding box filter không? (NE lat/lng + SW lat/lng)
- c) Cluster làm ở BE hay FE? (nếu FE → cần toàn bộ points trong bbox)
- d) Max points trả về trong 1 request?
- e) Cache CDN cho map tiles (nếu BE proxy tiles)?

**BE Response:**
```
a) Endpoint real_estate_map trả về gì?

Không phải GeoJSON.
FE đang parse response dạng wrapper data chứa:
properties: array các point/list item
total, count, page, limit, total_pages
Mỗi item của properties trong map chính có:
id
slug
price_description
lat
long
expired
real_estate_count
project_code

b) Có bounding box filter không?

Không thấy FE gửi NE/SW lat/lng.
FE chỉ gửi latlng=lat,lng + radius.
Radius được tự tính từ getVisibleRegion()

c) Cluster làm ở BE hay FE?

Không thấy code cluster ở FE.
FE chỉ lấy list point rồi tạo Marker từng item, mỗi marker có label icon riêng

d) Max points trả về trong 1 request?

FE đang request limit=50 cho map chính.
Với project preview, FE dùng limit=20

giới hạn thực tế là do backend quyết định, còn client đang yêu cầu tối đa 50 điểm cho viewport map chính.

e) Cache CDN cho map tiles

Không thấy BE proxy tile hay cơ chế cache tile trong repo FE.
App dùng google_maps_flutter, tức tile hiển thị là qua Google Maps SDK, không đi qua API tile riêng của BE trong code này.
```

---

### Q8. Commission type — reconciliation hardcoded "buyer"

**Context:** Trong reverse từ Flutter, `transaction_reconciliation` có field `commission_type = "buyer"` hardcoded.

**Câu hỏi:**
- a) Tại sao hardcoded "buyer"?
- b) Có các commission_type khác không? ("seller", "both"?)
- c) Logic nghiệp vụ hoa hồng đối soát: ai trả, bên nào nhận?
- d) FE nên expose field này cho user chọn, hay giữ hardcoded?

**BE Response:**
```
a) Tại sao hardcoded buyer?

Vì hàm getTransactionsByStatus(...) đang fix cứng query commission_type=buyer
b) Có các commission_type khác không?

Có:
buyer
seller
shared

c) Logic nghiệp vụ hoa hồng đối soát: ai trả, bên nào nhận?
bên nào tax_bearer thì là bên chịu phần hoa hồng đó
shared là chia theo thỏa thuận

d) FE nên expose field này cho user chọn, hay giữ hardcoded?

Với code hiện tại, nghiêng về:
giữ hardcoded nếu màn đó chỉ phục vụ đúng một nghiệp vụ cố định
expose choice nếu BE thực sự hỗ trợ nhiều loại đối soát

```

---

### Q9. Session revoke + multi-device login

**Context:** Agent có thể login cùng lúc trên app + web. Cần biết policy.

**Câu hỏi:**
- a) Allow multi-device login không?
- b) Nếu có: hiển thị list device đang login để user logout từ xa?
- c) Logout từ 1 device có logout hết không?
- d) Endpoint `/logout` invalidate token ở BE hay chỉ xoá local?

**BE Response:**
```
a) Allow multi-device login không?

Không thấy bất kỳ cơ chế “single session” nào ở FE.

b) Nếu có: hiển thị list device đang login để user logout từ xa?

Không thấy.
Không tìm thấy màn hay endpoint nào để liệt kê các device/session đang đăng nhập.
Không có UI quản lý session từ xa trong app.

c) Logout từ 1 device có logout hết không?

Theo FE, không.

- d) Endpoint `/logout` invalidate token ở BE hay chỉ xoá local?

/logout: FE dùng để remove equipment_token/FCM token, còn access token chỉ xoá local
```

---

### Q10. Team permissions + role

**Context:** FE cần hide/show menu theo role. Agent có các role: senior, junior, team leader?

**Câu hỏi:**
- a) Liệt kê các role Agent hiện có:
  - role=1: ___
  - role=2: ___
  - ...
- b) Permission model: RBAC (role-based) hay ABAC (attribute-based)?
- c) Permission được trả về trong `/me` response không? Shape nào? (`permissions: string[]` hay `role: string`?)
- d) Team leader có permission riêng (xem team_management, duyệt KYC member)?
- e) FE có cần check permission từng action hay BE tự reject?

**BE Response:**
```
a) Các role Agent hiện có

FE chỉ thấy các tín hiệu sau:
UserModel.step
UserModel.checkingStaff
UserModel.salesmanId
UserModel.salesman.salesmanType

Từ client hiện tại không thể liệt kê chính xác role=1, role=2

b) Permission model: RBAC hay ABAC?

Thực tế đang là:
một số màn/feature được bật theo trạng thái hồ sơ như step == 3 hoặc checkingStaff == true
còn phần authorize thật sự vẫn phải do BE chặn

c) Permission có trả trong /me response không?

Trong /me hiện tại, client map vào UserModel:
step
checking_staff
salesman_id
nested salesman
Không thấy permissions: string[] trong model /me.

d) Team leader có permission riêng (xem team_management, duyệt KYC member)?

Nếu có quyền team leader, hiện nó đang là backend-driven, không thấy FE enforce riêng

e) FE có cần check permission từng action hay BE tự reject?

Hiện tại FE không check permission từng action một cách hệ thống.
FE chỉ chặn một số trường hợp bằng state/feature flag đơn giản.
```

---

## Các điểm cần BE xem xét cải thiện (nice-to-have, không blocking)

### R1. OpenAPI spec
Sẽ giảm effort FE ~10-15 ngày nếu có. Có thể tool auto-generate từ Web2py routes không? (web2py-swagger, pyswagger...)

### R2. Endpoint `/me` lightweight
Nếu `get_user_profile.json` load toàn bộ profile + team + rank → nặng để gọi mỗi request SSR. Cần version nhẹ chỉ trả `{id, name, role, avatar}`.

### R3. Refresh token
Nếu hiện không có → cân nhắc bổ sung. Giảm friction UX (token hết hạn giữa phiên phải login lại = bad UX).

### R4. Standardize response shape
Hiện `{status, message, data}` với `status=0` = error. Cân nhắc chuyển sang HTTP standard code (200 OK / 4xx error) để FE + tooling (Axios/ofetch) handle tự nhiên hơn.

### R5. Pagination metadata
Trả thêm `total_count`, `has_next` trong response để FE không phải đoán pagination hết chưa.

---

## Questions summary table

| # | Priority | Topic | Blocking? |
|---|----------|-------|-----------|
| Q1 | P1 | Token TTL + Refresh | ✅ Yes |
| Q2 | P1 | `/me` endpoint | ✅ Yes |
| Q3 | P1 | Upload limits | ✅ Yes |
| Q4 | P1 | Rate limit | ⚠️ Phase-blocking |
| Q5 | P1 | Notification types | ⚠️ Module-blocking |
| Q6 | P2 | KYC approval flow | ⚠️ Module-blocking |
| Q7 | P2 | Map data format | ⚠️ Module-blocking |
| Q8 | P2 | Commission type | ⚠️ Module-blocking |
| Q9 | P2 | Session policy | 🟢 Nice to know |
| Q10 | P2 | Roles + permissions | ✅ Yes (RBAC menu) |

---

## Deadline mong đợi

- **Priority 1 (Q1-Q5)**: trong vòng **1 tuần** (trước 2026-04-24) để FE kickoff foundation.
- **Priority 2 (Q6-Q10)**: trước khi bắt đầu module tương ứng (~4 tuần).

## Liên hệ

FE lead: [điền tên/Slack]
BE lead: [điền tên/Slack]

---

## FE decisions — workaround cho BE gaps

> Brainstorm 2026-04-17 chốt FE tự workaround để kickoff đúng deadline. Chi tiết: [brainstorm-260417-1558-be-gap-workaround.md](../plans/reports/brainstorm-260417-1558-be-gap-workaround.md)

| # | Gap | FE workaround |
|---|---|---|
| Q3(e) | Upload response 5 biến thể | Adapter per-endpoint (`lib/api/upload/upload-<type>.ts`) |
| Q5(b) | Không có unread count | Polling 60s + event-driven refresh + client-side `lastReadAt` |
| Q10(c) | Không có role/permissions[] | Capability map hardcode (`lib/auth/capabilities.ts`) infer từ `step`+`salesmanType` |
| Q7 | Flutter google_maps_flutter | Google Maps JS API (`@vis.gl/react-google-maps`) + `@googlemaps/markerclusterer` |
| Q7(b) | Chỉ radius, không bbox | `radius = viewport_diagonal / 2` (over-fetch 30%, full coverage) |
| Q6(c) | Không push KYC approved | Global polling 5 phút khi `step == 2`, toast khi 2→3 |
| Q3(a) | PDF không size limit | FE reject > 10 MB |
| Q3(a,b) | Image > 5MB | Reject client-side, không compress (phase 2 revisit) |
| Q3(c) | HEIC browser không render | Deferred — decide khi impl BDS upload |
| Q4 | Rate limit mâu thuẫn | TanStack retry exp backoff + search debounce 500ms + polling throttle 30s min |

## Backlog asks gửi BE (post-kickoff)

| # | Request | Priority | Unblocks |
|---|---|---|---|
| B1 | Standardize upload response `{id, url, urls[]}` | High | Remove 5 adapters |
| B2 | `/me` thêm `capabilities[]` hoặc `/me/capabilities` endpoint | High | RBAC robust |
| B3 | `/notifications/unread_count` endpoint | Medium | Giảm polling traffic 80% |
| B4 | Map bbox filter (`ne_lat/lng`, `sw_lat/lng`) | Medium | Viewport chính xác |
| B5 | KYC approved → notification type mới | Low | Remove 5min polling |
| B6 | PDF size limit + extension check BE-side | Low | Security hardening |
| B7 | Confirm rate limit policy với DevOps | Low | Tune backoff config |
| B8 | Refresh token endpoint | Medium | Remove 24h login friction |

## Priority 3 — 2-cấp/3-cấp Location Filter (2026-04-22)

Related plan: `plans/260422-1637-bds-filter-2tier-3tier-impl/`.

### Q11. Unified `fetchLocations()` with `grant` parameter

**Context:** FE shipped multi-select location picker supporting 2-cấp (provinces + wards, no districts) and 3-cấp (full hierarchy). Need BE confirm for location endpoint.

**Câu hỏi:**
- a) Endpoint `/api_agent/locations.json?id={id}&grant=2|3&layer=?` — confirm `grant=2` (2-cấp) vs `grant=3` (3-cấp)?
- b) When `grant=2` + `id={provinceId}`: returns `wards[]` directly or still nested? 
- c) `layer` param: currently FE ignore BE-side. Is it OK to omit?

**FE-resolved (2026-04-22):** Shipped. Response shape: `{data: [{id, name, code, ...}]}`. FE uses `grant` to toggle between 2-tier (city → ward) and 3-tier (city → district → ward).

---

### Q12. Autocomplete endpoint `fetchLocationSearching()`

**Context:** `GET /real_estate_handle/location_searching?text=&city_id=`

**Câu hỏi:**
- a) Response shape — sample JSON with `type: 'project' | 'location'` discriminator?
- b) When gated by `city_id` (vs empty): does global search across all provinces work?
- c) Per-item: include `city_id / district_id / ward_id` for direct filter application?
- d) `n_level` field mapping to 2-cấp vs 3-cấp?

**FE-resolved (2026-04-22):** Shipped. Response: `{type: 'project'|'location', id, name, city_id?, district_id?, ward_id?, n_level}`. FE filters based on user's 2-tier vs 3-tier selection.

---

### Q13. `/home_config.json` — location system detection

**Context:** FE probes `GET /api/home_config.json` to check if backend supports new locations API (default assume yes if 404).

**Câu hỏi:**
- a) Endpoint path chính xác: `/api/home_config.json`?
- b) Response shape: has field `{new_locations: true}` để flag new system?
- c) Cache-control: how often FE should refetch (page load vs every session)?

**FE-resolved (2026-04-22):** Shipped. FE probes `/api/home_config.json`; if `new_locations: true`, use unified API. Fallback (404 or missing field) → assume true (new system).

---

### Q14. Commission validation — `get_commission_default.json` with 2-cấp mode

**Context:** Shipping 2-cấp creates case where `district_id` is empty or missing. BE validates `district_id` required (from Q5 findings).

**Câu hỏi:**
- a) In 2-cấp mode: can `district_id` param be **empty string** or **omitted entirely**?
- b) Or does BE need new `is_2_tier` flag to relax validation?
- c) Current: FE workaround = `district_id = ward_id` (hack, console.warn logged). Should BE support explicitly?

**FE workaround (2026-04-22):** FE hack at submission — `district_id` set to `ward_id` when 2-cấp. Tracked as tech debt. **Needs BE clarification** to support proper 2-tier semantics.

---

## Priority 4 — Consultation (2026-04-23)

Related plan: `plans/260423-1217-nhu-cau-consultation-phase-1/`. Phase 1 shipped — 7 phases, 9 endpoints wired.

### Q15. Tag attach endpoint path

**Context:** FE wired `POST /tag_management/assign_tags_to_entity` based on Flutter reverse. But `list_tags` lives under `/api_agent/list_tags`. Mismatch in controller namespace.

**Câu hỏi:** Endpoint chính xác để attach tags cho entity `consultation` là:
- a) `POST /tag_management/assign_tags_to_entity`?
- b) `POST /api_agent/list_tags` (same endpoint, different method)?
- c) Một path khác?

**BE Response:** _Chờ_

---

### Q16. `RealEstateComment.allowed_tables` — thêm `'consultation'`

**Context:** FE gửi `entity_type: 'consultation'` cho comment endpoint. Nếu BE validate `allowed_tables` whitelist, `consultation` cần được thêm vào.

**Câu hỏi:** BE có cần update `allowed_tables` (hoặc tương đương) để accept `entity_type='consultation'` không? Hiện tại có bị reject không?

**BE Response (2026-04-23):** ✅ RESOLVED — `allowed_tables` whitelist updated to include `'consultation'` (commit `3d15f3dc`, 2026-04-23). FE `GET /api_agent/salesman_comments?table_id=X&tablename=consultation` and `POST` now working.

---

### Q17. Comment endpoint path — `salesman_comments` vs `real_estate_comment` vs `add_work_comment`

**Context:** FE hiện dùng `GET /api_agent/salesman_comments` để fetch timeline và `POST /api_agent/salesman_comments` để add. Nhưng catalog cũ liệt kê `real_estate_work_comment.json`. Cần confirm path đúng cho consultation entity.

**FE Implementation (2026-04-23):** Both GET + POST use unified endpoint:
- a) ✅ Fetch comments: `GET /api_agent/salesman_comments?table_id=X&tablename=consultation`
- b) ✅ Add comment: `POST /api_agent/salesman_comments`
- c) ✅ Request body shape cho add: `{table_id, tablename: 'consultation', content, note_type?}`

**Confirmation:** BE confirms `allowed_tables` whitelist includes `'consultation'` (Q16 pending)

---

### Q18. Role label field trên user response

**Context:** `inferRole()` FE infer từ `checking_staff`, `salesman_type`, `auth_group`. Không có field label trực tiếp.

**Câu hỏi:** BE có thể expose `role_label: 'KH'|'CTV'|'TP'|'GDK'` trong `get_user_profile.json` response không? Giảm logic infer phức tạp ở FE.

**BE Response:** _Chờ_

---

### Q19. Tag group `selection_type` field

**Context:** FE muốn distinguish single-select tag groups (radio) vs multi-select (checkbox) khi hiển thị tag picker.

**Câu hỏi:** `GET /api_agent/list_tags` response có thể thêm `selection_type: 'single'|'multi'` vào mỗi group object không? Hiện tại FE fallback multi cho tất cả.

**BE Response:** _Chờ_

---

### Q20. Comment `is_pinned` field

**Context:** FE comment timeline có placeholder cho pin functionality (sticky note UI).

**Câu hỏi:** Comment object có field `is_pinned: boolean` không? Nếu có, `add_work_comment` endpoint có accept `is_pinned` param không?

**BE Response:** _Chờ_

---

## Priority 4 — Nhu Cầu × Working BDS section (2026-05-06)

Related plan: `plans/260506-0811-nhu-cau-mua-working-bds-section/`. Phase 1 shipped (5 phases, mock localStorage). Section tracks selected BDS per consultation + 4 actions (verify/appt/task/deposit) + group-by-broker toggle.

### Q21. Pivot table `consultation_property` contract

**Context:** FE Phase 1 mocks working BDS list în localStorage. Need BE contract for Phase 2 (persistent API).

**Câu hỏi:**
- a) Có table/endpoint `consultation_property` (pivot giữa consultation × real_estate) không?
- b) Nếu có: list/add/remove endpoint path + schema (id, consultation_id, real_estate_id, status, created_at)?
- c) Nếu không: FE có thể infer từ `interest_in_property` + `real_estate_appointment` + `deposit_work` joined by consultation_id không?

**BE Response:** _Chờ_

---

### Q22. `demand_suggest.json` — thêm field `owner` per item

**Context:** FE section group BDS theo "đầu chủ" (salesman owner). Hiện `demand_suggest.json` không trả owner info.

**Câu hỏi:**
- a) Per suggested item, thêm nested object `owner: {id, name, phone, avatar, office_name}`?
- b) Nếu không thêm: FE có thể merge từ `real_estate_v2` lookup per item không? (phức tạp)

**BE Response:** _Chờ_

---

### Q23. Endpoint "Yêu cầu xác thực BDS"

**Context:** FE card status `pending_verify` → primary action "Yêu cầu xác thực". Chưa tìm thấy endpoint riêng.

**Câu hỏi:**
- a) Endpoint path + method nào?
- b) Input shape: `{real_estate_id, consultation_id, ...}`?
- c) Trigger gì ở BE? (notification → owner? auto-create work?)
- d) Hay reuse work creation + auto-tag `verify_request`?

**BE Response:** _Chờ_

---

### Q24. "Bỏ khỏi list" action — soft delete vs history

**Context:** FE kebab menu "Bỏ khỏi list" xoá BDS từ working list.

**Câu hỏi:**
- a) Soft delete (mark `is_deleted=true`) hay hard delete record?
- b) Có history audit không?
- c) Endpoint path?

**BE Response:** _Chờ_

---

### Q25. Status mapping — `pending_verify` · `interested` · `appointment` · `deposit`

**Context:** FE infer 4 statuses từ related records. Cần confirm mapping.

**Câu hỏi:**
- a) `pending_verify`: có field `is_verified=false` trong `real_estate`? Hay check `verify_request` record pending?
- b) `interested`: field `is_interested=true` hay join `interest_in_property`?
- c) `appointment`: join `real_estate_appointment` where `status != 'cancelled'`?
- d) `deposit`: join `deposit_work` where `status != 'cancelled'`?

**BE Response:** _Chờ_

---

### Q26. Group "BDS của tôi" — ownership definition

**Context:** FE pinned group "BDS của tôi" khi `owner.id == current_user.salesman_id`.

**Câu hỏi:**
- a) "Đầu chủ" = field `salesman_id` (owner khi post)? Hay `created_by`?
- b) Cách nào để FE phân biệt "BDS của tôi"?

**BE Response:** _Chờ_

---

## Unresolved questions

- Google Maps API key: FE dùng key mới hay share key BE? (cần ops confirm)
- `salesman.salesmanType` giá trị exact cho team leader? (cần BE gửi sample data)
- HEIC strategy defer đến khi impl BDS upload module
- **[NEW 2026-04-23]** Q14 — Commission validation: BE should relax `district_id` requirement OR add `is_2_tier` flag for 2-cấp mode
- **[NEW 2026-04-23]** Q13 — Confirm `/api/home_config.json` endpoint path + response shape with `new_locations` field
- **[NEW 2026-05-06 Priority 4]** Q21-Q26 — Nhu Cầu × Working BDS section: pivot table contract + owner field + verify endpoint + status mapping

---

## Location Search APIs (2026-04-20)

Related plan: `plans/260420-1326-address-search-bds-filter/`.

### Q. `GET /api_common/location_searching_by_province.json?text=`

- Gọi với `text=""` có trả full 63 tỉnh không, hay bắt buộc phải có text?
- Response shape: flat array, `{data: [...]}`, hay `{suggestions: [...]}`?
- Item shape: chỉ `{id, name}` hay kèm `type` (province/district) để phân biệt?

### Q. `GET /api_customer/search_districts.json?id=<X>`

- `id` param là `city_id` (province id) hay `district_id`? Catalog label mơ hồ.
- Có filter theo `text` không hay luôn trả full list huyện của tỉnh?
- Item shape: `{id, name, city_id}` đủ không?

### Q. Ward (xã) search — defer phase 2

- Có endpoint `search_wards.json?city_id=&district_id=&text=` không? Nếu chưa, BE plan add khi nào?
- `real_estate_v2.json` có thể thêm `ward_id` vào filter param không?

---

## Location Multi-Select + Unified Dropdown (2026-04-20 16:45)

Related plan: `plans/260420-1530-address-search-unified-dropdown/`.

### Q1. `GET /real_estate_handle/location_searching?city_id=&text=&limit=10`

User confirmed endpoint exists. Cần clarify:
- Response shape — paste sample JSON.
- Per-item có kèm `city_id / district_id / ward_id` để FE apply filter trực tiếp không?
- Gọi không `city_id` (global search cả VN) có work không?
- Có hỗ trợ `limit`, `page` không?

### Q2. Multi-select address filter trên `real_estate_v2.json`

FE đã chốt multi-select (mixed levels). Cần BE support:
- `city_id` → `city_ids` (comma-separated `1,2,3`) — accept chưa?
- `district_id` → `district_ids` comma-separated — accept chưa?
- `ward_id` / `ward_ids` — thêm mới cho MVP phase 2.
- Semantic: OR within level, AND across levels (giống `property_types=1,2,3` hiện có).

### Q3. Ward hierarchy endpoint

- `/api_agent/locations.json?id=<districtId>&layer=2&grant=1` có trả wards của district không?
- Với 2-cấp mode (bỏ huyện): `layer=?` để trả wards theo city_id (flat, không qua district)?

### Q4. 2-cấp (VN admin reform) submission

- Khi user toggle "2 cấp": FE gửi `city_ids + ward_ids` (bỏ `district_ids`) — BE có accept?
- Có cần flag `is_2_tier=1` để BE switch logic không?

### Q5. Hot cities ranking

- BE có endpoint trả "top cities by listing count" không? (Hoặc FE hardcode HN/HCM/ĐN/HP/CT/NA.)
- `/api/cities?limit=6&sort=popular` khả thi không?

---

## Priority 3 (added 2026-04-21) — Create BDS wizard V2

> Context: FE đang refactor wizard tạo tin đăng theo Flutter pattern (4 step: Thông tin BĐS → Hình ảnh → Xem lại → Hoa hồng). Brainstorm context: chat session 2026-04-21 1138.
> Reference Flutter source: `tongkhobds_agent/lib/features/create_news/`.

### Q1. `get_property_type_fields.json` — formGuide động cho Step 1 "Mô tả thêm"

**Context:** Flutter gọi `apiClient.getPropertyTypeFields(id: property_type_id)` → response `data.data` parse vào `GiuFormModel.fieldsArray`. Mỗi item có `{type, title, ...}`. FE render field tương ứng theo `type` (counter, picker, number-with-unit, text).

**Câu hỏi:**
- a) Endpoint chính xác: `/api_customer/get_property_type_fields.json?property_type_id={id}` — FE verify 2026-04-24: param `property_type_id` (không phải `id`), truyền `?id=X` trả 400 "invalid arguments".
- b) **Sample JSON response** cho 2-3 loại BĐS phổ biến (vd: nhà phố, căn hộ, đất nền) — FE cần shape thật để type chính xác.
- c) `fieldsArray` có cố định thứ tự render không, hay FE tự sort?
- d) Có field nào REQUIRED bắt buộc theo loại BĐS không, hay FE tự decide?
- e) Danh sách `type` đầy đủ FE đang biết: `bedrooms, bathrooms, num_of_floors, floors, floor_block, legal_document_type, house_direction, balcony_direction, land_direction, interior, frontage, road_width, ceiling_height, door_size, access_door_size, management_fee, residential_agricultural_ratio, building_density, construction_area, campus_area, business_type, zone_of_project` — còn type nào khác không?

**BE Response (2026-04-21, partial):**
```
- Các trường được load động dựa trên loại bất động sản
- Ví dụ: số phòng ngủ, phòng tắm, số tầng, hướng nhà, nội thất
- Mỗi field có type riêng: text, number, dropdown
- Unlock Section 5 khi hoàn thành
```

**BE Response (2026-04-21, sample JSON for property_type_id=13 "Bán chung cư mini, căn hộ dịch vụ"):**
```json
{
  "status": 1,
  "data": {
    "id": 13,
    "title": "Bán chung cư mini, căn hộ dịch vụ",
    "fields_array": [
      { "title": "Tầng/Block", "type": "floor_block" },
      { "title": "Nội thất", "type": "interior", "type_input": "text",
        "data_field": ["Đầy đủ", "Cơ bản", "Không nội thất"] },
      { "title": "Số phòng ngủ", "type": "bedrooms", "type_input": "number",
        "data_field": [1, 2, 3, 4, 5, 6] },
      { "title": "Tầng", "type": "floors", "type_input": "number", "data_field": null },
      { "title": "Tòa", "type": "zone_of_project", "type_input": "text", "data_field": null },
      { "title": "Phí quản lý", "type": "management_fee", "type_input": "number", "data_field": null },
      { "title": "Số phòng tắm", "type": "bathrooms", "type_input": "number",
        "data_field": [1, 2, 3, 4, 5, 6] },
      { "title": "Hướng nhà", "type": "house_direction", "type_input": "text",
        "data_field": ["Đông", "Tây", "Nam", "Bắc", "Đông Bắc", "Đông Nam", "Tây Bắc", "Tây Nam"] },
      { "title": "Hướng ban công", "type": "balcony_direction", "type_input": "text",
        "data_field": ["Đông", "Tây", "Nam", "Bắc", "Đông Bắc", "Đông Nam", "Tây Bắc", "Tây Nam"] }
    ]
  },
  "message": "Thành công"
}
```

**FE decoded contract:**
- Wrapper: `{status, data, message}` — consistent
- `data.id` + `data.title` = property type metadata
- `data.fields_array[]` mỗi item:
  - `title` (vi label)
  - `type` (technical key, match Flutter enum đã list)
  - `type_input`: `"text"` | `"number"` (NOTE: chỉ 2 value, KHÔNG có "dropdown" như BE nói trước)
  - `data_field`: `null` | `string[]` | `number[]`
- **Logic render widget FE:**
  - `data_field` là array → render **picker/select** với options đó (regardless type_input)
  - `data_field` null + `type_input=number` → TextField number + unit suffix
  - `data_field` null + `type_input=text` → TextField text
  - **Edge case `floor_block`** không có `type_input` lẫn `data_field` (chỉ `title` + `type`) → BE thiếu spec? Flutter render Counter (+/-). FE web sẽ default = TextField text (combo "tầng/block" như "5/A") trừ khi BE confirm.

**FE follow-up — BE đã reply (2026-04-21):**
- Sample loại khác → "Truyền ID loại BDS vào để lấy dữ liệu" — BE confirm endpoint nhận ID. **FE assume shape consistent giữa các loại** (sẽ tự test thêm IDs khi impl).
- `floor_block` → BE: "không hiểu floor_block là gì" — field legacy không có spec. **FE quyết định skip render field này** (defensive: nếu gặp `type=floor_block` không có `type_input` → ignore item, không render).
- Field REQUIRED → BE: "Tất cả" — **mọi field BE trả về đều bắt buộc**. UX implication: user phải fill 9 field cho căn hộ chung cư mini trước khi tiếp tục.
- Unlock Section 5 → tự suy ra từ "Tất cả required": Section 4 (mota động) "hoàn thành" = fill HẾT mọi field non-floor_block → unlock Section 5 (title + description). Validation gate: `every(field => fieldValue !== undefined && fieldValue !== '')`.

**FE UX decision (2026-04-21): Group fields theo category để giảm cảm giác dài**

BE response không có `group` metadata → FE tự map static theo `type`:

| Group | Field types |
|---|---|
| **Phòng & Tầng** | `bedrooms`, `bathrooms`, `num_of_floors`, `floors`, `zone_of_project` |
| **Hướng** | `house_direction`, `balcony_direction`, `land_direction` |
| **Diện tích & Kích thước** | `frontage`, `road_width`, `ceiling_height`, `door_size`, `access_door_size`, `construction_area`, `campus_area` |
| **Pháp lý & Nội thất** | `legal_document_type`, `interior` |
| **Phí & Tỉ lệ** | `management_fee`, `residential_agricultural_ratio`, `building_density`, `business_type` |
| **Khác** (fallback) | unknown types BE thêm sau |

**Render UX:**
- Mỗi group = 1 collapsible card với badge progress "X/Y trường"
- Group nào không có field nào BE trả về → ẩn hoàn toàn (vd căn hộ chung cư mini không có "Diện tích & Kích thước")
- Default expand all groups
- Section 5 (Nội dung tin đăng) unlock khi TẤT CẢ groups complete (mọi non-floor_block field filled)

**Risk:** BE thêm `type` mới → fallback group "Khác" hứng. FE log warning để team add vào map.

---

### Q2. AI generate content endpoint

**Context:** Flutter có nút "Tạo tự động" (gradient orange) ở Step 1 → route `Routes.createAi` → AI generate title + HTML description. FE web muốn impl phase này.

**Câu hỏi:**
- a) BE có endpoint AI generate đã sẵn sàng chưa? (path?)
- b) Input shape: gửi gì? (property_type_id, area, price, location, bedrooms, bathrooms...?)
- c) Output shape: trả `{title, html_content, description_plain}`?
- d) Streaming (SSE) hay request-response 1 lần?
- e) Rate limit / quota / cost?
- f) Nếu chưa có → FE hide button hay show disabled với tooltip "Coming soon"?

**BE Response (2026-04-21):**
```
Section 5 — Nội dung tin đăng:
- Nhập tiêu đề tin đăng (tối đa 200 ký tự)
- Nhập mô tả chi tiết (rich text editor)
- Có tùy chọn generate bằng AI
- Unlock Section 6 khi hoàn thành

API (tùy chọn):
- V1: POST /api/generate_real_estate_sample.json
- Body: {content, length, tone}
- content = tất cả dữ liệu đã nhập của thông tin BDS ở trên theo đúng tên field
```

**FE decoded:**
- Endpoint: `POST /api/generate_real_estate_sample.json` (FE proxy → Web2py)
- Title constraint: **max 200 ký tự** (Zod validation)
- Body shape:
  - `content`: object chứa toàn bộ field BDS đã nhập (property_type_id, transaction_type, area, price, city, district, ward, address, bedrooms, bathrooms, floors, house_direction, balcony_direction, interior, ...) — dùng đúng tên field như `create_post.json` payload
  - `length`: enum độ dài (assume `'short' | 'medium' | 'long'` — chờ BE confirm)
  - `tone`: enum giọng văn (assume `'professional' | 'casual' | 'persuasive'` — chờ BE confirm)
- Output shape: chưa nói → assume `{status, data: {title, html_content, description}, message}` consistent wrapper
- Streaming: chưa nói → assume request-response 1 lần (timeout 30s đề xuất)
- Rate limit: chưa nói → defensive UX (disable button khi đang generate, debounce)

**Section 6 ambiguity:**
- BE nói "Unlock Section 6 khi hoàn thành" — Section 6 chưa được define
- **FE assumption:** Section 6 = sang **Bước 2** (Hình ảnh & Pháp lý) — Step 1 chỉ có 5 sections trong cùng 1 step. Tức là "unlock Section 6" = enable nút **"Tiếp theo"** chuyển sang Bước 2.
- Cần BE confirm: Step 1 có thực sự còn section nào nữa không? Hay Section 6 = Bước 2?

**BE source verified (2026-04-21) — `controllers/api.py:2549-2590`:**

```python
@request.restful()
@service.json
def generate_real_estate_sample():
  def POST(**vars):
    """
    body:
      title: string
      price, min_price, max_price: int
      property_type_id: int
      description: string
      furniture, house_direction, balcony_direction: string
      bedrooms, bathrooms, floors: int
      transaction_type: int
      city, district, ward, street_name, street_address: string
      legal_document_type: string
      content: string = "Viết về bất động sản này"
      length: string = "auto"
      tone: string = "friendly"
      use_ai: bool = false  # true = AI; false = template logic cũ
    returns:
      data: object (đoạn văn mẫu)
      ai_generated: bool
    """
    from post_handle import PostHandle
    result = PostHandle().generate_real_estate_sample(**vars)
    return responses(data=result)
```

**Endpoint chuẩn:** `POST /api/generate_real_estate_sample.json` (apiCommon = `{domain}/api`)

**Decoded:**
- `length`: default `"auto"` — enum chưa rõ trong source, có thể `"short" | "medium" | "long" | "auto"`
- `tone`: default `"friendly"` — có thể `"friendly" | "professional" | "persuasive"` (chờ check `PostHandle`)
- `use_ai: false` → dùng template legacy; `true` → gọi AI thật
- Body shape **flat** (KHÔNG wrap `content` object như BE nói trước) — tất cả field BDS gửi top-level
- Response: `{data: {...generated_content...}, ai_generated: bool}`

**Web payload mapping:**
```typescript
{
  title, price, property_type_id, transaction_type,
  description, furniture, bedrooms, bathrooms, floors,
  house_direction, balcony_direction,
  city, district, ward, street_name, street_address,
  legal_document_type,
  content: "Viết về bất động sản này",  // Hoặc user prompt custom
  length: "auto",
  tone: "friendly",
  use_ai: true,
}
```

**Discrepancy resolved:** BE answer trước nói body `{content, length, tone}` + "tất cả dữ liệu vào content" → **SAI**. Source thực tế: tất cả field flat top-level, `content` là field riêng (prompt instruction).

---

### Q3. Upload file endpoint cho Create BDS

**Context:** User confirm dùng `/api/account/upload-file`, mỗi file gọi 1 lần. Tham khảo Flutter: cùng endpoint nhưng `dio.FormData` với field `'file'` array (multi-file/call). Web sẽ chuyển sang single-file/call.

**Câu hỏi:**
- a) Endpoint `/api/account/upload-file` có phải proxy về Web2py `/api_customer/upload_file.json` không?
- b) Multipart field name là `file` đúng không?
- c) Response shape — confirm vẫn là heterogenous (`data.url` | `data.urls` | `data.data` | `message` (string|list))?
- d) Hard limit per file: 5MB ảnh / 100MB video / ? cho PDF?
- e) Accepted MIME types?
- f) Có virus scan / sanitize không?

**BE Response (2026-04-21):**
```
Section 6 — Hình Ảnh & Tài Liệu:
- Upload 4-10 hình ảnh (bắt buộc)
- Upload giấy tờ pháp lý (bắt buộc)
- Nhập URL video (tùy chọn)

API:
- V1: POST /api_customer/upload_file.json
- Response: {data: {url}} hoặc {data: "url_string"}
```

**FE decoded:**
- ✅ Section 6 = **Bước 2 (Hình ảnh & Tài liệu)** — đã chốt ambiguity từ Q2. Tổng thể wizard có 6 sections (5 trong Step 1 + 1 = Step 2), Step 3 (Review) + Step 4 (Commission) là 2 step cuối.
- ✅ Endpoint Web2py: `POST /api_customer/upload_file.json` — FE web proxy qua `/api/account/upload-file`
- ✅ Response shape **2 variants** (FE parser defensive):
  - `{data: {url: "https://..."}}` — object wrapper
  - `{data: "https://..."}` — string raw
- Constraint:
  - Hình ảnh: 4-10 file (bắt buộc)
  - Pháp lý: ≥1 file (bắt buộc) — KHÁC Flutter (Flutter optional)
  - Video: **upload file .mp4** (tùy chọn, chung endpoint + grid với hình ảnh) — REVERSED 2026-04-21, GIỐNG Flutter

**FE parser pseudocode:**
```typescript
function extractUploadUrl(res: { data: unknown }): string | null {
  if (typeof res.data === 'string') return res.data;
  if (res.data && typeof res.data === 'object' && 'url' in res.data) {
    return typeof res.data.url === 'string' ? res.data.url : null;
  }
  return null;
}
```

**BE source verified (2026-04-21) — `controllers/api_customer.py:4985`:**

```python
def upload_file():
  def POST(*args, **vars):
    """truyền vào body -> form-data biến file: file (định dạng file)"""
    uploaded_files = request.vars.file  # ✅ field name = "file"
    if not isinstance(uploaded_files, list):
      uploaded_files = [uploaded_files]   # accept single hoặc array

    MAX_FILE_SIZE = 50 * 1024 * 1024  # ✅ HARD LIMIT 50MB / file
    
    # FPT S3 storage:
    # - put_object cho file <8MB
    # - upload_fileobj multipart cho ≥8MB
    # - max_multipart_upload_size: 64MB
    # - timeout: connect 10s / read 30s / 3 retries
    
    # Key path: uploads/{year}/{month}/{timestamp}{ext}
    # ContentType: từ file.type hoặc 'application/octet-stream'
    # KHÔNG có MIME whitelist — accept mọi file extension
```

**Decoded:**
- ✅ Endpoint: `POST /api_customer/upload_file.json`
- ✅ Multipart field: `file` (single hoặc array of files)
- ⚠️ **Limit thật: 50MB/file** (KHÔNG phải 5MB ảnh / 100MB video như Flutter assume) — BE limit thoáng hơn nhưng FE vẫn nên enforce 5MB ảnh / 100MB video client-side cho UX tốt
- ⚠️ **KHÔNG có MIME whitelist** — BE accept mọi extension. FE phải enforce client-side: image/jpeg, png, webp, video/mp4, application/pdf
- ⚠️ **KHÔNG virus scan** — chỉ S3 upload thuần
- Storage: FPT S3 path `uploads/YYYY/MM/{timestamp}{ext}`
- Parallel: ThreadPoolExecutor 5 workers cho multi-file
- Response shape (3 variants) — `controllers/api_customer.py:5189-5192`:
  - **Single file success:** `{data: "url_string", message: "key_name"}` (positional `data, message`)
  - **Multi file success:** `{data: ["url1", "url2"], message: ["key1", "key2"]}`
  - **Partial fail:** `{data: {urls, keys, warnings}, message: "..."}`
  - **All fail:** `{status: -1, data: {}, message: "Upload thất bại: ..."}`
- URL pattern: `{s3_endpoint}/{bucket}/uploads/YYYY/MM/{timestamp}{ext}`

**FE parser update (single-file mode):**
```typescript
function extractUploadUrl(res: { status: number; data: unknown; message: unknown }): string | null {
  if (res.status !== 1) return null;
  if (typeof res.data === 'string') return res.data;        // single
  if (Array.isArray(res.data) && typeof res.data[0] === 'string') return res.data[0];  // first of multi
  return null;
}
```

---

### Q4. `create_post.json` payload — clarify field shape

**Context:** Flutter gửi `images` và `video_url` dạng `jsonEncode([...])` (string of JSON array, không phải array native). `legal_document_url` chỉ gửi first item duy nhất.

**Câu hỏi:**
- a) `images` BE expect: JSON-encoded string (`"[\"url1\",\"url2\"]"`) hay array native (`["url1","url2"]`)? Web prefer array native (idiomatic JSON).
- b) `video_url`: same question. Web upload file .mp4 (REVERSED 2026-04-21, không còn nhập URL). Gửi array native như `images` (`["video1.mp4"]`) đúng không? Flutter gửi `jsonEncode([...])` string.
- c) `legal_document_url`: chấp nhận array nhiều file không? Flutter chỉ gửi first → BE silent drop hay reject?
- d) `return_price` — Web bỏ field này (UX không cần). BE có require không, hay nullable OK?
- e) `save_status` enum đầy đủ: `DRAFT`, `PENDING_APPROVAL`, còn gì khác? (`PUBLISHED`, `REJECTED`, `EXPIRED`...?)
- f) Khi `latlng` = "0, 0" (chưa geocode) → BE có reject không, hay accept và set null?

**BE Response (2026-04-21): "Làm giống Flutter"**

**FE decoded — Web sẽ replicate Flutter payload behavior:**
| Sub-Q | Flutter behavior | Web web impl |
|---|---|---|
| a) `images` shape | `jsonEncode([url1, url2])` → JSON-encoded string | Web gửi cùng format: `JSON.stringify([url1, url2])` |
| b) `video_url` shape | `jsonEncode([url])` → JSON-encoded string | Web gửi cùng format: `JSON.stringify([url1, url2])` (multi video OK) |
| c) `legal_document_url` | first item only (`uploadedLegalDocs.first`) | Web gửi first item only — UI cho upload nhiều, payload chỉ gửi 1 |
| d) `return_price` | Flutter gửi (có field UI), filter 0 nếu empty | Web BỎ field này (đã decision UX), BE sẽ không nhận → OK do payload filter |
| e) `save_status` | `DRAFT \| PENDING_APPROVAL` | Web chỉ gửi `PENDING_APPROVAL` (no draft to BE, sessionStorage local only) |
| f) `latlng` "0, 0" | Flutter gửi raw `"0.0, 0.0"`, không guard | Web filter: nếu lat=0 && lng=0 → skip field (don't send) |

**BE source verified (2026-04-21) — `controllers/real_estate_handle.py:26-43`:**

```python
def save_real_estate():
    data = request.body.read()
    if not data:
        raise HTTP(400, "Empty request body")
    try:
        data = json.loads(data)
        data['save_status'] = 'ACTIVE'   # ⚠️ BE OVERRIDE — bất kể FE gửi gì!
    except json.JSONDecodeError:
        raise HTTP(400, "Invalid JSON format")
    
    success, result = RealEstateHandle().save_real_estate(data, 'cms')
    if data.get('id'):                    # edit mode → clear cache
        cache_key = f"property_{data.get('id')}"
        current.cache.disk(cache_key, None)
    return response.json(result)
```

**Endpoint thực tế:** `POST /real_estate_handle/save_real_estate.json` (KHÔNG phải `/api_agent/create_post.json` như tên Flutter method gợi ý)

**Flutter call ([api_client.dart:769-771](C:/Data 2026/Dev/Tongkhobds/src/tongkhobds_agent/lib/domain/client/api_client.dart#L769)):**
```dart
client.post('$apiHostReal\save_real_estate.json', data: [data]);
//          ⚠️ backslash bug    ⚠️ wrap array
```

**Discoveries:**
1. ⚠️ **BE override `save_status='ACTIVE'`** mọi lần — Flutter gửi `PENDING_APPROVAL` → BE ignore và set `ACTIVE`. Decision FE gửi `PENDING_APPROVAL` → vô nghĩa, có thể bỏ luôn field này.
2. ⚠️ Flutter wrap data trong **array** `[data]` nhưng BE đọc raw body và `json.loads(data)` → expect single object. **Flutter có thể có bug**, hoặc `RealEstateHandle().save_real_estate` xử lý cả 2 dạng. Web nên gửi single object (`data` không wrap).
3. ⚠️ Flutter URL có **backslash** `\save_real_estate.json` thay vì `/` — likely bug Flutter, browser/dio tolerant. Web phải dùng `/` đúng.
4. ✅ **Edit mode** = cùng endpoint, kèm `data.id` field. BE auto detect và clear cache.
5. Path prefix: `/real_estate_handle/` không phải `/api_agent/` hay `/api_customer/`

**Web impl:**
- Endpoint proxy: `POST /api/real-estate/save` → `/real_estate_handle/save_real_estate.json`
- Send single JSON object (no array wrap)
- Bỏ field `save_status` vì BE override
- `id` field: include khi edit, omit khi create

**Video follow-up — "giống Flutter":**
| Aspect | Flutter | Web |
|---|---|---|
| Size limit | 100MB | 100MB hard check client-side |
| Duration | 5 phút (max via picker) | 5 phút (validate via `<video>.duration` sau pick) |
| MIME | `.mp4` only | `accept="video/mp4"` |
| Thumbnail | `VideoThumbnailWidget` (client-side gen) | HTML5 `<video poster>` hoặc canvas grab frame 0 |
| Streaming | direct .mp4 download | direct .mp4 in `<video>` tag |

---

### Q5. `getCommissionDefault` — input/output cho Step 4

**Context:** Flutter gọi với `{cityId, districtId, wardId, area, price, propertyTypeId}`. Response `{title, description, min_commission, update_max_commission, update_commission}`. Web đang chỉ truyền `cityId` (`useProvinceCommission`) — cần extend.

**Câu hỏi:**
- a) Endpoint chính xác? (Flutter: `apiClient.getCommissionDefault` — path Web2py?)
- b) Confirm 6 params required: `city_id, district_id, ward_id, area, price, property_type_id`?
- c) Khi 2-cấp mode (no district), `district_id` truyền gì? Empty string? Skip param?
- d) `update_commission: bool` — `true` = user được edit, `false` = readonly?
- e) `update_max_commission` vs `min_commission` — semantic chính xác? (max là số tối đa user được set?)
- f) Có cache/stale-time recommend không (commission ít thay đổi)?

**FE-resolved from Flutter source (2026-04-21):**

Flutter dùng endpoint xác định, không cần BE confirm thêm:

```
GET {domain}/api_agent/get_commission_default.json
  ?city_id={city_id}
  &district_id={district_id}
  &ward_id={ward_id}
  &area={area}
  &price={price}
  &property_type={property_type_id}
```

**Source:** `tongkhobds_agent/lib/domain/client/api_client.dart:864-886`

**Decoded contract:**
- Method: **GET** (query params, không POST body)
- Path prefix: `/api_agent` (KHÔNG phải `/api_customer` như endpoint khác)
- Param **`property_type`** (KHÔNG phải `property_type_id`) — đây là discrepancy quan trọng cần check
- Tất cả 6 params đều `required` trong Flutter signature
- 2-cấp mode: Flutter pass `selectedDistrict.value` (string name) cho `districtForCommission`. Khi 2-cấp, FE controller fallback `useTwoLevelAddress.value ? selectedCommune.value : ''` cho district. Tức là **2-cấp → dùng ward làm district fallback** (hack), hoặc empty string.

**Response shape (từ Flutter `create_news_controller.dart:357-378`):**
```json
{
  "status": 1,
  "data": {
    "title": "string",
    "description": "string",
    "min_commission": 0.5,
    "update_max_commission": 3.0,
    "update_commission": true
  }
}
```

**Field semantic:**
- `min_commission` (number) — default value FE set vào input
- `update_max_commission` (number) — upper bound khoảng valid
- `update_commission` (bool) — `true` = user được edit, `false` = readonly (fix at min)
- `title` + `description` — marketing text BE custom (vd "Tăng hoa hồng - Tăng cơ hội chốt đơn" + body)

**Validation FE:**
```typescript
roseValid = (min === 0 && max === 0) || (rose >= min && rose <= max);
```

**Web impl:**
- Endpoint proxy: `GET /api/agent/get_commission_default.json` (Next.js Route Handler proxy)
- React Query hook `useCommissionDefault({city_id, district_id, ward_id, area, price, property_type_id})` — auto-fetch khi đủ data
- StaleTime: 5 phút (commission ít đổi, theo tuple)
- Refetch khi user đổi area/price ở Step 1 (debounce 500ms)

**BE source verified (2026-04-21) — `controllers/api_agent.py:17915-17952`:**

```python
@myjwt.allows_jwt()
@request.restful()
@service.json
def get_commission_default():
  def GET(**kwargs):
    city_id = request.vars.get('city_id')
    district_id = request.vars.get('district_id')
    ward_id = request.vars.get('ward_id')
    area = request.vars.get('area')
    price = request.vars.get('price')
    property_type = request.vars.get('property_type')   # ✅ tên param chính xác

    if not (city_id and district_id and ward_id):
      return responsesError({}, 'Thiếu thông tin địa chỉ')
    if not price or not area:
      return responsesError({}, 'Thiếu diện tích hoặc giá bán')

    # ⚠️ Hiện đang HARDCODE — chưa có logic tính theo location/type/area/price
    return responses({
      "min_commission": 2,
      "title": "Mức hoa hồng gợi ý cho bất động sản của bạn",
      "description": "...",
      "update_commission": True,
      "update_min_commission": 0,    # ⚠️ Flutter không đọc field này
      "update_max_commission": 100
    })
```

**Findings:**
1. ✅ Param name **`property_type`** (Flutter đúng) — BE nhận nhưng KHÔNG dùng để tính (mock current)
2. ⚠️ `district_id` REQUIRED — empty string sẽ FAIL ("Thiếu thông tin địa chỉ"). **2-cấp mode sẽ broken** trừ khi BE relax check
3. ⚠️ Logic commission đang **hardcode mock** (min=2, max=100) — không theo location/area/price/type. BE cần impl thật.
4. ✅ Response shape match Flutter expectation, có thêm `update_min_commission: 0` (Flutter ignore — OK)
5. ✅ Method GET, query params (đúng Flutter)

**Implications cho Web wizard:**
- Range `[2, 100]` quá rộng → UX validate luôn pass — không hữu ích cho user
- 2-cấp mode (no district) sẽ fail → cần BE patch sớm hoặc FE skip auto-fetch khi không có district_id
- Khi BE impl logic thật → response shape vẫn giữ → web không cần đổi code

---

### Q6. Edit mode (defer phase sau, nhưng cần lock contract sớm)

**Context:** Flutter dùng route arguments truyền `ProductModel` từ list màn hình → wizard hydrate `initDataFromMap()`. Web dự kiến route `/bds/[id]/edit` (defer phase sau, nhưng API cần khớp).

**Câu hỏi:**
- a) `create_post.json` đang dùng cho cả CREATE và UPDATE (kèm `id` trong payload)? Hay có endpoint riêng `update_post.json`?
- b) Khi edit, BE giữ nguyên `save_status` cũ hay reset về `PENDING_APPROVAL`?
- c) Có cần `version`/`updated_at` để optimistic concurrency không?
- d) Edit có require re-upload images không, hay giữ URL cũ?

**FE-resolved from BE source (2026-04-21):**

Cùng endpoint với create — đã verify ở Q4 ([real_estate_handle.py:26-43](c:/Data 2026/Dev/Tongkhobds/src/BE/controllers/real_estate_handle.py#L26)):

| Sub | Resolved |
|---|---|
| a) CREATE vs UPDATE endpoint | **CÙNG** `POST /real_estate_handle/save_real_estate.json`. Có `data.id` → UPDATE; không có → CREATE |
| b) `save_status` reset | BE luôn override `save_status='ACTIVE'` — không reset PENDING. Edit không đổi behavior này |
| c) optimistic concurrency (`version`/`updated_at`) | KHÔNG — BE không check, last-write-wins |
| d) Re-upload images? | KHÔNG cần — gửi URL cũ trong `images` array (đã upload trước đó). Chỉ upload file mới nếu user thêm ảnh |

**Web impl edit mode:**
- Route: `/bds/[id]/edit`
- Hydrate: GET `/api_agent/real_estate_v2.json?id={id}` → fill form (defer phase sau theo decision earlier)
- Save: cùng `useSaveBdsMutation`, kèm `id` field trong payload
- BE clear cache `property_{id}` tự động

---

### Q7. Tag categories `REAL_ESTATE` / `REAL_ESTATE_2` — typo + thiếu seed dev (2026-04-25)

**Context:** FE đã wire BDS tag filter theo mapping `transaction_type=1 (Mua bán) → REAL_ESTATE`, `transaction_type=2 (Cho thuê) → REAL_ESTATE_2`. Gọi `GET /api_agent/list_tags?category_code=...` trên trang `/bds/mua-ban` và `/bds/cho-thue`.

**Findings (query trực tiếp `tag_categories`):**

Prod (`db.tongkhobds.com / tongkhobds`):
```
 id | code          | name
----+---------------+--------------
  1 | DEMAND        | Nhu cầu
  2 | AGENT         | Agent
  3 | bat-dong-san  | Bất động sản
  4 | properties    | Bất động sản
  5 | REAL_ESTATE   | BDS Mua bán      ✅
  6 | REAL_ESTALE_2 | BDS Cho thuê     ❌ TYPO: thiếu chữ T
```

Dev (`dbdev.tongkhobds.com / tongkhobdsdev4`): chỉ có `DEMAND` + `AGENT`. Hoàn toàn chưa seed `REAL_ESTATE*` → FE BDS tag filter trên dev luôn trả mảng rỗng.

**Câu hỏi / Đề nghị:**

- a) **Prod fix typo**: `UPDATE tag_categories SET code='REAL_ESTATE_2' WHERE code='REAL_ESTALE_2';` — đổi `REAL_ESTALE_2` → `REAL_ESTATE_2`. Đồng bộ `tag_groups`/`tags` thuộc category này theo `category_id` (không cần đổi vì FK theo id).
- b) **Dev seed**: clone 2 row `REAL_ESTATE` + `REAL_ESTATE_2` từ prod (kèm `tag_groups` + `tags` mẫu) sang dev để FE test được trên `tongkhobdsdev4`.
- c) (Bonus) Có cần dọn 2 row legacy `bat-dong-san` + `properties` trên prod không? Hiện FE không dùng, nhưng tồn tại có thể gây nhầm lẫn cho team khác sau này.

**FE impact:** sau khi BE fix (a) + (b), FE giữ nguyên mapping hiện tại (`REAL_ESTATE` / `REAL_ESTATE_2`), không cần đổi code.

---

<a id="docs-04-api-by-screen-md"></a>

## docs/04-api-by-screen.md

---
title: API by Screen — MVP 36 màn
type: api-mapping
date: 2026-04-17
source: docs/02-api-catalog.md + docs/screens/phase-02-screens.md + phase-03-screens.md
scope: MVP only (Auth, BDS, Dự án, Giao dịch, Đặt cọc, Nhu cầu, Khách, Lịch hẹn, Hợp đồng, Profile, Notification)
---

# API by Screen — Webapp Agent MVP

Map endpoint → screen kèm input/output. Mọi request inject `Authorization: Bearer <token>` (trừ login/otp/register/forgot). Response envelope `{status: 1|0, message, data}` — FE unwrap `data`, throw nếu `status==0`.

**Chú thích**:
- `Trigger`: thời điểm gọi (mount, action, polling)
- `Input`: query/body keys chính (không list field tuỳ chọn nếu nhiều)
- `Output`: shape `data` payload
- ⚠️ = cần BE clarify
- 🔁 = polling

---

## Group 1 — Auth + KYC (5 màn)

### 1.1 `/login`
Đăng nhập bằng phone + password.

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/login` | submit form | `user_name`, `password` | `{token, user: UserProfile, mem: string[]}` |
| GET | `/api_agent/login` | OAuth Google btn | `google_token` | `{token, user, mem}` |
| GET | `/api_agent/checkPhoneRegister.json` | blur phone field (tuỳ) | `phone` | `{available: bool}` |

### 1.2 `/otp-verify`
6-digit OTP sau login (nếu BE yêu cầu 2FA).

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/send_otp.json` | mount + click "Gửi lại" | `phone`, `id_device` | `{otp_id, message}` |
| GET | `/api_agent/login_otp.json` | submit OTP | `phone`, `otp` | `{token, user}` |

### 1.3 `/forgot-password`
Wizard 3 step reset password.

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/send_otp.json` | step 1 submit | `phone`, `id_device` | `{otp_id}` |
| GET | `/api_agent/login_otp.json` | step 2 submit OTP | `phone`, `otp` | `{token (temp)}` |
| POST | `/api_agent/create_new_password` | step 3 submit | `{new_password}` | `{success: bool}` |

### 1.4 `/kyc` (verify_agent)
Upload CCCD + thông tin cá nhân.

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/check_account_authentication.json` | mount + 🔁 sau submit (interval ⚠️) | — | `{step: 1|2|3, step_name, salesman_id}` |
| POST | `/api_agent/verify_agent.json` | submit form | FormData: `id_card, name, birthday, sex, address, id_day, citizen_id_front (file), citizen_id_back (file)` | `{kyc_status, message}` |

### 1.5 `/splash`
Bootstrap session check.

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_user_profile.json` | mount (token tồn tại) | — | `{user_profile: UserProfile}` (401 → redirect `/login`) |
| GET | `/api_agent/check_account_authentication.json` | mount sau profile OK | — | `{step, step_name}` |

---

## Group 2 — Home + Search + Map (4 màn)

### 2.1 `/` (Home dashboard)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_user_profile.json` | mount | — | `{user_profile}` (greeting, KYC banner) |
| GET | `/api_agent/dashboard_stats.json` | mount | `start_date?`, `end_date?` (ISO 8601) | `{stats: {data: [{key, value, unit, change_percent, icon_svg}]}}` (4 cards) |
| GET | `/api_agent/home_config.json` | mount | — | `{banners[], featured_bds[]}` |
| GET | `/api_agent/home_blocks.json` | mount (city context) | `user_id`, `city_id`, `locations_slug`, `city` | `{blocks[]}` |
| GET | `/api_agent/list_tmessage.json` | mount preview 5 mới | `page=1`, `limit=5`, `app=agent` | `{items[], total, unread_count}` |
| GET | `/api/cities` | mount (city dropdown) | `limit=7` | `{cities[]}` |

### 2.2 `/tim-kiem` (Advanced search)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_filter_config.json` | mount | `transaction_type`, `city_id` | `{filters: {price_ranges, area_ranges, property_types, ...}}` |
| GET | `/api_customer/get_property_types.json` | mount | `type` (buy/sell/rent) | `{property_types[]}` |
| GET | `/api_agent/get_list_type_search.json` | mount | — | `{search_types[]}` |
| GET | `/api_agent/real_estate_v2.json` | submit filter (debounce 500ms) | `page, limit, sort, city_id, district_id, keyword, transaction_type, minPrice, maxPrice, minArea, maxArea, bedrooms, property_types, house_direction, balcony_direction, user_id` | `{items[], total, page}` |

### 2.3 `/select-location`
Cascading city → district → ward picker.

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/locations.json` | mount + change parent | `id?`, `layer` (1=city,2=district,3=ward), `grant?`, `n_slug?` | `{locations[]}` |
| GET | `/api_common/location_searching_by_province.json` | type to search | `text`, `lat?`, `lng?` | `{suggestions[]}` |
| GET | `/api_customer/search_districts.json` | district dropdown | `id` (parent city) | `{districts[]}` |

### 2.4 `/ban-do` (Real estate map)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_customer/real_estate_map.json` | pan/zoom (debounce) | `latlng=lat,lng`, `radius`, `limit=50`, `transaction_type?`, `project_code?` | `{properties[], total, page, limit, total_pages}` (no bbox, no cluster — client-side) |
| GET | `/api_customer/property_map.json` | click marker single | `id` | `{location: {lat,lng}, marker}` |
| GET | `/api_customer/project_details_map.json` | click project marker | `id` | `{map_data}` |

---

## Group 3 — BDS + Dự án + Bảng hàng (8 màn)

### 3.1 `/bds` (BDS list)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/real_estate_v2.json` | mount + filter change | `page, limit, sort, keyword, transaction_type, city_id, district_id, minPrice, maxPrice, minArea, maxArea, bedrooms, property_types (comma-sep), house_direction, balcony_direction` | `{items: Product[], total, page}` |
| GET | `/api_customer/list_favorite_groups` | mount (favorite badge) | — | `{groups[]}` |
| POST | `/api_agent/add_to_favorite_group.json` | click heart icon | `real_estate_id`, `group_id` | `{success}` |
| POST | `/api_agent/remove_from_favorite_group.json` | unfavorite | `{real_estate_id, group_id}` | `{success}` |
| GET | `/api_agent/location/*` | address cascade + search | `provinces`, `districts` per province, keyword search | filters by tỉnh → huyện + optional keyword |

**Filter refactor (post-MVP 2026-04-20):**
- **Multi-select**: property types + status passed as comma-joined string to `property_types` param.
- **Address cascade**: New `/api_agent/location/*` endpoints (provinces, districts); replaces hardcoded lists.
- **Range dropdowns**: Price/area ranges via UI dropdowns; API params unchanged (`minPrice`, `maxPrice`, `minArea`, `maxArea`).
- **Infinite scroll**: Pagination via `use-bds-infinite-list` hook (defensive last-page detection).
- **Keywords**: Address keyword search integrated into cascade selectors.

### 3.2 `/bds/[id]` (BDS detail)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_customer/property.json` | mount (slug/public) | `id` hoặc `slug`, `user_id?` | `{product_detail, gallery, seller}` |
| GET | `/api_customer/get_detail_real_estate.json` | mount (owner mode) | `real_estate_id`, `my_properties=true` | `{product, location, features}` |
| GET | `/api_agent/real_estate_v2.json` | section "BDS tương tự" | `limit=6, similar_to=<id>` | `{items[]}` |
| POST | `/api_agent/add_to_favorite_group.json` | favorite btn | `real_estate_id, group_id` | `{success}` |
| POST | `/api_agent/interest_in_property.json` | btn "Thêm vào nhu cầu khách" | `{table_id, table_name='real_estate', customer_id, notes}` | `{success}` |
| POST | `/api_customer/unpublish_property.json` | btn Delete (owner) | `id` | `{success}` |

### 3.3 `/bds/create` & `/bds/[id]/edit` (Wizard 4 step: Info → Hình ảnh → Xem lại → Hoa hồng)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_customer/get_property_types.json` | step 1 mount | `type` | `{property_types[]}` |
| GET | `/api_customer/get_property_type_fields.json` | step 1 chọn loại | `property_type_id` | `{fields: {type, title, type_input, data_field}[]}` |
| GET | `/api_agent/locations.json` | step 1 cascade địa chỉ | `layer, id` | `{locations[]}` |
| POST | `/api_common/generate_real_estate_sample.json` | step 1 btn "Tạo mô tả AI" | `{title, price, property_type_id, transaction_type, description, bedrooms, bathrooms, floors, house_direction, balcony_direction, city, district, ward, street_address, legal_document_type, content, length, tone, use_ai}` | `{data: {...}, ai_generated}` |
| POST | `/api_customer/upload_file.json` | step 2 upload ảnh/legal/video | FormData (file, max 50MB) | `{data: string \| {url}}` ⚠️ heterogenous shape |
| GET | `/api_agent/get_commission_default.json` | step 4 sau nhập giá+area | `city_id, district_id, ward_id, area, price, property_type` | `{min_commission, update_max_commission, update_commission, title, description}` |
| POST | `/real_estate_handle/save_real_estate.json` | step 4 submit | `{title, address, price, area, property_type_id, images: JSON.stringify([...]), video_url: JSON.stringify([...]), legal_document_url, latlng, bedrooms, ...}` (single object, no array wrap) | `{product_id, status}` |

**Wizard V2 (2026-04-21):**
- **Step 1 (Thông tin BDS)**: property type + dynamic fields + address + AI generate content. Section 5 unlock khi fill all required fields.
- **Step 2 (Hình ảnh & Tài liệu)**: Upload 4-10 ảnh (required), ≥1 legal doc (required), video (optional). Upload compress ≤50MB/file, images ≤5MB recommended (FE client-side validate).
- **Step 3 (Xem lại)**: Review tất cả thông tin trước submit.
- **Step 4 (Hoa hồng)**: Commission default (min-max range), user can edit nếu `update_commission=true`.
- **Endpoint thay đổi**: `POST /real_estate_handle/save_real_estate.json` (KHÔNG phải `/api_agent/save_real_estate.json`). Single object, no array wrap. `save_status` omitted (BE override to 'ACTIVE'). Edit mode: include `id` field (cùng endpoint auto-detect).
- **Payload format**: `images`, `video_url` as JSON.stringify arrays; `legal_document_url` first item only; skip `latlng` when 0,0.

### 3.4 `/bds/my-product`

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_list_real_estate.json` | mount + filter | `page, limit, search, source, sort, property_types, status_id, bedrooms, price_range, area_range` | `{items[], total}` |
| POST | `/api_customer/unpublish_property.json` | toggle "Tạm ngưng" | `id` | `{success}` |

### 3.5 `/bds/favorite`

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_customer/list_favorite_groups` | mount | — | `{groups[]}` (excludes hidden "Đã xem gần đây") |
| POST | `/api_customer/create_favorite_group` | btn "Tạo nhóm" | `{title}` | `{group_id, name}` |
| POST | `/api_customer/update_favorite_group` | edit nhóm | `{title, id}` | `{success}` |
| POST | `/api_customer/delete_favorite_group` | xoá nhóm | `{id}` | `{success}` |
| GET | `/api_agent/list_favorite_items_by_group` | chọn nhóm | `group_id` | `{items: Product[]}` |
| POST | `/api_agent/remove_from_favorite_group.json` | unfavorite item | `{real_estate_id, group_id}` | `{success}` |

**Favorite groups (post-MVP 2026-04-20):**
- Multi-group: items assigned to specific named groups; optimistic toggle stamps `is_favorite + favorite_group` across cached queries.
- Hidden default: BE filters "Đã xem gần đây" from user-visible group list.
- UI: `create-favorite-group-dialog.tsx`, `favorite-group-picker-dialog.tsx` (new).
- Hook: `use-favorite-groups.ts` (new).
- ⚠️ Caveat: `add_to_favorite_group` may read from query params, not JSON body — check request format in code.

### 3.6 `/du-an` (Project list)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/real_estate_sale_project.json` | mount | — (filter client-side hoặc params city) | `{projects[]}` |

### 3.7 `/du-an/[id]` (Project detail)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_customer/project_details.json` | mount | `id` | `{project, sub_projects[], blocks[]}` |
| GET | `/api_customer/project_details_map.json` | tab "Mặt bằng" | `id` | `{map_data}` |
| POST | `/api_agent/real_estate_sale_register.json` | btn "Liên hệ tư vấn" | `{project_id, real_estate_sale_id=1}` | `{registration_status}` |

### 3.8 `/du-an/[id]/bang-hang` (Bảng hàng)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/apartment_status.json` | mount + filter tòa/tầng | `project_code`, `zone_of_project?` | `{apartments[], status[]}` |
| (navigate) | `/dat-coc/create?bds_ids=...` | bulk action "Đặt cọc" | — | — |

---

## Group 4 — Giao dịch + Đặt cọc (4 màn)

### 4.1 `/giao-dich` (Transaction list)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_status_transaction.json` | mount (filter dropdown) | — | `{statuses[]}` |
| GET | `/api_agent/real_estate_transaction.json` | mount + filter | `page, limit, type` (buy/sell), `search?, status?` | `{items: Transaction[], total, page}` |

### 4.2 `/giao-dich/[id]` (Transaction detail)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/real_estate_transaction.json` | mount | `id` | `{transaction_detail, work_logs[], comments[]}` |
| POST | `/api_agent/real_estate_work.json` | btn "Tạo công việc" | `{table_id, tablename, ...work_data}` | `{work_id}` |
| POST | `/api_agent/update_real_work_status.json` | đổi status work | `{work_id, status, noted}` | `{success}` |
| POST | `/api_agent/real_estate_work_comment.json` | gửi comment | `{table_id, tablename, content_comment}` | `{comment_id}` |
| POST | `/api_agent/transaction_documents.json` | upload tài liệu | FormData (files + meta) | `{success}` |

### 4.3 `/dat-coc/create` (Make deposit)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_booking_statuses.json` | mount | `status_type=1` | `{statuses[]}` |
| GET | `/api_agent/get_list_customer.json` | mount (customer picker) | `page=1, limit=20, search?, xtype=0` | `{items: Customer[], total}` |
| POST | `/api_agent/deposit_create.json` | submit form | `{table_name, table_id, deposit_type, deposit_amount, customer_id}` | `{deposit_id, status}` |

### 4.4 `/dat-coc` (Deposit work list + detail)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_group_status_deposit.json` | mount (filter group) | — | `{status_groups[]}` |
| GET | `/api_agent/get_deposit_works.json` | mount + filter | `page, limit, status?` (comma-sep) | `{items[], total}` |
| GET | `/api_agent/deposit_detail.json` | mở detail | `deposit_work_id` | `{deposit_detail}` |
| PUT | `/api_agent/deposit_update.json` | btn cancel/notes | `{deposit_work_id, status, notes}` | `{success}` |

---

## Group 5 — Nhu cầu + Khách (5 màn)

### 5.1 `/nhu-cau` (Demand list)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_customer_demands.json` | mount + search | `page, limit, search?` | `{items: Demand[], total}` |

### 5.2 `/nhu-cau/create` (Demand create)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_list_customer.json` | mount (customer picker) | `page=1, limit=20, search?, xtype=0` | `{items[], total}` |
| GET | `/api_customer/get_property_types.json` | mount | `type` | `{property_types[]}` |
| GET | `/api_agent/locations.json` | location cascade | `layer, id` | `{locations[]}` |
| POST | `/api_agent/create_customer_demand.json` | submit | `{customer_id, title, description, property_type, min_price, max_price, min_area, max_area, city_id, district_id, ...}` | `{demand_id}` |

### 5.3 `/nhu-cau/[id]` (Demand detail + suggestions)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_demand_detail.json/<id>` | mount (path param) | `id` (path) | `{demand_detail}` |
| GET | `/api_agent/demand_suggest.json` | section "Gợi ý BDS" | `consultation_id` | `{suggested_products: Product[]}` |
| PUT | `/api_agent/update_demand.json` | edit/delete | `{id, ...demand_update}` | `{success}` |
| POST | `/api_agent/interest_in_property.json` | btn "Quan tâm" trên BDS gợi ý | `{table_id, table_name, customer_id, notes}` | `{success}` |

**Phase 1 (2026-05-06):** Section "BDS đang làm việc" (NEW) uses **mock localStorage** for FE-only prototype. Pending BE pivot table `consultation_property` contract (see Q1-Q6 in `03-be-questions.md` Priority 4 section). FE wires 4 actions (verify request, appointment, task, deposit) + group-by-broker toggle. No API changes required Phase 1; BE coordination needed Q2.

### 5.4 `/khach-hang` (Customer support / list)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_list_customer.json` | mount + search | `page, limit, search?, xtype=0` | `{items: Customer[], total}` |
| GET | `/api_agent/get_list_customer_transaction.json` | tab "Khách + GD" | — | `{customers_with_transactions[]}` |
| GET | `/api_agent/get_list_transaction_by_customer.json` | mở khách → tab GD | `customer_id` | `{transactions[]}` |
| PUT | `/api_agent/customer.json` | edit khách | `{customer_id, name, phone, email, address}` | `{success}` |
| DELETE | `/api_agent/customer.json` | xoá khách | `customer_id` | `{success}` |

### 5.5 `/khach-hang/create` (Add customer)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api/check_phone_register.json` | blur phone | `phone` | `{registered: bool}` |
| POST | `/api_agent/add_customer.json` | submit | `{name, phone, email, address}` | `{customer_id}` |

---

## Group 6 — Lịch hẹn (2 màn)

### 6.1 `/lich-hen/create` (Make appointment)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_list_customer.json` | mount (customer picker) | `page, limit, search?, xtype=0` | `{items[], total}` |
| GET | `/api_agent/real_estate_v2.json` | mount (BDS picker) | `page=1, limit=20, search?` | `{items[], total}` |
| POST | `/api_agent/real_estate_appointment` | submit | `{customer_id, real_estate_id, appointment_date, location, note, type}` | `{appointment_id}` |

### 6.2 `/lich-hen` & `/lich-hen/[id]`

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/real_estate_appointment.json` | mount list | `page, limit, status?` | `{items[], total}` |
| GET | `/api_agent/real_estate_appointment.json` | mount detail | `id` | `{appointment_detail}` |
| PUT | `/api_agent/real_estate_appointment` | đổi status / note | `{appointment_id, appointment_status, note}` | `{success}` |

---

## Group 7 — Hợp đồng (3 màn)

### 7.1 `/hop-dong` (Contract list)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_customer/contracts.json` | mount | — | `{contracts[]}` |

### 7.2 `/hop-dong/[id]` (Contract detail / sign flow)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_customer/contract_content_by_id.json` | mount | `contract_id` | `{contract_content (HTML/PDF url)}` |
| GET | `/api_agent/contract_content.json` | mode "Tạo mới" | — | `{contract_html, terms}` |
| POST | `/api_agent/contract_agent.json` | mode "Theo office" | `{info_office}` | `{contract_template}` |
| POST | `/api_agent/contract_otp.json` | btn "Gửi OTP ký" | `{phone, purpose=1, channel}` (SMS/email) | `{otp_sent}` |
| PUT | `/api_agent/contract_otp.json` | submit OTP | `{phone, purpose=1, otp}` | `{verified}` |
| POST | `/api_agent/upload_file.json` | upload signature PNG | FormData (signature_image bytes) | `{file_url}` |
| POST | `/api_agent/contract_create.json` | confirm ký (buyer-side) | `{contract_type, signing_method (1\|2), signed_at, signature_image, info_office}` | `{contract_id, status}` |
| POST | `/api_agent/contract_seller_create.json` | seller-side variant | `{signing_method, contract_type, real_estate_salesman_id, info_office}` | `{contract_id}` |

### 7.3 `/hop-dong/thu-vien` (Contract library)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/news_by_folder.json` | mount + search | `folder=thu-vien-hop-dong-agent, page, length, description?, key?` | `{contracts[], total}` |
| GET | `/api_agent/news_by_id.json` | mở chi tiết | `id` | `{contract_detail}` |

---

## Group 8 — Profile + Team + Rank (4 màn)

### 8.1 `/ho-so` (Profile info)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_user_profile.json` | mount | — | `{id, salesman_id, full_name, phone, email, image, city_id, district_id, address, birthday, sex, id_card, step, award, ...}` (xem shape phase-02-screens.md) |
| GET | `/api_agent/check_account_authentication.json` | mount (KYC banner) | — | `{step, step_name}` |
| GET | `/api_agent/salesman_get_info.json` | section "Giới thiệu" | — | `{referral_code, ...}` |

### 8.2 `/ho-so/edit` (Update profile + avatar + password)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| POST | `/api_agent/update_avatar.json` | upload avatar | FormData (file) | `{avatar_url}` |
| POST | `/api_agent/update_profile.json` | submit form | `{email, phone, full_name, tax_code, city_id, district_id, ward_id, address, birthday, yoe}` | `{success}` |
| POST | `/api_agent/update_password.json` | đổi mật khẩu | `{old_password, new_password}` | `{success}` |
| GET | `/api_agent/locations.json` | location cascade | `layer, id` | `{locations[]}` |

### 8.3 `/team` (Team management — leader only) ⚠️

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/get_reject_reasons.json` | mount (modal reject) | — | `{reasons[]}` |
| POST | `/api_agent/reject_real_estate_salesman.json` | btn reject member | `{real_estate_salesman_id, reject_reason_id, note}` | `{success}` |
| GET | `/api_agent/reconciliation_transactions.json` | tab "Đối soát" | `agent_id, status?, commission_type=buyer, period?, page, limit` | `{transactions[], summary}` |
| GET | `/api_agent/reconciliation_transactions_status.json` | filter dropdown | — | `{statuses[]}` |

> ⚠️ Endpoint chuyên cho team list (members) chưa thấy trong Flutter source — cần BE confirm.

### 8.4 `/xep-hang` (Rank member) ⚠️

> ⚠️ Endpoint riêng cho leaderboard chưa có trong catalog Flutter. Tạm dùng `/api_agent/news_by_folder.json` (`folder=rank` hoặc folder tương đương) hoặc đợi BE bổ sung. **Action**: clarify BE.

---

## Group 9 — Notification (1 màn)

### 9.1 `/thong-bao`

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/list_tmessage.json` | mount + 🔁 30s (badge) | `type? (1=GD, 2=System), page, limit, app=agent` | `{items: Notification[], total}` (no `unread_count` — FE tự count theo BE answer) |
| GET | `/api_agent/set_read_tmessage.json` | click 1 item | `tmessageId, tmessageType` | `{success}` |
| GET | `/api_agent/set_read_all.json` | btn "Đánh dấu đã đọc" | `tmessageType` | `{success}` |
| GET | `/api_agent/delete_tmessage.json` | swipe/delete | `tmessageId` | `{success}` |
| POST | `/api_agent/denied_tmessage.json` | reject 1 thông báo (action) | `{tmessage_id, action}` | `{success}` |

---

## Cross-cutting

### Logout (avatar dropdown — không phải màn riêng)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/logout.json` | btn Đăng xuất | `equipment_token?` | `{success}` (BE chỉ xoá `equipment_token`/FCM, FE tự xoá local token) |

### Activity log (tracking nội bộ)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_agent/api_activity_log` | login success / nav main | `authUserId, systemName, app=agent` | `{logged}` |

### Form config dynamic (dùng cho create/edit forms)

| Method | Endpoint | Trigger | Input | Output |
|--------|----------|---------|-------|--------|
| GET | `/api_common/get_form_config.json` | form mount theo `type` | `type` | `{form_fields[], validation}` |
| POST | `/api_common/calculate.json` | onChange field tính toán | `{...calculation_params}` | `{result}` |
| POST | `/api_common/get_legal_documents.json` | step "Pháp lý" | — | `{documents[], projects[]}` |

---

## Coverage check vs MVP 36 màn

| Group | Màn count | API endpoints unique |
|-------|-----------|----------------------|
| Auth + KYC | 5 | 7 |
| Home + Search + Map | 4 | 12 |
| BDS + Dự án + Bảng hàng | 8 | 24 |
| Giao dịch + Đặt cọc | 4 | 12 |
| Nhu cầu + Khách | 5 | 11 |
| Lịch hẹn | 2 | 4 |
| Hợp đồng | 3 | 10 |
| Profile + Team + Rank | 4 | 9 ⚠️ team/rank chưa đủ |
| Notification | 1 | 5 |
| Cross-cutting | — | 5 |
| **Tổng MVP** | **36** | **~99 unique** (overlap nhiều screens) |

---

## Group 8 — Đội nhóm (Team Management) · 5 screens

Added 2026-04-22 (plan 260421-1427-team-management-port). Route base: `/doi-nhom/`. 22 endpoints (xem 02-api-catalog.md §13).

### S1 · Menu (optional) — `/doi-nhom/menu/`
4 static cards entry (Phase 1 optional, sidebar đã cover navigation).

### S2 · Overview — `/doi-nhom/`
- GET `/api_team_overview` — 4 stat cards + title progress
- GET `/api_team_members?tree_type=referral&limit=20` — thành viên trực tiếp
- GET `/api_my_tags_for_filter` — tag filter (Phase 2)

### S3 · Tree — `/doi-nhom/so-do/`
- GET `/api_get_full_tree` — mode Vòng đời
- GET `/api_get_title_full_tree` — mode Danh hiệu
- GET `/api_get_member_tree?focus={id}` — scoped view (from S4)

### S4 · Member Detail — `/doi-nhom/[salesmanId]/`
- GET `/api_member_detail` + `/api_team_overview?salesman_id=X` (parallel)
- Personal tab → `/api_member_transactions`, `/api_member_inventory`, `/api_member_subordinates`
- Team tab → `/api_team_transactions`, `/api_team_inventory`, `/api_sub_members`
- GET `/api_salesman_tags` — header tags

### S5 · Activity History — `/doi-nhom/[salesmanId]/lich-su/`
- GET `/api_member_activity_log` — tab Cá nhân (eager)
- GET `/api_team_activity_log` — tab Đội nhóm (lazy)

---

## Unresolved questions

1. **`/xep-hang` (rank)** — endpoint nào trả leaderboard? Dùng `news_by_folder` với folder rank hay cần API riêng?
2. ~~**`/team` (team management)**~~ — ✅ Resolved 2026-04-22: 22 endpoints catalogged (02-api-catalog.md §13).
3. **Upload response shape** — heterogenous (`data.url` \| `data.data.url` \| `data.urls` \| `media_upload_id`); cần defensive parser util.
4. **`get_commission_default.json`** — return `commission_percent` là số (0-100) hay decimal (0-1)?
5. **`real_estate_v2.json` similar items** — confirm tham số `similar_to=<id>` có support không, hay phải gọi separate.
6. **`apartment_status.json` (bảng hàng)** — pagination? hay 1 lần trả full list?
7. **`contract_otp.json` channel values** — `sms` / `email` / số mapping?
8. **KYC polling interval** — sau submit `verify_agent`, FE poll `check_account_authentication` mỗi bao lâu? 30s? 60s?
9. **`dashboard_stats.json` shape** — confirm 4 keys cố định (`posted_news, caring_customers, deals_in_month, deposit_invoices`) hay dynamic theo `data.stats.data[]`?
10. **`home_blocks.json` schema** — `blocks[]` mỗi block kiểu gì? (banner, section bds, news?)

---

<a id="docs-05-be-handoff-consultation-actions-md"></a>

## docs/05-be-handoff-consultation-actions.md

---
title: "BE Handoff — Consultation detail actions (working-bds)"
type: be-handoff
date: 2026-05-07
status: draft
audience: BE team (Python Web2py V1)
related:
  - docs/02-api-catalog.md
  - docs/03-be-questions.md
  - docs/04-api-by-screen.md
  - src/components/nhu-cau/working-bds/
  - src/components/common/call-contact-dialog.tsx
  - src/components/appointments/create-appointment-dialog.tsx
  - src/components/deposit/create-deposit-dialog.tsx
  - src/components/bds/remind-verification-dialog.tsx
  - src/components/bds/share-bds-dialog.tsx
---

# BE Handoff — Detail Nhu cầu actions

> Context: FE đã build xong UI/UX cho các tương tác BDS-trong-nhu-cầu (working-bds activity panel) ở `/nhu-cau/{id}`. Mỗi tương tác đều có dialog popup, sample data và TODO comment trong code. Doc này list từng feature + endpoint đề xuất + payload + response shape để BE triển khai. **Tất cả endpoint dưới đây hiện chưa có** — FE đang dùng mock/localStorage.
>
> Convention chung: response wrapper `{status, message, data}` (theo `02-api-catalog.md`). Path namespace `/api_agent/*`. Header `Authorization: Bearer <token>`.

---

## 1. Working BDS pivot — list / add / remove

### Vấn đề hiện tại
FE Phase 1 lưu list BDS-trong-nhu-cầu ở **localStorage** (key `working_bds_<consultationId>`). Mỗi entry snapshot toàn bộ `BdsListItem` để tránh "BDS biến mất khi BE filter thay đổi". Không bền vững, không đa thiết bị.

### Endpoint đề xuất

**1.1 GET `/api_agent/get_consultation_property.json`**

| Param | Type | Required | Note |
|-------|------|----------|------|
| `consultation_id` | int | yes | ID nhu cầu |

**Response data:**
```jsonc
{
  "items": [
    {
      "bds": { /* BdsListItem shape, tham khảo real_estate_v4.json */ },
      "status": "pending_verify | interested | appointment | deposit",
      "owner": {                  // verified_by_agent_info đã chuẩn hoá
        "id": 5001,
        "name": "Nguyễn Văn Tâm",
        "phone": "0901234567",
        "avatar": null,
        "office_name": "CN Quận 7"
      },
      "related": {                // ID các bản ghi liên quan
        "appointment_id": 7001,
        "deposit_work_id": null,
        "verify_request_id": null
      },
      "added_at": "2026-05-06T09:00:00Z"
    }
  ]
}
```

Sample BDS đầy đủ field xem [`src/lib/working-bds/sample-bds-seed.ts`](../src/lib/working-bds/sample-bds-seed.ts) (2 BDS mẫu — nhà phố Q.7 + căn hộ Bình Thạnh).

**1.2 POST `/api_agent/add_consultation_property.json`**
```jsonc
{ "consultation_id": 1444, "real_estate_ids": [901001, 901002] }
```
Response: `{ added: 2 }`

**1.3 DELETE `/api_agent/remove_consultation_property.json`**
```jsonc
{ "consultation_id": 1444, "real_estate_id": 901001 }
```

### FE wiring khi BE ready
- Replace `fetchWorkingBds` / `addBdsToWorking` / `removeBdsFromWorking` trong [`src/lib/api/working-bds.ts`](../src/lib/api/working-bds.ts)
- Xoá `SAMPLE_WORKING_BDS_ITEMS` seed
- Brainstorm gốc: §10 Q1

---

## 2. Activity timeline cho BDS-trong-nhu-cầu

### UI
Mỗi BDS expanded row có panel "HOẠT ĐỘNG & GHI CHÚ" với timeline vertical:
- icon tròn trái (call/appointment/lead/note/deposit/verify)
- title + time
- meta chip màu (Đã kết nối / Không nghe máy / 08/05/2026 — 16:00...)
- body text (note/ghi chú nếu có)

### Endpoint đề xuất

**GET `/api_agent/get_consultation_property_activities.json`**

| Param | Type | Required |
|-------|------|----------|
| `consultation_id` | int | yes |
| `bds_id` | int | yes |
| `limit` | int | optional (default 50) |

**Response data:**
```jsonc
{
  "items": [
    {
      "id": "act-7001",
      "kind": "call | appointment | lead | note | deposit | verify",
      "title": "Anh Tâm gọi đầu chủ Nguyễn Văn Tâm (DC-5001)",
      "meta": "Đã kết nối",          // optional, render thành chip màu
      "body": "Đầu chủ xác nhận...",  // optional, full note
      "time": "5 phút trước",        // BE pre-format ngôn ngữ VN
      "highlight": "green | amber",  // optional, màu chip
      "actor": {                     // optional — render tên trong title
        "id": 123,
        "name": "Anh Tâm"
      }
    }
  ]
}
```

Sample timeline xem `DEMO_EVENTS` trong [`src/components/nhu-cau/working-bds/working-bds-row-expanded.tsx`](../src/components/nhu-cau/working-bds/working-bds-row-expanded.tsx) — 4 event mẫu (3 call outcome + 1 appointment + 1 lead).

### FE wiring khi BE ready
- Tạo `useConsultationBdsActivities(consultationId, bdsId)`
- Swap `getTimelineEvents()` → query result

---

## 3. Call outcome logging

### UI
Component reusable [`CallContactDialog`](../src/components/common/call-contact-dialog.tsx) dùng ở:
- Detail nhu cầu header → "Gọi chủ nhà" (context = consultation/customer)
- Working BDS row → "Gọi đầu chủ" (context = bds/owner)

Form: tên + sđt + nút Copy/Gọi → 4 outcome chip (Đã kết nối / Không nghe máy / Máy bận / Từ chối) → ô Ghi chú → Lưu.

### Endpoint đề xuất

**POST `/api_agent/log_call_outcome.json`**
```jsonc
{
  "context_type": "consultation | bds | deposit | contract",
  "context_id": 1444,
  "phone": "0356775969",
  "outcome": "connected | no_answer | busy | reject",
  "note": "Chủ nhà xác nhận muốn bán gấp..."  // optional
}
```

**Response data:**
```jsonc
{
  "id": 9001,
  "logged_at": "2026-05-07T03:24:00Z"
}
```

### Side-effect mong muốn
- Ghi vào activity log của context (consultation timeline + bds timeline)
- Trigger `kind: 'call'` event cho endpoint §2

---

## 4. Verify request — Nhắc / Tạo

### UI
Component [`RemindVerificationDialog`](../src/components/bds/remind-verification-dialog.tsx) tự switch 2 mode theo `owner`:
- **REMIND** (đã có đầu chủ + chưa xác thực): card đầu chủ + ghi chú → "Gửi nhắc nhở"
- **CREATE** (chưa có đầu chủ): empty state + ghi chú → "Tạo yêu cầu" (vào pool)

### Endpoint đề xuất

**4.1 POST `/api_agent/remind_verify_request.json`** — REMIND mode
```jsonc
{ "bds_id": 901001, "owner_id": 5001, "note": "Khách đang vội..." }
```

**4.2 POST `/api_agent/create_verify_request.json`** — CREATE mode
```jsonc
{ "bds_id": 901001, "note": "Khách đang vội..." }
```
Response: `{ verify_request_id: 8002 }` — FE cập nhật `related.verify_request_id` của working-bds item.

### Side-effect
- REMIND: push notification + (optional) SMS tới owner
- CREATE: enqueue vào pool, broadcast tới các CTV chi nhánh phù hợp
- Cả 2 ghi `kind: 'verify'` vào activity timeline (§2)

---

## 5. Appointment — Tạo lịch hẹn

### UI
Component [`CreateAppointmentDialog`](../src/components/appointments/create-appointment-dialog.tsx):
- Customer + BDS card cố định (pre-fill từ consultation + working-bds item)
- Inputs: Thời gian hẹn (datetime, required) + Địa điểm gặp + Ghi chú
- **Toggle "Tự động gửi thông báo cho chủ nhà"** (sub: "Sau khi đầu chủ xác nhận lịch hẹn") — default ON

### Endpoint đề xuất

**POST `/api_agent/create_appointment.json`**
```jsonc
{
  "customer_id": 12345,
  "real_estate_id": 901001,
  "appointment_datetime": "2026-05-08T16:00:00",
  "address": "Văn phòng Q1, 123 đường X",   // optional
  "note": "Khách yêu cầu xem buổi chiều",   // optional
  "notify_customer_after_owner_confirm": true  // toggle UI
}
```
**Response data:** `{ appointment_id: 7002 }`

### Flow notify đặc biệt
Khi `notify_customer_after_owner_confirm=true`:
1. BE chỉ gửi push/SMS cho **đầu chủ** trước (yêu cầu xác nhận)
2. Sau khi đầu chủ confirm trong app/web → BE gửi notification cho **khách hàng**
3. Khi `=false` → notify ngay tất cả parties

---

## 6. Deposit — Tạo đặt cọc + QR thanh toán

### UI
Component [`CreateDepositDialog`](../src/components/deposit/create-deposit-dialog.tsx) — 2 stage:

**Stage 1 (FORM):**
- Customer + BDS card cố định
- ❌ **Bỏ "Loại đặt cọc"** (không còn `deposit_type` 1/2)
- Số tiền cọc + 8 chips gợi ý (5tr / 10tr / 20tr / 50tr / 100tr / 200tr / 500tr / 1 tỷ) + đọc số bằng chữ
- Ghi chú

**Stage 2 (QR):** sau submit
- VietQR image
- Bank info rows (Ngân hàng, STK, Chủ TK, Số tiền, Nội dung CK) — mỗi row có nút Copy
- Status pill amber: "Chờ {KH} chuyển khoản — Hệ thống tự đối soát qua webhook ngân hàng"

### Endpoint đề xuất

**6.1 POST `/api_agent/create_deposit_work.json`**
```jsonc
{
  "table_name": "real_estate",
  "table_id": 901001,
  "customer_id": 12345,
  "deposit_amount": 50000000,
  "notes": "Cọc giữ chỗ 7 ngày"  // optional
}
```

**Response data:**
```jsonc
{
  "id": "DC-9001",
  "qr_url": "https://img.vietqr.io/image/TPB-0123456789-compact.png?amount=50000000&addInfo=DC%201444%20901001",
  "bank_name": "TPBank",
  "bank_account": "0123456789",
  "beneficiary": "CONG TY TONG KHO BDS",
  "transfer_memo": "DC 1444 901001",
  "amount": 50000000,
  "status": "pending",
  "expires_at": "2026-05-14T10:00:00Z"
}
```

**6.2 GET `/api_agent/get_deposit_status.json?deposit_id=DC-9001`** (poll, optional)
```jsonc
{ "status": "pending | paid | expired | cancelled", "paid_at": null }
```

### Webhook đối soát
Nếu BE đã có integration ngân hàng (Sepay/casso/MBBank webhook) → khi nhận được tiền, update status `pending → paid` và push notification cho cả KH + Agent. FE poll status hoặc subscribe real-time.

---

## 7. Note (Ghi chú) — đã đơn giản hoá

### UI
Component [`AddNoteDialog`](../src/components/nhu-cau/add-note-dialog/index.tsx):
- ❌ **Đã bỏ** "Loại ghi chú" pills
- ❌ **Đã bỏ** "Hiển thị" toggle (Riêng tư/Công khai)
- ❌ **Đã bỏ** "Ghim lên đầu" placeholder
- ✅ Còn: textarea (max 500 chars) + counter

### Endpoint hiện tại
`useCreateComment` — đã có. FE vẫn gửi `comment_type: 'note'` + `visibility: 'private'` mặc định để không phá API contract.

### Action BE (optional)
Có thể đơn giản hoá schema `comments` table — bỏ field `comment_type`/`visibility` không dùng nữa, hoặc giữ default. **Không gấp.**

---

## 8. Gửi khách hàng — link bài viết + lời nhắn + dual-log (2026-05-07 redesign)

### Đổi scope so với V1
~~News template (post_id/content/images grid)~~ — **đã bỏ**. Action giờ đơn giản: gửi LINK bài viết public + lời nhắn của Agent qua channel ngoài (Zalo / Messenger / App Tổng Kho).

### UI
Component [`ShareBdsDialog`](../src/components/bds/share-bds-dialog.tsx):
- Hiển thị mã + tiêu đề BDS (read-only)
- Input link bài viết: `https://tongkhobds.com/bds/{slug || id}` + nút Sao chép
- Textarea "Lời nhắn" — Agent tự nhập
- 3 nút channel: **Zalo** (deep-link `zalo.me/share?u=`) / **Messenger** (FB sharer fallback `facebook.com/sharer`) / **App Tổng Kho** (copy clipboard, no deep-link)

### Logging — yêu cầu BE
Khi user nhấn 1 trong 3 channel, FE gọi 2 lần `POST /api_agent/salesman_comments`:

```jsonc
// Log 1 — tab "Khách hàng" (consultation timeline)
{
  "table_id": <consultationId>,
  "tablename": "consultation",
  "comment_type": "note",
  "visibility": "private",
  "content": "Đã gửi BDS-1234 cho khách qua Zalo\n<lời nhắn>\nhttps://tongkhobds.com/bds/<slug>"
}

// Log 2 — tab "BDS" (real_estate timeline)
{
  "table_id": <bdsId>,
  "tablename": "real_estate",   // ← cần BE accept
  "comment_type": "note",
  "visibility": "private",
  "content": "<same as above>"
}
```

**Action BE cần làm:**
1. Confirm endpoint `salesman_comments` accept `tablename='real_estate'`. Nếu chưa, mở rộng controller để insert vào table comment chung (hoặc bảng `bds_activities` riêng).
2. Long-term: thay 2 call comment riêng bằng 1 endpoint hoạt động `POST /api_agent/log_send_property_to_customer` body `{consultation_id, real_estate_id, channel, message}` — BE tự fanout ra cả consultation + bds timeline + lưu channel kind cho analytics.
3. Activity tab "BDS" và "Khách hàng" (xem `consultation-works-tabs-card.tsx`) hiện FE đang DEMO — khi BE provide endpoint timeline (xem §Open Questions #2) thì hiển thị mới.

---

## 9. Bonus — Header detail "Gọi chủ nhà"

UI: button emerald đứng trước "Gán thẻ" + "Đóng nhu cầu". Mở `CallContactDialog` (xem §3) với context `consultation` và phone từ `consultation.customer_info.phone_number`.

Không cần endpoint mới — share endpoint với §3.

---

## Open Questions

1. **Pivot table schema:** BE có muốn tạo bảng `consultation_property` mới hay extend bảng có sẵn? Có cần `created_by` (CTV nào add)?
2. **Activity timeline:** BE có log sẵn ở `comments` table chung hay tạo bảng `activities` riêng? Format `time` text VN BE pre-format hay FE format từ ISO?
3. **Call outcome:** BE có tích hợp tổng đài ghi âm/duration tự động không? Hiện FE không có field duration (đã bỏ).
4. **Deposit QR:** BE đã có integration ngân hàng (Sepay/MBBank webhook)? Nếu chưa → status `paid` cần Agent xác nhận thủ công?
5. **Notify owner toggle:** flow "đợi đầu chủ confirm rồi mới notify khách" có khả thi với hệ notification hiện tại không? Cần thêm bảng `appointment_confirmations`?
6. **Share BDS:** endpoint `get_news_by_real_estate.json` đã sẵn sàng prod chưa? Response shape match Flutter consume?
7. **Owner field clarify** (brainstorm §10 Q2): `verified_by_agent_info` có thực sự là "đầu chủ" hay chỉ là "agent đã xác thực"? Nếu khác, BE cần expose field "đầu chủ" rõ ràng.

---

## Priority đề xuất

| Tier | Endpoint | Reason |
|------|----------|--------|
| P0 (blocking demo) | §1.1 GET working-bds list | Hiện FE dùng localStorage, không đa thiết bị |
| P0 | §2 GET activities | UI có rồi nhưng trống — demo client cảm thấy thiếu |
| P1 | §6.1 create_deposit + QR | Flow đặt cọc là core conversion funnel |
| P1 | §5 create_appointment + notify flow | Đã có endpoint cũ nhưng cần thêm `notify_customer_after_owner_confirm` |
| P2 | §3 log_call_outcome | UI lưu thành công nhưng chưa có nơi đọc lại — gắn vào §2 activity |
| P2 | §4 verify_request | Có thể dùng tạm `/xac-thuc-bds` page cũ |
| P3 | §1.2 / §1.3 add/remove | Có thể tiếp tục dùng localStorage tới khi BE ready |
| P3 | §8 confirm share endpoint | Có fallback OK |

---

<a id="docs-06-be-handoff-consultation-views-md"></a>

## docs/06-be-handoff-consultation-views.md

---
title: "BE Handoff — Consultation views (list + detail data shape)"
type: be-handoff
date: 2026-05-07
status: draft
audience: BE team (Python Web2py V1)
related:
  - docs/02-api-catalog.md
  - docs/03-be-questions.md
  - docs/04-api-by-screen.md
  - docs/05-be-handoff-consultation-actions.md
  - src/types/consultation.ts
  - src/lib/api/consultation.ts
  - src/lib/nhu-cau/format.ts
  - src/lib/nhu-cau/filter-url.ts
  - src/app/(dashboard)/nhu-cau/page.tsx
  - src/app/(dashboard)/nhu-cau/[id]/page.tsx
---

# BE Handoff — Nhu cầu (Consultation) views: list + detail

> Context: FE đã build xong **View Danh sách Nhu cầu** (`/nhu-cau`) và **View Chi tiết Nhu cầu** (`/nhu-cau/{id}`). Doc này liệt kê **mọi field FE đang đọc/render** + **shape FE expect** + **quirk hiện tại** để BE đối chiếu response của 2 endpoint chính:
>
> - `GET /api_agent/get_list_consultation` — list view + status tabs + filter
> - `GET /api_agent/get_detail_consultation/{id}` — detail view
>
> Doc này **chỉ spec data shape cho 2 view chính**. Actions (working-bds, deposit, appointment, share, …) đã có ở [05-be-handoff-consultation-actions.md](./05-be-handoff-consultation-actions.md).
>
> Convention: response wrapper `{status, message, data}` (`02-api-catalog.md`). Path namespace `/api_agent/*`. Header `Authorization: Bearer <token>`.

---

## 0. TL;DR — Việc BE cần làm

| # | Việc | Ưu tiên | Section |
|---|------|---------|---------|
| 1 | Confirm `get_list_consultation` trả đầy đủ field §2.1 (đặc biệt: `consultation_code`, `agent_support`, `post_office_name`, `tags[]`, `created_by_name`/`created_by{}`) | P0 | §2 |
| 2 | Confirm `get_detail_consultation/{id}` trả đầy đủ field §3.1 (đặc biệt: `user_support`, `customer_info`, `property_requirements`, `location_preferences[]` SearchItem shape, `notification_settings`, `stats`) | P0 | §3 |
| 3 | Confirm `list_status[]` trong response list — id chuẩn + count đã apply mọi filter trừ `demand_status` | P0 | §4 |
| 4 | Confirm filter params §5 (đặc biệt: `tag_id` repeated key + lowercase `or_and`, date range, search keyword) | P0 | §5 |
| 5 | Confirm `demand_status_name` shape `{name, color}` cho dynamic status badge | P1 | §3.5 |
| 6 | Trả `name_code` cho `user_support` / `agent_support` (đã pending — xem memory project-be-sales-off-users-name-code) | P1 | §3.6 |
| 7 | Bỏ inconsistency budget/area: chuẩn hoá về 1 shape (xem §6 quirks) | P2 | §6 |

---

## 1. Endpoint summary

### 1.1 List
`GET /api_agent/get_list_consultation`

```
Query: status?, demand_status?, search?, page?, limit?,
       office?, sales_off?, created_by?,
       start_date?, end_date?,
       city_id?, district_id?, ward_id?,
       tag_id (repeated)?, or_and (lowercase)?
```

Response wrapper:
```jsonc
{
  "status": "success",
  "message": "",
  "data": {
    "items": [ /* Demand[] — xem §2.1 */ ],
    "total": 1234,
    "page": 1,
    "limit": 20,
    "total_pages": 62,
    "list_status": [ /* StatusTab[] — xem §4 */ ]
  }
}
```

FE chấp nhận cả `data.items[]` lẫn `data[]` (top-level array) — xem `normalizeList` ở `src/lib/api/consultation.ts:21-53`. Khuyến nghị BE chuẩn hoá `data.items[]` để loại bỏ defensive parse.

### 1.2 Detail
`GET /api_agent/get_detail_consultation/{id}`

Response wrapper:
```jsonc
{
  "status": "success",
  "message": "",
  "data": { /* DemandDetail — xem §3.1 */ }
}
```

FE unwrap `data` trước khi parse (`unwrapData` ở `src/lib/api/consultation.ts:55-61`).

---

## 2. View Danh sách Nhu cầu — `/nhu-cau`

UI có 2 layout song song chia sẻ chung data: **desktop table** (`consultation-list-row.tsx`) và **mobile card** (`consultation-list-card.tsx`). Cả 2 đọc cùng `Demand` shape.

### 2.1 Field FE đang dùng cho mỗi item (`Demand`)

| FE field | Type | Bắt buộc | Render ở | Ghi chú |
|---|---|---|---|---|
| `id` | number\|string | **yes** | row key, link `/nhu-cau/{id}` | unique stable id |
| `consultation_code` | string | yes | cột STT (mã `#NC-2026-…`) | nếu thiếu, FE fallback `#{id}` |
| `consultation_id` | number\|string | optional | fallback cho code | |
| **Khách hàng** | | | | |
| `full_name` | string | yes | cột "Khách hàng" — tên (capitalize từng từ ở FE) | flat — BE-canonical |
| `customer_info.full_name` | string | optional | fallback cho `full_name` | nested |
| `customer_name` | string | optional | legacy fallback | |
| `customer.name` | string | optional | legacy fallback | |
| `phone_number` | string | yes | dòng phụ dưới tên (font-mono) | flat |
| `customer_info.phone_number` | string | optional | fallback | |
| `customer_phone` | string | optional | legacy fallback | |
| `customer_id` | number\|string | optional | dùng cho action "tạo lịch hẹn / đặt cọc" | |
| **Status** | | | | |
| `demand_status` | enum | yes | `'new'\|'active'\|'in_transaction'\|'completed'\|'cancelled'` | trở thành `id` của tab status |
| `demand_status_name` | `{name, color}` \| `''` | yes (object) | text + màu badge dynamic | nếu BE không có status → trả `''` (empty string), FE handle |
| `status` | enum | optional | legacy fallback cho `demand_status` | |
| **Nhu cầu (budget/area)** | | | | |
| `budget_min`, `budget_max` | number\|string | yes | cột "Nhu cầu" → "Giá: 5 - 10 tỷ" | flat top-level (BE-canonical) |
| `area_min`, `area_max` | number\|string | yes | "Diện tích: 50 - 80 m²" | flat |
| `property_requirements.budget_range.{min,max}` | nested | optional | fallback nếu flat thiếu | |
| `property_requirements.area_range.{min,max}` | nested | optional | fallback | |
| `min_price`/`max_price`/`min_area`/`max_area` | legacy | optional | last-resort fallback | |
| **Khu vực** | | | | |
| `interested_locations[]` | array | yes (list view) | cột "Khu vực" — chip đầu + `+N` | shape: `{name, boundaries: [{type,id,name,prefix,full_name}]}` |
| `interested_locations[].name` | string | yes | label chip | |
| `interested_locations[].boundaries[1].name` | string | optional | thành phố (sub-label) | index `[1]` = city |
| `interested_locations[].boundaries[2].name` | string | optional | tỉnh | |
| **VP / Phụ trách** | | | | |
| `post_office_name` | string | yes | cột "VP / Người phụ trách" — dòng 1 | hiện FE đang nhận field này từ BE |
| `post_office_id` | number\|string | yes | dùng cho dialog "Gán văn phòng" | |
| `post_office_code` | string | optional | reserved | |
| `agent_support` | object \| null | yes (list view) | dòng 2 — người phụ trách | shape: `{id, name, position_name_code, phone}` |
| `agent_support.position_name_code` | string | yes | badge ngắn (CTV/QL/GD) | |
| `team_members[]` | array | optional | (chưa render) | reserved |
| **Tags** | | | | |
| `tags[]` | array | yes | cột "Thẻ Tag" — mới nhất ngoài cùng | insertion order = oldest→newest, FE reverse khi render |
| `tags[].tag_id` \| `tags[].id` | number\|string | yes | unique key | |
| `tags[].tag_name` \| `tags[].name` | string | yes | label chip | |
| `tags[].tag_color` \| `tags[].color` | string (hex) | optional | màu chip | accept `#RRGGBB` hoặc `#RGB` |
| `tags[].tag_icon` \| `tags[].icon` | string | optional | icon name (chưa render hiện tại) | |
| `tags[].tag_code` \| `tags[].code` | string | optional | reserved | |
| `tags[].group_code` | string | optional | reserved | |
| **Người tạo + thời gian** | | | | |
| `created_by_name` | string | **yes (gap hiện tại)** | cột "Nguồn" → tên người tạo | flat — FE ưu tiên nhất |
| `creator_name` | string | optional | flat fallback | |
| `created_user_name` | string | optional | flat fallback | |
| `created_by` | object \| number | optional | nested fallback: `{full_name\|name\|first_name+last_name\|email}` | nếu là number ⇒ FE không render được |
| `created_on` | ISO string | yes | "Tạo {dd/MM/yyyy HH:mm}" | preferred |
| `created_at` | ISO string | optional | fallback | |
| `date` | ISO string | optional | last-resort fallback | |
| **Khác (optional)** | | | | |
| `source` | string | optional | mobile card — badge nguồn (manual/import/…) | |
| `notes` | string | optional | reserved | |

### 2.2 Layout map (desktop table)

| Cột | FE field gốc |
|---|---|
| Checkbox | `id` |
| STT + Code | `consultation_code` |
| Khách hàng | `full_name` + `phone_number` |
| Nhu cầu | `budget_min/max` + `area_min/area_max` |
| Khu vực | `interested_locations[0].name` (+ `+N`) |
| VP / Phụ trách | `post_office_name` + `agent_support.{name, position_name_code}` |
| Thẻ Tag | `tags[]` (newest first) |
| Nguồn | `created_by_name` + `created_on` |
| Trạng thái | `demand_status_name.{name,color}` |

### 2.3 Pagination

FE đọc `total`, `page`, `limit`, `total_pages` từ response. Nếu `total_pages` thiếu → FE tự tính `Math.ceil(total/limit)`.

### 2.4 Search bar

Input "Mã nhu cầu, SĐT khách hàng…" debounce 300ms → query `?q=<value>` → BE param `search`. BE nên match trên: `consultation_code`, `phone_number`, `full_name`.

---

## 3. View Chi tiết Nhu cầu — `/nhu-cau/{id}`

UI gồm 2 layout song song: **desktop 2-cột** + **mobile stack**. Component chính:
- `ConsultationDetailHeader` — avatar/tên/SĐT/status/tags/CTA
- `ConsultationNeedCard` — nhu cầu mong muốn (loại GD, budget, diện tích, khu vực, ghi chú, BDS quan tâm)
- `ConsultationCustomerTeamCard` — Người tạo, VP, Người phụ trách (timeline)
- `ConsultationStatsStrip` — 4 KPI: BDS đã thêm / Số đầu chủ / Số lịch hẹn / Thời gian xử lý
- `ConsultationWorksTabsCard` — tabs: BDS (working-bds), Khách hàng, Ghi chú nội bộ

### 3.1 Field FE đang dùng (`DemandDetail`)

`DemandDetail` extends `Demand` (§2.1) với các nested object dưới đây.

#### 3.1.1 `customer_info` (object, **yes**)
```jsonc
{
  "customer_id": 12345,
  "id": 12345,                    // alias cho customer_id
  "auth_user_id": 67890,
  "full_name": "Nguyễn Văn A",
  "phone_number": "0901234567",
  "email": "a@example.com"
}
```
FE dùng: tên trên header, sđt nút "Gọi", customer_id để khởi tạo appointment/deposit.

#### 3.1.2 `property_requirements` (object, **yes**)
```jsonc
{
  "transaction_type": 1,          // 1=Mua bán, 2=Cho thuê
                                  // — hoặc array: [{id:1, title:'Mua bán'}]
                                  // — hoặc string
  "property_type": [               // FE chấp nhận: array of {id,title} | array of id | string
    { "id": 5, "title": "Nhà phố" }
  ],
  "budget_range": { "min": 5000000000, "max": 10000000000 },
  "area_range":   { "min": 50, "max": 80 },
  "floors_range": { "min": 2, "max": 5 },
  "bedrooms": [2, 3],
  "bathrooms_min": 2,

  // Legacy flat (FE fallback):
  "budget_min": 5000000000, "budget_max": 10000000000,
  "area_min": 50, "area_max": 80,
  "bedrooms_min": 2, "bedrooms_max": 3
}
```
**Quirk:** FE đang accept cả nested `*_range.{min,max}` lẫn flat `*_min/*_max` trong cùng object. Khuyến nghị BE chuẩn hoá về **nested**.

`property_type` items có thể là number (id) → FE phải gọi `usePropertyTypes()` để map ra label. Nếu BE trả `{id, title}` luôn thì FE skip lookup → giảm 1 request.

#### 3.1.3 `location_preferences` (array, **yes** — KHÁC list view)

**Detail trả mảng `SearchItem[]`** (KHÁC list view dùng `interested_locations[]` flat):
```jsonc
[
  {
    "id": 79,
    "name": "Quận 7",
    "slug": "quan-7",
    "type": "district",
    "search_count": 100,
    "boundaries": [
      { "type": 1, "id": 79, "name": "Quận 7", "prefix": "Quận", "full_name": "Quận 7" },
      { "type": 2, "id": 1,  "name": "TP. Hồ Chí Minh" },
      { "type": 3, "id": 1,  "name": "Việt Nam" }
    ]
  }
]
```

Legacy fallback (FE accept): `location_preferences` là **object** `{interested_cities[], interested_districts[], interested_wards[], interested_projects[]}`. BE nên **bỏ shape object** trong response detail mới, chỉ trả array.

#### 3.1.4 `preferences` (object, optional)
```jsonc
{
  "preferred_directions": ["Đông Nam", "Tây Bắc"],
  "legal_requirements": ["Sổ hồng riêng"],
  "furniture_requirements": "Đầy đủ nội thất",
  "special_requirements": "Gần trường học",
  "note": "Khách yêu cầu xem buổi tối"
}
```
FE render `preferences.note` trong card "Nhu cầu mong muốn" → fallback `notes` flat string nếu thiếu.

#### 3.1.5 `status_info` (object, optional)
```jsonc
{
  "demand_status": "active",
  "status_changed_on": "2026-05-01T10:00:00Z",
  "status_reason": "Khách quay lại sau 6 tháng"
}
```
FE đọc `status_info.demand_status` làm fallback nếu top-level `demand_status` thiếu.

#### 3.1.6 `notification_settings` (object, optional)
**GET shape (FE đọc):**
```jsonc
{
  "push_enabled": true,
  "sms_enabled": false,
  "daily_limit": 5
}
```

**CREATE/UPDATE shape (FE gửi):**
```jsonc
{
  "enable_push_notification": true,
  "enable_sms_notification": false,
  "max_notifications_per_day": 5
}
```
BE asymmetric → FE tự map qua `toCreateNotificationSettings()` (xem `types/consultation.ts:199`). Khuyến nghị BE đồng bộ key giữa GET/POST/PUT.

#### 3.1.7 `stats` (object, optional)
```jsonc
{
  "priority_score": 85,
  "total_suggestions_sent": 12,
  "suggestions_today": 2,
  "last_matched": "2026-05-06T15:30:00Z",
  "view_count": 45,
  "contact_count": 3
}
```
Hiện FE chưa render đầy đủ — chỉ dự phòng cho card stats nâng cao (phase 2). KPI strip hiện tại derive client-side từ working-bds list (xem §3.4 STATS_STRIP).

#### 3.1.8 `user_support` (object, **yes** — detail view)
```jsonc
{
  "id": 5001,
  "auth_user_id": 9001,
  "name": "Nguyễn Văn Tâm",
  "name_code": "CTV",            // ⚠️ pending BE — xem memory
  "phone": "0901234567",
  "email": "tam@example.com",
  "img_url": "https://…",
  "created_on": "2025-01-15",
  "status": 1,
  "contact_facebook": "fb.com/tam",
  "count_customers": 45,
  "count_trans": 12,
  "count_real_estate": 80
}
```

**Quirk inconsistency list ↔ detail:** list endpoint trả `agent_support.{position_name_code}` còn detail trả `user_support.{name_code}`. FE tự fallback (xem `pickSalesName()` ở `format.ts:168-193`). Khuyến nghị BE thống nhất key: `name_code` hoặc `position_name_code` — chọn 1.

#### 3.1.9 `property` (object, optional) — BDS đính kèm chính
```jsonc
{
  "id": 901001,
  "name": "Nhà phố MT Q7",
  "code": "BDS-901001",
  "address": "123 Nguyễn Thị Thập",
  "full_address": "...",
  "price": 8000000000,
  "area": 75,
  "transaction_type": 1,
  "transaction_type_info": { "id": 1, "name": "Mua bán" },
  "property_type": 5,
  "property_type_info": { "id": 5, "name": "Nhà phố" },
  "bedrooms": 3,
  "bathrooms": 3,
  "floors": 4,
  "main_image": "https://…",
  "list_images": ["url1", "url2"],
  "count_image": 8,
  "description": "...",
  "created_on": "..."
}
```
Render mobile-only ở `ConsultationNeedCardMobile` ("BDS/Dự án quan tâm"). Desktop list "BDS Quan Tâm" được tách riêng → gọi `/api_agent/demand_suggest.json` (suggested-bds).

#### 3.1.10 `project` (object, optional)
Tương tự `ProjectLite` — chưa render hiện tại, reserved.

#### 3.1.11 `transaction_deposit` (object, optional)
```jsonc
{
  "deposit_type": { "value": "buyer", "label": "Cọc khách" },
  "deposit_amount": 50000000
}
```
Reserved — render trong badge "Đã đặt cọc" nếu có (chưa wire).

#### 3.1.12 Arrays chưa modeled (FE giữ `unknown[]`)

| Field | Mục đích | Status |
|---|---|---|
| `works[]` | Lịch sử công việc/hành động | Reserved — sẽ render ở tab "Khách hàng" detail |
| `interests[]` | BDS khách quan tâm thủ công | Reserved |
| `comments[]` | Inline comments (alternative cho /salesman_comments) | Hiện FE dùng endpoint riêng `/api_agent/salesman_comments` |
| `suggested_bds[]` | BDS gợi ý (alternative cho /demand_suggest) | Reserved — ưu tiên endpoint riêng |
| `notification_schedule` | Lịch gửi gợi ý | Reserved |
| `matching_criteria` | Tiêu chí match | Reserved |

### 3.2 Header detail (`ConsultationDetailHeader`)

| UI element | FE field |
|---|---|
| Tên khách | `customer_info.full_name` → `full_name` → `customer_name` |
| Mã `#{id}` | `id` |
| SĐT (nút tel:) | `customer_info.phone_number` → `phone_number` → `customer_phone` |
| "Tạo {dd/MM/yyyy}" | `created_on` → `created_at` |
| "{N} ngày" | derive từ `created_on` |
| Badge status | `demand_status_name.{name,color}` (priority) → fallback static map |

### 3.3 Card "Nhân sự liên quan" (`ConsultationCustomerTeamCard`)

| Row | FE field |
|---|---|
| Người tạo | `created_by_name` (flat) → `created_by.{full_name\|name\|first_name+last_name\|email}` |
| Văn phòng | `post_office_name` (+ `post_office_id` cho dialog gán) |
| Người phụ trách | `user_support.{name, name_code, phone}` (priority) → `agent_support.{name, position_name_code, phone}` |

### 3.4 Stats strip — derive client-side (informational)

FE đang **derive** từ working-bds + comments thay vì đọc field BE:

| KPI | Derive từ |
|---|---|
| BDS đã thêm | `working_bds[].length` (hiện localStorage — xem doc 05 §1) |
| Số đầu chủ | `unique(working_bds[].owner.id)` count |
| Số lịch hẹn | `working_bds[].related.appointment_id != null` count |
| Thời gian xử lý | `now - created_on` (days) |

Khi BE provide endpoint working-bds (doc 05 §1.1) → các KPI sẽ chuẩn xác.

### 3.5 Status badge

```jsonc
"demand_status_name": { "name": "Đang xử lý", "color": "#10B981" }
// HOẶC khi BE chưa có status:
"demand_status_name": ""
```
FE handle cả 2 trường hợp: object + empty string. **Yêu cầu**: nếu trả color, phải là hex valid (`#RRGGBB` hoặc `#RGB`).

### 3.6 Pending BE — `name_code`

Hiện `sales_off_users` (filter dropdown user phụ trách) chưa trả `office_position.name_code` → FE fallback bằng heuristic. Cùng issue cho `user_support.name_code` ở detail. Xem memory `project-be-sales-off-users-name-code.md`.

---

## 4. Status tabs — `list_status[]`

UI tabs ở list view:

```jsonc
"list_status": [
  { "id": "all",            "name": "Tất cả",        "count": 1234, "color": null },
  { "id": "new",            "name": "Mới",           "count": 45,   "color": "#3B82F6" },
  { "id": "active",         "name": "Đang xử lý",    "count": 789,  "color": "#10B981" },
  { "id": "in_transaction", "name": "Đang giao dịch","count": 12,   "color": "#F59E0B" },
  { "id": "completed",      "name": "Hoàn thành",    "count": 350,  "color": "#6B7280" },
  { "id": "cancelled",      "name": "Đã huỷ",        "count": 38,   "color": "#EF4444" }
]
```

| Field | Required | Note |
|---|---|---|
| `id` | yes | match với `demand_status` enum (`new\|active\|in_transaction\|completed\|cancelled`) hoặc `'all'` |
| `name` | yes | label tab |
| `count` | yes | số nhu cầu trong status đó **đã apply mọi filter trừ `demand_status`** |
| `color` | optional | hex màu badge count (chưa render) |

**Yêu cầu critical:** count tab phải đếm theo filter context — khi user áp `office=5` thì count mỗi tab chỉ đếm trong office 5. FE đang gọi 1 request riêng `useConsultationStatusCounts()` với `page=1, limit=1` để lấy `list_status[]` mà không phụ thuộc vào tab đang active. Nếu BE đảm bảo điều này → FE có thể tận dụng `list_status[]` từ response chính → tiết kiệm 1 request.

Fallback FE (khi `list_status` thiếu hoặc rỗng): `[all, new, active, completed]` (không count) — xem `consultation-status-tabs.tsx:7-12`.

---

## 5. Filter params

Tất cả param đều **GET query**.

| Param | Type | Note |
|---|---|---|
| `demand_status` | enum string | `'new'\|'active'\|'in_transaction'\|'completed'\|'cancelled'` — bỏ qua nếu `'all'` |
| `status` | enum string | alias cho `demand_status` (BE legacy) |
| `search` | string | full-text: code + phone + name |
| `page` | int | default 1 |
| `limit` | int | default 20, clamp [1, 100] |
| `office` | int | filter theo `post_office_id` |
| `sales_off` | int | filter theo `agent_support.id` (người phụ trách) |
| `created_by` | int | filter theo `created_by.id` (người tạo) |
| `start_date` | date `YYYY-MM-DD` | filter created_on |
| `end_date` | date `YYYY-MM-DD` | filter created_on |
| `city_id` | int | filter location |
| `district_id` | int | filter location |
| `ward_id` | int | filter location |
| `tag_id` | repeated int | **MUST be repeated key**, KHÔNG dùng CSV |
| `or_and` | enum (lowercase) | `'or'\|'and'\|'not'` — chỉ gửi khi có `tag_id` |

### 5.1 Tag filter quirk (**critical**)

Per memory `project-nhu-cau-consultation.md` + comment trong `consultation.ts:108-122`:

- `tag_id` **phải** là repeated key web2py vars list:
  ```
  ?tag_id=69&tag_id=62&tag_id=42
  ```
  KHÔNG được dùng CSV `?tag_id=69,62,42` — BE code `[int(tid) for tid in tag_ids]` sẽ crash với `int("69,62")`.

- `or_and` **phải lowercase**: `'or'|'and'|'not'`. Uppercase fallback default `'any'` → AND/NOT không có tác dụng (BE `consultation_manager.py:255`).

- Chỉ gửi `or_and` khi có `tag_id` — mirror BDS pattern.

### 5.2 URL-encoding

FE dùng [Next.js searchParams] giữ filter ở URL. Filter nào trống → xoá khỏi URL (xem `applyPatchToSearchParams()` ở `filter-url.ts:107-150`).

---

## 6. Quirks hiện tại + đề xuất chuẩn hoá

### 6.1 Customer name/phone — 4 paths
FE đang fallback theo thứ tự:
```
full_name | customer_info.full_name | customer_name | customer.name
phone_number | customer_info.phone_number | customer_phone
```
**Đề xuất:** BE chuẩn hoá về **flat top-level** `full_name` + `phone_number` (cả list + detail) + giữ `customer_info` cho payload create/update. Bỏ `customer_name`, `customer_phone`, `customer.name`.

### 6.2 Budget/Area — 4 paths
```
property_requirements.budget_range.{min,max}
| property_requirements.budget_min/max
| budget_min/budget_max (top-level flat)
| min_price/max_price (legacy)
```
**Đề xuất:** chỉ trả **nested** `property_requirements.budget_range.{min,max}` ở detail; **flat** `budget_min/budget_max` ở list. Bỏ `min_price/max_price`.

### 6.3 Date fields — 3 paths
```
created_on | created_at | date
updated_on | updated_at
```
**Đề xuất:** dùng **`created_on` / `updated_on`** xuyên suốt (Web2py convention). Bỏ `created_at`, `updated_at`, `date`.

### 6.4 Status path
```
demand_status (top-level)
| status (alias)
| status_info.demand_status (nested)
```
**Đề xuất:** giữ `demand_status` top-level + `demand_status_name` cho display. `status_info` chỉ chứa metadata phụ (`status_changed_on`, `status_reason`). Bỏ `status` alias.

### 6.5 Sales support — list ↔ detail naming
```
list:   agent_support.position_name_code
detail: user_support.name_code
```
**Đề xuất:** thống nhất **`user_support.name_code`** ở cả 2 endpoint (giống Flutter).

### 6.6 Tag fields — dual naming
```
tag_id | id
tag_name | name
tag_color | color
tag_icon | icon
tag_code | code
```
**Đề xuất:** chuẩn hoá về `tag_id`, `tag_name`, `tag_color`, `tag_icon`, `tag_code` (prefix rõ ràng tránh va với entity-level `id/name`).

### 6.7 Tag insertion order
BE trả `tags[]` theo **insertion order** (oldest → newest). FE phải reverse khi render (mới nhất ngoài cùng). Khuyến nghị: BE trả thẳng newest-first, hoặc thêm `tags_added_at` để FE tự sort.

### 6.8 Notification settings — GET vs CREATE/UPDATE asymmetric
```
GET:     push_enabled / sms_enabled / daily_limit
POST/PUT: enable_push_notification / enable_sms_notification / max_notifications_per_day
```
**Đề xuất:** đồng bộ về 1 set keys (preferred GET keys vì ngắn).

### 6.9 `interested_locations` (list) ≠ `location_preferences` (detail)

List view: flat array `interested_locations[]` với shape `{name, boundaries[]}`.

Detail view: `location_preferences[]` SearchItem với shape `{id, name, slug, type, boundaries[]}`.

**Đề xuất:** dùng `location_preferences[]` SearchItem ở **cả** list và detail. Bỏ `interested_locations[]`.

### 6.10 `transaction_type` — 3 shapes
```
number (1|2)
| array of {id, title}
| string
```
FE accept all (xem `transactionLabel()` ở `consultation-need-card.tsx:63-83`). **Đề xuất:** trả **`{id, name}` object** (đồng bộ với `property.transaction_type_info`). Bỏ raw number/string.

### 6.11 Property type — number ⇒ FE phải lookup
Nếu trả `property_type: [5]` → FE gọi `usePropertyTypes()` để map ra label. Nếu trả `[{id:5, title:'Nhà phố'}]` → FE skip lookup. **Đề xuất:** luôn trả `[{id, title}]` (giảm 1 request mỗi lần render detail).

---

## 7. JSON example — full happy path

### 7.1 List response (1 item)

```jsonc
{
  "status": "success",
  "message": "",
  "data": {
    "items": [
      {
        "id": 1444,
        "consultation_code": "NC-2026-0512",
        "consultation_id": 1444,

        "full_name": "Nguyễn Văn A",
        "phone_number": "0901234567",
        "customer_id": 12345,

        "demand_status": "active",
        "demand_status_name": { "name": "Đang xử lý", "color": "#10B981" },

        "created_on": "2026-05-01T08:30:00Z",
        "updated_on": "2026-05-06T10:15:00Z",

        "budget_min": 5000000000,
        "budget_max": 10000000000,
        "area_min": 50,
        "area_max": 80,

        "interested_locations": [
          {
            "name": "Quận 7",
            "boundaries": [
              { "type": 1, "id": 79, "name": "Quận 7" },
              { "type": 2, "id": 1,  "name": "TP. Hồ Chí Minh" }
            ]
          },
          {
            "name": "Nhà Bè",
            "boundaries": [
              { "type": 1, "id": 80, "name": "Nhà Bè" },
              { "type": 2, "id": 1,  "name": "TP. Hồ Chí Minh" }
            ]
          }
        ],

        "tags": [
          { "tag_id": 12, "tag_name": "Cấp bách",  "tag_color": "#EF4444" },
          { "tag_id": 18, "tag_name": "VIP",       "tag_color": "#F59E0B" }
        ],

        "post_office_id": 5,
        "post_office_name": "CN Quận 7",
        "post_office_code": "Q7",

        "agent_support": {
          "id": 5001,
          "name": "Trần Văn Tâm",
          "position_name_code": "CTV",
          "phone": "0987654321"
        },

        "created_by_name": "Lê Thị B",
        "created_by": { "id": 9001, "name": "Lê Thị B", "email": "b@example.com" }
      }
    ],
    "total": 1234,
    "page": 1,
    "limit": 20,
    "total_pages": 62,
    "list_status": [
      { "id": "all",            "name": "Tất cả",        "count": 1234 },
      { "id": "new",            "name": "Mới",           "count": 45 },
      { "id": "active",         "name": "Đang xử lý",    "count": 789 },
      { "id": "in_transaction", "name": "Đang giao dịch","count": 12 },
      { "id": "completed",      "name": "Hoàn thành",    "count": 350 },
      { "id": "cancelled",      "name": "Đã huỷ",        "count": 38 }
    ]
  }
}
```

### 7.2 Detail response

```jsonc
{
  "status": "success",
  "message": "",
  "data": {
    "id": 1444,
    "consultation_code": "NC-2026-0512",
    "consultation_id": 1444,

    "customer_info": {
      "customer_id": 12345,
      "id": 12345,
      "auth_user_id": 67890,
      "full_name": "Nguyễn Văn A",
      "phone_number": "0901234567",
      "email": "a@example.com"
    },

    "demand_status": "active",
    "demand_status_name": { "name": "Đang xử lý", "color": "#10B981" },

    "created_on": "2026-05-01T08:30:00Z",
    "updated_on": "2026-05-06T10:15:00Z",

    "property_requirements": {
      "transaction_type": { "id": 1, "name": "Mua bán" },
      "property_type": [{ "id": 5, "title": "Nhà phố" }],
      "budget_range": { "min": 5000000000, "max": 10000000000 },
      "area_range":   { "min": 50, "max": 80 },
      "floors_range": { "min": 2, "max": 5 },
      "bedrooms": [3],
      "bathrooms_min": 2
    },

    "location_preferences": [
      {
        "id": 79,
        "name": "Quận 7",
        "slug": "quan-7",
        "type": "district",
        "boundaries": [
          { "type": 1, "id": 79, "name": "Quận 7", "prefix": "Quận", "full_name": "Quận 7" },
          { "type": 2, "id": 1,  "name": "TP. Hồ Chí Minh" }
        ]
      }
    ],

    "preferences": {
      "preferred_directions": ["Đông Nam"],
      "legal_requirements": ["Sổ hồng riêng"],
      "furniture_requirements": "Đầy đủ nội thất",
      "special_requirements": "Gần trường học",
      "note": "Khách yêu cầu xem buổi tối"
    },

    "status_info": {
      "demand_status": "active",
      "status_changed_on": "2026-05-01T10:00:00Z",
      "status_reason": null
    },

    "notification_settings": {
      "push_enabled": true,
      "sms_enabled": false,
      "daily_limit": 5
    },

    "stats": {
      "priority_score": 85,
      "total_suggestions_sent": 12,
      "suggestions_today": 2,
      "last_matched": "2026-05-06T15:30:00Z",
      "view_count": 45,
      "contact_count": 3
    },

    "post_office_id": 5,
    "post_office_name": "CN Quận 7",

    "user_support": {
      "id": 5001,
      "auth_user_id": 9001,
      "name": "Trần Văn Tâm",
      "name_code": "CTV",
      "phone": "0987654321",
      "email": "tam@example.com",
      "img_url": "https://cdn.tongkhobds.com/avatar/5001.jpg",
      "created_on": "2025-01-15",
      "status": 1,
      "count_customers": 45,
      "count_trans": 12,
      "count_real_estate": 80
    },

    "tags": [
      { "tag_id": 12, "tag_name": "Cấp bách", "tag_color": "#EF4444", "tag_code": "URGENT" },
      { "tag_id": 18, "tag_name": "VIP",      "tag_color": "#F59E0B", "tag_code": "VIP" }
    ],

    "created_by_name": "Lê Thị B",
    "created_by": {
      "id": 9001,
      "name": "Lê Thị B",
      "full_name": "Lê Thị B",
      "email": "b@example.com"
    },

    "property": null,
    "project": null,
    "transaction_deposit": null,

    "works": [],
    "interests": [],
    "comments": [],
    "suggested_bds": []
  }
}
```

---

## 8. Open Questions (BE clarify)

1. **`list_status[]` filter context:** count mỗi tab có đang đếm theo **toàn bộ filter trừ `demand_status`** không? Nếu có, FE bỏ request `useConsultationStatusCounts` riêng được — tiết kiệm 1 round-trip.
2. **`created_by_name` vs `created_by`:** BE đang trả flat hay nested? Hiện FE prefer flat. Nếu chỉ có nested → confirm shape (`{id, name}` đủ chưa, có cần `email`?).
3. **`interested_locations[].boundaries[]` order:** index `[0]=ward/district, [1]=city, [2]=country` có đúng convention BE không? FE đang giả định vậy.
4. **`agent_support` vs `user_support`:** đồng ý hợp nhất về `user_support` ở cả 2 endpoint (xem §6.5)? Cần migration legacy clients?
5. **`tags[].insertion_order`:** BE có thể đảo về **newest-first** trong response không, hay FE tự reverse? Nếu giữ oldest-first → có cách nào (ngày gắn) để FE biết "thẻ mới" thực sự?
6. **`property_type` lookup:** detail trả `[{id, title}]` luôn được không? Tránh FE phải gọi thêm `/api_agent/get_property_types`.
7. **`property` (PropertyLite) vs `/api_agent/demand_suggest`:** card "BDS quan tâm" (mobile) đang đọc `linked_property` (legacy) — có thể thay bằng cùng `demand_suggest` items không, hay vẫn cần field riêng?
8. **`transaction_deposit`:** khi nào BE populate field này? Có nhu cầu hiển thị badge "Đang đặt cọc" trên list không?
9. **`name_code` cho user_support / sales_off_users:** ETA trả field `office_position.name_code` (đang pending — memory ghi 2026-04 chưa có).
10. **Date timezone:** `created_on` BE trả UTC hay local Asia/Ho_Chi_Minh? FE đang `new Date(iso)` → trình duyệt tự convert. Cần BE confirm.

---

## 9. References

- FE source code:
  - Types: [`src/types/consultation.ts`](../src/types/consultation.ts)
  - API client: [`src/lib/api/consultation.ts`](../src/lib/api/consultation.ts)
  - Format helpers: [`src/lib/nhu-cau/format.ts`](../src/lib/nhu-cau/format.ts)
  - Filter URL: [`src/lib/nhu-cau/filter-url.ts`](../src/lib/nhu-cau/filter-url.ts)
  - List page: [`src/app/(dashboard)/nhu-cau/page.tsx`](../src/app/(dashboard)/nhu-cau/page.tsx)
  - Detail page: [`src/app/(dashboard)/nhu-cau/[id]/page.tsx`](../src/app/(dashboard)/nhu-cau/[id]/page.tsx)
  - List components: [`src/components/nhu-cau/consultation-list-row.tsx`](../src/components/nhu-cau/consultation-list-row.tsx) · [`consultation-list-card.tsx`](../src/components/nhu-cau/consultation-list-card.tsx)
  - Detail components: [`consultation-detail-header.tsx`](../src/components/nhu-cau/consultation-detail-header.tsx) · [`consultation-need-card.tsx`](../src/components/nhu-cau/consultation-need-card.tsx) · [`consultation-customer-team-card.tsx`](../src/components/nhu-cau/consultation-customer-team-card.tsx) · [`consultation-stats-strip.tsx`](../src/components/nhu-cau/consultation-stats-strip.tsx)
- Related docs:
  - Actions handoff: [`docs/05-be-handoff-consultation-actions.md`](./05-be-handoff-consultation-actions.md)
  - API catalog: [`docs/02-api-catalog.md`](./02-api-catalog.md)
  - BE pending questions: [`docs/03-be-questions.md`](./03-be-questions.md)
- BE reference: `consultation_manager.py` (filter logic + `_apply_tag_filter`)

---

*Generated 2026-05-07. FE phía Web Agent — Next.js 15. Doc này là spec, không phải plan implementation.*

---

<a id="docs-06-xac-thuc-bds-flow-md"></a>

## docs/06-xac-thuc-bds-flow.md

# Xác thực BDS — Flow & Framework

> Canonical doc cho flow Xác thực BDS (Real Estate Verification). Dùng khi impl/modify tính năng liên quan.

## Overview

**Scope**: Quản lý hồ sơ xác thực BĐS — từ tạo mới, gán đầu chủ, xác nhận, đến phê duyệt/từ chối.

**Screens**:
| Route | File | Purpose |
|-------|------|---------|
| `/xac-thuc-bds` | `app/(dashboard)/xac-thuc-bds/page.tsx` | List + filter |
| `/xac-thuc-bds/[id]` | `app/(dashboard)/xac-thuc-bds/[id]/page.tsx` | Detail + tabs |
| `/xac-thuc-bds/[id]/edit` | `app/(dashboard)/xac-thuc-bds/[id]/edit/page.tsx` | Form nhập/sửa |

**Key actors**:
- **CTV** (Sales): Tạo verification, nhập thông tin pháp lý
- **Đầu chủ** (Listing Manager): Xác nhận thông tin, confirm trước khi phê duyệt
- **Trưởng phòng / GĐ Khối**: Assign đầu chủ, view, monitor
- **Admin VP / Listing Verifier**: Phê duyệt cuối cùng, approve/reject

---

## Architecture

### Data Flow

```
BE (Web2py) → Route Handler (/api/verification/*) → ofetch → TanStack Query → Component
                ↓
         lib/api/verification.ts  (API client)
                ↓
         lib/xac-thuc-bds/be-to-fe-mapper.ts  (BE → FE shape)
                ↓
         types/verification.ts  (VerificationRecord)
                ↓
         Component props/state
```

### State Management

| Type | Hook | Purpose |
|------|------|---------|
| **Server state** | `useVerifications()` | List data (cache 30s) |
| | `useVerificationDetail(id)` | Detail data (cache 60s) |
| | `useListingManagers()` | Dropdown assign (cache 60s) |
| **Mutations** | `useAssignListingManager()` | Giao đầu chủ |
| | `useConfirmVerification()` | Đầu chủ xác nhận |
| | `useApproveVerification()` | Phê duyệt |
| | `useRejectVerification()` | Từ chối |
| | `useRequestVerificationRecheck()` | Yêu cầu verify lại |
| **Local state** | Component `useState` | Filter, selected, modals |

### Key Files

```
src/
├── app/(dashboard)/xac-thuc-bds/
│   ├── page.tsx              # List (desktop + mobile)
│   └── [id]/
│       ├── page.tsx          # Detail + tabs
│       └── edit/page.tsx     # Form nhập/sửa
├── components/xac-thuc-bds/
│   ├── verification-list-table.tsx    # Desktop table
│   ├── verification-list-card.tsx     # Mobile card
│   ├── verification-filter-bar.tsx    # Filter UI
│   ├── verification-status-tabs.tsx   # Tab filter by status
│   ├── verification-active-chips.tsx  # Active filter badges
│   ├── verification-filter-sheet.tsx  # Mobile filter sheet
│   ├── detail/
│   │   ├── verification-detail-info-tab.tsx
│   │   └── verification-detail-public-tab.tsx
│   └── modals/
│       ├── assign-manager-dialog.tsx
│       ├── assign-owner-dialog.tsx
│       ├── confirm-verification-dialog.tsx
│       └── reject-verification-dialog.tsx
├── hooks/use-verifications.ts          # TanStack Query wrappers
├── lib/api/verification.ts             # API client (ofetch)
├── lib/xac-thuc-bds/
│   ├── be-to-fe-mapper.ts              # BE → FE mapper
│   ├── verification-status.ts          # Status constants + helpers
│   └── verification-mock-data.ts       # Mock data for dev
└── types/verification.ts               # TypeScript types + Zod schemas
```

---

## Status Flow

### BE ↔ FE Status Mapping

| BE int | FE status | Label | Actions |
|--------|-----------|-------|---------|
| 4 | `pending_assign` | Chờ gán | Giao đầu chủ |
| 5 | `pending_confirm` | Chờ xác nhận | Đầu chủ confirm |
| 1 | `pending_approval` | Chờ phê duyệt | Phê duyệt / Từ chối |
| 2 | `success` | Đã duyệt | View only |
| 3 | `rejected` | Từ chối | Yêu cầu verify lại |

**Source of truth**: `types/verification.ts` → `BE_STATUS_TO_FE`, `FE_STATUS_TO_BE`

### Transitions

```
[pending_assign] ──assign──> [pending_confirm] ──confirm──> [pending_approval]
                                                 │
                                                 ├─approve──> [success]
                                                 └─reject───> [rejected]
                                                                │
                                                   request_recheck │
                                                                ↓
                                                     [pending_confirm]
```

---

## Component Tree (List Page)

```
XacThucBdsListPage
├── Desktop (≥md)
│   ├── Header (title + actions)
│   ├── FilterBar (OfficeSelect, UserSelect, DateRange, TagFilter, FilterBtn)
│   ├── VerificationActiveChips
│   ├── VerificationStatusTabs
│   ├── SubBar (bulk actions when selected)
│   ├── VerificationListTable
│   └── Pagination
├── Mobile (<md)
│   ├── AppBar (title + create btn)
│   ├── SearchBar (search + filter btn)
│   ├── VerificationActiveChips
│   ├── VerificationStatusTabs (variant=mobile)
│   └── VerificationListCard[]
└── Modals (shared)
    ├── VerificationFilterSheet
    ├── AssignOwnerDialog
    └── AssignManagerDialog
```

---

## Patterns & Conventions

### 1. BE → FE Mapping

**Never use BE response directly in components**. Always map via `be-to-fe-mapper.ts`.

```ts
// ❌ Bad
const title = item.real_estate?.title ?? '—';

// ✅ Good
const record = mapBeToVerificationRecord(item);
const title = record.bdsTitle;
```

**Why**: BE shape heterogenous, may change. Mapper centralizes defensive parsing.

### 2. Status Constants

Use `beStatusToFe()` for conversion, never hardcode:

```ts
// ❌ Bad
const status = item.verification_status === 5 ? 'pending_confirm' : ...;

// ✅ Good
const status = beStatusToFe(item.verification_status);
```

### 3. Query Keys

Centralized in `hooks/use-verifications.ts`:

```ts
const KEYS = {
  list: (q: VerificationListQuery) => ['verifications', 'list', q] as const,
  detail: (id: string | number) => ['verifications', 'detail', id] as const,
  managers: (q: ListingManagerQuery) => ['verifications', 'listing-managers', q] as const,
};
```

### 4. Mutation Invalidation

All mutations call `useInvalidate()` helper:

```ts
function useInvalidate() {
  const qc = useQueryClient();
  return (id?: string | number) => {
    qc.invalidateQueries({ queryKey: ['verifications', 'list'] });
    qc.invalidateQueries({ queryKey: ['verifications', 'status-counts'] });
    if (id != null) qc.invalidateQueries({ queryKey: KEYS.detail(id) });
  };
}
```

### 5. Filter State

Default filter in `DEFAULT_FILTER` constant. Reset via `onClearAll`.

### 6. Mobile vs Desktop

- Use `hidden md:flex` / `md:hidden` classes
- Mobile: card layout, sheet filter
- Desktop: table layout, inline filter

### 7. Toast Feedback

All mutations show toast via `sonner`:

```ts
toast.success('Đã giao đầu chủ');
toast.error(err.message || 'Giao đầu chủ thất bại');
```

---

## API Reference

### Endpoints (via Route Handler `/api/verification/*`)

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | `/api/verification` | List (filter, search, paginate) |
| GET | `/api/verification/[id]` | Detail |
| GET | `/api/verification/listing-managers` | Dropdown assign |
| POST | `/api/verification/assign` | Giao đầu chủ |
| POST | `/api/verification/confirm` | Đầu chủ xác nhận |
| POST | `/api/verification/approve` | Phê duyệt |
| POST | `/api/verification/reject` | Từ chối |
| POST | `/api/verification/request-recheck` | Yêu cầu verify lại |

**Implementation**: `lib/api/verification.ts` → calls BE Web2py endpoints.

### Request/Response Shapes

See `types/verification.ts`:
- `BeVerificationItemSchema` (Zod)
- `BeVerificationListResponseSchema`
- `BeListingManagerSchema`

---

## Decisions Log

| Date | Decision | Why |
|------|----------|-----|
| 2026-05-12 | Client-side filter status counts | BE list endpoint không trả `list_status` → fetch all, count client-side (assumes <200 records typical user) |
| 2026-05-12 | Use `keepPreviousData` for list query | Prevents UI flash when filter changes |
| 2026-05-12 | Mapper pattern | BE shape heterogenous, may change; defensive parsing centralised |
| 2026-05-12 | Zod permissive schemas | BE response unconfirmed; accept all fields, mapper handles defaults |

---

## TODOs / Future Work

- [ ] BE endpoint `/get_verification_status_counts.json` để server-side count (replace client-side count)
- [ ] BE endpoint riêng cho "assign manager" (hiện tại re-use `assign_listing_manager` nhưng unclear)
- [ ] Pagination real impl (hiện tại mock)
- [ ] Upload images/videos (hiện tại mock UI)
- [ ] Draft save (hiện tại toast message only)

---

## Related Docs

- `docs/02-api-catalog.md` — Full API catalog
- `docs/03-be-questions.md` — BE clarifications
- `Wikis/Docs/_v1-reference/business-rules.md` — Business rules

---

<a id="docs-07-ba-nhu-cau-ban-md"></a>

## docs/07-ba-nhu-cau-ban.md

---
title: BA — Nhu cầu Bán (Lead chủ nhà)
type: business-analysis
module: nhu-cau-ban
status: draft (UI mock-only, BE chưa có)
audience: FE dev · BE dev · QA
created: 2026-05-08
related:
  - docs/01-brainstorm.md
  - docs/02-api-catalog.md
  - docs/05-be-handoff-consultation-actions.md
  - docs/06-be-handoff-consultation-views.md
---

# Nhu cầu Bán — Tài liệu BA

> Module quản lý **lead chủ nhà** (người bán BĐS). Khác với **Nhu cầu Mua** (consultation — đã có trên V1), nhu cầu Bán là track riêng, V1 chưa rõ entity → cần BE thiết kế mới hoặc tái dùng entity sẵn có.
>
> Hiện trạng: UI đã hoàn thiện ở mức mock (list + detail + 3 modal). Tài liệu này mô tả **business intent** để BE design endpoints + FE wire dữ liệu thật.

---

## 1. Mục tiêu module

Lead chủ nhà = một bản ghi về một người **muốn bán BĐS**, được hệ thống thu thập từ nhiều nguồn (Website, FB Lead Ads, CTV giới thiệu, App Agent, CMS thủ công, nhập tay).

| # | Mục tiêu | Đo lường |
|---|---|---|
| M1 | Tập trung tất cả lead chủ nhà về 1 nơi | Mọi lead có ID, không trùng SĐT |
| M2 | Phân công nhanh (Admin/TP gán đầu chủ trong < 1h) | SLA `remainingText` ≤ 24h |
| M3 | Đầu chủ phụ trách dẫn dắt lead → ký HĐ trích thưởng → đăng tin | 3 task `post`/`verify`/`commission_contract` |
| M4 | Theo dõi pipeline & cảnh báo trùng | Duplicate phone surface ngay khi tạo lead |
| M5 | Đo hiệu suất đầu chủ | Tỷ lệ chốt 30 ngày, lead xử lý, TB phản hồi |

Out of scope MVP: tự động gán bằng AI, scoring lead, multi-channel chat, dashboard manager-level.

---

## 2. Actors & Permissions

| Role | Quyền chính |
|---|---|
| **Admin / TP (Trưởng phòng)** | Xem tất cả lead trong VP mình quản lý · Gán/đổi đầu chủ · Đóng lead · Bulk action · Xuất Excel |
| **Đầu chủ (Salesman được gán)** | Xem lead được gán cho mình · Log hoạt động · Tạo XT BĐS · Tạo HĐ trích thưởng · Đăng tin |
| **CTV / Người tạo** | Tạo lead (manual hoặc qua App Agent) · Xem lead mình tạo |
| **Webhook (system)** | Tạo lead auto từ Website / FB Lead Ads |

Visibility rule (đề xuất): scope theo `office_id` + `sales_team_closure` (manager_id) — tái dùng pattern V1 (xem BE rule #2 ở root CLAUDE.md).

---

## 3. Glossary

| Thuật ngữ | Nghĩa |
|---|---|
| **Lead** | Bản ghi nhu cầu bán BĐS (1 chủ nhà · 1 BĐS dự kiến) |
| **Đầu chủ (broker)** | Salesman được Admin/TP gán phụ trách lead → người liên hệ chủ nhà |
| **Văn phòng (office)** | Đơn vị quản lý lead, lead luôn thuộc 1 VP |
| **XT BĐS** | Xác thực BĐS — quy trình verify thông tin BĐS sau khi gặp chủ nhà |
| **HĐ trích thưởng** | Hợp đồng ký giữa chủ nhà & công ty, cho phép môi giới hưởng % khi bán thành công |
| **Tin đăng (post)** | Bài đăng public trên website công khai bán BĐS |
| **Trùng SĐT** | Lead khác đã tồn tại với cùng số điện thoại chủ nhà |

---

## 4. Lifecycle (status machine)

```
                 ┌─────────────────┐
                 │  WEBHOOK / USER │ tạo lead
                 └────────┬────────┘
                          ▼
           ┌──────────────────────────┐
           │  NEW (Mới)               │  SLA 24h: phải gán broker
           └────────┬─────────────────┘
                    │ Admin/TP gán đầu chủ
                    ▼
           ┌──────────────────────────┐
           │  WAITING_ASSIGN (Chờ giao)│  (transient — có thể gộp với NEW)
           └────────┬─────────────────┘
                    │ broker xác nhận / log activity đầu tiên
                    ▼
           ┌──────────────────────────┐
           │  CONSULTING (Đang TV)    │  broker dẫn dắt: gọi/hẹn/XT/HĐ
           └────────┬─────────────────┘
                    │ task post + verify + contract = done
                    │   hoặc Admin đóng thủ công
                    ▼
           ┌──────────────────────────┐
           │  CLOSED (Đóng)           │  + reason (success/lost_*)
           └──────────────────────────┘
```

Trạng thái (`LeadStatus`): `new` · `waiting_assign` · `consulting` · `closed`

Reason khi đóng (`LeadCloseReason`):
- `success_signed` — Đã ký HĐ trích thưởng (success)
- `lost_changed_mind` — Chủ nhà đổi ý không bán
- `lost_other_channel` — Bán bằng kênh khác
- `lost_spam` — Spam / không liên lạc được
- `lost_duplicate` — Trùng SĐT (lead phụ)

Auto-transition: hoàn thành cả 3 task `post` + `verify` + `commission_contract` → tự đóng `closed` với reason `success_signed` (xem `tasks-card.tsx` banner cảnh báo).

---

## 5. Domain entities (đề xuất schema)

> Source of truth cho FE shape: [`src/types/nhu-cau-ban.ts`](../src/types/nhu-cau-ban.ts).

### 5.1 `Lead`

| Field | Type | Required | Mô tả |
|---|---|---|---|
| `id` | string `#3215` | ✓ | Mã hiển thị, có dấu `#` |
| `shortId` | string `3215` | ✓ | Mã raw để route `/nhu-cau-ban/[id]` |
| `owner` | `LeadOwner` | ✓ | Chủ nhà |
| `bds` | `LeadBds` | ✓ | Thông tin BĐS dự kiến bán |
| `source` | enum | ✓ | `website` · `fb_lead` · `ctv` · `app_agent` · `cms` · `manual` |
| `office` | `LeadOffice` | ✓ | VP gán lead |
| `creator` | `{fullName, role}` | ✓ | Người/hệ thống tạo lead |
| `broker` | `LeadBroker` | ✗ | Đầu chủ phụ trách (null = chưa gán) |
| `status` | enum | ✓ | xem mục 4 |
| `tags` | `LeadTag[]` | ✓ | Nhãn dán: VIP, GẤP, BÁN GẤP, DUYỆT TK… |
| `duplicates` | `LeadDuplicate[]` | ✓ | Lead khác cùng SĐT |
| `ageText` | string | ✓ | Tuổi lead display, vd `5 phút`, `3 ngày` |
| `remainingText` | string | ✓ | SLA còn lại, vd `23h 55p`, `—` (đã consulting) |
| `createdAt` / `updatedAt` / `updatedAtFull` | string | ✓ | Display strings |
| `callCount` / `noteCount` | number | ✓ | Counter cho stats strip |
| `tasks` | `LeadTask[3]` | ✓ | Luôn 3 task: post · verify · commission_contract |
| `activities` | `ActivityEntry[]` | ✓ | Timeline log |

### 5.2 Sub-entities

```ts
LeadOwner   { fullName, phone, initial, avatarTone: 'amber'|'mint'|'blue'|'purple' }
LeadBds     { type, area, priceText, address, description? }
LeadBroker  { fullName, initial, phone? }
LeadOffice  { name, area? }
LeadTag     { id, label, tone: 'amber'|'rose'|'blue'|'mint'|'purple'|'olive' }
LeadDuplicate { id, name, date, status }
LeadTask    { key: 'post'|'verify'|'commission_contract', title, description, done, locked }
ActivityEntry { id, kind, title, meta?, outcome?, outcomeTone?, body?, highlightDate? }
ActivityKind = 'call'|'note'|'appointment'|'created'|'assigned'|'verify_remind'|'deposit'
```

### 5.3 Task dependency rules

| Task | Khoá khi |
|---|---|
| `post` (Tin đăng) | luôn unlock (làm trước hoặc sau đều được) |
| `verify` (XT BĐS) | locked khi `post.done === false` |
| `commission_contract` (HĐ trích thưởng) | locked khi `verify.done === false` |

Logic này thấy ở mock data (`mock-leads.ts:7-23`) và `tasks-card.tsx:98-128`.

---

## 6. Use cases

### UC-01 — Xem danh sách lead

**Actor**: Admin/TP, Đầu chủ
**Trigger**: vào `/nhu-cau-ban`
**Flow**:
1. Hệ thống load lead theo scope (Admin = full VP, broker = chỉ lead được gán)
2. Hiển thị 5 tab: `Tất cả` · `Mới` · `Chờ giao` · `Đang TV` · `Đóng` — kèm count
3. Filter bar (desktop): VP · Đầu chủ phụ trách · Nguồn lead · Search · Ngày tạo · Tag · Bộ lọc nâng cao
4. Bảng (desktop): 11 cột (checkbox · # · Chủ nhà · BĐS/Giá · Khu vực · Đầu chủ · Nguồn · VP/Người tạo · Tag · Cập nhật · Trạng thái)
5. Click row → detail page
6. Pagination: 20 lead/trang, hiển thị `{from}–{to} / {total}`

**Mobile**: top bar (back · "Nhu cầu bán" · count · search · filter) → tabs sticky → cards stack → FAB "TẠO LEAD".

### UC-02 — Tạo lead manual

**Actor**: Admin/TP, CTV
**Trigger**: click "Tạo lead" (desktop) hoặc FAB (mobile) → `/nhu-cau-ban/create` *(chưa impl, cần spec form)*
**Đề xuất fields**:
- Owner: `fullName`, `phone` (validate VN phone), `office_id`
- BDS: `type`, `area`, `priceFrom`, `priceTo`, address (tỉnh/huyện/xã), `description?`
- Source: mặc định `manual`
- Tag: optional, multi-select
- (Optional) ngay khi nhập SĐT → check duplicate, hiện `LeadDuplicate[]`

### UC-03 — Tạo lead auto (webhook)

**Actor**: System (webhook)
**Source**: Website form, FB Lead Ads
**Yêu cầu BE**:
- Endpoint nhận webhook (signed) tạo `Lead` với `source = website|fb_lead`
- Auto detect duplicate phone → set `duplicates[]`, status vẫn `new`
- Push notification cho Admin/TP của VP target

### UC-04 — Gán đầu chủ (assign broker)

**Actor**: Admin/TP
**Trigger**: từ list (bulk pill `GÁN ĐẦU CHỦ`) hoặc detail (button `Gán đầu chủ`/CTA `GÁN NGAY`)
**Flow** (xem `assign-broker-dialog.tsx`):
1. Mở dialog 2 panel: trái = cây tổ chức (VP → user), phải = card đầu chủ đã chọn + perf 30 ngày
2. Search theo tên/VP
3. Chọn 1 broker → enable nút `GÁN VÀ THÔNG BÁO`
4. Confirm → BE update `broker_id`, status → `consulting` (hoặc giữ `waiting_assign` nếu cần broker tự ack)
5. Push notification cho broker; activity timeline thêm entry `assigned`

**Edge**:
- Broker nghỉ phép → vẫn cho gán nhưng warning
- Bulk assign: 1 broker cho N lead → confirm count

### UC-05 — Log hoạt động

**Actor**: Đầu chủ (broker)
**Trigger**: button `Gọi đầu chủ` / `Ghi chú` / `Hẹn xem` (desktop) hoặc nút `Log` trong mobile
**Mobile sheet** (`log-activity-sheet.tsx`): chọn type (call/note/appointment/verify) · outcome (connected/no_answer/busy) · note · next-action time
**Side effects**:
- BE append `ActivityEntry` vào timeline
- Update `callCount` / `noteCount`
- Nếu `appointment`: tạo `Lịch hẹn` entry (link với module Lịch hẹn)
- Nếu `outcome=connected` & lead đang `new` → auto chuyển sang `consulting`

### UC-06 — Hoàn thành 3 task pipeline

| Task | Trigger | Module liên kết |
|---|---|---|
| `post` Tin đăng | button `Tạo tin` → flow đăng tin (route `/bds/create` với pre-fill) | BDS |
| `verify` XT BĐS | button `Tạo XT` → flow xác thực BĐS, link audit lead | xac-thuc-bds |
| `commission_contract` HĐ trích thưởng | button `Tạo HĐ` → form ký HĐ | hop-dong-trich-thuong |

Khi cả 3 done → lead auto-close `success_signed` (banner cảnh báo trong `tasks-card.tsx:65-67`).

### UC-07 — Đóng lead thủ công

**Actor**: Admin/TP, Đầu chủ
**Trigger**: button `Đóng nhu cầu` (header) hoặc bulk pill
**Dialog** (`close-lead-dialog.tsx`):
- Chọn lý do (5 option, xem mục 4)
- Note tuỳ chọn
- Cảnh báo "không thể hoàn tác"
**Effect**: BE set `status=closed`, `close_reason`, `close_note`, append activity `closed`.

### UC-08 — Bulk actions

**Actor**: Admin/TP
**Trigger**: select N lead trong table → strip pills xuất hiện
**Pills**:
| Action | Mô tả |
|---|---|
| `GÁN ĐẦU CHỦ` | Mở dialog assign cho N lead |
| `THÊM TAG` | Add tag chung cho N lead |
| `CONVERT XT BĐS` | Convert nhanh sang flow xác thực |
| `ĐÓNG LEAD` | Bulk close + chọn reason chung |
| `GỘP LEAD` | Merge các lead cùng SĐT thành 1 master |

### UC-09 — Cảnh báo trùng SĐT

**Trigger**: BE detect lead khác cùng phone → set `duplicates[]`
**UI**:
- Detail desktop: card cảnh báo viền cam (`DuplicateCard`) liệt kê lead trùng
- Mobile: badge `N trùng SĐT` ở info card + footer card
- Bulk action `GỘP LEAD` để merge

### UC-10 — Xem stats / hiệu suất

**Detail page strip** (`stats-strip.tsx`):
| Stat | Source |
|---|---|
| Cuộc gọi | `callCount` |
| Hẹn gặp | count `activities[kind=appointment]` |
| Đầu khách quan tâm | count khách demand match (cần BE) |
| Đã yêu cầu | `remainingText` SLA (chuyển warning tone) |

---

## 7. UI flows — màn hình & cấu trúc

### 7.1 List page `/nhu-cau-ban`

**Layout desktop** (≥md, từ `page.tsx:40-109`):
```
┌─────────────────────────────────────────────────────────────────┐
│ HEADER  [refresh] [Xuất Excel] [+ Tạo lead]                    │ ← scroll away
├─────────────────────────────────────────────────────────────────┤
│ FILTER BAR  [VP][Đầu chủ][Nguồn][🔍search][Ngày][Tag][≡]  [Xoá]│ ← scroll away
├─────────────────────────────────────────────────────────────────┤
│ TABS   Tất cả · Mới · Chờ giao · Đang TV · Đóng                │ ← sticky top-0
├─────────────────────────────────────────────────────────────────┤
│ BULK PILLS (chỉ khi selected > 0)                              │ ← sticky top-13
├─────────────────────────────────────────────────────────────────┤
│ TABLE 11 cols · click row → detail                             │
│ …                                                              │
├─────────────────────────────────────────────────────────────────┤
│ FOOTER pagination "Hiển thị 1–20 / 312 lead"   [< 1 2 3 … >]   │ ← shrink-0 đáy
└─────────────────────────────────────────────────────────────────┘
```

**Layout mobile** (`<md`):
```
┌──────────────────────────────────┐
│ APP BAR ← Nhu cầu bán [count] ≡ │
├──────────────────────────────────┤
│ TABS sticky                      │
├──────────────────────────────────┤
│ ┌─ Lead Card ─────────────────┐ │
│ │ #3215  Chị Lan         [Mới]│ │
│ │ ☎ 098.222.7788     [Gọi]    │ │
│ │ ┌─ BDS box ──────────────┐ │ │
│ │ │ Chung cư · 78 m² · 2.8tỷ│ │
│ │ │ 📍 123 Cầu Giấy, HN     │ │
│ │ └────────────────────────┘ │ │
│ │ [FB Lead] [⚠ 2 trùng]  5p   │ │
│ └─────────────────────────────┘ │
│ ⋯                                │
├──────────────────────────────────┤
│       FAB [+ TẠO LEAD]           │
└──────────────────────────────────┘
```

### 7.2 Detail page `/nhu-cau-ban/[id]`

**Desktop** 2 cột:
- **Left col w-95** (380px):
  1. `BdsInfoCard` — thông tin BĐS + giá kỳ vọng + địa chỉ + mô tả
  2. `RelatedPeopleCard` — Người tạo · Văn phòng · Người phụ trách (timeline với connector)
  3. `SourceCard` — Nguồn lead pill
  4. `DuplicateCard` — (có điều kiện) cảnh báo trùng SĐT
- **Right col flex-1**:
  1. `DetailPageHeader` — back · tên owner · #id · status · phone · createdAt · age · `Gán thẻ` · `Đóng nhu cầu`
  2. `DetailStatsStrip` — 4 stat: gọi · hẹn · đầu khách · đã yêu cầu
  3. `DetailTasksCard` — banner + 3 task box (post/verify/contract) với CTA active/locked/done
  4. `DetailActivityCard` — timeline + CTA gọi/ghi chú/hẹn

**Mobile** (stack):
1. `MobileDetailHeader` (h-14, back · Lead #id · owner)
2. `MobileHeroCard` — avatar · name · status · phone+updatedAt · 2 nút `Gọi ngay`/`Zalo`
3. `MobileInfoCard` — 3 col grid (loại/diện tích/giá) · address · source pill · trùng SĐT badge
4. `MobileTasksCard` — list 3 task vertical
5. `MobileStepperCard` — progress 4 bước trạng thái
6. `MobileActivityCard` — timeline + button `Log` (mở sheet)
7. `MobileBottomBar` (fixed) — CTA `GÁN ĐẦU CHỦ` hoặc `TRIỂN KHAI` + ⋯

### 7.3 Create page `/nhu-cau-ban/create`

**TODO** — chưa có UI mock. Đề xuất:
- Form 1 cột (mobile-first), section: Chủ nhà → BĐS → Văn phòng/gán → Tag/Note
- Validate phone ngay → check duplicate inline (hiện list lead trùng nếu có)
- Submit → toast → redirect detail

---

## 8. Business rules

| BR | Mô tả |
|---|---|
| BR-01 | 1 lead có duy nhất 1 broker (broker đổi → activity log `assigned`) |
| BR-02 | Lead `closed` không cho edit (trừ Admin với quyền reopen — out of MVP) |
| BR-03 | SLA `new`: phải gán broker trong 24h kể từ `createdAt` (hiển thị `remainingText`); quá hạn → escalate Admin (cần BE rule) |
| BR-04 | `verify` chỉ unlock khi `post.done` |
| BR-05 | `commission_contract` chỉ unlock khi `verify.done` |
| BR-06 | 3 task done → auto close `success_signed` |
| BR-07 | Lead auto-tạo (webhook) status mặc định `new`, broker null |
| BR-08 | Lead trùng SĐT: vẫn tạo bản ghi mới + flag duplicate, KHÔNG block (cho phép gộp manual) |
| BR-09 | Tag tone (amber/rose/blue/mint/purple/olive) lấy từ palette chung; Admin tự định nghĩa tag mới ở module Tag (tái dùng `/api_agent/list_tags` của V1) |
| BR-10 | Source `cms` chỉ tạo từ web admin V1 cũ; FE web agent không tạo source này |
| BR-11 | Activity `appointment` link sang module Lịch hẹn (1-1 với `appointment_id`) |
| BR-12 | `closed` lead vẫn xem được trong tab "Đóng" để xem lịch sử; không xoá |

---

## 9. Tích hợp với module khác

| Module | Tương tác |
|---|---|
| **BDS** | Task `post` → tạo BDS từ data lead (`/api_agent/create_real_estate.json` — tham khảo `02-api-catalog.md`); link `bds_id` ngược về lead |
| **Xác thực BĐS** | Task `verify` → tạo XT BĐS với `lead_id` reference |
| **HĐ trích thưởng** | Task `commission_contract` → form ký + upload file |
| **Lịch hẹn** | Activity `appointment` ↔ entity `appointments` |
| **Tag** | Reuse generic `/api_agent/list_tags` (xem feedback `consultation`) |
| **Notification** | Push khi: lead mới được gán broker · 3h trước appointment · SLA `new` quá hạn |
| **Khách hàng** | Stat "Đầu khách quan tâm" — match BĐS lead với nhu cầu mua |

---

## 10. API contract (đề xuất — chờ BE confirm)

> Format reference: V1 dùng namespace pattern `/api_agent/*`. Đề xuất namespace `nhu_cau_ban` hoặc `lead_seller`.

| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api_agent/list_lead_seller.json` | List + filter (office_id, broker_id, source, status, tag_id[], q, date_from, date_to, page, limit) |
| GET | `/api_agent/get_lead_seller.json?id={id}` | Detail (include activities, tasks, duplicates) |
| POST | `/api_agent/create_lead_seller.json` | Tạo manual |
| POST | `/api_agent/update_lead_seller.json` | Sửa thông tin |
| POST | `/api_agent/assign_broker_lead_seller.json` | Body: `lead_id`, `broker_id` (single hoặc array) |
| POST | `/api_agent/close_lead_seller.json` | Body: `lead_id`, `reason`, `note?` |
| POST | `/api_agent/log_activity_lead_seller.json` | Body: `lead_id`, `kind`, `outcome?`, `note?`, `next_at?` |
| POST | `/api_agent/list_tags` (existing) | Attach tag (cùng pattern Nhu cầu Mua) |
| POST | `/api_agent/merge_lead_seller.json` | Bulk merge duplicates |
| POST | `/api_agent/webhook/lead_seller/website` | Webhook tạo từ Website |
| POST | `/api_agent/webhook/lead_seller/fb_lead` | Webhook tạo từ FB Lead Ads |
| GET | `/api_agent/lead_seller_brokers.json?office_id=` | List broker để gán (cho dialog) |
| GET | `/api_agent/lead_seller_broker_perf.json?broker_id=` | Hiệu suất 30 ngày (recentLeads, successRate, avgResponse) |
| GET | `/api_agent/lead_seller_duplicates.json?phone=` | Check duplicate khi nhập SĐT |

Filter `tag_id` & `or_and` tái dùng convention V1 (lowercase `'or'|'and'|'not'` — xem BE rule #6 root CLAUDE.md).

---

## 11. Acceptance criteria (tổng quát)

### List page
- [ ] 5 tab + count chính xác theo dataset
- [ ] Filter bar 7 control hoạt động độc lập + combine; nút "Xoá lọc (N)" reset all
- [ ] Search debounce 300ms, áp lên `id`/`shortId`/`owner.fullName`/`owner.phone`
- [ ] Pagination 20/page, total hiển thị đúng định dạng `vi-VN`
- [ ] Click row → navigate detail; click checkbox không trigger navigate
- [ ] Bulk pills hiện khi `selectedIds.length > 0`, ẩn khi clear
- [ ] Mobile: FAB visible, tabs sticky scroll, không có double scrollbar

### Detail page
- [ ] Header back về list (giữ filter state)
- [ ] StatsStrip 4 cell, divider giữa cell, value tabular
- [ ] TasksCard: button state đúng theo `done`/`locked`; banner cảnh báo always show
- [ ] ActivityCard timeline: connector line giữa 2 entry, last entry không có line dưới
- [ ] DuplicateCard chỉ render khi `duplicates.length > 0`
- [ ] CTA `Gọi đầu chủ` mở `CallContactDialog` (component sẵn có)
- [ ] Mobile: bottom bar fixed, không che activity card cuối (padding pb-23)

### Modal
- [ ] AssignBrokerDialog: search + tree + perf panel, disable submit khi chưa chọn
- [ ] CloseLeadDialog: 5 reason radio, default `success_signed`, note tuỳ chọn, confirm 2 bước (warning text)
- [ ] LogActivitySheet (mobile): 4 type · 3 outcome · note required khi `kind=note`

### Cross-cutting
- [ ] Capitalize display text (họ tên, địa chỉ, tiêu đề) — feedback memory
- [ ] Mobile-first responsive: không có horizontal scroll dưới `375px`
- [ ] Dark mode: tone tag/source/status giữ contrast AA (cần test)
- [ ] i18n: tất cả copy bằng tiếng Việt, không hardcode tiếng Anh ngoài label dev

---

## 12. Visual contract (design tokens đã dùng)

| Token | Value | Dùng cho |
|---|---|---|
| Status `new` | bg `#CCFBE1` · text `#0D7C4D` (mint) | Mới |
| Status `waiting_assign` | bg `#FEE4C4` · text `#9A5B0B` (amber) | Chờ giao |
| Status `consulting` | bg `#EDE9FE` · text `#5B21B6` (purple) | Đang TV |
| Status `closed` | bg `#FECACA` · text `#9F1239` (rose) | Đóng |
| Tag tones | amber/rose/blue/mint/purple/olive | xem `status-badge.tsx:18-25` |
| Source `website` | info blue + GlobeIcon | |
| Source `fb_lead` | `#1877F2` + Facebook glyph | |
| Source `ctv` | success green | |
| Source `app_agent` | violet | |
| Source `manual` | amber | |
| Card | `rounded-md border border-border bg-card` (desktop) · `rounded-[10px]` (mobile) | |
| Section label | `font-bold text-[11px] uppercase tracking-wider text-text-muted-2` | |
| Status pill sm | `h-6 px-3 text-[11px] font-bold rounded-full` | |
| Status pill mobile compact | `h-5.5 px-2.5 text-[10px]` | |

Visual contract tham chiếu component "Nhu cầu Mua" (consultation) — giữ đồng bộ giữa 2 module.

---

## 13. Files reference

### Routes
- [src/app/(dashboard)/nhu-cau-ban/page.tsx](../src/app/(dashboard)/nhu-cau-ban/page.tsx) — List
- [src/app/(dashboard)/nhu-cau-ban/[id]/page.tsx](../src/app/(dashboard)/nhu-cau-ban/[id]/page.tsx) — Detail

### Components
- [src/components/nhu-cau-ban/list/](../src/components/nhu-cau-ban/list/) — 8 file (table, filter, tabs, bulk pills, mobile…)
- [src/components/nhu-cau-ban/detail/](../src/components/nhu-cau-ban/detail/) — 6 file (header, cards trái, stats, tasks, activity, mobile)
- [src/components/nhu-cau-ban/modals/](../src/components/nhu-cau-ban/modals/) — 3 file (assign, close, log)
- [src/components/nhu-cau-ban/source-pill.tsx](../src/components/nhu-cau-ban/source-pill.tsx)
- [src/components/nhu-cau-ban/status-badge.tsx](../src/components/nhu-cau-ban/status-badge.tsx)

### Types & data
- [src/types/nhu-cau-ban.ts](../src/types/nhu-cau-ban.ts) — domain types
- [src/lib/nhu-cau-ban/mock-leads.ts](../src/lib/nhu-cau-ban/mock-leads.ts) — fixtures (5 lead)
- [src/lib/nhu-cau-ban/source-meta.ts](../src/lib/nhu-cau-ban/source-meta.ts) — avatar tone palette

---

## 14. Open questions (cần BE/Product clarify)

1. **Entity mapping**: V1 đã có entity nào tương đương lead chủ nhà chưa? (e.g. `lead`, `seller_request`?) Hay tạo mới hoàn toàn?
2. **SLA `new` 24h**: Ai chịu trách nhiệm escalate khi quá hạn? Auto-reassign hay chỉ notify?
3. **Permission Đầu chủ**: Có được edit BĐS info trong lead không, hay chỉ Admin?
4. **Reopen lead**: Cho phép Admin reopen lead `closed` không? Nếu có → cần audit log.
5. **Bulk merge**: Khi merge N lead → thông tin nào giữ (master = lead nào)? Activities cộng dồn?
6. **Webhook auth**: Sign secret cho webhook Website/FB Lead Ads — config ở đâu?
7. **Source `cms`**: Có cần expose source này lên FE web agent (filter dropdown) hay ẩn?
8. **Activity `outcome`**: Mobile sheet hardcode 3 option (connected/no_answer/busy) — có cần thêm `voicemail`/`wrong_number` không?
9. **Stat "Đầu khách quan tâm"**: Cần BE expose endpoint match nhu cầu mua ↔ BĐS lead, hay deferred phase 2?
10. **Tag attach**: Tái dùng `/api_agent/list_tags` (như Nhu cầu Mua) hay endpoint riêng?
11. **`broker_id` lookup cho dialog**: Scope theo office_id hay full company? Pagination?
12. **Performance metrics broker**: Source data (recentLeads/successRate/avgResponse) tính từ table nào?

---

> **Trạng thái BA**: v1 draft — UI đã ổn định, chờ BE handoff để wire dữ liệu thật. Sau handoff, FE sẽ thay `mock-leads.ts` bằng TanStack Query hooks tại `src/hooks/use-lead-seller-*.ts`.

---

<a id="docs-08-be-handoff-lead-seller-data-md"></a>

## docs/08-be-handoff-lead-seller-data.md

---
title: "Tư vấn Data — Nhu cầu Bán (Lead Seller), đối chiếu Nhu cầu Mua"
type: be-handoff
date: 2026-05-08
status: draft
audience: BE team · FE dev
related:
  - docs/06-be-handoff-consultation-views.md
  - docs/07-ba-nhu-cau-ban.md
  - src/types/consultation.ts
  - src/types/nhu-cau-ban.ts
---

# Tư vấn Data — Nhu cầu Bán (Lead Seller)

> Mục tiêu: tận dụng tối đa schema **Nhu cầu Mua (Consultation/Demand)** đã được BE/FE đồng thuận (xem [06-be-handoff-consultation-views.md](./06-be-handoff-consultation-views.md)) để build data cho **Nhu cầu Bán (Lead Seller)** — giảm thiểu rủi ro, tái dùng convention, đồng bộ UI primitive.
>
> Phân tích: 70% field có thể **tái dùng/đối xứng**, 20% cần **biến thể nhỏ**, 10% là **đặc thù lead bán** (tasks pipeline, duplicates, broker assignment, SLA).

---

## 1. TL;DR — Khuyến nghị chính

| # | Khuyến nghị | Lý do |
|---|---|---|
| 1 | **Đặt tên entity = `lead_seller`** thay vì `demand` (consultation đã dùng) | Tránh đụng namespace; rõ semantic (bán vs mua) |
| 2 | **Tái dùng 100% shape**: tags, office, user_support, status_info, notification_settings, comments, dates | Đã có FE component dùng được (TagChip, OfficeSelect, UserSelect, StatusBadge dynamic) |
| 3 | **Đổi shape**: `property_requirements` (range) → `property_info` (giá trị cụ thể), `location_preferences[]` (nhiều) → `location` (đơn) | Lead bán = 1 BĐS cụ thể, không phải nhu cầu khoảng |
| 4 | **Bỏ shape**: `interested_locations[]`, `project_preferences[]`, `suggested_bds[]`, `interests[]` | Không áp dụng cho lead bán |
| 5 | **Thêm shape mới**: `tasks[3]` pipeline, `duplicates[]`, `broker` (subset của user_support), `sla_info`, `source` (enum), `close_info` | Đặc thù lead seller |
| 6 | **Status enum riêng**: `new`/`waiting_assign`/`consulting`/`closed` (KHÔNG dùng `active`/`in_transaction`/`completed`/`cancelled` của consultation) | Pipeline khác nhau |
| 7 | **Tránh lặp lại 11 quirks** của consultation (xem §8) | BE chuẩn hoá ngay từ đầu |

---

## 2. Mapping table — Demand ↔ LeadSeller

| Group | Field Demand (Mua) | Field LeadSeller (Bán) đề xuất | Action |
|---|---|---|---|
| **ID** | `id`, `consultation_id`, `consultation_code` | `id`, `lead_id`, `lead_code` (ví dụ `LS-2026-3215`) | Đổi prefix tên |
| **Status** | `demand_status` enum (5 giá trị) | `lead_status` enum (4 giá trị: `new`/`waiting_assign`/`consulting`/`closed`) | Khác enum, giữ pattern |
| **Status display** | `demand_status_name: {name,color}` | `lead_status_name: {name,color}` | Tái dùng pattern |
| **Status meta** | `status_info: {demand_status, status_changed_on, status_reason}` | `status_info: {lead_status, status_changed_on, status_reason, close_reason?, close_note?}` | Mở rộng thêm close fields |
| **Người 1 (khách/chủ nhà)** | `customer_info: {customer_id, full_name, phone_number, email, auth_user_id}` | `owner_info: {owner_id, full_name, phone_number, email, auth_user_id}` | Cùng shape, đổi key prefix |
| **Người 1 — flat top-level** | `full_name`, `phone_number` (BE-canonical) | `full_name`, `phone_number` | Tái dùng |
| **Mô tả BĐS** | `property_requirements: {transaction_type, property_type[], budget_range, area_range, floors_range, bedrooms[], bathrooms_min}` | `property_info: {property_type:{id,name}, area, price_min, price_max, address, floors?, bedrooms?, bathrooms?, description?}` | Bỏ "range" cho budget/area (giá có thể range, area cụ thể) |
| **Địa chỉ** | `location_preferences[]: SearchItem[]` (nhiều khu vực) | `location: SearchItem` (1 khu vực) hoặc inline trong `property_info.address` + `property_info.boundaries[]` | Single, không array |
| **Sở thích** | `preferences: {preferred_directions, legal_requirements, furniture_requirements, special_requirements, note}` | (không cần — không phải nhu cầu khoảng) — chỉ giữ `notes` flat | Lược bỏ |
| **VP / Office** | `post_office_name`, `post_office_id`, `post_office_code` | `office_name`, `office_id`, `office_code` | Giữ pattern, bỏ prefix `post_` (lead bán không phải "đăng tin") |
| **Người phụ trách** | `user_support: {id, name, name_code, phone, ...}` | `broker: {id, name, name_code, phone, ...}` | Cùng shape, đổi tên — broker = đầu chủ |
| **Người phụ trách (list)** | `agent_support: {id, name, position_name_code, phone}` | (chuẩn hoá ngay: trả `broker` ở cả list lẫn detail với key `name_code`) | Bỏ luôn pattern `agent_support` để tránh quirk §6.5 doc 06 |
| **Người tạo** | `created_by_name` flat + `created_by: {id, full_name, ...}` nested | `created_by_name` flat + `created_by: {id, full_name, ...}` nested | Tái dùng |
| **Source** | `source` string optional (manual/import) | `source` enum **required**: `website`/`fb_lead`/`ctv`/`app_agent`/`cms`/`manual` | Hard-typed enum |
| **Tags** | `tags[]: TagItem[]` (chuẩn shape `tag_id, tag_name, tag_color`) | `tags[]: TagItem[]` (cùng shape) | Tái dùng 100% — generic `/api_agent/list_tags` |
| **Dates** | `created_on`, `updated_on` (Web2py) | `created_on`, `updated_on` | Tái dùng (bỏ `created_at`/`date` luôn từ đầu) |
| **Notif settings** | `notification_settings: {push_enabled, sms_enabled, daily_limit}` | `notification_settings: {push_enabled, sms_enabled}` | Tái dùng (bỏ `daily_limit` — lead bán không cần) |
| **Stats** | `stats: {priority_score, total_suggestions_sent, view_count, contact_count, ...}` | `stats: {call_count, note_count, appointment_count, interested_buyer_count, sla_remaining_seconds}` | Đổi nội dung, giữ pattern object `stats` |
| **Property attached** | `property: PropertyLite` (BDS đính kèm) | `property: PropertyLite` (BDS đã đăng từ task `post`) | Tái dùng — chỉ có sau khi `post.done` |
| **Project attached** | `project: ProjectLite` | (không áp dụng) | Bỏ |
| **Activities** | `works[]` (reserved), comments dùng `/api_agent/salesman_comments` | `activities[]: ActivityEntry[]` (call/note/appointment/created/assigned/verify_remind/deposit) | Định nghĩa shape mới (xem §5) |
| **Comments** | `/api_agent/salesman_comments?demand_id={id}` | `/api_agent/salesman_comments?lead_id={id}` | Tái dùng endpoint, đổi key |
| **Suggested BDS** | `suggested_bds[]` + `/api_agent/demand_suggest.json` | (không cần — match ngược: nhu cầu mua match lead bán) | Phase 2 nếu cần |
| **Transaction deposit** | `transaction_deposit: {deposit_type, deposit_amount}` | (không áp dụng — lead bán không cọc) | Bỏ |
| **Đặc thù lead bán** | — | `tasks[3]: LeadTask[]` (post/verify/commission_contract) | **MỚI** — xem §4 |
| **Đặc thù lead bán** | — | `duplicates[]: LeadDuplicate[]` | **MỚI** — xem §6 |
| **Đặc thù lead bán** | — | `sla_info: {deadline, remaining_seconds, escalated}` | **MỚI** — xem §7 |
| **Đặc thù lead bán** | — | `close_info: {reason, note, closed_on, closed_by}` | **MỚI** (nested trong `status_info` cũng OK) |

---

## 3. Schema đề xuất — `LeadSellerDetail` (full)

```jsonc
{
  // ─── ID ─────────────────────────────────────
  "id": 3215,
  "lead_code": "LS-2026-3215",         // hiển thị → FE format thành "#3215" hoặc "#LS-2026-3215"

  // ─── Owner (chủ nhà) ────────────────────────
  "full_name": "Chị Lan",              // flat BE-canonical (giống Demand)
  "phone_number": "0982227788",        // flat
  "owner_info": {
    "owner_id": 9001,
    "id": 9001,
    "auth_user_id": null,
    "full_name": "Chị Lan",
    "phone_number": "0982227788",
    "email": null
  },

  // ─── Status ─────────────────────────────────
  "lead_status": "consulting",         // enum: new|waiting_assign|consulting|closed
  "lead_status_name": { "name": "Đang TV", "color": "#5B21B6" },
  "status_info": {
    "lead_status": "consulting",
    "status_changed_on": "2026-05-06T08:30:00Z",
    "status_reason": null,
    // Chỉ populate khi status=closed:
    "close_reason": null,              // enum: success_signed|lost_changed_mind|lost_other_channel|lost_spam|lost_duplicate
    "close_note": null,
    "closed_on": null,
    "closed_by": null                  // user_id
  },

  // ─── Property (BĐS được đăng bán) ──────────
  "property_info": {
    "property_type": { "id": 5, "name": "Chung cư" },   // luôn object {id,name} — tránh quirk §6.11
    "area": 78,                                          // m² — số đơn (không range)
    "price_min": 2800000000,                             // VND — range cho phép thương lượng
    "price_max": 3000000000,                             // null nếu cố định
    "price_display": "2.8 - 3.0 tỷ",                     // BE compute, FE dùng trực tiếp
    "address": "123 Cầu Giấy",                           // chi tiết
    "boundaries": [                                       // array tỉnh/huyện/xã (giống boundaries của SearchItem)
      { "type": 1, "id": 1,   "name": "Cầu Giấy",      "prefix": "Quận",    "full_name": "Quận Cầu Giấy" },
      { "type": 2, "id": 1,   "name": "Hà Nội",        "prefix": "Thành phố","full_name": "TP. Hà Nội" }
    ],
    "floors": null,
    "bedrooms": 2,
    "bathrooms": 2,
    "direction": null,                                    // hướng (Đông/Tây/...)
    "legal_status": "Sổ hồng",                            // tình trạng pháp lý
    "description": "Chung cư 2PN view sông, full nội thất, đã có sổ. Cần bán gấp."
  },

  // ─── Source ─────────────────────────────────
  "source": "fb_lead",                 // enum hard-typed

  // ─── Office ─────────────────────────────────
  "office_id": 12,
  "office_name": "VP Hà Nội",
  "office_code": "HN-01",

  // ─── Broker (đầu chủ) ───────────────────────
  "broker": null,                      // null = chưa gán; populate với UserSupport shape khi gán
  // {
  //   "id": 5001, "auth_user_id": 9001,
  //   "name": "Chị Hằng", "name_code": "CTV",
  //   "phone": "0901234567", "email": "...",
  //   "img_url": "...",
  //   "count_customers": 45, "count_trans": 12, "count_real_estate": 80,
  //   "success_rate_30d": 72,         // ⬅ field MỚI cho dialog assign
  //   "avg_response_minutes": 30      // ⬅ field MỚI cho dialog assign
  // }

  // ─── Người tạo ──────────────────────────────
  "created_by_name": "Anh Tâm",
  "created_by": {
    "id": 5002,
    "full_name": "Anh Tâm",
    "role": "Admin"                    // free text — dùng cho hiển thị "Anh Tâm (Admin)"
  },

  // ─── Tags ───────────────────────────────────
  "tags": [
    { "tag_id": 12, "tag_name": "BÁN GẤP", "tag_color": "#FBCFE8" },
    { "tag_id":  7, "tag_name": "VIP",     "tag_color": "#FEE4C4" }
  ],

  // ─── Dates ──────────────────────────────────
  "created_on": "2026-05-06T15:25:00Z",
  "updated_on": "2026-05-06T15:30:00Z",

  // ─── SLA ────────────────────────────────────
  "sla_info": {
    "deadline": "2026-05-07T15:25:00Z",   // 24h sau created_on (chỉ khi status=new)
    "remaining_seconds": 86100,            // 0 khi đã consulting/closed
    "escalated": false                     // true khi quá hạn → notify Admin TP
  },

  // ─── Tasks pipeline (3 task cố định) ───────
  "tasks": [
    { "key": "post",                "title": "Tin đăng",      "description": "Đăng tin lên website công khai", "done": true,  "locked": false, "done_on": "...", "linked_id": 901001, "linked_type": "real_estate" },
    { "key": "verify",              "title": "Xác thực BĐS",  "description": "Tạo XT BĐS — link audit lead",     "done": false, "locked": false, "done_on": null,   "linked_id": null,   "linked_type": "verification" },
    { "key": "commission_contract", "title": "HĐ trích thưởng","description": "Ký hợp đồng với chủ nhà",          "done": false, "locked": true,  "done_on": null,   "linked_id": null,   "linked_type": "commission_contract" }
  ],

  // ─── Duplicates (trùng SĐT) ────────────────
  "duplicates": [
    { "id": 3198, "lead_code": "LS-2026-3198", "full_name": "Chị Lan",   "phone_number": "0982227788", "lead_status": "closed",     "lead_status_name": { "name": "Đã đóng",   "color": "#9F1239" }, "created_on": "2026-05-03T..." },
    { "id": 3050, "lead_code": "LS-2026-3050", "full_name": "Lan A.",     "phone_number": "0982227788", "lead_status": "consulting", "lead_status_name": { "name": "Đang TV",   "color": "#5B21B6" }, "created_on": "2026-04-15T..." }
  ],

  // ─── Stats ──────────────────────────────────
  "stats": {
    "call_count": 1,
    "note_count": 0,
    "appointment_count": 1,
    "interested_buyer_count": 0,        // số nhu cầu mua match với BĐS này (phase 2)
    "last_activity_on": "2026-05-06T15:25:00Z"
  },

  // ─── Property đính kèm (sau khi task `post` done) ──
  "property": null,                     // null nếu chưa post; PropertyLite khi đã đăng

  // ─── Notification settings ─────────────────
  "notification_settings": {
    "push_enabled": true,
    "sms_enabled": false
  },

  // ─── Activities timeline ───────────────────
  "activities": [
    {
      "id": "a1",
      "kind": "call",                   // enum: call|note|appointment|created|assigned|verify_remind|deposit
      "title": "Anh Tâm gọi điện chủ nhà",
      "created_on": "2026-05-06T15:20:00Z",
      "actor": { "id": 5002, "name": "Anh Tâm" },
      "outcome": "connected",           // call: connected|no_answer|busy|voicemail|wrong_number
      "duration_seconds": 200,
      "note": "Chủ nhà xác nhận muốn bán gấp, hẹn xem nhà thứ 5...",
      "appointment_at": null,           // chỉ có khi kind=appointment
      "linked_id": null,
      "linked_type": null
    }
  ],

  // ─── Comments (nếu BE muốn embed; hoặc dùng endpoint riêng) ──
  "comments": []                        // optional — FE ưu tiên endpoint /api_agent/salesman_comments?lead_id=
}
```

---

## 4. Schema `LeadTask` — chi tiết

```ts
type LeadTaskKey = 'post' | 'verify' | 'commission_contract';
type LeadTaskLinkedType = 'real_estate' | 'verification' | 'commission_contract';

interface LeadTask {
  key: LeadTaskKey;
  title: string;            // hiển thị (BE compute, FE dùng trực tiếp)
  description: string;      // sub-text
  done: boolean;
  locked: boolean;          // true khi prereq chưa xong
  done_on: string | null;   // ISO
  linked_id: number | null; // id của entity tạo ra
  linked_type: LeadTaskLinkedType | null;
}
```

**Lock rules (BE compute):**
- `post.locked = false` (luôn unlock)
- `verify.locked = !post.done`
- `commission_contract.locked = !verify.done`

**Auto-close rule:** khi 3 task `done=true` → BE auto set `lead_status='closed'`, `close_reason='success_signed'`, append activity `kind='auto_closed'`.

---

## 5. Schema `ActivityEntry` — chi tiết

```ts
type ActivityKind =
  | 'created'         // tạo lead (system/user)
  | 'assigned'        // gán/đổi broker
  | 'call'            // gọi điện
  | 'note'            // ghi chú
  | 'appointment'     // hẹn xem
  | 'verify_remind'   // nhắc xác thực
  | 'deposit'         // đặt cọc (nếu link với module Đặt cọc)
  | 'tag_added'       // thêm tag
  | 'task_done'       // hoàn thành task pipeline
  | 'status_changed'  // đổi status
  | 'closed';         // đóng lead manual

type CallOutcome = 'connected' | 'no_answer' | 'busy' | 'voicemail' | 'wrong_number';

interface ActivityEntry {
  id: string | number;
  kind: ActivityKind;
  title: string;                     // BE format sẵn (vd "Anh Tâm gọi điện chủ nhà")
  created_on: string;                // ISO
  actor: { id: number; name: string } | null;
  body: string | null;               // mô tả dài (FE render đoạn paragraph)

  // Polymorphic fields theo kind:
  outcome: CallOutcome | null;       // chỉ kind=call
  duration_seconds: number | null;   // chỉ kind=call
  appointment_at: string | null;     // chỉ kind=appointment (ISO)
  linked_id: number | null;          // verify_remind→verification_id, deposit→deposit_id, task_done→linked entity
  linked_type: string | null;
}
```

**FE hiện đang map** `outcome` thành `outcomeTone: 'success'|'muted'|'primary'` — đề xuất BE trả `outcome_tone` luôn (giảm logic FE):

| `outcome` | `outcome_tone` đề xuất |
|---|---|
| `connected` | `success` |
| `no_answer` / `busy` | `muted` |
| `voicemail` | `primary` |
| `wrong_number` | `muted` |

---

## 6. Schema `LeadDuplicate`

```ts
interface LeadDuplicate {
  id: number;
  lead_code: string;
  full_name: string;
  phone_number: string;
  lead_status: LeadStatus;
  lead_status_name: { name: string; color: string };
  created_on: string;          // ISO
  // Optional cho hiển thị:
  property_summary?: string;   // vd "Nhà phố · 95m² · ~4.5tỷ" để diff context
}
```

**BE rule khi tạo lead mới:**
1. Match `phone_number` với toàn bộ `lead_seller` table.
2. Trả về N bản ghi cùng SĐT → set field `duplicates[]`.
3. KHÔNG block tạo lead → cho phép Admin gộp manual sau (UC-08 Bulk merge).

---

## 7. Schema `sla_info`

```ts
interface SlaInfo {
  deadline: string | null;        // ISO — chỉ set khi lead_status='new', = created_on + 24h
  remaining_seconds: number;      // 0 khi deadline=null hoặc đã pass
  escalated: boolean;             // true khi remaining_seconds=0 + lead chưa assign → notify Admin TP
}
```

**FE format `remaining_seconds` → display:** vd `86100` → `"23h 55p"`, `0` → `"—"`.

**Compute rule (BE cron hoặc on-read):**
- `deadline = created_on + 24h` khi `lead_status='new'`
- Khi gán broker → `lead_status` chuyển → `deadline=null`, `remaining_seconds=0`
- Cron mỗi 5 phút check leads `new` → `remaining_seconds <= 0` → set `escalated=true` + push notify Admin

---

## 8. 11 quirks của Consultation — đừng lặp lại

Đối chiếu với [doc 06 §6](./06-be-handoff-consultation-views.md), BE **CẦN làm đúng ngay từ đầu** cho lead seller:

| # | Quirk Consultation | Fix cho LeadSeller |
|---|---|---|
| 6.1 | Customer name/phone — 4 paths (`full_name`/`customer_info`/`customer_name`/`customer.name`) | Chỉ trả **`full_name`** + `phone_number` flat + `owner_info` nested. **Không** có `customer_name`, `owner.name` |
| 6.2 | Budget/area — 4 paths | LeadSeller dùng **`property_info.price_min/max`** + **`property_info.area`** duy nhất. Không có `min_price/max_price` legacy |
| 6.3 | Dates — 3 paths | Chỉ **`created_on`** + **`updated_on`**. Không `created_at`/`date` |
| 6.4 | Status — 3 paths | Chỉ **`lead_status`** top-level. `status_info.lead_status` = metadata, không phải canonical. Không `status` alias |
| 6.5 | `agent_support` (list) vs `user_support` (detail) | Cả 2 endpoint cùng trả **`broker: {id, name, name_code, phone, ...}`**. Không tách `agent_support` |
| 6.6 | Tag fields dual naming | Chỉ **`tag_id`, `tag_name`, `tag_color`, `tag_icon`, `tag_code`** (prefix `tag_`) |
| 6.7 | Tag insertion order ngược | BE trả **newest-first** trực tiếp (giảm 1 bước reverse FE) |
| 6.8 | Notif settings GET vs CREATE asymmetric | Đồng bộ: **`push_enabled`/`sms_enabled`** ở cả GET và POST/PUT |
| 6.9 | `interested_locations` ≠ `location_preferences` | LeadSeller dùng `property_info.boundaries[]` duy nhất ở cả list/detail |
| 6.10 | `transaction_type` 3 shapes | LeadSeller không có `transaction_type` (luôn là "Bán") — bỏ field |
| 6.11 | `property_type` số → FE phải lookup | Luôn trả **`{id, name}` object** ở cả list/detail |

---

## 9. Filter params cho list — `GET /api_agent/get_list_lead_seller`

Tái dùng pattern Consultation (doc 06 §5):

| Param | Type | Note vs Consultation |
|---|---|---|
| `lead_status` | enum | `new\|waiting_assign\|consulting\|closed` (khác enum) |
| `search` | string | match `lead_code` + `phone_number` + `full_name` |
| `page`, `limit` | int | default 1, 20 |
| `office` | int | `office_id` |
| `broker` | int | thay `sales_off` — filter `broker.id` |
| `created_by` | int | filter người tạo |
| `source` | enum | **MỚI** — `website\|fb_lead\|ctv\|app_agent\|cms\|manual` |
| `start_date`, `end_date` | `YYYY-MM-DD` | filter `created_on` |
| `city_id`, `district_id`, `ward_id` | int | filter location boundaries |
| `tag_id` | repeated int | **lowercase or_and**, repeated key (đừng lặp quirk consultation §5.1) |
| `or_and` | enum lowercase | `or\|and\|not` |
| `has_duplicates` | bool | **MỚI** — lọc chỉ lead có trùng SĐT |
| `escalated` | bool | **MỚI** — lọc lead quá SLA |

Response wrapper giữ nguyên `{status, message, data: {items, total, page, limit, total_pages, list_status}}`.

`list_status[]` shape giống consultation, id = lead_status enum + `'all'`.

---

## 10. Endpoint summary — đề xuất

| Method | Endpoint | Tương đương Consultation |
|---|---|---|
| GET | `/api_agent/get_list_lead_seller` | `get_list_consultation` |
| GET | `/api_agent/get_detail_lead_seller/{id}` | `get_detail_consultation/{id}` |
| POST | `/api_agent/create_lead_seller` | `create_consultation` |
| POST | `/api_agent/update_lead_seller` | `update_consultation` |
| POST | `/api_agent/assign_broker_lead_seller` | (new) |
| POST | `/api_agent/close_lead_seller` | (new) — body: `lead_id, close_reason, close_note?` |
| POST | `/api_agent/log_activity_lead_seller` | (new) — body: `lead_id, kind, ...polymorphic` |
| POST | `/api_agent/list_tags` (existing generic) | tái dùng — body: `entity_type='lead_seller', entity_id, tag_ids[]` |
| POST | `/api_agent/merge_lead_seller` | (new) — bulk merge duplicates |
| GET | `/api_agent/lead_seller_brokers?office_id=` | (new) — list broker để gán + perf 30d |
| GET | `/api_agent/lead_seller_duplicates?phone=` | (new) — check duplicate khi nhập SĐT lúc tạo lead |
| GET | `/api_agent/salesman_comments?lead_id=` | tái dùng endpoint (FE đổi param key) |
| POST | `/api_agent/webhook/lead_seller/website` | (new) — webhook |
| POST | `/api_agent/webhook/lead_seller/fb_lead` | (new) — webhook |

---

## 11. Migration path FE (đề xuất)

Khi BE handoff xong, FE cần:

1. **Tạo `src/types/lead-seller.ts`** — copy pattern từ `consultation.ts` (Zod schema, passthrough, fallback), thay `Demand` → `LeadSeller`.
2. **Tạo `src/lib/api/lead-seller.ts`** — copy pattern từ `lib/api/consultation.ts` (normalizeList, unwrapData).
3. **Tạo `src/hooks/use-lead-seller-*.ts`** — TanStack hooks (list, detail, mutations).
4. **Thay mock-leads.ts** trong các page bằng hooks thật.
5. **Component không cần đổi nhiều** — vì shape FE-internal đã trừu tượng (xem `src/types/nhu-cau-ban.ts`); chỉ cần mapper `mapBeToFeLead()` ở api layer.
6. **Tái dùng UI primitives** từ Consultation: `TagChip`, `TagDot`, `OfficeSelect`, `UserSelect`, `TagFilterPopover`, `CallContactDialog`.

---

## 12. Differences cốt lõi — bảng so sánh nhanh

| Khía cạnh | Nhu cầu Mua (Consultation) | Nhu cầu Bán (LeadSeller) |
|---|---|---|
| **Người chính** | Khách hàng (muốn mua) | Chủ nhà (muốn bán) |
| **BĐS** | Mô tả khoảng (range) | BĐS cụ thể (1 BĐS / 1 lead) |
| **Địa chỉ** | Nhiều vùng quan tâm (`location_preferences[]`) | 1 địa chỉ (`property_info.boundaries[]`) |
| **Transaction type** | Mua/Thuê (`transaction_type`) | Luôn Bán (bỏ field) |
| **Status pipeline** | `new→active→in_transaction→completed/cancelled` | `new→waiting_assign→consulting→closed` |
| **Người phụ trách** | `user_support` / `agent_support` | `broker` (= đầu chủ) — **tên rõ hơn** |
| **Tasks** | Không có pipeline cố định (works[] free-form) | **3 task fixed**: post → verify → commission_contract |
| **SLA** | Không tracking 24h | **Có** — gán broker trong 24h |
| **Duplicates** | Không cảnh báo trùng | **Có** — flag duplicate phone |
| **Source** | Manual hoặc import (free string) | **Hard-typed enum** 6 giá trị |
| **Suggested BDS** | `/demand_suggest` — match BDS cho khách | (ngược lại — match nhu cầu mua cho lead) — phase 2 |
| **Deposit attached** | Có (`transaction_deposit`) | Không |
| **Project attached** | Có (`project: ProjectLite`) | Không |
| **Webhook auto-create** | Không | **Có** — Website + FB Lead Ads |
| **Bulk action** | Có (giới hạn) | **Có nhiều hơn**: assign / tag / convert-XT / close / merge |

---

## 13. Open questions — cần BE/Product confirm

1. **Entity mapping V1**: V1 đã có table nào tương đương (`tbl_seller_lead`, `tbl_owner_demand`?) hay tạo mới hoàn toàn?
2. **`tasks` lưu ở đâu**: Tách table `lead_seller_task` (3 row / lead) hay JSON field trong `lead_seller`?
3. **`activities` lưu ở đâu**: Tách table `lead_seller_activity` hay tái dùng `salesman_comments` với polymorphic?
4. **`broker.success_rate_30d` / `avg_response_minutes`**: Compute on-the-fly (slow) hay cron tổng hợp vào field cache?
5. **Match ngược (interested_buyer_count)**: Endpoint nào trả demand match với 1 BĐS lead? Phase 1 hay 2?
6. **Webhook auth**: Sign secret config ở `appconfig.ini`? Hay header `X-Webhook-Token`?
7. **Reopen lead**: Cho phép Admin reopen `closed` lead không? Nếu có → audit log thế nào?
8. **`source=cms`**: Có expose lên FE Web Agent filter dropdown hay ẩn (chỉ source nội bộ)?
9. **Permission scope**: Broker chỉ thấy lead `broker_id = self.id`, hay thấy cả lead VP mình? (Tham chiếu V1 `sales_team_closure`)
10. **`property_type` cho lead bán**: Tái dùng catalog `/api_agent/property_types` của BDS hay có catalog riêng?
11. **`price_min/max` null khi cố định giá**: BE trả `price_min=2800000000, price_max=null`, hay `price_min=price_max=2800000000`?
12. **Tag attach endpoint**: Generic `/api_agent/list_tags` với `entity_type='lead_seller'` đã support chưa, hay cần thêm support entity mới?

---

> Tài liệu này chỉ spec **data shape + endpoint**. UI flows + business rules đầy đủ xem [07-ba-nhu-cau-ban.md](./07-ba-nhu-cau-ban.md). Convention chuẩn hoá tham chiếu [06-be-handoff-consultation-views.md §6](./06-be-handoff-consultation-views.md).

---

<a id="docs-09-api-tin-tuc-du-an-md"></a>

## docs/09-api-tin-tuc-du-an.md

# API Tin tức & Dự án — handoff FE

> Tổng hợp endpoint BE cho 2 nhóm chức năng **Tin tức (news)** và **Dự án (project)** trong app Agent.
> Nguồn: BE Web2py (`src/BE/controllers/api_agent.py`, `api_customer.py`, `modules/real_estate_handle.py`) + app Flutter (`tongkhobds_agent/lib/domain/client/api_client.dart`).
> Ngày: 2026-05-12.

## 0. Quy ước chung

- FE gọi qua proxy `/api/*` → Web2py (giữ convention hiện tại).
- Base path BE: `/api_agent/*`, `/api_customer/*`, `/api/*` (một số endpoint tồn tại ở cả `api_agent` lẫn `api_customer`, logic gần như giống nhau — ưu tiên `/api_agent/*` cho app Agent).
- **Token (`Authorization: Bearer <jwt>`)**:
  - ✅ **Bắt buộc** — decorator `@auth.requires_login()`; thiếu/sai/hết hạn → 401.
  - ⚪ **Tùy chọn** — decorator `allows_jwt(required=False)`; không gửi vẫn chạy, gửi thì lọc theo quyền/`user_id`. Một số endpoint có `verify_expiration=False` → chấp nhận cả token hết hạn.
  - ❌ **Public** — chỉ `@request.restful()`.
  - Khuyến nghị: web_agent cứ đính token cho mọi request; chỉ endpoint ✅ mới thực sự chặn.
- Token TTL 24h, **không có refresh** → hết hạn = login lại.
- Ảnh: BE trả path tương đối → cần build full URL (BE đã prefix sẵn `https://quanly.tongkhobds.com/...` ở phần lớn endpoint detail).

---

## 1. TIN TỨC (news / bài viết CMS)

Dữ liệu = bảng CMS `news` (qua `plugin_cms.Cms`), tổ chức theo **folder** (thư mục, có id số hoặc slug).

### 1.1. Danh sách tin theo danh mục
`GET /api_agent/news_by_folder.json` — Token: ❌ Public

| Param | Kiểu | Bắt buộc | Ghi chú |
|---|---|---|---|
| `folder` | int \| string | ✓ | id số hoặc slug thư mục. Mặc định `'resaland'` nếu rỗng. App mobile dùng `folder=11` cho tin tức trang chủ; `14` = icon trang chủ; `19` = công cụ nhanh; các slug khác: `onboarding-data-agent`, `thumbnail-agnet`, `lucky-program`, `app-agent-qua-tang`, `thu-vien-hop-dong-agent`... |
| `page` | int | – | mặc định 1 |
| `length` | int | – | mặc định 20 (số bài/trang) |
| `key` | string | – | tìm full-text trong nội dung (`dcontent.textcontent`) |
| `description` | string | – | lọc theo "loại" (vd loại hợp đồng) |

**Response** `{ result: [ {...} ], folder_name, count }`. Mỗi item:
```
id, name, description, avatar (full URL), display_order,
htmlcontent          // BỊ LƯỢC trong list (trừ folder thumbnail-*) → lấy detail để có nội dung
list_gallery: [...], product?, slug?, link?, version_docs?
```
> Bản `GET /api_customer/news_by_folder.json` tương tự, thêm `slug` + `link` (`https://tongkhobds.com/tin/<slug>`).

### 1.2. Chi tiết tin
`GET /api_agent/news_by_id.json?id=<news_id>` — Token: ⚪ Tùy chọn (gửi token để có `name_code` khi folder = `lucky-program`)

| Param | Kiểu | Bắt buộc |
|---|---|---|
| `id` | int | ✓ |

**Response** `{ result: { id, name, description, avatar, htmlcontent (đã unescape + fix `src` static → full URL), folder, folder_name, folder_label, list_gallery, point?, name_code? } }`. id sai → `{ status:'error', message:'ID không hợp lệ' }`.

Biến thể theo slug: `GET /api_customer/news_by_slug.json?slug=<slug>` — Token ❌.

### 1.3. Danh sách thư mục tin
`GET /api_customer/list_folder.json?folder=<id>` — Token: ❌ Public. Trả thư mục con của 1 folder (build menu danh mục).

### 1.4. Tin gắn với 1 BĐS
`GET /api_agent/get_news_by_real_estate.json?real_estate_id=<id>` — Token: ✅ Bắt buộc. Trả list bài viết của BĐS, `post_id = "00" + news_id`.

### Bảng tóm tắt — Tin tức
| Chức năng | Method + Endpoint | Token |
|---|---|---|
| List tin (trang chủ) | `GET /api_agent/news_by_folder.json?folder=11&page=1&length=20` | ❌ |
| List theo danh mục + search | `GET /api_agent/news_by_folder.json?folder=&page=&length=&key=&description=` | ❌ |
| Danh sách danh mục | `GET /api_customer/list_folder.json?folder=` | ❌ |
| Chi tiết tin | `GET /api_agent/news_by_id.json?id=` | ⚪ |
| Chi tiết theo slug | `GET /api_customer/news_by_slug.json?slug=` | ❌ |
| Tin theo BĐS | `GET /api_agent/get_news_by_real_estate.json?real_estate_id=` | ✅ |

---

## 2. DỰ ÁN (project)

Dữ liệu = bảng `project` (cha–con qua `parent_id`: dự án cha → các "Phân khu"). `project_type` = FK `property_type` (nhóm `transaction_type=3`, id 34–55: `can-ho-chung-cu`, `nha-o-xa-hoi`, `biet-thu-lien-ke`, `shophouse`, `dat-nen-du-an`...).

### 2.1. Danh sách dự án (search / explore)
`GET /api_agent/real_estate_v2.json?transaction_type=3&...` — Token: ⚪ Tùy chọn (`verify_expiration=False`)

`transaction_type=3` ⇒ trả **dự án** (không phải BĐS lẻ). BE ưu tiên Elasticsearch, fallback DB.

| Param | Ghi chú |
|---|---|
| `transaction_type` | `3` để lấy dự án (bắt buộc cho case này) |
| `property_types` | id loại dự án, multiple (`property_types=34&property_types=39` hoặc CSV `34,39`) — lấy danh sách qua §2.9 |
| `city_id` / `district_id` / `ward_id` | id địa giới, multiple |
| `locations_slug` | CSV slug tỉnh/huyện/xã |
| `keyword` / `search_txt` | từ khóa |
| `page`, `limit`, `sort` | phân trang + sắp xếp (`newest`, `price_asc`, `price_desc`, `area_asc`, `area_desc`) |
| `user_id`, `trending`, `id_ignore[]`, `is_verified` | tùy chọn |

**Response** `{ data: { properties: [...], total, page, total_pages, limit } }`.

### 2.2. Sản phẩm / phân khu bên trong 1 dự án
`GET /api_customer/real_estate_v2.json?project_code=<code>&transaction_type=<1|2|3>&page=&limit=20&userId=&<filters>` — Token: ⚪ Tùy chọn

- `transaction_type`: 1 = mua bán, 2 = cho thuê, 3 = dự án con.
- `project_types=<id>` để lọc phân khu theo loại.
- Response shape giống §2.1.

### 2.3. Chi tiết dự án
`GET /api_agent/project_details.json?id=<project_code | slug>` — Token: ❌ Public
(bản `/api_customer/project_details.json` — Token ⚪ Tùy chọn)

| Param | Kiểu | Bắt buộc |
|---|---|---|
| `id` | string | ✓ | `project_code` hoặc `slug` |

**Response** `{ project: {...}, property_types_childrens: [{ title:'Phân khu', project_childs:[...] }] }` (nếu không có phân khu → `property_types_childrens: null`).

`project` chứa (đã xử lý ảnh full URL, `utilities`/`gallery_images`/`master_plan_images` parse JSON, HTML đã unescape):
```
id, project_name, project_code, project_code_show, source_project, parent_id, slug,
project_status, project_area, area_unit, project_type, price_description, price, price_per_meter,
developer, developer_name, developer_logo, legal_status, description, html_content, total_units, total_towers,
city, city_id, district, district_id, ward, ward_id, street_address, latitude, longitude,
main_image, gallery_images:[], master_plan_images:[], utilities:[],
total_rate, total_amount, rate_seller, amount_seller, rate_buyer, amount_buyer, rate_project, amount_project,
is_show_inventory, bot_ai, is_bot_ai, ai_convert, ai_content
```
> (BE loại bỏ `created_on/updated_on/created_by/aactive/is_featured/source_get` khỏi response.)

### 2.4. Bảng hàng / Đợt mở bán (sale projects)
| Chức năng | Endpoint | Token |
|---|---|---|
| List dự án có đợt mở bán | `GET /api_agent/real_estate_sale_project.json` | ✅ Bắt buộc |
| Chi tiết đợt mở bán | `GET /api_agent/real_estate_sale_project_detail.json` | ✅ Bắt buộc |
| Đăng ký bán dự án | `POST /api_agent/real_estate_sale_register.json` body `{ project_id, real_estate_sale_id: 1 }` | ✅ Bắt buộc |

`real_estate_sale_project` lọc theo quyền salesman + `visibility_level` (1 công khai / 2 đăng ký / 3 nội bộ) + `registration_type`; gom phân khu (`zone_of_project`) cho dự án con. Trả về list dự án kèm trạng thái đăng ký (`registered_verify`: 1 chưa đăng ký / 2 chờ duyệt / 3 đã duyệt) + thông tin đợt bán (`real_estate_sale_id`, `title`, `start_at`, `end_at`, `notes`...).

### 2.5. Trạng thái căn hộ / lọc phân khu
`GET /api_agent/apartment_status.json?project_code=<code>&zone_of_project=<tên phân khu>` — Token: ❌ Public. Trả `{ apartments, status }`.

### 2.6. Bản đồ dự án
| Chức năng | Endpoint | Token |
|---|---|---|
| BĐS quanh dự án (markers) | `GET /api_customer/real_estate_map.json?project_code=<code>&page=1&limit=100` | ⚪ Tùy chọn |
| Map chi tiết dự án | `GET /api_customer/project_details_map.json?id=<id>` | ⚪ Tùy chọn |

> `real_estate_map.json` cũng dùng cho search BĐS theo bán kính: `latlng=<lat>,<lng>&radius=<km>&limit=50&transaction_type=`. Wrapper `{ properties/items, total, page, limit, total_pages }`, marker client-side (không cluster).

### 2.7. Danh sách dự án đơn giản (theo thành phố)
`GET /api_customer/get_list_project.json?city_id=<id>&limit=10` — Token: ❌ Public. Chỉ lọc `city_id`, không có filter loại. Trả `{ status, data:[{id,title,slug,description,status,area,unit,project_code,developer_project:{name,logo},main_image,images,search_count,key_attributes}], total, limit }`. (Lưu ý: `search_count` là số giả lập.)

### 2.8. Liên quan dự án (phase 2 / phụ trợ)
- Chat nhóm dự án: `POST /api_agent/create_project_group.json` body `{ project_name, id_bot, project_id }` — Token ✅. `GET /api_agent/get_list_message_project.json` — Token ✅.
- Cấu hình hoa hồng dự án: `GET /api_agent/commission_config_api_for_project.json` — Token ⚪.
- Lịch hẹn theo dự án: gửi `table_name="project"` (thay `"real_estate"`) trong API tạo lịch hẹn.
- Dropdown chọn dự án + pháp lý (lúc tạo/sửa BĐS): `GET /api/get_legal_documents.json` → `{ documents, projects }` — Token ✅.

### 2.9. Danh sách "loại dự án" (để truyền vào `property_types`)
`GET /api_customer/get_property_types.json?type=3` — Token: ❌ Public. `type=3` = nhóm "Dự án". Trả `{ status, data:[{id,title,vietnamese,slug,icon,total_post,...}] }`. Id hiện có: 34–55.

### Bảng tóm tắt — Dự án
| Chức năng | Method + Endpoint | Token |
|---|---|---|
| List dự án (search) | `GET /api_agent/real_estate_v2.json?transaction_type=3&page=&limit=` (+ `property_types`, `city_id`...) | ⚪ |
| SP / phân khu trong dự án | `GET /api_customer/real_estate_v2.json?project_code=&transaction_type=&page=&limit=` | ⚪ |
| Chi tiết dự án | `GET /api_agent/project_details.json?id=<code\|slug>` | ❌ |
| List đợt mở bán | `GET /api_agent/real_estate_sale_project.json` | ✅ |
| Chi tiết đợt mở bán | `GET /api_agent/real_estate_sale_project_detail.json` | ✅ |
| Đăng ký bán dự án | `POST /api_agent/real_estate_sale_register.json` | ✅ |
| Trạng thái căn hộ | `GET /api_agent/apartment_status.json?project_code=&zone_of_project=` | ❌ |
| Map quanh dự án | `GET /api_customer/real_estate_map.json?project_code=` | ⚪ |
| Map chi tiết dự án | `GET /api_customer/project_details_map.json?id=` | ⚪ |
| List dự án theo TP | `GET /api_customer/get_list_project.json?city_id=&limit=` | ❌ |
| List loại dự án | `GET /api_customer/get_property_types.json?type=3` | ❌ |

---

## 3. Câu hỏi cần BE xác nhận

1. Folder id cho mục "Tin tức" chính trên web_agent — app mobile hardcode `11`; nên build động qua `list_folder` hay BE cấp config?
2. `real_estate_v2.json` cho list dự án: web_agent nên gọi `/api_agent/` hay `/api_customer/`? (logic giống nhau, chỉ khác auth context/visibility.)
3. Một số endpoint có `verify_expiration=False` (`real_estate_v2`, `real_estate_map`) — token hết hạn vẫn nhận. FE có cần xử lý đặc biệt không, hay cứ refresh khi 401 ở các endpoint `auth.requires_login()`?
4. `project_details.json`: bản `/api_agent/` public hoàn toàn, bản `/api_customer/` đọc token — có khác biệt dữ liệu trả về theo quyền không?

---

<a id="docs-10-be-handoff-nhac-xac-thuc-bds-md"></a>

## docs/10-be-handoff-nhac-xac-thuc-bds.md

---
title: "BE Handoff — Nhắc xác thực BDS (verification reminder)"
type: be-handoff
date: 2026-05-17
status: draft
audience: BE team (Python Web2py V1)
related:
  - docs/API_Consultation_Activities.md
  - docs/06-xac-thuc-bds-flow.md
  - docs/02-api-catalog.md
  - src/components/bds/remind-verification-dialog.tsx
  - src/components/nhu-cau/working-bds/working-bds-row-expanded.tsx
  - src/components/nhu-cau/working-bds/working-bds-section.tsx
---

# BE Handoff — Nhắc xác thực BDS

> Context: trong màn `/nhu-cau/{id}` → khối "BDS đang làm việc", mỗi dòng BDS có button **"Nhắc xác thực"**. Click → mở dialog `RemindVerificationDialog` → submit gọi BE tạo 1 work record + gửi notification cho đầu chủ của BDS. FE hiện tại đang stub submit (toast giả). Doc này định nghĩa hành vi BE cần triển khai.

## Scope & decisions (đã chốt với FE)

| # | Quyết định |
|---|---|
| 1 | **Recipient**: đầu chủ (internal Listing Manager) đang assigned cho BDS — in-app notification + FCM push. Không liên lạc chủ nhà thật. |
| 2 | **Trigger**: chỉ manual từ FE (CTV bấm nút). Không có cron auto. |
| 3 | **Endpoint**: reuse `POST /api_agent/create_work_consultation` với `code='verification_reminder'`. Không tạo endpoint mới. |
| 4 | **Work scope**: `tablename='consultation_interest'`, `table_id=<consultation_interest.id>` (BDS-trong-nhu-cầu-mua). |
| 5 | **Cooldown**: BE quyết, đề xuất 24h. FE chỉ handle error message. |
| 6 | **Permission**: bất kỳ user nào view được nhu cầu (giống permission các action khác trên consultation). |
| 7 | **Status flow**: work auto-`completed` ngay sau khi gửi noti — không có chờ phản hồi, không có cancel. Work đứng như 1 dòng log trong activity feed. |
| 8 | **Notification content**: BE template auto. FE không truyền title/body. |

---

## Endpoint spec

### Request

```
POST /tongkho/api_agent/create_work_consultation
Authorization: Bearer <token>
Content-Type: application/json
```

| Param | Kiểu | Bắt buộc | Mô tả |
|---|---|---|---|
| `code` | string | Có | `verification_reminder` (giá trị mới) |
| `tablename` | string | Có | `consultation_interest` |
| `table_id` | int | Có | `consultation_interest.id` của dòng BDS đang làm việc |
| `note` | string | Không | Ghi chú tự do CTV gõ trong dialog (optional). Nếu BE muốn ignore cũng OK — FE đang để optional. |

FE **không** truyền: `started_at`, `assigned_to`, `deposit_*`, `location`, `documents`. BE tự sinh.

#### Example

```json
POST /tongkho/api_agent/create_work_consultation
{
  "code": "verification_reminder",
  "tablename": "consultation_interest",
  "table_id": 8842,
  "note": "Khách đang chờ, cần xác thực gấp"
}
```

### BE behavior

Pipeline BE cần thực hiện theo thứ tự:

1. **Auth**: `@auth.requires_login()` (đã có sẵn trên endpoint).
2. **Validate scope**: nếu `tablename != 'consultation_interest'` → `{status:'0', message:'Endpoint nhắc xác thực chỉ áp dụng cho consultation_interest', data:{}}`.
3. **Lookup**: `consultation_interest.id = table_id` → `real_estate.id` (qua field reference của bảng `consultation_interest`).
   - Không tìm thấy → `{status:'0', message:'Không tìm thấy BĐS trong nhu cầu', data:{}}`.
4. **Resolve recipient đầu chủ**: từ `real_estate` lấy listing manager đang assigned (theo logic verification flow hiện có — xem `docs/06-xac-thuc-bds-flow.md`).
   - Chưa có đầu chủ → `{status:'0', message:'BĐS chưa có đầu chủ', data:{}}` (FE sẽ toast info, không phải lỗi nặng).
5. **Check verification status**: nếu BDS đã `verification_status = 2` (FE: `success`) → `{status:'0', message:'BĐS đã xác thực, không cần nhắc', data:{}}`.
6. **Cooldown check**: query work gần nhất cùng `code='verification_reminder'` + cùng `table_id`. Nếu khoảng cách < cooldown window (BE config, đề xuất 24h):
   - `{status:'0', message:'Mới nhắc lúc {HH:MM dd/MM}, vui lòng chờ {X giờ} trước khi nhắc lại', data:{}}`.
7. **Permission**: user phải view được nhu cầu chứa `consultation_interest` đó. Áp dụng cùng rule như `get_activities_consultation` cho consultation đó. 403 → `{status:'0', message:'Không có quyền', data:{}}`.
8. **Create work record**:
   - `template_id`: cấp mới — **đề xuất `template_id = 43`**, BE quyết số cuối.
   - `code`: `verification_reminder`
   - `tablename`: `consultation_interest`, `table_id`: theo request
   - `status`: `completed` (set ngay khi create)
   - `name`: auto, vd `"Nhắc xác thực BĐS {real_estate.title hoặc code}"`
   - `description`: nếu có `note` → dùng làm description; nếu không, để `null` hoặc copy `name`.
   - `assigned_to`: ID đầu chủ (để filter "việc của tôi" sau này).
   - `started_at`: `request.now`
   - `created_by`: user hiện tại
9. **Send notification** cho đầu chủ:
   - Tạo bản ghi `notification` (`type` BE quyết — có thể tái sử dụng `type=1` "Giao dịch" hoặc tạo type mới cho "Xác thực").
   - Title: `"Nhắc xác thực BĐS"`
   - Body: `"{Tên CTV} nhắc bạn xác thực BĐS '{real_estate.code/title}' trong nhu cầu của khách {customer_name}"`
   - Deep link payload: `{ "type": "verification", "real_estate_id": <real_estate.id> }` (FE route `/xac-thuc-bds/{id}`).
   - FCM push tới `equipment_token` của đầu chủ (nếu có).
10. **Response success**:

```json
{
  "status": "1",
  "message": "Đã gửi nhắc xác thực",
  "data": {
    "work": {
      "id": 12345,
      "code": "verification_reminder",
      "template_id": 43,
      "name": "Nhắc xác thực BĐS BDS-100234",
      "status": "completed",
      "tablename": "consultation_interest",
      "table_id": 8842,
      "assigned_to": 25,
      "started_at": "2026-05-17T14:30:00"
    },
    "work_id": 12345,
    "notification_sent": true
  }
}
```

> Field `notification_sent` là optional cho FE biết noti đã gửi thành công hay không (vd có thể đầu chủ không có equipment_token). Nếu BE không trả cũng OK.

---

## Edge cases

| Trường hợp | Hành vi BE | Hành vi FE |
|---|---|---|
| BDS không có trong nhu cầu (`consultation_interest.id` invalid) | status=0 + message | Toast error |
| BDS chưa có đầu chủ | status=0 + message | Toast info; dialog mode "create" có thể disable submit |
| BDS đã `success` | status=0 + message | Toast info, không retry |
| Trong cooldown | status=0 + message ghi rõ thời gian + còn bao lâu | Toast warning, đóng dialog |
| Đầu chủ không có equipment_token | Vẫn tạo work + in-app noti record, nhưng FCM skip. `notification_sent` có thể `false` nhưng `status='1'` | Toast success bình thường |
| User không có quyền view nhu cầu | status=0 hoặc HTTP 403 | Toast error |

---

## Activity feed integration

Work mới sẽ tự xuất hiện trong response `get_activities_consultation` (vì cùng scope `consultation_interest` + `table_id`). FE đã có timeline mapping. Cần update:

### Mapping bảng `work_type` (FE đã handle qua `work_type` field BE trả)

| `work_type` | `template_id` | Tên hiển thị FE |
|---|---|---|
| `appointment` | 4 | Lịch hẹn |
| `deposit` | 29 | Đặt cọc |
| `note` | 42 | Ghi chú |
| **`verification_reminder`** (mới) | **43** (đề xuất) | **Nhắc xác thực** |

BE cần đảm bảo `work_type='verification_reminder'` được trả trong response item của `get_activities_consultation` cho work loại này.

---

## Backward compat

Endpoint `create_work_consultation` đã accept các param cũ (xem section "Backward compat" trong `API_Consultation_Activities.md`). Code `verification_reminder` là **giá trị mới của field `code`** — không break backward compat.

---

## FE wiring (đã sẵn sàng)

Sau khi BE deploy:

| File FE | Thay đổi |
|---|---|
| `src/types/consultation-activity.ts` | Extend `CreateWorkPayloadSchema.code` enum: thêm `'verification_reminder'`. Extend `WorkTypeSchema`: thêm `'verification_reminder'`. |
| `src/components/bds/remind-verification-dialog.tsx` | Thay TODO bằng `useCreateWork().mutateAsync({ code:'verification_reminder', tablename:'consultation_interest', table_id, note })`. Accept prop mới `consultationInterestId`. |
| `src/components/nhu-cau/working-bds/working-bds-section.tsx` | Pass `consultationInterestId={verifyItem?.consultation_interest_id}` vào `RemindVerificationDialog`. |
| `src/components/nhu-cau/working-bds/working-bds-row-expanded.tsx` | `workTypeToKind` thêm case `verification_reminder` → `'verify'` để hiện icon đúng trong timeline. |

---

## Câu hỏi cho BE

1. **`template_id`**: đồng ý số `43`? Hay BE muốn số khác → confirm để FE update doc.
2. **Notification type**: tạo type mới (vd `3=Xác thực`) hay tái sử dụng `1=Giao dịch`? Ảnh hưởng tới filter notification screen của FE.
3. **Cooldown window**: 24h OK không? Có cần BE expose qua config endpoint để FE/admin có thể tinh chỉnh không, hay hard-code đủ rồi.
4. **`note` field**: BE có muốn nhận và lưu vào `description` của work, hay ignore? FE hiện đang gửi (optional).

---

## Estimated effort BE

- Logic endpoint: thêm 1 nhánh `if code == 'verification_reminder'` trong handler `create_work_consultation` hiện có (~30 dòng).
- Notification sender: tái sử dụng module FCM hiện có.
- DB: thêm 1 row template (`template_id=43`, `code=verification_reminder`).

Tổng: **~0.5 ngày**.

---

<a id="docs-11-be-requirements-missing-apis-md"></a>

## docs/11-be-requirements-missing-apis.md

---
title: "Yêu cầu BE — API còn thiếu & cần bổ sung"
type: be-requirements
date: 2026-05-20
status: draft
audience: BE team (Python Web2py V1)
related:
  - docs/03-be-questions.md
  - docs/screens/hop-dong-trich-thuong-screens.md
  - docs/screens/khach-hang-screens.md
---

# Yêu cầu BE — API còn thiếu & cần bổ sung

> **Context:** FE team đã review toàn bộ codebase webapp Agent (2026-05-20). Phần lớn module đã có API thực (~105+ endpoints). Tài liệu này tổng hợp các endpoint **còn thiếu hoặc chưa đủ**, phân theo mức độ ưu tiên.
>
> **Cách sử dụng:** BE điền đáp vào phần **BE Response** của từng item. FE sẽ không bắt đầu implement module tương ứng cho đến khi có câu trả lời.

---

## Tóm tắt theo priority

| Priority | Module | Số items |
|----------|--------|---------|
| P1 — Blocking MVP | Khách hàng, Hợp đồng trích thưởng | 8 |
| P2 — Blocking feature | Dashboard, Notification, Rank | 5 |
| P3 — Nice to have | Export, Comment HĐ, Bulk | 4 |

---

## P1 — Blocking MVP

### [HĐ-1] BDS verify picker — `list_real_estate_salesman` confirm params

**Module:** Hợp đồng trích thưởng — Drawer Tạo HĐ, Step 1 (Chọn BĐS)

**Context:** FE cần combobox autocomplete hiển thị danh sách BDS đã verify thuộc CTV hiện tại. Hiện có endpoint `GET /api_agent/list_real_estate_salesman` nhưng chưa rõ params đầy đủ.

**Câu hỏi:**
- a) Endpoint chính xác: `/api_agent/list_real_estate_salesman?verify=1&salesman_id=me` — `me` literal hay phải truyền id thực?
- b) Có param `search` để debounce autocomplete không? (FE cần tìm theo mã BDS / địa chỉ)
- c) Response item shape — confirm FE cần: `{id, code, address, price, owner_name, owner_phone, has_exclusive_contract}`?
- d) Field `has_exclusive_contract: bool` có sẵn trong response không? FE cần disable item này (BDS đã có HĐ độc quyền active).
- e) Có pagination (`page`, `limit`) không? (FE dùng infinite scroll khi CTV có nhiều BDS)

**BE Response:**
```
(chờ)
```

---

### [HĐ-2] Pre-check `has_exclusive_contract` flag trên BDS detail

**Module:** Hợp đồng trích thưởng — BDS detail page, button "Tạo HĐ trích thưởng"

**Context:** Khi CTV xem BDS detail, cần biết BDS có đang active HĐ độc quyền (`contract_type=3`) không để ẩn/disable nút "Tạo HĐ trích thưởng".

**Câu hỏi:**
- a) `GET /api_customer/property.json?id=X` (BDS detail) có trả field `has_exclusive_contract: bool` không?
- b) Nếu không — BE có thể thêm field này vào response không?
- c) Hay FE phải tự call endpoint riêng để check?

**BE Response:**
```
(chờ)
```

---

### [HĐ-3] Status counts cho HĐ trích thưởng (tabs số lượng)

**Module:** Hợp đồng trích thưởng — List, tabs trạng thái (7 tabs)

**Context:** FE hiện dùng `POST /bds_transaction_management/get_status_contract` để lấy count theo status. Cần confirm endpoint này hoạt động được cho `contract_type IN [2,3]`.

**Câu hỏi:**
- a) Endpoint `get_status_contract` nhận param `contract_types` (giống `contracts_by_types`) không?
- b) Response shape: `{status_1: count, status_2: count, ...}` hay array?
- c) Nếu không hỗ trợ — BE cần tạo endpoint mới hay FE tự count từ list?

**BE Response:**
```
(chờ)
```

---

### [HĐ-4] Pagination `/api_customer/contracts.json`

**Module:** Hợp đồng trích thưởng — List

**Context:** Screen spec ghi nhận endpoint `GET /api_customer/contracts.json?app=2` có thể không hỗ trợ pagination, sẽ vỡ khi >100 HĐ.

**Câu hỏi:**
- a) Endpoint này có `page`, `limit` params không?
- b) Response có trả `pagination: {total, pages, page, limit}` không?
- c) Nếu chưa có — BE có plan thêm pagination không, hay FE nên dùng `contracts_by_types` thay thế (endpoint đã có pagination)?

**BE Response:**
```
(chờ)
```

---

### [HĐ-5] Comment / Ghi chú cho hợp đồng

**Module:** Hợp đồng trích thưởng — Tab "Ghi chú" (và HĐ môi giới)

**Context:** Tab Ghi chú hiện là placeholder vì BE chưa có endpoint comment cho entity `contract`. FE đang dùng `POST /api_agent/salesman_comments` với `tablename=consultation` — cần tương tự cho hợp đồng.

**Câu hỏi:**
- a) `allowed_tables` whitelist trong `salesman_comments` endpoint có thể thêm `'contract'` không?
- b) Sau khi thêm, FE gọi:
  - `GET /api_agent/salesman_comments?table_id={contract_id}&tablename=contract`
  - `POST /api_agent/salesman_comments` với `{table_id, tablename: 'contract', content}`
  — shape này đúng không?
- c) Có field `note_type` (work-note vs comment) như consultation không?

**BE Response:**
```
(chờ)
```

---

### [HĐ-6] PDF CORS — cho domain web Agent

**Module:** Hợp đồng trích thưởng — Tab "Tài liệu", PDF iframe

**Context:** FE cần embed PDF hợp đồng trong `<iframe>` hoặc PDF viewer. File nằm tại `/static/uploads/contracts/<year>/<file>.pdf` trên BE domain. Nếu CORS không allow → iframe bị block.

**Câu hỏi:**
- a) Server BE có CORS header `Access-Control-Allow-Origin` cho domain web Agent (`https://agent.tongkhobds.com`) trên static files không?
- b) Nếu không — BE có thể thêm không? Hay FE phải proxy PDF qua Next.js Route Handler?
- c) URL pattern chính xác của file PDF hợp đồng (để FE build URL đúng)?

**BE Response:**
```
(chờ)
```

---

### [KH-1] Danh sách Khách hàng — wiring API thực

**Module:** Khách hàng — List (`/khach-hang`)

**Context:** Trang Khách hàng hiện dùng `MOCK_CUSTOMERS` hardcoded. Endpoint `GET /api_agent/get_list_customer.json` đã tồn tại nhưng FE chưa wire vì không rõ response shape cho webapp Agent.

**Câu hỏi:**
- a) `GET /api_agent/get_list_customer.json` — confirm params: `page`, `limit`, `search`?
- b) Response item shape — FE cần: `{id, full_name, phone, email, cccd, created_on, related_bds_count, related_transaction_count}`?
- c) Filter theo "khách của tôi" vs "tất cả" — có param `owner=me` không?
- d) Có tabs phân loại khách (khách mua, khách thuê, khách đầu tư)?

**BE Response:**
```
(chờ)
```

---

### [KH-2] Chi tiết Khách hàng

**Module:** Khách hàng — Detail (`/khach-hang/[id]`)

**Context:** Chưa có màn detail khách hàng. FE cần endpoint để hiển thị full profile + lịch sử tương tác.

**Câu hỏi:**
- a) Endpoint get customer detail: `/api_agent/get_customer_detail?id=X` có tồn tại không?
- b) Response shape — FE cần: `{id, full_name, phone, email, address, cccd, birthday, gender, notes, created_on, related_consultations[], related_transactions[], related_appointments[]}`?
- c) Nếu chưa có endpoint — BE có plan tạo không, hay FE merge từ nhiều endpoint?

**BE Response:**
```
(chờ)
```

---

## P2 — Blocking Feature

### [DASH-1] Dashboard analytics — Đầu chủ (Xác thực BDS)

**Module:** Dashboard Đầu chủ (`/dau-chu`)

**Context:** Toàn bộ trang Đầu chủ đang dùng `MOCK_DASHBOARD_DATA` hardcoded (KPI tiles, charts, leaderboard). Cần endpoint thực từ BE.

**Câu hỏi:**
- a) Có endpoint tổng hợp stats xác thực BDS theo team/cá nhân không? Propose:
  - `GET /api_agent/verification_dashboard_team` — stats đội nhóm
  - `GET /api_agent/verification_dashboard_me` — stats cá nhân
- b) Stats FE cần (theo period `today/week/month/quarter`):
  - Tổng BDS đã giao (`assigned_count`)
  - Đang xử lý (`in_progress_count`)
  - Hoàn thành (`done_count`)
  - Quá hạn (`overdue_count`)
  - Tỷ lệ thành công (`success_rate`)
  - Thời gian xử lý trung bình (`avg_processing_days`)
- c) Leaderboard agent theo số BDS verify thành công trong kỳ — có endpoint không?
- d) Chart dữ liệu theo ngày (timeseries 30 ngày) — có endpoint không?

**BE Response:**
```
(chờ)
```

---

### [RANK-1] Rank progress — gap đến rank tiếp theo

**Module:** Rank / Rankings

**Context:** FE đang dùng `generateMockRankGap()` (seeded random) để hiển thị "còn X đơn nữa lên rank tiếp". Endpoint `GET /api_agent/ranking.json` hiện tại không có thông tin gap.

**Câu hỏi:**
- a) Endpoint `ranking.json` có thể thêm field `next_rank_gap: {target_rank, current_value, target_value, gap}` không?
- b) Hay cần endpoint riêng `GET /api_agent/rank_progress`?
- c) `delta_percent` (tăng/giảm so với kỳ trước) có sẵn không?

**BE Response:**
```
(chờ)
```

---

### [NOTIF-1] Notifications list endpoint

**Module:** Thông báo (`/notifications`)

**Context:** Trang notifications tồn tại nhưng chưa wire API. FE cần endpoint để load danh sách thông báo.

**Câu hỏi:**
- a) Endpoint chính xác để lấy danh sách thông báo: `/api_agent/get_notifications` hay path khác?
- b) Params: `page`, `limit`, `type` (1=Giao dịch, 2=Hệ thống)?
- c) Response item shape — FE cần: `{id, type, title, body, is_read, created_on, related_entity_id, related_entity_type}`?
- d) Endpoint mark as read: path + method + payload?
- e) Có endpoint `mark_all_as_read` không?

**BE Response:**
```
(chờ)
```

---

### [HĐ-7] CTV đầu chủ identifier khi BDS có nhiều CTV

**Module:** Hợp đồng trích thưởng — Business rule

**Context:** BDS có thể có nhiều CTV (`salesman_id` chính + `salesman_support`). Khi hiển thị "CTV đầu chủ" trên HĐ trích thưởng, FE cần biết ai là chính.

**Câu hỏi:**
- a) Field nào trong `real_estate_salesman` identify CTV đầu chủ chính (không phải support)?
- b) Có flag `is_primary: bool` hay FE dùng field `salesman_id` (không phải `salesman_support_id`)?
- c) CTV nào được phép tạo HĐ trích thưởng — chỉ `salesman_id` chính hay cả `salesman_support`?

**BE Response:**
```
(chờ)
```

---

### [HĐ-8] Notification chủ nhà sau khi admin duyệt HĐ

**Module:** Hợp đồng trích thưởng — Flow status 1→2

**Context:** Sau khi admin duyệt HĐ (status 1→2), chủ nhà cần nhận thông báo để vào app Flutter ký. FE webapp không handle phần này nhưng cần biết để hiển thị hướng dẫn đúng.

**Câu hỏi:**
- a) Kênh notify chủ nhà sau duyệt: Push notification app, SMS, hay Zalo OA?
- b) FE webapp có cần trigger gì, hay BE tự động gửi sau khi duyệt?
- c) Có thể "gửi lại thông báo" cho chủ nhà từ webapp không? Endpoint nào?

**BE Response:**
```
(chờ)
```

---

## P3 — Nice to have

### [EXP-1] Export Excel — nhiều module

**Module:** Danh sách HĐ trích thưởng, HĐ môi giới, Khách hàng, Giao dịch

**Context:** Nhiều trang danh sách có nút "Xuất Excel" nhưng chưa có API. User cần export để báo cáo.

**Câu hỏi:**
- a) BE có plan implement export Excel/CSV không?
- b) Propose pattern: `GET /api_agent/export_contracts_trich_thuong?contract_types=2,3&format=xlsx`
- c) Trả về: file download trực tiếp hay URL download tạm thời (presigned)?
- d) Có limit record khi export không (vd max 1000 rows)?

**BE Response:**
```
(chờ)
```

---

### [HĐ-9] Edit / Hủy HĐ trích thưởng status=1

**Module:** Hợp đồng trích thưởng — Actions trên HĐ status "Chờ duyệt"

**Context:** Cần rõ quyền CTV trong giai đoạn chờ duyệt.

**Câu hỏi:**
- a) CTV tạo HĐ có thể tự hủy HĐ status=1 không, hay phải qua admin?
- b) Edit HĐ status=1 — có endpoint không? Payload gì có thể sửa (chỉ `signing_method`, hay cả `contract_type`)?
- c) Khi hủy → status chuyển về bao nhiêu? (status=5 Hủy hay status khác?)

**BE Response:**
```
(chờ)
```

---

### [HĐ-10] Field ưu tiên display tài chính

**Module:** Hợp đồng trích thưởng — Section 5 Tài chính

**Context:** Response HĐ trích thưởng có cả `text_percent` (text mô tả) và các field số `deposit_percent`, `completion_payout_percent`. FE không rõ ưu tiên hiển thị.

**Câu hỏi:**
- a) `text_percent` là text tổng hợp (vd "2% giá trị BĐS"), còn `deposit_percent`/`completion_payout_percent` là tách riêng phần trăm từng đợt?
- b) Nên hiển thị cả hai hay chỉ một trong hai?
- c) Khi nào `text_percent` null — FE fallback sang số?

**BE Response:**
```
(chờ)
```

---

### [Q-ROLE] `role_label` trong user profile (carry-over từ Q18)

**Module:** All — Role display

**Context:** Câu hỏi Q18 trong `03-be-questions.md` (2026-04-23) vẫn chờ. FE hiện `inferRole()` từ nhiều field. Nếu BE expose `role_label` sẽ bỏ được logic infer phức tạp.

**Câu hỏi:**
- a) BE có thể thêm `role_label: 'KH'|'CTV'|'TP'|'GDK'|'ADMIN'` vào response `get_user_profile.json` không?
- b) Nếu không — FE giữ workaround `inferRole()` từ `step` + `salesman_type` + `auth_group`.

**BE Response:**
```
(chờ)
```

---

## Backlog mở (từ audit — chưa schedule)

Các item dưới đây phát hiện trong audit nhưng chưa có timeline rõ:

| # | Item | Module | Note |
|---|------|--------|------|
| B1 | `get_commission_default.json` logic thực tế | Create BDS | Hiện hardcode mock (min=2, max=100). Ảnh hưởng UX wizard |
| B2 | District_id relaxation cho 2-cấp mode | Create BDS, Commission | Q14 trong `03-be-questions.md` vẫn chờ |
| B3 | Tag endpoint `assign_tags_to_entity` path | Consultation | Q15 vẫn chờ |
| B4 | `selection_type: 'single'|'multi'` cho tag groups | All tagging | Q19 vẫn chờ |
| B5 | Pivot table `consultation_property` | Nhu cầu × Working BDS | Q21 vẫn chờ |
| B6 | `demand_suggest.json` thêm `owner` per item | Nhu cầu | Q22 vẫn chờ |
| B7 | Endpoint "Yêu cầu xác thực BDS" | Nhu cầu × Working BDS | Q23 vẫn chờ |

---

## Deadline mong đợi

| Priority | Deadline | Unblocks |
|----------|----------|---------|
| P1 (HĐ-1 → KH-2) | **2026-05-27** | FE bắt đầu impl Hợp đồng trích thưởng + Khách hàng |
| P2 (DASH, RANK, NOTIF) | **2026-06-10** | Dashboard + Notifications module |
| P3 (Export, Edit HĐ) | **2026-06-24** | Feature complete |

---

## Liên hệ

FE lead: Thoai (branch `hotfix/thoai-fix-hop-dong-trich-thuong`)
BE lead: [điền tên/Slack]

---

*Tài liệu này bổ sung cho `docs/03-be-questions.md` (Q1-Q26). Các câu hỏi cũ vẫn còn hiệu lực — xem phần "Unresolved questions" trong file đó.*

---

<a id="docs-12-be-api-hop-dong-trich-thuong-md"></a>

## docs/12-be-api-hop-dong-trich-thuong.md

---
title: "BE API — Hợp đồng trích thưởng"
date: 2026-05-20
status: ready
related: screens/hop-dong-trich-thuong-screens.md
---

# BE API — Hợp đồng trích thưởng

Tài liệu này mô tả 8 API/field liên quan đến luồng **Hợp đồng trích thưởng** (Commission Contract) trong hệ thống Tongkho BDS Agent App.

Base URL: `https://quanly.tongkhobds.com/tongkho`

**Auth chung:** Tất cả endpoint yêu cầu `Authorization: Bearer <jwt_token>` trừ khi ghi rõ khác.

---

## Mục lục

- [HĐ-1] [GET /api_agent/list_real_estate_salesman — Danh sách BDS để chọn khi tạo HĐ](#hđ-1-get-api_agentlist_real_estate_salesman)
- [HĐ-2] [GET /api_customer/property.json — Field has_exclusive_contract](#hđ-2-get-api_customerpropertyjson--field-has_exclusive_contract)
- [HĐ-3] [POST /bds_transaction_management/get_status_contract — Thống kê trạng thái HĐ](#hđ-3-post-bds_transaction_managementget_status_contract)
- [HĐ-4] [GET /api_customer/contracts.json — Danh sách HĐ có phân trang](#hđ-4-get-api_customercontractsjson)
- [HĐ-5] [Comments cho hợp đồng](#hđ-5-comments-cho-hợp-đồng)
- [HĐ-6] [PDF contract URL](#hđ-6-pdf-contract-url)
- [HĐ-7] [Field is_primary_ctv](#hđ-7-field-is_primary_ctv)
- [HĐ-8] [Notification sau khi HĐ được duyệt](#hđ-8-notification-sau-khi-hđ-được-duyệt)

---

## [HĐ-1] GET /api_agent/list_real_estate_salesman

**Status:** ✅ Ready
**Auth:** JWT Bearer

Trả về danh sách BDS đã xác thực của CTV hiện tại — dùng làm picker khi tạo HĐ trích thưởng. `salesman_id` được tự động resolve từ JWT token, không cần và không được truyền lên.

### Request

`GET /api_agent/list_real_estate_salesman.json`

| Param | Type | Required | Default | Mô tả |
|-------|------|----------|---------|-------|
| `verify` | integer | No | `0` | Lọc chỉ BDS đã xác thực. Truyền `verify=1` để chỉ lấy BDS đã verify |
| `search` | string | No | — | Tìm kiếm theo mã BDS (`code`/`real_estate_code`) hoặc địa chỉ |
| `page` | integer | No | `1` | Trang hiện tại (1-based) |
| `limit` | integer | No | `20` | Số item mỗi trang, tối đa 100 |

### Response

```json
{
  "success": true,
  "data": [
    {
      "id": 1042,
      "code": "BDS-00123",
      "address": "123 Nguyễn Huệ, Q1, TP.HCM",
      "real_estate_value": 5000000000,
      "owner_name": "Nguyễn Văn A",
      "owner_phone": "0901234567",
      "has_exclusive_contract": false,
      "is_primary_ctv": true
    }
  ],
  "pagination": {
    "total": 45,
    "pages": 3,
    "page": 1,
    "limit": 20
  }
}
```

**Mô tả các field trong `data[]`:**

| Field | Type | Mô tả |
|-------|------|-------|
| `id` | integer | ID của `real_estate_salesman` (không phải `real_estate.id`) — dùng làm `real_estate_salesman_id` khi tạo HĐ |
| `code` | string | Mã BDS hiển thị |
| `address` | string | Địa chỉ BDS |
| `real_estate_value` | integer | Giá trị BDS (VNĐ) |
| `owner_name` | string | Tên chủ nhà |
| `owner_phone` | string | SĐT chủ nhà |
| `has_exclusive_contract` | boolean | BDS này đã có HĐ độc quyền đang hoạt động (contract_type=3, status khác 5 và 6) |
| `is_primary_ctv` | boolean | CTV hiện tại có phải CTV chính của BDS này không |

### Error codes

| Mã lỗi | Message | Nguyên nhân |
|--------|---------|-------------|
| `success: false` | `"Chưa đăng nhập"` | Token không hợp lệ hoặc hết hạn |
| `success: false` | `"Tài khoản không có salesman id"` | User không được liên kết salesman |
| `success: false` | `"Tham số không hợp lệ"` | `page` hoặc `limit` không phải số nguyên |

### FE Notes

- **Luôn truyền `verify=1`** khi dùng cho picker tạo HĐ trích thưởng — chỉ BDS đã xác thực mới đủ điều kiện tạo HĐ.
- Disable (không cho chọn) các item có `has_exclusive_contract=true`. Hiện tooltip: `"BDS này đã có HĐ độc quyền"`.
- Debounce `search` tối thiểu 300ms trước khi gửi request.
- `id` trả về là `real_estate_salesman.id` — đây là giá trị cần dùng khi submit tạo HĐ, không phải `real_estate.id`.
- `real_estate_value` là số nguyên VNĐ thô (ví dụ `5000000000` = 5 tỷ). FE tự format hiển thị.

---

## [HĐ-2] GET /api_customer/property.json — field `has_exclusive_contract`

**Status:** ✅ Ready
**Auth:** JWT Bearer

Field mới bổ sung vào response của endpoint BDS detail hiện có. Không có endpoint mới, chỉ có field mới trong response.

### Request

`GET /api_customer/property.json?id={real_estate_id}`

| Param | Type | Required | Default | Mô tả |
|-------|------|----------|---------|-------|
| `id` | integer | Yes | — | ID của bất động sản (`real_estate.id`) |

### Response (phần field mới bổ sung)

```json
{
  "success": true,
  "data": {
    "id": 501,
    "title": "Nhà phố 3 tầng Q.Bình Thạnh",
    "...": "...các field hiện có khác...",
    "has_exclusive_contract": false
  }
}
```

**Field mới:**

| Field | Type | Mô tả |
|-------|------|-------|
| `has_exclusive_contract` | boolean | `true` nếu BDS này (ở cấp property) đang có ít nhất một HĐ độc quyền đang hoạt động (contract_type=3, status khác 5 và 6) — kiểm tra TOÀN BỘ salesman của property, không chỉ salesman hiện tại |

### FE Notes

- Đây là kiểm tra ở **property-level**: nếu bất kỳ salesman nào của BDS đã có HĐ độc quyền thì field này là `true`, kể cả khi CTV hiện tại chưa tạo HĐ.
- Dùng field này để ẩn/hiện nút **"Tạo HĐ trích thưởng"** trên màn hình chi tiết BDS: nếu `has_exclusive_contract=true` thì disable hoặc ẩn nút, hiện thông báo giải thích.
- Phân biệt với `has_exclusive_contract` ở [HĐ-1]: logic tương tự nhưng context khác (list picker vs detail view).

---

## [HĐ-3] POST /bds_transaction_management/get_status_contract

**Status:** ✅ Ready
**Auth:** Session cookie (endpoint CMS — xem FE Notes)

Trả về số lượng HĐ theo từng trạng thái. Hỗ trợ lọc nhiều `contract_type` cùng lúc qua param mới `contract_types`.

### Request

`POST /bds_transaction_management/get_status_contract`

Body (JSON hoặc form):

| Param | Type | Required | Default | Mô tả |
|-------|------|----------|---------|-------|
| `contract_types` | string | No | — | Danh sách loại HĐ, phân cách bằng dấu phẩy. VD: `"2,3"` để lấy cả HĐ thông thường và độc quyền |
| `contract_type` | integer | No | — | Loại HĐ đơn lẻ (tương thích ngược). Bị bỏ qua nếu `contract_types` đã được truyền |
| `filter` | object | No | `{}` | Object filter bổ sung (nếu cần) |

**Ưu tiên parse:** `contract_types` (query param) > `contract_type` (query param) > `filter.contract_types` > `filter.fil_contract_type` > `filter.contract_type`.

### Response

```json
{
  "success": true,
  "data": {
    "0": 152,
    "1": 12,
    "2": 35,
    "3": 8,
    "4": 67,
    "5": 20,
    "6": 10
  }
}
```

**Ý nghĩa các key trong `data`:**

| Key | Trạng thái | Mô tả |
|-----|-----------|-------|
| `"0"` | Tổng | Tổng số HĐ (tất cả trạng thái) |
| `"1"` | Chờ duyệt | Pending approval |
| `"2"` | Chờ diễn ra | In progress — đã duyệt, chờ ký |
| `"3"` | Chờ xác nhận | Waiting confirmation |
| `"4"` | Thành công | Completed |
| `"5"` | Hủy | Cancelled |
| `"6"` | Từ chối | Rejected |

### Error codes

| Mã lỗi | Message | Nguyên nhân |
|--------|---------|-------------|
| `success: false` | `"Lỗi lấy danh sách trạng thái nhu cầu: ..."` | Lỗi server hoặc tham số không hợp lệ |

### FE Notes

- Truyền `contract_types=2,3` để lấy counts gộp cho cả 2 loại HĐ trích thưởng (thông thường + độc quyền) trong cùng một request.
- Endpoint này dùng session-based auth (CMS internal), không dùng JWT Bearer. Nếu FE Agent App cần gọi trực tiếp, cần xác nhận thêm với BE về auth flow hoặc dùng endpoint tương đương có JWT.
- Giá trị key là **string** (`"0"`, `"1"`, ...) không phải integer — TypeScript cần typed mapping khi parse.

---

## [HĐ-4] GET /api_customer/contracts.json

**Status:** ✅ Ready (pagination mới được thêm)
**Auth:** JWT Bearer

Danh sách hợp đồng trích thưởng của CTV. **Thay đổi breaking**: response hiện có phân trang — FE cũ không truyền `page`/`limit` sẽ nhận trang 1 với 20 items, không còn trả về toàn bộ như trước.

### Request

`GET /api_customer/contracts.json`

| Param | Type | Required | Default | Mô tả |
|-------|------|----------|---------|-------|
| `app` | integer | **Yes** | `2` | Luôn truyền `app=2` cho Agent webapp |
| `page` | integer | No | `1` | Trang hiện tại |
| `limit` | integer | No | `20` | Số item mỗi trang, tối đa 200 |
| `contract_type` | integer | No | — | Lọc theo loại HĐ: `1`=CTV, `2`=Thông thường, `3`=Độc quyền |
| `signing_method` | integer | No | — | Phương thức ký: `1`=Trực tiếp, `2`=Điện tử |
| `status` | integer | No | — | Lọc theo trạng thái (1–6, xem mapping bên dưới) |
| `q` | string | No | — | Tìm kiếm full-text theo mã HĐ, tên BDS, mã BDS, tên chủ nhà, tên CTV |
| `date_from` | string | No | — | Lọc từ ngày tạo, format `YYYY-MM-DD` |
| `date_to` | string | No | — | Lọc đến ngày tạo, format `YYYY-MM-DD` |

### Response

```json
{
  "status": "success",
  "result": [
    {
      "id": 88,
      "signed_status": 0,
      "signing_methods": 2,
      "code": "088/2026/HCM/HĐMG-RESA HOLDING",
      "contract_type": 3,
      "contract_type_name": "Độc quyền",
      "contract_type_image": "https://quanly.tongkhobds.com/tongkho/static/uploads/...",
      "created_on": "2026-05-15T10:30:00",
      "status": 2,
      "status_name": "Chờ diễn ra",
      "title": "BDS 80m2",
      "price": "5 tỷ",
      "address": "123 Lê Lợi, Q1, TP.HCM",
      "name_sale": "CTV Nguyễn Văn B",
      "pdf_url": "https://quanly.tongkhobds.com/tongkho/static/uploads/contracts/2026/088_2026.pdf"
    }
  ],
  "pagination": {
    "total": 38,
    "pages": 2,
    "page": 1,
    "limit": 20
  }
}
```

**Mô tả các field trong `result[]`:**

| Field | Type | Mô tả |
|-------|------|-------|
| `id` | integer | ID hợp đồng |
| `signed_status` | integer | `0` = chưa ký, `1` = đã ký (có `signed_at`) |
| `signing_methods` | integer | `1`=Trực tiếp, `2`=Điện tử |
| `code` | string \| null | Mã HĐ định dạng `NNN/YYYY/OFFICE/HĐMG-RESA HOLDING`. `null` nếu chưa có `contract_no` |
| `contract_type` | integer | `1`=CTV, `2`=Thông thường, `3`=Độc quyền |
| `contract_type_name` | string | Tên loại HĐ |
| `contract_type_image` | string | URL ảnh minh họa theo loại HĐ |
| `created_on` | datetime | Thời điểm tạo HĐ |
| `status` | integer | Trạng thái hiện tại (1–6) |
| `status_name` | string | Tên trạng thái |
| `title` | string | Tiêu đề BDS, VD: `"BDS 80m2"`. Rỗng nếu không có diện tích |
| `price` | string | Giá trị BDS dạng text, VD: `"5 tỷ"`, `"2 tỷ 500 triệu"` |
| `address` | string | Địa chỉ BDS |
| `name_sale` | string | Tên CTV, prefix `"CTV "` |
| `pdf_url` | string \| null | URL file PDF đã ký. `null` nếu chưa ký hoặc chưa đủ thông tin |

**Lưu ý response key:** Response dùng `status: "success"` và `result` (không phải `success: true` và `data` như các API khác). Xem FE Notes.

### Error codes

| Mã lỗi | Message | Nguyên nhân |
|--------|---------|-------------|
| `success: false` | `"Tài khoản này không tồn tại"` | JWT không hợp lệ |
| `success: false` | `"Tài khoản này không có salesman id"` | User chưa được liên kết salesman |

### FE Notes

- **Luôn truyền `app=2`** — không truyền hoặc truyền `app=1` sẽ trả về data của app Tongkho (chủ nhà), lọc theo `owner_account_id` thay vì `salesman_id`.
- **Breaking change:** Response trước đây không có phân trang. FE cũ cần cập nhật để handle `pagination`. Nếu không truyền `page`/`limit`, nhận trang 1 với 20 items.
- Response root key là `status: "success"` (string) và `result` (array), khác với chuẩn `success: true` và `data` của các API khác — cần xử lý riêng trong TypeScript type.
- `pdf_url` chỉ có giá trị khi `signed_status=1`. Xem [HĐ-6] để biết cách xử lý CORS.
- `price` là string đã được format (VD: `"5 tỷ"`), không phải số nguyên — không dùng cho tính toán.
- Endpoint mặc định chỉ trả về HĐ có `contract_type` thuộc `[2, 3]` (trích thưởng). HĐ CTV (type=1) không xuất hiện ở đây.

---

## [HĐ-5] Comments cho hợp đồng

**Status:** ✅ Ready (không cần thay đổi BE)
**Auth:** JWT Bearer (GET không yêu cầu auth riêng, POST yêu cầu)

Sử dụng lại endpoint comments chung, chỉ cần truyền `tablename=contract` và `table_id={contract_id}`.

### GET — Lấy danh sách comments

`GET /api_agent/salesman_comments.json?table_id={contract_id}&tablename=contract`

| Param | Type | Required | Default | Mô tả |
|-------|------|----------|---------|-------|
| `table_id` | integer | Yes | — | ID của hợp đồng |
| `tablename` | string | Yes | — | Luôn truyền `"contract"` |
| `page` | integer | No | `1` | Trang hiện tại |
| `limit` | integer | No | `20` | Số comment mỗi trang |

**Response:**

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": 301,
        "content": "Đã gửi hợp đồng qua email cho chủ nhà",
        "comment_type": "note",
        "visibility": "team",
        "created_at": "2026-05-15T14:22:00",
        "user": {
          "id": 12,
          "name": "Trần Thị B"
        },
        "replies": []
      }
    ],
    "pagination": {
      "total": 5,
      "pages": 1,
      "page": 1,
      "limit": 20
    }
  }
}
```

### POST — Tạo comment mới

`POST /api_agent/salesman_comments.json`

Body (JSON):

| Field | Type | Required | Default | Mô tả |
|-------|------|----------|---------|-------|
| `table_id` | integer | Yes | — | ID hợp đồng |
| `tablename` | string | Yes | — | Luôn truyền `"contract"` |
| `content` | string | Yes | — | Nội dung comment |
| `comment_type` | string | No | `"comment"` | Loại comment (xem bảng dưới) |
| `visibility` | string | No | `"public"` | Phạm vi hiển thị (xem bảng dưới) |
| `reply_to_comment_id` | integer | No | — | ID comment cha nếu là reply |
| `attachments` | string (JSON) | No | — | JSON string mảng attachment objects |

**Giá trị `comment_type`:**

| Giá trị | Mô tả |
|---------|-------|
| `comment` | Bình luận thông thường |
| `note` | Ghi chú nội bộ |
| `status_update` | Cập nhật trạng thái |
| `attachment` | Đính kèm file |
| `mention` | Đề cập người dùng |

**Giá trị `visibility`:**

| Giá trị | Mô tả |
|---------|-------|
| `public` | Tất cả mọi người |
| `private` | Chỉ người tạo |
| `team` | Trong team |
| `admin_only` | Chỉ admin |

**Response:**

```json
{
  "success": true,
  "data": {
    "comment": {
      "id": 302,
      "content": "Chủ nhà đồng ý ký điện tử",
      "comment_type": "note",
      "visibility": "team",
      "created_at": "2026-05-20T09:10:00"
    }
  }
}
```

### Error codes

| Mã lỗi | Message | Nguyên nhân |
|--------|---------|-------------|
| `success: false` | `"Thiếu table_id"` | Không truyền `table_id` |
| `success: false` | `"Lỗi: ..."` | Lỗi server |

### FE Notes

- Đây là endpoint dùng chung cho nhiều loại entity (consultation, contract, v.v.) — chỉ cần đổi `tablename`.
- Với HĐ trích thưởng, dùng `tablename=contract` và `table_id=<contract.id>`.
- `visibility=team` phù hợp cho các ghi chú nội bộ của CTV team.

---

## [HĐ-6] PDF contract URL

**Status:** ❌ Blocked — CORS (infra đang pending)
**Auth:** Không yêu cầu (static file)

URL pattern của file PDF hợp đồng đã ký:

```
https://quanly.tongkhobds.com/tongkho/static/uploads/contracts/{year}/{no}_{year}.pdf
```

Ví dụ: `https://quanly.tongkhobds.com/tongkho/static/uploads/contracts/2026/088_2026.pdf`

Trong đó `{no}` = `contract_no` (số thứ tự HĐ), `{year}` = `contract_year`.

### FE Workaround (bắt buộc dùng khi chờ infra)

Do CORS chưa được cấu hình cho domain FE, **không được gọi trực tiếp từ browser**. Sử dụng Next.js Route Handler làm proxy:

**Tạo file `/app/api/proxy-pdf/route.ts`:**

```typescript
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  const url = request.nextUrl.searchParams.get('url');
  if (!url || !url.startsWith('https://quanly.tongkhobds.com/tongkho/static/')) {
    return NextResponse.json({ error: 'Invalid URL' }, { status: 400 });
  }

  const res = await fetch(url);
  if (!res.ok) {
    return NextResponse.json({ error: 'Not found' }, { status: res.status });
  }

  const buffer = await res.arrayBuffer();
  return new NextResponse(buffer, {
    headers: {
      'Content-Type': 'application/pdf',
      'Content-Disposition': 'inline',
    },
  });
}
```

**Sử dụng trên FE:**

```typescript
// Thay vì dùng pdf_url trực tiếp từ API
const safePdfUrl = `/api/proxy-pdf?url=${encodeURIComponent(pdf_url)}`;
```

### FE Notes

- `pdf_url` từ [HĐ-4] và `contract_pdf` từ `contract_content_by_id` đều theo pattern này.
- Validate URL trên proxy để chỉ cho phép domain `quanly.tongkhobds.com` — ngăn open redirect.
- `pdf_url` chỉ tồn tại khi `signed_status=1` (đã ký) và có đủ `contract_no` + `contract_year`.
- Khi infra CORS được fix, chỉ cần bỏ proxy và dùng `pdf_url` trực tiếp — không cần sửa logic khác.

---

## [HĐ-7] Field `is_primary_ctv`

**Status:** ✅ Ready
**Auth:** JWT Bearer (resolve tự động từ token)

Field `is_primary_ctv` được thêm vào response của **hai** endpoint:

1. `GET /api_agent/list_real_estate_salesman.json` — xem [HĐ-1], nằm trong từng item của `data[]`
2. `GET /api_customer/contract_content_by_id.json?contract_id={id}` — nằm ở root level của `data`

### Ý nghĩa

`is_primary_ctv: boolean` — `true` nếu `salesman_id` của CTV đang đăng nhập (resolve từ JWT) trùng với `real_estate_salesman.salesman_id` của BDS/HĐ đó.

Nói cách khác: CTV hiện tại có phải là người đã đăng ký khai thác BDS này không (CTV chính), hay chỉ là người được chia sẻ/xem.

### Ví dụ trong `contract_content_by_id` response

```json
{
  "success": true,
  "data": {
    "contract": { "id": 88, "contract_type": 3 },
    "real_estate_salesman": { "id": 1042, "address": "123 Lê Lợi, Q1" },
    "is_primary_ctv": true
  }
}
```

### FE Notes

- Dùng `is_primary_ctv` để kiểm soát quyền chỉnh sửa/thao tác trên HĐ: CTV không phải CTV chính chỉ được xem, không được tạo HĐ mới cho BDS đó.
- Kết hợp với `has_exclusive_contract` để render trạng thái đầy đủ của nút "Tạo HĐ":
  - `is_primary_ctv=false` → ẩn nút tạo HĐ
  - `is_primary_ctv=true` và `has_exclusive_contract=true` → disable nút, show tooltip "BDS đã có HĐ độc quyền"
  - `is_primary_ctv=true` và `has_exclusive_contract=false` → cho phép tạo HĐ

---

## [HĐ-8] Notification sau khi HĐ được duyệt

**Status:** ✅ Ready
**Auth:** Auto (trigger nội bộ khi admin duyệt) / Session-based (manual resend)

### Cơ chế tự động

Khi admin gọi `POST /bds_transaction_management/browse_contract` với `status=2`, hệ thống **tự động** gửi Firebase push notification đến chủ nhà (owner) của BDS liên quan, không cần FE làm gì thêm.

**Nội dung notification tự động:**
- Title: `"Hợp đồng của bạn đã được duyệt"`
- Body: `"Vui lòng mở app Tổng kho để ký hợp đồng"`
- Deep link: `app.tongkho://contract/contract-preview/id={contract_id}`

Notification chỉ được gửi cho HĐ có `contract_type` thuộc `[2, 3]`.

### Manual resend

`POST /bds_transaction_management/resend_contract_notify`

Dùng khi cần gửi lại thông báo (ví dụ: chủ nhà chưa nhận hoặc chưa mở app để ký).

Body (JSON):

| Field | Type | Required | Mô tả |
|-------|------|----------|-------|
| `contract_id` | integer | Yes | ID hợp đồng cần gửi lại |

**Response thành công:**

```json
{
  "success": true,
  "message": "Đã gửi lại thông báo"
}
```

### Error codes

| Mã lỗi | Message | Nguyên nhân |
|--------|---------|-------------|
| `success: false` | `"Thiếu contract_id"` | Không truyền `contract_id` |
| `success: false` | `"Không tìm thấy hợp đồng"` | `contract_id` không tồn tại hoặc không phải HĐ trích thưởng (contract_type không thuộc [2, 3]) |
| `success: false` | `"Chỉ gửi lại khi HĐ ở trạng thái Chờ diễn ra (status=2)"` | HĐ chưa được duyệt hoặc đã hoàn thành/hủy/từ chối |
| `success: false` | `"Không tìm thấy thông tin chủ nhà"` | `verify_agent` không tìm được salesman liên kết |
| `success: false` | `"..."` | Lỗi server |

### FE Notes

- **Ràng buộc quan trọng:** `resend_contract_notify` chỉ hoạt động khi `contract.status=2` (Chờ diễn ra). Nếu HĐ đang ở trạng thái khác, request sẽ thất bại với message rõ ràng.
- Nút "Gửi lại thông báo" chỉ nên hiển thị (và được enable) khi `status=2`.
- Notification được gửi đến **chủ nhà** (owner) qua Firebase — không phải đến CTV. CTV không nhận notification này.
- Endpoint này dùng session-based auth (CMS), không dùng JWT. Nếu FE Agent App cần tính năng resend, cần xác nhận thêm với BE về auth hoặc tạo wrapper endpoint có JWT.

---

## Phụ lục: Mapping trạng thái và loại HĐ

### Mapping trạng thái (`status`)

Dùng chung cho tất cả endpoint có field `status`:

| status | Tên | Màu gợi ý |
|--------|-----|-----------|
| `1` | Chờ duyệt | `#fbbf24` (vàng) |
| `2` | Chờ diễn ra | `#3b82f6` (xanh dương) |
| `3` | Chờ xác nhận | `#8b5cf6` (tím) |
| `4` | Thành công | `#10b981` (xanh lá) |
| `5` | Hủy | `#6b7280` (xám) |
| `6` | Từ chối | `#ef4444` (đỏ) |

### Mapping loại HĐ (`contract_type`)

| contract_type | Tên |
|---------------|-----|
| `1` | Hợp đồng cộng tác viên (CTV) |
| `2` | Hợp đồng môi giới thông thường |
| `3` | Hợp đồng môi giới độc quyền |

HĐ trích thưởng = `contract_type` thuộc `[2, 3]`.

---

<a id="docs-13-be-api-khach-hang-md"></a>

## docs/13-be-api-khach-hang.md

---
title: "BE API — Khách hàng"
date: 2026-05-20
status: ready
---

# BE API — Khách hàng

> Audience: FE developers (Next.js / TypeScript).
> Base URL: `https://quanly.tongkhobds.com/tongkho`
> Auth: All endpoints require `Authorization: Bearer <token>` header.

---

## [KH-1] GET /api_agent/get_list_customer — List customers

**Status:** Ready

### Request

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `search` | string | — | Free-text search on name / phone |
| `page` | number | `0` | **0-indexed** — page 0 = first page |
| `limit` | number | `10` | Items per page |

### Response

```json
{
  "status": 1,
  "data": [
    {
      "id": 1,
      "full_name": "Nguyễn Văn A",
      "phone": "0901234567",
      "email": "a@example.com",
      "cccd": "",
      "created_on": "2025-01-01T00:00:00",
      "related_bds_count": 0,
      "related_transaction_count": 3
    }
  ]
}
```

### Field notes

| Field | Type | Detail |
|-------|------|--------|
| `id` | number | Customer primary key |
| `full_name` | string | |
| `phone` | string | |
| `email` | string | May be empty |
| `cccd` | string | **Always empty string** — field not in customer schema |
| `created_on` | string | ISO 8601 datetime |
| `related_bds_count` | number | **Always 0** — no direct customer→BDS link in schema |
| `related_transaction_count` | number | Counts rows where `buyer_id` OR `seller_id` matches customer |

### FE integration notes

- `page` is **0-indexed** — this differs from most other paginated endpoints in this project which use `page=1` for the first page. Use `page: currentPage - 1` when building pagination UI.
- Returns **only customers belonging to the current authenticated salesman** — no admin cross-access.
- `cccd` and `related_bds_count` are placeholder fields; do not display them until schema is updated.

---

## [KH-2] GET /api_agent/get_customer_detail — Customer detail

**Status:** Ready

### Request

| Param | Type | Required | Notes |
|-------|------|----------|-------|
| `id` | number | Yes | Customer primary key |

### Response (success)

```json
{
  "success": true,
  "data": {
    "id": 1,
    "full_name": "Nguyễn Văn A",
    "phone": "0901234567",
    "email": "a@example.com",
    "address": "123 Lê Lợi, Q.1, TP.HCM",
    "cccd": "",
    "birthday": "1990-01-01T00:00:00",
    "sex": 1,
    "notes": "Khách hàng VIP",
    "created_on": "2025-01-01T00:00:00",
    "related_consultations": [
      {
        "id": 1,
        "title": "Tìm căn hộ Q.7",
        "status": "active",
        "created_on": "2025-06-01T00:00:00"
      }
    ],
    "related_transactions": [
      {
        "id": 10,
        "status": "completed",
        "created_on": "2025-07-01T00:00:00"
      }
    ],
    "related_appointments": []
  }
}
```

### Response (error)

```json
{
  "success": false,
  "message": "Không tìm thấy khách hàng"
}
```

### Field notes

| Field | Type | Detail |
|-------|------|--------|
| `sex` | number | `1` = Nam, `2` = Nữ. Note: field name is `sex`, **not** `gender` |
| `cccd` | string | **Always empty string** — field not in current schema |
| `birthday` | string | ISO 8601 datetime (time part is midnight, use date only) |
| `related_consultations` | array | Consultations linked to this customer |
| `related_transactions` | array | Transactions where customer appears as buyer or seller |
| `related_appointments` | array | Currently always `[]` — appointment linking not yet wired |

### FE integration notes

- Use `sex` (not `gender`) when mapping to display labels or TypeScript types.
- `cccd` is always `""` — skip rendering until schema migration is confirmed.
- `related_appointments` is always an empty array for now; hide the appointments section or show an empty state.
- Error case returns `success: false` with a Vietnamese message — catch on the `success` flag, not on HTTP status.

---

<a id="docs-14-be-api-dashboard-rank-notif-md"></a>

## docs/14-be-api-dashboard-rank-notif.md

---
title: "BE API — Dashboard, Rank, Notifications"
date: 2026-05-20
status: ready
---

# BE API — Dashboard, Rank, Notifications

> Audience: FE developers (Next.js / TypeScript).
> Base URL: `https://quanly.tongkhobds.com/tongkho`
> Auth: All endpoints require `Authorization: Bearer <token>` header.

---

## [DASH-1] GET /api_agent/verification_dashboard_me — Verification dashboard (self)

**Status:** Ready

### Request

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `period` | string | `week` | One of: `today`, `week`, `month`, `quarter` |

### Response

```json
{
  "success": true,
  "data": {
    "period": "week",
    "assigned_count": 10,
    "in_progress_count": 3,
    "done_count": 5,
    "overdue_count": 2,
    "success_rate": 0.5,
    "avg_processing_days": 0,
    "timeseries": [
      { "date": "2026-05-01", "count": 2 }
    ],
    "leaderboard": []
  }
}
```

### Field notes

| Field | Type | Detail |
|-------|------|--------|
| `assigned_count` | number | Total verification tasks assigned in period |
| `in_progress_count` | number | Tasks currently being processed |
| `done_count` | number | Completed tasks |
| `overdue_count` | number | Tasks past their deadline |
| `success_rate` | number | Float 0.0–1.0 (multiply by 100 for percentage) |
| `avg_processing_days` | number | **Always 0** — processing time calculation not yet implemented |
| `timeseries` | array | Daily counts for the selected period |
| `leaderboard` | array | **Always `[]`** for the `_me` endpoint |

### FE integration notes

- `avg_processing_days` is always `0`; either hide the metric or show "—" until BE confirms it is implemented.
- `leaderboard` is intentionally empty for the personal view — only the team variant populates it.

---

## [DASH-1b] GET /api_agent/verification_dashboard_team — Verification dashboard (team)

**Status:** Ready

### Request

Same params as [DASH-1]: `period` (optional, default `week`).

### Response

Same shape as [DASH-1] with two differences:

- Counts aggregate across all org-tree subordinates of the current salesman (organization tree, not referral tree).
- `leaderboard` is populated:

```json
"leaderboard": [
  { "salesman_id": 42, "name": "Trần Thị B", "done_count": 12 }
]
```

Top 10 members by `done_count` within the period.

---

## [RANK-1] GET /api_agent/ranking — Current rank and next rank gap

**Status:** Ready (new endpoint)

### Request

No params required. Uses JWT to identify the current salesman.

### Response

```json
{
  "success": true,
  "data": {
    "current_rank": "CTV",
    "next_rank_gap": {
      "target_rank": "CTV1",
      "current_value": 3,
      "target_value": 5,
      "gap": 2,
      "delta_percent": 0
    }
  }
}
```

### Field notes

| Field | Type | Detail |
|-------|------|--------|
| `current_rank` | string | Salesman's current rank key |
| `next_rank_gap` | object \| null | `null` if salesman is already at the highest rank |
| `next_rank_gap.target_rank` | string | Rank key to achieve next |
| `next_rank_gap.current_value` | number | Current deal count toward next rank |
| `next_rank_gap.target_value` | number | Deal count threshold for next rank |
| `next_rank_gap.gap` | number | `target_value - current_value` |
| `next_rank_gap.delta_percent` | number | **Always 0** — historical comparison not yet implemented |

### Rank thresholds

| Rank | Minimum deals |
|------|--------------|
| CTV | 0 |
| CTV1 | 5 |
| CTV2 | 10 |
| TP | 20 |
| GDK | 50 |

### FE integration notes

- Always check `next_rank_gap !== null` before rendering the progress widget.
- `delta_percent` is always `0`; hide or omit the trend indicator until BE confirms it is implemented.

---

## [NOTIF-1] GET /api_agent/get_notifications — List notifications

**Status:** Ready (partial — `is_read` tracking not yet active)

### Request

| Param | Type | Default | Notes |
|-------|------|---------|-------|
| `page` | number | `1` | 1-indexed |
| `limit` | number | `20` | Items per page |
| `type` | number | `0` | `0` = all, `1` = transaction, `2` = system |

### Response

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "type": 1,
      "title": "Hợp đồng #123 đã được xác nhận",
      "body": "Chi tiết nội dung thông báo...",
      "is_read": false,
      "created_on": "2026-05-20T10:00:00",
      "related_entity_id": 123,
      "related_entity_type": "contract"
    }
  ],
  "pagination": {
    "total": 50,
    "pages": 3,
    "page": 1,
    "limit": 20
  }
}
```

### Field notes

| Field | Type | Detail |
|-------|------|--------|
| `is_read` | boolean | **Always `false`** — `is_read` field not yet in `log_tracking` schema; a migration is required before read-tracking works |
| `related_entity_id` | number | PK of the linked entity (contract, transaction, etc.) |
| `related_entity_type` | string | Entity type string, e.g., `"contract"`, `"transaction"` |

### FE integration notes

- Do not build unread-badge logic based on `is_read` yet — all items return `false` regardless of actual read state. Track read state client-side (e.g., in localStorage or Zustand) as a temporary workaround until the schema migration is deployed.
- `pagination` uses 1-indexed `page`, consistent with the standard convention in this project (unlike [KH-1] which is 0-indexed).

---

## [NOTIF-1b] POST /api_agent/mark_notification_read — Mark notification(s) as read

**Status:** Ready (partial — currently a no-op)

### Request body

Mark a single notification:
```json
{ "id": 123 }
```

Mark all notifications as read:
```json
{ "all": true }
```

### Response

```json
{ "success": true }
```

Or, when the schema migration has not been applied:

```json
{ "success": true, "message": "is_read field chưa có trong schema" }
```

### FE integration notes

- The endpoint accepts the request and returns `success: true` in both cases, but has no persistent effect until the `is_read` column is added to `log_tracking`.
- Calling this endpoint is safe and will not error. Implement the call now so that read-marking works automatically once the migration is deployed.
- Detect the no-op state by checking for the `message` field in the response — if present, update UI state only client-side.

---

<a id="docs-api-call-logging-md"></a>

## docs/API_Call_Logging.md

# API Call Logging — Ghi kết quả cuộc gọi

> Use case: Agent gọi cho Khách hàng / Chủ nhà / Đầu chủ → lưu kết quả cuộc gọi vào hệ thống để track lịch sử tương tác.

---

## 1. GHI KẾT QUẢ CUỘC GỌI

### Endpoint
```
POST /api_agent/log_call_outcome.json
```

### Authentication
- Yêu cầu đăng nhập (`@auth.requires_login()`)

### Request Parameters

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---------|------|----------|-------|
| `context_type` | string | Có | `consultation`, `bds`, `deposit`, `contract` |
| `context_id` | int | Có | ID của đối tượng (consultation_id / real_estate_id / deposit_id / contract_id) |
| `phone` | string | Có | Số điện thoại được gọi |
| `outcome` | string | Có | `connected` (Đã kết nối), `no_answer` (Không nghe máy), `busy` (Máy bận), `reject` (Từ chối) |
| `duration_sec` | int | Không | Thời lượng cuộc gọi (giây) — optional, future enhancement |
| `note` | string | Không | Ghi chú về nội dung trao đổi |
| `call_to_role` | string | Không | Vai trò người được gọi: `customer` (Khách hàng), `owner` (Chủ nhà), `broker` (Đầu chủ), `agent` (Agent khác) |
| `related_party_id` | int | Không | ID người được gọi (customer_id / owner_id / broker_id) nếu có |

### Request Example

**Gọi cho Khách hàng (trong context Nhu cầu):**
```json
POST /api_agent/log_call_outcome.json
{
  "context_type": "consultation",
  "context_id": 1444,
  "phone": "0901234567",
  "outcome": "connected",
  "duration_sec": 127,
  "note": "Khách quan tâm căn hộ view sông, hẹn xem lại thứ 7",
  "call_to_role": "customer",
  "related_party_id": 5001
}
```

**Gọi cho Đầu chủ (trong context BDS):**
```json
POST /api_agent/log_call_outcome.json
{
  "context_type": "bds",
  "context_id": 901001,
  "phone": "0912345678",
  "outcome": "no_answer",
  "note": "Đã gọi 2 lần, không nghe máy. Để lại tin nhắn Zalo.",
  "call_to_role": "broker",
  "related_party_id": 7001
}
```

### Response Format

**Success (200):**
```json
{
  "status": "1",
  "message": "Đã ghi nhận kết quả cuộc gọi",
  "data": {
    "id": 9001,
    "logged_at": "2026-05-07T03:24:00Z",
    "activity_log_id": 8001
  }
}
```

**Error (400/500):**
```json
{
  "status": "0",
  "message": "Thiếu tham số bắt buộc: outcome",
  "data": {}
}
```

---

## 2. LẤY LỊCH SỬ CUỘC GỌI

### Endpoint
```
GET /api_agent/get_call_logs.json
```

### Query Parameters

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---------|------|----------|-------|
| `context_type` | string | Có | `consultation`, `bds`, `deposit`, `contract` |
| `context_id` | int | Có | ID của đối tượng |
| `page` | int | Không | Trang hiện tại (default: 1) |
| `limit` | int | Không | Số item/trang (default: 20) |

### Request Example

**Lấy lịch sử cuộc gọi cho Nhu cầu:**
```
GET /api_agent/get_call_logs.json?context_type=consultation&context_id=1444
```

**Lấy lịch sử cuộc gọi cho BDS:**
```
GET /api_agent/get_call_logs.json?context_type=bds&context_id=901001
```

### Response Format

**Success (200):**
```json
{
  "status": "1",
  "message": "Lấy danh sách cuộc gọi thành công",
  "data": {
    "items": [
      {
        "id": 9001,
        "context_type": "bds",
        "context_id": 901001,
        "phone": "0912345678",
        "outcome": "connected",
        "duration_sec": 127,
        "note": "Đầu chủ xác nhận giá còn thương lượng, hẹn gặp thứ 5",
        "call_to_role": "broker",
        "related_party_id": 7001,
        "related_party_name": "Nguyễn Văn Tâm",
        "created_at": "2026-05-07T10:30:00Z",
        "created_by": {
          "id": 123,
          "name": "Anh Tâm",
          "avatar": "https://..."
        }
      },
      {
        "id": 9000,
        "context_type": "bds",
        "context_id": 901001,
        "phone": "0912345678",
        "outcome": "no_answer",
        "note": "Không nghe máy",
        "call_to_role": "broker",
        "related_party_id": 7001,
        "related_party_name": "Nguyễn Văn Tâm",
        "created_at": "2026-05-06T15:20:00Z",
        "created_by": {
          "id": 123,
          "name": "Anh Tâm",
          "avatar": "https://..."
        }
      }
    ],
    "summary": {
      "total_calls": 5,
      "connected": 3,
      "no_answer": 1,
      "busy": 1,
      "reject": 0
    },
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 5,
      "pages": 1
    }
  }
}
```

---

## 3. OUTCOME VALUES

| Value | Label (VN) | Mô tả |
|-------|------------|-------|
| `connected` | Đã kết nối | Cuộc gọi thành công, có trao đổi |
| `no_answer` | Không nghe máy | Không ai nghe máy sau N hồi chuông |
| `busy` | Máy bận | Đang bận, không thể kết nối |
| `reject` | Từ chối | Người được gọi từ chối nghe |

---

## 4. CONTEXT TYPES

| Value | Mô tả | Ví dụ context_id |
|-------|-------|------------------|
| `consultation` | Nhu cầu (Khách mua) | consultation_id |
| `bds` | Bất động sản | real_estate_id |
| `deposit` | Đặt cọc | deposit_work_id |
| `contract` | Hợp đồng | contract_id |

---

## 5. CALL TO ROLE

| Value | Label (VN) | Mô tả |
|-------|------------|-------|
| `customer` | Khách hàng | Người mua/thuê |
| `owner` | Chủ nhà | Chủ sở hữu BĐS |
| `broker` | Đầu chủ | Người môi giới/giới thiệu |
| `agent` | Agent khác | Đồng nghiệp |

---

## 6. FRONTEND INTEGRATION

### API Client

```typescript
// src/lib/api/call-logging.ts

export interface LogCallOutcomePayload {
  context_type: 'consultation' | 'bds' | 'deposit' | 'contract';
  context_id: number | string;
  phone: string;
  outcome: 'connected' | 'no_answer' | 'busy' | 'reject';
  duration_sec?: number;
  note?: string;
  call_to_role?: 'customer' | 'owner' | 'broker' | 'agent';
  related_party_id?: number | string;
}

export async function logCallOutcome(payload: LogCallOutcomePayload) {
  return httpClient<{ id: number; logged_at: string }>('/api_agent/log_call_outcome.json', {
    method: 'POST',
    body: payload,
  });
}

export interface GetCallLogsParams {
  context_type: 'consultation' | 'bds' | 'deposit' | 'contract';
  context_id: number | string;
  page?: number;
  limit?: number;
}

export async function getCallLogs(params: GetCallLogsParams) {
  return httpClient<CallLogsResponse>('/api_agent/get_call_logs.json', {
    method: 'GET',
    params,
  });
}
```

### Hook

```typescript
// src/hooks/use-call-logging.ts

export function useLogCallOutcome() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (payload: LogCallOutcomePayload) => logCallOutcome(payload),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['call-logs'] });
      qc.invalidateQueries({ queryKey: ['activities'] });
    },
  });
}

export function useCallLogs(params: GetCallLogsParams) {
  return useQuery({
    queryKey: ['call-logs', params],
    queryFn: () => getCallLogs(params),
    enabled: !!params.context_id,
  });
}
```

### Usage in CallContactDialog

```tsx
import { useLogCallOutcome } from '@/hooks/use-call-logging';

function CallContactDialog({ context, phone, ... }) {
  const { mutateAsync: logCall, isPending } = useLogCallOutcome();

  async function handleSubmit() {
    if (!outcome) {
      toast.info('Chọn kết quả cuộc gọi');
      return;
    }

    await logCall({
      context_type: context?.type ?? 'consultation',
      context_id: context?.id,
      phone: phone ?? '',
      outcome,
      note,
    });

    toast.success('Đã ghi nhận kết quả cuộc gọi');
    onSaved?.();
    onOpenChange(false);
  }

  // ... rest of UI
}
```

---

## 7. DATABASE SCHEMA PROPOSAL

### Table: `call_logs`

```sql
CREATE TABLE call_logs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  context_type ENUM('consultation', 'bds', 'deposit', 'contract') NOT NULL,
  context_id INT NOT NULL,
  phone VARCHAR(20) NOT NULL,
  outcome ENUM('connected', 'no_answer', 'busy', 'reject') NOT NULL,
  duration_sec INT DEFAULT NULL,
  note TEXT,
  call_to_role ENUM('customer', 'owner', 'broker', 'agent') DEFAULT NULL,
  related_party_id INT DEFAULT NULL,
  created_by_id INT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_context (context_type, context_id),
  INDEX idx_created_at (created_at),
  FOREIGN KEY (created_by_id) REFERENCES auth_user(id)
);
```

---

## VERSION

- **Version**: 1.0.0
- **Last Updated**: 2026-05-15
- **Author**: API Team

---

<a id="docs-api-consultation-activities-md"></a>

## docs/API_Consultation_Activities.md

# API Consultation Activities

API quản lý các hoạt động liên quan đến Nhu cầu (Consultation): Lịch hẹn, Đặt cọc, Ghi chú.

> **Canonical schema (v2)**: tất cả endpoint scope theo entity dùng cặp **`tablename`** + **`table_id`** thống nhất. Với 1 dòng BDS trong "BDS đang làm việc" của 1 nhu cầu mua, dùng `tablename='consultation_interest'` + `table_id=<consultation_interest.id>`.
> Các tên param cũ (`note_type/related_id`, `tab/tab_id`, `real_estate_id/customer_id/consultation_id/internal_id`) vẫn được BE chấp nhận để backward-compat, xem mục "Backward compat" cuối doc.

---

## Quick reference — `tablename` values

| `tablename` | Ý nghĩa | `table_id` là |
|---|---|---|
| `consultation_interest` | 1 dòng BDS đang làm việc trong nhu cầu mua | `consultation_interest.id` |
| `real_estate` | BĐS chung (ngoài context nhu cầu) | `real_estate.id` |
| `customer` | Khách hàng | `customer.id` |
| `consultation` | Nhu cầu mua (consultation root) | `consultation.id` |

---

## 1. TẠO CÔNG VIỆC (Lịch hẹn, Đặt cọc)

### Endpoint
```
POST /tongkho/api_agent/create_work_consultation
```

### Authentication
- Yêu cầu đăng nhập (`@auth.requires_login()`)

### Request Parameters (canonical)

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---|---|---|---|
| `code` | string | Có | `appointment` (Lịch hẹn) · `deposit` (Đặt cọc) · `verification_reminder` (Nhắc xác thực BĐS — xem `docs/10-be-handoff-nhac-xac-thuc-bds.md`) |
| `tablename` | string | Có | Loại entity gắn với work — thường là `consultation_interest` |
| `table_id` | int | Có | ID bản ghi tương ứng `tablename` |
| `started_at` | string | Có* | Thời gian triển khai `YYYY-MM-DDTHH:MM:SS` — Bắt buộc cho Lịch hẹn |
| `location` | string | Không | Địa điểm (cho Lịch hẹn) |
| `deposit_type` | string | Có* | `thien_chi` hoặc `coc_chet` — Bắt buộc cho Đặt cọc |
| `deposit_amount` | int | Có* | Số tiền đặt cọc — Bắt buộc cho Đặt cọc |
| `note` | string | Không | Ghi chú |
| `assigned_to` | int | Không | ID SaleOff phụ trách |
| `post_office_id` | int | Không | ID Văn phòng |
| `buyer_agent_id` | int | Không | ID Agent đầu khách |
| `owner_agent_id` | int | Không | ID Agent đầu chủ |
| `documents` | array | Không | Danh sách document đính kèm |

### Request Example

**Tạo Lịch hẹn cho BDS trong working list:**
```json
POST /tongkho/api_agent/create_work_consultation
{
  "code": "appointment",
  "tablename": "consultation_interest",
  "table_id": 8842,
  "started_at": "2024-05-10T10:00:00",
  "location": "Tầng 5, tòa nhà VP Bank",
  "note": "Khách quan tâm căn hộ view sông",
  "assigned_to": 15
}
```

**Tạo Đặt cọc cho BDS trong working list:**
```json
POST /tongkho/api_agent/create_work_consultation
{
  "code": "deposit",
  "tablename": "consultation_interest",
  "table_id": 8842,
  "deposit_type": "thien_chi",
  "deposit_amount": 50000000,
  "note": "Khách đặt cọc thiện chí, hẹn ký hợp đồng sau 3 ngày",
  "assigned_to": 20,
  "buyer_agent_id": 18,
  "owner_agent_id": 25
}
```

### Response Format

**Success (200):**
```json
{
  "status": "1",
  "message": "Tạo công việc thành công",
  "data": {
    "work": {
      "id": 1234,
      "code": "appointment",
      "template_id": 4,
      "name": "Lịch hẹn xem BĐS VP Bank Tower",
      "description": "Hẹn khách hàng đến xem căn hộ 2PN",
      "status": "waiting",
      "started_at": "2024-05-10T10:00:00",
      "tablename": "consultation_interest",
      "table_id": 8842,
      "assigned_to": 15
    },
    "work_id": 1234
  }
}
```

**Error (400/500):**
```json
{
  "status": "0",
  "message": "Thiếu tham số bắt buộc: started_at",
  "data": {}
}
```

---

## 2. TẠO GHI CHÚ

### Endpoint
```
POST /tongkho/api_agent/create_note_consultation
```

### Authentication
- Yêu cầu đăng nhập (`@auth.requires_login()`)

### Request Parameters (canonical)

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---|---|---|---|
| `tablename` | string | Có | `consultation_interest` \| `real_estate` \| `customer` \| `consultation` |
| `table_id` | int | Có | ID bản ghi tương ứng `tablename` |
| `content` | string | Có | Nội dung ghi chú |
| `attachments` | array | Không | Danh sách file đính kèm |
| `visibility` | string | Không | `public` hoặc `internal` (default: `public`) |

### Request Example

**Ghi chú cho BDS trong working list của nhu cầu mua:**
```json
POST /tongkho/api_agent/create_note_consultation
{
  "tablename": "consultation_interest",
  "table_id": 8842,
  "content": "Khách quan tâm căn hộ view sông, giá hợp lý. Chủ nhà dễ thương lượng.",
  "visibility": "public"
}
```

**Ghi chú nội bộ (private):**
```json
POST /tongkho/api_agent/create_note_consultation
{
  "tablename": "consultation_interest",
  "table_id": 8842,
  "content": "Lưu ý: Khách này đang làm việc với công ty khác, cần deal nhanh.",
  "visibility": "internal"
}
```

**Ghi chú gắn vào BĐS gốc:**
```json
POST /tongkho/api_agent/create_note_consultation
{
  "tablename": "real_estate",
  "table_id": 100,
  "content": "Chủ nhà xác nhận muốn bán gấp",
  "visibility": "public"
}
```

### Response Format

**Success (200):**
```json
{
  "status": "1",
  "message": "Tạo ghi chú thành công",
  "data": {
    "work_id": 1235,
    "comment_id": 5678,
    "work": {
      "id": 1235,
      "name": "Ghi chú cho Nhu cầu quan tâm #8842",
      "template_id": 42,
      "tablename": "consultation_interest",
      "table_id": 8842,
      "created_at": "2024-05-09T15:30:00"
    },
    "comment": {
      "id": 5678,
      "content": "Khách quan tâm căn hộ view sông...",
      "comment_type": "note_consultation_interest",
      "visibility": "public",
      "created_at": "2024-05-09T15:30:00"
    }
  }
}
```

---

## 3. LẤY DANH SÁCH HOẠT ĐỘNG & GHI CHÚ

### Endpoint
```
GET /tongkho/api_agent/get_activities_consultation
```

### Authentication
- Yêu cầu đăng nhập (`@auth.requires_login()`)

### Query Parameters (canonical)

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---|---|---|---|
| `tablename` | string | Có | `consultation_interest` \| `real_estate` \| `customer` \| `consultation` |
| `table_id` | int | Có | ID bản ghi tương ứng `tablename` |
| `activity_type` | string | Không | `appointment` \| `deposit` \| `note` \| `all` (default: `all`) |
| `page` | int | Không | Trang hiện tại (default: 1) |
| `limit` | int | Không | Số item/trang (default: 20) |

### Request Example

**Lấy tất cả hoạt động của 1 dòng BDS đang làm việc trong nhu cầu mua:**
```
GET /tongkho/api_agent/get_activities_consultation?tablename=consultation_interest&table_id=8842&page=1&limit=20
```

**Chỉ lịch hẹn của 1 BĐS gốc:**
```
GET /tongkho/api_agent/get_activities_consultation?tablename=real_estate&table_id=100&activity_type=appointment
```

### Response Format

**Success (200):**
```json
{
  "status": "1",
  "message": "Lấy danh sách hoạt động thành công",
  "data": {
    "tablename": "consultation_interest",
    "table_id": 8842,
    "works": [
      {
        "work_id": 1234,
        "work_name": "Lịch hẹn xem BĐS VP Bank Tower",
        "work_type": "appointment",
        "template_id": 4,
        "started_at": "2024-05-10T10:00:00",
        "status": "waiting",
        "tablename": "consultation_interest",
        "table_id": 8842,
        "comments": [
          {
            "id": 5678,
            "content": "Khách quan tâm căn hộ view sông",
            "comment_type": "note_consultation_interest",
            "user": {
              "id": 1,
              "name": "Nguyễn Văn A",
              "avatar": "https://...",
              "award_title": "Chuyên viên"
            },
            "attachments": [],
            "created_at": "2024-05-09T15:30:00"
          }
        ],
        "comment_count": 1
      },
      {
        "work_id": 1235,
        "work_name": "Đặt cọc thiện chí",
        "work_type": "deposit",
        "template_id": 29,
        "status": "waiting",
        "amount_deposit": 50000000,
        "deposit_type": "thien_chi",
        "tablename": "consultation_interest",
        "table_id": 8842,
        "comments": [],
        "comment_count": 0
      }
    ],
    "summary": {
      "total_works": 2,
      "total_comments": 1,
      "by_type": {
        "appointment": 1,
        "deposit": 1,
        "note": 0
      },
      "by_status": {
        "waiting": 2,
        "completed": 0,
        "cancelled": 0
      }
    },
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 2,
      "pages": 1
    }
  }
}
```

### Activity Types Mapping

| `work_type` | `template_id` | Tên hiển thị |
|---|---|---|
| `appointment` | 4 | Lịch hẹn |
| `deposit` | 29 | Đặt cọc |
| `note` | 42 | Ghi chú |
| `verification_reminder` | 43 (đề xuất, BE confirm) | Nhắc xác thực |

### Comment Types Mapping

| `comment_type` | Tên hiển thị |
|---|---|
| `note_consultation_interest` | Ghi chú BDS đang làm việc |
| `note_real_estate` | Ghi chú BĐS |
| `note_customer` | Ghi chú KH |
| `note_internal` | Ghi chú nội bộ |
| `call_log` | Nhật ký cuộc gọi |
| `comment` | Bình luận thường |
| `status_update` | Cập nhật trạng thái |

---

## 4. LẤY DANH SÁCH LỊCH HẸN

### Endpoint
```
GET /tongkho/api_agent/get_list_appointments_consultation
```

### Authentication
- Yêu cầu đăng nhập (`@auth.requires_login()`)

### Query Parameters

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---|---|---|---|
| `tablename` | string | Không | Filter theo entity — vd `consultation_interest` |
| `table_id` | int | Không | ID bản ghi tương ứng `tablename` |
| `status` | string/array | Không | Trạng thái lọc |
| `date_from` | string | Không | Ngày bắt đầu `YYYY-MM-DD` |
| `date_to` | string | Không | Ngày kết thúc `YYYY-MM-DD` |
| `search` | string | Không | Tìm kiếm theo từ khóa |
| `page` | int | Không | Trang hiện tại (default: 1) |
| `limit` | int | Không | Số item/trang (default: 20) |

### Request Example

**Lịch hẹn của 1 dòng BDS đang làm việc:**
```
GET /tongkho/api_agent/get_list_appointments_consultation?tablename=consultation_interest&table_id=8842
```

**Tất cả lịch hẹn trong khoảng thời gian:**
```
GET /tongkho/api_agent/get_list_appointments_consultation?date_from=2024-05-01&date_to=2024-05-31
```

### Response Format

**Success (200):**
```json
{
  "status": "1",
  "message": "Lấy danh sách lịch hẹn thành công",
  "data": [
    {
      "id": 1234,
      "name": "Lịch hẹn xem BĐS VP Bank Tower",
      "description": "Hẹn khách hàng đến xem căn hộ 2PN",
      "template_id": 4,
      "started_at": "2024-05-10T10:00:00",
      "location": "Tầng 5, tòa nhà VP Bank",
      "status": "waiting",
      "tablename": "consultation_interest",
      "table_id": 8842,
      "assigned_to": 15,
      "assigned_to_name": "Nguyễn Văn A",
      "created_at": "2024-05-09T15:30:00"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 25,
    "pages": 2
  },
  "count": 25
}
```

---

## 5. CẬP NHẬT TRẠNG THÁI CÔNG VIỆC

### Endpoint
```
POST /tongkho/api_agent/update_work_status_consultation
```

> **Note**: Endpoint này scope theo `work_id` (work đã unique), không cần `tablename`/`table_id`.

### Authentication
- Yêu cầu đăng nhập (`@auth.requires_login()`)

### Request Parameters

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---|---|---|---|
| `work_id` | int | Có | ID công việc |
| `status` | string | Có | `waiting`, `in_progress`, `completed`, `cancelled`, `no_show`, `forfeited`, `refunded` |
| `result_note` | string | Không | Ghi chú kết quả |
| `reason` | string | Không | Lý do hủy/hoãn |

### Request Example

```json
POST /tongkho/api_agent/update_work_status_consultation
{
  "work_id": 1234,
  "status": "completed",
  "result_note": "Khách đã xem căn hộ, hẹn đưa ra quyết định trong 2 ngày tới"
}
```

### Response Format

**Success (200):**
```json
{
  "status": "1",
  "message": "Cập nhật trạng thái thành công",
  "data": {
    "work_id": 1234,
    "status": "completed",
    "updated_at": "2024-05-10T11:00:00"
  }
}
```

---

## 6. THÊM COMMENT VÀO CÔNG VIỆC

### Endpoint
```
POST /tongkho/api_agent/add_work_comment_consultation
```

> **Note**: Endpoint này scope theo `work_id`, không cần `tablename`/`table_id`.

### Authentication
- Yêu cầu đăng nhập (`@auth.requires_login()`)

### Request Parameters

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---|---|---|---|
| `work_id` | int | Có | ID công việc |
| `content` | string | Có | Nội dung comment |
| `comment_type` | string | Không | Loại comment (default: `comment`) |
| `documents` | array | Không | Danh sách document đính kèm |

### Request Example

```json
POST /tongkho/api_agent/add_work_comment_consultation
{
  "work_id": 1234,
  "content": "Đã gọi nhắc lại khách, khách xác nhận sẽ đến đúng giờ",
  "comment_type": "call_log",
  "documents": ["doc_key_1"]
}
```

### Response Format

**Success (200):**
```json
{
  "status": "1",
  "message": "Thêm bình luận thành công",
  "data": {
    "comment": {
      "id": 5679,
      "content": "Đã gọi nhắc lại khách...",
      "comment_type": "call_log",
      "user": {
        "id": 1,
        "name": "Nguyễn Văn A"
      },
      "created_at": "2024-05-10T09:00:00"
    }
  }
}
```

---

## SUMMARY

### Endpoint List

| Endpoint | Method | Scope by |
|---|---|---|
| `/api_agent/create_work_consultation` | POST | `tablename` + `table_id` |
| `/api_agent/create_note_consultation` | POST | `tablename` + `table_id` |
| `/api_agent/get_activities_consultation` | GET | `tablename` + `table_id` |
| `/api_agent/get_list_appointments_consultation` | GET | `tablename` + `table_id` (optional filter) |
| `/api_agent/update_work_status_consultation` | POST | `work_id` |
| `/api_agent/add_work_comment_consultation` | POST | `work_id` |

### Template ID Mapping

| `template_id` | Loại công việc |
|---|---|
| 4 | Lịch hẹn |
| 29 | Đặt cọc |
| 42 | Khác / Ghi chú |
| 43 (đề xuất) | Nhắc xác thực BĐS |

### Status Values

| Status | Mô tả |
|---|---|
| `waiting` | Chờ diễn ra |
| `in_progress` | Đang thực hiện |
| `completed` | Hoàn thành |
| `cancelled` | Đã hủy |
| `no_show` | Không đến |
| `forfeited` | Phạt cọc |
| `refunded` | Hoàn cọc |

---

## ERROR CODES

| Status | Message | Mô tả |
|---|---|---|
| `0` | Thiếu tham số bắt buộc | Missing required parameter |
| `0` | Thời gian triển khai không hợp lệ | Invalid started_at format |
| `0` | Số tiền đặt cọc phải lớn hơn 0 | Deposit amount must be positive |
| `0` | Loại cọc không hợp lệ | Invalid deposit_type |
| `0` | Không tìm thấy đối tượng | Object not found |
| `0` | BĐS chưa có đầu chủ | Verification reminder: no assigned listing manager |
| `0` | BĐS đã xác thực, không cần nhắc | Verification reminder: BDS already verified |
| `0` | Mới nhắc lúc ..., vui lòng chờ | Verification reminder: still in cooldown |
| `0` | Lỗi server | Internal server error |

---

## FRONTEND INTEGRATION EXAMPLE

### React/Axios Example

```javascript
import axios from 'axios';

const API_BASE = '/tongkho/api_agent';

// Tạo lịch hẹn cho 1 dòng BDS đang làm việc
export const createAppointment = (data) =>
  axios.post(`${API_BASE}/create_work_consultation`, {
    code: 'appointment',
    tablename: 'consultation_interest',
    ...data, // table_id, started_at, location, note, assigned_to, ...
  });

// Tạo đặt cọc cho 1 dòng BDS đang làm việc
export const createDeposit = (data) =>
  axios.post(`${API_BASE}/create_work_consultation`, {
    code: 'deposit',
    tablename: 'consultation_interest',
    ...data, // table_id, deposit_type, deposit_amount, note, ...
  });

// Tạo ghi chú
export const createNote = (data) =>
  axios.post(`${API_BASE}/create_note_consultation`, data);
  // data: { tablename, table_id, content, visibility?, attachments? }

// Lấy danh sách hoạt động
export const getActivities = (tablename, tableId, params = {}) =>
  axios.get(`${API_BASE}/get_activities_consultation`, {
    params: { tablename, table_id: tableId, ...params },
  });

// Cập nhật trạng thái
export const updateWorkStatus = (workId, status, note) =>
  axios.post(`${API_BASE}/update_work_status_consultation`, {
    work_id: workId,
    status,
    result_note: note,
  });

// Thêm comment vào work
export const addComment = (workId, content) =>
  axios.post(`${API_BASE}/add_work_comment_consultation`, {
    work_id: workId,
    content,
  });
```

### Usage Example

```javascript
// Tạo lịch hẹn cho dòng BDS đang làm việc (consultation_interest.id = 8842)
await createAppointment({
  table_id: 8842,
  started_at: '2024-05-10T10:00:00',
  location: 'Tầng 5, tòa nhà VP Bank',
  assigned_to: 15,
});

// Lấy hoạt động của dòng BDS đang làm việc
const { data } = await getActivities('consultation_interest', 8842, { page: 1, limit: 20 });

// Tạo ghi chú nội bộ trên dòng BDS
await createNote({
  tablename: 'consultation_interest',
  table_id: 8842,
  content: 'Lưu ý: Khách cần deal nhanh',
  visibility: 'internal',
});
```

---

## BACKWARD COMPAT (Deprecated)

BE vẫn chấp nhận các param cũ để các client chưa migrate không bị break. Mapping:

### `create_note_consultation`
| Param cũ | Tương đương canonical |
|---|---|
| `note_type=real_estate, related_id=X` | `tablename=real_estate, table_id=X` |
| `note_type=customer, related_id=X` | `tablename=customer, table_id=X` |
| `note_type=consultation_interest, consultation_interest_id=X` (hoặc `internal_id=X`, hoặc `related_id=X`) | `tablename=consultation_interest, table_id=X` |
| `note_type=internal, internal_id=X` (hoặc `table_id=X`, hoặc `related_id=X`) | `tablename=consultation_interest, table_id=X` + `visibility=internal` |

### `create_work_consultation`
| Param cũ | Cách BE suy ra canonical |
|---|---|
| `real_estate_id=X` (không có `consultation_interest_id`) | `tablename=real_estate, table_id=X` |
| `customer_id=X` | `tablename=customer, table_id=X` |
| `consultation_id=X` | `tablename=consultation, table_id=X` |
| `internal_id=X` / `consultation_interest_id=X` | `tablename=consultation_interest, table_id=X` |

### `get_activities_consultation`
| Param cũ | Tương đương canonical |
|---|---|
| `tab=bds, tab_id=X` | `tablename=consultation_interest, table_id=X` (hoặc `tablename=real_estate, table_id=X` nếu work cũ link trực tiếp tới real_estate) |
| `tab=customer, tab_id=X` | `tablename=customer, table_id=X` |
| `tab=consultation_interest, tab_id=X` | `tablename=consultation_interest, table_id=X` |
| `tab=internal` (kèm `tab_id`) | `tablename=consultation_interest, table_id=X` + filter `template_id=42` |

### `get_list_appointments_consultation`
| Param cũ | Tương đương canonical |
|---|---|
| `consultation_id=X` | `tablename=consultation, table_id=X` |
| `real_estate_id=X` | `tablename=real_estate, table_id=X` |
| `customer_id=X` | `tablename=customer, table_id=X` |
| `consultation_interest_id=X` | `tablename=consultation_interest, table_id=X` |

> **Khuyến nghị**: client mới chỉ dùng schema canonical. Param cũ sẽ bị remove ở phiên bản 3.0.0.

---

## VERSION

- **Version**: 2.1.0
- **Last Updated**: 2026-05-17
- **Changes**:
  - 2.1.0 (2026-05-17): Thêm `code='verification_reminder'` cho `create_work_consultation` (template_id 43 đề xuất). Chi tiết flow xem `docs/10-be-handoff-nhac-xac-thuc-bds.md`.
  - 2.0.0: Thống nhất schema sang cặp `tablename` + `table_id` cho mọi action scope theo entity. Schema cũ chuyển sang mục "Backward compat".

---

<a id="docs-api-contracts-by-types-md"></a>

## docs/API_contracts_by_types.md

# API: Lấy danh sách hợp đồng theo nhiều loại hợp đồng

## Thông tin chung

- **Endpoint**: `/tongkho/api_agent/contracts_by_types`
- **Method**: `GET`
- **Authentication**: Yêu cầu đăng nhập (`@auth.requires_login()`)
- **Mô tả**: Lấy danh sách hợp đồng được lọc theo nhiều loại hợp đồng, hỗ trợ tìm kiếm và phân trang

---

## Tham số Request (Query Params)

### Tham số bắt buộc

| Tên | Kiểu | Mô tả | Ví dụ |
|-----|------|-------|-------|
| `contract_types` | string | Chuỗi các loại hợp đồng cách nhau bằng dấu phẩy | `"1,2,3"` |

**Giá trị loại hợp đồng**:
- `1` - CTV (Cộng tác viên)
- `2` - Thông thường
- `3` - Độc quyền

### Tham số tùy chọn

#### Phân trang

| Tên | Kiểu | Mặc định | Mô tả |
|-----|------|----------|-------|
| `page` | int | 1 | Số trang hiện tại |
| `limit` | int | 20 | Số lượng item trên mỗi trang |

#### Bộ lọc (Filter)

Có thể truyền trực tiếp hoặc thông qua tham số `filter` (JSON string):

| Tên | Kiểu | Mô tả | Ví dụ |
|-----|------|-------|-------|
| `search` | string | Tìm kiếm theo từ khóa | `"Hợp đồng A"` |
| `signing_method` | int | Phương thức ký (1=Ký trực tiếp, 2=Online) | `1` |
| `status` | string/int | Trạng thái hợp đồng | `"active"` |
| `tag_id` | string/int | Tag ID để lọc (format: "24,18" hoặc 24) | `"24,18"` |
| `verified_by_agent_id` | string/int | Agent ID đã verify | `"123,456"` |
| `time_field` | string | Trường thời gian lọc (`signing_at` hoặc `created_on`) | `"signing_at"` |
| `date_from` | string | Ngày bắt đầu (YYYY-MM-DD) | `"2024-01-01"` |
| `date_to` | string | Ngày kết thúc (YYYY-MM-DD) | `"2024-12-31"` |
| `office` | int | Filter theo văn phòng | `1` |
| `city` | int | Filter theo thành phố | `2` |
| `district` | int | Filter theo quận/huyện | `3` |
| `ward` | int | Filter theo phường/xã | `4` |
| `sales_off` | int | Filter theo sales off | `5` |
| `filter` | string (JSON) | Chuỗi JSON chứa các bộ lọc | `{\"search\":\"ABC\"}` |

---

## Response

### Định dạng

```json
{
  "status": "1",           // "1" = Success, "0" = Error
  "message": "string",      // Thông báo kết quả
  "data": [],               // Mảng danh sách hợp đồng
  "pagination": {           // Thông tin phân trang
    "page": 1,
    "limit": 20,
    "total": 100,
    "pages": 5
  }
}
```

### Các trạng thái Response

| Status | Message | Mô tả |
|--------|---------|-------|
| `1` | "Lấy danh sách hợp đồng thành công" | Thành công |
| `0` | "Thiếu tham số contract_types" | Thiếu tham số bắt buộc |
| `0` | "contract_types không hợp lệ" | Format không đúng |
| `0` | "contract_types không được rỗng" | Danh sách rỗng sau khi parse |

---

## Ví dụ sử dụng

### Ví dụ 1: Lấy hợp đồng loại CTV và Thông thường

**Request:**
```
GET /tongkho/api_agent/contracts_by_types?contract_types=1,2&page=1&limit=20
```

**Response:**
```json
{
  "status": "1",
  "message": "Lấy danh sách hợp đồng thành công",
  "data": [
    {
      "id": 123,
      "code": "HD001",
      "contract_type": 1,
      "customer_name": "Nguyễn Văn A",
      ...
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 45,
    "pages": 3
  }
}
```

### Ví dụ 2: Lọc với nhiều điều kiện

**Request:**
```
GET /tongkho/api_agent/contracts_by_types?contract_types=1,2,3&signing_method=1&status=active&date_from=2024-01-01&date_to=2024-12-31
```

### Ví dụ 3: Sử dụng filter JSON

**Request:**
```
GET /tongkho/api_agent/contracts_by_types?contract_types=1&filter={"search":"Nguyen","tag_id":"24,18"}
```

---

## Lưu ý

1. **Authentication**: API yêu cầu user phải đăng nhập
2. **Pagination**: Sử dụng kết hợp `page` và `limit` để phân trang dữ liệu
3. **Filter format**:
   - Có thể truyền trực tiếp qua query params
   - Hoặc truyền qua tham số `filter` dưới dạng JSON string
4. **Multi-value fields**: Các field như `tag_id`, `verified_by_agent_id` hỗ trợ format "24,18" hoặc giá trị đơn
5. **Date format**: YYYY-MM-DD (ví dụ: 2024-01-31)

---

## Error Handling

Khi có lỗi xảy ra, API trả về:

```json
{
  "status": "0",
  "message": "Error message here",
  "data": {}
}
```

Các lỗi thường gặp:
- Thiếu tham số `contract_types`
- Format `contract_types` không hợp lệ
- Lỗi xử lý từ server (có trong message chi tiết)

---

<a id="docs-ba-bds-detail-actions-and-views-md"></a>

## docs/BA/bds-detail-actions-and-views.md

# BA — Trang chi tiết BĐS: Actions & Views

> Tài liệu phân tích nghiệp vụ cho dev + test. Phạm vi: trang chi tiết 1 BĐS (`/bds/[id]` + dialog `BdsDetailDialog`).
> Nguồn: Flutter V1 `tongkhobds_agent/lib/features/detail_product/*` + web hiện tại `src/components/bds/bds-detail-*`.
> Ngày: 2026-05-12. Layout đã chốt: **stack phẳng** (sidebar dọc + sticky bar mobile, chỉ bổ sung button — không bottom-sheet/overflow menu).

---

## 1. Mục tiêu & phạm vi

Trang chi tiết BĐS phải phục vụ 4 đối tượng, mỗi đối tượng × trạng thái BĐS → tập action khác nhau. Tài liệu này:
- Liệt kê use case theo từng persona.
- Spec UI: vị trí, điều kiện hiển thị, hành vi, endpoint mỗi action.
- Acceptance criteria cho test.
- Đánh dấu **MVP** / **Phase 2**.

**Cắt phạm vi MVP:** 5 action hiện có + Chia sẻ + Gọi đầu chủ + Quản lý tin (Chỉnh sửa / Gỡ bài) + Xác thực (entry) + 2 view bổ sung (Thông tin xác thực, Hợp đồng — read-only, có phân quyền).
**Phase 2:** Ký HĐ với chủ nhà · Duyệt/Từ chối tin (checking staff) · Đăng tin rao bán lên feed · Chỉnh sửa pháp lý · Chat với người đăng · Đặt cọc từ trang chi tiết · Bổ sung thông tin BĐS (full flow).

---

## 2. Đối tượng người dùng (personas)

| Mã | Persona | Điều kiện nhận diện | Ghi chú |
|---|---|---|---|
| **P1** | Agent xem tin người khác | `!isMe` | Phổ biến nhất. CTV xem BĐS kho chung. |
| **P2** | Chủ tin (người đăng) | `isMe === true` (so `product.user_id` ↔ `me.id`) | "isMeFlow" trong Flutter. |
| **P3** | Trưởng phòng | role = trưởng phòng (BE field cần xác nhận — xem §9 Q2) | Mở rộng quyền của P1: thấy thêm nút **Xác thực BĐS**. |
| **P4** | Agent đã/đang xác thực BĐS (verifier) | user là `verified_by_agent` của BĐS | MVP: chỉ badge + entry; full flow Phase 2. |
| **P5** | Checking staff (kiểm duyệt) | `me.checking_staff` truthy | **Phase 2** — MVP coi như P1, ẩn action duyệt. |
| **P6** | Người có quyền xem HĐ / thông tin xác thực | (BE field cần xác nhận — xem §9 Q5) | Quyết định 2 view bổ sung ở §6 có hiển thị không. |

Persona không loại trừ nhau: 1 user có thể vừa là P2 (chủ tin) vừa là P3 (trưởng phòng). Quy tắc gộp action ở §7.

---

## 3. Trạng thái BĐS (ảnh hưởng action)

- **`status_info.status_code`**: `DRAFT` (nháp) · `PENDING_APPROVAL` ("Chờ duyệt") · `REJECTED` ("Từ chối") · đang bán (`ACTIVE`/approved) · `CANCELLED` (đã gỡ).
- **`verification_stage`**: `0` chưa xác thực · `1` đang xử lý · `2` đã xác thực.
- **`is_secondary_property`** (sơ cấp/thứ cấp): ảnh hưởng "Liên hệ đầu chủ" (chỉ áp dụng BĐS thứ cấp + verified).

---

## 4. Use cases theo persona

### UC-P1 — Agent xem tin người khác (`!isMe`, BĐS đang bán)

| ID | Use case | Tiền điều kiện | Hành vi tóm tắt | MVP |
|---|---|---|---|---|
| UC-P1-01 | Yêu thích / bỏ yêu thích | luôn | Toggle; nếu thêm → cho chọn nhóm yêu thích (`favorite_group`) | ✅ đã có |
| UC-P1-02 | Chia sẻ BĐS | luôn | Web Share API nếu hỗ trợ; fallback copy link `/bds/[id]` + toast | ✅ **mới** |
| UC-P1-03 | Liên hệ đầu chủ | `verification_stage===2` & `is_secondary_property` & có owner info (`verified_by_agent_info[_arr]`) | Mở inline owner card (tên, phone `tel:`, link FB). Đây là entry duy nhất để xem SĐT đầu chủ. | ✅ đã có |
| UC-P1-04 | Gọi đầu chủ | như UC-P1-03 | `tel:<owner.phone>`. Nút riêng (mobile sticky icon 📞) trỏ tới đúng owner phone. **Không** gọi người đăng tin. | ✅ **mới** (mobile) |
| UC-P1-05 | Gửi quan tâm | khi UC-P1-03 không thỏa (chưa verified / không owner info) | Form "Tôi quan tâm BĐS này" → tạo demand interest. Thay chỗ CTA "Liên hệ đầu chủ". | ✅ đã có |
| UC-P1-06 | Đặt lịch hẹn | luôn | → `/appointments/new?bds=<id>` | ✅ đã có |
| UC-P1-07 | Thêm vào nhu cầu | luôn | → `/nhu-cau/create?bds=<id>` | ✅ đã có |
| UC-P1-08 | Gắn / gỡ tag | luôn | Tags section (`POST /api_agent/list_tags` attach) | ✅ đã có |
| UC-P1-09 | Xem thông tin xác thực | `verification_stage===2` & user thuộc P6 | Mở view read-only (§6.1) | ✅ **mới** |
| UC-P1-10 | Xem hợp đồng | có HĐ liên kết BĐS & user thuộc P6 | Mở view read-only (§6.2) | ✅ **mới** |
| UC-P1-11 | Đặt cọc | luôn | popup "Tôi có khách" → Đặt cọc → `make_deposit` | ❌ Phase 2 |
| UC-P1-12 | Chat với người đăng | có người đăng | mở hội thoại | ❌ Phase 2 |
| UC-P1-13 | Đăng tin rao bán lên feed | `!fromList` | → SellNewsPage | ❌ Phase 2 |

### UC-P3 — Trưởng phòng (kế thừa UC-P1 + bổ sung)

| ID | Use case | Tiền điều kiện | Hành vi | MVP |
|---|---|---|---|---|
| UC-P3-01 | Xác thực BĐS (entry) | `verification_stage===0` & role = trưởng phòng | → luồng xác thực ở module `xac-thuc-bds` (`/xac-thuc-bds/<id>`). Trang chi tiết chỉ là entry point. | ✅ **mới** (entry) |

> Agent thường (không phải trưởng phòng) **không** thấy nút "Xác thực BĐS".

### UC-P2 — Chủ tin (`isMe === true`)

CTA liên hệ/quan tâm/gọi đầu chủ **ẩn hết** (vô nghĩa với BĐS của chính mình). Thay bằng nhóm quản lý tin theo `status_code`. Vẫn **giữ**: Yêu thích, Chia sẻ, Đặt lịch hẹn, Thêm vào nhu cầu, Gắn tag, Stats (xác nhận: chủ tin vẫn dùng được — **đã chốt: CÓ**).

| ID | Trạng thái | Action | Hành vi | MVP |
|---|---|---|---|---|
| UC-P2-01 | `DRAFT` | **Chỉnh sửa** | → wizard chỉnh sửa BĐS (`/bds/<id>/edit`) với data prefilled | ✅ **mới** |
| UC-P2-02 | `PENDING_APPROVAL` | **Gỡ bài** · **Chỉnh sửa** · **Xác thực** | Gỡ: confirm dialog → `POST /api_customer/unpublish_property.json {id}` · Chỉnh: như UC-P2-01 · Xác thực: → luồng xác thực (Phase 2 cho full flow, MVP chỉ điều hướng) | ✅ Gỡ/Chỉnh; Xác thực = entry |
| UC-P2-03 | `REJECTED` | **Gỡ bài** · **Chỉnh sửa** + banner đỏ hiện lý do từ chối | banner lấy lý do từ `status_info` / reject reason | ✅ **mới** |
| UC-P2-04 | đang bán (`ACTIVE`) | **Gỡ bài** | confirm dialog → unpublish | ✅ **mới** |
| UC-P2-05 | đã verified & chưa request signing | **Ký HĐ với chủ nhà** | dialog chọn cách ký + loại HĐ → `POST /api_agent/contract_seller_create.json` → success page | ❌ Phase 2 |
| UC-P2-06 | bất kỳ | **Chỉnh sửa pháp lý** | edit legal info riêng | ❌ Phase 2 |
| UC-P2-07 | `CANCELLED` | (chỉ xem, không action quản lý) | có thể hiện "Đăng lại" — Phase 2 | ❌ Phase 2 |

### UC-P4 — Agent đã xác thực BĐS (verifier)
MVP: hiển thị badge **"Bạn đã xác thực BĐS này"** (khi `verified_by_agent === me`). Action **Ký HĐ với chủ nhà / Bổ sung thông tin / Chỉnh sửa pháp lý / Từ chối xác thực** → **Phase 2** (module `xac-thuc-bds` lo phần này).

### UC-P5 — Checking staff
**Phase 2 toàn bộ**: Duyệt tin (`POST /api_agent/update_real_estate_salesman_status`-tương đương / `updateStatus`) · Từ chối tin (`get_reject_reasons` → `reject_real_estate_salesman`) · Gán salesman. MVP: render như P1, ẩn các nút này.

---

## 5. Action inventory + spec UI

Vị trí cố định (layout flat — Option C):

```
HEADER (BdsDetailHeader):  ... badges ...            [⤴ Chia sẻ] [♥ Yêu thích]

SIDEBAR (BdsDetailSidebar — thứ tự từ trên xuống, ẩn block nếu không thỏa):
  1. Card Giá + specs                                      (luôn)
  2. (NEW) Banner trạng thái                               (P2 & REJECTED → đỏ + lý do; P2 & PENDING → vàng)
  3. Card Agent phụ trách (seller card)                    (có seller & !isMe)
  4. CTA stack (BdsDetailCtaStack) — nội dung theo persona/state:
       P1/P3:  [Liên hệ đầu chủ ▾] | [Gửi quan tâm]   (1 trong 2 tùy điều kiện UC-P1-03)
               [Đặt lịch hẹn]
               [Thêm vào nhu cầu]
               [Xác thực BĐS]                         (chỉ P3 & stage===0)
       P2/DRAFT:    [Chỉnh sửa]
       P2/PENDING:  [Xác thực]   rồi hàng [Gỡ bài] [Chỉnh sửa]
       P2/REJECTED: hàng [Gỡ bài] [Chỉnh sửa]
       P2/ACTIVE:   [Gỡ bài]
       P2 chung:    [Đặt lịch hẹn] [Thêm vào nhu cầu]   (vẫn hiện)
  5. (NEW) [Xem thông tin xác thực]                        (stage===2 & P6)
  6. (NEW) [Xem hợp đồng]                                  (có HĐ & P6)
  7. Tags section (BdsTagsSection)                         (luôn)
  8. Stats (Lượt xem / Yêu thích)                          (luôn)
  9. Card Hoa hồng dự kiến                                 (có commission_value)

STICKY BAR MOBILE (BdsDetailStickyCta — lg:hidden):
  P1/P3:  [♥]  [📞 Gọi đầu chủ]*  [ Liên hệ đầu chủ / Quan tâm — flex ]
            * icon 📞 chỉ hiện khi UC-P1-04 thỏa
  P2:     [♥]  [ CTA chính theo state — flex ]  [Chỉnh sửa]
            DRAFT → CTA="Chỉnh sửa" (không cần nút phụ); PENDING → CTA="Xác thực" + nút phụ "Gỡ bài"; REJECTED → [Gỡ bài][Chỉnh sửa]; ACTIVE → CTA="Gỡ bài"
```

| Action | Tone/style | Endpoint / route | Confirm? |
|---|---|---|---|
| Yêu thích | icon ghost | `POST /api_agent/like_product` (đã có) | không |
| Chia sẻ | icon ghost | client only (Web Share / clipboard) | không |
| Liên hệ đầu chủ | primary, expandable | inline render owner card | không |
| Gọi đầu chủ | icon outline | `tel:<owner.phone>` | không |
| Gửi quan tâm | primary | form → create demand interest | không |
| Đặt lịch hẹn | info-outline | `/appointments/new?bds=<id>` | không |
| Thêm vào nhu cầu | ghost | `/nhu-cau/create?bds=<id>` | không |
| Gắn tag | (tags section UI) | `POST /api_agent/list_tags` | không |
| Xác thực BĐS | primary | `/xac-thuc-bds/<id>` | không |
| Chỉnh sửa | primary / icon | `/bds/<id>/edit` | không |
| Gỡ bài | destructive outline / icon | `POST /api_customer/unpublish_property.json {id}` | **có** (dialog) |
| Xem thông tin xác thực | ghost | mở dialog/sheet read-only (§6.1) | không |
| Xem hợp đồng | ghost | mở dialog/sheet read-only (§6.2) hoặc → trang HĐ | không |

---

## 5b. Ma trận CTA × Người thao tác

> Persona: **P1** Agent xem tin người khác · **P2** Chủ tin (`isMe`) · **P3** Trưởng phòng (mở rộng P1) · **P4** Agent đã xác thực · **P5** Checking staff · **P6** Người có quyền xem HĐ/xác thực.
> Ký hiệu: ✓ = thấy & dùng được · — = không hiển thị · (P2: cột P1/P3 = "—" nghĩa là khi `isMe` thì ẩn).
> Cột "Điều kiện hiện" = ngoài persona còn cần trạng thái BĐS / dữ liệu kèm theo.

| # | CTA / Action | P1 | P2 (chủ tin) | P3 (TP) | P4 (verifier) | P5 (checking) | P6 | Điều kiện hiện | Vị trí | Phạm vi | Triển khai |
|---|---|:--:|:--:|:--:|:--:|:--:|:--:|---|---|---|---|
| 1 | Yêu thích / bỏ yêu thích | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | luôn | header + sticky | MVP | ✅ đã có |
| 2 | Chia sẻ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | luôn | header | MVP | ✅ **mới** |
| 3 | Liên hệ đầu chủ | ✓ | — | ✓ | ✓ | ✓ | ✓ | `verification_stage=2` & thứ cấp & có owner info | sidebar CTA + sticky | MVP | ✅ đã có |
| 4 | Gọi đầu chủ (`tel:`) | ✓ | — | ✓ | ✓ | ✓ | ✓ | như #3 & có `owner.phone` | sticky icon 📞 (mobile) | MVP | ✅ **mới** |
| 5 | Gửi quan tâm | ✓ | — | ✓ | ✓ | ✓ | ✓ | khi #3 **không** thỏa | sidebar CTA + sticky | MVP | ✅ đã có |
| 6 | Đặt lịch hẹn | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | luôn | sidebar CTA | MVP | ✅ đã có |
| 7 | Thêm vào nhu cầu | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | luôn | sidebar CTA | MVP | ✅ đã có |
| 8 | Gắn / gỡ tag | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | luôn | tags section | MVP | ✅ đã có |
| 9 | Xác thực BĐS (entry) | — | ✓¹ | ✓ | — | — | — | `verification_stage≠2` (hiện cho mọi user; chỉ TP enabled, role qua `inferRole`=`TP`) → `/xac-thuc-bds/[id]` | sidebar CTA | MVP | ✅ **mới** (gate role tạm bằng `salesmanType=team_leader` — chờ Q2) |
| 10 | Chỉnh sửa tin | — | ✓ | — | — | — | — | `isMe` (dùng `bdsIsOwnPost` = `user_id===me.id`) | sidebar + sticky | MVP | ⏳ render disabled — route `/bds/[id]/edit` chưa có (Q6); wizard chỉ hỗ trợ tạo mới |
| 11 | Gỡ bài | — | ✓ | — | — | — | — | `isMe` | sidebar | MVP | ✅ **mới** (`useUnpublishBdsMutation` → `POST /api_customer/unpublish_property.json`; confirm bằng `window.confirm`; thành công → `/bds/my`) — chờ Q3 confirm endpoint |
| 12 | Banner trạng thái (chờ duyệt / lý do từ chối) | — | ✓ | — | — | — | — | `isMe` & `status ∈ {PENDING_APPROVAL, REJECTED}` | trên cùng sidebar | MVP | ⏳ Q1·Q7 |
| 13 | Xem thông tin xác thực | ✓² | ✓² | ✓² | ✓² | ✓² | ✓ | `verification_stage=2` & user∈P6 | sidebar | MVP | ⏳ Q5 |
| 14 | Xem hợp đồng | ✓² | ✓² | ✓² | ✓² | ✓² | ✓ | có HĐ liên kết & user∈P6 | sidebar | MVP | ⏳ Q4·Q5 |
| 15 | Ký HĐ với chủ nhà | — | ✓ | — | ✓ | — | — | `verification_stage=2` & chưa request signing | sidebar CTA | Phase 2 | — |
| 16 | Bổ sung thông tin BĐS | — | — | — | ✓ | — | — | trong luồng xác thực | — | Phase 2 | — |
| 17 | Chỉnh sửa pháp lý | — | ✓ | — | ✓ | — | — | — | — | Phase 2 | — |
| 18 | Duyệt tin | — | — | — | — | ✓ | — | `status = PENDING_APPROVAL` | sidebar CTA | Phase 2 | — |
| 19 | Từ chối tin | — | — | — | — | ✓ | — | `status = PENDING_APPROVAL` | sidebar | Phase 2 | — |
| 20 | Gán salesman | — | — | — | — | ✓ | — | — | — | Phase 2 | — |
| 21 | Đăng tin rao bán lên feed | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | `!fromList` | sidebar | Phase 2 | — |
| 22 | Đặt cọc | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | luôn | popup "Tôi có khách" | Phase 2 | — |
| 23 | Chat với người đăng | ✓ | — | ✓ | ✓ | ✓ | ✓ | có người đăng | sidebar / sticky | Phase 2 (toàn dự án) | — |
| 24 | Đăng lại tin | — | ✓ | — | — | — | — | `isMe` & `status = CANCELLED` | sidebar CTA | Phase 2 | — |

¹ Chủ tin (P2) khi `status = PENDING_APPROVAL` cũng thấy nút "Xác thực" (theo Flutter V1). Nếu cần giới hạn chỉ Trưởng phòng → xác nhận BE (Q2).
² Hiển thị cho mọi persona **nếu** user đó thuộc P6 (P6 là điều kiện quyền, cộng dồn với persona gốc) — không phải quyền mặc định.

**Quy tắc đọc nhanh:**
- `isMe = true` → ẩn toàn bộ nhóm liên hệ/quan tâm/gọi đầu chủ (#3, #4, #5) + card "Agent phụ trách"; bật nhóm quản lý tin (#9–#12) theo `status`.
- P3 (Trưởng phòng) = P1 + bật #9.
- P6 = điều kiện phụ → bật #13, #14 (không liên quan persona thao tác chính).
- CTA "chính" (vị trí #1 sidebar / nút flex mobile) chỉ 1 — chọn theo §7.

**Tooltip "act nào dùng cho ai" (đã triển khai):** mỗi action gắn `title` (native tooltip) mô tả đối tượng — "Mọi người dùng" · "Agent xem tin (không phải chủ tin) · cần BĐS đã xác thực" · "Agent hoặc Chủ tin" · "Chủ tin (người đăng tin này)" · "Trưởng phòng · khi BĐS chưa xác thực". Action user không dùng được trong ngữ cảnh hiện tại (vd Xác thực khi không phải TP, Chỉnh sửa khi route chưa có) vẫn **hiển thị** ở trạng thái `disabled` + tooltip giải thích lý do/đối tượng.

---

## 6. Views bổ sung (mới — read-only, có phân quyền P6)

### 6.1. View "Thông tin xác thực"
- **Hiển thị khi:** `verification_stage===2` **và** user thuộc P6.
- **Nội dung:** thông tin đầu chủ đã xác thực (`verified_by_agent_info`, `verified_by_agent_info_arr`): tên, SĐT, link FB/zalo, ngày xác thực, agent đã xác thực, ghi chú/giấy tờ pháp lý kèm theo (nếu BE trả). Read-only.
- **UI:** nút "Xem thông tin xác thực" trong sidebar → mở `Sheet`/`Dialog`. Tái sử dụng `BdsOwnerInfoSheet` mở rộng thêm metadata.

### 6.2. View "Hợp đồng"
- **Hiển thị khi:** BĐS có HĐ liên kết (field từ detail — cần xác nhận BE, xem §9 Q4) **và** user thuộc P6.
- **Nội dung:** mã HĐ, loại HĐ, cách ký, trạng thái HĐ, các bên, ngày ký. Read-only. Có thể link sang module hợp đồng nếu đã có route.
- **UI:** nút "Xem hợp đồng" trong sidebar → dialog tóm tắt hoặc điều hướng.

> Nếu user **không** thuộc P6: ẩn cả 2 nút, không lộ thông tin.

---

## 7. Quy tắc gộp & ưu tiên action

1. **isMe thắng:** nếu `isMe`, dùng nhánh P2 — ẩn toàn bộ CTA liên hệ/quan tâm/gọi đầu chủ.
2. **Persona cộng dồn:** P3 (trưởng phòng) chỉ *thêm* nút "Xác thực BĐS" vào nhánh P1; P6 chỉ *thêm* 2 view §6. Không xóa action nào của persona gốc.
3. **CTA chính (vị trí #1 sidebar / flex mobile) — 1 và chỉ 1, theo độ ưu tiên:**
   - P2 & DRAFT → "Chỉnh sửa"
   - P2 & PENDING → "Xác thực"
   - P2 & REJECTED → (không CTA đơn — dùng hàng 2 nút) → mobile lấy "Chỉnh sửa"
   - P2 & ACTIVE → "Gỡ bài"
   - P1/P3 & UC-P1-03 thỏa → "Liên hệ đầu chủ"
   - P1/P3 & không thỏa → "Gửi quan tâm"
4. **Ẩn thay vì disable:** action không đủ điều kiện thì ẩn hẳn (trừ trường hợp cần giải thích — khi đó dùng banner).
5. **CANCELLED:** ẩn mọi action quản lý/giao dịch; chỉ giữ Chia sẻ + (Phase 2) "Đăng lại".

---

## 8. Acceptance criteria (cho test)

> Ký hiệu: G = Given, W = When, T = Then.

**AC-01 (UC-P1-02 Chia sẻ):** G agent xem BĐS bất kỳ · W bấm "Chia sẻ" · T trình duyệt hỗ trợ → mở Web Share sheet; không hỗ trợ → copy `https://<host>/bds/<id>` vào clipboard + toast "Đã copy link".

**AC-02 (UC-P1-03/04 Liên hệ + Gọi đầu chủ):** G BĐS `verification_stage===2`, thứ cấp, có owner info · W bấm "Liên hệ đầu chủ" · T hiện owner card với tên + SĐT (link `tel:`) + FB. W bấm icon 📞 sticky · T quay số đúng `owner.phone`.

**AC-03 (UC-P1-05 fallback):** G BĐS `verification_stage!==2` hoặc không owner info · T sidebar/sticky hiện "Gửi quan tâm" (không hiện "Liên hệ đầu chủ", không hiện icon 📞).

**AC-04 (UC-P3-01 quyền xác thực):** G BĐS `verification_stage===0` · W user = trưởng phòng → T thấy nút "Xác thực BĐS" → bấm điều hướng `/xac-thuc-bds/<id>`. W user là agent thường → T **không** thấy nút.

**AC-05 (UC-P2 isMe ẩn CTA liên hệ):** G `isMe===true` · T không có nút "Liên hệ đầu chủ" / "Gửi quan tâm" / "Gọi đầu chủ" / card "Agent phụ trách"; vẫn có "Đặt lịch hẹn", "Thêm vào nhu cầu", "Yêu thích", "Chia sẻ", "Gắn tag".

**AC-06 (UC-P2-01 DRAFT):** G isMe & `status_code===DRAFT` · T CTA chính = "Chỉnh sửa" → `/bds/<id>/edit`; không có "Gỡ bài".

**AC-07 (UC-P2-02 PENDING):** G isMe & `PENDING_APPROVAL` · T hiện 3 action: "Xác thực" (CTA chính), "Gỡ bài", "Chỉnh sửa"; banner vàng "Đang chờ duyệt". W bấm "Gỡ bài" → confirm dialog → xác nhận → gọi `POST /api_customer/unpublish_property.json {id}` → thành công → điều hướng về list / cập nhật trạng thái.

**AC-08 (UC-P2-03 REJECTED):** G isMe & `REJECTED` · T banner đỏ hiện lý do từ chối; có "Gỡ bài" + "Chỉnh sửa"; không có "Xác thực".

**AC-09 (UC-P2-04 ACTIVE):** G isMe & đang bán · T có "Gỡ bài" (confirm) ; vẫn có Đặt lịch hẹn / Thêm nhu cầu.

**AC-10 (§6.1 view xác thực — phân quyền):** G `verification_stage===2` · W user thuộc P6 → T thấy nút "Xem thông tin xác thực" → mở dialog read-only đủ field. W user không thuộc P6 → T **không** thấy nút.

**AC-11 (§6.2 view HĐ — phân quyền):** G BĐS có HĐ liên kết · W user thuộc P6 → T thấy "Xem hợp đồng" → mở tóm tắt. W không thuộc P6 → T ẩn.

**AC-12 (Phase 2 không lộ MVP):** trang chi tiết MVP **không** có: "Đặt cọc", "Chat", "Ký HĐ với chủ nhà", "Duyệt tin", "Từ chối tin", "Đăng tin lên feed", "Chỉnh sửa pháp lý".

**AC-13 (mobile sticky):** trên viewport < lg, sticky bar luôn hiện, không đè footer, tránh keyboard inset (đã có `useKeyboardInsetHeight`), tôn trọng `env(safe-area-inset-bottom)`.

**AC-14 (dialog vs page parity):** `BdsDetailDialog` (modal) và `/bds/[id]` (page) hiển thị **cùng tập action** theo cùng persona/state (dialog không render sticky bar — đã hiện full sidebar inline).

---

## 9. Câu hỏi mở cho BE / cần xác nhận

1. **Q1 — `isMe`:** detect bằng `product.user_id === me.id`? Hay BE trả flag `is_me` trong product detail? (Flutter có `controller.isMe`.)
2. **Q2 — "Trưởng phòng":** field nào trong UserModel xác định trưởng phòng? Liên quan `office_position.name_code` / `sales_team_closure` manager / `salesman.title`? (xem memory `project-be-sales-off-users-name-code.md`.)
3. **Q3 — Endpoint gỡ bài:** `POST /api_customer/unpublish_property.json {id}` đúng cho app Agent chưa, hay có `/api_agent/*` riêng? Trạng thái sau khi gỡ = `CANCELLED`?
4. **Q4 — HĐ liên kết BĐS:** product detail có field tham chiếu HĐ (`contract_id` / `seller_contract`...) không? Hay phải gọi endpoint riêng theo `real_estate_id`?
5. **Q5 — Quyền xem (P6):** ai được xem "Thông tin xác thực" + "Hợp đồng" của BĐS? Chủ tin? Agent đã xác thực? Trưởng phòng? Checking staff? — cần rule rõ.
6. **Q6 — Route edit BĐS:** hiện chỉ có `/xac-thuc-bds/[id]/edit`. Cần thêm `/bds/[id]/edit` (wizard chỉnh sửa cho chủ tin) — confirm dùng lại `bds-create-wizard` ở chế độ edit.
7. **Q7 — Lý do từ chối tin (REJECTED):** lấy từ `status_info` của product detail hay phải gọi endpoint reject reason riêng?

---

## 10. Phase 2 backlog (ghi nhận, không làm đợt này)

- Ký HĐ với chủ nhà (`contract_seller_create` + OTP) — P2/P4.
- Duyệt / Từ chối tin + gán salesman — P5 (checking staff).
- Đăng tin rao bán lên feed (SellNewsPage) — P1.
- Chỉnh sửa pháp lý BĐS — P2/P4.
- Đặt cọc từ trang chi tiết (popup "Tôi có khách") — P1.
- Chat với người đăng — P1 (đã loại khỏi MVP toàn dự án).
- "Đăng lại" tin đã `CANCELLED` — P2.
- Bổ sung thông tin BĐS (supplement) full flow — P4.

---

<a id="docs-readme-md"></a>

## docs/README.md

---
title: Web Agent — Next.js FE
type: module-readme
track: track-2-implementation
status: planning
stack: nextjs-15
created: 2026-04-17
---

# Web Agent — FE Implementation Track

🟢 **MVP shipped 2026-04-18** → **Post-MVP 2026-04-19~23** — Phase 08 /doi-nhom (team stats), Phase 09 Nhu cầu/Consultation (full CRUD + tags + comments, 9 endpoints wired), BDS filter 2-cấp/3-cấp. Post-MVP added: Favorites multi-group, BDS filter refactor, My-products page, infinite scroll, header store, persisted state, async/multi-select primitives. Typecheck ✓ Lint ✓ 101+ tests (37+ consultation) ✓ Build 40+ routes, FLJS ~250KB shared. **Manual remaining**: E2E suite (Playwright deferred), responsive audit 36 màn, bundle analyzer, Docker/Coolify final, UAT 2-3 Agent. **Phase 2 backlog**: tree viz, avatar crop, DOMPurify, calendar, contract upload, autocomplete, reconciliation, demand match, edit wizards.

## TL;DR (30s read cho AI)

- **Goal**: Webapp mới cho Agent thay phần web của app Flutter V1
- **Stack**: Next.js 15 + TS + shadcn/ui + TanStack Query + Zustand + RHF/Zod
- **BE**: Python Web2py V1 giữ nguyên (Bearer token auth)
- **Scope MVP**: ~36 màn (core + hợp đồng + đặt cọc), bỏ chat/wallet/events/rose
- **Timeline**: 3-4 tháng, 1 FE dev solo (⚠️ risk high, user accepted)
- **Blocking**: none — BE answers đã nhận đủ (2026-04-17)

## Files

| File | Nội dung |
|------|---|
| [01-brainstorm.md](./01-brainstorm.md) | Brainstorm full: stack + scope + risks + 19 decisions |
| [02-api-catalog.md](./02-api-catalog.md) | 127 endpoints reverse từ Flutter Dio, 14 modules |
| [03-be-questions.md](./03-be-questions.md) | 10 câu hỏi BE team (Q1-Q5 P1 blocking, Q6-Q10 P2 module-gating) |
| [04-api-by-screen.md](./04-api-by-screen.md) | API mapping theo từng screen MVP |
| [system-architecture.md](./system-architecture.md) | Kiến trúc hệ thống: routing, auth, proxy, data layer, security |
| [deployment-guide.md](./deployment-guide.md) | Docker + Coolify deploy, env vars, rollback, troubleshooting |
| [project-changelog.md](./project-changelog.md) | Lịch sử feature shipped theo ngày |
| [screens/](./screens/) | Specs UI per phase + design tokens + filter wireframes |

## Post-MVP features (2026-04-19~20)

Added post-MVP:
- **Favorites**: Multi-group support via `/api_customer/` endpoints; optimistic toggle + group picker/create dialogs.
- **BDS filter**: Multi-select property types, address cascade (tỉnh → huyện + keyword search), range dropdowns, location filter.
- **My-products**: Status tabs, parallel counts, 5-col grid layout.
- **Infinite scroll**: `use-bds-infinite-list` hook with defensive page-boundary detection.
- **Header visibility**: Scroll-driven filter chrome collapse via `bds-header-visibility-store.ts`.
- **Persisted state**: SSR-safe localStorage wrapper via `use-persisted-state.ts`.
- **UI primitives**: `async-combobox`, `multi-select-combobox` + favorite dialogs.

Component library + API client patterns documented inline in code; see `plans/reports/` for implementation summaries.

## Stack decisions (quick reference)

| Layer | Tool |
|-------|---|
| Framework | Next.js 15 (App Router) |
| Language | TypeScript strict |
| UI | shadcn/ui + Tailwind v4 |
| Server state | TanStack Query v5 |
| Client state | Zustand |
| Form | React Hook Form + Zod |
| Table | TanStack Table |
| HTTP | ofetch |
| Auth | Bearer token + Next Route Handler proxy |
| Map | Webview embed (trade-off) |
| Lint | Biome |
| Test | Vitest + Playwright |
| Deploy | Docker + Coolify/Dokploy |

## Phases (proposed)

| Phase | Duration | Deliverables |
|-------|----------|---|
| 0. Research | 2w | API catalog ✅ + wireframes + BE answers |
| 1. Foundation | 3w | Setup + Auth + Layout + Proxy + CI |
| 2. Core features | 6w | BDS, Dự án, Giao dịch, Nhu cầu, Profile |
| 3. Secondary | 3w | Hợp đồng, Lịch hẹn, Create news, KYC, Notification |
| 4. Polish + Release | 2w | Responsive, UAT, E2E, deploy |

**Total**: ~16 tuần = 4 tháng

## Cross-references

- V1 App Flutter source: `C:\Data 2026\Dev\Tongkhobds\src\tongkhobds_agent`
- BE V1 endpoint: `https://quanly.tongkhobds.com/tongkho`
- V1 feature spec: [../\_v1-reference/features/app/](../\_v1-reference/features/app/)
- V2 design context: [../v2-analysis/README.md](../v2-analysis/README.md)
- Domain entities: [../\_v1-reference/domain-entities.md](../\_v1-reference/domain-entities.md)
- Business rules: [../\_v1-reference/business-rules.md](../\_v1-reference/business-rules.md)

## Open questions

Xem [03-be-questions.md](./03-be-questions.md). Tóm tắt:
- Q1 Token TTL + refresh
- Q2 `/me` endpoint
- Q3 Upload limits
- Q4 Rate limit
- Q5 Notification type mapping

Deadline P1: **2026-04-24** (1 tuần).

---

<a id="docs-api-agent-batch-update-md"></a>

## docs/api_agent_batch_update.md

# API Agent - Batch Update & Support

Base URL: `/tongkho/api_agent`

---

## 1. get_list_offices

Lấy danh sách văn phòng (bưu cục) đang hoạt động.

**Endpoint:** `GET /get_list_offices.json`

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| filter | object | No | Bộ lọc tùy chọn |

**Response:**
```json
{
  "status": 1,
  "data": [
    {
      "id": 1,
      "name": "Văn phòng HCM",
      "name_code": "VP-HCM",
      "city": "ho-chi-minh",
      "address": "...",
      "phone": "...",
    }
  ],
  "count": 10
}
```

**Note:** Chỉ trả về văn phòng đang active (`aactive=1`) và đã duyệt (`status=2`).

---

## 2. get_sales_off_users

Lấy danh sách người phụ trách (sales_off) theo văn phòng hoặc tất cả.

**Endpoint:** `GET /get_sales_off_users.json`

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| post_office_id | integer | No | Lọc theo ID văn phòng |
| limit | integer | No | Số bản ghi (default: 50, max: 200) |
| offset | integer | No | Vị trí bắt đầu (default: 0) |

**Response:**
```json
{
  "status": 1,
  "data": [
    {
      "id": 513,
      "salesman_id": 180069,
      "staff_id": 86,
      "name": "fwer555",
      "phone": "0239428524",
      "office_id": 57,
      "positions": [
        {
          "id": 1,
          "name": "Nhân viên kinh doanh"
        }
      ],
    }
  ]
}
```

---

## 3. assign_salesman_support

Gán người phụ trách cho 1 hoặc nhiều entities (nhu cầu, agent, hợp đồng, giao dịch).

**Endpoint:** `POST /assign_salesman_support.json`

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| entity_type | string | Yes | Loại entity: `consultation`, `salesman`, `contract`, `transaction` |
| entity_id | integer | Yes* | ID entity (dùng cho 1 entity) |
| entity_ids | array | Yes* | List ID entities (dùng cho batch, thay thế entity_id) |
| user_id | integer | Yes | ID user (auth_user) được gán làm phụ trách |
| support_type | string | No | Loại support: `sales_offline` (default), `assigned_to`, `support` |

*Lưu ý: Chọn 1 trong 2: `entity_id` hoặc `entity_ids`.*

**Ví dụ request:**
```json
{
    "entity_type": "consultation",
    "entity_ids": [667, 666],
    "update_data": {
      "post_office_id": 29
    },
    "save_mode": "all"
  }
```

**Response:**
```json
{
    "status": 1,
    "data": {
        "success_count": 2,
        "error_count": 0,
        "updated_consultations": [
            {
                "id": 666,
                "post_office_id": 29
            },
            {
                "id": 667,
                "post_office_id": 29
            }
        ]
    },
    "message": "Hoàn thành",
    "execution_time": 0.02
}
```

**Side effects:**
- Tạo record trong bảng `salesman_support`
- Cập nhật field `user_support` (consultation) hoặc `agent_support` (salesman) trong bảng chính
- Gửi notification đến user được gán
- Ghi log tracking

**entity_type mapping:**

| entity_type | Table name | Field update |
|-------------|-----------|--------------|
| `consultation` | real_estate_consultation | `user_support` |
| `salesman` | salesman_agent | `agent_support` |
| `contract` | contract | - |
| `transaction` | real_estate_transaction | - |

---

## 4. get_salesman_support_history

Lấy lịch sử gán người phụ trách cho entity.

**Endpoint:** `GET /get_salesman_support_history.json`

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| entity_type | string | Yes | `consultation`, `salesman`, `contract`, `transaction` |
| entity_id | integer | Yes | ID entity |

**Response:**
```json
{
  "success": true,
  "data": [
     {
            "id": 220,
            "table_id": 666,
            "user_support_id": 521,
            "phone": "0235925243",
            "username": "0235925243",
            "name": "Nhân viên HR",
            "user_email": "",
            "support_type": "sales_offline",
            "status": true,
            "start_date": "08/01/2026",
            "role": "admin"
        }
  ],
  "message": "Lấy lịch sử thành công"
}
```

---

## 5. batch_update_entities

Cập nhật hàng loạt cho nhiều entities cùng lúc (gán văn phòng, tag, người phụ trách).

**Endpoint:** `POST /batch_update_entities.json`

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| entity_type | string | Yes | `consultation` hoặc `salesman` |
| entity_ids | array | Yes | Danh sách ID cần cập nhật |
| update_data | object | Yes | Các field cần cập nhật (xem bảng dưới) |
| save_mode | string | No | `new` (chỉ cập nhật entity chưa có giá trị) hoặc `all` (cập nhật tất cả). Default: `all` |

**update_data fields:**

| Field | Type | entity_type hỗ trợ | Description |
|-------|------|-------------------|-------------|
| post_office_id | integer | consultation, salesman | ID văn phòng cần gán |
| tag_id | array | consultation, salesman | Danh sách tag_id cần gán |
| replace_tags | boolean | consultation, salesman | `true` = thay thế toàn bộ tag, `false` = merge với tag hiện có |
| agent_support_id | integer | salesman | salesman.id người phụ trách |
| user_id | integer | salesman | auth_user.id người phụ trách (đi kèm agent_support_id, dùng để gửi notification) |

**Ví dụ 1 - Gán văn phòng cho consultation:**
```json
{
  "entity_type": "consultation",
  "entity_ids": [1, 2, 3],
  "update_data": {
    "post_office_id": 5
  },
  "save_mode": "new"
}
```

**Ví dụ 2 - Gán tag cho consultation:**
```json
{
  "entity_type": "consultation",
  "entity_ids": [1, 2, 3],
  "update_data": {
    "tag_id": [10, 20],
    "replace_tags": false
  },
  "save_mode": "all"
}
```

**Ví dụ 3 - Gán văn phòng + người phụ trách cho salesman:**
```json
{
  "entity_type": "salesman",
  "entity_ids": [10, 20],
  "update_data": {
    "post_office_id": 5,
    "agent_support_id": 99,
    "user_id": 50
  },
  "save_mode": "all"
}
```

**Response:**
```json
{
  "status": 1,
  "data": {
    "success_count": 3,
    "error_count": 0,
    "updated_agents": [
      { "id": 10, "post_office_id": 5 },
      { "id": 20, "post_office_id": 5 }
    ]
  },
  "message": "Cập nhật thành công 3 salesman"
}
```

**save_mode giải thích:**

| Mode | Hành vi |
|------|---------|
| `new` | Chỉ cập nhật entity **chưa có giá trị** cho field đó (field = null hoặc rỗng). Dùng khi không muốn ghi đè dữ liệu cũ. |
| `all` | Cập nhật **tất cả** entity được chọn, bất kể field đã có giá trị hay chưa. |

---

## Flow gán người phụ trách cho nhu cầu (consultation)

```
1. GET  /get_list_offices          -> Chọn văn phòng
2. GET  /get_sales_off_users       -> Chọn người phụ trách (filter theo post_office_id)
3. POST /assign_salesman_support   -> Gán người phụ trách
   hoặc
   POST /batch_update_entities     -> Gán văn phòng + người phụ trách cùng lúc
```

---

<a id="docs-consultation-sell-api-delivery-md"></a>

## docs/consultation-sell-api-delivery.md

# Consultation Sell - API Delivery Report

**Ngày bàn giao:** 2026-05-16
**Backend module:** `controllers/api_agent.py` + `modules/consultation_sell_manager.py`
**Base path:** `/tongkho/api_agent/{endpoint}`
**Authentication:** JWT Bearer Token (header `Authorization: Bearer <token>`)
**Response envelope:** `{ status: "1"/"0", data: {...}, message: "..." }`

---

## 📊 Tổng Quan

| Sprint | Endpoints | Status |
|--------|-----------|--------|
| **Sprint 1 — Critical (P1)** | 4 | ✅ Đã xong |
| **Sprint 2 — Important (P2)** | 5 | ✅ Đã xong |
| **Sprint 3 — Advanced (P3)** | 2 | ✅ Đã xong |
| **TỔNG** | **11 mới + 1 reuse** | ✅ |

> Endpoint `get_offices` (yêu cầu P1) đã có sẵn từ trước tại [api_agent.py:19686](../controllers/api_agent.py#L19686), không cần xây mới.

---

## 🔥 SPRINT 1 — Critical (Wire ngay)

### 1.1. `GET /api_agent/get_property_types`

**Frontend Use Case:** Filter dropdown loại BĐS, property type mapping trong adapter.

**Source:** [api_agent.py:25016](../controllers/api_agent.py#L25016)

**Query Params:**
| Param | Type | Required | Mô tả |
|-------|------|----------|-------|
| `transaction_type_id` | int | ❌ | 1=Bán, 2=Cho thuê |
| `active_only` | bool | ❌ | Default `true` |

**Response:**
```json
{
  "status": "1",
  "message": "Lấy danh sách thành công",
  "data": {
    "items": [
      {
        "id": 1,
        "name": "Chung cư",
        "code": "chung-cu",
        "icon": "...",
        "transaction_type_id": 1,
        "sort_order": 1,
        "is_active": true,
        "parent_id": null
      }
    ]
  }
}
```

**Sample call:**
```bash
GET /tongkho/api_agent/get_property_types?transaction_type_id=1&active_only=true
```

---

### 1.2. `GET /api_agent/get_consultation_sell_status_counts`

**Frontend Use Case:** Status tabs counts trên list page.

**Source:** [api_agent.py:25077](../controllers/api_agent.py#L25077)

**Query Params:**
| Param | Type | Required | Mô tả |
|-------|------|----------|-------|
| `office_id` | int | ❌ | Filter văn phòng |
| `listing_manager_id` | int | ❌ | Filter LM |
| `city_id` | string | ❌ | Filter tỉnh/thành |
| `start_date` | string (ISO 8601) | ❌ | Từ ngày |
| `end_date` | string (ISO 8601) | ❌ | Đến ngày |

**Response:**
```json
{
  "status": "1",
  "message": "Lấy thống kê thành công",
  "data": {
    "counts": [
      { "status": "all",        "count": 312, "label": "Tất cả" },
      { "status": "new",        "count": 45,  "label": "Mới" },
      { "status": "pending",    "count": 12,  "label": "Chờ xử lý" },
      { "status": "consulting", "count": 189, "label": "Đang tư vấn" },
      { "status": "closed",     "count": 66,  "label": "Đã đóng" }
    ]
  }
}
```

**Sample call:**
```bash
GET /tongkho/api_agent/get_consultation_sell_status_counts?office_id=1
```

---

### 1.3. `GET /api_agent/get_listing_managers`

**Frontend Use Case:** Populate Assign Broker Dialog, filter by listing manager.

**Source:** [api_agent.py:25120](../controllers/api_agent.py#L25120)

**Query Params:**
| Param | Type | Required | Mô tả |
|-------|------|----------|-------|
| `office_id` | int | ❌ | Filter văn phòng |
| `status` | string | ❌ | `active` / `inactive` |
| `search` | string | ❌ | Tìm theo name/phone |
| `page` | int | ❌ | Default 1 |
| `limit` | int | ❌ | Default 50, max 200 |

**Response:**
```json
{
  "status": "1",
  "message": "Lấy danh sách thành công",
  "data": {
    "items": [
      {
        "id": 789,
        "full_name": "Nguyễn Văn A",
        "phone": "0912345678",
        "email": "email@example.com",
        "avatar_url": "https://...",
        "office_id": 1,
        "office_name": "VP Hà Nội",
        "role": "listing_manager",
        "stats_30days": {
          "total_leads": 18,
          "completed_leads": 13,
          "success_rate": 72.22,
          "avg_response_time": 0
        },
        "is_active": true,
        "created_at": "2026-01-15"
      }
    ],
    "total": 45,
    "page": 1,
    "limit": 50,
    "has_more": false
  }
}
```

**⚠️ Lưu ý FE:**
- `avg_response_time` hiện trả `0` (cần backend bổ sung tracking response time).
- `role` luôn trả `"listing_manager"` (chưa phân biệt vai trò chi tiết).

**Sample call:**
```bash
GET /tongkho/api_agent/get_listing_managers?office_id=1&status=active&page=1&limit=50
```

---

### 1.4. `GET /api_agent/get_users_minimal`

**Frontend Use Case:** Display creator/updater names trong list/detail.

**Source:** [api_agent.py:25254](../controllers/api_agent.py#L25254)

**Query Params:**
| Param | Type | Required | Mô tả |
|-------|------|----------|-------|
| `user_ids` | array/CSV/JSON | ❌* | Batch fetch theo ID — `[123,456]` hoặc `"123,456"` |
| `role` | string | ❌* | Filter theo role |

> *Phải truyền ít nhất 1 trong 2 (`user_ids` hoặc `role`) để tránh trả toàn bộ user.

**Response:**
```json
{
  "status": "1",
  "message": "Lấy danh sách thành công",
  "data": {
    "items": [
      {
        "id": 123,
        "full_name": "Nguyễn Văn A",
        "username": "nguyenvana",
        "email": "email@example.com",
        "phone": "0912345678",
        "avatar_url": "https://...",
        "role": "Admin",
        "role_display": "Quản trị viên"
      }
    ]
  }
}
```

**Sample call:**
```bash
GET /tongkho/api_agent/get_users_minimal?user_ids=[123,456,789]
```

---

### 1.5. `GET /api_agent/get_offices` ✅ ĐÃ CÓ SẴN

**Source:** [api_agent.py:19686](../controllers/api_agent.py#L19686)

> Endpoint này đã được xây dựng từ trước. FE chỉ cần wire vào.

**Query Params chính:**
| Param | Type | Mô tả |
|-------|------|-------|
| `id` | int | Lấy chi tiết 1 văn phòng |
| `q` | string | Search keyword |
| `city` | string | Filter tỉnh |
| `district` | string | Filter quận |
| `ward` | string | Filter phường |
| `office_level` | int | Cấp văn phòng (1=Vùng, 2=Tỉnh, 3=Huyện, 4=Xã) |
| `type_office` | int | Loại VP |
| `limit` | int | Default 20 |
| `offset` | int | Default 0 |

---

## 🔶 SPRINT 2 — Bulk Operations & Export

### 2.1. `POST /api_agent/bulk_update_consultation_sell_status`

**Frontend Use Case:** Bulk actions từ list page (change status).

**Source:** [api_agent.py:25322](../controllers/api_agent.py#L25322)

**Body Params:**
| Param | Type | Required | Mô tả |
|-------|------|----------|-------|
| `ids` | array[int] / CSV / JSON | ✅ | Danh sách consultation_sell ID |
| `demand_status` | string | ✅ | `new` / `pending` / `consulting` / `closed` |
| `reason` | string | ❌ | Lý do |

**Response:**
```json
{
  "status": "1",
  "message": "Cập nhật thành công 15/15 leads",
  "data": {
    "updated_count": 15,
    "failed_ids": [],
    "errors": {}
  }
}
```

Nếu có lỗi từng record:
```json
{
  "updated_count": 13,
  "failed_ids": [102, 105],
  "errors": {
    "102": "Không tìm thấy consultation_sell 102",
    "105": "Trạng thái không hợp lệ"
  }
}
```

**Sample call:**
```bash
POST /tongkho/api_agent/bulk_update_consultation_sell_status
Body: ids=[1,2,3]&demand_status=consulting&reason=Đã liên hệ
```

---

### 2.2. `POST /api_agent/bulk_assign_listing_manager`

**Frontend Use Case:** Bulk assign từ list page.

**Source:** [api_agent.py:25364](../controllers/api_agent.py#L25364)

**Body Params:**
| Param | Type | Required | Mô tả |
|-------|------|----------|-------|
| `ids` | array[int] | ✅ | Danh sách consultation_sell ID |
| `listing_manager_id` | int | ✅ | ID listing manager (salesman) |
| `send_notification` | bool | ❌ | Default `true` |

**Response:**
```json
{
  "status": "1",
  "message": "Đã giao 10/10 leads cho listing manager",
  "data": {
    "assigned_count": 10,
    "failed_ids": [],
    "errors": {}
  }
}
```

**⚠️ Lưu ý FE:** Hiện notification chỉ log (chưa wire vào push service). Backend đã đặt stub sẵn — sẽ wire trong sprint sau.

---

### 2.3. `POST /api_agent/bulk_delete_consultation_sell`

**Frontend Use Case:** Bulk delete từ list page. **Soft delete** (set `aactive=False`).

**Source:** [api_agent.py:25408](../controllers/api_agent.py#L25408)

**Body Params:**
| Param | Type | Required | Mô tả |
|-------|------|----------|-------|
| `ids` | array[int] | ✅ | Danh sách ID |
| `reason` | string | ❌ | Lý do |

**Response:**
```json
{
  "status": "1",
  "message": "Đã xóa 5/5 leads",
  "data": {
    "deleted_count": 5,
    "failed_ids": [],
    "errors": {}
  }
}
```

---

### 2.4. `GET /api_agent/get_consultation_sell_tags`

**Frontend Use Case:** Display tags trong detail page, tag picker.

**Source:** [api_agent.py:25444](../controllers/api_agent.py#L25444)

**Query Params:**
| Param | Type | Required | Mô tả |
|-------|------|----------|-------|
| `id` | int | ✅ | ID consultation_sell |

**Response:**
```json
{
  "status": "1",
  "message": "Lấy tags thành công",
  "data": {
    "tags": [
      {
        "id": 69,
        "name": "VIP",
        "color": "#FEE4C4",
        "category_id": 1,
        "category_name": "Độ ưu tiên",
        "group_id": 5,
        "group_name": "Mức ưu tiên",
        "assigned_at": "2026-05-15T08:00:00",
        "assigned_by": {
          "id": 123,
          "full_name": "Nguyễn Văn A"
        }
      }
    ]
  }
}
```

**⚠️ Lưu ý FE:** Backend dùng bảng `entity_tags` (table_name='consultation_sell') — KHÔNG dùng field `tag_ids` cũ. Để gán/gỡ tag, dùng endpoint `list_tags` (POST) đã có sẵn.

---

### 2.5. `GET /api_agent/export_consultation_sell_excel`

**Frontend Use Case:** Export Excel button trên list page.

**Source:** [api_agent.py:25475](../controllers/api_agent.py#L25475)

**Query Params:** (giống hệt `list_consultation_sell`)
| Param | Type | Mô tả |
|-------|------|-------|
| `demand_status` | string | Filter status |
| `office_id` | int | Filter văn phòng |
| `listing_manager_id` | int | Filter LM |
| `property_type_id` | int | Filter loại BĐS |
| `city_id` | string | Filter tỉnh |
| `district_id` | string | Filter quận |
| `search` | string | Search keyword |
| `start_date` | string | Từ ngày |
| `end_date` | string | Đến ngày |

**Response Headers:**
```
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
Content-Disposition: attachment; filename="consultation_sell_20260516_140523.xlsx"
```

**Cách dùng từ FE:**
```js
window.open(`/tongkho/api_agent/export_consultation_sell_excel?${queryString}`)
```

**Cột Excel (17 cột):**
Mã NC | Trạng thái | Tên KH | SĐT KH | Loại BĐS | Diện tích | Giá tối thiểu | Giá tối đa | Tỉnh | Quận | Địa chỉ | Văn phòng | Listing Manager | SĐT LM | Nguồn | Ghi chú | Ngày tạo

---

## 🔷 SPRINT 3 — Advanced

### 3.1. `GET /api_agent/get_consultation_sell_stats`

**Frontend Use Case:** Dashboard stats strip, analytics page.

**Source:** [api_agent.py:25587](../controllers/api_agent.py#L25587)

**Query Params:**
| Param | Type | Required | Mô tả |
|-------|------|----------|-------|
| `start_date` | string ISO 8601 | ❌ | Default: 30 ngày trước |
| `end_date` | string ISO 8601 | ❌ | Default: hôm nay |
| `office_id` | int | ❌ | Filter VP |

**Response:**
```json
{
  "status": "1",
  "message": "Lấy thống kê thành công",
  "data": {
    "period": {
      "start_date": "2026-04-16",
      "end_date": "2026-05-16"
    },
    "overview": {
      "total_leads": 312,
      "new_leads": 45,
      "active_leads": 201,
      "closed_leads": 66
    },
    "conversion": {
      "conversion_rate": 21.15,
      "avg_cycle_time": 0,
      "top_performers": [
        {
          "id": 789,
          "full_name": "Nguyễn Văn A",
          "closed_count": 23,
          "success_rate": 78.5
        }
      ]
    },
    "by_source": [
      { "source": "Website",  "count": 120, "percentage": 38.46 },
      { "source": "Facebook", "count": 89,  "percentage": 28.53 },
      { "source": "CTV",      "count": 65,  "percentage": 20.83 }
    ],
    "by_property_type": [
      { "property_type": "Chung cư", "count": 145, "percentage": 46.47 },
      { "property_type": "Nhà phố",  "count": 89,  "percentage": 28.53 }
    ]
  }
}
```

**⚠️ Lưu ý FE:** `avg_cycle_time` hiện trả `0` — cần backend bổ sung field `closed_at` mới tính chính xác.

---

### 3.2. `GET /api_agent/check_duplicate_consultation_sell`

**Frontend Use Case:** Duplicate warning khi tạo/edit lead.

**Source:** [api_agent.py:25624](../controllers/api_agent.py#L25624)

**Query Params:**
| Param | Type | Required | Mô tả |
|-------|------|----------|-------|
| `customer_phone` | string | ✅ | SĐT khách hàng |
| `exclude_id` | int | ❌ | Loại trừ ID khi edit |

**Response:**
```json
{
  "status": "1",
  "message": "Kiểm tra trùng lặp thành công",
  "data": {
    "is_duplicate": true,
    "duplicates": [
      {
        "id": 3215,
        "demand_code": "CS-20260514-0001",
        "customer_name": "Chị Lan",
        "customer_phone": "098.222.7788",
        "demand_status": "consulting",
        "created_at": "2026-05-14T15:25:00",
        "days_ago": 2
      }
    ]
  }
}
```

**Sample call:**
```bash
GET /tongkho/api_agent/check_duplicate_consultation_sell?customer_phone=0982227788
```

---

## 🗂️ Bảng Tra Cứu Nhanh

| # | Endpoint | Method | Source line | Sprint |
|---|----------|--------|-------------|--------|
| 1 | `get_property_types` | GET | 25016 | P1 |
| 2 | `get_consultation_sell_status_counts` | GET | 25077 | P1 |
| 3 | `get_listing_managers` | GET | 25120 | P1 |
| 4 | `get_users_minimal` | GET | 25254 | P1 |
| 5 | `get_offices` ✅ có sẵn | GET | 19686 | P1 |
| 6 | `bulk_update_consultation_sell_status` | POST | 25322 | P2 |
| 7 | `bulk_assign_listing_manager` | POST | 25364 | P2 |
| 8 | `bulk_delete_consultation_sell` | POST | 25408 | P2 |
| 9 | `get_consultation_sell_tags` | GET | 25444 | P2 |
| 10 | `export_consultation_sell_excel` | GET | 25475 | P2 |
| 11 | `get_consultation_sell_stats` | GET | 25587 | P3 |
| 12 | `check_duplicate_consultation_sell` | GET | 25624 | P3 |

---

## 🛠️ Backend Internal Changes

### Module mới: `ConsultationSellManager`

File: [modules/consultation_sell_manager.py](../modules/consultation_sell_manager.py)

**Methods mới được bổ sung:**
| Method | Mục đích |
|--------|---------|
| `change_status(cs_id, status, reason)` | Đổi status đơn (trước đó missing) |
| `get_status_counts(filters)` | Aggregate count theo status |
| `bulk_change_status(ids, status, reason)` | Bulk update status |
| `bulk_assign_listing_manager(ids, lm_id, send_notification)` | Bulk assign LM |
| `bulk_delete(ids, reason)` | Bulk soft delete |
| `get_entity_tags(cs_id)` | Lấy tags đã gán cho 1 entity |
| `get_stats(start_date, end_date, office_id)` | Thống kê dashboard |
| `check_duplicate(customer_phone, exclude_id)` | Tìm leads trùng SĐT |
| `list_for_export(filters)` | List + enrich data cho Excel export |

---

## 📌 Quy ước & Tiêu chuẩn

### Authentication
Tất cả endpoints dùng `@myjwt.allows_jwt()`. FE truyền JWT qua header:
```
Authorization: Bearer <jwt_token>
```

### Response envelope (success)
```json
{ "status": "1", "data": {...}, "message": "Thành công" }
```

### Response envelope (error)
```json
{ "status": "0", "data": {}, "message": "Lỗi: ..." }
```

### Array parameters
Các endpoint nhận array (`ids`, `user_ids`) chấp nhận:
- **JSON array**: `[1,2,3]`
- **CSV**: `"1,2,3"`
- **Repeated form fields**: `ids=1&ids=2&ids=3`

---

## ⚠️ Hạn Chế Hiện Tại & Backlog Backend

| # | Hạn chế | Endpoint ảnh hưởng | Cần làm |
|---|---------|---------------------|---------|
| 1 | `avg_response_time = 0` | `get_listing_managers` | Tracking response time vào real_estate_comment |
| 2 | `avg_cycle_time = 0` | `get_consultation_sell_stats` | Thêm field `closed_at` vào consultation_sell |
| 3 | Notification chỉ log | `bulk_assign_listing_manager` | Wire vào push notification service |
| 4 | `role` chỉ trả `listing_manager` | `get_listing_managers` | Tracking role chi tiết theo salesman_type |

---

## 📝 Changelog

**2026-05-16** — Initial delivery
- Thêm 11 endpoints mới vào `controllers/api_agent.py` (line 25016-25640)
- Thêm 9 methods mới vào `modules/consultation_sell_manager.py`
- Verified: `python -m py_compile` PASS

---

**Liên hệ Backend:** Team Backend Tongkho
**Liên hệ Frontend:** Frontend Team
**File yêu cầu gốc:** [consultation-sell-api-requirements.md](./consultation-sell-api-requirements.md)

---

<a id="docs-consultation-sell-api-integration-report-md"></a>

## docs/consultation-sell-api-integration-report.md

# Consultation Sell - API Integration Report

**Ngày kiểm tra:** 2026-05-16  
**Trạng thái:** Partial Integration (70% Complete)

---

## 📊 Tổng quan

### API Endpoints từ Documentation: 12 endpoints

| Endpoint | Method | Trạng thái | File |
|----------|--------|------------|------|
| `/api_agent/list_consultation_sell` | GET | ✅ Hoàn thành | `src/lib/api/consultation-sell.ts` |
| `/api_agent/get_consultation_sell` | GET | ✅ Hoàn thành | `src/lib/api/consultation-sell.ts` |
| `/api_agent/create_consultation_sell` | POST | ✅ Hoàn thành | `src/lib/api/consultation-sell.ts` |
| `/api_agent/update_consultation_sell` | POST | ✅ Hoàn thành | `src/lib/api/consultation-sell.ts` |
| `/api_agent/delete_consultation_sell` | POST | ✅ Hoàn thành | `src/lib/api/consultation-sell.ts` |
| `/api_agent/consultation_sell_assign_listing_manager` | POST | ⚠️ API xong, Modal chưa wire | `src/lib/api/consultation-sell.ts` |
| `/api_agent/consultation_sell_link_real_estate` | POST | ✅ Hoàn thành | `src/lib/api/consultation-sell.ts` |
| `/api_agent/get_activities_consultation_sell` | GET | ✅ Hoàn thành | `src/lib/api/consultation-sell.ts` |
| `/api_agent/create_work_consultation_sell` | POST | ✅ Hoàn thành | `src/lib/api/consultation-sell.ts` |
| `/api_agent/add_work_comment_consultation_sell` | POST | ✅ Hoàn thành | `src/lib/api/consultation-sell.ts` |
| `/api_agent/consultation_sell_get_comments` | GET | ✅ Hoàn thành | `src/lib/api/consultation-sell.ts` |
| `/api_agent/consultation_sell_create_comment` | POST | ✅ Hoàn thành | `src/lib/api/consultation-sell.ts` |

**Tỷ lệ hoàn thành API Layer:** 12/12 (100%)

---

## 🎯 Pages Integration Status

### ✅ List Page (`/nhu-cau-ban`)

**File:** `src/app/(dashboard)/nhu-cau-ban/page.tsx`

| Chức năng | API/Data | Trạng thái |
|-----------|----------|------------|
| Danh sách lead | ✅ Real API (`useConsultationSellList`) | Hoàn thành |
| Pagination | ✅ Real API | Hoàn thành |
| Filter by status | ✅ Real API | Hoàn thành |
| Refresh button | ✅ Real API (`refetch()`) | Hoàn thành |
| Loading state | ✅ Implemented | Hoàn thành |
| Error state | ✅ Implemented | Hoàn thành |
| Status tabs | ⚠️ Hardcoded (không count từ API) | Cần cải thiện |
| Export Excel | ❌ Placeholder | Chưa impl |
| Bulk actions | ❌ UI có sẵn, chưa wire API | Chưa impl |

**Data flow:**
```
API → useConsultationSellList() → consultationSellToLead() → UI Components (Lead type)
```

---

### ✅ Detail Page (`/nhu-cau-ban/[id]`)

**File:** `src/app/(dashboard)/nhu-cau-ban/[id]/page.tsx`

| Chức năng | API/Data | Trạng thái |
|-----------|----------|------------|
| Lead detail | ✅ Real API (`useConsultationSellDetail`) | Hoàn thành |
| Activities timeline | ✅ Real API (`useActivities`) | Hoàn thành |
| Loading state | ✅ Implemented | Hoàn thành |
| Error/404 state | ✅ Implemented | Hoàn thành |

**Data flow:**
```
API → useConsultationSellDetail() + useActivities() → consultationSellToLead() → UI Components
```

---

## 🔧 Components Data Sources

### ✅ Using Real API

| Component | Data Source | File |
|-----------|-------------|------|
| `NhuCauBanListTable` | API via adapter | `src/components/nhu-cau-ban/list/list-table.tsx` |
| `NhuCauBanMobileLeadCard` | API via adapter | `src/components/nhu-cau-ban/list/mobile-lead-card.tsx` |
| `DetailPageHeader` | API via adapter | `src/components/nhu-cau-ban/detail/detail-page-header.tsx` |
| `DetailActivityCard` | API (activities) | `src/components/nhu-cau-ban/detail/activity-card.tsx` |
| All detail cards | API via adapter | `src/components/nhu-cau-ban/detail/*.tsx` |

### ❌ Still Using Mock Data

| Component | Mock Data | File | Cần wire API |
|-----------|-----------|------|--------------|
| `AssignBrokerDialog` | `MOCK_BROKERS` | `src/components/nhu-cau-ban/modals/assign-broker-dialog.tsx` | ⚠️ Cần get listing managers API |
| `CloseLeadDialog` | ✅ Type only, UI only | `src/components/nhu-cau-ban/modals/close-lead-dialog.tsx` | ⚠️ Cần wire delete API |
| `LogActivitySheet` | ✅ Type only, UI only | `src/components/nhu-cau-ban/modals/log-activity-sheet.tsx` | ⚠️ Cần wire create work API |

---

## 📦 Files Still Using Mock Data

| File | Usage | Priority |
|------|-------|----------|
| `src/lib/nhu-cau-ban/mock-leads.ts` | ❌ Chưa dùng (đã thay bằng API) | Có thể xoá |
| `src/lib/nhu-cau-ban/source-meta.ts` | ⚠️ Cần kiểm tra | Medium |

---

## 🚧 Remaining Work

### High Priority

1. **Wire Assign Broker Modal**
   - File: `src/components/nhu-cau-ban/modals/assign-broker-dialog.tsx`
   - Cần: API lấy danh sách listing managers
   - Action: Wire `useAssignListingManager()` mutation

2. **Implement Status Counts**
   - File: `src/app/(dashboard)/nhu-cau-ban/page.tsx`
   - Cần: API trả về count per status tab
   - Action: Add `demand_status` parameter to count tabs

3. **Wire Log Activity Sheet**
   - File: `src/components/nhu-cau-ban/modals/log-activity-sheet.tsx`
   - Cần: Wire `useCreateWork()` mutation
   - Action: Call API when form submitted

### Medium Priority

4. **Wire Close Lead Dialog**
   - File: `src/components/nhu-cau-ban/modals/close-lead-dialog.tsx`
   - Cần: Wire `useDeleteConsultationSell()` hoặc update status
   - Action: Call API khi confirm

5. **Implement Export Excel**
   - File: `src/app/(dashboard)/nhu-cau-ban/page.tsx`
   - Cần: Backend endpoint export
   - Action: Add API call

6. **Implement Bulk Actions**
   - File: `src/components/nhu-cau-ban/list/bulk-action-pills.tsx`
   - Cần: Bulk update/delete API
   - Action: Wire mutations

### Low Priority

7. **Clean Up Mock Files**
   - File: `src/lib/nhu-cau-ban/mock-leads.ts`
   - Action: Remove if no longer used

8. **Improve Adapter Functions**
   - File: `src/lib/consultation-sell/adapter.ts`
   - Cần: Map đầy đủ các field (property_type, office, creator, broker)
   - Action: Add proper mapping logic

---

## 🔍 Data Flow Analysis

### Current Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      API Layer (100%)                        │
│  src/lib/api/consultation-sell.ts (12 endpoints ✅)          │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    React Hooks (100%)                       │
│  src/hooks/use-consultation-sell.ts (all wired ✅)           │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                   Adapter Layer (100%)                      │
│  src/lib/consultation-sell/adapter.ts                       │
│  • consultationSellToLead(): API → UI type mapping          │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    UI Components (70%)                      │
│  • List page: ✅ 100% API                                   │
│  • Detail page: ✅ 100% API                                 │
│  • Modals: ❌ 0% API (still mock data)                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 📈 Completion Metrics

| Layer | Completion | Notes |
|-------|------------|-------|
| API Types (Zod) | 100% | All endpoints typed |
| API Client | 100% | All 12 endpoints implemented |
| React Hooks | 100% | All queries + mutations ready |
| Adapter | 90% | Core fields mapped, some TODOs |
| List Page | 95% | Main flow done, counts hardcoded |
| Detail Page | 100% | All features wired |
| Modals | 0% | UI ready, data still mock |

**Overall Completion:** ~70%

---

## 🎯 Recommendations

### Immediate Actions (Week 1)

1. Wire Assign Broker Modal → `useAssignListingManager()`
2. Wire Log Activity Sheet → `useCreateWork()`
3. Wire Close Lead → `useDeleteConsultationSell()` or status update
4. Add status tab counts from API response

### Short Term (Week 2)

5. Implement Export Excel functionality
6. Wire bulk actions (assign multiple, delete multiple)
7. Improve adapter mapping (property types, offices, users)

### Long Term (Week 3+)

8. Add real-time updates (polling/websocket)
9. Add advanced filtering
10. Add analytics/stats dashboard

---

## 📝 Technical Debt

1. **Hardcoded values in adapter:**
   - Property types: "BĐS" (should map from property_type_id)
   - Offices: "VP Hà Nội" (should map from office_id)
   - Creators: "Admin" (should map from created_by)
   - Brokers: "Đầu chủ" (should map from listing_manager_id)

2. **Missing mappings:**
   - Tags: Empty array (should map from tag_ids)
   - Tasks: Static array (should calculate from activities)
   - Call/Note counts: Zeros (should count from activities)

3. **Status tabs:**
   - Counts are hardcoded undefined
   - Should fetch from API or calculate from list

---

**Report Generated:** 2026-05-16  
**Next Review:** Sau khi wire modals (target: 90% completion)

---

<a id="docs-consultation-sell-api-requirements-md"></a>

## docs/consultation-sell-api-requirements.md

# Consultation Sell - Backend API Requirements

**Ngày yêu cầu:** 2026-05-16  
**Mô-đun:** Nhu cầu Bán (Consultation Sell)  
**Mục đích:** Hoàn thiện API integration cho frontend

---

## 📋 Tổng Quan

Dựa trên review frontend hiện tại (70% hoàn thành), đây là danh sách các API endpoints cần backend cung cấp để hoàn thiện chức năng còn thiếu.

**Trạng thái hiện tại:**
- ✅ 12/12 CRUD endpoints đã có
- ✅ Activities & Comments endpoints đã có
- ⚠️ Missing: Reference data endpoints (users, offices, property types, stats)
- ⚠️ Missing: Advanced features (bulk operations, export)

---

## 🔥 Priority 1 - Critical APIs (Cần ngay)

### 1. Get Listing Managers/Salesmen List

**Mô tả:** Lấy danh sách nhân viên để populate vào Assign Broker Dialog

**Endpoint:** `GET /api_agent/get_listing_managers`

**Query Parameters:**
```typescript
{
  office_id?: number;           // Filter by office
  status?: string;              // Filter by status (active, inactive)
  search?: string;              // Search by name, phone
  page?: number;                // Pagination
  limit?: number;               // Default 50
}
```

**Response:**
```typescript
{
  status: "1",
  message: "Lấy danh sách thành công",
  data: {
    items: [
      {
        id: 789;                          // salesman ID
        full_name: "Nguyễn Văn A";        // Họ tên
        phone: "0912345678";              // SĐT
        email: "email@example.com";       // Email (optional)
        avatar_url?: string;              // Link avatar (optional)
        office_id: 1;                     // ID văn phòng
        office_name: "VP Hà Nội";         // Tên văn phòng
        role: "listing_manager";          // Role: listing_manager, sales_off, etc.
        
        // Stats cho UI (30 ngày)
        stats_30days: {
          total_leads: 18;                // Tổng số leads được giao
          completed_leads: 13;            // Số leads đã chốt
          success_rate: 72.2;             // Tỷ lệ thành công (%)
          avg_response_time: 28;          // TB thời gian phản hồi (phút)
        };
        
        // Info thêm
        is_active: true;                  // Đang hoạt động
        created_at: "2026-01-15T08:00:00";
      }
    ],
    total: 45;
    page: 1;
    limit: 50;
    has_more: true;
  }
}
```

**TypeScript Definition:**
```typescript
interface ListingManager {
  id: number;
  full_name: string;
  phone: string;
  email?: string;
  avatar_url?: string;
  office_id: number;
  office_name: string;
  role: string;
  stats_30days: {
    total_leads: number;
    completed_leads: number;
    success_rate: number;
    avg_response_time: number;
  };
  is_active: boolean;
  created_at: string;
}

interface ListingManagersResponse {
  items: ListingManager[];
  total: number;
  page: number;
  limit: number;
  has_more: boolean;
}
```

**Use Case:** Assign Broker Dialog, Filter by listing manager

---

### 2. Get Status Tab Counts

**Mô tả:** Lấy số lượng lead theo từng status để hiển thị trên tabs

**Endpoint:** `GET /api_agent/get_consultation_sell_status_counts`

**Query Parameters:**
```typescript
{
  office_id?: number;           // Filter by office
  listing_manager_id?: number;   // Filter by listing manager
  city_id?: string;             // Filter by city
  start_date?: string;          // Filter from date (ISO 8601)
  end_date?: string;            // Filter to date (ISO 8601)
}
```

**Response:**
```typescript
{
  status: "1",
  message: "Lấy thống kê thành công",
  data: {
    counts: [
      { status: "all"; count: 312; label: "Tất cả" },
      { status: "new"; count: 45; label: "Mới" },
      { status: "pending"; count: 12; label: "Chờ xử lý" },
      { status: "consulting"; count: 189; label: "Đang tư vấn" },
      { status: "closed"; count: 66; label: "Đã đóng" }
    ]
  }
}
```

**TypeScript Definition:**
```typescript
interface StatusCount {
  status: 'all' | 'new' | 'pending' | 'consulting' | 'closed';
  count: number;
  label: string;
}

interface StatusCountsResponse {
  counts: StatusCount[];
}
```

**Use Case:** Status tabs on list page

---

### 3. Get Property Types List

**Mô tả:** Lấy danh sách loại bất động sản để mapping và filter

**Endpoint:** `GET /api_agent/get_property_types`

**Query Parameters:**
```typescript
{
  transaction_type_id?: number;  // 1=Bán, 2=Cho thuê
  active_only?: boolean;         // Chỉ lấy loại đang active
}
```

**Response:**
```typescript
{
  status: "1",
  message: "Lấy danh sách thành công",
  data: {
    items: [
      {
        id: 1;
        name: "Chung cư";                  // Tên hiển thị
        code: "apartment";                // Code để lookup
        icon?: string;                    // Icon URL (optional)
        transaction_type_id: 1;           // 1=Bán, 2=Cho thuê
        sort_order: 1;                    // Thứ tự sắp xếp
        is_active: true;
      },
      {
        id: 2;
        name: "Nhà phố";
        code: "townhouse";
        transaction_type_id: 1;
        sort_order: 2;
        is_active: true;
      },
      {
        id: 3;
        name: "Đất nền";
        code: "land";
        transaction_type_id: 1;
        sort_order: 3;
        is_active: true;
      },
      // ... more types
    ]
  }
}
```

**TypeScript Definition:**
```typescript
interface PropertyType {
  id: number;
  name: string;
  code: string;
  icon?: string;
  transaction_type_id: number;
  sort_order: number;
  is_active: boolean;
}

interface PropertyTypesResponse {
  items: PropertyType[];
}
```

**Use Case:** Filter dropdown, property type mapping in adapter

---

### 4. Get Offices List

**Mô tả:** Lấy danh sách văn phòng để mapping và filter

**Endpoint:** `GET /api_agent/get_offices`

**Query Parameters:**
```typescript
{
  city_id?: string;      // Filter by city
  active_only?: boolean; // Chỉ lấy VP đang active
}
```

**Response:**
```typescript
{
  status: "1",
  message: "Lấy danh sách thành công",
  data: {
    items: [
      {
        id: 1;
        name: "VP Hà Nội";
        city_id: "01";
        city_name: "Hà Nội";
        address: "123 Đường ABC, Quận Hoàn Kiếm";
        phone: "0241234567";
        is_active: true;
      },
      {
        id: 2;
        name: "VPHCM";
        city_id: "79";
        city_name: "TP. Hồ Chí Minh";
        address: "456 Đường XYZ, Quận 1";
        phone: "0287654321";
        is_active: true;
      },
      // ... more offices
    ]
  }
}
```

**TypeScript Definition:**
```typescript
interface Office {
  id: number;
  name: string;
  city_id: string;
  city_name: string;
  address: string;
  phone?: string;
  is_active: boolean;
}

interface OfficesResponse {
  items: Office[];
}
```

**Use Case:** Office dropdown, office mapping in adapter

---

### 5. Get Users List (Minimal)

**Mô tả:** Lấy thông tin user cơ bản để mapping created_by, updated_by

**Endpoint:** `GET /api_agent/get_users_minimal`

**Query Parameters:**
```typescript
{
  user_ids?: number[];    // Array of user IDs to fetch
  role?: string;          // Filter by role
}
```

**Response:**
```typescript
{
  status: "1",
  message: "Lấy danh sách thành công",
  data: {
    items: [
      {
        id: 123;
        full_name: "Nguyễn Văn A";
        username: "nguyenvana";
        email: "email@example.com";
        phone: "0912345678";
        avatar_url?: string;
        role: "Admin";
        role_display: "Quản trị viên";
      }
    ]
  }
}
```

**TypeScript Definition:**
```typescript
interface UserMinimal {
  id: number;
  full_name: string;
  username: string;
  email?: string;
  phone?: string;
  avatar_url?: string;
  role: string;
  role_display: string;
}

interface UsersMinimalResponse {
  items: UserMinimal[];
}
```

**Use Case:** Display creator, updater names in list/detail

---

## 🔶 Priority 2 - Important APIs (Tuần tới)

### 6. Bulk Update Status

**Mô tả:** Cập nhật status hàng loạt cho nhiều leads

**Endpoint:** `POST /api_agent/bulk_update_consultation_sell_status`

**Body Parameters:**
```typescript
{
  ids: number[];              // Array of consultation_sell IDs
  demand_status: string;      // new, pending, consulting, closed
  reason?: string;            // Lý do (optional)
}
```

**Response:**
```typescript
{
  status: "1",
  message: "Cập nhật thành công X leads",
  data: {
    updated_count: 15;        // Số lượng đã update
    failed_ids: number[];      // IDs bị lỗi (nếu có)
    errors: {
      [id: string]: string;    // Error message per ID
    }
  }
}
```

**TypeScript Definition:**
```typescript
interface BulkUpdateStatusPayload {
  ids: number[];
  demand_status: ConsultationSellStatus;
  reason?: string;
}

interface BulkUpdateStatusResponse {
  updated_count: number;
  failed_ids: number[];
  errors: Record<number, string>;
}
```

**Use Case:** Bulk actions from list page

---

### 7. Bulk Assign Listing Manager

**Mô tả:** Gán listing manager hàng loạt

**Endpoint:** `POST /api_agent/bulk_assign_listing_manager`

**Body Parameters:**
```typescript
{
  ids: number[];                    // Array of consultation_sell IDs
  listing_manager_id: number;       // ID của listing manager được gán
  send_notification?: boolean;      // Gửi push notify (default: true)
}
```

**Response:**
```typescript
{
  status: "1",
  message: "Đã giao X leads cho listing manager",
  data: {
    assigned_count: 10;
    failed_ids: number[];
    errors: Record<number, string>;
  }
}
```

**TypeScript Definition:**
```typescript
interface BulkAssignPayload {
  ids: number[];
  listing_manager_id: number;
  send_notification?: boolean;
}

interface BulkAssignResponse {
  assigned_count: number;
  failed_ids: number[];
  errors: Record<number, string>;
}
```

**Use Case:** Bulk assign from list page

---

### 8. Bulk Delete (Soft Delete)

**Mô tả:** Xóa mềm hàng loạt

**Endpoint:** `POST /api_agent/bulk_delete_consultation_sell`

**Body Parameters:**
```typescript
{
  ids: number[];           // Array of consultation_sell IDs
  reason?: string;         // Lý do xóa (optional)
}
```

**Response:**
```typescript
{
  status: "1",
  message: "Đã xóa X leads",
  data: {
    deleted_count: 5;
    failed_ids: number[];
    errors: Record<number, string>;
  }
}
```

**TypeScript Definition:**
```typescript
interface BulkDeletePayload {
  ids: number[];
  reason?: string;
}

interface BulkDeleteResponse {
  deleted_count: number;
  failed_ids: number[];
  errors: Record<number, string>;
}
```

**Use Case:** Bulk delete from list page

---

### 9. Get Consultation Sell Tags (Assigned)

**Mô tả:** Lấy tags đã gán cho một consultation_sell (đã có API list_tags nhưng cần API để lấy tags của entity cụ thể)

**Endpoint:** `GET /api_agent/get_consultation_sell_tags`

**Query Parameters:**
```typescript
{
  id: number;    // consultation_sell ID (required)
}
```

**Response:**
```typescript
{
  status: "1",
  message: "Lấy tags thành công",
  data: {
    tags: [
      {
        id: 69;
        name: "VIP";
        color: "#FEE4C4";          // Hex color
        category_id: 1;
        category_name: "Độ ưu tiên";
        assigned_at: "2026-05-15T08:00:00";
        assigned_by: {
          id: 123;
          full_name: "Nguyễn Văn A";
        }
      }
    ]
  }
}
```

**TypeScript Definition:**
```typescript
interface AssignedTag {
  id: number;
  name: string;
  color: string;
  category_id: number;
  category_name: string;
  assigned_at: string;
  assigned_by: {
    id: number;
    full_name: string;
  };
}

interface ConsultationSellTagsResponse {
  tags: AssignedTag[];
}
```

**Use Case:** Display tags in detail page, tag picker

---

### 10. Export Consultation Sell to Excel

**Mô tả:** Xuất danh sách nhu cầu bán ra file Excel

**Endpoint:** `GET /api_agent/export_consultation_sell_excel`

**Query Parameters:**
```typescript
{
  demand_status?: string;      // Filter by status
  office_id?: number;          // Filter by office
  listing_manager_id?: number;  // Filter by listing manager
  city_id?: string;            // Filter by city
  district_id?: string;        // Filter by district
  start_date?: string;         // Filter from date
  end_date?: string;           // Filter to date
  search?: string;             // Search keyword
  // ... same as list endpoint
}
```

**Response:**
```typescript
// Response headers:
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
Content-Disposition: attachment; filename="consultation_sell_20260516.xlsx"

// Body: Excel file binary
```

**TypeScript Definition:**
```typescript
// Frontend sẽ download file trực tiếp từ URL
interface ExportExcelParams {
  demand_status?: string;
  office_id?: number;
  listing_manager_id?: number;
  city_id?: string;
  district_id?: string;
  start_date?: string;
  end_date?: string;
  search?: string;
  // ... other list params
}

// Usage:
// window.open(`/api_agent/export_consultation_sell_excel?${queryString}`)
```

**Use Case:** Export Excel button on list page

---

## 🔷 Priority 3 - Nice to Have (Tương lai)

### 11. Get Consultation Sell Statistics

**Mô tả:** Lấy thống kê tổng quan cho dashboard

**Endpoint:** `GET /api_agent/get_consultation_sell_stats`

**Query Parameters:**
```typescript
{
  start_date?: string;  // ISO 8601 (optional, default 30 ngày gần nhất)
  end_date?: string;    // ISO 8601 (optional)
  office_id?: number;   // Filter by office
}
```

**Response:**
```typescript
{
  status: "1",
  message: "Lấy thống kê thành công",
  data: {
    period: {
      start_date: "2026-04-16";
      end_date: "2026-05-16";
    };
    
    overview: {
      total_leads: 312;          // Tổng số leads
      new_leads: 45;              // Leads mới
      active_leads: 201;          // Leads đang xử lý
      closed_leads: 66;           // Leads đã đóng
    };
    
    conversion: {
      conversion_rate: 21.2;     // Tỷ lệ chốt (%)
      avg_cycle_time: 14;         // TB thời gian chốt (ngày)
      top_performers: [           // Top 5 listing managers
        {
          id: 789;
          full_name: "Nguyễn Văn A";
          closed_count: 23;
          success_rate: 78.5;
        }
      ];
    };
    
    by_source: [
      { source: "Website"; count: 120; percentage: 38.5 },
      { source: "Facebook"; count: 89; percentage: 28.5 },
      { source: "CTV"; count: 65; percentage: 20.8 },
      { source: "App Agent"; count: 38; percentage: 12.2 }
    ];
    
    by_property_type: [
      { property_type: "Chung cư"; count: 145; percentage: 46.5 },
      { property_type: "Nhà phố"; count: 89; percentage: 28.5 },
      { property_type: "Đất nền"; count: 78; percentage: 25.0 }
    ];
  }
}
```

**TypeScript Definition:**
```typescript
interface StatsPeriod {
  start_date: string;
  end_date: string;
}

interface StatsOverview {
  total_leads: number;
  new_leads: number;
  active_leads: number;
  closed_leads: number;
}

interface StatsConversion {
  conversion_rate: number;
  avg_cycle_time: number;
  top_performers: Array<{
    id: number;
    full_name: string;
    closed_count: number;
    success_rate: number;
  }>;
}

interface StatsBreakdown {
  source: string;
  count: number;
  percentage: number;
}

interface ConsultationSellStatsResponse {
  period: StatsPeriod;
  overview: StatsOverview;
  conversion: StatsConversion;
  by_source: StatsBreakdown[];
  by_property_type: StatsBreakdown[];
}
```

**Use Case:** Dashboard stats strip, analytics page

---

### 12. Get Duplicate Leads Detection

**Mô tả:** Tìm leads trùng (cùng SĐT) khi tạo mới

**Endpoint:** `GET /api_agent/check_duplicate_consultation_sell`

**Query Parameters:**
```typescript
{
  customer_phone: string;    // SĐT khách hàng (required)
  exclude_id?: number;       // Exclude current ID khi edit
}
```

**Response:**
```typescript
{
  status: "1",
  message: "Kiểm tra trùng lặp",
  data: {
    is_duplicate: true;
    duplicates: [
      {
        id: 3215;
        demand_code: "CS-20260514-0001";
        customer_name: "Chị Lan";
        customer_phone: "098.222.7788";
        demand_status: "waiting_assign";
        created_at: "2026-05-14T15:25:00";
        days_ago: 2;
      }
    ]
  }
}
```

**TypeScript Definition:**
```typescript
interface DuplicateLead {
  id: number;
  demand_code: string;
  customer_name: string;
  customer_phone: string;
  demand_status: ConsultationSellStatus;
  created_at: string;
  days_ago: number;
}

interface CheckDuplicateResponse {
  is_duplicate: boolean;
  duplicates: DuplicateLead[];
}
```

**Use Case:** Duplicate warning when creating/editing lead

---

## 📝 Tóm Tắt

### APIs Cần Thiết (12 endpoints)

| Priority | Endpoint | Mục đích | Độ khẩn cấp |
|----------|----------|----------|-------------|
| 🔥 P1 | `GET /api_agent/get_listing_managers` | Populate dropdown | **Ngay** |
| 🔥 P1 | `GET /api_agent/get_consultation_sell_status_counts` | Status tabs counts | **Ngay** |
| 🔥 P1 | `GET /api_agent/get_property_types` | Property type mapping | **Ngay** |
| 🔥 P1 | `GET /api_agent/get_offices` | Office mapping | **Ngay** |
| 🔥 P1 | `GET /api_agent/get_users_minimal` | User mapping | **Ngay** |
| 🔶 P2 | `POST /api_agent/bulk_update_consultation_sell_status` | Bulk status update | Tuần tới |
| 🔶 P2 | `POST /api_agent/bulk_assign_listing_manager` | Bulk assign | Tuần tới |
| 🔶 P2 | `POST /api_agent/bulk_delete_consultation_sell` | Bulk delete | Tuần tới |
| 🔶 P2 | `GET /api_agent/get_consultation_sell_tags` | Get assigned tags | Tuần tới |
| 🔶 P2 | `GET /api_agent/export_consultation_sell_excel` | Export Excel | Tuần tới |
| 🔷 P3 | `GET /api_agent/get_consultation_sell_stats` | Dashboard stats | Tương lai |
| 🔷 P3 | `GET /api_agent/check_duplicate_consultation_sell` | Duplicate check | Tương lai |

### TypeScript Types File

Tất cả TypeScript interfaces sẽ được lưu trong:
```
src/types/consultation-sell-api.ts
```

---

## 🎯 Implementation Priority

### Sprint 1 (Week 1) - Critical Data
1. `get_listing_managers` - Wire Assign Broker Modal
2. `get_consultation_sell_status_counts` - Wire Status Tabs
3. `get_property_types` - Improve adapter mapping
4. `get_offices` - Improve adapter mapping
5. `get_users_minimal` - Improve adapter mapping

### Sprint 2 (Week 2) - Bulk Operations
6. `bulk_update_consultation_sell_status` - Bulk status change
7. `bulk_assign_listing_manager` - Bulk assign
8. `bulk_delete_consultation_sell` - Bulk delete
9. `get_consultation_sell_tags` - Tag management
10. `export_consultation_sell_excel` - Export feature

### Sprint 3 (Week 3+) - Advanced Features
11. `get_consultation_sell_stats` - Dashboard/analytics
12. `check_duplicate_consultation_sell` - Duplicate prevention

---

**Liên hệ:** Frontend Team  
**Ngày yêu cầu:** 2026-05-16  
**Expected timeline:** Sprint 1 trong tuần này, Sprint 2 tuần tới

---

<a id="docs-consultation-sell-api-md"></a>

## docs/consultation_sell_api.md

# Consultation Sell (Nhu cầu Bán) - API Documentation

## 📋 Tổng quan

**Consultation Sell** là module quản lý nhu cầu bán BĐS từ CTV/Customer.

### Workflow tổng quát:

```
┌─────────────────┐
│  CTV/Customer   │
│  Tạo nhu cầu    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Giao Đầu chủ    │  (assign_listing_manager)
│ - Xác thực BĐS  │
│ - Tạo tin đăng  │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────────────┐
│  Thực hiện công việc                        │
│  1. Tạo tin đăng (real_estate)               │
│  2. Xác thực BĐS (real_estate_salesman)      │
│  3. Tạo hợp đồng với chủ nhà (contract)      │
└─────────────────────────────────────────────┘
```

---

## 🗄️ Cấu trúc Database

### 1. `consultation_sell` - Bảng nhu cầu bán

```python
consultation_sell
├── id (PK)
├── demand_code              # Mã nhu cầu: NCB-1, NCB-2, NCB-100...
├── demand_status            # Trạng thái: new, pending, consulting, closed
│
├── customer_id (FK)         # → customer (chủ nhà)
├── property_type_id (FK)    # → property_type (Loại BĐS)
├── transaction_type_id (FK) # → transaction_type (1=Bán, 2=Cho thuê)
├── area                     # Diện tích (m²)
├── price                    # Giá BĐS
│
├── city_id                  # Tỉnh/Thành (code)
├── district_id              # Quận/Huyện (code)
├── ward_id                  # Phường/Xã (code)
├── address                  # Địa chỉ cụ thể
├── full_address             # Địa chỉ đầy đủ
├── address_tier             # Cấp địa chỉ: 2=Tỉnh/Huyện, 3=Tỉnh/Huyện/Xã (default=3)
│
├── house_direction          # Hướng nhà: Đông, Tây, Nam, Bắc...
├── legal_document           # Pháp lý: Sổ hồng, Sổ đỏ...
├── legal_status             # Tình trạng pháp lý
│
├── bedrooms                 # Số phòng ngủ
├── bathrooms                # Số phòng tắm
├── floors                   # Số tầng
├── note                     # Ghi chú
│
├── lead_source              # Nguồn: Website, Facebook, Zalo, CTV, App, Tongkho, Khác
│   # Python field: lead_source
│   # Database column: source_type (vì source là reserved keyword)
│   # API request/response: source
├── source_detail            # Nguồn chi tiết
│
├── office_id (FK)           # → post_office (Văn phòng quản lý)
├── salesman_support_id (FK) # → salesman (MB Chăm sóc - Người phụ trách KH)
├── listing_manager_id (FK)  # → salesman (Listing Manager - Đầu chủ xác thực)
│
├── real_estate_id (FK)      # → real_estate (BĐS được tạo)
├── real_estate_salesman_id (FK) # → real_estate_salesman (Listing BĐS)
│
├── tag_ids                  # Danh sách tags (list:integer)
│
└── audit trail
    ├── created_on, created_by
    ├── updated_on, updated_by
    └── aactive
```

### 2. `real_estate_comment` - Bảng comment/hoạt động (reuse)

```python
real_estate_comment
├── id (PK)
├── tablename                # Tên bảng: 'consultation_sell', 'real_estate', 'work', ...
├── table_id                 # ID bản ghi trong bảng tablename
├── user_id (FK)             # → auth_user (Người viết)
│
├── content_comment          # Nội dung comment
├── comment_type            # Loại: comment, note, status_update, attachment, mention
├── reply_to_comment_id (FK) # Phản hồi comment nào (self-reference)
├── thread_level             # Cấp độ thread: 0=gốc, 1=reply level 1...
│
├── is_private               # Ghi chú riêng tư
├── visibility               # public, private, team, admin_only
│
├── attachments              # File đính kèm (JSON)
├── mentioned_users          # Danh sách user được mention
│
├── is_edited, edit_count
├── is_deleted, is_pinned
│
├── created_at, updated_at, deleted_at
├── created_by, updated_by   # Người tạo/cập nhật
```

**Lưu ý**: `real_estate_comment` được dùng chung cho nhiều bảng:
- `tablename = 'consultation_sell'` → Comment cho nhu cầu bán
- `tablename = 'real_estate'` → Comment cho BĐS
- `tablename = 'work'` → Comment cho công việc

---

## 🔄 Trạng thái & Workflow

### Demand Status (Trạng thái nhu cầu)

| Status | Mô tả | Chuyển từ | Chuyển sang |
|--------|-------|----------|------------|
| `new` | Mới tạo | - | `consulting` |
| `consulting` | Đang tư vấn (Đã giao Đầu chủ) | `new` | `closed` |
| `closed` | Hoàn thành | `consulting` | - |

---

## 🔌 API Endpoints

### CRUD Operations

#### 1. Danh sách nhu cầu bán

```
GET /api_agent/list_consultation_sell

Query Parameters:
  - demand_status: string (optional)  # new, pending, consulting, closed
  - office_id: int (optional)
  - listing_manager_id: int (optional)
  - property_type_id: int (optional)
  - city_id: string (optional)
  - district_id: string (optional)
  - source: string (optional)         # Nguồn lead
  - start_date: string (optional)     # Ngày bắt đầu (YYYY-MM-DD)
  - end_date: string (optional)       # Ngày kết thúc (YYYY-MM-DD)
  - search: string (optional)         # Tìm theo tên KH, SĐT, mã
  - tag_id: int or int[] (optional)   # Filter theo tag ID
  - or_and: string (optional)         # Logic kết hợp tag: 'or' (có ít nhất 1), 'and' (có tất cả), 'not' (không có). Default: 'or'
  - page: int (default: 1)
  - limit: int (default: 20)          # Số item/trang
  - sort_by: string (default: created_on)
  - sort_order: string (default: DESC)

Response:
{
  "status": "1",
  "message": "Lấy danh sách thành công",
  "data": {
    "items": [
      {
        "id": 456,
        "demand_code": "NCB-1",
        "demand_status": "new",
        "customer_id": 123,
        "customer_name": "Nguyễn Văn A",
        "customer_phone": "0912345678",
        "property_type_id": 5,
        "area": 95.5,
        "price": 4500000000,
        "city_id": "01",
        "city_name": "Hà Nội",
        "district_id": "001",
        "district_name": "Quận Ba Đình",
        "ward_id": "00001",
        "ward_name": "Phường Phúc Xá",
        "address": "123 Cầu Giấy",
        "full_address": "123 Cầu Giấy, Phường Phúc Xá, Quận Ba Đình, Hà Nội",
        "address_tier": 3,
        "house_direction": "Nam",
        "legal_document": "Sổ hồng",
        "bedrooms": 3,
        "bathrooms": 2,
        "floors": 5,
        "note": "Chính chủ",
        "source": "Website",
        "office_id": 1,
        "office_name": "Văn phòng TP.HCM",
        "office_code": "VN-HCM",
        "salesman_support_id": 100,
        "user_support": {
          "id": 100,
          "auth_user_id": 50,
          "name": "Trần Văn B",
          "name_code": "TVB",
          "phone": "0909876543",
          "email": "tranvanb@example.com",
          "img_url": "https://example.com/avatar.jpg",
          "created_on": "15/01/2026",
          "status": 2,
          "contact_facebook": "facebook.com/tranvanb"
        },
        "listing_manager_id": 200,
        "listing_manager": {
          "id": 200,
          "auth_user_id": 80,
          "name": "Lê Thị C",
          "name_code": "LTC",
          "phone": "0912345678",
          "email": "lethic@example.com",
          "img_url": "https://example.com/avatar2.jpg",
          "created_on": "10/02/2026",
          "status": 3,
          "contact_facebook": "facebook.com/lethic"
        },
        "real_estate_id": null,
        "real_estate_salesman_id": null,
        "tag_ids": [],
        "tags": [                        # Enriched từ entity_tags
          {
            "tag_id": 10,
            "tag_name": "Khách tiềm năng",
            "tag_color": "#28a745",
            "category_id": 2,
            "category_name": "Trạng thái"
          }
        ],
        "created_on": "2026-05-14T08:00:00"
      }
    ],
    "total": 100,
    "page": 1,
    "limit": 20,
    "has_more": true
  }
}
```

#### 2. Chi tiết nhu cầu bán

```
GET /api_agent/get_consultation_sell

Query Parameters:
  - id: int (required)  # ID consultation_sell

Response:
{
  "status": "1",
  "message": "Lấy chi tiết thành công",
  "data": {
    "id": 456,
    "demand_code": "NCB-2",
    "demand_status": "consulting",
    "created_on": "2026-05-15T08:00:00",
    "source": "Website",
    "source_detail": "Form đăng tin trên website",
    "note": "Chính chủ, cho phép xem bất cứ lúc nào",

    "customer": {
      "id": 123,
      "name": "Nguyễn Văn A",
      "phone": "0912345678",
      "email": "email@example.com",
      "address": "Địa chỉ khách hàng"
    },

    "created_by": {
      "id": 861,
      "name": "Nguyễn Admin"
    },

    "user_support": {
      "id": 100,
      "auth_user_id": 50,
      "name": "Trần Văn B",
      "name_code": "TVB",
      "phone": "0909876543",
      "email": "tranvanb@example.com",
      "img_url": "https://example.com/avatar.jpg",
      "created_on": "15/01/2026",
      "status": 2,
      "contact_facebook": "facebook.com/tranvanb"
    },

    "listing_manager": {
      "id": 200,
      "auth_user_id": 80,
      "name": "Lê Thị C",
      "name_code": "LTC",
      "phone": "0912345678",
      "email": "lethic@example.com",
      "img_url": "https://example.com/avatar2.jpg",
      "created_on": "10/02/2026",
      "status": 3,
      "contact_facebook": "facebook.com/lethic"
    },

    "verifying_real_estate_salesman": {
      "real_estate_salesman_id": 2000,
      "real_estate_id": 1000,
      "real_estate_title": "Chung cư Cầu Giấy Plaza",
      "real_estate_code": "CGC-2024-001",
      "verification_status": 4,
      "verification_name": "Chờ gán",
      "verification_color": "#fff3cd"
    },

    "real_estate": {
      "id": 1000,
      "title": "Chung cư Cầu Giấy Plaza",
      "real_estate_code": "CGC-2024-001",
      "area": 95.5,
      "price": 4500000000,
      "price_description": "4.5 tỷ",
      "bedrooms": 3,
      "bathrooms": 2,
      "images": ["image1.jpg", "image2.jpg"],
      "main_image": "main.jpg"
    },

    "contract": {
      "contract_code": "001/2025/VP01",
      "status": 2,
      "status_name": "Chờ diễn ra",
      "office_name": "Văn phòng Hà Nội"
    },

    "city_name": "Hà Nội",
    "district_name": "Quận Ba Đình",
    "ward_name": "Phường Phúc Xá",
    "office_name": "Văn phòng TP.HCM",
    "office_code": "VN-HCM"
  }
}
```

**Enriched Data:**

Phản hồi chi tiết bao gồm các thông tin mở rộng:

1. **Location Enrichment** - Tên địa điểm từ ID:
   - `city_name` - Tên tỉnh/thành từ `city_id` (bảng `locations`)
   - `district_name` - Tên quận/huyện từ `district_id`
   - `ward_name` - Tên phường/xã từ `ward_id`
   - `full_address` - Địa chỉ đầy đủ: `address, ward_name, district_name, city_name`

2. **Office Enrichment** - Thông tin văn phòng:
   - `office_name` - Tên văn phòng từ `office_id` (bảng `post_office`)
   - `office_code` - Mã văn phòng

3. **Property Type Enrichment** - Thông tin loại BĐS:
   - `property_type_name` - Tên loại BĐS từ `property_type_id` (bảng `property_type`)

4. **Tag Enrichment** - Tags được gán cho nhu cầu bán:
   - `tags` - Danh sách tags từ `entity_tags` table, mỗi tag bao gồm:
     - `tag_id` - ID tag
     - `tag_name` - Tên tag
     - `tag_color` - Màu sắc hiển thị
     - `category_id` - ID danh mục tag
     - `category_name` - Tên danh mục tag
     - `group_id` - ID nhóm tag
     - `group_name` - Tên nhóm tag
     - `assigned_at` - Thời gian gán tag

5. **Personnel Information** - Thông tin nhân sự:
   - `user_support` - Salesman hỗ trợ từ `salesman_support_id`
   - `listing_manager` - Đầu chủ từ `listing_manager_id`
   - `created_by` - Người tạo từ `created_by` (chỉ trong detail view)

   Salesman info bao gồm:
   - `id`, `auth_user_id`, `name`, `name_code`, `phone`, `email`
   - `img_url` - Ảnh đại diện
   - `created_on`, `status`, `contact_facebook`

   **Lưu ý**: `list_consultation_sell` chỉ trả `created_by` là ID, `get_consultation_sell` trả object đầy đủ.

6. **Verification Info** - Thông tin xác thực BĐS:
   - `verifying_real_estate_salesman` - Thông tin xác thực từ `real_estate_salesman`
     - `real_estate_salesman_id` - ID bản ghi real_estate_salesman
     - `real_estate_id` - ID BĐS
     - `real_estate_title` - Tiêu đề BĐS
     - `real_estate_code` - Mã BĐS
     - `verification_status` - Mã trạng thái xác thực (0-5)
     - `verification_name` - Tên trạng thái xác thực
     - `verification_color` - Màu hiển thị (hex color)
   - Mapping trạng thái (theo property_verification.html):
     | Status | Tên | Màu thực tế | Dòng trong file |
     |--------|-----|------------|----------------|
     | `0` | Chưa thiết lập | `#6c757d` (gray) | - |
     | `1` | Chờ duyệt | `#ffc107` (yellow) | 1937 |
     | `2` | Đã duyệt | `#007bff` (blue) | 1662 |
     | `3` | Từ chối | `#EF4444` (red) | 1355, 1405 |
     | `4` | Chờ gán | `#fff3cd` (light yellow) | 287-292 |
     | `5` | Chờ xác nhận | `#0dcaf0` (cyan) | 1459, 1801 |
   - Chỉ hiển thị khi `real_estate_salesman_id` có giá trị và `created_verification_at != null`

7. **Real Estate Info** - Thông tin BĐS liên kết:
   - `real_estate` - Chi tiết BĐS từ `real_estate_id`
     - `id`, `title`, `real_estate_code`
     - `area`, `price`, `price_description`
     - `bedrooms`, `bathrooms`
     - `images`, `main_image`

8. **Contract Info** - Thông tin hợp đồng môi giới:
   - `contract` - Thông tin hợp đồng từ `real_estate_salesman_id`
     - `contract_code` - Mã hợp đồng
     - `status` - Trạng thái hợp đồng (1-6)
     - `status_name` - Tên trạng thái hợp đồng
     - `office_name` - Tên văn phòng (Bên A)
   - Mapping trạng thái hợp đồng:
     | Status | Tên | Màu |
     |--------|-----|-----|
     | `1` | Chờ duyệt | `#ffc107` (yellow) |
     | `2` | Chờ diễn ra | `#17a2b8` (info) |
     | `3` | Chờ xác nhận | `#fd7e14` (orange) |
     | `4` | Thành công | `#28a745` (green) |
     | `5` | Đã hủy | `#6c757d` (gray) |
     | `6` | Từ chối | `#dc3545` (red) |
   - Chỉ hiển thị khi `real_estate_salesman_id` có giá trị và đã có contract trong bảng `contract`

#### 3. Tạo nhu cầu bán

```
POST /api_agent/create_consultation_sell

Body Parameters (form-data or JSON):
  - customer_id: int (required)
  - property_type_id: int (required)
  - area: float (optional)
  - price: bigint (optional)           # Giá BĐS
  - city_id: string (optional)
  - district_id: string (optional)
  - ward_id: string (optional)
  - address: string (optional)
  - full_address: string (optional)
  - address_tier: int (optional)       # Cấp địa chỉ: 2 hoặc 3 (default=3, auto-calculate)
  - house_direction: string (optional)
  - legal_document: string (optional)
  - legal_status: string (optional)
  - bedrooms: int (optional)
  - bathrooms: int (optional)
  - floors: int (optional)
  - note: string (optional)
  - source: string (optional)         # API nhận "source"
  - source_detail: string (optional)
  - office_id: int (optional)

Response:
{
  "status": "1",
  "message": "Tạo nhu cầu bán thành công",
  "data": {
    "id": 456,
    "demand_code": "NCB-456"
  }
}
```

**Lưu ý về field `source`:**
- API Request: `source` (string)
- Python Code: `lead_source`
- Database Column: `source_type` (vì `source` là reserved SQL keyword)
- API Response: `source` (string)

#### 4. Tạo nhiều nhu cầu bán (Bulk Create)

```
POST /api_agent/bulk_create_consultation_sell

Content-Type: application/json

Body Parameters (JSON array):
  [
    {
      "customer_id": 123,
      "property_type_id": 1,
      "area": 50.5,
      "price": 2000000000,
      "city_id": "01",
      "district_id": "001",
      "ward_id": "00001",
      "address": "Số 1 Đường A",
      "note": "Ghi chú",
      "source": "Website"
    },
    {
      "customer_id": 124,
      "property_type_id": 2,
      "area": 75.0,
      "price": 5000000000,
      "city_id": "01",
      "district_id": "002",
      "address": "Số 2 Đường B",
      "source": "Facebook"
    }
  ]

Response (Success - All created):
{
  "status": "1",
  "message": "Đã tạo 2 nhu cầu bán thành công",
  "data": {
    "success": true,
    "created_count": 2,
    "created_ids": [1001, 1002],
    "failed_count": 0,
    "errors": []
  }
}

Response (Partial Success):
{
  "status": "1",
  "message": "Đã tạo 1/2 nhu cầu bán thành công",
  "data": {
    "success": true,
    "created_count": 1,
    "created_ids": [1001],
    "failed_count": 1,
    "errors": [
      {
        "index": 1,
        "error": "Thiếu property_type_id"
      }
    ]
  }
}
```

**Validation:**
- Max 100 records per batch
- Each record requires: `customer_id` or `owner_name`, `property_type_id`
- Individual record errors don't affect other records
- Transaction commits only after all records processed

#### 5. Cập nhật nhu cầu bán

```
POST /api_agent/update_consultation_sell

Query Parameters:
  - id: int (required)

Body Parameters:
  // Same as create (all optional)
  - source: string (optional)  # Sẽ được map thành lead_source

Response:
{
  "status": "1",
  "message": "Cập nhật thành công",
  "data": {
    "id": 456
  }
}
```

#### 6. Xóa nhu cầu bán (Soft Delete)

```
POST /api_agent/delete_consultation_sell

Body Parameters:
  - id: int (required)

Response:
{
  "status": "1",
  "message": "Xóa thành công",
  "data": {
    "id": 456
  }
}
```

**Lưu ý**: Đây là soft delete, chỉ set `aactive = False`

---

### Action APIs

#### 1. Giao Listing Manager (Đầu chủ)

```
POST /api_agent/consultation_sell_assign_listing_manager

Body Parameters:
  - id: int (required)                # ID consultation_sell
  - listing_manager_id: int (required) # ID salesman (Listing Manager)

Response:
{
  "status": "1",
  "message": "Giao Listing Manager thành công",
  "data": {
    "id": 456,
    "listing_manager_id": 789
  }
}
```

**Hành động:**
- Update `listing_manager_id`
- Chuyển `demand_status` → `consulting`
- Tạo system comment

#### 2. Link với BĐS đã tạo

```
POST /api_agent/consultation_sell_link_real_estate

Body Parameters:
  - id: int (required)                   # ID consultation_sell
  - real_estate_id: int (required)        # ID real_estate
  - real_estate_salesman_id: int (optional) # ID real_estate_salesman (listing)

Response:
{
  "status": "1",
  "message": "Link BĐS thành công",
  "data": {
    "id": 456,
    "real_estate_id": 1000,
    "real_estate_salesman_id": 7873828
  }
}
```

**Bug Fixed**: Parameter name corrected from `real_estate_salesman` → `real_estate_salesman_id`

---

### Activity APIs

#### 1. Lấy danh sách Hoạt động & Ghi chú

```
GET /api_agent/get_activities_consultation_sell

Query Parameters:
  - id: int (required)           # ID consultation_sell
  - activity_type: string (optional)  # appointment, deposit, note, call, all (default: all)
  - page: int (default: 1)
  - limit: int (default: 20)

Response:
{
  "status": "1",
  "message": "Lấy danh sách hoạt động thành công",
  "data": {
    "id": 456,
    "works": [
      {
        "work_id": 1,
        "work_name": "Hẹn gặp chủ nhà",
        "description": "Đi xem BĐS",
        "work_type": "appointment",
        "template_id": 4,
        "started_at": "2026-05-15T10:00:00",
        "status": "completed",
        "priority": 3,
        "created_at": "2026-05-15T08:00:00",
        "assigned_to": 123,
        "comments": [],
        "comment_count": 2
      },
      {
        "work_id": 2,
        "work_name": "Ghi chú",
        "description": "Khách hàng muốn giảm giá",
        "work_type": "note",
        "template_id": 42,
        "started_at": null,
        "status": "",
        "priority": 3,
        "created_at": "2026-05-15T09:00:00",
        "assigned_to": null,
        "comments": [],
        "comment_count": 0
      }
    ],
    "summary": {
      "total_works": 2,
      "total_comments": 2,
      "by_type": {
        "appointment": 1,
        "deposit": 0,
        "note": 1,
        "call": 0
      }
    },
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 2,
      "pages": 1
    }
  }
}
```

**Lưu ý:**
- Hoạt động được lưu trong `real_estate_work` với `tablename='consultation_sell'` và `table_id=id`
- Loại hoạt động (work_type):
  - `appointment`: Hẹn gặp (template_id=4)
  - `deposit`: Đặt cọc (template_id=29)
  - `note`: Ghi chú (template_id=42)
  - `call`: Gọi điện (template_id=43)

#### 2. Thêm Comment vào Công việc

```
POST /api_agent/add_work_comment_consultation_sell

Body Parameters:
  - work_id: int (required)         # ID công việc (real_estate_work.id)
  - content: string (required)      # Nội dung comment
  - comment_type: string (optional) # Loại comment (default: comment)
  - documents: array (optional)     # Danh sách document đính kèm

Response:
{
  "status": "1",
  "message": "Thêm bình luận thành công",
  "data": {
    "comment": {
      "id": 100,
      "tablename": "real_estate_work",
      "table_id": 1,
      "user_id": 2,
      "content_comment": "Đã hoàn thành",
      "comment_type": "comment",
      "created_at": "2026-05-15T11:00:00"
    }
  }
}
```

#### 3. Tạo Công việc mới (Lịch hẹn, Đặt cọc, Ghi chú)

```
POST /api_agent/create_work_consultation_sell

Body Parameters:
  - consultation_sell_id: int (required)  # ID nhu cầu bán
  - template_id: int (required)           # 4=Lịch hẹn, 29=Đặt cọc, 42=Ghi chú, 43=Gọi điện
  - name: string (optional)               # Tên công việc
  - description: string (optional)        # Mô tả/Ghi chú
  - started_at: string (optional)         # Thời gian (YYYY-MM-DDTHH:MM:SS)
  - location: string (optional)           # Địa điểm (cho Lịch hẹn)
  - assigned_to: int (optional)           # ID SaleOff phụ trách
  - priority: int (optional)              # 1=cao, 3=trung bình, 5=thấp
  - deposit_type: string (optional)       # thien_chi, coc_chet (cho Đặt cọc)
  - deposit_amount: int (optional)        # Số tiền đặt cọc (cho Đặt cọc)
  - real_estate_id: int (optional)        # BĐS ID (optional)
  - comment: string (optional)            # Comment ban đầu

Response:
{
  "status": "1",
  "message": "Tạo công việc thành công",
  "data": {
    "work_id": 1,
    "work": {
      "id": 1,
      "name": "Hẹn gặp chủ nhà",
      "description": "Đi xem BĐS",
      "template_id": 4,
      "tablename": "consultation_sell",
      "table_id": 456,
      "started_at": "2026-05-15T10:00:00",
      "status": "waiting",
      "priority": 3,
      "assigned_to": 123
    }
  }
}
```

**Loại công việc (template_id):**
- `4`: Lịch hẹn (Appointment)
- `29`: Đặt cọc (Deposit)
- `42`: Ghi chú (Note)
- `43`: Gọi điện (Call)

---

### Comment APIs (Direct)

#### 1. Lấy danh sách comments

```
GET /api_agent/consultation_sell_get_comments

Query Parameters:
  - id: int (required)           # ID consultation_sell
  - comment_type: string (optional)  # comment, note, status_update, attachment, mention

Response:
{
  "status": "1",
  "message": "Lấy danh sách thành công",
  "data": [
    {
      "id": 1,
      "consultation_sell_id": 456,
      "user_id": 2,
      "content_comment": "Lead được tạo",
      "comment_type": "note",
      "created_at": "2026-05-15T08:00:00"
    }
  ]
}
```

#### 2. Tạo comment mới

```
POST /api_agent/consultation_sell_create_comment

Body Parameters:
  - id: int (required)              # ID consultation_sell
  - content_comment: string (required)
  - comment_type: string (optional)  # default: comment
  - is_private: boolean (optional)
  - attachments: string (optional)   # JSON string

Response:
{
  "status": "1",
  "message": "Tạo comment thành công",
  "data": {
    "id": 100
  }
}
```

---

### Listing Manager APIs

#### 1. Lấy danh sách Listing Managers (Đầu chủ)

```
GET /api_agent/get_listing_manager

Query Parameters:
  - for_listing_manager: boolean (optional)  # Nếu=true, trả về format cho modal giao Đầu chủ
  - max_depth: int (optional)                # Độ sâu tối đa của cây (default: 10)
  - include_parents: boolean (optional)      # Có lấy cấp cha không (default: true)
  - max_parents: int (optional)              # Số cấp cha tối đa (default: 2)
  - limit: int (optional)                    # Số children tối đa mỗi level (default: 20)
  - offset: int (optional)                   # Offset cho pagination (default: 0)
  - sort_by_level: boolean (optional)        # Sắp xếp theo level giảm dần (default: true)

Response:
{
  "status": "1",
  "message": "Lấy danh sách Đầu chủ thành công",
  "data": {
    "tree_data": [
      {
        "id": 123,
        "name": "Nguyễn Mạnh Hùng",
        "name_code": "NMH",
        "title_code": "TVV",
        "title_name": "Tư vấn viên",
        "depth": 0,
        "is_listing_manager": true,
        "children": [...],
        "has_children": true
      }
    ],
    "flat_list": [...]
  }
}
```

**Phân quyền:**
- **Admin**: Xem TẤT CẢ listing managers
- **Admin VP (is_office_admin)**: Xem listing managers của văn phòng mình
- **TP (Trưởng phòng)**: Xem subtree của team mình
- **Khác**: Không có quyền

#### 2. Lấy danh sách Listing Managers nhóm theo Văn phòng

```
GET /api_agent/get_listing_managers_by_post_office

Response:
{
  "status": "1",
  "message": "Lấy danh sách Đầu chủ theo Văn phòng thành công (2 văn phòng)",
  "data": {
    "tree_data": [
      {
        "id": "po_1",
        "type": "post_office",
        "name": "VP. HOÀN KIẾM",
        "post_office_id": 1,
        "total_listing_managers": 3,
        "total_descendants": 21,
        "has_children": true,
        "children": [
          {
            "id": 123,
            "name": "Nguyễn Mạnh Hùng",
            "name_code": "NMH",
            "title_code": "TVV",
            "title_name": "Tư vấn viên",
            "depth": 0,
            "is_listing_manager": true,
            "children": [],
            "has_children": false
          }
        ]
      },
      {
        "id": "po_2",
        "type": "post_office",
        "name": "VP. TÂY HỒ",
        "post_office_id": 2,
        "total_listing_managers": 1,
        "total_descendants": 5,
        "has_children": true,
        "children": [...]
      }
    ],
    "flat_list": [
      {
        "id": 123,
        "name": "Nguyễn Mạnh Hùng",
        "post_office_id": 1,
        "post_office_name": "VP. HOÀN KIẾM",
        "is_listing_manager": true
      }
    ]
  }
}
```

**Cấu trúc dữ liệu:**
```
Văn phòng (Post Office)
  ├── VP. HOÀN KIẾM (3)
  │   ├── Nguyễn Mạnh Hùng (16)
  │   ├── Trần Quốc Tuấn (3)
  │   └── Nguyễn Thị Oanh (2)
  └── VP. TÂY HỒ (1)
      └── Vũ Thu Hương (1)
```

**Phân quyền:**
- **Admin**: Xem TẤT CẢ các văn phòng với listing managers
- **Admin VP (is_office_admin)**: Chỉ xem văn phòng của mình
- **Khác**: Không có quyền

---

### Tag APIs

#### 1. Lấy danh sách tags của nhu cầu bán

```
GET /api_agent/get_consultation_sell_tags

Query Parameters:
  - id: int (required)  # ID consultation_sell

Response:
{
  "status": 1,
  "message": "Lấy danh sách tag thành công",
  "data": {
    "tags": [
      {
        "id": 10,
        "name": "Khách tiềm năng",
        "color": "#28a745",
        "category_id": 2,
        "category_name": "Trạng thái",
        "group_id": 1,
        "group_name": "Trạng thái nhu cầu",
        "assigned_at": "2026-05-15T10:30:00"
      }
    ]
  }
}
```

#### 2. Lấy danh sách tag groups (để gán tag)

```
GET /api_agent/list_tags

Query Parameters:
  - category_code: string (optional)  # 'DEMAND_SELL' cho nhu cầu bán, 'DEMAND' cho nhu cầu mua. Default: 'DEMAND'
  - group_id: int (optional)
  - category_id: int (optional)
  - active_only: boolean (default: true)

Response:
{
  "success": true,
  "data": [
    {
      "group_id": 1,
      "group_name": "Trạng thái nhu cầu",
      "can_view": true,
      "can_edit": true,
      "selection_type": "single",
      "tags": [
        {
          "id": 10,
          "name": "Khách tiềm năng",
          "color": "#28a745",
          "category_id": 2
        }
      ]
    }
  ]
}
```

#### 3. Gán tags cho nhu cầu bán

```
POST /api_agent/list_tags

Body Parameters:
  - entity_type: string (required)  # 'consultation_sell'
  - entity_id: int (required)       # ID consultation_sell
  - entity_ids: int[] (optional)    # Batch update nhiều IDs
  - tag_ids: int[] (required)       # Danh sách tag ID để gán
  - replace: boolean (optional)     # True = thay thế tất cả, False = thêm vào. Default: false

Response:
{
  "success": true,
  "message": "Gán tag thành công",
  "data": {
    "assigned_count": 1,
    "entity_type": "consultation_sell",
    "tag_ids": [10, 15]
  }
}
```

#### 4. Lấy lịch sử thay đổi tag

```
GET /api_agent/get_entity_tag_history.json

Query Parameters:
  - entity_type: string (required)  # 'consultation_sell'
  - entity_id: int (required)       # ID consultation_sell
  - limit: int (default: 50)

Response:
{
  "success": true,
  "data": [
    {
      "id": 100,
      "entity_type": "consultation_sell",
      "entity_id": 456,
      "tag_id": 10,
      "tag_name": "Khách tiềm năng",
      "action": "assign",
      "user_id": 861,
      "user_name": "Nguyễn Admin",
      "created_at": "2026-05-15T10:30:00"
    }
  ],
  "message": "Lấy lịch sử tag thành công"
}
```

---

## 📊 Các loại Comment Type

| Type | Mô tả | Ví dụ |
|------|-------|-------|
| `comment` | Bình luận thường | "Khách hàng quan tâm thêm căn hộ" |
| `note` | Ghi chú | "Lead được tạo", "Đã phân công" |
| `status_update` | Cập nhật trạng thái | "Đã giao Listing Manager" |
| `attachment` | Đính kèm file | "Đã tải lên hình ảnh BĐS" |
| `mention` | Mention người khác | "@salesman_123 Vui lòng kiểm tra" |

---

## 🎯 Mã nhu cầu (Demand Code)

Format: `NCB-{max_id + 1}`

- `NCB` = Nhu Cầu Bán
- `{max_id + 1}` = ID tiếp theo trong bảng consultation_sell

Ví dụ:
- `NCB-1` - Nhu cầu bán đầu tiên
- `NCB-2` - Nhu cầu bán thứ 2
- `NCB-100` - Nhu cầu bán thứ 100

---

## 🎨 UI States & Transitions

### State Machine cho Demand Status

```
     ┌──────────────────┐
     │       NEW        │  ← Mới tạo
     └────────┬─────────┘
              │
              ▼ assign_listing_manager()
     ┌──────────────────┐
     │   CONSULTING     │  ← Đang tư vấn
     └────────┬─────────┘   (Đã giao Đầu chủ)
              │
              ├──→ Tạo tin đăng
              ├──→ Xác thực BĐS
              │
              ▼ Tạo hợp đồng
     ┌──────────────────┐
     │     CLOSED       │  ← Hoàn thành
     └──────────────────┘
```

---

## 📝 Ví dụ Flow hoàn chỉnh

### Scenario: CTV tạo nhu cầu bán → Chia VP → Phân công MB Chăm sóc → Giao Đầu chủ → Tạo BĐS

#### Step 1: CTV tạo nhu cầu bán

```bash
POST /api_agent/create_consultation_sell
{
  "customer_id": 123,
  "property_type_id": 5,
  "area": 95.5,
  "price": 4500000000,
  "city_id": "01",
  "district_id": "001",
  "ward_id": "00001",
  "address": "123 Cầu Giấy",
  "house_direction": "Nam",
  "legal_document": "Sổ hồng",
  "bedrooms": 3,
  "bathrooms": 2,
  "floors": 5,
  "note": "Chính chủ",
  "source": "Website"
}

# Response: { "id": 456, "demand_code": "NCB-456" }
```

#### Step 2: Admin giao Listing Manager (Đầu chủ)

```bash
POST /api_agent/consultation_sell_assign_listing_manager
{
  "id": 456,
  "listing_manager_id": 789
}
```

#### Step 3: Link với BĐS đã tạo

```bash
POST /api_agent/consultation_sell_link_real_estate
{
  "id": 456,
  "real_estate_id": 1000,
  "real_estate_salesman_id": 2000
}
```

---

## ⚠️ Lưu ý quan trọng

### 1. Field `source` Mapping

```
API Request/Response  →  Python Code     →  Database Column
     source           →  lead_source     →  source_type
```

- **API Request**: Gửi `"source": "Website"`
- **Python Code**: Nhận và xử lý thành `lead_source`
- **Database Column**: Lưu vào cột `source_type` (vì `source` là reserved SQL keyword)
- **API Response**: Trả về `"source": "Website"`

**Nguồn hợp lệ**: Website, Facebook, Zalo, CTV, App, Tongkho, Khác

### 2. Field `address_tier` - Cấp địa chỉ

```
address_tier = 3  nếu có ward_id (Tỉnh/Huyện/Xã - 3 cấp)
address_tier = 2  nếu không có ward_id (Tỉnh/Huyện - 2 cấp)
```

- **Tự động tính toán**: Hệ thống tự động tính `address_tier` dựa trên `ward_id`
- **Giá trị**: 2 hoặc 3
- **Mặc định**: 3
- **Khi update**: Nếu `ward_id` thay đổi, `address_tier` được tính lại tự động

Ví dụ:
```json
{
  "city_id": "01",
  "district_id": "001",
  "ward_id": "00001",
  "address_tier": 3  // Tự động tính
}
```

```json
{
  "city_id": "01",
  "district_id": "001",
  "ward_id": null hoặc "",
  "address_tier": 2  // Tự động tính
}
```

### 3. Auto-assign Office theo City
- Khi tạo nhu cầu bán, hệ thống check `city_id` vs `post_office.city`
- Nếu khớp → auto gán `consultation_sell.office_id`
- Nếu không khớp → `office_id = null`, cần chia về VP thủ công

### 4. Salesman Support lưu vào bảng salesman_support
- Không chỉ update `consultation_sell.salesman_support_id`
- Insert vào `salesman_support` table với:
  - `table_name`: 'consultation_sell'
  - `table_id`: consultation_sell.id

### 5. Comment & Work sử dụng real_estate_comment & real_estate_work
- Comment cho consultation_sell được lưu trong `real_estate_comment` table
- Sử dụng pattern `tablename` + `table_id`:
  - `tablename`: 'consultation_sell'
  - `table_id`: ID của consultation_sell

---

## 🔌 Danh sách API

### APIs Đã triển khai

| STT | Method | Endpoint | Mô tả |
|-----|--------|----------|-------|
| 1 | `GET` | `/api_agent/list_consultation_sell` | Danh sách nhu cầu bán |
| 2 | `GET` | `/api_agent/get_consultation_sell` | Chi tiết nhu cầu bán |
| 3 | `POST` | `/api_agent/create_consultation_sell` | Tạo nhu cầu bán mới |
| 4 | `POST` | `/api_agent/bulk_create_consultation_sell` | Tạo nhiều nhu cầu bán (bulk create) |
| 5 | `POST` | `/api_agent/update_consultation_sell` | Cập nhật nhu cầu bán |
| 6 | `POST` | `/api_agent/delete_consultation_sell` | Xóa nhu cầu bán (soft delete) |
| 7 | `POST` | `/api_agent/consultation_sell_assign_listing_manager` | Giao Listing Manager/Đầu chủ |
| 8 | `POST` | `/api_agent/consultation_sell_link_real_estate` | Link với BĐS đã tạo |
| 9 | `GET` | `/api_agent/get_activities_consultation_sell` | Lấy danh sách hoạt động & ghi chú |
| 10 | `POST` | `/api_agent/create_work_consultation_sell` | Tạo công việc (Lịch hẹn/Đặt cọc/Ghi chú) |
| 11 | `POST` | `/api_agent/add_work_comment_consultation_sell` | Thêm comment vào công việc |
| 12 | `GET` | `/api_agent/consultation_sell_get_comments` | Lấy danh sách comments |
| 13 | `POST` | `/api_agent/consultation_sell_create_comment` | Tạo comment mới |
| 14 | `GET` | `/api_agent/get_consultation_sell_tags` | Lấy danh sách tags của nhu cầu bán |
| 15 | `GET` | `/api_agent/list_tags` | Lấy danh sách tag groups (để gán tag) |
| 16 | `POST` | `/api_agent/list_tags` | Gán tags cho nhu cầu bán |
| 17 | `GET` | `/api_agent/get_entity_tag_history.json` | Lấy lịch sử thay đổi tag |
| 18 | `GET` | `/api_agent/get_consultation_sell_status_counts` | Thống kê số lượng theo trạng thái |
| 19 | `GET` | `/api_agent/get_listing_manager` | Lấy danh sách Listing Manager (cấu trúc cây) |
| 20 | `GET` | `/api_agent/get_listing_managers_by_post_office` | Lấy danh sách Listing Manager nhóm theo Văn phòng |

---

## 📞 Liên hệ

Nếu có thắc mắc, vui lòng liên hệ Backend Team.

---

<a id="docs-deployment-guide-md"></a>

## docs/deployment-guide.md

---
title: Deployment Guide — Tongkhobds Web Agent
type: deployment
last_synced: 2026-04-18
audience: ops + dev
---

# Deployment Guide

## Stack

- Runtime: Node.js 22-alpine (Docker multi-stage)
- Output: `next build` standalone (`output: 'standalone'` via `BUILD_STANDALONE=1`)
- Server: Next.js native `server.js`, port 3000
- User: non-root `nextjs` (uid 1001)
- Target: Coolify self-host, any Docker host works

## Environment variables

| Var | Scope | Required | Notes |
|-----|-------|----------|-------|
| `BACKEND_URL` | server | optional | Proxy target cho `/api/*`. Default theo `NODE_ENV`: dev → `https://devquanly.tongkhobds.com/tongkho`, prod → `https://quanly.tongkhobds.com/tongkho`. Set explicit khi cần override. |
| `GOOGLE_MAPS_API_KEY` | server | no | reserved for future SSR map calls |
| `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY` | client | recommended | without it, `/map` shows warning card |
| `NEXT_PUBLIC_APP_NAME` | client | no | display label |
| `NODE_ENV` | both | auto | set to `production` by Dockerfile |
| `PORT` | server | no | default 3000 |
| `HOSTNAME` | server | no | default `0.0.0.0` (required for Docker) |

Create `.env.production` for Coolify UI or pass via env var section.

## Local Docker verify

```bash
# Build
docker build -t tongkhobds-web-agent:local .

# Run
docker run --rm -d -p 3001:3000 \
  -e BACKEND_URL=https://quanly.tongkhobds.com/tongkho \
  -e NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=your_key \
  --name tkbds-test \
  tongkhobds-web-agent:local

# Health check
curl http://localhost:3001/api/health
# → {"status":"ok","uptime_ms":<n>,"version":"0.1.0"}

# Stop
docker stop tkbds-test
```

**Note:** `pnpm build` with `BUILD_STANDALONE=1` fails on Windows (symlink permission). Use Docker, WSL, or Linux CI — Linux filesystem handles it.

## Coolify setup

1. **New Resource → Dockerfile**, point to this repo.
2. **Build:** Dockerfile at repo root, build context `.`.
3. **Port:** container `3000` → HTTP. Enable HTTPS (Let's Encrypt auto).
4. **Health check:** `GET /api/health` every 30s, expect `200`. Coolify respects this for zero-downtime rollouts.
5. **Environment:** paste vars from table above.
6. **Persistent volumes:** none needed (stateless FE).
7. **Domain:** bind staging / prod domain; Coolify issues cert.
8. **Auto-deploy:** enable git webhook on `main` branch.

## Bundle budget

First-Load JS shared target **< 300 KB** gzipped. Monitor via:

```bash
pnpm build:analyze
```

Opens 3 HTMLs under `.next/analyze/` (client, nodejs, edge). Post-build table in console shows per-route size.

As of 2026-04-18: 102 KB shared, all routes under 210 KB. Re-measure after post-MVP additions (favorites dialogs, filter primitives, infinite scroll) — expected <300 KB still.

## Rollback

Coolify keeps last 3 image tags. Roll back via UI:

1. Deployments → pick previous tag → Redeploy.
2. Health check must pass on old tag before traffic cutover.

For manual rollback:

```bash
docker pull coolify-registry.internal/tongkhobds-web-agent:<prev-sha>
docker stop tkbds-prod && docker rm tkbds-prod
docker run -d ... <prev-sha>
```

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| Build fails with `EPERM symlink` on Windows | Local `BUILD_STANDALONE=1 pnpm build` outside Docker | Run build inside Docker; Linux FS has no restriction |
| `next build --turbopack` bundle > 300 KB | Turbopack prod still experimental | Use default `pnpm build` (webpack) |
| Container starts but `/api/health` 502 | `HOSTNAME` not `0.0.0.0` | Dockerfile sets it; override env if you pass custom `HOSTNAME` |
| All `/api/*` return 502 | `BACKEND_URL` unset or wrong | Check env injection in Coolify UI; proxy logs at container stdout |
| `/map` shows warning card | `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY` unset | Set both `NEXT_PUBLIC_*` and server `GOOGLE_MAPS_API_KEY` |
| Cookie `tkbds_token` missing after login | Server action `lib/auth/login-action.ts` failed to set cookie OR upstream `/sign_in.json` returned non-200 | Check proxy logs; verify `BACKEND_URL` reachable; cookie is set by FE server action (BE `Set-Cookie` is intentionally stripped in proxy) |

## E2E smoke after deploy

```bash
PLAYWRIGHT_BASE_URL=https://your-domain.com \
E2E_PHONE=<test_phone> \
E2E_PASSWORD=<test_pass> \
  pnpm test:e2e tests/e2e/auth-redirect.spec.ts tests/e2e/login.spec.ts
```

Those 2 specs are network-light (no writes to BE). Run against staging first.

**TODO** (post-MVP 2026-04-20): Consider adding `/bds` filter smoke + `/bds/favorites` happy path once post-MVP stabilizes.

## Unresolved

- Coolify registry URL + image tagging scheme — ops to confirm.
- CI/CD pipeline (GitHub Actions) — not set up, manual webhook deploy for now.
- Sentry / GA4 — deferred to phase 2.

---

<a id="docs-nhu-cau-fe-integration-work-consultation-md"></a>

## docs/nhu-cau/FE_INTEGRATION_WORK_CONSULTATION.md

# FE Integration: Work Consultation API

> **Yêu cầu integrate cho Frontend Dev**
> Module: BĐS phù hợp trong 1 Nhu cầu mua (consultation_interest)
> Last updated: 2026-05-19

## 📋 Tổng quan

Frontend tích hợp **2 endpoints + 1 master data**, dispatch theo `code` để xử lý 7 hành động tương ứng 7 nút trên UI:

| API | Method | Mục đích |
|---|---|---|
| `/api_agent/work_consultation` | POST | Dispatcher cho **7 action** + 2 thao tác hỗ trợ (comment, update_status) + remove_from_list |
| `/api_agent/activities_consultation` | GET | Lấy timeline hoạt động (work + comment) của 1 BĐS quan tâm |
| `/api_agent/get_not_suitable_reasons` | GET | Lấy danh sách 8 lý do "Không phù hợp" (master data) |

---

## 🔐 Auth

Tất cả API yêu cầu JWT:

```
Authorization: Bearer <JWT_TOKEN>
```

---

## 🎯 7 Nút UI + Mapping Code

| # | Nút UI | `code` | Validate field bắt buộc |
|---|---|---|---|
| 1 | 📞 Gọi đầu chủ | `call_owner` | `call_result` |
| 2 | ✈️ Gửi khách hàng | `send_customer` | `send_channel` |
| 3 | 📝 Ghi chú | `note` | `content` |
| 4 | 🔔 Nhắc xác thực | `request_verification` | (chỉ cần tablename + table_id) |
| 5 | 📅 Hẹn xem | `appointment` | `started_at` |
| 6 | 💰 Đặt cọc | `deposit` | `deposit_type`, `deposit_amount` |
| 7 | ⊘ Không phù hợp | `not_suitable` | (`reason_code` optional) |
| 7b | 🗑️ Bỏ khỏi list (menu phụ) | `remove_from_list` | (chỉ cần tablename + table_id) |

---

## 🧩 Common Request Fields

Mọi action đều cần 3 field cơ bản:

| Field | Type | Required | Mô tả |
|---|---|---|---|
| `tablename` | string | ✅ | Luôn = `consultation_interest` cho 7 action này |
| `table_id` | int | ✅ | `consultation_interest.id` (BĐS phù hợp trong nhu cầu) |
| `code` | string | ✅ | Mã action (xem bảng trên) |

Backend **tự động query** từ `consultation_interest` để inject các field liên quan:
- `consultation_id` ← `CI.consultation_id`
- `real_estate_id` ← `CI.real_estate_id`
- `transaction_id` ← `CI.real_estate_transaction_id`
- `owner_agent_id` ← `CI.salesman_id`

→ Mobile **không cần gửi** 4 field trên.

---

## 📦 Common Response Format

**Success (status=1):**
```json
{
  "status": 1,
  "message": "...",
  "data": {
    "work_id": 12345,
    "work_subtype": "<code>",
    "status": "<work_status>",
    ...
  }
}
```

**Error (status=0):**
```json
{
  "status": 0,
  "message": "<thông báo lỗi tiếng Việt>",
  "data": {}
}
```

---

# 🔵 1. Gọi đầu chủ (call_owner)

**View:** Modal "Gọi đầu chủ" — chọn 1 trong 4 kết quả + ghi chú trao đổi.

## Request
```
POST /api_agent/work_consultation
Content-Type: application/x-www-form-urlencoded
```

| Field | Type | Required | Giá trị | Mô tả |
|---|---|---|---|---|
| `tablename` | string | ✅ | `consultation_interest` | |
| `table_id` | int | ✅ | `<ci_id>` | |
| `code` | string | ✅ | `call_owner` | |
| `call_result` | string | ✅ | `connected` \| `no_answer` \| `busy` \| `rejected` | Kết quả cuộc gọi |
| `content` | text | ❌ | "Ghi chú trao đổi với đầu chủ..." | Nếu không nhập → dùng label kết quả |

## Mapping `call_result` → status + color

| `call_result` | `status` DB | `result_label` | `result_color` |
|---|---|---|---|
| `connected` | `completed` | Đã kết nối | `#10b981` 🟢 |
| `no_answer` | `no_show` | Không nghe máy | `#fbbf24` 🟡 |
| `busy` | `on_hold` | Máy bận | `#f97316` 🟠 |
| `rejected` | `cancelled` | Từ chối | `#ef4444` 🔴 |

## Response
```json
{
  "status": 1,
  "message": "Đã ghi nhận cuộc gọi đầu chủ",
  "data": {
    "work_id": 12345,
    "work_subtype": "call_owner",
    "status": "no_show",
    "call_result": "no_answer",
    "result_label": "Không nghe máy",
    "result_color": "#fbbf24",
    "work": { ... }
  }
}
```

## Curl
```bash
curl -X POST "$BASE/work_consultation" \
  -H "Authorization: Bearer $TOKEN" \
  --data-urlencode "tablename=consultation_interest" \
  --data-urlencode "table_id=222" \
  --data-urlencode "code=call_owner" \
  --data-urlencode "call_result=connected" \
  --data-urlencode "content=Đầu chủ xác nhận giá còn thương lượng được"
```

---

# 🟢 2. Gửi khách hàng (send_customer)

**View:** Modal "Gửi khách hàng" — chọn 1 trong 3 kênh + lời nhắn.

## Request
| Field | Type | Required | Giá trị |
|---|---|---|---|
| `tablename` | string | ✅ | `consultation_interest` |
| `table_id` | int | ✅ | `<ci_id>` |
| `code` | string | ✅ | `send_customer` |
| `send_channel` | string | ✅ | `zalo` \| `messenger` \| `app_tongkho` |
| `content` | text | ❌ | Lời nhắn gửi kèm |

## Mapping `send_channel` → label + color

| `send_channel` | `result_label` | `result_color` | `send_channel_icon` |
|---|---|---|---|
| `zalo` | Zalo | `#0068ff` 🔵 | `zalo` |
| `messenger` | Messenger | `#0084ff` 🔵 | `messenger` |
| `app_tongkho` | App Tổng Kho | `#10b981` 🟢 | `mobile` |

## Đặc biệt: Auto-snapshot recipient

Backend tự query `consultation.full_name` + `consultation.phone_number` và inject vào `description`:
```
[Zalo → tự hoàn - 0342790003] BĐS phù hợp ngân sách của anh/chị
```

## Response
```json
{
  "status": 1,
  "message": "Đã ghi nhận gửi khách hàng",
  "data": {
    "work_id": 12346,
    "work_subtype": "send_customer",
    "status": "completed",
    "send_channel": "zalo",
    "result_label": "Zalo",
    "result_color": "#0068ff",
    "work": { ... }
  }
}
```

---

# 🟡 3. Ghi chú (note)

**View:** Modal "Thêm ghi chú" — textarea + toggle visibility (public/internal).

## Request
| Field | Type | Required | Giá trị |
|---|---|---|---|
| `tablename` | string | ✅ | `consultation_interest` (hoặc `real_estate`, `customer`, `consultation`) |
| `table_id` | int | ✅ | ID tương ứng |
| `code` | string | ✅ | `note` |
| `content` | text | ✅ | Nội dung ghi chú |
| `visibility` | string | ❌ | `public` (default) \| `internal` |
| `attachments` | JSON array | ❌ | `[{"name":"file.jpg","url":"/upload/..."}]` |

## Đặc biệt
- ⚠️ **KHÔNG có status `completed`** — note dùng `status='pending'` (không có khái niệm hoàn thành)
- ✅ **Gửi notification** `NOTE_CREATED` cho team
- ❌ **KHÔNG tạo comment** trong DB — nội dung lưu vào `work.description`
- Name hiển thị: `"Ghi chú"` (public) hoặc `"Ghi chú nội bộ"` (internal)

## Response
```json
{
  "status": 1,
  "message": "Tạo ghi chú thành công",
  "data": {
    "work_id": 12347,
    "work_subtype": "note",
    "status": "pending",
    "notify_count": 3,
    "work": { ... }
  }
}
```

---

# 🟠 4. Nhắc xác thực (request_verification)

**View:** Action trực tiếp (không có modal phức tạp) — gửi notification cho đầu chủ BĐS xác nhận.

## Request
| Field | Type | Required | Giá trị |
|---|---|---|---|
| `tablename` | string | ✅ | `consultation_interest` |
| `table_id` | int | ✅ | `<ci_id>` |
| `code` | string | ✅ | `request_verification` |
| `content` | text | ❌ | Note kèm thông báo (default: "Vui lòng xác thực BĐS này") |

## Behavior
- Backend tự query `real_estate.owner_id` → tìm `auth_user.id` của đầu chủ
- Gửi notification template `VERIFY_REMINDER` cho đầu chủ
- Tạo work log để timeline ghi nhận

## Edge case
Nếu BĐS chưa gán đầu chủ (`real_estate.owner_id = null`):
- ✅ Vẫn tạo work
- ❌ Skip notification
- Message: `"Đã ghi nhận yêu cầu (BĐS chưa có đầu chủ - chưa gửi được notification)"`

## Response
```json
{
  "status": 1,
  "message": "Đã gửi nhắc xác thực",
  "data": {
    "work_id": 12348,
    "work_subtype": "request_verification",
    "real_estate_id": 319414,
    "verifying_user_id": 567,
    "notify_count": 1,
    "notification_sent": true
  }
}
```

---

# 📅 5. Hẹn xem (appointment)

**View 1:** "Tạo lịch hẹn — Thêm thông tin hẹn gặp với chủ nhà" (có BDS)
**View 2:** "Tạo lịch hẹn — Thêm thông tin hẹn gặp với khách hàng" (không BDS)

## Request

### View 1: Hẹn chủ nhà (gắn với CI)
| Field | Type | Required | Giá trị |
|---|---|---|---|
| `tablename` | string | ✅ | `consultation_interest` |
| `table_id` | int | ✅ | `<ci_id>` |
| `code` | string | ✅ | `appointment` |
| `started_at` | datetime | ✅ | `2026-06-01T09:00:00` (ISO 8601) |
| `location` | string | ❌ | Địa điểm gặp → lưu vào `meeting_place` |
| `note` | text | ❌ | Ghi chú → lưu vào `description` |

### View 2: Hẹn khách hàng (gắn với Consultation, không có BDS)
| Field | Type | Required | Giá trị |
|---|---|---|---|
| `tablename` | string | ✅ | `consultation` |
| `table_id` | int | ✅ | `<consultation_id>` |
| `code` | string | ✅ | `appointment` |
| `started_at` | datetime | ✅ | ISO 8601 |
| `location` | string | ❌ | |
| `note` | text | ❌ | |

## Field aliases (đều được accept)
| FE gửi | Map sang DB field |
|---|---|
| `note` \| `description` \| `content` | `description` |
| `location` \| `meeting_place` | `meeting_place` |
| `started_at` | `started_at` |

## Response
```json
{
  "status": 1,
  "message": "Tạo lịch hẹn thành công",
  "data": {
    "work_id": 12350,
    "work_subtype": "appointment",
    "meeting_place": "Trước cổng nhà, hẻm 123 Lê Văn Sỹ",
    "work": { ... }
  }
}
```

## ⚠️ Lưu ý
- **Notification toggle** trên UI ("Tự động gửi thông báo cho chủ nhà/khách hàng"): chưa implement backend. FE có thể gửi field `notify=true/false` nhưng backend hiện skip — khi có spec rõ sẽ thêm.

---

# 💰 6. Đặt cọc (deposit)

## Request
| Field | Type | Required | Giá trị |
|---|---|---|---|
| `tablename` | string | ✅ | `consultation_interest` |
| `table_id` | int | ✅ | `<ci_id>` |
| `code` | string | ✅ | `deposit` |
| `deposit_type` | string | ✅ | `thien_chi` (Cọc thiện chí) \| `coc_chet` (Cọc chính thức) |
| `deposit_amount` | int | ✅ | Số tiền (VND) — phải > 0 |
| `started_at` | datetime | ❌ | Default: now |
| `deposit_notes` | text | ❌ | Ghi chú đặt cọc |

## Response
```json
{
  "status": 1,
  "message": "Tạo đặt cọc thành công",
  "data": {
    "deposit_id": 999,
    "work_id": 12351,
    ...
  }
}
```

---

# ⊘ 7. Không phù hợp (not_suitable)

**View:** Modal "Đánh dấu không phù hợp" — chọn 1 trong 8 lý do + ghi chú (optional).

## Step 1: Lấy danh sách lý do

```
GET /api_agent/get_not_suitable_reasons
```

### Response
```json
{
  "status": 1,
  "data": [
    {"id": 1, "code": "over_budget",          "label": "Giá vượt ngân sách khách",          "is_note_required": false},
    {"id": 2, "code": "wrong_area",           "label": "Diện tích không đúng nhu cầu",      "is_note_required": false},
    {"id": 3, "code": "wrong_location",       "label": "Vị trí / khu vực không phù hợp",    "is_note_required": false},
    {"id": 4, "code": "wrong_direction",      "label": "Hướng nhà / phong thủy không phù hợp", "is_note_required": false},
    {"id": 5, "code": "legal_issue",          "label": "Pháp lý / sổ đỏ chưa đủ điều kiện", "is_note_required": false},
    {"id": 6, "code": "mismatch_description", "label": "Hình ảnh / hiện trạng không như mô tả", "is_note_required": false},
    {"id": 7, "code": "customer_closed_other","label": "Khách đã chốt BĐS khác",            "is_note_required": false},
    {"id": 8, "code": "other",                "label": "Khác",                              "is_note_required": true}
  ]
}
```

**FE lưu ý:**
- `is_note_required=true` → bắt validate `content` ở FE khi user chọn (ví dụ "Khác")
- Backend hiện **không enforce** required → cần FE validate

## Step 2: Submit

```
POST /api_agent/work_consultation
```

| Field | Type | Required | Giá trị |
|---|---|---|---|
| `tablename` | string | ✅ | `consultation_interest` |
| `table_id` | int | ✅ | `<ci_id>` |
| `code` | string | ✅ | `not_suitable` |
| `reason_code` | string | ❌ | 1 trong 8 codes (xem master data) |
| `content` | text | ❌ | Ghi chú thêm (bắt buộc khi `reason_code=other`) |

## Side effect
- ✅ Set `consultation_interest.status = '9'` → BDS **biến mất khỏi list quan tâm**
- ✅ Tạo work log trong timeline với prefix `[Lý do: <label>]`

## Response
```json
{
  "status": 1,
  "message": "Đã đánh dấu BĐS không phù hợp",
  "data": {
    "work_id": 12352,
    "work_subtype": "not_suitable",
    "status": "completed",
    "reason_code": "legal_issue",
    "reason_label": "Pháp lý / sổ đỏ chưa đủ điều kiện",
    "consultation_interest_status_updated": true,
    "consultation_interest_status": "9",
    "work": { ... }
  }
}
```

---

# 🗑️ 7b. Bỏ khỏi list (remove_from_list) — menu phụ

**View:** Menu context "Bỏ khỏi list" — confirm đơn giản, không có form.

## Request
| Field | Type | Required | Giá trị |
|---|---|---|---|
| `tablename` | string | ✅ | `consultation_interest` |
| `table_id` | int | ✅ | `<ci_id>` |
| `code` | string | ✅ | `remove_from_list` |

## Behavior
- ✅ Set `consultation_interest.status = '9'`
- ❌ **KHÔNG tạo work log** (silent action - không để dấu vết trong timeline)

**Khác với `not_suitable`:**
- `not_suitable`: có lý do + tạo log trong timeline
- `remove_from_list`: chỉ remove, lặng lẽ

## Response
```json
{
  "status": 1,
  "message": "Đã bỏ BĐS khỏi danh sách",
  "data": {
    "consultation_interest_id": 222,
    "consultation_interest_status": "9",
    "work_id": null
  }
}
```

---

# 📊 8. Lấy timeline hoạt động

```
GET /api_agent/activities_consultation
```

## Request params

| Param | Type | Required | Mô tả |
|---|---|---|---|
| `tablename` | string | ✅ | `consultation_interest` |
| `table_id` | int | ✅ | `<ci_id>` |
| `visibility` | string | ❌ | `public` \| `internal` \| `all` (default) |
| `activity_type` | string | ❌ | `appointment` \| `deposit` \| `note` \| `all` (default) |
| `page` | int | ❌ | Default 1 |
| `limit` | int | ❌ | Default 20 |

## Response

```json
{
  "status": 1,
  "data": {
    "works": [
      {
        "work_id": 12345,
        "work_name": "Gọi đầu chủ",
        "description": "Đầu chủ xác nhận giá còn thương lượng",
        "work_type": "call_owner",
        "work_subtype": "call_owner",
        "template_code": "call_owner",
        "template_id": 31,
        "started_at": "2026-05-19T14:30:00",
        "completed_at": "2026-05-19T14:30:00",
        "status": "completed",
        "result_label": "Đã kết nối",
        "result_color": "#10b981",
        "result_note": "",
        "meeting_place": "",
        "comments": [],
        "comment_count": 0
      },
      {
        "work_id": 12346,
        "work_name": "Gửi khách hàng",
        "description": "[Zalo → tự hoàn - 0342790003] BĐS phù hợp ngân sách",
        "work_type": "send_customer",
        "template_code": "send_customer",
        "status": "completed",
        "result_label": "Zalo",
        "result_color": "#0068ff",
        "send_channel": "zalo",
        "send_channel_icon": "zalo",
        "result_note": "zalo"
      },
      ...
    ],
    "summary": {
      "total_works": 25,
      "total_comments": 0,
      "by_type": {
        "appointment": 3,
        "deposit": 1,
        "note": 5,
        "call_owner": 8,
        "send_customer": 4,
        "not_suitable": 2,
        "request_verification": 2
      }
    },
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 25,
      "pages": 2
    }
  }
}
```

## FE rendering hints
- `work_type` / `template_code`: render icon + màu nền card theo loại action
- `result_label` + `result_color`: render badge sub-status (vd "Đã kết nối" 🟢)
- `meeting_place`: hiển thị nếu là appointment
- `send_channel_icon`: icon kênh gửi cho send_customer
- `description`: nội dung chi tiết

---

# ⚠️ Common Errors

| HTTP / Message | Lý do |
|---|---|
| `Thiếu tham số code (...)` | Mobile quên `code` field |
| `code không hợp lệ. Cho phép: ...` | `code` không thuộc whitelist |
| `Thiếu tham số tablename` / `table_id` | Thiếu 2 field bắt buộc |
| `tablename không hợp lệ. Cho phép: consultation_interest, real_estate, customer, consultation` | tablename ngoài whitelist |
| `table_id phải là số nguyên` | table_id không phải int |
| `Không tìm thấy <entity> #<id>` | table_id không tồn tại trong DB |
| `Thiếu tham số call_result (...)` | code=call_owner thiếu `call_result` |
| `call_result không hợp lệ. ...` | Sai whitelist 4 giá trị |
| `Thiếu tham số send_channel (...)` | code=send_customer thiếu `send_channel` |
| `send_channel không hợp lệ. ...` | Sai whitelist 3 giá trị |
| `reason_code không hợp lệ. ...` | code=not_suitable với reason_code sai |
| `Chưa có thời gian triển khai` | code=appointment thiếu `started_at` |
| `Thiếu thông tin bắt buộc: deposit_amount` | code=deposit thiếu amount |
| `Loại cọc không hợp lệ. ...` | deposit_type sai |
| `remove_from_list chỉ áp dụng với tablename=consultation_interest` | Sai tablename |

---

# 🧪 Test resource

- **Postman collection**: [`docs/team-management/postman_work_consultation.json`](postman_work_consultation.json)
  - 7 folders, 45 requests
  - Auto-save token sau login, auto-save work_id sau khi tạo
- **Variables cần set**: `base_url`, `ci_id`, `consultation_id`

---

# 📌 Checklist FE implementation

## Tab "BDS phù hợp với nhu cầu" trong 1 Nhu cầu

- [ ] **Card BDS** hiển thị thông tin từ `consultation_interest` (BDS code, title, địa chỉ, diện tích, giá, đầu chủ)
- [ ] **7 nút action** trên mỗi card → gọi `POST /work_consultation` với `code` tương ứng
- [ ] **Menu "..."** mở dropdown chứa 7 nút + "Xem cọc" + "Bỏ khỏi list"
- [ ] **Modal "Gọi đầu chủ"**: 4 radio button (Đã kết nối/Không nghe/Máy bận/Từ chối) + textarea ghi chú
- [ ] **Modal "Gửi khách hàng"**: hiển thị thông tin KH + BDS + link bài viết + 3 button kênh (Zalo/Messenger/App)
- [ ] **Modal "Thêm ghi chú"**: textarea (max 500 chars) + toggle visibility (nếu cần)
- [ ] **Modal "Hẹn xem"**: datetime picker (required) + location input + textarea note + toggle notify (chưa active backend)
- [ ] **Modal "Đặt cọc"**: deposit_type radio (2 loại) + amount input + datetime + note
- [ ] **Modal "Không phù hợp"**: 
  - [ ] Load 8 reasons từ `GET /get_not_suitable_reasons` (cache cho session)
  - [ ] Radio chọn reason → highlight cam
  - [ ] Textarea "Ghi chú thêm"
  - [ ] Validate FE: nếu chọn "Khác" thì content REQUIRED
- [ ] **Action "Bỏ khỏi list"**: confirm dialog đơn giản → POST với `code=remove_from_list`
- [ ] **Action "Nhắc xác thực"**: gọi trực tiếp (có thể prompt note ngắn hoặc không)
- [ ] **Tab "HOẠT ĐỘNG & GHI CHÚ"**: render timeline từ `GET /activities_consultation` với pagination
- [ ] **Toast notification**: sau mỗi action thành công ("Đã thêm ghi chú", "Đã bỏ BDS khỏi danh sách", ...)
- [ ] **Refresh list BDS**: sau khi `not_suitable` / `remove_from_list` thành công → BDS biến mất khỏi list (CI.status='9' bị filter)

## Color & icon mapping (lưu vào constants FE)

```js
const CALL_RESULT_COLORS = {
  connected:  { label: 'Đã kết nối',     color: '#10b981', icon: 'check-circle' },
  no_answer:  { label: 'Không nghe máy', color: '#fbbf24', icon: 'phone-x' },
  busy:       { label: 'Máy bận',        color: '#f97316', icon: 'phone-off' },
  rejected:   { label: 'Từ chối',        color: '#ef4444', icon: 'x-circle' },
};

const SEND_CHANNEL_COLORS = {
  zalo:        { label: 'Zalo',         color: '#0068ff', icon: 'zalo' },
  messenger:   { label: 'Messenger',    color: '#0084ff', icon: 'messenger' },
  app_tongkho: { label: 'App Tổng Kho', color: '#10b981', icon: 'mobile' },
};

const ACTION_BUTTONS = [
  { code: 'call_owner',           label: 'Gọi đầu chủ',    icon: 'phone',     color: 'green' },
  { code: 'send_customer',        label: 'Gửi khách hàng', icon: 'share',     color: 'blue' },
  { code: 'note',                 label: 'Ghi chú',        icon: 'edit',      color: 'gray' },
  { code: 'request_verification', label: 'Nhắc xác thực',  icon: 'shield',    color: 'yellow' },
  { code: 'appointment',          label: 'Hẹn xem',        icon: 'calendar',  color: 'purple' },
  { code: 'deposit',              label: 'Đặt cọc',        icon: 'dollar',    color: 'orange' },
  { code: 'not_suitable',         label: 'Không phù hợp',  icon: 'x',         color: 'red' },
];
```

---

# 🔄 Out of scope (sẽ làm sau)

| Feature | Trạng thái |
|---|---|
| Notify toggle "Tự động gửi thông báo cho chủ nhà" (appointment) | Backend chưa wire, FE gửi `notify=true/false` chấp nhận |
| Send_customer: thực sự gửi qua Zalo/Messenger (open app + share link) | FE tự handle (open intent), backend chỉ ghi nhận |
| Edit kết quả call_owner sau khi đã lưu | Hiện không cho phép (mỗi cuộc gọi là 1 work mới) |
| Comment thread trên work note | Tạm bỏ — có thể bổ sung qua `code=comment` nếu cần |
| Master data CRUD admin UI cho `not_suitable_reasons` | Hardcode, redeploy khi đổi |

---

<a id="docs-nhu-cau-contract-seller-create-md"></a>

## docs/nhu-cau/contract_seller_create.md

# API Tạo Hợp Đồng Môi Giới

## Thông tin chung

- **Endpoint**: `POST /tongkho/api_agent/contract_seller_create`
- **Description**: Tạo hợp đồng môi giới cho BĐS
- **Authentication**: Bắt buộc (`@auth.requires_login()`)
- **Content-Type**: `application/json`

---

## Request Body

### Các trường dữ liệu

| Field | Type | Required | Description | Default | Allowed Values |
|-------|------|----------|-------------|---------|----------------|
| `real_estate_salesman_id` | `number` | **Yes** | ID của real_estate_salesman (BĐS cần ký hợp đồng) | - | - |
| `contract_type` | `number` | No | Loại hợp đồng | `1` | `1`, `2`, `3` |
| `signing_method` | `number` | No | Phương thức ký | `1` | `1`, `2` |

### Chi tiết các giá trị

#### `contract_type` - Loại hợp đồng

| Value | Description |
|-------|-------------|
| `1` | Hợp đồng môi giới |
| `2` | Hợp đồng đặt cọc |
| `3` | Hợp đồng độc quyền |

#### `signing_method` - Phương thức ký

| Value | Description |
|-------|-------------|
| `1` | Ký trực tiếp |
| `2` | Ký online |

---

## Request Example

### Example 1: Tạo hợp đồng môi giới (ký trực tiếp)

```json
{
  "real_estate_salesman_id": 12345,
  "contract_type": 1,
  "signing_method": 1
}
```

### Example 2: Tạo hợp đồng độc quyền (ký online)

```json
{
  "real_estate_salesman_id": 12345,
  "contract_type": 3,
  "signing_method": 2
}
```

### Example 3: Tạo hợp đồng với giá trị mặc định

```json
{
  "real_estate_salesman_id": 12345
}
```

---

## Response

### Success Response

**Status Code**: `200 OK`

```json
{
  "success": true,
  "contract_id": 67890
}
```

### Error Response

**Status Code**: `200 OK` (luôn trả về 200, kiểm tra qua `success` field)

#### Case 1: Thiếu thông tin BĐS

```json
{
  "success": false,
  "message": "Không tồn tại nội dung hợp đồng"
}
```

#### Case 2: BĐS là "Thông tin pháp lý khác"

```json
{
  "success": false,
  "message": "Thông tin pháp lý khác hiện không khả dụng để ký hợp đồng!"
}
```

#### Case 3: Không có chủ nhà (bên B)

```json
{
  "success": false,
  "message": "Không tồn tại thông tin chủ nhà (bên B)"
}
```

#### Case 4: Không tìm thấy văn phòng

```json
{
  "success": false,
  "message": "Không tìm thấy thông tin văn phòng (Bên A)"
}
```

#### Case 5: Loại hợp đồng không hợp lệ

```json
{
  "success": false,
  "message": "Loại hợp đồng phải thuộc [1, 2, 3]"
}
```

#### Case 6: Lỗi hệ thống

```json
{
  "success": false,
  "message": "Không thể tạo hợp đồng, vui lòng thử lại"
}
```

---

## Logic xử lý (Backend)

### 1. Kiểm tra BĐS

- BĐS phải tồn tại trong bảng `real_estate_salesman`
- BĐS phải có `owner_account_id` (chủ nhà - bên B)
- BĐS không được có `contract_type = '3'` (thông tin pháp lý khác)

### 2. Xác định Bên A (Văn phòng)

Backend tự động xác định `info_office` theo thứ tự sau:

1. **Ưu tiên 1**: Từ `salesman_support` của user đang login
2. **Ưu tiên 2**: Từ `city_id` của BĐS → tìm `post_office` tương ứng
3. **Fallback**: Dùng `info_office` mặc định (id = 1)

### 3. Xác định Verify Agent

- Lấy từ bảng `verify_agent` với `salesman = owner_account_id`

### 4. Tạo Contract

```python
db.contract.insert(
    info_office=info_office,              # Tự động xác định
    verify_agent=row_verify_agent.id,      # Tự động từ owner
    status=1,                              # Chờ duyệt
    contract_type=contract_type,           # Từ request
    signing_method=signing_method,         # Từ request
    real_estate_salesman=real_estate_salesman_id,  # Từ request
    created_by=auth.user_id,               # User đang login
    post_office_id=post_office_id          # Tự động xác định
)
```

### 5. Workflow sau khi tạo

- Tạo work item: "Ký hợp đồng môi giới"
- Ghi log tracking

---

## Câu hỏi thường gặp (FAQ)

### Q: Tại sao cần `real_estate_salesman_id` mà không phải `real_estate_id`?

**A**: Hợp đồng được tạo dựa trên `real_estate_salesman` (bản ghi gán BĐS cho salesman), không phải trực tiếp từ `real_estate`.

### Q: Contract type = 3 là gì?

**A**: Contract type = 3 là "Hợp đồng độc quyền". Một BĐS chỉ có thể có một hợp đồng độc quyền active tại một thời điểm.

### Q: Signing method ảnh hưởng gì?

**A**: `signing_method` quyết định quy trình ký sau này:
- `1`: Ký trực tiếp - cần gặp mặt ký giấy
- `2`: Ký online - ký qua hệ thống (chữ ký số)

### Q: Khi nào contract có code?

**A**: Contract được tạo với `status = 1` (Chờ duyệt) và chưa có code. Code sẽ được sinh khi contract được duyệt.

---

## Integration Guide cho FE

### 1. Validation trước khi gọi API

```typescript
interface CreateContractRequest {
  real_estate_salesman_id: number;
  contract_type?: 1 | 2 | 3;
  signing_method?: 1 | 2;
}

// Validate
function validateRequest(data: CreateContractRequest): string[] {
  const errors: string[] = [];

  if (!data.real_estate_salesman_id) {
    errors.push("Vui lòng chọn BĐS");
  }

  if (data.contract_type && ![1, 2, 3].includes(data.contract_type)) {
    errors.push("Loại hợp đồng không hợp lệ");
  }

  if (data.signing_method && ![1, 2].includes(data.signing_method)) {
    errors.push("Phương thức ký không hợp lệ");
  }

  return errors;
}
```

### 2. Gọi API

```typescript
async function createContract(data: CreateContractRequest): Promise<number> {
  const response = await fetch('/tongkho/api_agent/contract_seller_create', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    credentials: 'include', // Để gửi session cookie
    body: JSON.stringify(data)
  });

  const result = await response.json();

  if (!result.success) {
    throw new Error(result.message || 'Không thể tạo hợp đồng');
  }

  return result.contract_id;
}
```

### 3. Xử lý response

```typescript
try {
  const contractId = await createContract({
    real_estate_salesman_id: 12345,
    contract_type: 1,
    signing_method: 1
  });

  // Chuyển hướng sang trang chi tiết hợp đồng
  window.location.href = `/contract/${contractId}`;

} catch (error) {
  // Hiển thị error message cho user
  showToast(error.message, 'error');
}
```

---

## Tham khảo

- **File**: `applications/tongkho/controllers/api_agent.py:18560`
- **Table**: `contract`, `real_estate_salesman`, `info_office`, `verify_agent`
- **Related API**: `contract_create_broker` (tạo hợp đồng môi giới - logic tương tự)

---

<a id="docs-nhu-cau-postman-work-consultation-json"></a>

## docs/nhu-cau/postman_work_consultation.json

```json
{
  "info": {
    "name": "TongKho — Work Consultation (Nhu cầu mua)",
    "description": "Test collection cho 2 API mới `/work_consultation` (POST dispatcher) và `/activities_consultation` (GET timeline) — quản lý công việc + comment trên BĐS phù hợp trong 1 Nhu cầu mua.\n\n**Thiết lập môi trường:**\n- `base_url`: http://localhost:8000 hoặc https://quanly.tongkhobds.com\n- `app`: tongkho (tên web2py app)\n- `token`: JWT từ API Login (tự lưu sau khi gọi Login)\n- `ci_id`: consultation_interest.id\n- `work_id`: real_estate_work.id (cho thao tác comment / update_status)\n\n**Codes hợp lệ trong `/work_consultation`:**\n- 7 nút UI: call_owner | send_customer | note | request_verification | appointment | deposit | not_suitable\n- Hỗ trợ: comment | update_status\n\nClient chỉ cần truyền 3 thông số chính `tablename=consultation_interest` + `table_id=<ci_id>` + `code=<action>`. Backend tự query consultation_interest để lấy: consultation_id, real_estate_id, real_estate_transaction_id, owner_agent_id.",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
    "_postman_id": "tongkho-work-consultation-2026"
  },
  "variable": [
    { "key": "base_url", "value": "http://localhost:8000", "type": "string", "description": "Base URL (đổi sang prod khi cần)" },
    { "key": "app", "value": "tongkho", "type": "string" },
    { "key": "token", "value": "", "type": "string", "description": "JWT token từ Login (tự lưu)" },
    { "key": "ci_id", "value": "4567", "type": "string", "description": "consultation_interest.id (cho View 1: hẹn chủ nhà / call_owner / send_customer...)" },
    { "key": "consultation_id", "value": "678", "type": "string", "description": "consultation.id (cho View 2: hẹn khách hàng, không có BĐS cụ thể)" },
    { "key": "work_id", "value": "9999", "type": "string", "description": "real_estate_work.id (lưu từ response của các API tạo work)" }
  ],
  "auth": {
    "type": "bearer",
    "bearer": [
      { "key": "token", "value": "{{token}}", "type": "string" }
    ]
  },
  "item": [
    {
      "name": "0. Login (lấy JWT)",
      "item": [
        {
          "name": "Login (username/password) — auto-save token",
          "request": {
            "auth": { "type": "noauth" },
            "method": "GET",
            "header": [],
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/login.json?user_name=0901234567&password=123456",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "login.json"],
              "query": [
                { "key": "user_name", "value": "0901234567" },
                { "key": "password", "value": "123456" }
              ]
            }
          },
          "event": [
            {
              "listen": "test",
              "script": {
                "type": "text/javascript",
                "exec": [
                  "var json = pm.response.json();",
                  "if (json && json.token) {",
                  "    pm.collectionVariables.set('token', json.token);",
                  "    console.log('Token saved:', json.token.substring(0, 30) + '...');",
                  "}"
                ]
              }
            }
          ]
        }
      ]
    },
    {
      "name": "0b. Master Data (danh sách lý do, ...)",
      "item": [
        {
          "name": "GET /get_not_suitable_reasons — Danh sách 8 lý do \"Không phù hợp\"",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/get_not_suitable_reasons",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "get_not_suitable_reasons"]
            },
            "description": "Trả về 8 lý do cho modal \"Đánh dấu không phù hợp\".\n\nResponse format:\n[\n  { id, code, label, is_note_required },\n  ...\n]\n\nFrontend gọi 1 lần khi mở modal, render dropdown. Khi user chọn xong, gửi `reason_code` vào POST /work_consultation với code=not_suitable."
          }
        }
      ]
    },
    {
      "name": "1. 7 Nút UI BĐS phù hợp (POST /work_consultation)",
      "description": "7 action tương ứng 7 nút trong UI tab BĐS của 1 Nhu cầu mua. Tất cả dùng tablename=consultation_interest + table_id=ci_id + code.",
      "item": [
        {
          "name": "A.1a — call_owner: Đã kết nối (xanh)",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "call_owner", "type": "text" },
                { "key": "call_result", "value": "connected", "type": "text", "description": "connected | no_answer | busy | rejected" },
                { "key": "content", "value": "Đầu chủ xác nhận giá còn thương lượng được 200tr", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Tạo real_estate_work với template.code='call_owner', status='completed', description=note. KHÔNG tạo comment.\n\nResponse data: { work_id, work, work_subtype='call_owner', status, call_result='connected', result_label='Đã kết nối', result_color='#10b981' }"
          },
          "event": [
            {
              "listen": "test",
              "script": {
                "type": "text/javascript",
                "exec": [
                  "var json = pm.response.json();",
                  "if (json && json.data && json.data.work_id) {",
                  "    pm.collectionVariables.set('work_id', json.data.work_id);",
                  "    console.log('work_id saved:', json.data.work_id);",
                  "}"
                ]
              }
            }
          ]
        },
        {
          "name": "A.1b — call_owner: Không nghe máy (vàng)",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "call_owner", "type": "text" },
                { "key": "call_result", "value": "no_answer", "type": "text" },
                { "key": "content", "value": "Gọi 3 lần đều không nghe máy", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "status='no_show', result_color='#fbbf24'"
          }
        },
        {
          "name": "A.1c — call_owner: Máy bận (cam)",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "call_owner", "type": "text" },
                { "key": "call_result", "value": "busy", "type": "text" },
                { "key": "content", "value": "Máy bận - thử lại sau", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "status='on_hold', result_color='#f97316'"
          }
        },
        {
          "name": "A.1d — call_owner: Từ chối (đỏ)",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "call_owner", "type": "text" },
                { "key": "call_result", "value": "rejected", "type": "text" },
                { "key": "content", "value": "Đầu chủ từ chối, không muốn bán nữa", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "status='cancelled', result_color='#ef4444'"
          }
        },
        {
          "name": "A.1e — call_owner: thiếu call_result (negative)",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "call_owner", "type": "text" },
                { "key": "content", "value": "Test thiếu call_result", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'Thiếu tham số call_result (connected | no_answer | busy | rejected)'"
          }
        },
        {
          "name": "A.2a — send_customer: Zalo",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "send_customer", "type": "text" },
                { "key": "send_channel", "value": "zalo", "type": "text", "description": "zalo | messenger | app_tongkho" },
                { "key": "content", "value": "BĐS phù hợp ngân sách của anh/chị", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Tạo work với template.code='send_customer', result_note='zalo'. Description snapshot recipient: '[Zalo → tự hoàn - 0342790003] BĐS phù hợp...'\n\nResponse data: { work_id, work_subtype='send_customer', status='completed', send_channel='zalo', result_label='Zalo', result_color='#0068ff' }"
          },
          "event": [
            {
              "listen": "test",
              "script": {
                "type": "text/javascript",
                "exec": [
                  "var json = pm.response.json();",
                  "if (json && json.data && json.data.work_id) {",
                  "    pm.collectionVariables.set('work_id', json.data.work_id);",
                  "}"
                ]
              }
            }
          ]
        },
        {
          "name": "A.2b — send_customer: Messenger",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "send_customer", "type": "text" },
                { "key": "send_channel", "value": "messenger", "type": "text" },
                { "key": "content", "value": "Em gửi anh xem BĐS này nhé", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "result_label='Messenger', result_color='#0084ff'"
          }
        },
        {
          "name": "A.2c — send_customer: App Tổng Kho",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "send_customer", "type": "text" },
                { "key": "send_channel", "value": "app_tongkho", "type": "text" },
                { "key": "content", "value": "Đã gửi qua app TongKho", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "result_label='App Tổng Kho', result_color='#10b981'"
          }
        },
        {
          "name": "A.2d — send_customer: thiếu send_channel (negative)",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "send_customer", "type": "text" },
                { "key": "content", "value": "Test thiếu send_channel", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'Thiếu tham số send_channel (zalo | messenger | app_tongkho)'"
          }
        },
        {
          "name": "A.3 — note (📝 Ghi chú public)",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "note", "type": "text" },
                { "key": "content", "value": "Khách quan tâm, đang chờ chốt với gia đình", "type": "text" },
                { "key": "visibility", "value": "public", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Chỉ tạo work với status='pending' (không completed) + gửi notification NOTE_CREATED. KHÔNG tạo comment.\n\nDB row:\n  name='Ghi chú'\n  description=<nội dung user nhập>\n  status='pending'\n  completed_at=null\n  attachments=<JSON nếu có>\n\nResponse data: { work_id, work_subtype='note', status='pending', notify_count }"
          },
          "event": [
            {
              "listen": "test",
              "script": {
                "type": "text/javascript",
                "exec": [
                  "var json = pm.response.json();",
                  "if (json && json.data && json.data.work_id) {",
                  "    pm.collectionVariables.set('work_id', json.data.work_id);",
                  "}"
                ]
              }
            }
          ]
        },
        {
          "name": "A.3b — note internal (📝 Ghi chú nội bộ)",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "note", "type": "text" },
                { "key": "content", "value": "Lưu ý nội bộ: khách hay đổi ý", "type": "text" },
                { "key": "visibility", "value": "internal", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "name='Ghi chú nội bộ', status='pending', completed_at=null, KHÔNG tạo comment, notification NOTE_CREATED_INTERNAL"
          }
        },
        {
          "name": "A.4 — request_verification (🔔 Nhắc xác thực)",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "request_verification", "type": "text" },
                { "key": "content", "value": "Vui lòng xác thực tình trạng BĐS còn không", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Gửi notification VERIFY_REMINDER cho đầu chủ (auto-resolve từ real_estate.salesman_id → salesman.user_id) + tạo work log."
          }
        },
        {
          "name": "A.5a — appointment View 1: Hẹn chủ nhà (CI)",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "appointment", "type": "text" },
                { "key": "started_at", "value": "2026-06-01T09:00:00", "type": "text", "description": "REQUIRED" },
                { "key": "location", "value": "Trước cổng nhà, hẻm 123 Lê Văn Sỹ", "type": "text", "description": "→ DB: meeting_place" },
                { "key": "note", "value": "Khách đi cùng vợ", "type": "text", "description": "→ DB: description" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "View 1: Hẹn chủ nhà. tablename=consultation_interest.\n\nDB row:\n  tablename=consultation_interest, table_id=<ci_id>\n  template_id=4 (appointment)\n  started_at=<thời gian hẹn>\n  meeting_place=<địa điểm từ field location>\n  description=<ghi chú từ field note>\n  real_estate_id=<auto-enrich từ CI>\n  consultation_id=<auto-enrich từ CI>\n\nField aliases được accept:\n  - description | note | content → description\n  - meeting_place | location → meeting_place"
          },
          "event": [
            {
              "listen": "test",
              "script": {
                "type": "text/javascript",
                "exec": [
                  "var json = pm.response.json();",
                  "if (json && json.data && json.data.work_id) {",
                  "    pm.collectionVariables.set('work_id', json.data.work_id);",
                  "}"
                ]
              }
            }
          ]
        },
        {
          "name": "A.5b — appointment View 2: Hẹn khách hàng (Consultation)",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation", "type": "text" },
                { "key": "table_id", "value": "{{consultation_id}}", "type": "text" },
                { "key": "code", "value": "appointment", "type": "text" },
                { "key": "started_at", "value": "2026-06-02T14:00:00", "type": "text", "description": "REQUIRED" },
                { "key": "location", "value": "Văn phòng quận 1, số 123 đường X", "type": "text" },
                { "key": "note", "value": "Tư vấn tổng quan nhu cầu của khách", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "View 2: Hẹn khách hàng (không có BĐS cụ thể). tablename=consultation.\n\nDB row:\n  tablename=consultation, table_id=<consultation_id>\n  template_id=4 (appointment)\n  started_at=<thời gian hẹn>\n  meeting_place=<địa điểm>\n  description=<ghi chú>\n  consultation_id=<auto-set = table_id>\n  real_estate_id=null (không có BĐS)\n\nLưu ý: cần khai báo biến `consultation_id` trong collection."
          }
        },
        {
          "name": "A.5c — appointment: thiếu started_at (negative)",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "appointment", "type": "text" },
                { "key": "location", "value": "Test", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'Chưa có thời gian triển khai' (vì template_id=4 require started_at)"
          }
        },
        {
          "name": "A.6 — deposit (💰 Đặt cọc)",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "deposit", "type": "text" },
                { "key": "deposit_type", "value": "thien_chi", "type": "text", "description": "thien_chi | coc_chet" },
                { "key": "deposit_amount", "value": "10000000", "type": "text" },
                { "key": "started_at", "value": "2026-06-01T10:00:00", "type": "text" },
                { "key": "deposit_notes", "value": "Cọc thiện chí giữ chỗ 3 ngày", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            }
          }
        },
        {
          "name": "A.7a — not_suitable: với reason_code",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "not_suitable", "type": "text" },
                { "key": "reason_code", "value": "legal_issue", "type": "text", "description": "Optional: over_budget | wrong_area | wrong_location | wrong_direction | legal_issue | mismatch_description | customer_closed_other | other" },
                { "key": "content", "value": "Sổ đỏ chưa đủ điều kiện sang tên", "type": "text", "description": "Ghi chú thêm (required khi reason_code='other')" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Set CI.status='9' + tạo work log.\n\nDB row:\n  tablename=consultation_interest\n  table_id=<ci_id>\n  status='completed'\n  description='[Lý do: Pháp lý / sổ đỏ chưa đủ điều kiện] Sổ đỏ chưa đủ điều kiện sang tên'\n  result_note='legal_issue'\n\nResponse data: { work_id, reason_code='legal_issue', reason_label='Pháp lý / sổ đỏ chưa đủ điều kiện', consultation_interest_status='9' }"
          }
        },
        {
          "name": "A.7b — not_suitable: không reason_code (free text)",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "not_suitable", "type": "text" },
                { "key": "content", "value": "Khách chê hướng nhà không hợp tuổi", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Backward-compat: không gửi reason_code vẫn OK. description = ghi chú user."
          }
        },
        {
          "name": "A.7c — not_suitable: reason_code không hợp lệ (negative)",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "not_suitable", "type": "text" },
                { "key": "reason_code", "value": "invalid_reason", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'reason_code không hợp lệ. Cho phép: over_budget, ...'"
          }
        },
        {
          "name": "A.8 — remove_from_list (🗑️ Bỏ khỏi list - silent)",
          "request": {
            "method": "POST",
            "header": [{ "key": "Content-Type", "value": "application/x-www-form-urlencoded" }],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "remove_from_list", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Hành động \"Bỏ khỏi list\" (silent): CHỈ set consultation_interest.status='9'. KHÔNG tạo work log, không có dấu vết trong timeline.\n\nKhác với not_suitable: \n- not_suitable: có reason + tạo log\n- remove_from_list: chỉ remove, lặng lẽ\n\nResponse data: { consultation_interest_id, consultation_interest_status='9', work_id=null }"
          }
        }
      ]
    },
    {
      "name": "2. Thao tác hỗ trợ trên work đã có",
      "item": [
        {
          "name": "B.1 — comment (Thêm bình luận vào work)",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "code", "value": "comment", "type": "text" },
                { "key": "work_id", "value": "{{work_id}}", "type": "text" },
                { "key": "content", "value": "Khách đã chuyển khoản, vui lòng xác nhận", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            }
          }
        },
        {
          "name": "B.2 — update_status: completed",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "code", "value": "update_status", "type": "text" },
                { "key": "work_id", "value": "{{work_id}}", "type": "text" },
                { "key": "status", "value": "completed", "type": "text" },
                { "key": "result_note", "value": "Đã ký HĐ đặt cọc", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            }
          }
        },
        {
          "name": "B.3 — update_status: cancelled",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "code", "value": "update_status", "type": "text" },
                { "key": "work_id", "value": "{{work_id}}", "type": "text" },
                { "key": "status", "value": "cancelled", "type": "text" },
                { "key": "reason", "value": "Khách đổi ý không mua nữa", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            }
          }
        }
      ]
    },
    {
      "name": "3. Đọc timeline (GET /activities_consultation)",
      "item": [
        {
          "name": "C.1 — Lấy danh sách hoạt động của 1 BĐS phù hợp",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/activities_consultation?tablename=consultation_interest&table_id={{ci_id}}&page=1&limit=20",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "activities_consultation"],
              "query": [
                { "key": "tablename", "value": "consultation_interest" },
                { "key": "table_id", "value": "{{ci_id}}" },
                { "key": "page", "value": "1" },
                { "key": "limit", "value": "20" }
              ]
            }
          }
        },
        {
          "name": "C.2 — Lọc chỉ lịch hẹn",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/activities_consultation?tablename=consultation_interest&table_id={{ci_id}}&activity_type=appointment",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "activities_consultation"],
              "query": [
                { "key": "tablename", "value": "consultation_interest" },
                { "key": "table_id", "value": "{{ci_id}}" },
                { "key": "activity_type", "value": "appointment", "description": "appointment | deposit | note | all" }
              ]
            }
          }
        },
        {
          "name": "C.3 — Lọc chỉ đặt cọc",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/activities_consultation?tablename=consultation_interest&table_id={{ci_id}}&activity_type=deposit",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "activities_consultation"],
              "query": [
                { "key": "tablename", "value": "consultation_interest" },
                { "key": "table_id", "value": "{{ci_id}}" },
                { "key": "activity_type", "value": "deposit" }
              ]
            }
          }
        },
        {
          "name": "C.4 — Chỉ ghi chú nội bộ",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/activities_consultation?tablename=consultation_interest&table_id={{ci_id}}&visibility=internal",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "activities_consultation"],
              "query": [
                { "key": "tablename", "value": "consultation_interest" },
                { "key": "table_id", "value": "{{ci_id}}" },
                { "key": "visibility", "value": "internal", "description": "public | internal | all" }
              ]
            }
          }
        }
      ]
    },
    {
      "name": "4. Negative paths (validation)",
      "item": [
        {
          "name": "D.1 — Thiếu code",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'Thiếu tham số code (...)'"
          }
        },
        {
          "name": "D.2 — code không hợp lệ",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "invalid_action", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'code không hợp lệ. Cho phép: appointment, call_owner, ...'"
          }
        },
        {
          "name": "D.3 — comment thiếu work_id",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "code", "value": "comment", "type": "text" },
                { "key": "content", "value": "Test", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'Thiếu tham số work_id'"
          }
        },
        {
          "name": "D.4 — deposit thiếu deposit_amount",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "deposit", "type": "text" },
                { "key": "deposit_type", "value": "thien_chi", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'Thiếu thông tin bắt buộc: deposit_amount'"
          }
        },
        {
          "name": "D.5 — update_status status không hợp lệ",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "code", "value": "update_status", "type": "text" },
                { "key": "work_id", "value": "{{work_id}}", "type": "text" },
                { "key": "status", "value": "invalid_status", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message về status không hợp lệ"
          }
        },
        {
          "name": "D.6 — activities thiếu params",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/activities_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "activities_consultation"]
            },
            "description": "Expect: status=0, message: 'Thiếu tham số tablename/table_id (...)'"
          }
        },
        {
          "name": "D.7 — table_id không tồn tại trong DB",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "99999999", "type": "text", "description": "ID không tồn tại" },
                { "key": "code", "value": "note", "type": "text" },
                { "key": "content", "value": "Test", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'Không tìm thấy BĐS quan tâm #99999999'"
          }
        },
        {
          "name": "D.8 — table_id không phải số nguyên",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "abc", "type": "text" },
                { "key": "code", "value": "note", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'table_id phải là số nguyên'"
          }
        },
        {
          "name": "D.9 — tablename không hợp lệ",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "tablename", "value": "real_estate_transaction", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "code", "value": "note", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'tablename không hợp lệ. Cho phép: consultation_interest, real_estate, customer, consultation'"
          }
        },
        {
          "name": "D.10 — work_id không tồn tại (comment)",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "code", "value": "comment", "type": "text" },
                { "key": "work_id", "value": "99999999", "type": "text" },
                { "key": "content", "value": "Test", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'Không tìm thấy công việc #99999999'"
          }
        },
        {
          "name": "D.11 — work_id không tồn tại (update_status)",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "code", "value": "update_status", "type": "text" },
                { "key": "work_id", "value": "99999999", "type": "text" },
                { "key": "status", "value": "completed", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "work_consultation"]
            },
            "description": "Expect: status=0, message: 'Không tìm thấy công việc #99999999'"
          }
        }
      ]
    },
    {
      "name": "5. Backward-compat wrappers cũ",
      "description": "5 endpoint cũ vẫn hoạt động (gọi cùng helper). Mobile cũ không bị break.",
      "item": [
        {
          "name": "E.1 — create_work_consultation (style cũ: code=appointment)",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "code", "value": "appointment", "type": "text" },
                { "key": "tablename", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "started_at", "value": "2026-06-01T09:00:00", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/create_work_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "create_work_consultation"]
            }
          }
        },
        {
          "name": "E.2 — create_note_consultation (style cũ: note_type)",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "note_type", "value": "consultation_interest", "type": "text" },
                { "key": "table_id", "value": "{{ci_id}}", "type": "text" },
                { "key": "content", "value": "Ghi chú từ mobile cũ", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/create_note_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "create_note_consultation"]
            }
          }
        },
        {
          "name": "E.3 — get_activities_consultation (style cũ: tab/tab_id)",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/get_activities_consultation?tab=consultation_interest&tab_id={{ci_id}}",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "get_activities_consultation"],
              "query": [
                { "key": "tab", "value": "consultation_interest", "description": "bds | customer | internal | consultation_interest" },
                { "key": "tab_id", "value": "{{ci_id}}" }
              ]
            }
          }
        },
        {
          "name": "E.4 — update_work_status_consultation",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "work_id", "value": "{{work_id}}", "type": "text" },
                { "key": "status", "value": "completed", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/update_work_status_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "update_work_status_consultation"]
            }
          }
        },
        {
          "name": "E.5 — add_work_comment_consultation",
          "request": {
            "method": "POST",
            "header": [
              { "key": "Content-Type", "value": "application/x-www-form-urlencoded" }
            ],
            "body": {
              "mode": "urlencoded",
              "urlencoded": [
                { "key": "work_id", "value": "{{work_id}}", "type": "text" },
                { "key": "content", "value": "Bình luận từ wrapper cũ", "type": "text" }
              ]
            },
            "url": {
              "raw": "{{base_url}}/{{app}}/api_agent/add_work_comment_consultation",
              "host": ["{{base_url}}"],
              "path": ["{{app}}", "api_agent", "add_work_comment_consultation"]
            }
          }
        }
      ]
    }
  ]
}
```

---

<a id="docs-project-changelog-md"></a>

## docs/project-changelog.md

---
title: "Project Changelog — Webapp Agent Next.js"
type: changelog
last_updated: 2026-05-19
---

# Project Changelog

## 2026-05-19 — feat: dashboard home redesign (priority stack agent-first)

**Replaced:** `src/app/(dashboard)/page.tsx` UI demo (369 LOC hardcoded) bằng compose-only page (35 LOC) wire BE thật.

**Added (`src/components/dashboard/`):**
- `dashboard-greeting.tsx` — chào + date label
- `kyc-soft-banner.tsx` — KYC nudge conditional step<3
- `dashboard-action-card.tsx` + `dashboard-empty-state.tsx` — shared shells
- `today-appointments-card.tsx` — lịch hẹn hôm nay (filter client-side từ `useAppointments`)
- `consultation-overdue-card.tsx` — nhu cầu overdue (filter `created_on > 7d` client-side, BE thiếu `last_contact_at`)
- `verification-rejected-card.tsx` — BĐS xác thực bị từ chối (`useVerifications` status=3)
- `kpi-strip.tsx` + `kpi-stat-card.tsx` — 4 KPI từ `dashboard_stats.json`: Hoa hồng MTD · Deal MTD · Khách chăm sóc · Tin BĐS đăng
- `quick-actions-grid.tsx` — 4 quick action button
- `home-news-carousel.tsx` — tin tức folder=11 (`news_by_folder.json`)
- `home-projects-carousel.tsx` — dự án nổi bật (`real_estate_sale_project.json`)

**Added API + hooks:**
- `src/lib/api/dashboard-stats.ts` + `src/hooks/use-dashboard-stats.ts` — wire 4 KPI metric, polling 60s
- `src/lib/api/news.ts` + `src/hooks/use-home-news.ts` — wire news folder, staleTime 5min
- `src/types/dashboard.ts` — DashboardStatsResponse schema + `OVERDUE_THRESHOLD_DAYS=7`
- `src/lib/format/number.ts` — `formatVndCompact`, `formatNumber`
- `src/lib/format/date-time.ts` — thêm `daysSince`, `isSameDayToday`

**Notes:**
- BE `dashboard_stats.json` không có Ranking + Conversion → fallback dùng 4 metric BE đã có sẵn
- Polling stagger: appointments 30s · consultations 30s · verifications 30s · dashboard_stats 60s · news/projects 5min
- Plan + research: `plans/260519-1005-dashboard-redesign/`

## 2026-04-25 — docs: system-architecture.md tổng hợp kiến trúc

**Added:**
- `docs/system-architecture.md` — 16 sections: context diagram, stack lock, source layout, routing & layout, auth (Bearer cookie + httpOnly + proxy injection), API proxy detail (header strip + encoding fix), data layer (TanStack + envelope parser), Zustand stores, forms, map (native Google Maps), notification (polling 30s), cross-cutting, build/test/deploy, security boundaries, trade-offs, roadmap anchors.

**Updated:**
- `docs/README.md` Files table: link 04-api-by-screen, system-architecture, deployment-guide, project-changelog, screens/.
- `docs/deployment-guide.md` troubleshooting: cookie name `access_token` → `tkbds_token` (match `src/middleware.ts`).

**No code changes.**

---

## 2026-04-24 — feat(nhu-cau): Schema rewrite match BE V2 + tag picker rework + bonus detail fields

**Shipped:** 6 phases complete (schema fix option A).

**Schema changes:**
- Flat + nested structure: `property_requirements.budget_range` (nested), `location_preferences: SearchItem[]`
- Bonus detail fields: `user_support`, `property`, `project`, `transaction_deposit`, `interests[]`, `works[]`, `post_office_*`, `consultation_code`, `demand_status_name: {name, color}`, `consultation_type`, `notification_schedule`, `matching_criteria`, `tag_id`, `stats: {priority_score, total_suggestions_sent, suggestions_today, last_matched, view_count, contact_count}`
- Notification keys asymmetric: GET detail `{push_enabled, sms_enabled, daily_limit}` vs CREATE `{enable_push_notification, enable_sms_notification, max_notifications_per_day}` + mapper helper `toCreateNotificationSettings()`
- BDS suggest response: single-level wrap `{data: {total, properties[], consultation_info, applied_filters}}`
- List filter params expanded: `office`, `sales_off`, `created_by`, `start_date/end_date`, `city_id/district_id/ward_id`, `or_and`, `tag_id[]`

**Files changed:**
- `src/types/consultation.ts` — merged schema + bonus fields
- `src/lib/api/consultation.ts` — response parsers + mapper helper
- `src/lib/nhu-cau/format.ts` — NEW formatter module for nested field extraction
- `src/components/nhu-cau/tag-picker-dialog/` — split 7 modules (index, logic, form, footer, tag-picker-item, assign, error-handler)
- `src/app/(dashboard)/nhu-cau/[id]/page.tsx` — detail page components refactored (broker_ → user_support, linked_property → property, tasks → works rename)

**BE unblocked:**
- Q16 `salesman_comments` allowed_tables ✅ include 'consultation' (commit 3d15f3dc, 2026-04-23)

**Tests:** 251/251 pass, build production pass.

**Docs updated:** `docs/02-api-catalog.md` section 9 detail fields + filter params + key asymmetry note.

---

## 2026-04-23 — feat(nhu-cau): Consultation phase 1 full CRUD + tag + note

**Shipped:** 7 phases complete.

**Features:**
- Replace legacy `sales-pipeline.ts` Demand stubs with `src/lib/api/consultation.ts` (9 endpoints wired)
- Responsive list page (`/nhu-cau`): tabs with count badges, card + table views, status filter
- Detail page (`/nhu-cau/[id]`): customer card, property requirements, location chips, suggested BDS panel
- Create/edit dialog with `consultationFormSchema` (Zod superRefine: customer_id OR name+phone required)
- Tag picker: fetch groups via `list_tags`, attach/replace via `assign_tags_to_entity`
- Comment timeline: fetch + add note dialog (note_type select + content textarea)
- Close consultation action: `PUT update_demand` shortcut with `status='completed'`
- `inferRole()` helper: infers KH/CTV/TP/GDK from user shape (checking_staff, salesman_type, auth_group)
- Unit tests: 37 cases across consultation-api, infer-role, consultation-form-schema

**BE endpoints wired (9):** `create_customer_demand` · `get_list_consultation` · `get_detail_consultation` · `update_demand` · `get_status_demand` · `demand_suggest` · `list_tags` · `assign_tags_to_entity` · `salesman_comments`

**Deferred:**
- E2E Playwright lifecycle (`tests/e2e/nhu-cau-lifecycle.spec.ts`): pending `allowed_tables` BE update (Q16) + auth fixture reliability
- Q15–Q20 sent to BE team (tag path, comments path, role label, selection_type, is_pinned)

---

## 2026-04-23 — BDS Filter 2-cấp/3-cấp + Location Autocomplete (Phase Complete)

**Shipped:** All 9 implementation phases complete.

**Features:**
- Unified `fetchLocations({parentId, grant: 2|3})` replaces fetchDistricts/fetchWards
- Autocomplete `fetchLocationSearching({text, cityId})` with mixed project + location results, gated by city_id
- `fetchHomeConfig()` probes `/api/home_config.json` for location system detection (fallback: assume new system)
- AddressPickerDialog multi-select provinces/districts/wards + 2-cấp toggle
- Sidebar "Chọn chi tiết" button opens picker; comboboxes show "Đã chọn N" in multi mode
- Active chips + cascade removal helpers (`cascadeRemoveCity`, `cascadeRemoveDistrict` in `src/lib/bds/cascade-remove.ts`)
- BDS list multi-array query params: `city_ids`, `district_ids`, `ward_ids`, `street_names`, `project_codes` + `locations_slug` CSV
- Wizard Section 2: 2-tier toggle + conditional district; `validateAddressTier()` at step transition
- Create payload: `buildSaveBdsPayload()` sends empty `district_id` when 2-tier (removed by `filterEmptyValues`)
- Commission workaround: `district_id=ward_id` hack for 2-cấp (logged to console, tracked as tech debt)
- 6 Playwright smoke test cases + helper (`tests/e2e/helpers/address-picker-actions.ts`)

**Documentation:**
- Updated `docs/03-be-questions.md`: Added Q11-Q14 for 2-cấp/3-cấp clarifications
- Updated `docs/02-api-catalog.md`: Documented `/real_estate_handle/location_searching`, `/api/home_config.json`, multi-array filter params

**Tech Debt / Unresolved:**
- Commission validation: FE uses `district_id=ward_id` workaround when 2-cấp mode; BE should relax validation OR add `is_2_tier` flag
- Confirm `/api/home_config.json` endpoint path + response shape

---

## Earlier Releases

- **2026-04-22** — Wizard Section 2 + commission validation
- **2026-04-21** — Create BDS wizard V2 (4 steps)
- **2026-04-20** — Address search unified dropdown + autocomplete research
- **2026-04-17** — Scaffold Next.js 15, API catalog reverse, brainstorm decisions locked

---

<a id="docs-qa-overlay-dev-checklist-md"></a>

## docs/qa-overlay-dev-checklist.md

# QA Overlay — Yêu cầu Dev trước khi push

Checklist BẮT BUỘC chạy trước mỗi `git push` để giữ QA overlay đồng bộ với code. Tester dùng overlay làm source of truth → tag rot = tester verify sai → bug lọt prod.

Tham chiếu attribute syntax: [../plans/260519-1439-qa-overlay-api-traceability/attribute-convention.md](../plans/260519-1439-qa-overlay-api-traceability/attribute-convention.md).

## Khi nào cần update tags

Mở DOM tagged khi PR của bạn touch ít nhất 1 trong các thay đổi sau:

- Thay endpoint BE (đổi path, đổi method, đổi response shape)
- Đổi field path response (vd. `data.list[].total_price` → `data.summary.amount`)
- Thêm/xóa transform function (`formatVnd` → `formatCurrency`)
- Thay đổi business rule (fallback, conditional render, role gate)
- Thêm button gọi API mới (POST/PUT/DELETE)
- Đổi screen layout làm element atom di chuyển → ancestor `data-qa-api` sai

Nếu PR chỉ refactor không đổi data flow / endpoint → SKIP checklist (note rõ trong PR).

## Pre-push checklist

Dán block sau vào PR description, tick `[x]` tất cả trước khi merge:

```
QA Overlay tag check (trước push):

- [ ] Đã chạy `localhost:3000/<route-bị-sửa>?qa=1` → click bug button
- [ ] Hover field bị thay đổi → tooltip hiển thị endpoint + field path + transform + note ĐÚNG với code mới
- [ ] Button POST/PUT/DELETE mới có `data-qa-api` + `data-qa-method`
- [ ] Field business-meaningful mới (giá, tên, status, KH, số tiền) có `data-qa-field` + `data-qa-transform` nếu có format
- [ ] Conditional render có `data-qa-note` mô tả rule (vd. "shown when role=checking_staff")
- [ ] List/table loop: container có `data-qa-api`, atom cell có `data-qa-field` (KHÔNG copy endpoint vào mọi row)
- [ ] Không tag wrapper layout (div Flex, Grid trống) hoặc icon trang trí
- [ ] `pnpm typecheck` pass (`npx tsc --noEmit`)
- [ ] Đã refresh page và xác minh overlay không break UI khi tắt (`?qa=1` mở, bug button OFF)
```

## Quick reference

### Atom field

```tsx
<span
  data-qa-api="/api_agent/get_bds_detail.json"
  data-qa-field="data.bds.total_price"
  data-qa-transform="formatVnd"
  data-qa-note="fallback 0 if null"
>
  {formatVnd(bds.total_price ?? 0)}
</span>
```

### Button gọi API (write op)

```tsx
<Button
  data-qa-api="/api_agent/confirm_verification.json"
  data-qa-method="POST"
  data-qa-note="{id, decision} → refresh list + close modal"
  onClick={handleConfirm}
>
  Xác nhận
</Button>
```

### List/Table loop (DRY)

```tsx
<tbody data-qa-api="/api_agent/get_list_bds.json">
  {bdsList.map(bds => (
    <tr key={bds.id}>
      <td data-qa-field="data.list[].title" data-qa-transform="capitalize">
        {capitalize(bds.title)}
      </td>
      <td data-qa-field="data.list[].total_price" data-qa-transform="formatVnd">
        {formatVnd(bds.total_price)}
      </td>
    </tr>
  ))}
</tbody>
```

Overlay tự outline ROW ĐẦU TIÊN, tooltip vẫn work cho mọi row.

### Wrapper component không hỗ trợ rest props

Spread `...rest` vào button/element bên trong:

```tsx
function MyButton({ children, tone, ...rest }: Props & ButtonHTMLAttributes<HTMLButtonElement>) {
  return <button {...rest}>{children}</button>;
}
```

## Anti-patterns (PR sẽ bị reject nếu có)

- Tag wrapper div thuần layout: `<div data-qa-api="..." className="flex gap-2">`
- Field path không đầy đủ: `data-qa-field="price"` (ambiguous)
- Tag icon trang trí: `<HomeIcon data-qa-api="..." />`
- Verbose note >100 ký tự
- Copy `data-qa-api` vào mọi cell row thay vì 1 container
- Tag endpoint sai (vd. dùng `/get_list_bds` khi code gọi `/get_list_real_estate`)

## Khi BE đổi endpoint

Khi BE rename/move endpoint (vd. namespace rebuild `nhu_cau` → `consultation`):

1. Grep `data-qa-api` chứa endpoint cũ:
   ```bash
   git grep -l "data-qa-api=\"/api_agent/old_endpoint"
   ```
2. Replace toàn bộ → endpoint mới
3. Verify trên 2-3 screen samples qua `?qa=1`
4. Note trong commit message: `chore(qa): update tags after BE rename X → Y`

## Quy ước method

- GET = mặc định, KHÔNG cần `data-qa-method`
- POST/PUT/PATCH/DELETE = BẮT BUỘC khai báo `data-qa-method`
- Read endpoint hiển thị endpoint không badge (đỡ clutter)
- Write endpoint hiển thị badge màu (POST xanh dương, PUT/PATCH cam, DELETE đỏ)

## Khi nào KHÔNG tag

- Field local-only (computed từ state, không đến từ API) → skip
- Toast/snackbar ephemeral → skip
- Skeleton loading → skip
- Padding/spacer wrapper → skip
- Icon trang trí → skip
- Label tĩnh "Giá:" / "Trạng thái:" → skip

## Khi nào tag dù không có `data-qa-field`

Container có `data-qa-api` mô tả endpoint trigger (filter container, action button, conditional block) — chấp nhận không có field, đặt `data-qa-note` mô tả side effect.

```tsx
<div
  data-qa-api="/api_agent/get_list_bds.json"
  data-qa-note="filter inputs → refetch list with query params"
>
  {/* filter inputs */}
</div>
```

---

<a id="docs-qa-overlay-guide-md"></a>

## docs/qa-overlay-guide.md

# QA Overlay — Hướng dẫn Tester

In-app overlay giúp manual tester biết UI field nào lấy từ endpoint nào, transform/biz rule ra sao — không cần devtools.

## Bật overlay

1. Mở trang cần test, thêm query `?qa=1` vào URL.
   Ví dụ: `https://app.tongkhobds.com/bds/123?qa=1`
2. Nhìn góc phải-dưới: bug icon trên nút floating → click để bật/tắt.
3. Khi bật: mọi field tagged được viền vàng cam.
4. Hover field → tooltip hiện:
   - **API**: endpoint BE đang cung cấp data
   - **Field**: path từ response root (vd. `data.list[].total_price`)
   - **Transform**: function/rule biến đổi raw → display (vd. `formatVnd`)
   - **Note**: biz rule, fallback, conditional render

## Cách verify

- **Đúng field hiển thị?** → đối chiếu Field path với BE response (tester request endpoint qua Postman/devtools nếu cần).
- **Transform hợp lý?** → check format số tiền, viết hoa, fallback null.
- **Conditional render đúng role?** → đọc Note xem điều kiện hiển thị.

## Action button

Button gọi API có `data-qa-api` = endpoint nó POST/PUT/DELETE.
Hover trước khi click để biết side effect.

## End-user không thấy

Nút floating chỉ xuất hiện khi URL có `?qa=1`. Khách hàng không vô tình bật được. Overlay tắt mặc định khi page load.

## Khi field không tagged

Field business-meaningful (giá, tên, status, KH) phải có tag. Nếu thiếu → báo dev. Field thuần UI (icon, divider, label tĩnh) không tag.

## Quy ước attribute (dev tham khảo)

Xem [../plans/260519-1439-qa-overlay-api-traceability/attribute-convention.md](../plans/260519-1439-qa-overlay-api-traceability/attribute-convention.md).

---

<a id="docs-screens-bds-filter-location-md"></a>

## docs/screens/bds-filter-location.md

---
title: BDS Filter — Address Search section (Tỉnh + Huyện cascade)
type: design-spec
level: detailed
phase: 03
audience: Pencil AI designer
date: 2026-04-20
related:
  - plans/260420-1326-address-search-bds-filter/plan.md
  - plans/reports/brainstorm-260420-1326-address-search-bds-filter.md
  - docs/screens/phase-03-screens.md (parent spec §Filter sidebar)
  - docs/02-api-catalog.md (§6 Search & Location)
supersedes_partial: docs/screens/phase-03-screens.md §"Khu vực (cascade)" — Xã (ward) defer phase 2
ref_ux: https://tongkhobds.com/ (hero search)
---

# BDS Filter — Address Search Section

Detailed design spec cho section "Địa điểm" trong filter sidebar của BDS list (`/bds/mua-ban`, `/bds/cho-thue`).

## Context

- Reference UX: [tongkhobds.com](https://tongkhobds.com) hero search "Tìm kiếm địa điểm, quận huyện..." với dropdown phân cấp + preset top tỉnh thành
- Agent webapp dùng dashboard-only — **không có hero**; search nằm trong **filter sidebar** cạnh list
- Phase 1: **Tỉnh + Huyện** (BE đã có endpoint). **Xã (ward) defer** — BE chưa expose endpoint + filter param
- URL state đã tồn tại từ Phase 03 core: `city_id`, `district_id`, `keyword`

## Purpose

Cho agent filter BDS theo địa bàn + freeform keyword (tên đường, dự án, building).

## Placement trong Filter Sidebar

Section "Địa điểm" đặt **trên cùng**, trước `property_types`:

```
┌─ Filter sidebar (280px desktop) ────────┐
│ ⚙ Bộ lọc      [3]                        │
│                                          │
│ ─────── ĐỊA ĐIỂM ───────                │ ← NEW section
│ [🔍 Tên đường, dự án...              ]  │
│                                          │
│ Tỉnh/Thành                              │
│ [Chọn tỉnh/thành             ▾ ]        │
│                                          │
│ Quận/Huyện                              │
│ [Chọn tỉnh trước             ▾ ] (disabled)│
│ ──────────────────                       │
│                                          │
│ LOẠI BDS                                 │ ← existing sections
│ ☐ Bán căn hộ chung cư          (245)    │
│ ...                                      │
└──────────────────────────────────────────┘
```

## Components

### 1. Keyword input (freeform)

- Input với search icon prefix
- Placeholder: `"Tên đường, dự án..."`
- Debounce **400ms** → URL param `?keyword=`
- Max chars: no limit; auto-trim whitespace
- Empty state: no special styling

### 2. Tỉnh/Thành combobox (cascading parent)

- Trigger: button full-width, variant="outline"
  - Default: placeholder `"Chọn tỉnh/thành"` (text muted)
  - Selected: tên tỉnh (e.g., `"Hà Nội"`) + X clear button
  - Chevron ▾ luôn ở phải
- Dropdown:
  - Width: match trigger
  - Command input top: `"Tìm kiếm..."` (substring, diacritic-insensitive → "ha noi" match "Hà Nội")
  - List: 63 tỉnh preloaded (TQ cache, staleTime: Infinity)
  - Item: checkmark prefix (visible nếu selected) + tên tỉnh
  - Empty text: `"Không tìm thấy tỉnh phù hợp"`
  - Loading state: `"Đang tải..."` (muted, padded)
  - Max height: scroll sau 10 items

### 3. Quận/Huyện combobox (cascading child)

- Trigger: giống Tỉnh, nhưng:
  - **Disabled** khi `city_id` rỗng → placeholder `"Chọn tỉnh trước"`
  - Enabled khi đã chọn tỉnh → placeholder `"Chọn quận/huyện"`
- Behavior:
  - Đổi tỉnh → district value **clear tự động**
  - Districts fetched on-demand: `useDistricts(cityId)` — 10min cache
  - Filter client-side diacritic-insensitive tương tự Tỉnh

### Active chips (top of results area)

Extended từ existing chips system (`use-bds-active-chips.ts`):

| Chip | Label format | Remove action |
|---|---|---|
| Keyword | `"vinhomes"` (truncate 30ch) | Clear `keyword` only |
| Tỉnh | `Hà Nội` | Clear `city_id` + `district_id` (cascade) |
| Huyện | `Cầu Giấy` | Clear `district_id` only |

## Visual States

### Combobox trigger states

| State | Visual |
|---|---|
| Empty (default) | Placeholder text muted, chevron only |
| Selected | Label color=foreground, X button + chevron right |
| Hover | Border = primary/40 |
| Focus | Ring primary, outline |
| Disabled | Opacity 50%, cursor not-allowed, placeholder "Chọn tỉnh trước" |
| Open (popover shown) | `aria-expanded=true`, subtle border color change |

### Dropdown (popover)

| State | Content |
|---|---|
| Loading | Centered muted text `"Đang tải..."` with spinner |
| Populated | Command input + item list with checkmarks |
| Filtering (query typed) | List filtered client-side |
| Empty match | `"Không tìm thấy..."` muted text |
| Error | (rare) Fallback: hidden dropdown + toast error |

### Keyword input states

| State | Visual |
|---|---|
| Empty | Placeholder muted |
| Typing (before debounce flush) | Border focus, no spinner |
| Applied | URL updated, list reloaded (no visual marker on input) |

## Interaction Flow

```
User lands on /bds/mua-ban
  │
  ▼
[Type "vinh" in keyword]
  └─► 400ms later → URL becomes /bds/mua-ban?keyword=vinh → list refetch
  
[Click Tỉnh trigger]
  └─► Popover opens, 63 provinces shown (cached from first open)
  
[Type "ha" in command input]
  └─► Client filter: "Hà Nội", "Hà Nam", "Hà Tĩnh", "Hà Giang"...
  
[Click "Hà Nội"]
  └─► Popover closes
  └─► URL += city_id=01
  └─► district_id cleared if previously set
  └─► Huyện combobox enables
  └─► Chip "Hà Nội" appears
  
[Click Huyện trigger]
  └─► Popover opens, spinner briefly, then districts of Hà Nội
  
[Click "Cầu Giấy"]
  └─► URL += district_id=007
  └─► Chip "Cầu Giấy" appears
  
[Click X on Tỉnh chip]
  └─► city_id + district_id both cleared
  └─► Huyện combobox disables
  └─► Both chips removed
```

## Responsive

Inherit từ parent sidebar (`phase-03-screens.md` §Responsive):

- **Desktop (≥1024px)**: Sidebar fixed 280px, section render đầy đủ stack vertical
- **Tablet (768-1023px)**: Sidebar collapsible, section giữ nguyên structure
- **Mobile (<768px)**: Sidebar → Sheet drawer bottom; section đầu tiên khi mở sheet

## A11y

- Mỗi combobox có `<label>` liên kết qua `htmlFor` / `aria-label`
- Trigger button: `role="combobox"`, `aria-expanded`, `aria-controls`
- Keyword input: `aria-label="Từ khóa tìm kiếm"`
- Keyboard:
  - Tab/Shift+Tab di chuyển giữa 3 controls
  - Space/Enter mở combobox
  - Arrow ↑↓ điều hướng items
  - Enter select, Escape close
  - Type-to-search trong popover

## Design Tokens

Reuse tokens từ `docs/screens/design-tokens.md`:

- Border: `border` (default), `border-primary/40` (hover), `ring-primary` (focus)
- Text: `foreground` (selected), `muted-foreground` (placeholder, labels)
- Label (section + field): `font-semibold text-[11px] text-muted-foreground uppercase tracking-wider`
- Field label (Tỉnh/Huyện): `font-medium text-[12px] text-muted-foreground`
- Height: combobox trigger = button default (36px), input keyword = 36px
- Gap: `gap-3` giữa controls, `gap-1.5` giữa label + control

## API Dependencies

| API | Used by | Notes |
|---|---|---|
| `GET /api_common/location_searching_by_province.json?text=` | `useProvinces()` | 63 tỉnh; cache `staleTime: Infinity`; shape TBD verify |
| `GET /api_customer/search_districts.json?id=<city_id>` | `useDistricts(cityId)` | Per-province; cache 10min; param name TBD verify |
| `GET /api_agent/real_estate_v2.json?keyword=&city_id=&district_id=` | BDS list refetch | Existing, already wired |

BE open questions tracked trong `docs/03-be-questions.md` §Location Search APIs (phase 01 task).

## Out of Scope (Phase 2)

- **Xã (ward)** — BE chưa có `search_wards.json` + `ward_id` filter
- **"Top tỉnh nổi bật"** preset chips (HN/HCM/HP/ĐN/CT) như tongkhobds.com
- **Recent searches** (localStorage)
- **Map-based / radius search** (`real_estate_map.json`) — tách brainstorm riêng
- **Province/district count badges** (BE không trả count)
- **Topbar global hero search** (chỉ sidebar trong phase này)

## Success Criteria

- [ ] Pencil AI designer có đủ context để design static mockup (desktop + mobile)
- [ ] Mockup thể hiện được: default/selected/disabled/open/empty states
- [ ] Chip system extend seamlessly với existing chips row
- [ ] Visual consistent với design-tokens + shadcn component library đang dùng

## Unresolved

1. Có cần **divider line** giữa section "Địa điểm" và section "Loại BDS" không? → đề xuất: có (`h-px bg-border`) để tách visual
2. Khi keyword rỗng nhưng có tỉnh/huyện → hiển thị count chip total filter trong header như `[3]` hay chỉ đếm selected controls?
3. Mobile sheet drawer: section "Địa điểm" có sticky top không khi scroll dài?

---

<a id="docs-screens-component-library-md"></a>

## docs/screens/component-library.md

---
title: Component Library — Cross-feature reusable components & rules
type: design-system
date: 2026-04-28
audience: Pencil AI designer + FE devs + reviewers
related:
  - docs/screens/design-tokens.md
  - docs/screens/xac-thuc-bds-screens.md
  - docs/screens/nhu-cau-screens.md
  - docs/screens/khach-hang-screens.md
source_designs:
  - Design/xac_thucbds.pen
  - Design/nhu cau.pen
---

# Component Library — Quy định dùng chung

Tập hợp **rules + canonical reusable patterns** cross-feature. Mọi `.pen` mới + screen mới **phải** tuân thủ. Đây là single source of truth cho mobile/desktop shell, atomic components, modal/sheet pattern và token naming trong file `.pen`.

> ⚠️ **Trước mọi screen mới**: đọc file này + `design-tokens.md` + screen spec của module liên quan.

---

## 1. Audit findings (28/04/2026)

So sánh `Design/xac_thucbds.pen` ↔ `Design/nhu cau.pen` phát hiện divergence cần fix:

| Aspect | `xac_thucbds.pen` | `nhu cau.pen` | Canonical (must-use) |
|---|---|---|---|
| Token system | Hardcoded hex (`#FFFFFF`, `#F7F8FA`, `#E5E7EB`) | Pen vars (`$bg-page`, `$surface`, …) | **Pen vars** (xem §3) |
| Card bg name | `#FFFFFF` | mix `$bg-card` + `$surface` | **`$surface`** |
| Page bg name | `#F7F8FA` | mix `$bg-page` + `$bg` | **`$bg`** |
| Border name | `#E5E7EB` | mix `$border-muted` + `$border` | **`$border`** |
| Card radius | hardcoded 10/12/14 | `$radius-md` | **`$radius-md`** (=6) cho input/button, **`$radius-xl`** (=12) cho card/modal |
| Mobile App Bar h | 52 | 56 | **56** |
| Mobile FS Footer h | (varies) | 72 | **72** |
| Modal backdrop | `#00000066` + `#11182766` | `#0F172A66` | **`$overlay`** = `#0F172A66` |
| Modal sheet shadow | `blur:24, y:-4, color:#00000026` | `blur:32, y:-8, color:#00000026` | tách 2 token: **`shadow-sheet-up`** vs **`shadow-modal`** (xem §4.6) |
| Sheet bg | `#FFFFFF` | `$surface` | **`$surface`** |
| Brand button color | (đa dạng) | `$accent-indigo` cho FAB/Search/Filter btn | ⚠️ **`$primary` (orange)** — `$accent-indigo` chỉ dùng cho info badge, không dùng cho primary CTA |

**Divergence khác đáng lưu ý**:

- `nhu cau.pen` dùng `$accent-indigo` cho FAB + button "Search/Filter/Tạo" → **mâu thuẫn brand** (primary đã đổi sang orange `#fb923c` từ 2026-04-18). Cần migrate sang `$primary`.
- `xac_thucbds.pen` không dùng variables → khi brand đổi màu sẽ phải sửa thủ công toàn file.
- `nhu cau.pen` có 2 alias cho cùng 1 màu (`$bg-card` ≡ `$surface`, `$border-muted` ≡ `$border`, `$bg-page` ≡ `$bg`) → gây nhầm lẫn, cần rút về 1 tên duy nhất.

---

## 2. Action plan (cho designer + dev)

### 2.1 Đối với file `.pen` mới
- ✅ Bắt buộc dùng Pen vars theo §3. Tuyệt đối **không** hardcode hex (trừ cases liệt kê ở `design-tokens.md` §"Hardcoded colors NOT token").
- ✅ Bắt buộc dùng reusable components ở §4 thay vì draw lại từ frame primitive.

### 2.2 Đối với 2 file hiện tại
Refactor (priority cao → thấp):

**P0** — `nhu cau.pen`:
- Thay `$accent-indigo` (primary CTA) → `$primary` ở: btn Filter, btn Search, btn TẠO, FAB, action buttons trong modal.
- Rút aliases: `$bg-card` → `$surface`, `$border-muted` → `$border`, `$bg-page` → `$bg`. (Search-replace toàn file.)
- Modal backdrop: giữ `#0F172A66` → đặt vào var `$overlay`.

**P1** — `xac_thucbds.pen`:
- Thay tất cả `#FFFFFF` → `$surface`, `#F7F8FA` → `$bg`, `#E5E7EB` → `$border`.
- Thay cornerRadius hardcoded: 10 → `$radius-lg` (8) hoặc `$radius-xl` (12) tùy ngữ cảnh (card mobile = lg, modal = xl).
- Modal backdrop `#00000066` / `#11182766` → `$overlay`.

**P2** — Cả hai file:
- Replace App Bar/Status Bar/Footer/Tab bằng reusable components ở §4.

### 2.3 Đối với code (FE)
Tạo các common components ở §6 — hiện đang thiếu, mỗi feature self-implement → drift.

---

## 3. Canonical Pen variables (`.pen` files)

Chuẩn này khớp 1-1 với CSS vars trong `src/app/globals.css`. Khi designer định nghĩa biến trong `.pen`, **phải dùng đúng tên dưới đây** (không tự sinh alias).

### 3.1 Color

| Pen var | Hex (light) | CSS var | Usage |
|---|---|---|---|
| `$bg` | `#F7F8FA` | `--background` | Page background |
| `$surface` | `#FFFFFF` | `--card` | Card, modal, sheet, input bg, app bar, footer fixed |
| `$surface-muted` | `#F3F4F6` | `--muted` | Hover state, back btn, tab inactive |
| `$border` | `#E5E7EB` | `--border` | Default border, divider |
| `$border-strong` | `#D1D5DB` | `--border-strong` | Input border, checkbox border |
| `$text-primary` | `#111827` | `--foreground` | Heading, body |
| `$text-secondary` | `#4B5563` | `--muted-foreground` | Subtitle, label |
| `$text-muted` | `#9CA3AF` | — | Placeholder, helper, icon idle |
| `$text-muted-2` | `#94A3B8` | `--text-muted-2` | Disabled meta, separator dot |
| `$text-inverse` | `#FFFFFF` | `--primary-foreground` | Text on primary CTA |
| `$primary` | `#FB923C` | `--primary` | **Primary CTA**, brand orange |
| `$primary-hover` | `#F97316` | `--primary-hover` | Button hover |
| `$primary-soft` | `#FFEDD5` | `--primary-soft` | Soft fill (active tab, badge bg, sidebar item active) |
| `$success` | `#10B981` | `--success` | Success state, "Đặt cọc ngay" CTA |
| `$success-soft` | `#D1FAE5` | `--success-soft` | Success badge bg |
| `$warning` | `#F59E0B` | `--warning` | Warning, "Chờ xác nhận" status |
| `$warning-soft` | `#FEF3C7` | `--warning-soft` | KYC banner, warning bg |
| `$danger` | `#EF4444` | `--destructive` | Error, "Từ chối" status |
| `$danger-soft` | `#FEE2E2` | `--destructive-soft` | Error bg |
| `$info` | `#3B82F6` | `--info` | Info badge, "Chờ phê duyệt" status, "Tạo giao dịch" CTA |
| `$overlay` | `#0F172A66` | — | Modal/sheet backdrop (40% slate-900) |

> ❌ **DEPRECATED** trong `.pen` — không dùng nữa: `$bg-card` (→ `$surface`), `$bg-page` (→ `$bg`), `$border-muted` (→ `$border`), `$accent-indigo` cho CTA (→ `$primary`). `$accent-indigo` chỉ giữ làm alias info/decorative nếu cần.

### 3.2 Radius

| Pen var | px | Usage |
|---|---|---|
| `$radius-sm` | 4 | Checkbox, small chip |
| `$radius-md` | 6 | **Input, button, OTP digit, filter pill** |
| `$radius-lg` | 8 | List item card mobile, logo badge |
| `$radius-xl` | 12 | **Card desktop, modal, sheet, tab card** |
| `$radius-pill` | 999 | Pill badge, FAB, status chip |

### 3.3 Shadow

| Pen var | Value | Usage |
|---|---|---|
| `$shadow-card` | `blur:24 offset:0,4 color:#0000000D` | Card, OTP modal, forgot card |
| `$shadow-sheet-up` | `blur:24 offset:0,-4 color:#0000001A` | Mobile bottom sheet, fixed footer (shadow lên trên) |
| `$shadow-modal` | `blur:32 offset:0,8 color:#00000026` | Desktop modal, dialog, popup |
| `$shadow-fab` | `blur:16 offset:0,6 color:$primary @ 33%` | FAB only (đổi từ indigo → primary alpha) |

---

## 4. Reusable components canonical spec

Tất cả `.pen` files **phải** define các components dưới đây dạng reusable (ID không bắt buộc match nhưng `name` phải khớp). Hoặc copy từ `Design/_design-system.pen` (TODO: tạo file dùng chung).

### 4.1 Mobile Status Bar
- **Name**: `StatusBar`
- **Spec**: height 32, fill `$surface`, padding `[0,16]`, layout horizontal, alignItems center, justifyContent space_between
- **Children**: time text 14/600 left + signal/wifi/battery icons right (12×12)

### 4.2 Mobile App Bar
- **Name**: `AppBar`
- **Spec**: height **56** (chuẩn — không dùng 52), fill `$surface`, padding `[0,12]`, gap 8, border-bottom 1 `$border`
- **Slots**: leading icon-btn 40×40 (back/menu) | title 16/600 `$text-primary` (fill_container) | trailing icon-btn(s) 40×40
- **Variant** `AppBar/Centered`: justifyContent center, title centered

### 4.3 Mobile Bottom Footer (Fixed)
- **Name**: `FooterFixed`
- **Spec**: height **72**, fill `$surface`, padding `[12,16,16,16]`, gap 10, border-top 1 `$border`, effect `$shadow-sheet-up`, layoutPosition absolute, x:0 y:(parentH-72), width = device width
- **Usage**: action bar trong detail/form mobile (ví dụ "Phê duyệt / Từ chối")

### 4.4 Page Body (Mobile)
- **Name**: `PageBody`
- **Spec**: layout vertical, fill `$bg`, gap 10, padding `[12,12,80,12]` (80 = 72 footer + 8 buffer khi có FooterFixed; nếu không có thì padding-bottom 12)
- **width**: `fill_container`

### 4.5 Desktop Page Shell
- **Name**: `PageShell`
- **Spec**: width 1520, padding `[24,28,32,28]`, fill `$bg`, gap 16, layout vertical
- **Standard sections** (top → bottom):
  1. Breadcrumb (gap 6, padding `[0,4,4,4]`)
  2. Page Header (gap 14, padding `[0,4]`, alignItems center)
  3. Filter Bar / Stats Strip (height 64, fill `$surface`, radius `$radius-xl`, border 1 `$border`)
  4. Tabs Card (fill `$surface`, padding `[4,20,0,20]`, radius `$radius-xl`, border 1 `$border`)
  5. Action Pills (chỉ hiện khi có selection)
  6. Content Card / Table Card (fill `$surface`, radius `$radius-xl`, border 1 `$border`, clip true)
  7. Pagination (height 40, justifyContent space_between)

### 4.6 Modal / Bottom Sheet

| Component | Use | Spec |
|---|---|---|
| `Modal/Backdrop` | wrapper | fill `$overlay`, layout none, full viewport |
| `Modal/Dialog` | desktop | fill `$surface`, radius `$radius-xl`, effect `$shadow-modal`, padding inside body 20-24, gap 16, justifyContent center trong backdrop |
| `Sheet/Bottom` | mobile | fill `$surface`, cornerRadius `[16,16,0,0]`, effect `$shadow-sheet-up`, layout vertical, layoutPosition absolute bottom, width = device width |
| `Sheet/Header` | both | height 56, padding `[0,16]`, border-bottom 1 `$border`, layout horizontal, alignItems center, gap 8. Slots: leading close-btn 32×32 | title 16/700 fill_container | trailing action |
| `Sheet/Footer` | both | height 72, padding `[12,16,16,16]`, gap 10, border-top 1 `$border`, layout horizontal |

### 4.7 Status Badge

Pill chip dùng cho status enum trên card/row.

- **Spec**: height 22, padding `[0,10]`, radius `$radius-pill`, layout horizontal, alignItems center, gap 4, font 11/600
- **Variants** (`name = StatusBadge/<variant>`):

| Variant | Bg | Text | Use |
|---|---|---|---|
| `pending` | `$warning-soft` `#FEF3C7` | `#92400E` | Chờ gán, Chờ xác nhận |
| `info` | `#DBEAFE` | `#1E40AF` | Chờ phê duyệt |
| `success` | `$success-soft` `#D1FAE5` | `#065F46` | Thành công, Đã chốt |
| `danger` | `$danger-soft` `#FEE2E2` | `#991B1B` | Từ chối, Hủy |
| `neutral` | `$surface-muted` | `$text-secondary` | Mới, Default |
| `accent` | `$primary-soft` | `$primary` | Active tab badge, count badge |

### 4.8 Buttons

| Variant | Height | Bg | Border | Text | Use |
|---|---|---|---|---|---|
| `primary` | 44 | `$primary` | — | 14/600 `$text-inverse` | Primary CTA (Đăng nhập, Lưu, Xác nhận) |
| `success` | 44 | `$success` | — | 14/600 `$text-inverse` | Đặt cọc ngay |
| `info` | 44 | `$info` | — | 14/600 `$text-inverse` | Tạo giao dịch |
| `outline` | 44 | `$surface` | 1 `$border-strong` | 14/600 `$text-primary` | Secondary action |
| `outline-primary` | 44 | `$surface` | 1 `$primary` | 14/600 `$primary` | "+ Tạo" trong filter bar |
| `outline-info` | 44 | `$surface` | 1 `$info` | 14/600 `$info` | Đặt lịch hẹn |
| `ghost` | 44 | transparent | — | 14/500 `$text-secondary` | Cancel, Quay lại |
| `icon-btn` | 40×40 | `$surface-muted` (idle) | — | icon 18 `$text-secondary` | App bar leading/trailing |

Radius mặc định `$radius-md`. Padding `[0,16]`. Khi có icon: gap 8, icon 16×16.

### 4.9 Tabs

- **Container**: layout horizontal, gap 24-32, padding `[0,20]`, fill `$surface`, border-bottom 1 `$border`
- **Tab item**: height 44 (mobile) / 48 (desktop), padding `[12,0]`, gap 8, layout horizontal
  - Label: 14/600 active `$text-primary`, 14/500 inactive `$text-secondary`
  - Count badge: `StatusBadge/accent` (active) hoặc `StatusBadge/neutral` (inactive)
  - Underline (active): height 2, fill `$primary`, position bottom `0,-1`

### 4.10 Filter Pills (multi-select chips)

- **Container** (`FilterChipsRow`): layout horizontal, gap 8, padding `[4,4,0,4]`, scroll horizontal mobile
- **Chip** (`FilterChip`): height 36, radius `$radius-md`, padding `[0,16,0,14]`, gap 8, layout horizontal alignItems center
  - Idle: fill `$surface`, border 1 `$border`, text 13/500 `$text-secondary`
  - Active: fill `$primary-soft`, border 1 `$primary`, text 13/600 `$primary`
  - Trailing X icon (active only): 14×14

### 4.11 List Item Card (mobile)

Áp dụng cho card BDS, card Nhu cầu, card KH, card Xác thực.

- **Spec**: layout vertical, padding 12, gap 8, fill `$surface`, radius `$radius-lg`, border 1 `$border`, width fill_container
- **Row 1**: thumbnail 64×64 radius `$radius-md` + (vertical fill) title 14/600 + subtitle 12/400 `$text-secondary`
- **Row 2**: price 16/700 `$primary` + StatusBadge
- **Row 3**: meta chips (icon 12 + text 12/400 `$text-muted`), gap 6
- **Row 4**: timestamp 11/400 `$text-muted-2` + age dot (8×8 radius full, color theo độ tươi)
- **Trailing action**: icon-btn "..." top-right (absolute, x: parentW-32, y: 12)

### 4.12 Section Header (trong detail)

- **Spec**: layout horizontal, padding `[0,4]`, alignItems center, justifyContent space_between, gap 8
- Title 14/700 `$text-primary` (left) | optional action link 13/500 `$primary` (right)

---

## 5. Cross-screen rules (must-follow)

1. **Mobile-first**: mọi screen mới design mobile trước (390 width), scale lên desktop bằng `sm:` / `lg:`. Memory rule.
2. **Token-only**: KHÔNG hardcode hex, radius, shadow trong `.pen` (trừ list được liệt kê ở `design-tokens.md` §"Hardcoded colors NOT token").
3. **Capitalize display text**: tên người, địa chỉ, tiêu đề render với First Letter Upper Each Word (memory rule).
4. **App bar height = 56** mobile, **footer fixed = 72** mobile, không tự ý đổi.
5. **Modal/Sheet**:
   - Desktop = Dialog (centered, `$shadow-modal`)
   - Mobile = Bottom Sheet (cornerRadius `[16,16,0,0]`, `$shadow-sheet-up`)
   - Backdrop luôn `$overlay`
6. **Primary CTA** = `$primary` (orange). Indigo chỉ dùng cho info/decorative, **không** dùng cho FAB/Search/CTA.
7. **Status enum mapping** (xác thực + nhu cầu + giao dịch):
   - Chờ gán / Chờ xác nhận → `StatusBadge/pending`
   - Chờ phê duyệt → `StatusBadge/info`
   - Thành công / Đã chốt → `StatusBadge/success`
   - Từ chối / Hủy → `StatusBadge/danger`
   - Mới / Default → `StatusBadge/neutral`
8. **Vietnamese only**: UI text bằng tiếng Việt, không trộn EN. Error/empty state cũng Việt.
9. **Density**: card padding 12 mobile / 16 desktop. Section gap 16 desktop / 10-12 mobile.
10. **Icon font**: Lucide. Sizes: 12 (meta chip), 14 (status), 16 (button), 18 (app bar), 20 (section), 24 (FAB).

---

## 6. Code reusable components (FE roadmap)

Các component sau **chưa tồn tại** trong `src/components/` và đang bị self-implement repeat ở mỗi feature. Tạo theo thứ tự priority để tránh drift.

### 6.1 P0 (cần ngay khi impl Xác thực BDS + refactor Nhu cầu)

| Path | Purpose |
|---|---|
| `src/components/common/status-badge.tsx` | `<StatusBadge variant="pending\|info\|success\|danger\|neutral\|accent">` — wrap shadcn `Badge` với variant map |
| `src/components/common/page-header.tsx` | Desktop page header: breadcrumb + title + actions slot (đang lặp ở Nhu cầu, BDS list, KH list) |
| `src/components/common/mobile-app-bar.tsx` | h-14 sticky top, slots `leading` + `title` + `trailing` |
| `src/components/common/mobile-fixed-footer.tsx` | h-18 fixed bottom với shadow-sheet-up |
| `src/components/common/empty-state.tsx` | Icon + title + description + optional action (đang lặp khắp nơi) |
| `src/components/common/list-item-card.tsx` | Mobile card 4-row pattern (§4.11) — generic shell, content slot |

### 6.2 P1

| Path | Purpose |
|---|---|
| `src/components/common/section-header.tsx` | §4.12 |
| `src/components/common/filter-chip.tsx` | (đã có `tag-filter-chip-body.tsx` — generalize sang `filter-chip.tsx` với active/idle) |
| `src/components/common/action-bar.tsx` | Sticky footer chứa primary + secondary buttons |
| `src/components/common/skeleton-list.tsx` | Loading 3-skeleton cho list mobile/desktop |

### 6.3 P2

| Path | Purpose |
|---|---|
| `src/components/common/stats-strip.tsx` | Horizontal stats row (đang dùng ở Nhu cầu desktop detail + sẽ dùng ở Xác thực dashboard) |
| `src/components/common/responsive-modal.tsx` | Wrap shadcn `Dialog` (desktop) + `Drawer/Sheet` (mobile) auto-switch theo viewport |

> **Convention**: tất cả common components dùng kebab-case filename, PascalCase export, props interface tên `<Component>Props`. Đặt props "minimal & composable" — slot-based thay vì prop-explosion.

---

## 7. Implementation checklist khi impl screen mới

```
[ ] Đọc docs/screens/component-library.md (file này)
[ ] Đọc docs/screens/design-tokens.md
[ ] Đọc screen spec module (docs/screens/<feature>-screens.md)
[ ] Xác nhận mobile-first wireframe trước
[ ] Reuse components ở §6 — không tự implement lại
[ ] Tokens-only — không hardcode color/radius/shadow
[ ] Status enum dùng StatusBadge variants ở §4.7
[ ] CTA = $primary (orange), không $accent-indigo
[ ] Capitalize display text (Họ Tên, địa chỉ, tiêu đề)
[ ] Test mobile 390 + desktop ≥1280 trước khi commit
```

---

## 8. Unresolved / TODO

- Tạo file `Design/_design-system.pen` chứa tất cả reusable components ở §4 → import vào các file feature qua `imports` block (Pen schema hỗ trợ).
- Migrate `Design/xac_thucbds.pen` từ hardcoded → tokens (P1).
- Migrate `Design/nhu cau.pen`: replace `$accent-indigo` CTA → `$primary`, rút aliases (P0).
- Code: scaffold `src/components/common/status-badge.tsx` + `mobile-app-bar.tsx` + `page-header.tsx` (§6.1).
- Confirm với BE: status enum exact label cho từng feature (xác thực vs nhu cầu vs giao dịch) — hiện inferred.

---

<a id="docs-screens-design-tokens-md"></a>

## docs/screens/design-tokens.md

---
title: Design Tokens — extracted từ Design/phase 2 - 3.pen
type: design-tokens
date: 2026-04-18
last_synced: 2026-04-28 (audit cross-feature, thêm Pen var canonical naming)
source: Design/phase 2 - 3.pen
audience: FE devs (Tailwind v4 + shadcn/ui) + Pencil designer
related:
  - docs/screens/component-library.md
  - docs/screens/phase-02-screens.md
  - docs/screens/phase-03-screens.md
  - plans/260417-1558-webapp-agent-mvp/phase-02-auth-and-session.md
  - plans/260417-1558-webapp-agent-mvp/phase-03-bds-projects-sales-board.md
---

# Design Tokens

Source: `Design/phase 2 - 3.pen` (extract qua Pencil MCP).

Map sang Tailwind v4 `@theme` block trong `src/app/globals.css`.

> **Update 2026-04-18 08:55**: Brand đổi từ blue (`#0062FF`) sang **orange** (`#fb923c` — Tailwind `orange-400`). `primary-hover` và `primary-soft` cũng đồng bộ. Các tokens khác KHÔNG đổi.
>
> **Update 2026-04-28**: Thêm canonical Pen variable naming + cross-feature rules. Xem [`component-library.md`](./component-library.md) để biết:
> - Reusable component spec (App Bar, Footer, Card, Modal, StatusBadge, Buttons, Tabs, Filter Pills…)
> - Cross-screen rules (mobile-first, primary CTA = orange, status enum mapping)
> - Code components roadmap (`src/components/common/*`)
>
> **Deprecated aliases trong `.pen`** (không dùng nữa): `$bg-card` → `$surface`, `$bg-page` → `$bg`, `$border-muted` → `$border`. `$accent-indigo` chỉ giữ cho info/decorative, KHÔNG dùng cho primary CTA/FAB.

## Colors

| Token | Hex | Tailwind alias | Usage |
|---|---|---|---|
| `bg` | `#F7F8FA` | `bg-background` | Page background |
| `surface` | `#FFFFFF` | `bg-card` / `bg-popover` | Card, modal, input bg |
| `surface-muted` | `#F3F4F6` | `bg-muted` | Back button bg, hover state |
| `border` | `#E5E7EB` | `border-border` | Default borders, dividers |
| `border-strong` | `#D1D5DB` | `border-input` | Input borders, checkbox |
| `text-primary` | `#111827` | `text-foreground` | Headings, body |
| `text-secondary` | `#4B5563` | `text-muted-foreground` | Subtitles, labels |
| `text-muted` | `#9CA3AF` | `text-muted-foreground/60` | Placeholders, helper text, icon |
| `text-inverse` | `#FFFFFF` | `text-primary-foreground` | Text on primary button |
| `primary` | `#fb923c` | `bg-primary` | Buttons, links, active state, brand orange (Tailwind `orange-400`) |
| `primary-hover` | `#f97316` | `bg-primary/90` | Button hover (`orange-500`) |
| `primary-soft` | `#ffedd5` | `bg-primary/10` | Icon circle bg, sidebar active bg, spec icon bg (`orange-100`) |
| `success` | `#10B981` | `bg-success` | Strength meter, completed step |
| `success-soft` | `#D1FAE5` | `bg-success/10` | Success badge bg |
| `warning` | `#F59E0B` | `bg-warning` | KYC banner |
| `warning-soft` | `#FEF3C7` | `bg-warning/10` | Warning bg |
| `danger` | `#EF4444` | `bg-destructive` | Error states |
| `danger-soft` | `#FEE2E2` | `bg-destructive/10` | Error bg |
| `info` | `#3B82F6` | `bg-info` | Info badge |
| `heart` | `#EF4444` | `text-destructive` | Favorite icon |

## Typography

| Token | Value | Usage |
|---|---|---|
| `font-sans` | `Inter` | Desktop body, headings |
| `font-display` | `SF Pro Display` | **Mobile** body, headings (phase 08+ mobile screens) |
| `font-mono` | `Geist Mono` | OTP digits, code |

> **Mobile font rule (2026-04-29)**: Mobile screens (`< sm` breakpoint hoặc page mobile-only) dùng `font-display: 'SF Pro Display'` thay cho Inter. Map qua Tailwind utility `font-display`. Fallback stack: `'SF Pro Display', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`.

**Type scale (extract từ design):**

| Size | Weight | Usage examples |
|---|---|---|
| 11/normal | text-secondary | Helper "Độ mạnh: Mạnh" |
| 12/normal | text-muted | Divider "hoặc", help text "Cần trợ giúp?" |
| 12/500 | primary | Inline link "Quên mật khẩu?" |
| 13/normal | text-secondary | Subtitles, labels phụ, "Quay lại" |
| 13/500 | text-primary | Field labels "Số điện thoại", "Mật khẩu" |
| 13/600 | primary | "Đăng nhập" link footer forgot |
| 14/normal | text-primary | Input value text |
| 14/600 | text-inverse | Button label "Đăng nhập", "Xác nhận" |
| 14/600 | primary | Link "1900 633 683" |
| 16/700 | text-inverse | Logo "TK" badge |
| 20/600 | text-primary | Card heading "Đăng nhập" |
| 22/700 | text-primary | Modal heading "Nhập mã xác thực", OTP digit |
| 22/700 | text-primary | Card title "Quên mật khẩu", "Đặt mật khẩu mới" |

### Mobile type scale (SF Pro Display)

Áp dụng cho mobile screens — thay Inter bằng SF Pro Display, dùng các size sau (px):

| Size | Tailwind class | Usage examples |
|---|---|---|
| 10 | `text-[10px]` | Caption micro, badge mini, stats footer ở compact tree node |
| 11 | `text-[11px]` | Helper text, label chip, meta phụ |
| 12 | `text-xs` | Divider, helper "hoặc", timestamp, secondary meta |
| 13 | `text-[13px]` | Field label, subtitle, "Quay lại", body phụ |
| 14 | `text-sm` | Body text mặc định mobile, button label, input value |
| 15 | `text-[15px]` | Card title medium, list item primary text |
| 16 | `text-base` | Section heading mobile, modal body |
| 18 | `text-lg` | Page title mobile, card heading lớn |
| 24 | `text-2xl` | Hero number, metric value lớn, screen title chính |

Font weight giữ nguyên convention: `400 normal` (body), `500` (label/link inline), `600 semibold` (button/CTA/title nhỏ), `700 bold` (heading/metric).

## Border Radius

| Token | px | Tailwind | Usage |
|---|---|---|---|
| `radius-sm` | 4 | `rounded-sm` | Checkbox |
| `radius-md` | 6 | `rounded-md` | Input, button, OTP digit, back btn |
| `radius-lg` | 8 | `rounded-lg` | Logo badge |
| `radius-xl` | 12 | `rounded-xl` | Card, modal, sheet |
| 14 | 14 | `rounded-[14px]` | Stepper circle 28px (full = 14) |
| 32 | 32 | `rounded-full` | Icon circle 64px (full) |

## Shadow

| Use | Spec |
|---|---|
| Card / OTP modal / Forgot card | `blur:24, offset:0,4, color:#0000000D` (very subtle) → Tailwind `shadow-sm` hoặc custom `shadow: 0 4px 24px 0 rgba(0,0,0,0.05)` |
| Sheet / drawer (Owner Info, Interest Form) | `blur:32, offset:0,8, color:#00000026` → `shadow-2xl` |

## Sizing constants (auth screens)

| Element | Spec |
|---|---|
| Auth card | `width: 400, padding: 40, gap: 24` (Login), `gap: 20` (OTP), `gap: 22-24` (Forgot) |
| Input | `height: 44, padding: [0,14], gap: 10, border: 1 border-strong, radius: 6` |
| Input focused (OTP digit) | `border: 2 primary` (thay border-strong 1) |
| Input icon | `16x16, lucide, fill: text-muted` |
| Primary button | `height: 44, radius: 6, fill: primary, text: 14/600 inverse, gap: 8 (with icon)` |
| Logo badge | `40x40, radius: 8, fill: primary, text: TK 16/700 inverse` |
| Back button | `32x32, radius: 6, fill: surface-muted, icon: arrow-left 16` |
| Icon circle (modal) | `64x64, radius: 32, fill: primary-soft, icon: 28 primary` |
| OTP digit box | `44 width × 52 height, radius: 6, gap: 8 between, font: Geist Mono 22/700` |
| Stepper circle | `28x28, radius: 14, fill: primary (active) / surface (idle) / success (done)` |
| Stepper bar | `40 width × 2 height, fill: border (idle) / success (done)` |
| Strength meter segment | `height: 4, radius: 2, gap: 4` |
| Checkbox | `16x16, radius: 4, border: 1.5 border-strong` |

## Sizing constants (dashboard / list / detail screens)

| Element | Spec |
|---|---|
| Sidebar | `width: 240, padding: [20,16], gap: 4 (items), fill: surface, border-right: 1 border` |
| Topbar | `height: 60, padding: [0,24], fill: surface, gap: 16, border-bottom: 1 border` |
| Page padding | `padding: 24` (Body), `gap: 16` (sections) |
| Metric card | rounded-xl, padding similar, shadow-sm, value 22-28/700, label 13/normal text-secondary |
| List item card (BDS card) | rounded-lg, image 16:9 ratio top, body padding ~16, badges top-left |
| Table row height | ~52px, hover surface-muted |
| Filter sidebar (BDS list) | `width: ~280, gap: 16, sticky` |
| Wizard stepper bar | height 64, background surface, border-bottom 1 |
| Wizard footer bar | height 72, background surface, border-top 1, justify space-between |
| Sheet drawer (right side) | `width: 520-560, radius-xl, shadow-2xl, header 56-64, footer 72` |

## Spacing scale (suggest)

Phù hợp Tailwind default 4px scale: `4, 6, 8, 10, 12, 14, 16, 20, 24, 32, 40`.

## Iconography

- **Primary icon font**: Lucide (matching shadcn/ui default — `lucide-react`)
- Common icons used: `phone`, `lock`, `eye`, `eye-off`, `arrow-left`, `arrow-right`, `shield-check`, `timer`, `check`, `x`, `search`, `plus`, `bell`, `map-pin`, `building-2`, `users`, `briefcase`

## Tailwind v4 mapping (snippet for `globals.css`)

```css
@theme {
  --color-background: #F7F8FA;
  --color-card: #FFFFFF;
  --color-muted: #F3F4F6;
  --color-border: #E5E7EB;
  --color-input: #D1D5DB;
  --color-foreground: #111827;
  --color-muted-foreground: #4B5563;
  --color-primary: #fb923c;
  --color-primary-foreground: #FFFFFF;
  --color-success: #10B981;
  --color-warning: #F59E0B;
  --color-destructive: #EF4444;
  --color-info: #3B82F6;
  --radius-sm: 4px;
  --radius-md: 6px;
  --radius-lg: 8px;
  --radius-xl: 12px;
  --font-sans: Inter, system-ui, sans-serif;
  --font-display: 'SF Pro Display', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  --font-mono: 'Geist Mono', ui-monospace, monospace;
  --text-2xs: 10px;
  --text-xs2: 11px;
  --text-xs: 12px;
  --text-sm2: 13px;
  --text-sm: 14px;
  --text-base2: 15px;
  --text-base: 16px;
  --text-lg: 18px;
  --text-2xl: 24px;
}
```

## Multi-color CTA pattern (BDS Detail)

Design dùng buttons khác màu cho hierarchy ngữ nghĩa, KHÔNG chỉ primary outline. Ví dụ stack:

| Action | Token | Visual |
|---|---|---|
| Liên hệ đầu chủ | `primary` solid | Orange #fb923c — high attention |
| Đặt cọc ngay | `success` solid | Green #10B981 — positive commercial action |
| Tạo giao dịch | `info` solid | Blue #3B82F6 — neutral business action |
| Đặt lịch hẹn | `info` outline | Blue border + bg surface — secondary blue |
| Thêm vào nhu cầu | `border-strong` outline | Ghost — tertiary |

→ FE: shadcn `Button` cần custom variants `success`, `info`, `outline-info` (không có sẵn).

## Hardcoded colors (NOT token)

Một số element dùng màu literal (không bind token), giữ nguyên khi impl:

| Element | Color | Note |
|---|---|---|
| Owner Info Sheet header (`LinRA/joPii`) | `#F58229` | Brand warning orange (đậm hơn primary) — keep literal |
| Phase 08 title badge bg | `#FFF4D9` | Warm cream pill (khác warning-soft `#FEF3C7`) — Figma V1 |
| Phase 08 title badge text | `#92400E` | Warm brown (không dùng warning `#F59E0B` vì đã dùng cho pending state) |
| Phase 08 tree connectors | `#1E3A8A` | Navy blue 2px — distinct from body text |
| Hero icon-btn bg | `#FFFFFF33` | White 20% alpha overlay trên orange hero |
| Orange soft active | `#FFF4E6` | Stat card active bg + avatar circle bg — nhạt hơn `primary-soft` `#ffedd5` |
| Info soft (dollar icon bg) | `#DBEAFE` | Khác `info/10` — hardcoded cho Doanh số icon circle |

## Phase 08 mobile-specific tokens

Tokens mới được introduce ở phase 08 (Figma V1 mobile reference). **Thêm vào `@theme` block khi impl**:

```css
--color-title-pill-bg: #FFF4D9;
--color-title-pill-fg: #92400E;
--color-tree-line: #D1D5DB;
--color-tree-navy: #1E3A8A;
--color-hero-action-bg: rgba(255,255,255,0.2);
--color-khoi-badge-bg: #FFF4E6;
--color-khoi-badge-fg: #FB923C;
--color-search-navy-btn: #0B2253;
--color-cá-nhân-row-bg: #FFF4E6;
```

Component patterns specific phase 08:
- **Mobile hero header**: orange solid fill (có thể swap gradient `linear-gradient(180deg, #FB923C, #F97316)` sau này), height 92 (status 32 + header 56 + padding top 4)
- **Circle icon button trên hero**: 40x40, radius 20 (full circle), fill `#FFFFFF33`, icon 18px white
- **Floating profile card**: radius 16, padding [14,16,20,16], shadow-sm `{offset:0,2 blur:12 color:#0000000D}`
- **Compact tree node card** (mobile tree view): 118x62 (children) / 190x68 (root), radius 8, stats footer 9-10px font
- **Zoom control stack**: 48x132 rounded-full pill, 3x buttons 32x32 rounded-full inside

## Phase 08 Desktop TN Dashboard — specific patterns

**Table structure** (ref: `Design/phase08.pen` frame "Desktop — TN Dashboard tổng quan"):

### Column widths (fixed for alignment)
```
STT 48 | Name 250 | Hot 30 | GĐK 70 | TP 70 | CTV 70 | NH 110 | GD 100 | DS 110 | Phân loại 80 | Thao tác fill
```

### Row types + styling
| Type | Bg | Avatar | Badge | Height |
|---|---|---|---|---|
| Khối team header | White | None | "Khối" cream/orange | 56-60 |
| Phòng team header | White | None | "Phòng" cream/orange | 56 |
| GĐK/TP cá nhân | Orange `#FFF4E6` from c2 | 28 circle primary-outline | (no structural badge) | 56 |
| CTV leaf | White | 28 circle gray/cream | (no badge) | 56 |

### Tree lines (2 levels, color `#D1D5DB`)
- **Level 1**: vline at `x=2` inside c1, hline bend at `y=28 x=3 w=20`
- **Level 2**: vline at `x=23`, hline bend at `y=28 x=24 w=16`
- Last child → vline half-height (h=29), others full (h=56)
- Bottom border mask: white rect at c1 `y=54 h=2` hides row bottom stroke in tree area

### Grouping rule
Team row + cá nhân row = paired block (no divider between them). Applies recursively at every level where parent has children (Khối+GĐK, Phòng+TP). CTV leaf = single row only.

### Badge placement
- "Khối"/"Phòng" badge placed **BEFORE** name in nm frame (index 0)
- Name text: `textGrowth: "fixed-width"`, width 150 (ensures Hot column alignment)
- Badge style: radius 8, fill `#FFF4E6`, padding [1,6], text 9/600 orange `#FB923C`

### Data conventions
- GĐK/TP/CTV count: single digit "0"/"1"/"2" (not "00"/"01"/"02")
- Nguồn hàng: plain number (no "BDS" suffix) — e.g., "150" not "150 BDS"
- Doanh số: "{X} tỉ" format, orange `#FB923C`, weight 600-700
- Plus button (Phân loại): 24x24 radius 12, border 1 gray, icon plus 12x12 muted

### Title progress card (Trạng thái danh hiệu)
Horizontal card, padding 16, radius 8, border 1 gray:
- Left: award badge 56x56 cream `#FFF4D9` + icon `award` 28px brown `#B45309` + label "Danh hiệu hiện tại" + title bold 16/700
- Right: `{progress label}` + next title bold 14/700 + "{+N%}" primary 14/700 right | progress bar h=10 radius=5 | footer text (current metric) + (target diff)

## shadcn/ui mapping cheatsheet

| Design element | shadcn component |
|---|---|
| Auth card | `Card` (custom padding 40, radius `rounded-xl`) |
| Input with icon prefix | Compose `Input` + leading icon (no shadcn helper, use flex wrapper) |
| Primary button | `Button` size="default" (h-10 default → override to `h-11` = 44px) |
| Checkbox | `Checkbox` |
| OTP modal | `Dialog` + `InputOTP` (shadcn input-otp) |
| Stepper | Custom (no shadcn primitive — build with `Circle` icons + connectors) |
| Sidebar | shadcn `Sidebar` (canary) hoặc compose `cn` + custom |
| Topbar search | `Command` palette, hoặc `Input` simple |
| KYC banner | `Alert` variant warning custom |
| Metric card | `Card` + `CardContent` |
| BDS list card | `Card` + image + badges |
| Filter sidebar | `Accordion` + `RadioGroup` + `Slider` + `Button` |
| Sheet right drawer | `Sheet` (radix dialog side="right") |
| Wizard footer | Custom layout (sticky bottom bar) |

## Lưu ý implementation

- Input height 44px → custom Tailwind `h-11` hoặc shadcn variant `size="lg"`
- Card shadow rất mảnh (`#0000000D` = 5% alpha), dùng `shadow-sm` của Tailwind là OK, không cần custom
- Tất cả radius phải dùng tokens, không hardcode
- Font Inter + Geist Mono phải import qua `@next/font/google` (Inter) hoặc `@vercel/geist` (Geist Mono)
- Color tokens phải đặt vào CSS variables để dark-mode-ready (hiện chỉ light mode)

---

<a id="docs-screens-hop-dong-moi-gioi-screens-md"></a>

## docs/screens/hop-dong-moi-gioi-screens.md

---
title: Hợp đồng môi giới — Screens spec (high-level)
type: design-spec
level: high-level
phase: 07
audience: Pencil AI designer + FE devs
date: 2026-04-29
status: implemented
related:
  - docs/screens/design-tokens.md
  - docs/screens/component-library.md
  - docs/01-brainstorm.md
  - docs/02-api-catalog.md
  - plans/reports/describe-260429-1042-quan-ly-hop-dong-existing.md
  - plans/reports/impl-260429-1329-hop-dong-moi-gioi.md
design_file: Design/hopdong.pen
---

# Hợp đồng môi giới — Screens spec

**Khái niệm:** Hợp đồng giữa **CTV** (Cộng tác viên) và **Tổng kho RESA HOLDING** — kích hoạt tài khoản agent. CTV tự ký, không gắn BĐS. BE field: `contract_type=1`.

> Phân biệt với "Hợp đồng trích thưởng" (HĐ giữa chủ nhà ↔ Tổng kho, BE `contract_type=2|3`) — xem [hop-dong-trich-thuong-screens.md](./hop-dong-trich-thuong-screens.md).

## Brand context

- Vietnamese UI, locale vi
- Tool nội bộ Agent BDS — density cao, professional
- shadcn/ui + Tailwind v4, design tokens theo `design-tokens.md`
- Mobile-first → scale lên `sm:` / `lg:` (memory rule)
- Capitalize display text (Họ Tên, Văn Phòng…) ở render layer

---

## 0. Business flow + status enum

```
CTV mở app → Ký HĐ CTV (signature pad + OTP)
  → status=3 Chờ xác nhận (có code + PDF ngay)
  → Admin xác nhận → status=4 Thành công
                  → status=5 Hủy / status=6 Từ chối (kèm reason)
```

**Status enum:**
| ID | Label | Color tone |
|---|---|---|
| 1 | Chờ duyệt | pending vàng `#FEF3C7 / #92400E` |
| 2 | Chờ diễn ra | info xanh dương `#DBEAFE / #1E40AF` |
| 3 | Chờ xác nhận | pending vàng |
| 4 | Thành công | success xanh `#D1FAE5 / #0D7C4D` |
| 5 | Hủy | danger đỏ `#FEE2E2 / #991B1B` |
| 6 | Từ chối | danger đỏ |

**Roles tham gia:**
- **CTV** — tạo + ký HĐ kích hoạt tài khoản (chính mình)
- **Admin VP / TP** — duyệt, gán VP+sale phụ trách, hủy/từ chối, bulk action
- **Sale phụ trách** — xem read-only HĐ liên quan office/đội nhóm

**Mã HĐ format:** `<no:03d>/<year>/<office_code>` (vd `005/2025/HN1`).

---

## 1. Danh sách HĐ môi giới (`/hop-dong-moi-gioi`)

**Purpose:** List + filter + bulk action HĐ CTV theo role.

**Topbar:**
- Title "Hợp đồng môi giới" + count badge
- Buttons phải: `Refresh` · `Xuất Excel` · `+ Tạo HĐ CTV` (primary orange)

**Filter row (sticky dưới topbar):**
- Search input (mã HĐ / SĐT / CCCD)
- Select: VP (admin), Sale-off (admin/TP)
- Date range popover (`Ngày tạo` mặc định / toggle `Ngày ký`)
- Tag filter chip: gắn HĐ vào BDS/khách (nếu cần — phase 2)
- Button "Bộ lọc" (extended filter popover)
- Active chips row dưới + Reset

**Tabs trạng thái** (sticky, scroll horizontal mobile, 7 tabs):
`Tất cả | Chờ duyệt | Chờ diễn ra | Chờ xác nhận | Thành công | Hủy | Từ chối`
Active tab cập nhật URL `?status=N` (deep-linkable). Count badge per tab.

**Table desktop (md+) — 9 cột match design D01:**
1. ▶ chevron (expand inline overview)
2. STT
3. Mã HĐ (`contract_code`)
4. CTV (name + phone)
5. VP + Phụ trách
6. Ngày ký (`signed_at` hoặc dash)
7. File PDF (icon button → mở PDF)
8. Khởi tạo (creator name + timestamp)
9. Trạng thái pill

Zebra striping (even rows `#F8FAFC`). Row hover + click → `/hop-dong-moi-gioi/[id]`.

**Card mobile (<md):**
- Hàng 1: mã HĐ + status pill phải
- Hàng 2: tên CTV + SĐT
- Hàng 3: VP · Phụ trách
- Hàng 4: ngày ký · ngày tạo
- Hàng 5: chips meta (loại HĐ, PT ký) + button icon "..."

**Bulk action bar (admin, tab `Chờ duyệt`):**
- Checkbox column visible khi `status=1` + role admin
- Floating bottom bar khi selection ≥ 1: `Đã chọn N HĐ` · `[Duyệt N]` · `[Từ chối N]` · `Clear`

**Empty state:** icon file-text-off + "Chưa có hợp đồng" (mỗi tab độc lập).

**States:** idle · loading (skeleton 3 rows) · empty · error toast · pagination footer (page x của y).

---

## 2. Modal — Tạo HĐ CTV (signature pad + OTP)

**Purpose:** CTV ký HĐ kích hoạt tài khoản (Flutter có flow này; web reuse tương tự, phase 2).

**Flow steps:**

**Step 1 — OTP gửi:**
- Title "Xác thực số điện thoại"
- Hiển thị phone CTV (masked) · channel toggle (Zalo / SMS)
- Button "Gửi mã OTP"
- API: `POST /api_agent/contract_otp.json` (purpose=1)
- Note: TTL 5 phút, max 5 attempts, rate-limit 3 lần / 15 phút / phone

**Step 2 — Nhập OTP:**
- 6 ô nhập số (auto-focus, auto-submit khi đủ)
- Countdown 5 phút + button "Gửi lại" (disabled tới khi hết hoặc TTL expire)
- API: `PUT /api_agent/contract_otp.json {phone, otp, purpose=1}`

**Step 3 — Ký chữ ký (signature pad):**
- Canvas full-width, height 200, border + grid
- Slider điều chỉnh độ dày bút (1-5px)
- Button `Vẽ lại` · `Xác nhận`
- Khi xác nhận: convert canvas → PNG bytes → upload `/api_real_estate_handle/upload_file.json` → URL

**Step 4 — Submit tạo HĐ:**
- API: `POST /api_agent/contract_create.json`
- Payload: `{info_office (auto), contract_type=1, signing_method=2, signed_at: NOW, signature_image: <url>}`
- Response: `{contract_id, pdf, status=3}`

**Step 5 — Success:**
- Title "Tạo hợp đồng thành công"
- Preview PDF iframe + button `Tải PDF` · `Đóng`
- Auto-redirect detail sau 3s

**Validation/Errors:**
- OTP sai → inline error, giữ session
- Signature trống → block submit
- Network fail → toast retry
- Invalid office (BE reject) → fallback dialog "Liên hệ admin"

---

## 3. Chi tiết HĐ môi giới (`/hop-dong-moi-gioi/[id]`)

**Purpose:** Xem full info HĐ + admin actions theo trạng thái.

**Header (sticky):**
- Back button
- Title `HĐ <code>` + status pill
- Subtitle: `<loại> · <PT ký> · <CTV name>`
- Actions phải: `Tải PDF` · `Duyệt` · `Từ chối` · `⋮` (overflow: Print, Share, Gán VP/Sale, Hủy)

**Tabs:** `Tổng quan` (active) | `Tài liệu` | `Lịch sử` | `Ghi chú`

### 3.1 Tab Tổng quan (3 sections KV)

**Section "Thông tin hợp đồng":**
- Loại hợp đồng (lookup `contract_options.contract_types`)
- Phương thức ký (lookup `contract_options.signing_methods`)
- Note "Thanh toán hoa hồng" (`text_percent`) — optional, không có cho HĐ CTV thông thường

**Section "Bên A — Tổng kho":**
- Tên công ty (`info_office.company_name`) — bold
- Mã số doanh nghiệp (`info_office.business_code`)
- [Expand "Xem thêm"] Địa chỉ trụ sở · Người đại diện · Chức vụ

**Section "Bên B — CTV":**
- Họ tên (bold) · Ngày sinh
- CCCD · Cấp ngày
- [Expand "Xem thêm"] Nơi cấp · Địa chỉ thường trú · SĐT

### 3.2 Tab Tài liệu

**4 categories (grid mobile 1col, tablet 2col, desktop 3col):**
- CCCD CTV mặt trước (1 ảnh)
- CCCD CTV mặt sau (1 ảnh)
- File scan HĐ (multi)
- Tài liệu bổ sung (multi)

**Per category:**
- Drop zone + click upload (react-dropzone)
- Upload progress bar per file
- Thumbnail grid + lightbox click
- API upload: `POST /api_real_estate_handle/upload_file.json` (5MB/file)
- API save: `POST /bds_transaction_management/update_contract_doc {contract_id, images[], document_type}`

**PDF hợp đồng:**
- Iframe preview (`pdf_url`)
- Fallback button `Mở trong tab mới` (Safari iOS)
- Placeholder "HĐ chưa có file" nếu `status=1`

### 3.3 Tab Lịch sử

Timeline vertical, mỗi event 1 row:
```
○ 28/04/2026 14:30 — NV.B tạo hợp đồng
│
● 28/04/2026 15:00 — CTV ký HĐ (signature + Zalo OTP)
│
○ Pending — chờ admin xác nhận
```

**Phase 1 fallback:** FE generate 3 events từ `created_on` / `signed_at` / `status` (BE chưa expose `log_tracking`).

### 3.4 Tab Ghi chú

- Input area + button `Gửi`
- Comment list reverse chronological: avatar + name + timestamp + content
- Edit/delete own note (phase 2)
- API: chưa có endpoint `add_contract_comment` — placeholder hoặc reuse `add_work_comment` qua work_id liên kết

**Sticky footer (admin only, status=1):**
- Hint text "HĐ đang chờ duyệt"
- `Gán VP/Sale` (secondary) · `Từ chối` (ghost destructive) · `Duyệt hợp đồng` (primary)

---

## 4. Modal — Duyệt / Từ chối / Bulk

**A. Duyệt 1 HĐ:**
- Confirm dialog: "Duyệt HĐ <code>?"
- Body: summary key fields
- Checkbox `Đẩy BĐS sang ACTIVE` (nếu HĐ liên kết BDS, không apply CTV)
- Btn `Hủy` · `Duyệt` (primary)
- API: `POST /bds_transaction_management/browse_contract {ids:[id], status:2}`

**B. Từ chối 1 HĐ:**
- Title "Từ chối hợp đồng"
- Textarea "Lý do từ chối" (required, min 10 chars)
- Btn `Hủy` · `Xác nhận từ chối` (destructive)
- API: `POST /bds_transaction_management/browse_contract {ids:[id], status:6, reason:string}`

**C. Bulk approve/reject:**
- Variant của A/B với title `Duyệt N hợp đồng` / `Từ chối N hợp đồng`
- Body: list ngắn N items (collapsible nếu > 5)
- API call same với `ids[]` array

---

## 5. Modal — Gán VP / Sale phụ trách

**Purpose:** Admin gán văn phòng + sale phụ trách 1 HĐ.

**Trigger:** Sticky footer button hoặc overflow menu.

**Content:**
- Title "Gán VP & sale phụ trách"
- Section 1: Select VP (search picker, options từ `offices`)
- Section 2: Select Sale-off (filter theo VP đã chọn, options từ `sales-off-users`)
- Btn `Hủy` · `Lưu` (primary)
- API:
  - `POST /bds_transaction_management/update_contract_office {id, info_office}`
  - `POST /bds_transaction_management/contract_assign_to {id, user_id}`

**After confirm:** Toast + invalidate cache list/detail.

---

## 6. Permissions matrix

| Persona | List filter | Tab actions visible |
|---|---|---|
| CTV | HĐ của mình (`verify_agent.salesman == me`) | Xem detail · Tải PDF |
| Sale | HĐ trong office (`real_estate_salesman.salesman_id == me`) | Xem · upload doc · note · download |
| Admin VP / TP | All HĐ | Full: duyệt/hủy/gán VP+sale + bulk + assign |

**Detect role:** heuristic env flag tạm (waiting BE expose `permissions[]`). Fallback: `step==3 && checking_staff/admin_flag` cho admin.

---

## 7. API mapping

| UI action | Endpoint | Method |
|---|---|---|
| List HĐ CTV | `/api_customer/contracts.json?app=2&contract_type=1` | GET |
| Detail | `/api_customer/contract_content_by_id.json?contract_id=X` | GET |
| Status counts | `/bds_transaction_management/get_status_contract` | POST |
| Tạo HĐ CTV | `/api_agent/contract_create.json` | POST |
| Gửi OTP | `/api_agent/contract_otp.json` (purpose=1) | POST |
| Verify OTP | `/api_agent/contract_otp.json` | PUT |
| Ký HĐ (update signature) | `/api_customer/contract_sign.json` | POST |
| Upload ảnh chữ ký / CCCD | `/api_real_estate_handle/upload_file.json` | POST multipart |
| Upload doc | `/bds_transaction_management/update_contract_doc` | POST |
| Bulk approve/reject | `/bds_transaction_management/browse_contract` | POST |
| Gán VP | `/bds_transaction_management/update_contract_office` | POST |
| Gán sale | `/bds_transaction_management/contract_assign_to` | POST |
| Lấy template | `/api_agent/contract_content.json` | GET |
| Thư viện HĐ | `/api_real_estate_handle/news_by_folder.json?folder=thu-vien-hop-dong-agent` | GET |

---

## 8. Components reuse

Existing (đã impl `src/components/hop-dong/`):
- `contract-status-pill.tsx` — pill 22px soft-tinted theo enum
- `contract-status-tabs.tsx` — 7 tabs với count badge
- `contract-list-table.tsx` — desktop 9 cột zebra

Shared cần refactor (Phase 1 plan trích thưởng):
- Extract `shared/contract-status-pill.tsx` + `shared/contract-status-tabs.tsx`
- Generic `shared/contract-list-table.tsx` (props.columns config)

External existing:
- `components/common/date-range-popover.tsx`
- `components/common/tag-filter-chip-body.tsx`
- `components/bds/bds-detail-content.tsx` (KV row pattern)

---

## 9. Open questions (chờ BE clarify)

1. `permissions[]` field trong profile API — confirm BE expose hay FE heuristic?
2. `get_list_contract` admin endpoint có tự auto-scope theo role không (1 endpoint vs 2)?
3. Pagination cho `/api_customer/contracts.json` — flat list hiện tại sẽ vỡ khi >100 HĐ.
4. Endpoint `add_contract_comment` cho Tab Ghi chú — chưa có?
5. `get_detail_contract` có trả `history[]` không hay phải parse từ `log_tracking`?
6. PDF iframe CORS — `/static/uploads/contracts/<year>/<file>.pdf` có cho phép load từ web Agent domain?
7. Status 3 ambiguity (schema = "Chờ xác nhận" vs `contract_create.json` set status=3 sau ký) — confirm semantic.

---

<a id="docs-screens-hop-dong-trich-thuong-screens-md"></a>

## docs/screens/hop-dong-trich-thuong-screens.md

---
title: Hợp đồng trích thưởng — Screens spec (high-level)
type: design-spec
level: high-level
phase: 07
audience: Pencil AI designer + FE devs
date: 2026-04-29
status: planned
related:
  - docs/screens/design-tokens.md
  - docs/screens/component-library.md
  - docs/screens/hop-dong-moi-gioi-screens.md
  - docs/01-brainstorm.md
  - docs/02-api-catalog.md
  - plans/reports/brainstorm-260429-1428-hop-dong-trich-thuong.md
  - plans/reports/describe-260429-1042-quan-ly-hop-dong-existing.md
  - plans/260429-1428-hop-dong-trich-thuong/plan.md
design_file: Design/hopdong.pen
---

# Hợp đồng trích thưởng — Screens spec

**Khái niệm:** Hợp đồng giữa **Chủ nhà** (bên B) và **Tổng kho RESA HOLDING** (bên A) gắn 1:1 với 1 BĐS đã verify. **Người khởi tạo: CTV đầu chủ** (bất kỳ CTV assigned to BDS). **Người ký: chủ nhà** (qua app Flutter — web không xử lý ký). BE field: `contract_type=2` (Thông thường) hoặc `3` (Độc quyền).

> Phân biệt với "Hợp đồng môi giới" (HĐ giữa CTV ↔ Tổng kho, BE `contract_type=1`) — xem [hop-dong-moi-gioi-screens.md](./hop-dong-moi-gioi-screens.md).

## Brand context

- Vietnamese UI, locale vi
- Tool nội bộ Agent BDS — density cao, professional
- shadcn/ui + Tailwind v4, design tokens theo `design-tokens.md`
- Mobile-first → scale lên `sm:` / `lg:` (memory rule)
- Capitalize display text (Họ Tên, Văn Phòng, Địa Chỉ…) ở render layer

---

## 0. Business flow + status enum

```
CTV đầu chủ chọn BDS đã verify
  → Tạo HĐ trích thưởng (chọn loại 2/3 + PT ký)
  → status=1 Chờ duyệt (sinh code + PDF ngay)
  → Admin duyệt → status=2 Chờ diễn ra
                → status=6 Từ chối (kèm reason)
  → Notify chủ nhà mở app Flutter
  → Chủ nhà ký (OTP gửi vào owner_phone, app=1)
  → status=3 Chờ xác nhận
  → Admin xác nhận hoàn tất → status=4 Thành công
```

**Status enum:** giống HĐ môi giới (1-6 cùng color tone — xem `hop-dong-moi-gioi-screens.md` §0).

**Roles tham gia:**
- **CTV đầu chủ** — assigned to BDS qua `real_estate_salesman.salesman_id` hoặc `salesman_support` — tạo HĐ
- **Chủ nhà** — bên B, ký qua app Flutter, không login web
- **Admin VP / TP** — duyệt/từ chối, gán VP+sale phụ trách, bulk action
- **Sale phụ trách** — xem read-only HĐ trong office/đội nhóm

**Mã HĐ format:** `<no:03d>/<year>/<office_code>` (vd `005/2025/HN1` — không có suffix `HĐMG-RESA HOLDING` ở api_agent).

**Sub-type:**
- `contract_type=2` Thông thường — badge xanh
- `contract_type=3` Độc quyền — badge đỏ · ⚠️ 1 BĐS chỉ được 1 HĐ độc quyền active

---

## 1. Danh sách HĐ trích thưởng (`/hop-dong-trich-thuong`)

**Purpose:** List + filter + bulk action HĐ chủ nhà theo role. Reuse 90% structure HĐ môi giới + thêm cột BĐS / Chủ nhà.

**Topbar:**
- Title "Hợp đồng trích thưởng" + count badge
- Buttons phải: `Refresh` · `Xuất Excel` · `+ Tạo HĐ trích thưởng` (primary orange)

**Filter row (sticky):**
- Search input (mã HĐ / địa chỉ BDS / SĐT chủ nhà / CCCD)
- Sub-type chip toggle: `Tất cả | Thông thường | Độc quyền`
- Select: VP (admin), Sale-off (admin/TP)
- Date range popover (Ngày tạo / Ngày ký)
- Tag filter chip
- Button "Bộ lọc"
- Active chips row + Reset

**Tabs trạng thái** (sticky, scroll horizontal mobile, 7 tabs):
`Tất cả | Chờ duyệt | Chờ diễn ra | Chờ xác nhận | Thành công | Hủy | Từ chối`

**Table desktop (md+) — 12 cột:**
1. ☐ Checkbox (admin, status=1)
2. STT
3. Mã HĐ
4. Loại (badge Thông thường/Độc quyền)
5. PT ký
6. **BĐS** — mã + địa chỉ ellipsis (link `/bds/[code]`)
7. **Chủ nhà** — name + SĐT (capitalize)
8. CTV đầu chủ
9. VP + Phụ trách
10. Ngày tạo / Ngày ký (2 dòng)
11. File PDF
12. Trạng thái pill

Zebra striping. Row hover + click → `/hop-dong-trich-thuong/[id]`.

**Card mobile (<md):**
- Hàng 1: mã HĐ + status pill phải
- Hàng 2: tên BDS + giá nổi bật
- Hàng 3: chủ nhà + SĐT
- Hàng 4: chip loại HĐ + chip PT ký + chip CTV đầu chủ
- Hàng 5: ngày tạo · ngày ký
- Hàng 6: button icon "..."

**Bulk action bar:** giống HĐ môi giới §1.

**Empty state:** icon file-text-off + "Chưa có hợp đồng trích thưởng" (mỗi tab độc lập).

**States:** idle · loading skeleton · empty · error toast · pagination footer.

---

## 2. Drawer — Tạo HĐ trích thưởng

**Purpose:** CTV đầu chủ tạo HĐ trích thưởng cho 1 BĐS đã verify.

**Trigger:** Button `+ Tạo HĐ trích thưởng` topbar list HOẶC button trên BDS detail page section "Hợp đồng" (nếu BDS verify + chưa có HĐ exclusive).

**Layout:**
- Desktop: Drawer right-side, w=480
- Mobile: Bottom sheet full-height (drag handle top)

**Header:**
- Close button (×)
- Title "Tạo Hợp đồng trích thưởng"

**Body (vertical, gap 16, scrollable):**

### Step 1 — Chọn BĐS

- Label "BĐS *"
- Combobox autocomplete:
  - Search input "Tìm BĐS đã xác thực…"
  - Dropdown: list BDS verify thuộc CTV (paginated, debounce 300ms)
  - Item display:
    ```
    BDS-12345 · 50m² Vinhomes Q.7
    Chủ: Nguyễn Văn A — 0987xxx
    Giá: 2.5 tỷ            [Đã có HĐ ĐQ]  ← badge nếu disabled
    ```
  - Disabled item (gray + tooltip "BĐS này đã có HĐ độc quyền"): `has_exclusive=true`
- API: `GET /api_agent/list_real_estate_salesman?verify=1&salesman_id=me` (cần BE confirm)

### Preview BĐS đã chọn (read-only, sau khi pick)

- Card section bg muted:
  - Tên BĐS bold + giá nổi bật primary
  - Mã + Sổ đỏ + Số HĐMB + Ngày ký mua bán
  - Chủ nhà tên + SĐT (CCCD nếu verify_agent có)

### Step 2 — Loại HĐ

- Label "Loại hợp đồng *"
- Radio group:
  - ( ) Thông thường (`contract_type=2`)
  - ( ) Độc quyền (`contract_type=3`) — helper text "⚠️ Chỉ được 1 HĐ độc quyền/BĐS"

### Step 3 — Phương thức ký

- Label "Phương thức ký *"
- Radio group:
  - ( ) Trực tiếp (giấy) (`signing_method=1`)
  - ( ) Điện tử (online) (`signing_method=2`)

### Preview Tài chính (read-only, từ BĐS)

- Section card title "Tài chính (từ thông tin BĐS)" với badge "Read-only"
- Phí MG: `<value>%` hoặc `<value> đ`
- Đặt cọc: `<deposit_percent>%`
- Hoàn tất: `<completion_payout_percent>%`
- Bên chịu thuế: Bên Bán / Bên Mua / Thỏa Thuận
- Thuế suất: `<tax_rate_percent>%`
- Note "Thanh toán hoa hồng" (yellow card): `<text_percent>`

> Note hint dưới: "Để chỉnh sửa các thông tin tài chính, vui lòng cập nhật ở form BĐS."

### Preview Bên A & Bên B (read-only)

- Bên A: RESA HOLDING (VP <name>) · ĐD: <name>
- Bên B: <chủ nhà name> · CCCD: <id_card> · <owner_phone>

### Hint cuối form

> 💡 Hợp đồng sẽ ở trạng thái "Chờ duyệt". Sau khi admin duyệt, chủ nhà sẽ nhận thông báo để mở app Tổng kho và ký HĐ.

**Footer (sticky):**
- Btn `Hủy` (ghost) — confirm dialog nếu dirty
- Btn `Tạo hợp đồng` (primary, disabled tới khi đủ Step 1+2+3)

**State machine:**
- `idle` → user mở drawer
- `selecting-bds` → autocomplete search active
- `bds-selected` → preview hiện, enable Step 2/3
- `submitting` → button loading + disabled
- `error` → inline alert (đặc biệt error "Thông tin pháp lý khác hiện không khả dụng để ký")
- `success` → toast + close drawer + navigate `/hop-dong-trich-thuong/[id]`

**API call submit:**
- `POST /api_agent/contract_create_broker.json`
- Payload: `{info_office (auto resolve), real_estate_salesman: <id>, contract_type: 2|3, signing_method: 1|2}`
- Response: `{contract_id, pdf, status=1}`

**Validation FE:**
- BDS phải verify (`is_verified=true`) — filter list
- Block button nếu BDS đã có HĐ exclusive (relly BE error hoặc pre-check `has_exclusive`)
- Confirm dialog "Tạo HĐ độc quyền?" nếu chọn type=3 (warning về 1 HĐ ĐQ/BĐS)

---

## 3. Chi tiết HĐ trích thưởng (`/hop-dong-trich-thuong/[id]`)

**Purpose:** Xem full info HĐ + admin actions theo trạng thái.

**Header (sticky):**
- Back button
- Title `HĐ <code>` + status pill
- Subtitle: `<loại Thông thường/Độc quyền> · <PT ký> · <chủ nhà name>`
- Actions phải: `Tải PDF` · `Duyệt` · `Từ chối` · `⋮` (overflow: Print, Share, Gán VP/Sale, Hủy)

**Tabs:** `Tổng quan` (active) | `Tài liệu` | `Lịch sử` | `Ghi chú`

### 3.1 Tab Tổng quan (5 sections KV)

**Section 1 — "Thông tin hợp đồng":**
- Loại HĐ (Thông thường / Độc quyền)
- Phương thức ký (Trực tiếp / Điện tử)
- Mã HĐ (`code`)
- Trạng thái pill

**Section 2 — "Bên A — Tổng kho":**
- Tên công ty (bold)
- Mã số doanh nghiệp
- [Expand "Xem thêm"] Địa chỉ trụ sở · Người đại diện · Chức vụ · Bank info (nếu BE expose)

**Section 3 — "Bên B — Chủ nhà"** (lookup từ `verify_agent` qua `real_estate_salesman.owner_account_id`):
- Họ tên (bold) · Ngày sinh
- CCCD · Cấp ngày
- [Expand] Nơi cấp · Địa chỉ thường trú
- SĐT chủ nhà (`real_estate_salesman.owner_phone`)

> Nếu `owner_name_first` + `owner_name_second` đều có → display 2 chủ nhà cards (đồng sở hữu).

**Section 4 — "BĐS"** (mới — không có ở HĐ môi giới):
- Mã BDS · Địa chỉ
- Giá trị BĐS (`real_estate_value`) — bold primary
- Số sổ đỏ (`certificate_number`) · Quyển số nếu có
- Số HĐ mua bán (`contract_number`) + Ngày ký mua bán (`contract_signed_date`)
- Tên chủ sổ đỏ: `owner_name_first` (+ `owner_name_second`)
- Link → `/bds/[code]` (button "Xem chi tiết BĐS")

**Section 5 — "Tài chính HĐ"** (mới — read-only từ BĐS):
- Phí môi giới: `brokerage_fee_value` + unit (% hoặc đ)
- Đặt cọc: `deposit_percent` (%)
- Hoàn tất: `completion_payout_percent` (%)
- Bên chịu thuế: `tax_bearer` map (Bên Bán / Bên Mua / Thỏa Thuận)
- Thuế suất: `tax_rate_percent` (%)
- Note "Thanh toán hoa hồng" (yellow card): `text_percent`

### 3.2 Tab Tài liệu

**4 categories:**
- CCCD chủ nhà mặt trước (1 ảnh)
- CCCD chủ nhà mặt sau (1 ảnh)
- Sổ đỏ (multi)
- File scan HĐ (multi)

**PDF hợp đồng:** iframe + fallback "Mở tab mới" + placeholder nếu chưa render.

(API + UX upload giống HĐ môi giới §3.2.)

### 3.3 Tab Lịch sử

Timeline vertical:
```
○ 28/04/2026 14:30 — CTV đầu chủ tạo HĐ
│
○ 28/04/2026 15:00 — Admin <name> duyệt HĐ
│
● 28/04/2026 16:00 — Chủ nhà ký HĐ (signature + Zalo OTP)
│
○ Pending — chờ admin xác nhận hoàn tất
```

**Phase 1 fallback:** FE generate events từ `created_on` / `signed_at` / status (BE chưa expose `log_tracking`).

### 3.4 Tab Ghi chú

Giống HĐ môi giới §3.4 (placeholder vì BE thiếu endpoint).

**Sticky footer:** giống HĐ môi giới §3 (admin actions theo status).

---

## 4. Modal — Duyệt / Từ chối / Bulk

Reuse từ HĐ môi giới §4. Khác biệt:

**Duyệt 1 HĐ trích thưởng:**
- Body summary thêm: BĐS · Chủ nhà · Loại HĐ
- Checkbox `Đẩy BĐS sang ACTIVE` (nếu BDS đang `PENDING_APPROVAL`)
- API: `POST /bds_transaction_management/browse_contract {ids:[id], status:2, update_re_status:true}`

**Từ chối:** giống HĐ môi giới (reason required).

**Bulk:** variant cùng API `ids[]`.

---

## 5. Modal — Gán VP / Sale phụ trách

Giống HĐ môi giới §5. (Cùng dialog reuse cho cả 2 loại HĐ.)

---

## 6. Permissions matrix

| Persona | List filter | Tab actions visible |
|---|---|---|
| CTV đầu chủ | HĐ của mình (`real_estate_salesman.salesman_id == me` hoặc `salesman_support`) | Xem detail · Tải PDF · Tạo HĐ trích thưởng |
| Sale phụ trách | HĐ trong office | Xem · upload doc · note · download |
| Admin VP / TP | All HĐ | Full: duyệt/hủy/gán VP+sale + bulk |

**Block rules:**
- CTV chỉ tạo được HĐ trích thưởng cho BDS mình assigned
- Block tạo nếu BDS đã có HĐ `contract_type=3` active (BE reject)
- Sale không tạo được HĐ trích thưởng — chỉ CTV đầu chủ

**Detect role:** giống HĐ môi giới §6.

---

## 7. API mapping

| UI action | Endpoint | Method |
|---|---|---|
| List HĐ trích thưởng | `/api_customer/contracts.json?app=2` (filter FE `contract_type IN [2,3]`) | GET |
| Detail | `/api_customer/contract_content_by_id.json?contract_id=X` | GET |
| Status counts | `/bds_transaction_management/get_status_contract` | POST |
| **Tạo HĐ trích thưởng** | `/api_agent/contract_create_broker.json` | POST |
| Pre-check ownership (chủ nhà = chủ sổ đỏ) | `/api_customer/contract_verify_owner_by_id.json?contract_id=X` | GET |
| Pre-check approval status BDS | `/bds_transaction_management/check_contract_approval_status.json?contract_id=X` | GET |
| List BDS verify cho picker | `/api_agent/list_real_estate_salesman?verify=1&salesman_id=me` | GET (cần BE confirm) |
| Upload doc | `/bds_transaction_management/update_contract_doc` | POST |
| Bulk approve/reject | `/bds_transaction_management/browse_contract` | POST |
| Gán VP | `/bds_transaction_management/update_contract_office` | POST |
| Gán sale | `/bds_transaction_management/contract_assign_to` | POST |
| Ký HĐ chủ nhà | `/api_customer/contract_sign.json` (app Flutter, không web) | POST |

---

## 8. Components reuse

Shared với HĐ môi giới (refactor Phase 1 plan trích thưởng):
- `shared/contract-status-pill.tsx`
- `shared/contract-status-tabs.tsx`
- `shared/contract-list-table.tsx` (generic, props.columns)

Riêng HĐ trích thưởng (`components/hop-dong/trich-thuong/`):
- `trich-thuong-create-drawer.tsx` — drawer right/bottom-sheet
- `trich-thuong-bds-picker.tsx` — autocomplete BDS verify
- `trich-thuong-detail-tabs.tsx` — wrapper detail
- `trich-thuong-section-bds.tsx` — Section BĐS với link `/bds/[code]`
- `trich-thuong-section-finance.tsx` — Section Tài chính read-only
- `trich-thuong-section-owner.tsx` — Section Bên B chủ nhà (extend existing)
- `trich-thuong-list-columns.tsx` — column config cho generic table

External existing:
- `components/common/date-range-popover.tsx`
- `components/common/tag-filter-chip-body.tsx`
- `components/bds/bds-detail-content.tsx`

---

## 9. Open questions (chờ BE clarify)

1. Endpoint list BDS verify cho picker (`list_real_estate_salesman?verify=1&salesman_id=me`) — confirm hay propose mới?
2. Pre-check `has_exclusive_contract` flag cho BDS — hide button "Tạo HĐ trích thưởng" trên BDS detail.
3. Filter sub-type 2 vs 3 ở list response — `contract_type_name` đủ phân biệt hay cần param riêng?
4. Pagination cho `/api_customer/contracts.json` — flat list sẽ vỡ khi >100 HĐ.
5. CTV đầu chủ "duy nhất" khi BDS có nhiều CTV (`salesman_id` chính + `salesman_support`) — flag nào identify?
6. Notification chủ nhà sau admin duyệt status→2 — kênh nào (push app, SMS, Zalo)?
7. Edit/Hủy HĐ status=1 — quyền CTV tự thao tác hay phải qua admin?
8. `text_percent` vs `deposit_percent`/`completion_payout_percent` cùng có — ưu tiên display field nào?
9. PDF iframe CORS cho `/static/uploads/contracts/<year>/<file>.pdf` — confirm allow web Agent domain?
10. Endpoint comment cho `contract_id` — chưa có, reuse `add_work_comment` qua work_id liên kết?

---

<a id="docs-screens-khach-hang-screens-md"></a>

## docs/screens/khach-hang-screens.md

---
title: Khách hàng — System Design (Screens Spec)
source: plans/reports/brainstorm-260424-1316-khach-hang-optimize.md
updated: 2026-04-24
related:
  - plans/reports/brainstorm-260424-1316-khach-hang-optimize.md
  - docs/02-api-catalog.md §5 Customer (get_list_customer, add_customer, etc.)
  - docs/04-api-by-screen.md §5.4–5.5
  - docs/screens/design-tokens.md
---

# Khách hàng — Screens Spec

Spec canonical cho module **Khách hàng**. Kế thừa design tokens + interaction patterns từ module Nhu cầu.

## Scope & States

**Ownership** (derived per viewer agent, không phải bảng riêng):
- `self` — `customer.assigned_to_agent_id == viewer.id`
- `linked` — viewer là assignee của ≥1 nhu cầu/GD/LH/WL gắn customer

**Không có** UI "pool" độc lập. Khách chưa có người chăm access qua dialog "Thêm khách" → phone lookup.

## Frame map

| # | Name | Viewport | Source |
|---|------|----------|--------|
| 1 | Desktop List | 1520×1020 | spec |
| 2 | Desktop Detail — Self | 1520×1020 | spec |
| 3 | Desktop Detail — Linked | 1520×1020 | spec |
| 4 | Mobile List | 390×844 | spec |
| 5 | Mobile Detail | 390×844 | spec |
| 6 | Mobile Filter (bottom sheet) | 390×844 | spec |
| 7 | Dialog "Thêm khách" — 3 branch | 520×auto desktop / 390×auto mobile | spec |
| 8 | Dialog "Gán sales / Gán office" | 480×auto | spec |

Token ref: [design-tokens.md](./design-tokens.md).

---

## 1. Desktop List

Layout vertical, gap 16, padding `[24,28,32,28]`, fill `$bg-page`.

### 1.1 Filter Bar

Card `$bg-card`, padding `[14,16]`, gap 10, border `$border-muted`, radius `$radius-md`.

Row 1 (height 40, radius `$radius-sm`, border `$border-muted`):

| Control | Width | Note |
|---|---|---|
| Search Input | 300 | Placeholder "Tìm theo tên, SĐT…" |
| DD Địa bàn | 220 | Reuse `AddressPickerDialog` multi-level (Tỉnh → Quận → Phường) — multi-select |
| DD Hoạt động | 170 | Multi-select: Có nhu cầu · Có GD · Có lịch hẹn · Có công việc · Không có gì |
| DD Khoảng thời gian | 170 | Preset Hôm nay / 7 ngày / 30 ngày / Custom (filter theo `last_activity_at`) |
| *(spacer fill)* | fill | |
| Btn Reset | 40 | Icon-only `↻`, outline `$border-muted`, chỉ hiện khi có active filter |
| Btn + THÊM KHÁCH | fit | Outline `$accent-indigo`, icon plus + text — trigger Dialog Thêm khách (§7) |

Row 2 — Segment radio, gap 4, fill `$surface-muted`, padding 4, radius `$radius-pill`, height 36:

| Segment | Label | Badge | Active |
|---|---|---|---|
| all | Tất cả | count | |
| self | Của tôi | count | ✓ default |
| linked | Liên kết | count | |

Badge height 18, padding `[0,8]`, radius `$radius-pill`, font 11/700.

### 1.2 Active Filter Chips Row

Render khi có active filter (ngoài segment). Gap 8, wrap. Mỗi chip fill `$primary-soft`, padding `[4,10]`, radius `$radius-pill`, text 12/500 `$primary`, có icon × xoá.

Ví dụ: `[Hà Nội / Cầu Giấy ✕] [Có nhu cầu ✕] [7 ngày qua ✕]`

URL sync: `/khach-hang?ownership=self&province_ids=1&district_ids=12&has_activities=demand&activity_from=2026-04-17`.

### 1.3 Card Grid

Grid responsive: 1 col `<640px`, 2 col `<1024`, 3 col `<1440`, 4 col `≥1440`. Gap 14.

#### Card shape (`bg-card`, border `$border-muted`, radius `$radius-md`, padding 16, gap 10)

```
┌────────────────────────────────┐
│ 👤 Anh Tú              [⭐|🔗] │ ← header row
│ 0971621429                      │ ← phone link `$text-link` 13/500
│ 📍 Cầu Giấy, Hà Nội             │ ← địa bàn 12 muted
│ [2 nhu cầu][1 GD][3 LH]         │ ← counter chips
│ Hoạt động 24/04                 │ ← last activity 11 muted-2
└────────────────────────────────┘
```

- Avatar 36 default (`AssetConstants.avatarDefault`)
- Tên 14/600 `$text-primary`, truncate
- Badge ownership 20 pill: **self** = ⭐ + "Của tôi" fill `$accent-green-light` `#0D7C4D`; **linked** = 🔗 + "Liên kết" fill `$indigo-soft` `$accent-indigo`; **both** = cả 2 chip gap 4
- Phone: `<a href="tel:">` copy icon trên hover
- Địa bàn: derive từ customer.address hoặc fallback linked entity (xem BE Q#7)
- Counter chips: height 22, padding `[0,8]`, radius `$radius-pill`, fill `$surface-muted`, font 11/600 — ẩn khi count=0
- Last activity: 11/400 `$text-muted-2`, format "Hoạt động DD/MM" (trong tuần: "Hôm nay/Hôm qua/T2…")
- Hover: border `$primary/40`, shadow sm
- Click card → `/khach-hang/[id]`

### 1.4 Empty / Loading / Error

- **Empty** (filter=0): icon `users` size 40 muted + "Không có khách nào khớp bộ lọc" + CTA outline "Xoá bộ lọc" → reset URL params
- **Empty** (no data): "Chưa có khách hàng" + CTA primary "Thêm khách"
- **Loading**: skeleton 6 card (grid placeholder)
- **Error**: message + retry button

### 1.5 Pagination

Bottom: "Hiển thị 1-20 / 453" + page controls `‹ 1 2 3 … ›`. Page size 20. Infinite scroll option phase 2.

---

## 2. Desktop Detail — Self (`/khach-hang/[id]`)

Vertical, gap 14, padding `[20,28,32,28]`.

### 2.1 Breadcrumb
`Tổng quan › Khách hàng › Anh Tú` — font 12, tên bold `$text-primary`.

### 2.2 Page Header
Row gap 14, padding `[0,4]`:
- `iBack` 36×36 pill border — lucide arrow-left
- Avatar 40 default
- Title wrap vertical: tên 20/700 + row gap 8 `[⭐ Của tôi] [phone 13 link]`
- *(spacer fill)*
- Btn outline `+ Ghi chú` 36
- Btn outline `+ Thẻ` 36
- **Menu more** `⋯` 36×36 — dropdown: "Sửa thông tin" / "Gán cho sales khác" (role manager) / "Gán cho office" (role admin) / `Xoá` (destructive)

### 2.3 Stats Strip

Card height 64, radius `$radius-md`, border, padding `[0,22]`. 4 ô chia đều, divider 1×36 `$neutral-200`:

| Stat | Value | Icon |
|---|---|---|
| Nhu cầu | 2 | file-text |
| Giao dịch | 1 | briefcase |
| Lịch hẹn | 3 | calendar |
| Công việc | 0 | check-square |

Value 20/700, label 11 muted uppercase.

### 2.4 Grid — Left/Right

- **Left** (400) — Info Card + Tag Card
- **Right** (fill) — Timeline Card

#### Left Info Card
Radius `$radius-md`, border, padding 18, gap 14.

| Field | Display |
|---|---|
| Họ tên | input text (editable) |
| **SĐT** | **readonly (🔒)** — phone là identity khách, không cho đổi. Label "SĐT · Không thể sửa". Copy icon OK. |
| Email | input email |
| Địa chỉ | input + `AddressPickerDialog` trigger |
| Ghi chú nội bộ | textarea 3 rows |
| Nguồn | readonly pill — `source` (Tự tạo / Tự đăng ký app / …) |
| Ngày tạo | readonly 13 muted |

Footer: btn primary "Lưu" (chỉ enable khi dirty), outline "Huỷ".

#### Left Tag Card
Header "Thẻ Tag" + link "Quản lý". Row chip + btn outline `+ Chọn thẻ` — reuse `list_tags` + `assign_tags_to_entity`.

#### Right Timeline Card (`activities[]`)
Radius `$radius-md`, border, padding `[18,22]`, gap 16. Header: "Lịch sử tương tác" + filter DD (Tất cả / Nhu cầu / GD / Lịch hẹn / Công việc / Ghi chú / Ownership) + btn primary "+ Ghi chú".

```
  ● 24/04/2026
  ├─ 📝 Nhu cầu #123 "Mua chung cư Cầu Giấy"
  │   Trạng thái: Đang tư vấn · agent: Nguyễn A
  │   [Mở nhu cầu →]
  ├─ 📞 Ghi chú: "Khách hẹn xem lại T7"  · Nguyễn A · 17:02
  │   [Sửa] [Xoá]
  │
  ● 20/04/2026
  ├─ 📅 Lịch hẹn: Xem căn hộ Vinhome Smart City
  │   10:00 · Trạng thái: Confirmed
  │   [Mở lịch hẹn →]
  │
  ● 15/04/2026
  ├─ 💼 Giao dịch #55 "Đặt cọc Masteri"
  │   Trạng thái: Completed · 3.5 tỷ
  │   [Mở GD →]
```

**Visual**:
- Left rail vertical line 2px `$border-muted`, bullet circle 10 `$primary` ở mỗi date
- Date label 13/700 uppercase `$text-secondary`
- Item: indent 24, icon 16 theo type, title 14/500, sub 12 muted
- Link "Mở X →" `$text-link` 12/600

**Item type visuals**:

| Type | Icon | Badge fill | Link dest |
|---|---|---|---|
| demand | file-text | `$accent-green-light` | `/nhu-cau/[id]` |
| transaction | briefcase | `$pill-amber` | `/giao-dich/[id]` |
| appointment | calendar | `$indigo-soft` | `/lich-hen/[id]` |
| work_log | check-square | `$surface-muted` | `/cong-viec/[id]` |
| note | message-square | `$bg-card` border | — (edit/delete inline) |
| ownership_change | user-check | `$pill-rose` | — (audit) — hiển thị "Nhận từ pool bởi [actor]" / "Được giao từ [from] → [to] bởi [actor]" |

**Empty**: text muted "Chưa có hoạt động nào" + CTA outline "+ Tạo nhu cầu mới" + "+ Đặt lịch hẹn".

**Pagination**: fetch 20 activities/lần, click "Xem thêm" → append.

---

## 3. Desktop Detail — Linked

Giống §2 Self, khác biệt:

### 3.1 Header Badge
Badge `🔗 Liên kết` fill `$indigo-soft` thay cho `⭐ Của tôi`. Sub-text 12 muted: "Khách từ Nhu cầu #123 · agent chủ: Nguyễn A".

### 3.2 Info Card — Readonly Fields
Các field `name, phone, email, address` **readonly**:
- Input disabled, background `$surface-muted`
- Icon 🔒 16 `$text-muted` bên phải label
- Tooltip hover: "Không thể sửa — dữ liệu từ nhu cầu #123"

**Field editable**:
- Ghi chú nội bộ (của agent viewer)
- Tags (có thể add/remove riêng)

### 3.3 Menu more
- ✅ "+ Ghi chú" (add own note)
- ❌ "Sửa thông tin" — hidden
- ❌ "Xoá" — disabled (hiện với tooltip "Chỉ gỡ liên kết, không xoá được data gốc")
- ✅ "Gỡ liên kết" (chỉ detach khỏi entity của agent, không xoá customer)
- ✅ "Gán cho sales khác" — role manager
- ✅ "Gán cho office" — role admin

---

## 4. Mobile List (390×844)

Vertical, fill `$bg-page`.

| Section | Height | Note |
|---|---|---|
| Status Bar | 32 | |
| App Bar | 56 | back 36 + "Khách hàng" 17/700 + badge total `$primary-soft` + *(fill)* + icon search + icon filter (outline `$accent-indigo`) |
| Segment | 44 | Tất cả / Của tôi / Liên kết — fill `$surface-muted`, padding 4, segment active fill white shadow |
| Active Chips | auto | Render khi có filter (xem §1.2) |
| List Area | fill | Vertical gap 10, padding 12 |
| FAB | absolute `[244,772]` | pill `$accent-indigo`, icon plus + "THÊM KHÁCH" 12/700, shadow blur 16 `#6366F155` |

### 4.1 Mobile Card
Radius `$radius-md`, border, padding 14, gap 8, fill `$bg-card`.

- Row 1: Avatar 36 + tên 14/600 + *(fill)* + badge ownership
- Row 2: `📞 0971621429` copy icon → tap `tel:`
- Row 3: `📍 Cầu Giấy, Hà Nội` 12 muted
- Row 4: counter chips (ẩn khi 0): `[2 NC][1 GD][3 LH]`
- Row 5: "Hoạt động 24/04" 11 muted-2 right-aligned

Tap card → `/khach-hang/[id]`.

---

## 5. Mobile Detail (390×844)

Stack: Status / App Bar / Scroll / Bottom Bar.

### 5.1 App Bar — 56
- Back pill 36
- Title wrap vertical: tên 16/700 + badge ownership 11 + sub-text "#ID" 11 muted
- *(fill)* + action more 36

### 5.2 Scroll Area — padding `[12,12,80,12]`, gap 12

Cards (tất cả `$bg-card`, radius `$radius-md`, border, padding 14):

#### 5.2.1 Summary Card
- Row: avatar 40 + tên 15/700 + badge ownership + *(fill)* + source chip (11)
- Row 2: `📞 phone · tạo 22/04/2026` 12 muted

#### 5.2.2 Info Card (editable theo ownership §2.4/3.2)

#### 5.2.3 Tags Card
- Header "THẺ GẮN" 11/700 uppercase + link "Quản lý"
- Row chips wrap + "+ Thêm thẻ"

#### 5.2.4 Stats Strip — height 58
4 ô chia đều, divider 1×28: NC / GD / LH / CV.

#### 5.2.5 Timeline Card
Giống §2.4 Right Timeline nhưng padding 12, indent 18.

### 5.3 Bottom Bar — absolute `[0,772]`, 390×72
Fill `$bg-card`, border-top, padding `[12,16,16,16]`, gap 10:
- Square 44 outline — icon `phone` (tap: `tel:`)
- Fill button 44 primary `$accent-indigo` — "+ GHI CHÚ NHANH" (open sheet input)

---

## 6. Mobile Filter (bottom sheet fullscreen 390×844)

Stack: Status / App Bar / Body / Footer.

### 6.1 App Bar — 52
Back 36 + title wrap ("Bộ lọc" 16/700 + "N bộ lọc đang áp dụng" 11 muted) + reset 32 `↻`.

### 6.2 Body — padding `[12,12,80,12]`, gap 10

1. **Search** 44 — icon + "Tìm tên, SĐT"
2. **Segment Ownership** 38 — Tất cả / Của tôi / Liên kết
3. Section "ĐỊA BÀN"
4. **Địa bàn select** 56 — icon map-pin + value multi "HN, Cầu Giấy + 2" + chevron → bottom sheet AddressPickerDialog multi
5. Section "HOẠT ĐỘNG"
6. **Chips row** wrap: `[Có nhu cầu][Có GD][Có lịch hẹn][Có công việc][Không có gì]` — toggle multi, active fill `$primary-soft`
7. Section "KHOẢNG THỜI GIAN"
8. **Date card** — preset chips (Hôm nay `$pill-amber` active / 7 ngày / 30 ngày / Tháng này / Custom) + (nếu Custom) row 2 date field

### 6.3 Footer — absolute `[0,772]`, 390×72, border-top
Left: "Kết quả **N** / total" — Right: button primary 44 "✓ ÁP DỤNG (N)".

---

## 7. Dialog "Thêm khách" — 3 branch

Desktop: modal 520×auto. Mobile: bottom sheet full-width.

### 7.1 Step 1 — Nhập phone (common)

- Title "Thêm khách hàng"
- Field SĐT: input 48, placeholder "Nhập số điện thoại…", format `+84` auto, validation regex VN phone
- Footer: btn outline "Huỷ" + btn primary "Tiếp tục" (disabled nếu invalid)

Submit → `GET /api_agent/lookup_customer.json?phone=<normalized>`.

### 7.2 Branch A — Phone chưa có

Expand dialog → full form:

| Field | Required | Note |
|---|---|---|
| Họ tên | ✅ | |
| SĐT | ✅ | prefilled từ step 1 |
| Email | — | |
| Địa chỉ | — | AddressPickerDialog trigger |
| Thẻ | — | Multi-tag select |
| Ghi chú | — | Textarea |

Footer: "Huỷ" + primary "Thêm khách".
Submit → `POST /api_agent/add_customer.json` → success → toast "Đã thêm khách" + redirect `/khach-hang/[id]`.

### 7.3 Branch B — Phone có, chưa ai chăm

Replace form bằng info panel:

```
┌─────────────────────────────────────────┐
│ Khách đã tồn tại (chưa có người chăm)   │
├─────────────────────────────────────────┤
│ 👤 Anh Tú                               │
│ 📞 0971621429                           │
│ 📍 Cầu Giấy, Hà Nội                     │
│ 🏷️ Nguồn: Tự đăng ký app                │
│ 🔗 Đã xuất hiện trong:                  │
│   • Nhu cầu #123 "Mua chung cư"         │
│   • Nhu cầu #98 "Thuê văn phòng"        │
├─────────────────────────────────────────┤
│ Nhận khách này làm khách của bạn?       │
│                    [Huỷ] [Nhận khách]   │
└─────────────────────────────────────────┘
```

- Info 2-col grid mobile → 1-col
- Nguồn: pill chip 11/700
- Linked entities: list max 3, "Xem thêm" nếu >3, mỗi item click → navigate `/nhu-cau/[id]` (open new tab)

Submit "Nhận khách" → `POST /api_agent/claim_customer.json { customer_id }`:
- **200** → toast "Đã nhận khách" + redirect `/khach-hang/[id]`
- **409 Conflict** → thay panel bằng empty state: "Khách vừa được agent khác nhận." + btn "Đóng"

### 7.4 Branch C — Phone có, đã có người chăm

```
┌─────────────────────────────────────────┐
│ ⚠ Khách đã có người chăm                │
├─────────────────────────────────────────┤
│ 👤 Anh Tú                               │
│ 📞 0971621429                           │
│ 👤 Người chăm: Nguyễn Văn A             │
│ 🏢 VP Cầu Giấy                          │
├─────────────────────────────────────────┤
│ Liên hệ người chăm nếu cần phối hợp.    │
│                              [Đóng]     │
└─────────────────────────────────────────┘
```

- Icon warning orange + title red-800
- Không có action "Nhận khách"
- Nếu viewer có role manager/admin → show thêm btn "Gán cho sales khác" → open Dialog §8 với customer_id prefilled

**Privacy note**: agent không thuộc cùng office có thể chỉ thấy "Đã có người chăm" generic (xem BE Q#19).

---

## 8. Dialog "Gán sales / Gán office"

Modal 480×auto. Trigger từ menu more (§2.2) hoặc Branch C (§7.4).

### 8.1 Gán sales (role: manager)
- Title "Gán khách cho sales"
- Field customer readonly header (avatar + tên + phone)
- Current assignee row (nếu có): "Hiện tại: Nguyễn A"
- Dropdown "Chọn sales" — search, filter agent trong cùng office, list avatar + tên + workload (N khách đang chăm) — optional metric
- Textarea "Ghi chú (hiển thị trong lịch sử)" — optional
- Footer: "Huỷ" + primary "Gán"

Submit → `POST /api_agent/assign_customer_to_sales.json { customer_id, agent_id, note? }`.
Success: toast + timeline append `ownership_change` event + notification gửi sales mới.

### 8.2 Gán office (role: admin)
Giống 8.1 nhưng field là **office dropdown** (list chi nhánh). Endpoint `assign_customer_to_office.json`.

---

## 9. Notifications

| Event | Trigger | Payload | Deeplink |
|---|---|---|---|
| Được giao khách | Manager/admin assign | `{ type: 'customer_assigned', customer_id, from_agent, to_agent, note? }` | `/khach-hang/[customer_id]` |
| Khách liên kết mới | Nhu cầu/GD/LH được tạo với agent là assignee | `{ type: 'customer_linked', customer_id, entity_type, entity_id }` | `/khach-hang/[customer_id]` |

Reuse notification type 1 (Giao dịch/system) hay type mới — xem BE Q#18.

---

## 10. Responsive breakpoints

| Breakpoint | Behavior |
|---|---|
| `<640px` (mobile) | §4 §5 §6, dialog → bottom sheet, grid 1 col |
| `640–1024` (tablet) | Desktop layout, grid 2 col, filter bar wrap 2 row |
| `>1024` (desktop) | Full §1 §2 §3, grid 3–4 col |

---

## 11. Accessibility

- Mọi interactive element có focus ring `$primary/40` 2px
- Ownership badge có `aria-label` "Khách của tôi" / "Khách liên kết"
- Lock icon có `aria-describedby` tooltip content
- Timeline heading có `role="heading" aria-level="3"` per date group
- Dialog Thêm khách phone field: `aria-live="polite"` announce kết quả lookup
- Keyboard: `Enter` trong phone field → submit lookup; `Esc` → close dialog

---

## 12. Open UI decisions (cho design phase)

- Avatar: có upload trong form edit không, hay chỉ placeholder default (V1 Flutter chỉ dùng default)?
- Timeline pagination: "Xem thêm" button hay infinite scroll?
- Branch C: phạm vi thông tin hiển thị cross-office (privacy) — BE Q#19
- Counter chips card mobile: wrap hay scroll horizontal khi >3?
- Badge `both-self-linked` (vừa self vừa linked): hiển thị 1 badge gộp hay 2 badge cạnh nhau?

---

## 13. Related BE questions

Xem **Section 6** của [brainstorm-260424-1316-khach-hang-optimize.md](../../plans/reports/brainstorm-260424-1316-khach-hang-optimize.md) — 19 câu hỏi BE cần clarify trước khi impl Phase 2+.

---

<a id="docs-screens-nhu-cau-screens-md"></a>

## docs/screens/nhu-cau-screens.md

---
title: Nhu cầu — System Design (Screens Spec)
source: Design/nhu cau.pen (8 frames)
updated: 2026-04-23
related:
  - plans/260423-1217-nhu-cau-consultation-phase-1/plan.md
  - docs/02-api-catalog.md §9 Consultation
  - docs/screens/design-tokens.md
---

# Nhu cầu — Screens Spec

Spec canonical cho module **Nhu cầu (Consultation)**, sync từ `Design/nhu cau.pen`.

## Frame map

| # | ID | Name | Viewport |
|---|----|------|----------|
| 1 | `bi8Au` | Desktop List | 1520×1020 |
| 2 | `DvGZD` | Desktop Detail — No Broker | 1520×1020 |
| 3 | `4n6Ub` | Desktop Detail — With Broker | 1520×1080 |
| 4 | `XrWN9` | Mobile List | 390×844 |
| 5 | `6BHJv` | Mobile Detail | 390×844 |
| 6 | `ST7BS` | Mobile Filter (bottom sheet fullscreen) | 390×844 |
| 7 | `tOdYC` | Tag Popup — Desktop (dialog 920×680) | 1200×820 |
| 8 | `04Tkq` | Tag Popup — Mobile (bottom sheet) | 450×900 |

Token ref: [design-tokens.md](./design-tokens.md) (`$bg-card`, `$bg-page`, `$primary`, `$accent-indigo`, `$text-primary`, `$text-secondary`, `$text-muted`, `$text-muted-2`, `$text-link`, `$border-muted`, `$border`, `$neutral-100..200`, `$surface`, `$surface-muted`, `$pill-mint|rose|amber`, `$indigo-soft`, `$primary-soft`, `$accent-green-light`, `$radius-sm|md|pill`).

---

## 1. Desktop List (`bi8Au`)

Layout vertical, gap 16, padding `[24,28,32,28]`, fill `$bg-page`.

### 1.1 Filter Bar (`xZkdb`)

Card `$bg-card`, padding `[14,16]`, gap 10, border `$border-muted`, radius `$radius-md`.

Row ngang gồm (tất cả height 40, radius `$radius-sm`, border `$border-muted`):

| Control | Width | Note |
|---|---|---|
| DD Văn phòng | 160 | Dropdown |
| DD Người phụ trách | 190 | Dropdown |
| Search Input | 260 | Placeholder "Mã nhu cầu, SĐT khách hàng…" |
| DD Ngày tạo | 120 | Preset (Hôm nay / 7 ngày / 30 ngày / Tháng này) |
| Date Range | 220 | 2 ngày ngăn cách bằng → |
| DD HOẶC | 88 | Combinator tag (HOẶC / VÀ) |
| DD Thẻ Tag | 180 | Multi-select |
| *(spacer fill)* | fill | |
| Btn Filter | 42 | Icon-only, outline `$accent-indigo` |
| Btn Search | 50 | Primary `$accent-indigo` |
| Btn + TẠO | fit | Outline `$accent-indigo`, icon + text |

### 1.2 Tabs Card (`9CQYL`)

Card trắng, padding `[4,20,0,20]`, radius `$radius-md`. 4 tabs gap 32:

| Tab | Label | Badge fill | Active |
|---|---|---|---|
| Tất cả | 2179 | `$primary-soft` | ✓ (underline 2px `$border-muted` → prod dùng `$primary`) |
| Mới | 2042 | `$surface-muted` | |
| Đang diễn ra | 37 | `$surface-muted` | |
| Kết thúc | 97 | `$surface-muted` | |

Badge pill `$radius-pill`, height 22, padding `[0,10]`. Font tab 14/600 active, 14/500 inactive.

### 1.3 Action Pills (`LNlm4`)

4 pill height 36, radius `$radius-sm`, padding `[0,16,0,14]`, gap 12. **Chỉ hiện khi có checked rows**:

| Pill | Fill | Icon (lucide) | Text color | Label |
|---|---|---|---|---|
| Nhân viên | `$pill-mint` | user-plus | `#0D7C4D` | THÊM NHÂN VIÊN PHỤ TRÁCH |
| Thẻ Tag | `$pill-rose` | tag | `#BE1F3D` | THÊM THẺ TAG |
| Văn phòng | `$pill-amber` | briefcase | `#9A5B0B` | GÁN VĂN PHÒNG |
| Gộp | `$pill-rose` | git-merge | `#BE1F3D` | GỘP NHU CẦU |

Text 11/700, letter-spacing 0.4.

### 1.4 Table (`xXXAx`)

Card trắng, border `$border-muted`, radius `$radius-md`, clip.

**Header** (`UoqSZ`) height 52, fill `$bg-header`, border-bottom 1 `$border-muted`, padding `[0,16]`:

| Col | Width | Label | Note |
|---|---|---|---|
| h0 | 56 | □ | Checkbox (+ expand chevron cho row) |
| STT | 44 | STT | |
| Khách hàng | 200 | Khách hàng | 2 dòng: tên / SĐT |
| Nhu cầu | 180 | Nhu cầu | "Giá: x tỷ" / "Diện tích: y m²" |
| Khu vực | 150 | Khu vực | Link `$text-link` |
| Đầu chủ | 140 | Đầu chủ | Fallback "Chưa có môi giới" `$text-muted` |
| Đầu khách | 80 | Đầu khách | |
| VP/Người | 190 | Văn Phòng / Người phụ trách | 2 dòng icon 🏢/👤 |
| Thẻ Tag | 160 | Thẻ Tag | Chips + color squares row |
| Nguồn | 160 | Nguồn | Tên + timestamp |
| Trạng thái | 100 | Trạng thái | Pill `$accent-green-light` |

**Row** (`jQBbt`…`O5vvO`) height 72, fill `$bg-card`, border-bottom 1. Font cell 12–13/normal–500.

---

## 2. Desktop Detail — No Broker (`DvGZD`)

Mã minh hoạ `#3036`. Vertical, gap 14, padding `[20,28,32,28]`.

### 2.1 Breadcrumb (`Si4CJ`)
`Tổng quan › Nhu cầu › #3036` — icon lucide chevron-right 13px, text 12, `#3036` bold `$text-primary`.

### 2.2 Page Header (`st84Z`)
Row gap 14, padding `[0,4]`:
- `iBack` 36×36 pill border — lucide arrow-left
- Title wrap: tên KH 20/700 + badge trạng thái "Đang xử lý" pill
- *(spacer fill)*
- `dTagBtn` — outline `#10B981` 1.5px, label "Thêm thẻ"
- `dMore` 36×36 — lucide more-horizontal
- `dClose` — label "Đóng nhu cầu" + icon lucide x

### 2.3 Stats Strip (`koRrw`)
Card height 64, radius `$radius-md`, border `$border-muted`, padding `[0,22]`. 4 ô chia đều, divider 1×36 `$neutral-200` giữa:

| Stat | Value sample | Icon |
|---|---|---|
| BDS đang khớp | 0 | grid |
| agent đã tư vấn | 0 | user-check |
| Lượt xem | 5 | eye |
| Thời gian xử lý | 0 ngày | clock |

### 2.4 Grid (`mB65a`) — gap 14
- **Left** (`xEJpz`) width 400, vertical, gap 12 — card **Customer** (`LWhab`)
- **Right** (`dlRwh`) fill, vertical, gap 12 — **Hero Empty** + **Activity**

#### Left → Customer card (`LWhab`)
Radius `$radius-md`, border `$border-muted`, padding 18, gap 16.

Children theo thứ tự:
1. `dCTop` — avatar 40 + tên KH + mã `#3036` + phone icons (call/msg)
2. `dSecT` — section title "Nhu cầu mong muốn" + link "Sửa"
3. `dHLw` — pill "Mua bán" indigo-soft (hoặc "Thuê", "Cho thuê")
4. `dRow` — 2 cột KV (Ngân sách / Diện tích) `1-2 tỷ` / `—`
5. `dKV` — Pill "TP. Đồng Hới - Quảng Bình"
6. `aRyXi` **Linked BDS Section** — header "BDS/Dự án Quan Tâm" + count + row card BDS (thumb 48 + mã "MBGD5360764" + địa chỉ + giá "1.3 tỷ · 740 m²" + icon link-external)

#### Right → Hero Empty (`rh9vZ`)
Card border `$indigo-soft` 2px, radius `$radius-md`, padding `[36,40]`, gap 22, align center, fill `$bg-card`.
- Circle 72 `$indigo-soft` + icon lucide user-search
- H1 "Chưa có Môi giới" 18/700
- Sub "Hãy bắt đầu tìm BDS phù hợp để gán môi giới cho nhu cầu này" `$text-muted-2` 13
- Row 2 button: primary `$accent-indigo` "Tìm kiếm BĐS phù hợp" + outline "Đơn đầu vào nhu cầu"
- Tips row gap 18 (3 icon+label: "Matching từ Đồng tiền khu", "Xem theo ngân sách + diện tích", "Lưu lại giao dịch agent")

#### Right → Activity (`H92vg`)
Radius `$radius-md`, border, padding `[16,20]`, gap 14.
- Header "Lịch sử hoạt động" + link "Xem tất cả"
- Row event: avatar 32 + tên "Tạo nhu cầu" badge orange + user "nguyen van dai" + time "16:56 hôm nay"

---

## 3. Desktop Detail — With Broker (`4n6Ub`)

Mã `#691`. **Giống No Broker** ở Breadcrumb / Header / Stats / Left card.

Khác biệt ở Right column (`rPRhC`):

### 3.1 Broker Panel (`wr65Q`)
Card border, radius `$radius-md`:
- `XmSPG` header (border-bottom) — avatar 40 "PH" + tên "Phạm Hùng" + badge "Đầu chủ" `$accent-green-light` + *(fill)* + actions call/msg
- `vKrP2` info — địa chỉ chi tiết + "1.300.000.000 đ" + cột phải "740 m²" + badge "Đồng nộp hợp đồng"
- `cNjOu` **BDS Section** — thumb 80 + mã "Đơn cốc thấn Vụ Bí, xã Vũ Bản, 740m² giá 1.3 tỷ" + row action primary "Đầu dịch đăng" + outline "Đăng agent"

### 3.2 Tasks (`QNK17`)
Card border, padding `[16,20]`, gap 12.
- Header "Công việc triển khai" + link "Thêm công việc"
- Row task `hxDQU` fill `$neutral-100`, padding `[12,14]`:
  - Icon trạng thái (circle 18) + 2 dòng: "Đặt lịch xem nhà" + "22/05/2026 · 16:00" + actions phải

---

## 4. Mobile List (`XrWN9`)

390×844, vertical, fill `$bg-page`.

| Section | Height | Note |
|---|---|---|
| Status Bar (`rJvHB`) | 32 | 9:41 + signal |
| App Bar (`anZEP`) | 56 | back 36 + "Nhu cầu" 17/700 + badge count "2179" `$primary-soft` + *(fill)* + search icon + filter icon (outline `$accent-indigo`) |
| Tabs Mobile (`xS8Lc`) | 48 | 4 tabs gap 22: Tất cả (active underline) / Mới (2042) / Đang diễn ra / Kết thúc |
| List Area (`i2FGh`) | fill | Vertical, gap 10, padding 12, 4 card |
| FAB (`vmxoW`) | absolute `[244, 772]` | pill, fill `$accent-indigo`, shadow blur 16 color `#6366F155`, icon plus + "TẠO NHU CẦU" 12/700 |

### 4.1 List Card (`oIDhi`)
Radius `$radius-md`, border, padding 14, gap 10, fill `$bg-card`.
- `c1Top` — "#3038" bold + "Nguyễn Hoàng" + badge "KH" pill + *(fill)* + badge "Tạo mới" `$accent-green-light`
- Phone "098.735.7333"
- `c1Budget` — 2 cột: "Ngân sách 1.00 tỷ - 2.00 tỷ" / "Diện tích —"
- `c1Loc` — icon + "Thành Phố Đồng Hới"
- `c1Off` — icon briefcase + "VP Quảng Bình · nguyen van dai" + badge source "GDX"
- `O9gO3` Tags Row — "+" chip outline + 2–3 tag chips (ví dụ "L0-Lead tới ưu" amber, tag xanh, tag xanh dương)
- `vFXSR` Date Row — "16:56 22/04/2026" right-aligned `$text-muted` 11

---

## 5. Mobile Detail (`6BHJv`)

390×844. Stack: Status / App Bar / Scroll Area / Bottom Bar.

### 5.1 App Bar (`T4VpM`) — 56
- Back pill 36
- Title wrap vertical gap 6 — "Nhu cầu #3036" 16/700 + "Nguyễn Hoàng" 12 muted
- *(fill)* + action more 36

### 5.2 Scroll Area (`KsoqS`) — padding `[12,12,80,12]`, gap 12

Children (tất cả card `$bg-card`, radius `$radius-md`, border `$border-muted`, padding 14):

#### Summary (`pRsMJ`)
- `vvxtf` row — avatar "NH" 40 + tên "Nguyễn Hoàng" + badge "KH" + *(fill)* + "Tạo mới" tag + "0987357333 · 22/04/2026"
- `FyPzf` Tags Wrap vertical gap 6:
  - "THẺ GẮN" label 11/700 uppercase + link "Quản lý" phải
  - Row chips: "L0-Lead tới ưu" (mint), "NQXH Bảo Ninh 2" (amber), "VIP" (outline)

#### Need (`QYqA4`)
- `VHVyR` header "NHU CẦU MONG MUỐN" 11/700 + link "Sửa"
- `jY20Y` pill "Mua bán" `$indigo-soft`
- `aEXI0` mNGrid — 2 cột: "Ngân sách 1-2 tỷ" / "Diện tích —"
- `AlWJp` pill "TP. Đồng Hới - Quảng Bình" `$indigo-soft`
- `fnITs` Linked BDS — header "BDS/DỰ ÁN QUAN TÂM" + count; row thumb 56 + "MBGD5360764" + "Đất nền thân Vũ Bí, xã Vũ Bản" + "1.3 tỷ · 740 m²" + icon external

#### Ghi chú Mobile (`qBqqL`) — fill `$surface`, border `$border`
- `bJx8G` header "Ghi chú" + button outline primary "+ Thêm"
- `KDVl2` Note item fill `$bg`, radius `$radius-sm`, padding 12, gap 10:
  - Avatar 24 + "nguyen van dai" + "Hôm nay · 17:02" + kebab
  - Body text 13 — *"Khách tâm chính 2PN hướng Đông Nam, đã xem online 3 căn. Chuyển cho Uyên follow sau 16h chiều này."*
  - Row action: "📎 Ghim" + "✎ Sửa"

#### Stats Strip Mobile (`k7dBb`) — height 58
4 ô `mSsA..D` fill chia đều, divider 1×28: BDS khớp / Tư vấn / Xem / Ngày.

#### Hero Empty (`89QUT`) — khi chưa có môi giới
Border `$indigo-soft` 2px, padding `[22,16]`, gap 14, center.
- Circle 56 `$indigo-soft` + icon
- Title "Chưa có Môi giới" 15/700
- Sub "Tìm BDS phù hợp để gán Đầu chủ" 12 `$text-muted-2` center fixed-width 320
- Button full-width 44 primary `$accent-indigo` "Tìm BĐS phù hợp"

#### Activity Mobile (`kI1BN`)
Header "Lịch sử hoạt động" + "Xem tất cả" + event row 1.

### 5.3 Bottom Bar (`vMjgj`) — absolute `[0, 772]`, 390×72
Fill `$bg-card`, border-top 1 `$border-muted`, padding `[12,16,16,16]`, gap 10:
- Square 44 outline `$accent-indigo` — icon call
- Fill button 44 `$bg-card` border `$neutral-200` — "✓ ĐÓNG NHU CẦU"

---

## 6. Mobile Filter (`ST7BS`)

Bottom sheet fullscreen 390×844. Stack: Status / App Bar / Body scroll / Footer fixed.

### App Bar (`fd1XR`) — 52
Back 36 + Title wrap vertical ("Bộ lọc" 16/700 + "3 bộ lọc đang áp dụng" 11 muted) + *(fill)* + reset 32 "↻ Đặt lại".

### Body (`fcmkw`) — padding `[12,12,80,12]`, gap 10
1. **Search** (`Ks4ma`) 44 — icon search + "Mã NC, SĐT khách hàng…" + icon scan
2. **Segment Status** (`WRqVK`) 38 fill `$surface-muted`, padding 4 — 4 segment: Tất cả (active white) / Mới / Đang xử lý / Kết thúc
3. Section header "PHẠM VI" 10/700 `$text-muted`
4. **Văn phòng select** (`Ql28E`) 56 — icon briefcase + label "Văn phòng" + value "VP Quảng Bình" + chevron-right
5. **Người phụ trách select** (`si5sw`) 56 — icon user + "Người phụ trách" + "Tất cả" + chevron
6. Section header "NGÀY TẠO"
7. **Date card** (`nCVvu`) — presets chip row (Hôm nay active `$pill-amber` / 7 ngày / 30 ngày / Tháng này) + row 2 date field ngăn bằng →
8. Header "THẺ TAG" + toggle segment "HOẶC / VÀ"
9. **Tag card** (`xnWZa`) — chips đã chọn ("L0-Lead tới ưu" × / "NQXH Bảo Ninh 2" ×) + "+ Chọn thêm thẻ"

### Footer Fixed (`B55HC`) — absolute `[0,772]`, 390×72, border-top
Left: count result "Kết quả **40** / 2179" — Right: button primary 44 "✓ ÁP DỤNG (3)".

---

## 7. Tag Popup — Desktop (`tOdYC`)

Modal overlay `#0F172A66`. Dialog `T1RrH` 920×680 center `[140, 70]`, shadow blur 32 `#00000026`.

### Dialog stack
- **Header** (`dgVKb`) 64 border-bottom, padding `[0,20,0,24]`, gap 12:
  - Icon tag `$primary` 20 + "Cập nhật thẻ Tag" 18/700 + *(fill)* + close ×
- **Tabs** (`mnYqu`) 48 border-bottom, padding `[0,24]`, gap 24:
  - "Chọn thẻ Tag" active underline `$primary` / "Lịch sử theo tác"
- **Body** (`E3lfz`) fill, vertical, gap 16, padding `[20,24]`, fill `$bg`:
  - **Group card** per category — fill `$bg-card` / `$surface`, border, padding, gap 12:
    - Header: icon `$primary` + tên category ("Sale - Trạng thái nhu cầu") + badge mode "Chọn 1" (hoặc "Chọn nhiều")
    - Chips wrap: mỗi tag pill `$radius-pill`, height 28, padding `[0,12]`, fill color riêng (slate/indigo/blue/green/amber/red), text trắng 12/600. Checkbox 14 bên trái (square/check-square).
  - 2 group (Sale / CC - Chăm sóc lại) — tag ví dụ: "L0 - Khách tự tìm của ưa", "L1 Không nghe máy/Thuê bao", "L2.1 Bận gọi lại sau", "L3 Hẹn gặp", "L3 Quan tâm, gọi thông tin", "L4 Đã gặp", "L5 Đã cọc/booking", "L6.2 Hoàn tiền", "L7 Không còn nhu cầu nữa"…
- **Footer** (`wcSNt`) 72 border-top, padding `[0,24]`, gap 12, justify end, fill `$surface`:
  - Left "Đã chọn 2 thẻ" `$text-muted`
  - Button ghost "ĐÓNG" + button primary `$accent-indigo` "💾 LƯU THẺ TAG"

---

## 8. Tag Popup — Mobile (`04Tkq`)

Overlay `#0F172A66`. Sheet `3haAV` 390×844 top `[30,28]`, radius top `[16,16,0,0]`, shadow blur 32 offset `y:-8`.

### Sheet stack
- **Grab Handle** (`BeTvA`) 18 — pill 40×4 `$neutral-200` center
- **Header** (`i94fJ`) 50 border-bottom, padding `[0,16]` — icon tag + "Cập nhật thẻ Tag" 15/700 + *(fill)* + close
- **Tabs** (`xU7o3`) 44 border-bottom — "Chọn thẻ" active / "Lịch sử"
- **Selected Bar** (`0Sf6m`) fill `$primary-soft`, padding `[10,14]`, vertical gap 8:
  - Row "ĐÃ CHỌN 2 THẺ" 10/700 + link "Xoá tất cả" phải
  - Chips đã chọn (removable ×)
- **Body** (`4adrA`) fill, vertical gap 12, padding 14, clip:
  - Group card "Sale - Trạng thái" — header + badge "Chọn 1" + chips wrap
  - Group card "CC - Chăm sóc lại" — header + "Chọn nhiều" + chips wrap (variants colors)
- **Footer** (`43FbW`) 72 border-top, padding `[12,14,16,14]`, gap 10:
  - Button ghost "ĐÓNG"
  - Button primary fill `$accent-indigo` "💾 LƯU THẺ TAG (2)"

---

## 9. Interaction flows

### 9.1 List → Detail
- Desktop: click row → route `/nhu-cau/{id}` (Desktop Detail). Checkbox header + row reveal Action Pills (`LNlm4`).
- Mobile: tap card → route `/nhu-cau/{id}` (Mobile Detail).

### 9.2 Filter
- Desktop: inline filter bar (`xZkdb`) — submit qua Btn Search.
- Mobile: tap filter icon AppBar → Mobile Filter sheet → ÁP DỤNG.
- Date preset chip + 2-field custom coexist (preset hi-lights khi cover exactly range).
- Tag combinator HOẶC / VÀ toggle apply cho query param `tag_combinator`.

### 9.3 Tag attach
- Entry: `dTagBtn` (desktop header) / `LMMfC` (no-broker header) / `iTagBtn` (with-broker header) / "Quản lý" link trong Summary mobile / "+ Thêm thẻ" row.
- Desktop → `tOdYC` dialog ; Mobile → `04Tkq` sheet.
- Chọn xong → `POST /tag_management/assign_tags_to_entity` `{entity_type:'consultation', entity_id, tag_ids[], replace:true}`.

### 9.4 Close nhu cầu
- Desktop: `dClose` button header → confirm → `PUT /api_agent/update_demand` `status_info.status=closed`.
- Mobile: Bottom Bar button "ĐÓNG NHU CẦU".

### 9.5 Add note
- Desktop: Activity card chưa có compose inline (phase 2).
- Mobile: Ghi chú card → "+ Thêm" → compose inline (title "Ghi chú", body textarea) → `POST /api_agent/salesman_comments`.

### 9.6 Linked BDS
- Section "BDS/Dự án Quan Tâm" (Left card desktop / Need card mobile) — lấy từ `GET /api_agent/demand_suggest.json?consultation_id=`.
- Row action icon `external-link` → route `/bds/{code}`.

### 9.7 Hero Empty → match broker
- `rh9vZ` / `89QUT` "Tìm BĐS phù hợp" → route `/bds?match=consultation&id={id}`.

---

## 10. Responsive rules

| Breakpoint | Layout |
|---|---|
| ≥1280 | Desktop list / detail 2-col grid (Left 400 + Right fill) |
| 1024–1279 | Desktop layout collapse Left to 360, giữ 2-col |
| 768–1023 | Stack vertical (Left trên, Right dưới), filter bar wrap 2 hàng |
| <768 | Mobile frames (`XrWN9`, `6BHJv`, `ST7BS`, `04Tkq`) |

FAB chỉ show `<768`. Action Pills desktop: hide `<1024` (dùng bottom sheet thay).

---

## 11. Token mapping (quick ref)

> **Project override (2026-04-23):** `.pen` design dùng indigo cho primary; project đã chốt **orange** primary (`design-tokens.md` update 2026-04-18). Nên trong code: `$accent-indigo` / `$primary` / `$primary-soft` / `$indigo-soft` / `$text-link` (.pen) → `--primary` / `--primary-soft` (orange).


| Token | Sample | Usage |
|---|---|---|
| `$bg-page` | soft gray | page bg |
| `$bg-card` | white | card/row/header surface |
| `$bg-header` | gray-50 | table header |
| `$surface` | white | dialog surface, note card |
| `$surface-muted` | gray-100 | segment inactive, tab badge inactive |
| `$border-muted` | gray-200 | card border, row divider |
| `$border` | gray-300 | dialog border |
| `$primary` | indigo-600 | active tab text, brand link |
| `$primary-soft` | indigo-50 | badge, selected bar, badge count |
| `$accent-indigo` | indigo-500 | primary button, FAB, search button |
| `$accent-green-light` | emerald-100 | status "Tạo mới" pill |
| `$indigo-soft` | indigo-100 | Hero Empty border + pill Mua bán |
| `$pill-mint` | emerald-50 | Action pill "Nhân viên" |
| `$pill-rose` | rose-50 | Action pill "Thẻ Tag" / "Gộp" |
| `$pill-amber` | amber-50 | Action pill "Văn phòng" / date preset active |
| `$text-primary` | slate-900 | title, value |
| `$text-secondary` | slate-600 | label, body |
| `$text-muted` | slate-500 | placeholder, meta |
| `$text-muted-2` | slate-400 | breadcrumb inactive, sub-copy |
| `$text-link` | indigo-600 | location link |
| `$radius-sm` | 6 | button, input, card small |
| `$radius-md` | 10 | card, dialog |
| `$radius-pill` | 999 | pill, badge, avatar |

---

## 12. Unresolved

- Exact color values của `$pill-*`, `$accent-green-light`, `$indigo-soft` — cần confirm với `design-tokens.md` hoặc export từ .pen `get_variables`.
- Active underline fill hiện đang là `$border-muted` trong .pen (should be `$primary`) — verify intent.
- Action Pills — luật show/hide theo số rows checked chưa ghi trong .pen; mặc định hiện khi `>0`.
- Hero Empty copy desktop (`rh9vZ`) vs mobile (`89QUT`) khác nhau ("gán môi giới" vs "gán Đầu chủ") — chốt 1 wording.
- Tag popup "Lịch sử theo tác" (tab 2) layout chưa có frame — phase 2.
- Inline edit field "Nhu cầu mong muốn" (Sửa link) chưa có design modal/inline — phase 2.
- Filter bar mobile — Segment Status có 3 item nhưng desktop tabs 4 item (Tất cả/Mới/Đang diễn ra/Kết thúc vs Tất cả/Mới/Đang xử lý/Kết thúc). Wording "Đang diễn ra" vs "Đang xử lý" cần align.

---

<a id="docs-screens-phase-02-screens-md"></a>

## docs/screens/phase-02-screens.md

---
title: Phase 02 screens — Auth + Layout Shell
type: design-spec
level: high-level
phase: 02
audience: Pencil AI designer
date: 2026-04-17
related:
  - plans/260417-1558-webapp-agent-mvp/phase-02-auth-and-session.md
---

# Phase 02 — Screens spec (high-level)

Target: Pencil AI tự fill layout. Chỉ mô tả purpose + key sections.

## Brand context

- Vietnamese UI, locale vi
- Tool nội bộ Agent BDS — professional, density cao, không marketing-y
- shadcn/ui base (radix) + Tailwind v4
- Desktop-first responsive, mobile subset

---

## 1. Login (`/login`)

**Purpose**: Agent đăng nhập bằng số điện thoại + password.

**Key sections:**
- Logo "Tổng Kho BDS" + tagline
- Form: input phone, input password (toggle visibility), checkbox "Ghi nhớ", button "Đăng nhập"
- Links: "Quên mật khẩu?" → `/forgot-password`
- Footer: version + support contact

**States**: idle · loading (button disabled, spinner) · error (toast "Sai số điện thoại hoặc mật khẩu")

**Responsive**: Desktop center card 400px. Mobile full-width card với safe padding 24px.

---

## 2. OTP verify (`/otp-verify`)

**Purpose**: Nhập 6 số OTP gửi tới SMS sau login (nếu BE yêu cầu 2FA).

**Key sections:**
- Heading "Nhập mã xác thực"
- Subtitle "Mã đã gửi tới số điện thoại ending ***1234"
- 6-digit OTP input (segment boxes, auto-focus next)
- Resend timer "Gửi lại sau 60s" → "Gửi lại" sau timeout
- Button "Xác nhận"
- Link "Dùng email thay thế" (optional)

**States**: idle · loading · error (OTP sai, shake animation) · success → redirect dashboard

---

## 3. Forgot password (`/forgot-password`)

**Purpose**: Reset password qua OTP.

**Multi-step wizard (3 step):**

**Step 1 — Nhập số điện thoại**
- Input phone + button "Gửi OTP"

**Step 2 — Nhập OTP**
- 6-digit OTP input + resend timer
- Button "Xác nhận"

**Step 3 — Đặt mật khẩu mới**
- Input new password (toggle visibility) + strength indicator
- Input confirm password
- Button "Cập nhật" → success toast → redirect `/login`

**Progress indicator**: 3-step dot navigation trên top.

---

## 4. Dashboard shell (layout — áp dụng tất cả màn protected)

**Purpose**: Chrome wrap cho toàn bộ trang sau login.

**Layout structure:**

### Desktop (> 1024px)
```
┌─────────────────────────────────────────────────────┐
│ Topbar: logo | search | notification | avatar menu  │
├──────────┬──────────────────────────────────────────┤
│ Sidebar  │                                          │
│ (fixed   │  Main content area                       │
│  240px)  │  (page.tsx render here)                  │
│          │                                          │
│ - BDS    │                                          │
│ - Dự án  │                                          │
│ - ...    │                                          │
└──────────┴──────────────────────────────────────────┘
```

### Tablet (768–1024px)
- Sidebar collapsible (icon-only 64px) + toggle

### Mobile (< 768px)
- Topbar: burger menu + logo + bell
- Sidebar → Sheet (slide-in từ left)
- No persistent sidebar

**Topbar components:**
- Logo "Tổng Kho BDS" (click → dashboard home)
- Global search input (desktop only, icon on tablet/mobile)
- Notification bell với badge đỏ count unread (phase 05 wire real)
- Avatar dropdown: Hồ sơ · Cài đặt · Đăng xuất

**Sidebar menu** (capability-filtered):
- Trang chủ
- BDS (submenu: Danh sách, SP của tôi, Yêu thích)
- Dự án
- Bảng hàng
- Giao dịch
- Đặt cọc
- Nhu cầu
- Khách hàng
- Hợp đồng
- Lịch hẹn
- Bản đồ
- Team management *(leader only)*
- Xếp hạng
- Thông báo

**Avatar dropdown**:
- Avatar image (fallback initials) + full_name + award badge (ví dụ "Giám đốc chi nhánh")
- Hồ sơ của tôi
- KYC status indicator — step_name thực tế: "Đã duyệt" (step 3) / "Chờ duyệt" (step 2) / "Chưa gửi" (step 1)
- Đăng xuất

---

## 5. Home (`/` protected)

**Purpose**: Dashboard overview, quick stats + shortcuts.

**Key sections:**
- Greeting `"Chào anh {first_name}!"` — lấy từ `/get_user_profile.json` → `data.first_name` (e.g. "Tuấn")
- Stats cards (4 cards) — data từ `/dashboard_stats.json` → `data.stats.data[]`:
  - `posted_news` — "Tin BĐS đã đăng" (unit: Tin)
  - `caring_customers` — "Đang chăm sóc" (unit: Khách)
  - `deals_in_month` — "Deal trong tháng" (unit: Deals)
  - `deposit_invoices` — "Hoá đơn đặt cọc" (unit: Phiếu)
  - Mỗi card có: icon SVG (embedded từ BE), title, value, unit, change % so với kỳ trước
- Quick actions: button "Tạo BDS" · "Thêm khách" · "Tạo nhu cầu" · "Xem bảng hàng"
- Recent activity list: 5 latest notifications preview
- KYC banner nếu `step < 3`: "Hoàn thành KYC để mở khoá tính năng" → CTA "Hoàn thành ngay"

**Responsive**: Desktop 4-col grid stats, tablet 2-col, mobile 1-col.

---

## Real data — UserProfile shape

Từ `GET /api_agent/get_user_profile.json` (token auth):

```json
{
  "id": 322,
  "salesman_id": 13376,
  "username": "0356656777",
  "first_name": "Tuấn",
  "last_name": "Anh",
  "full_name": "Tuấn Anh",
  "email": "anh.nt@tongkhobds.vn",
  "phone": "0356656777",
  "image": "https://quanly.tongkhobds.com/tongkho/static/uploads/user/...jpg",
  "city_name": "Nghệ An",
  "city_id": "40",
  "district_name": "Thành phố Vinh",
  "district_id": "40412",
  "yoe": 0,
  "citizen_id_front": "https://.../salesman.citizen_id_front...jpg",
  "citizen_id_back": "https://.../salesman.citizen_id_back...jpg",
  "birthday": "2005-01-27",
  "address": "7PC7MMGF+7W",
  "sex": "Nam",
  "id_card": "123456789123",
  "id_day": "2005-01-22",
  "step": 3,
  "tax_code": null,
  "award": {
    "name": "Giám đốc chi nhánh",
    "code": "GDCN",
    "description": "Lãnh đạo đỉnh cao – Xây dựng tài sản"
  },
  "contract_pdf": null,
  "contract_verify": false,
  "required_tax_code": false,
  "require_update": false,
  "checking_staff": false,
  "verify_listing": false
}
```

**Role/permissions** từ login response `mem[]`: `["user", "App Tổng kho", "App Agent", "admin", "data_admin", "GD_6"]` — group membership array. Infer capability từ đây + `award.code` (GDCN = Giám đốc chi nhánh / leader).

**Token JWT**: `exp: 2592000s = 30 ngày` (⚠️ khác với BE Q1 answer "24h" — cần confirm lại). Header `Authorization: Bearer <jwt>`.

**KYC status** từ `GET /api_agent/check_account_authentication.json`:
```json
{ "status": "success", "result": { "auth_user_id": 322, "salesman_id": 13376, "step": 3, "step_name": "Đã duyệt" } }
```

---

## Shared patterns

- **Toast**: shadcn sonner, top-right desktop, bottom mobile
- **Loading**: skeleton cards cho list, spinner button cho action
- **Empty state**: illustration + message + CTA
- **Error boundary**: full-page fallback với "Thử lại" button
- **Response envelope**: `{ status: 1|0, data: T, message: string }` — unwrap `data`, throw nếu `status == 0`

## Colors / Typography notes

- Primary: blue tươi (confirm với brand guideline — chưa có answer)
- Secondary: neutral gray scale
- Font: Inter hoặc system default
- Density: compact (8px unit grid)
- Avatar placeholder: fallback initials từ `first_name + last_name`

---

<a id="docs-screens-phase-03-screens-md"></a>

## docs/screens/phase-03-screens.md

---
title: Phase 03 screens — BDS + Dự án + Bảng hàng
type: design-spec
level: high-level
phase: 03
audience: Pencil AI designer
date: 2026-04-17
updated: 2026-04-18
updated_ref: plans/reports/brainstorm-260418-0735-phase-03-bds-architecture-review.md
related:
  - plans/260417-1558-webapp-agent-mvp/phase-03-bds-projects-sales-board.md
  - plans/reports/brainstorm-260418-0735-phase-03-bds-architecture-review.md
---

# Phase 03 — Screens spec (high-level)

Target: Pencil AI tự fill layout. **13 màn/modals** core business (sau update 2026-04-18).

## Context

- Agent là NVKD BĐS, làm việc với list BDS nhiều (density cao, filter nhiều)
- BDS = đơn vị nghiệp vụ chính (nhà, đất, căn hộ, lô dự án)
- **3 phân loại top-level**: Mua bán (`transaction_type=1`), Cho thuê (`transaction_type=2`), Dự án (entity riêng)
- Desktop-first (agent dùng laptop nhiều khi tư vấn văn phòng), responsive mobile khi gặp khách ngoài

## Route structure (nested)

```
/                          # Home dashboard
/bds/mua-ban               # BDS list — Mua bán
/bds/cho-thue              # BDS list — Cho thuê
/bds/[id]                  # BDS detail (shared)
/bds/create                # BDS create wizard (6 step)
/bds/[id]/edit             # BDS edit
/bds/my-product            # BDS của tôi (dedicated endpoint)
/bds/favorite              # Yêu thích
/du-an                     # Dự án list
/du-an/[id]                # Dự án detail (tabs)
/du-an/[id]/bang-hang      # Bảng hàng standalone
```

Sidebar nav:
```
▸ BDS
  ├ Mua bán
  ├ Cho thuê
  ├ + Tạo BDS mới
  ├ BDS của tôi
  └ Yêu thích
▸ Dự án
  └ Danh sách dự án
```

## Filter architecture — server-driven

Filter sidebar render DYNAMIC từ `GET /api_customer/get_filter_config.json?transaction_type=X&city_id=Y`.
FE dispatch 4 section types: `multiselect`, `preset-chips` (+ tuỳ chỉnh slider), `range-slider`, `cascade`.
Stale 1h cache (TanStack Query).

## URL schema (nuqs compact keys)

```
?tt=1              transaction_type
&pt=12,14,16       property_types (comma-sep)
&c=01              city_id
&d=001             district_id
&w=00001           ward_id
&p=1-2             price preset id hoặc min-max
&a=50-80           area preset
&br=2,3            bedrooms
&hd=dong-nam       house_direction slug
&v=1               is_verified
&q=keyword         search
&sort=newest       sort
&page=1            pagination
```

---

## 1. BDS list — Mua bán + Cho thuê (`/bds/mua-ban`, `/bds/cho-thue`)

**Purpose**: Danh sách BDS theo transaction_type, filter server-driven, URL-synced.

**Note**: Mua bán và Cho thuê share cùng component `BdsListPage`, phân biệt qua route. Filter schema khác nhau do BE return config khác theo `transaction_type`.

**Key sections:**

### Header bar
- Breadcrumb "BDS / Mua bán" hoặc "BDS / Cho thuê"
- Search input (debounce 500ms, placeholder "Tìm theo tiêu đề, địa chỉ, mã BDS")
- View toggle: Grid / List icon
- Button "+ Tạo BDS mới" (primary)

### Filter sidebar (collapsible) — DYNAMIC render từ `/get_filter_config.json?transaction_type=X`

**Render từ response config.sections[], mỗi section có `type` dispatch:**
- `multiselect` → checkbox group (property_types, directions, amenities)
- `preset-chips` → chip single/multi select (price preset, area preset) + nút "Tuỳ chỉnh" expand range slider
- `range-slider` → khi user click "Tuỳ chỉnh" price/area
- `cascade` → city → district → ward dropdowns

**Shared sections (cả 2 category):**
- **Trạng thái xác thực** (`is_verified`): Tất cả · Đã xác thực · Chưa xác thực
- **Khu vực** (cascade): city dropdown → district cascading → ward
- **Diện tích** (preset-chips + tuỳ chỉnh): Dưới 30m² · 30-50 · 50-80 · 80-100 · 100-150 · 150-200 · 200-250 · 250-300 · 300-500 · Trên 500m²
- **Hướng cửa chính** (multiselect): 8 hướng
- **Hướng ban công** (multiselect): 8 hướng

**Mua bán specific (transaction_type=1):**
- **Loại BDS** (multiselect, id 12-22): Bán căn hộ chung cư · Bán chung cư mini, căn hộ dịch vụ · Bán nhà riêng · Bán nhà biệt thự, liền kề · Bán nhà mặt phố · Bán shophouse · Bán đất nền dự án · Bán trang trại · Bán đất · Bán kho, nhà xưởng
- **Khoảng giá** (preset-chips, total): Dưới 800 triệu · 800tr-1 tỷ · 1-2 tỷ · 2-3 tỷ · 3-5 tỷ · 5-7 tỷ · 7-10 tỷ · 10-20 tỷ · 20-30 tỷ · 30-40 tỷ · 40-60 tỷ · Trên 60 tỷ
- **Số phòng ngủ** (multiselect): 1 / 2 / 3 / 4 / 5 / 5+ PN
- **Số phòng tắm** (multiselect): 1 / 2 / 3 / 4 / 5 / 5+ PT
- **Pháp lý** (multiselect): Sổ đỏ · Sổ hồng · HĐMB · Chờ sổ
- **Mặt tiền** (range-slider): m

**Cho thuê specific (transaction_type=2):**
- **Loại BDS** (multiselect, id 23+): Cho thuê căn hộ · Cho thuê nhà riêng · Cho thuê nhà mặt phố · Cho thuê văn phòng · Cho thuê mặt bằng · Cho thuê phòng trọ · Cho thuê kho/xưởng
- **Khoảng giá/tháng** (preset-chips): Dưới 3tr · 3-5tr · 5-10tr · 10-20tr · 20-40tr · 40-70tr · 70-100tr · Trên 100tr
- **Số phòng ngủ** (multiselect)
- **Nội thất** (multiselect): Đầy đủ · Cơ bản · Không nội thất
- **Thời hạn thuê** (multiselect, nếu BE trả): Ngắn hạn · Dài hạn

- Clear filters button (giữ transaction_type + city, clear others)
- **Switch tab mua-ban ↔ cho-thue**: clear `property_types` (ID không overlap), city giữ

### Results area
- Count "Hiển thị 1-20 trong 1,234 kết quả"
- Sort dropdown: Mới nhất · Giá tăng · Giá giảm · Diện tích
- Grid/List of BDS cards (pagination bottom)

### BDS card components (variant `sale` | `rental`)
- Thumbnail image (fallback placeholder)
- Badge favorite (heart icon, toggle)
- Badge trạng thái (màu theo status)
- Title (2-line clamp)
- Address (1-line clamp with district, city)
- Price lớn + "/m²" nhỏ (sale) hoặc "/tháng" (rental)
- Meta row sale: diện tích · PN · hướng · pháp lý
- Meta row rental: diện tích · PN · nội thất chip
- Agent info strip (avatar + name + phone)
- Actions: Xem chi tiết · Chia sẻ · Copy link

### Responsive
- Desktop grid 3 col, filter sidebar fixed 280px
- Tablet grid 2 col, filter sidebar collapsible
- Mobile grid 1 col, filter → Sheet drawer bottom

### States
- Loading: 6-12 skeleton cards
- Empty: illustration + "Chưa có BDS phù hợp" + CTA "Xoá bộ lọc"
- Error: fallback + retry button

---

## 2. BDS detail (`/bds/[id]`)

**Purpose**: View đầy đủ 1 BDS + actions (đặt cọc, tạo giao dịch, favorite).

**Key sections:**

### Top
- Breadcrumb + back button
- Actions row right: Favorite · Share · Edit (nếu owner) · Delete (nếu owner)

### Gallery
- Main image (16:9, 600px height desktop)
- Thumbnail strip dưới (scroll horizontal)
- Click main → lightbox fullscreen zoom
- Badge count "1/15" góc phải

### Info section (2-col desktop, 1-col mobile)

**Left col — Primary info:**
- Title (H1)
- Address full + map pin link
- Price lớn (nổi bật) + "/m²" + negotiable flag
- Meta grid: Diện tích · PN · WC · Hướng · Pháp lý · Tầng · Mặt tiền
- Description (collapsible "Xem thêm")
- Amenities chips: Gần trường · Gần chợ · Công viên · ...
- Utilities tiện ích

**Right col — Sticky sidebar:**
- Agent card (avatar + name + team + phone + Chat disabled MVP)
- **Primary CTA stack — conditional logic:**
  - Compute `useOwnerFlow = !isMe && property_category === 2`
  - If `useOwnerFlow === true` → top button: **"Liên hệ đầu chủ"** (primary, orange)
    - If `verification_stage === 2` → click opens Owner Info Sheet (§2b)
    - Else → click opens Interest Request Form (§2c)
  - If `useOwnerFlow === false` → top button: **"Tôi có khách"** (primary, opens customer match popup)
  - Below top button (always):
    - Button "Đặt cọc ngay" (secondary, hidden nếu thiếu capability `deposit.create`)
    - Button "Tạo giao dịch" (secondary)
    - Button "Đặt lịch hẹn" (outline)
    - Button "Thêm vào nhu cầu khách" (outline)
- Stats card: View count · Favorite count · Posted date

### Bottom sections
- BDS tương tự (3-6 cards horizontal scroll)
- Video tour (optional nếu có)

### Responsive
- Desktop: 2-col layout, sticky sidebar
- Tablet: 1-col, sidebar move to top below gallery
- Mobile: 1-col, CTA floating bottom bar

---

## 2b. Owner info sheet (modal từ BDS detail)

**Trigger**: Click "Liên hệ đầu chủ" khi `verification_stage === 2`.
**Format**: Bottom Sheet (mobile) / Dialog centered 520px (desktop).

### Layout

**Header**
- Bar màu primary-orange, title "Thông tin đầu chủ" (semibold 18px, white)
- Close button (X) góc phải / back arrow left

**Body — Info card (white, rounded 16px, padding 24px)**
- Render theo priority:
  1. Nếu `verified_by_agent_info_arr` có items với `hasDisplayData=true` → render array với icon-mapped theo `type`, click URL nếu có
  2. Fallback `verified_by_agent_info` object, render 4 fields:
     - 👤 Name — `person_outline` icon
     - 📞 Phone — `phone_outlined` icon → tel: link
     - 💬 Facebook → open new tab
     - 📍 Nơi xác thực (`post_office_name`)

**Icon row style:**
- Icon box 36×36 rounded-10 bg neutral-100
- Text semibold 17px, color neutral-800
- Spacing 12px between icon and text, 20px between rows

**Empty state:** "Chưa có thông tin đầu chủ." (neutral-500, regular 15px)

**Footer (sticky)**
- Primary button full-width "Quan tâm" → opens Interest Request Form (§2c) kèm BDS context

### Responsive
- Desktop: centered Dialog 520px width, body max-height 70vh scroll
- Mobile: Sheet bottom, safe-area-inset-bottom

---

## 2c. Interest Request Form (modal từ BDS detail)

**Trigger**: Click "Liên hệ đầu chủ" khi `verification_stage !== 2`. Hoặc click "Quan tâm" từ Owner Info Sheet (§2b).
**Format**: Bottom Sheet (mobile) / Dialog centered 560px (desktop).
**Submit**: `POST /api_customer/interest_in_property.json { table_id, table_name: "real_estate", customer_id, notes? }`

### Layout

**Header**
- Title "Gửi yêu cầu quan tâm BDS" (semibold 18px)
- Close X

**Body**
- **BDS preview card (readonly)**: thumbnail 80×80 + title (line-clamp 2) + price + address 1-line
- **Form fields:**
  - Khách hàng (required) — autocomplete search existing customers (phase 04 dependency — stub simple `/api_agent/customers.json?q=` search phase 03)
    - Inline "+ Tạo khách mới" link → modal nested
  - Ghi chú (optional) — textarea 4 rows, placeholder "VD: Khách quan tâm vị trí này, cần tham quan cuối tuần"

**Footer (sticky)**
- Secondary button "Huỷ"
- Primary button "Gửi yêu cầu" (disabled nếu customer chưa chọn)

### Success flow
- Dialog thay thế content: checkmark icon + "Gửi yêu cầu quan tâm BDS thành công" (h3) + "Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất" (body)
- Button "Đóng"

### Responsive
- Desktop: Dialog 560px, form 1-col
- Mobile: Sheet bottom, sticky footer với safe-area

---

## 3. BDS create wizard (`/bds/create`) — 6 steps

**Purpose**: Wizard 6-step tạo BDS mới. Auto-save sessionStorage per step, key `bds-create-draft-{userId}`, clear on submit success.

**Key sections:**

### Header
- Title "Tạo BDS mới"
- Progress stepper: 6 numbered steps (clickable về step trước đã pass)
- Save draft indicator (top-right, silent after first save)

### Step 1 — Loại giao dịch (NEW, must chọn FIRST)
- Radio card grid 2 options lớn:
  - 🏠 **Bán** (transaction_type=1) — "Đăng tin rao bán BDS"
  - 🗝️ **Cho thuê** (transaction_type=2) — "Đăng tin cho thuê BDS"
- Khi chọn → load dynamic property_types list cho step 2 (cascade)
- Note: switching transaction_type later clears dependent fields (property_type, pricing unit)

### Step 2 — Thông tin cơ bản
- Loại BDS (radio card grid, options load theo transaction_type step 1, có icon per type)
- Tiêu đề (input, max 100 chars, counter)
- Mã BDS (input, auto-gen nếu để trống)
- Trạng thái (radio: Đang bán / Tạm ngưng)
- Mô tả chi tiết (textarea, min 50 chars)
  - (Optional MVP+) Nút "✨ Tạo mô tả AI" → call `/api_common/generate_real_estate_sample.json`

### Step 3 — Vị trí
- City dropdown (search)
- District dropdown (cascade)
- Ward dropdown (cascade)
- Street input
- Số nhà input
- Map preview (embed Google Maps nhỏ show pin)
- Lat/lng auto-filled hoặc drag pin adjust

### Step 4 — Hình ảnh
- Upload area (drag-drop + click)
- Grid preview với:
  - Reorder drag handle (dnd-kit sortable)
  - Set main image (star icon)
  - Delete (X icon)
  - Retry button nếu upload fail (adapter parse 4 response shapes defensive)
- Max 20 ảnh, mỗi ảnh 5MB (reject > 5MB inline), format JPG/PNG/WEBP
- Progress bar per upload (sequential, không parallel để tránh BE overload)
- Validation error inline per file (red border)

### Step 5 — Giá + Chi tiết
- **Giá**:
  - Input currency format VN `1.000.000 VND`
  - Đơn vị: Tổng / m² (toggle) — rental mode shows "/tháng" suffix
  - Có thương lượng (checkbox)
- **Physical specs:**
  - Diện tích (m²)
  - PN, WC (number input, rental không bắt buộc WC)
  - Hướng nhà (dropdown 8 hướng)
  - Hướng ban công (dropdown, optional)
  - Số tầng
  - Mặt tiền (m)
  - Năm xây dựng
- **Conditional by transaction_type:**
  - Mua bán: Pháp lý (dropdown: Sổ đỏ · Sổ hồng · HĐMB · Đang chờ sổ)
  - Cho thuê: Nội thất (dropdown: Đầy đủ · Cơ bản · Không) + Thời hạn (Ngắn hạn · Dài hạn)

### Step 6 — Xác nhận
- Summary tất cả info đã nhập (readonly card, section per step)
- "Sửa" button next to each section → back to relevant step (state giữ)
- Checkbox "Tôi cam kết thông tin chính xác"
- Button "Tạo BDS" (primary, disabled nếu checkbox off)

### Footer wizard
- Back · Next buttons (Next disabled khi validation fail)
- Auto-save sessionStorage on field change (debounce 1s), toast silent chỉ lần đầu

### Responsive
- Desktop: form 2-col cho fields liên quan
- Mobile: 1-col full-width, sticky footer buttons

---

## 4. BDS edit (`/bds/[id]/edit`)

**Purpose**: Same as create, pre-filled với data hiện tại.

**Differences:**
- Skip confirm checkbox step 5
- Button "Lưu thay đổi" thay "Tạo BDS"
- Show "Cập nhật lần cuối: {date}" top-right

---

## 5. My product (`/bds/my-product`)

**Purpose**: Variant BDS list chỉ BDS của Agent đang login.

**Differences vs BDS list:**
- Default filter: agent_id = current user (hidden, không thể bỏ)
- Thêm stats bar top: Tổng SP · Đang bán · Đã bán · View tháng này
- Card actions thêm: Edit, Delete, Toggle status (Đang bán ↔ Tạm ngưng)

---

## 6. Favorite (`/bds/favorite`)

**Purpose**: Variant BDS list show BDS user đã favorite.

**Differences vs BDS list:**
- Default filter: favorite = true (hidden)
- Empty state: "Chưa yêu thích BDS nào" + CTA "Khám phá BDS"
- Card favorite button = unfavorite (filled heart)

---

## 7. Project list (`/du-an`)

**Purpose**: Danh sách dự án BĐS.

**Key sections:**

### Header
- Breadcrumb "Dự án"
- Search input (debounce)
- Filter: Khu vực (city/district) · Trạng thái (Đang bán · Sắp mở bán · Đã bàn giao)

### Project card grid
- Cover image (aspect 3:2)
- Title
- Developer (chủ đầu tư)
- Location
- Price range "Từ 2.5 tỷ"
- Total units + units available badge
- Status badge màu
- Stats row: diện tích dự án · số tòa · số căn

### Responsive
- Desktop grid 3 col
- Tablet 2 col
- Mobile 1 col

---

## 8. Project detail (`/du-an/[id]`)

**Purpose**: Detail dự án + embed bảng hàng.

**Key sections:**

### Hero
- Cover image banner (1920×600)
- Title overlay + developer name
- CTA: "Xem bảng hàng" (anchor scroll) · "Liên hệ tư vấn"

### Info tabs
- **Tab 1 — Tổng quan**: mô tả, vị trí, tiện ích, quy mô
- **Tab 2 — Bảng hàng**: embed table (xem màn 9)
- **Tab 3 — Mặt bằng**: site plan + floor plans (images gallery)
- **Tab 4 — Tiện ích**: danh sách tiện ích kèm icon
- **Tab 5 — Thanh toán**: lịch thanh toán + chính sách

### Map section
- Embed Google Maps large với pin project + tiện ích surrounding

### Gallery
- Masonry grid ảnh dự án (20-30 ảnh)

### Bottom CTA
- "Liên hệ ngay" banner với phone button

---

## 9. Bảng hàng (`/du-an/[id]/bang-hang` hoặc embed tab)

**Purpose**: Table căn hộ/lô của dự án, bulk action đặt cọc.

**Key sections:**

### Filter bar
- Tòa (dropdown)
- Tầng (dropdown)
- Loại căn (dropdown: Studio, 1PN, 2PN, ...)
- Trạng thái (dropdown: Available, Reserved, Sold)
- Khoảng giá (range slider)
- Hướng

### Table (TanStack)
- Columns: Mã căn | Tòa | Tầng | Loại | Diện tích | Giá | Trạng thái | Action
- Row hover highlight
- Status badge màu (Available green, Reserved yellow, Sold gray)
- Action (single-row only, MVP phase 03): View detail, **Đặt cọc** (disabled nếu Sold)
- Bulk action DEFER phase 04 (endpoint `deposit_create` per-BDS cần loop, chưa rõ N BDS cùng lúc)

### Pagination
- 25/50/100 per page
- Page navigator

### Legend
- Status color legend below table

### Responsive
- Desktop: full table with all columns
- Tablet: hide Hướng, Mặt tiền columns
- Mobile: card view thay table (1 col)

---

## 10. List apartments (alternate entry)

Same as Bảng hàng but standalone page (không embed project detail). Route `/du-an/[id]/bang-hang`.

---

## Shared components

### BDS card (reusable)
- Used in: list, my-product, favorite, similar-items section, customer match
- Variants: compact (horizontal) · full (vertical with all meta)

### Price display
- Format: `{number}.{separator} VND`
- Locale vi-VN
- Billion/million auto-format: "2.5 tỷ" · "500 triệu"

### Image upload zone
- Used in: BDS create step 3, avatar, KYC
- Drag-drop hover highlight border
- Progress per file
- Error per file inline

### Empty states
- Illustration (simple line art)
- Message heading + subtext
- CTA primary + secondary

### Loading skeletons
- Card skeleton (image placeholder + lines)
- Table skeleton (6 rows with varied widths)
- Detail skeleton (gallery + info blocks)

---

## Design system notes

- **Colors**:
  - Primary blue
  - Status: green (success/sold), yellow (pending/reserved), red (error), gray (neutral)
  - Heart favorite: pink/red
- **Spacing**: 4/8/16/24/32/48px
- **Border radius**: 8px cards, 6px buttons, 4px inputs
- **Shadows**: subtle `shadow-sm` cho cards, `shadow-md` cho dropdowns/modals
- **Icons**: lucide-react (consistent 16/20/24 size)
- **Typography**:
  - Price: 24px bold
  - Title card: 16px semibold, line-clamp 2
  - Meta: 14px regular gray-600
  - Body: 14-16px

## Interaction patterns

- **Hover card**: slight lift (shadow-md + translate-y -2px)
- **Skeleton → content**: fade transition 200ms
- **Toast success**: green checkmark 3s auto-dismiss
- **Toast error**: red with "Thử lại" action
- **Modal/Sheet**: overlay backdrop blur 4px
- **Sticky CTA mobile**: fixed bottom với safe-area-inset-bottom

## Real API data — shapes thực tế

### Cities — `GET /api/cities?limit=7`
```json
[
  { "city_id": "01", "city": "Hà Nội", "title": "Thành Phố Hà Nội", "slug": "ha-noi", "property_count": 975642, "city_image_web": "https://.../cities/ha-noi.png", "lat": 21.028354, "long": 105.853798 },
  { "city_id": "79", "city": "Hồ Chí Minh", "property_count": 1417651, "lat": 10.776486, "long": 106.701056 },
  { "city_id": "48", "city": "Đà Nẵng", "property_count": 199870 },
  { "city_id": "31", "city": "Hải Phòng", "property_count": 327368 }
]
```
→ Dùng cho city selector dropdown, hiển thị `property_count` as badge counter trong home block "Khám phá theo tỉnh thành".

### Property types — `GET /api_customer/get_property_types.json?type=1`
Type=1 (Mua bán), type=2 (Cho thuê). Sample:
```json
[
  { "id": 12, "name": "Bán căn hộ chung cư", "icon": "icon-apartment1", "total_post": 1194, "slug": "ban-can-ho-chung-cu" },
  { "id": 14, "name": "Bán nhà riêng", "icon": "icon-townhouse", "total_post": 308 },
  { "id": 16, "name": "Bán nhà mặt phố", "icon": "icon-commercial", "total_post": 69 },
  { "id": 17, "name": "Bán shophouse, nhà phố thương mại", "icon": "icon-commercial", "total_post": 86 },
  { "id": 18, "name": "Bán đất nền dự án", "icon": "icon-townhouse", "total_post": 24 },
  { "id": 19, "name": "Bán trang trại, khu nghỉ dưỡng", "icon": "icon-townhouse" }
]
```
→ Dùng icon card grid trong filter + create BDS step 1.

### BDS list item — `GET /api_agent/real_estate_v2.json?page=1&limit=20`
Response shape `{ data: { total, count, page, limit, total_pages, properties: [...] } }`. Item:
```json
{
  "id": 7141760,
  "title": "Đất vườn Cư Huê Ea Kar 3.5 sào 1.55 tỷ - Nghỉ dưỡng lý tưởng",
  "slug": "dat-vuon-cu-hue-ea-kar-35-sao-155-ty-nghi-duong-ly-tuong-7141760",
  "real_estate_code": null,
  "price": 1550000000.0,
  "price_description": "1.55 tỷ",
  "currency": "1,55 tỷ",
  "area": "1260",
  "bedrooms": null, "bathrooms": null, "floors": null,
  "property_type_id": 19,
  "property_type": "Bán trang trại, khu nghỉ dưỡng",
  "transaction_type": 1,
  "house_direction": null,
  "status": "Đang bán",
  "city": "Tỉnh Đắk Lắk",
  "district": "Huyện Ea Kar",
  "ward": "Xã Cư Huê",
  "street_address": "Huyện Ea Kar, Tỉnh Đắk Lắk",
  "lat": null, "long": null,
  "main_image": "https://quanly.tongkhobds.com/uploads/2026/04/14/postfb_...jpg",
  "images": [ "url1", "url2", "url3" ],
  "created_on": "17/04/2026",
  "time_ago": "3 phút trước",
  "view_count": 0,
  "is_favorite": false,
  "favorite_group": null,
  "expired": false,
  "deposit_commission": [
    { "id": 1, "type": "thien_chi", "name": "Thiên chí", "min_rate": 1.0, "max_rate": 3.0, "rate_type": "percent" },
    { "id": 2, "type": "coc_chet", "name": "Cọc không hoàn lại", "min_rate": 5.0, "max_rate": 10.0, "rate_type": "percent" }
  ]
}
```

**Hiển thị card**:
- Ảnh: `main_image` (fallback placeholder nếu null)
- Title: `title` (2-line clamp)
- Price big: `price_description` ("1.55 tỷ" — đã format sẵn)
- Meta: `area + "m²"` · `bedrooms + "PN"` (nếu có) · `house_direction` (nếu có)
- Address: `"{district}, {city}"` ngắn gọn
- Time badge: `time_ago` ("3 phút trước") góc trên phải
- Status badge: `status` ("Đang bán") màu xanh
- Favorite toggle: `is_favorite` state
- Type tag: `property_type` ("Bán nhà mặt phố")
- Code (nếu có): `real_estate_code` ("T41NR7141687") dạng small gray

### BDS detail — `GET /api_customer/property.json?slug=...`
Fields bổ sung so với list:
```json
{
  "real_estate_code": "T41NR7141687",
  "transaction_type_name": "Cho thuê",
  "property_slug": "cho-thue-nha-rieng",
  "legal_document": "Không xác định",
  "legal_document_url": "",
  "interior": "Không nội thất",
  "latlng": "10.7658855,106.6908105",
  "street_name": "Lương Hữu Khánh",
  "contact_phone": "0965324969",
  "hotline": "0965324969",
  "zalo": "https://zalo.me/743507688581290959",
  "video_url": [],
  "html_content": "<p>Mặt tiền kinh doanh đắc địa...</p><h2>Thông tin chi tiết:</h2><ul>...</ul>",
  "description": "Nhà phố Quận 1 tại Lương Hữu Khánh...",
  "utilities": [],
  "legal_document_file": [],
  "status_info": { "id": 5, "name": "Đang rao", "code": "ACTIVE" },
  "price_history": [],
  "commissionRate": [
    { "title": "Hoa hồng chủ nhà", "key": "total_rate", "rate": 2.0, "description": "2%" }
  ],
  "rate_seller": 0.5,
  "rate_buyer": 0.5,
  "total_rate": 1,
  "num_of_floors": null,
  "frontage": null,
  "road_width": null,
  "chat": { "room_id": null, "bot_ai": "namkn", "message_content": "Xin chào, bạn đang quan tâm tới bất động..." }
}
```

**Hiển thị detail**:
- H1: `title`
- Code row: `real_estate_code` · `transaction_type_name` · `property_type`
- Price: `price_description` · "/tháng" nếu `transaction_type == 2`
- Address full: `street_address` + map pin → Google Maps with `lat/long`
- Info grid: `area` · `bedrooms` · `bathrooms` · `house_direction` · `balcony_direction` · `legal_document` · `interior` · `floors` · `frontage` · `road_width`
- Description section: `description` (preview) + "Xem thêm" → render `html_content` (sanitize HTML)
- Gallery: `images[]` + `video_url[]`
- Commission card: `commissionRate[]` (Hoa hồng chủ nhà {rate}%)
- Agent strip: `contact_phone` · `hotline` · `zalo` link
- Status badge: `status_info.name` ("Đang rao") với color theo `status_info.code` (ACTIVE=xanh)

### Map data — `GET /api_customer/real_estate_map.json?latlng=10.77,106.70&radius=5&limit=50&transaction_type=2`
```json
{
  "properties": [
    { "id": 7141687, "slug": "nha-pho-quan-1-180m-gia-53-trieu-...", "price_description": "53 triệu", "lat": 10.7658855, "long": 106.6908105, "expired": false }
  ],
  "total": 14674, "count": 5, "page": 1, "limit": 5, "total_pages": 2935
}
```
→ Marker label từ `price_description`. Click marker → popup với thumbnail + link `/bds/{slug}`. Không có bbox → FE compute radius=diagonal/2 từ viewport bounds.

### Sale project — `GET /api_agent/real_estate_sale_project.json`
```json
[
  {
    "id": 38319, "parent_id": 38318,
    "project_code": "D61CC38319",
    "project_name": "Tecco Felice",
    "project_image": "uploads/2025/12/1765637670498.jpg",
    "zone_of_project": [
      {
        "zone_of_project_name": "Teco_home",
        "real_estate_sale_id": 32,
        "real_estate_sale_name": "Ra hàng đợt 1 - 15 CH",
        "real_estate_sale_start": "2025-12-17T01:00:00",
        "real_estate_sale_end": "2026-04-30T12:00:00",
        "visibility_level": 1,
        "required_infor_verify": false,
        "registered_verify": 1,
        "is_noxh": false
      }
    ]
  }
]
```
→ Sale project card: ảnh `project_image` + `project_name` + `project_code` nhỏ + stack zone badges (e.g. "Ra hàng đợt 1 - 15 CH") + countdown timer tới `real_estate_sale_end`. `is_noxh` = nhà ở xã hội (badge riêng).

### Location search — `GET /api_customer/search_districts.json?id={city_id}`
```json
[
  { "id": 1, "name": "Chung cư Handico30", "type": "building", "params": "project=1" },
  { "id": 2, "name": "Vinhome Ocean Park IV", "type": "house", "params": "" }
]
```
→ `type` có thể là `building` (dự án) hoặc `house` (khu dân cư). Hiển thị icon khác nhau.

---

## Vietnamese price format (quy ước từ BE `price_description`)

BE đã format sẵn các dạng:
- `"1.55 tỷ"` · `"500 triệu"` · `"53 triệu"` (chi tiết) · `"8.5 triệu"` (lease)
- `"9 tỷ"` (integer không có thập phân)

FE dùng `price_description` trực tiếp, **không format lại** từ `price` raw number. Nếu cần format cho create form, dùng `react-number-format` locale vi-VN với separator `.`.

---

## Status mapping thực tế

| Field | Values | Hiển thị |
|---|---|---|
| `status` (list item) | "Đang bán" · "Đã bán" · "Tạm ngưng" · "Hết hạn" | Badge xanh/xám/vàng/đỏ |
| `status_info.code` (detail) | `ACTIVE` · `EXPIRED` · `PENDING` · `REJECTED` | Màu badge |
| `transaction_type` | `1` (Mua bán) · `2` (Cho thuê) | Tab/filter label |
| `expired` | `true` / `false` | Overlay mờ + ribbon "Hết hạn" |
| `is_favorite` | `true` / `false` | Heart filled/outline |

---

## Unresolved

- Brand color chính thức — chưa có từ stakeholder
- Logo asset — chờ design team
- Illustration style cho empty states — abstract line art vs realistic
- Token TTL BE Q1 nói 24h, JWT exp thực tế 30 ngày (2592000s) — cần confirm
- Icon library: BE trả `icon-apartment1` · `icon-townhouse` · `icon-commercial` · `icon-villa` · `icon-studio` → map sang lucide icons hoặc custom SVG set

---

<a id="docs-screens-phase-08-screens-md"></a>

## docs/screens/phase-08-screens.md

---
title: Phase 08 screens — Quản lý đội nhóm (Team Management)
type: design-spec
level: high-level
phase: 08
audience: Pencil AI designer + FE devs
date: 2026-04-18
updated: 2026-04-18
updated_ref: Figma mobile refs + Design/phase08.pen
related:
  - plans/260417-1558-webapp-agent-mvp/phase-08-team-management.md
  - docs/screens/design-tokens.md
  - docs/screens/phase-02-screens.md
  - docs/screens/phase-03-screens.md
---

# Phase 08 — Screens spec (mobile-first)

Target: Pencil AI tự fill layout. **3 màn** team management core. Mobile-first (tham chiếu Figma V1), responsive desktop.

## Context

- Agent V1 có UI mobile ưu tiên cho Team Management (screenshot Figma reference đính kèm trong chat)
- Webapp mirror pattern mobile cho consistency, sau đó scale desktop bằng grid layout
- **Mobile**: tree visualization là entry point chính (dễ thao tác bằng tay), member detail screen dùng stat cards làm filter for list
- Style language: **orange gradient hero header**, floating profile card, underline tab, stat cards filter, list items variant theo tab

## Route structure

```
/doi-nhom                          # overview dashboard (stats + member list)
/doi-nhom/so-do                    # tree visualization
/doi-nhom/[salesmanId]             # member detail (2-level filter: tab + stat)
```

Sidebar nav (desktop): Tài khoản → Quản lý đội nhóm
Mobile nav: từ profile menu / home shortcut

---

## Design language (từ Figma V1 references)

### Hero header (mobile)
- Background: linear gradient orange `#FB923C → #F97316` (hoặc single `$primary` fade-down to surface), height ~92-100px, status bar inclusive
- Safe padding top 44 (iOS) / 24 (Android)
- Layout: [back-btn 40x40 circle white/10 opacity] — [title center bold] — [action-btn 40x40 circle white/10 opacity]
- Title: 17/700 color white, center aligned
- Back icon: `arrow-left` 20px white
- Action icon: `history` / `rotate-ccw` (refresh) 20px white
- Border bottom: slight curve joining white content card (optional SVG arc)

### Floating profile card
- Position: overlap hero (negative margin-top 16-20px)
- Frame: white fill, radius-xl top, shadow-sm, padding [20, 20, 24, 20]
- Top-right link "Sơ đồ đội nhóm →" 13/500 primary (opens `/doi-nhom/so-do`)
- Avatar: 80x80 circle center, border 4 white, shadow subtle
- Name: 18/700 text-primary center
- Badge row center:
  - Title pill: fill `#FFF4D9` (cream/warm yellow) / `$warning-soft`, padding [4,12], radius-full, text 12/600 color `#92400E` (warm brown)
  - Growth chip: text "+78% ↑" 12/600 color `$success` (no bg, just text)
- CTA row (fill_container, padding-top 16, gap 12):
  - Button primary fill `$primary` radius-md height 48, icon message-circle + text "Nhắn tin" 15/600 white — fill_container
  - Button outline 48x48 square radius-md border-2 `$primary`, icon phone 20px `$primary`

### Primary tab (underline style)
- Below profile card, full-width, fill surface, padding [12, 0]
- 2 tabs equal width, text center:
  - Active: 15/600 primary, border-bottom-2 primary (4px below text)
  - Inactive: 15/500 text-muted, no border
- Height 44, gap 0

### Doanh số summary row
- Below tabs inside main content, padding 16
- Layout horizontal: icon circle 28 bg `#DBEAFE` (info-soft) + `$` icon info color → col "Doanh số" 12 muted + value "8.213.100đ" 18/700 primary
- Right: "Kỳ doanh số" dropdown (pill radius-md border muted, 13/500 secondary + chevron-down)

### Stat cards filter (3 equal columns gap 12)
- Card frame: fill surface, border 1 border, radius-lg, padding [12, 16], text center
  - Label "Giao dịch" 13/500 secondary
  - Value "20" 24/700 primary
- **Active state**: fill `$primary-soft` (#FFF4E6), border 1 `$primary`, same text colors
- Click switches list below

### List section
- Section header 16/700 text-primary, padding-bottom 12
- Variants theo tab + stat active:

**List item — Giao dịch (deal card)**
- Card fill surface, border 1 border, radius-md, padding [12, 14], gap 4 vertical
- Row 1: "GD10001042" 14/600 text-primary (flex_between) — badge right
  - Badge "Thành công" fill `$success-soft` text `$success` 11/600 radius-full padding [2,10]
  - Badge "Khởi tạo" fill `$warning-soft` text `$warning` 11/600 ...
- Row 2: "Mã BDS: L50409 | Nguyễn Thị C" 12/normal secondary
- Row 3: "Số tiền: 3,000,000,000 đ" 13/500 text-primary

**List item — Nguồn hàng (BDS card)**
- Card same shell
- Row 1: title truncate 14/600 + badge right ("Đã xác thực" success-soft / "Chờ ký HĐ" warning-soft)
- Row 2: icon `map-pin` 12 muted + address 12/normal secondary
- Row 3: "Diện tích: 200 m2 | Giá: 3,000,000,000 đ" 12/normal secondary

**List item — Thành viên (member card)**
- Card same shell
- Row 1 horizontal gap 10: avatar 32 circle + col (name 14/600 + chip line) + chevron-right optional
- Chip line: "{titleCode}" 11/500 text-muted + colored growth "+78% thăng cấp" 11/600 success or "-30% giảm cấp" 11/600 danger
- Row 2: "BDS: 1 | Giao dịch: 10 | Doanh số: 10,000,000,000 đ" 11/normal text-muted

### Tree view (`/doi-nhom/so-do`, mobile optimized)
- Header giống member detail (orange hero + back + title "Sơ đồ đội nhóm")
- Body: horizontal scrollable tree canvas với dot grid bg (optional)
- **Tree node card compact** (floating):
  - 200 wide minimum, padding 12, radius-md, fill surface, shadow-md
  - Row 1: avatar 24 + name 13/600 + growth chip tiny
  - Row 2: "BDS: {n} | Giao dịch: {n} | Doanh số: {n}" 10/normal text-muted (single line)
- Connector lines: dark navy `#1E3A8A` 2px dashed hoặc solid elbow
- Tap node → bottom sheet với full member card (same shell as list item) + CTA "Xem chi tiết →" routes detail
- Pan/zoom giữ nguyên behavior spec (0.6x-2.6x, default 0.8x)

### Desktop variant (responsive)
- ≥ 1024px: sidebar 240 + main
  - Profile card fills main top, stats row 3-col desktop
  - Tabs remain underline style
  - List items max-width 720 centered
- ≥ 768px tablet: similar mobile but wider, 2-col list cards

---

## Screens

### 1. Team Overview (`/doi-nhom`)

**1 view — 2 cách nhìn responsive**. Mobile = card stack compact, Desktop = dashboard table hierarchical. Cùng data model, cùng entry point.

#### Shared data model

Tất cả variants sử dụng cùng underlying data:
```typescript
type TeamOverviewData = {
  // Current user profile
  self: { name, role: "GĐK"|"TP"|"CTV", titleName, growthPercent, growthDir: "up"|"down" };
  
  // Team aggregate stats (self + all descendants)
  teamStats: {
    totalTp: number;         // Tổng TP (cấp 2 dưới)
    totalCtv: number;        // Tổng CTV
    directCtv: number;       // CTV trực tiếp (cấp con đầu)
    totalInventory: number;  // Tổng nguồn hàng (BDS)
    totalDeals: number;      // Tổng giao dịch
    totalRevenue: number;    // Tổng doanh số (đồng)
    // growth % per stat so với kỳ trước
  };
  
  // Personal stats (self only, không cộng descendants)
  personalStats: { inventory, deals, revenue };
  
  // Title progression
  titleProgress: {
    currentTitleName: string;    // e.g. "Giám đốc khối"
    nextTitleName: string;       // e.g. "Phó Tổng giám đốc"
    progressPercent: number;     // 0-100
    currentMetric: string;       // "8,2M doanh số quý hiện tại"
    targetDiff: string;          // "Cần thêm 2,5 tỷ để đạt mục tiêu"
  };
  
  // Hierarchical members tree (recursive: team → team/cá nhân pair → children)
  members: MemberNode[];
};

type MemberNode = {
  salesmanId: number;
  name: string;
  role: "GĐK"|"TP"|"CTV";
  growth: { percent: number, dir: "up"|"down" };
  teamName?: string;             // nếu node có children → team label (Khối/Phòng)
  stats: {
    gdkCount: number, tpCount: number, ctvCount: number,   // team member counts
    inventory: number, deals: number, revenue: number,
  };
  personalStats?: { ... };       // if node has children → also personal contribution
  children?: MemberNode[];       // recursive
  isHot?: boolean;               // display flame icon in Hot column
};
```

#### Breakpoint logic

| Viewport | Variant | Source |
|---|---|---|
| `< 768px` (mobile) | **Card stack compact** (tab-filtered list) | Figma V1 mobile refs |
| `>= 768px` (tablet+) | **Dashboard table hierarchical** | `Design/phase08.pen` — "Desktop — TN Dashboard tổng quan" |

Transition: FE dùng single component `<TeamOverview />` với internal breakpoint guard + switch layout. Không có client/desktop-only entry page — chung URL `/doi-nhom`.

---

#### A. Mobile variant (< 768px) — Card stack compact

Mirror Member Detail mobile layout với `salesmanId = currentUser.salesmanId`.

**Structure** (vertical scroll):

1. **Hero header** (orange solid, 92px):
   - Status bar (40) + header bar (56): back arrow circle + title "Quản lý đội nhóm" + history/refresh icon circle
2. **Profile card** (floating, overlap hero slightly):
   - Avatar 80 circle + Name bold 18/700 + Title badge pill cream "Giám đốc khối" + growth "+78% ↑" chip
   - "Sơ đồ đội nhóm →" link top-right → routes `/doi-nhom/so-do`
   - CTA row: button "Làm mới" (icon rotate-cw) — no "Nhắn tin" self view
3. **Tabs row** (underline style, sticky optional):
   - `Cá nhân` | `Đội nhóm` (default active: **Đội nhóm** cho Team Overview context)
4. **Doanh số summary row**: `$` icon + "Doanh số" label + big value + "Kỳ doanh số" dropdown
5. **Stat cards filter row** (3-col grid, tab-driven):
   - Đội nhóm tab: `Giao dịch` | `Nguồn hàng` | `Thành viên` (active = orange soft bg, filter list below)
   - Cá nhân tab: `Giao dịch` | `Nguồn hàng` (2 cards only, no "Thành viên")
6. **List section** (variant theo stat active):
   - `Thành viên` active → "Danh sách thành viên" — member cards (flat, tap to open detail)
   - `Giao dịch` active → "Danh sách giao dịch" — deal cards
   - `Nguồn hàng` active → "Danh sách nguồn hàng" — BDS cards

Member card (mobile): avatar 32 + name 14/600 + role chip + growth% + stats line "BDS: N · GD: N · DS: N tỉ". Tap → `/doi-nhom/[salesmanId]`.

---

#### B. Desktop variant (>= 768px) — Dashboard table hierarchical (ref pen frame "Desktop — TN Dashboard tổng quan"):

##### Overall layout (1440 wide)
- Sidebar 240 (navigation) + Main content (1200 wide)
- Main: topbar (search + bell + avatar) + content area (padding 24)
- Content vertical stack: User header → Tổng quan card → Trạng thái danh hiệu card → Danh sách thành viên card

##### User header (compact row)
- Left: avatar 32 circle (cream bg) + name bold 14 + "·" separator + role "Giám đốc khối" primary 13
- Right: "Xem sơ đồ đội nhóm →" orange link 13/500 → routes `/doi-nhom/so-do`

##### Section "Tổng quan" (card, radius 12, border 1, padding 20)
- Header row: "Tổng quan" 16/700 + "Kỳ doanh số" dropdown (right)
- **6 stat cards row** (gap 10, each fill_container):
  - Card structure: label top 11/normal muted + row (icon 28 cream/primary-soft + value 22/700 + growth chip)
  - Cards: **Tổng TP**, **Tổng CTV**, **CTV trực tiếp**, **Tổng nguồn hàng**, **Tổng giao dịch**, **Tổng doanh số**
  - Growth chip: `+X%` green+arrow-up / `-X%` danger+arrow-down
  - Each card: radius 8, border 1, padding 14

##### Section "Trạng thái danh hiệu" (card, radius 8, border 1, padding 16, horizontal layout, gap 20)
- **Left** (gap 14, align center):
  - Award badge 56x56, radius 8, fill `#FFF4D9` (cream), icon `award` 28px color `#B45309` (warm brown)
  - Text col: "Danh hiệu hiện tại" 11/500 muted + **"Giám đốc khối"** 16/700 bold
- **Right** (fill_container, vertical gap 10):
  - Top row (space_between): [text col: "Tiến độ lên danh hiệu tiếp theo" 11/500 muted + **"Phó Tổng giám đốc"** 14/700] + **"+78%"** 14/700 primary (right)
  - Progress bar: full-width height 10 radius 5, bg `#FFF4E6`, fill primary ~78%
  - Bottom row (space_between): "8,2M doanh số quý hiện tại" 11/500 muted + "Cần thêm 2,5 tỷ để đạt mục tiêu" 11/500 muted

##### Section "Danh sách thành viên" (card, radius 12, border 1, padding 20)

###### Filter bar (gap 10, horizontal)
- Search input (w=280, h=36, border): icon search + placeholder "Tìm kiếm..."
- "Trạng thái hoạt động" dropdown (w=180, h=36, border)
- "Kỳ doanh số" dropdown (w=140, h=36, border)
- Spacer fill
- Search action button: circle 36x36, fill `#0B2253` (navy), white search icon

###### Table structure (fixed column widths for visual alignment)

| # | Column | Width | Notes |
|---|---|---|---|
| 0 | STT | 48 | Row number + expand chevron |
| 1 | Đội nhóm / Thành viên | 250 | Name + role/title badge + subtitle |
| 2 | Hot | 30 | Flame icon (optional, indicates "hot" status) |
| 3 | Thành viên (grouped) | 210 | Sub-columns GĐK/TP/CTV (70 each, center-aligned) |
| 4 | Nguồn hàng | 110 | BDS count (just number, no "BDS" suffix) |
| 5 | Giao dịch | 100 | Deal count |
| 6 | Doanh số | 110 | Revenue (orange color, tỉ/triệu format) |
| 7 | Phân loại | 80 | Plus button 24x24 (radius 12, border) + icon 12x12 |
| 8 | Thao tác | fill | Ellipsis icon (...) |

###### 3 role levels (role-based hierarchy, không dùng LV badges)
1. **GĐK** (Giám đốc khối) — cấp cao nhất
2. **TP** (Trưởng phòng) — quản lý nhóm
3. **CTV** (Cộng tác viên) — thành viên

Subtitle format: `{role} + {growth%}` (e.g., "GĐK +50% thăng cấp", "TP +45% thăng cấp", "CTV +12%", "CTV -30% giảm cấp")

Growth colors: green `$success` for positive/thăng cấp, red `$danger` for negative/giảm cấp.

###### Row types

**a) Khối team row** (top-level team, e.g., "Kinh doanh 2"):
- Structure: chevron + STT number | **"[Khối] {name} 🔥"** bold 13/700 | (no Hot — team rows không có flame) | aggregate counts + metrics | plus + ellipsis
- Badge "Khối": radius 8, fill `#FFF4E6`, text orange 9/600, placed BEFORE name in nm frame
- No avatar
- White bg, bottom border gray
- Name text: `textGrowth: "fixed-width"`, width 150 (to align Hot column across rows)

**b) Phòng team row** (sub-team leader, e.g., "Trần Minh Hùng"):
- Same structure as Khối but with "Phòng" badge instead of "Khối"
- No avatar (like Khối rows), bold name 13/700
- No flame in Hot column

**c) TP/GĐK cá nhân row** (personal stats of team leader, e.g., "Nguyễn Văn Đức GĐK", "Trần Minh Hùng TP"):
- Directly BELOW team row, no divider between → forms "đội nhóm + cá nhân" visual pair
- Avatar 28 circle: white bg + outline primary 1.5 + user icon orange
- Subtitle shows `{role} + {growth%}`
- **Orange bg `#FFF4E6` starts from c2 onwards** (c1 area stays white showing tree lines)
- Cell heights stretch `fill_container` to ensure uniform orange bg height across cells
- Padding-left on c2: **12** (indent matching other members)

**d) CTV member row** (leaf member, e.g., "Võ Hoàng Long", "Phạm Thu Trang"):
- Single row, white bg
- Avatar 28 circle: color varies by status (gray `#F3F4F6` for neutral, cream for active, red for giảm, green for tích cực)
- Subtitle shows `CTV + growth%`
- Leaf CTV: NO chevron (not expandable)
- Padding-left on c2: **12** (aligned with cá nhân rows)

###### Grouping rule (recursive pattern)
**Bất kỳ node nào có children → render 2 rows cạnh nhau**:
1. **Row "đội nhóm"** (team aggregate): white bg, bold name + Khối/Phòng badge, numbers = SUM của self + all descendants
2. **Row "cá nhân"** (self only): orange bg `#FFF4E6` từ c2, avatar with primary outline, numbers = chỉ individual contribution

- 2 rows **không có divider** giữa → hiển thị như 1 block gộp
- Apply recursive:
  - GĐK (top) có direct children → Kinh doanh 2 (đội) + NVĐ (cá nhân)
  - TP (middle) có direct children → Trần team (Phòng) + Trần (cá nhân)
  - CTV (leaf) không split — single row only
- **Không cần label "Cá nhân"** — bg + tree line đã đủ phân biệt

###### Tree lines (visualize hierarchy)

**2 levels of vertical tree lines** in c1 column (width 48, layout:none):

| Level | Vline x | Hline bend | Purpose |
|---|---|---|---|
| 1 | x=2, w=1, h=56 (or h=29 if last) | x=3, y=28, w=20 | Children of Khối (Kinh doanh 2) |
| 2 | x=23, w=1, h=56 (or h=29 if last) | x=24, y=28, w=16 | Children of Phòng (Trần Minh Hùng) |

- Color: `#D1D5DB` (border-strong gray)
- Last child in a group: vline **half-height** (y=0 to y=29), terminates at L-bend
- Middle children: vline **full-height** (y=0 to y=56), continues down
- L-bend horizontal line at y=28 connects vline to content area

**Bottom border masking**:
- Row stroke bottom-1 gray renders at row bottom edge
- To hide stroke under c1 area (so tree line area has no bottom border), add mask rectangle inside c1:
  - `x=0, y=54, w=48, h=2, fill: #FFFFFF`
- Result: row bottom border starts from x=48 onwards (after tree line area)

###### Orange accent rule
- **Removed** (final state): no orange vertical accent bars anywhere inside table
- Visual pair identification (team + cá nhân) achieved by:
  1. Orange bg on cá nhân row
  2. Tree line continuity
  3. Absence of divider between team + cá nhân

###### Column alignment details
- **Name text** (in team rows + member rows): `textGrowth: "fixed-width"`, width 150 → Hot column consistently at same x
- **Numbers** in Thành viên group: single digit "0", "1", "2" (NOT "00", "01", "02")
- **Nguồn hàng**: just number "150", "45", "25" (no "BDS" suffix)
- **Doanh số**: "{number} tỉ" format, orange color

###### Nm row internal structure (team rows)
Order: `[Khối/Phòng badge, name text (fixed 150), flame was here now removed, spacer (fill_container), ...]`
- Badge BEFORE name (moved to index 0 of nm frame)
- Name text fixed-width 150 → consistent flame column alignment (though flame now in separate column)
- Spacer at end pushes additional elements to right

###### Member row nm internal structure
Order: `[name text (fixed 150), spacer, (no badge for leaf)]`
- No "Khối"/"Phòng"/"Thành viên" badge for leaf members (role already in subtitle)

##### Pagination footer (align right of card, space_between)
- Left: page size dropdown "10" + info text "Hiển thị từ 1 đến 6 trên tổng 6"
- Right: prev button + current page (orange bg) + next button

---

#### C. Responsive transitions (mobile ↔ desktop)

Single component `<TeamOverview />` renders different layout dựa breakpoint:

| Element | Mobile (< 768px) | Desktop (≥ 768px) |
|---|---|---|
| Chrome | Orange hero header + profile card + tabs | Sidebar + topbar + content padding 24 |
| Stats | 3 stat cards filter (Giao dịch/Nguồn hàng/Thành viên), tab-driven | 6 stat cards row (all aggregates visible always) |
| Title progress | Chỉ nằm trong profile card (growth % chip) | Dedicated card "Trạng thái danh hiệu" với award badge + progress bar + metric footer |
| Member list | Card stack, flat list (tap to drill down) | Hierarchical table với đội nhóm + cá nhân pairs + tree lines + pagination |
| "Sơ đồ đội nhóm" entry | Top-right link in profile card | Top-right link in user header row |
| Tab switcher | Visible, toggles Cá nhân ↔ Đội nhóm | Implicit — desktop shows full team hierarchy always; personal stats shown via dedicated "TP/GĐK cá nhân" rows trong table |

**Data shared across variants**:
- `self` + `teamStats` drive both stat cards (mobile filter / desktop 6-card)
- `titleProgress` drives growth chip (mobile) + progress card (desktop)
- `members[]` drives card list (mobile, flat) + hierarchical table (desktop, recursive grouping)

**FE architecture note**:
- Component: `<TeamOverview />` (single entry for `/doi-nhom`)
- Internal: `useMediaQuery(breakpoint.md)` → render `<TeamOverviewMobile />` or `<TeamOverviewDesktop />`
- Shared hooks: `useTeamOverview()` fetches all data once, both variants consume
- State: tab selection (mobile) / no tab state (desktop) — separate but both components read same `members[]`

### 2. Team Tree (`/doi-nhom/so-do`)

**Mobile**: 
- Hero header "Sơ đồ đội nhóm"
- Canvas full body, horizontal scroll, compact nodes (200x60)
- Tap → bottom sheet detail
- Zoom controls bottom-right floating
- 2 tab toggle trên top body: "Vòng đời" (referral) | "Danh hiệu" (title)

**Desktop**: canvas wider, zoom pan + legend top-left + node cards 200x88

### 3. Member Detail (`/doi-nhom/[salesmanId]`)

**Mobile**: như Figma screenshots, state variants:
- Variant A — Cá nhân tab + Giao dịch active: "Danh sách giao dịch"
- Variant B — Cá nhân tab + Nguồn hàng active: "Danh sách nguồn hàng"
- Variant C — Đội nhóm tab + Giao dịch active: "Danh sách giao dịch đội"
- Variant D — Đội nhóm tab + Nguồn hàng active: "Danh sách nguồn hàng đội"
- Variant E — Đội nhóm tab + Thành viên active: "Danh sách thành viên" (chỉ tab Đội nhóm)

**Desktop**: profile card 2-col (info left + CTA stack right), tabs underline, sub-stats 3-col, list centered max-width 800

---

## Shared tokens mới (add to design-tokens.md)

| Token | Hex | Usage |
|---|---|---|
| `primary-gradient-start` | `#FB923C` | Hero header top |
| `primary-gradient-end` | `#F97316` | Hero header bottom |
| `title-badge-bg` | `#FFF4D9` | Title pill background (warm yellow) |
| `title-badge-text` | `#92400E` | Title pill text (warm brown) |
| `hero-icon-btn-bg` | `rgba(255,255,255,0.2)` | 40x40 circle buttons trên hero (back, history) |

## API wire (unchanged from plan)

Xem `plans/260417-1558-webapp-agent-mvp/phase-08-team-management.md` section API Endpoints. Key: `/api_team_overview`, `/api_team_members`, `/api_get_full_tree`, `/api_member_detail`, `/api_member_inventory`, `/api_member_transactions`, `/api_member_subordinates`.

## Real data shapes

```json
// Member detail header — từ api_member_detail
{
  "salesman_id": 13490,
  "name": "Nguyễn Văn Đức",
  "title_name": "Giám đốc khối",
  "title_code": "GDK",
  "growth_percent": 78,           // mô phỏng "+78% ↑"
  "growth_direction": "up",
  "avatar": "https://...",
  "phone": "0912345678",
  "total_revenue": 8213100,
  "personal_deals": 20,
  "personal_inventory": 20,
  "team_members_count": 15
}
```

## Interaction patterns

- Tab switch: fade content 150ms
- Stat card click: instant switch list content (client-side filter or fetch)
- Tree node tap (mobile): open bottom sheet với member summary + "Xem chi tiết"
- Pull-to-refresh: top of page (mobile)

## Open questions

- BE confirm `period` param cho `api_team_overview` (B9 chờ)
- Growth percent `+78%`/`-30%` — BE trả field gì? (`growth_percent`, `change_rate`?) → cần check BE
- Title progress (current → next) data structure trên API V1 → confirm

## Notes implementation

- Mobile hero + profile card cần `SafeAreaView` (React Native) hoặc `env(safe-area-inset-top)` (web PWA)
- Avatar border ring 4px white: dùng `ring-4 ring-white` (Tailwind) hoặc `box-shadow: 0 0 0 4px white`
- Orange gradient: `bg-gradient-to-b from-[#FB923C] to-[#F97316]`
- Tab underline: bottom border-b-2 border-primary, transition 200ms
- Bottom sheet: shadcn `Sheet side="bottom"` hoặc Radix `Drawer`

---

<a id="docs-screens-xac-thuc-bds-screens-md"></a>

## docs/screens/xac-thuc-bds-screens.md

---
title: Xác thực BDS — Screens spec (high-level)
type: design-spec
level: high-level
phase: 06
audience: Pencil AI designer + FE devs
date: 2026-04-28
related:
  - docs/screens/design-tokens.md
  - docs/01-brainstorm.md
  - docs/02-api-catalog.md
  - C:/Data 2026/Wikis/Docs/_v1-reference/business-flows.md (1. Luồng Xác thực BDS)
  - C:/Data 2026/Wikis/Docs/_v1-reference/features/app/Xác thực BDS.md
  - C:/Data 2026/Wikis/Docs/_v1-reference/features/app/Luồng phê duyệt BDS xác thực cho App.md
design_file: Design/xac_thucbds.pen
---

# Xác thực BDS — Screens spec

Mục tiêu: Pencil AI tự fill chi tiết. Mô tả purpose + key sections + states.

## Brand context

- Vietnamese UI, locale vi
- Tool nội bộ Agent BDS — density cao, professional
- shadcn/ui + Tailwind v4, design tokens theo `design-tokens.md`
- **Mobile-first** → scale lên `sm:` / `lg:` (memory rule)

---

## 0. Business flow tóm tắt

```
CTV/TP/GĐK tạo BDS
  ├─ CTV tạo  → Chờ gán đầu chủ → Admin VP gán → Chờ xác nhận → (Đầu chủ xác nhận)
  │              ├─ Đầu chủ có quyền phê duyệt → Thành công
  │              └─ Đầu chủ chỉ xác nhận → Chờ phê duyệt → TP/GĐK phê duyệt
  │                                                          ├─ Thành công
  │                                                          └─ Từ chối / Yêu cầu sửa
  └─ TP/GĐK tạo → Thành công ngay
```

**Status enum:** `Chờ gán` (vàng) · `Chờ xác nhận` (cam) · `Chờ phê duyệt` (xanh dương) · `Thành công` (xanh) · `Từ chối` (đỏ).

**Roles tham gia:**
- **CTV (đầu chủ)** — tạo + bổ sung thông tin xác thực
- **Đầu chủ** — xác nhận thông tin (chỉ Admin VP gán)
- **Trưởng phòng / GĐ Khối** — quản lý hỗ trợ + phê duyệt
- **Admin VP** — gán đầu chủ + gán trưởng phòng + xem toàn VP

---

## 1. Danh sách Xác thực (`/xac-thuc-bds`)

**Purpose**: Hiển thị tất cả bản ghi xác thực BDS theo role, filter theo trạng thái + thời gian + đầu chủ + TP.

**Topbar:**
- Title "Xác thực BDS" + count badge
- Search box (tên BĐS / địa chỉ)
- Filter button (mở filter sheet)
- Button "+ Tạo xác thực" (chỉ CTV)

**Tabs trạng thái** (sticky dưới topbar, scrollable horizontal mobile):
`Tất cả | Chờ gán | Chờ xác nhận | Chờ phê duyệt | Thành công | Từ chối`
- Tab "Chờ gán" chỉ hiển thị với role Admin VP / TP

**Card item** (mobile-first, p-3, gap-2):
- Hàng 1: thumbnail BDS 64×64 (radius lg) + (vertical) tên BĐS / dự án + địa chỉ ngắn 1 dòng
- Hàng 2: giá nổi bật (text-primary 16/600) + status badge (màu theo enum)
- Hàng 3: chips meta — `[icon person] Tên người đăng (chức vụ)` + `[icon shield] Đầu chủ: Tên` (hoặc btn "Giao đầu chủ" nếu chưa gán + role match)
- Hàng 4: `Ngày tạo dd/MM/yyyy` · `Đã gán Xh/Xd trước` (dot color: <2d xanh, 2-4d vàng, >4d đỏ)
- Hover/active: surface-muted, cursor pointer → mở chi tiết
- Action zone phải card: nút icon "..." mở action sheet (Giao đầu chủ / Gán TP / Xem chi tiết)

**Empty state**: icon shield-off + "Chưa có bản ghi xác thực" (mỗi tab độc lập).

**States**: idle · loading (skeleton 3 cards) · empty · error toast.

**Responsive**:
- Mobile: stack 1 col, card full-width, padding 12
- Desktop ≥1024: 2 col grid hoặc table view (toggle icon góc phải topbar)

---

## 2. Filter sheet (mobile drawer / desktop popover)

**Trigger:** filter button trên topbar list.

**Sections (vertical, gap 16):**
- Trạng thái — multi chip select (sync với tabs)
- Khoảng thời gian — preset (Hôm nay / 7 ngày / 30 ngày) + custom date range
- Đầu chủ — search picker (chỉ hiện cho Admin/TP)
- Quản lý hỗ trợ (TP) — search picker (chỉ Admin)
- Văn phòng — chỉ Admin VP cấp cao
- Loại tạo — `Tôi tạo` / `Được gán cho tôi` / `Tôi quản lý`

**Footer:** btn "Đặt lại" (ghost) + btn "Áp dụng" (primary). Active filter count chip ở topbar.

---

## 3. Chi tiết — Tab "Bài viết công khai" (`/xac-thuc-bds/[id]`)

**Purpose**: Xem snapshot bài đăng public của BDS. Mặc định mở khi vào chi tiết.

**Header (sticky):**
- Back button + title "Chi tiết xác thực BĐS"
- Status badge phải header
- Subline: `[icon] Người đăng (chức vụ) · Đầu chủ: Tên · TP: Tên · Đăng dd/MM/yyyy`

**Tabs:** `Bài viết công khai` (active) | `Thông tin xác thực`

**Content (vertical, gap 16):**
- Image slider 16:9 với counter `1/12`
- Tiêu đề tin (20/700)
- Địa chỉ ngắn + thời gian đăng relative + chip "Đăng X tuần trước"
- Pricing row: Giá tổng (22/700 primary) · Giá/m² (13 secondary) · subtitle "VD: 3,600 tỷ"
- Spec icons row: 🛏 N PN · 🛁 N WC · ▢ N m²
- Mô tả chi tiết (paragraph, expand "Xem thêm")
- Section "Giấy tờ pháp lý" — list file: icon + tên file + nút "Xem"
- Section "Đặc điểm" — grid 2 col key/value: Mức giá, Diện tích, Giá/m², Pháp lý, Số PN, Tình trạng, Nội thất
- Map view — embed Google Map snapshot vị trí

**Footer action bar (sticky, role-based):**
- CTV (xác thực status = Chờ xác nhận hoặc nháp): btn "Bổ sung thông tin xác thực" (primary)
- Admin/TP (Chờ gán): btn "Giao đầu chủ" + btn "Gán TP" (secondary)
- Đầu chủ (Chờ xác nhận): btn "Từ chối" (ghost destructive) + btn "Xác nhận" (primary)
- TP/GĐK có quyền duyệt (Chờ phê duyệt): btn "Yêu cầu sửa" + btn "Từ chối" + btn "Phê duyệt" (primary)

---

## 4. Chi tiết — Tab "Thông tin xác thực" (3 cases pháp lý)

**Purpose**: Xem dữ liệu chủ nhà nhập + đính kèm pháp lý.

**3 cases pháp lý:**
- A. Pháp lý bìa đỏ (sổ đỏ / sổ hồng)
- B. Pháp lý hợp đồng mua bán
- C. Pháp lý khác

**Sections chung (mọi case):**
- "Thông tin liên hệ chủ nhà" — Họ tên + SĐT + (optional) ảnh CCCD trước/sau (chỉ ảnh, không nhập text từ ảnh)
- "Địa điểm" — Link Google Map · Tỉnh / Quận / Phường · Địa chỉ cụ thể
- "Thông tin giao dịch" — Giá trị HĐ, Phí môi giới (VND hoặc %), Bên chịu thuế (toggle Chủ/Khách/Chia 50:50), Tỷ lệ TT đặt cọc — TT hoàn tất (validate sum=100%)

**Section riêng theo case:**
- A. **Bìa đỏ:**
  - Block "Người trên bìa đỏ" — list 1-2 chủ: Họ tên, CCCD, ảnh CCCD trước/sau (bắt buộc đủ ảnh)
  - Giấy chứng nhận số · Quyển số · Cấp ngày
  - Tình trạng hợp đồng (optional)
- B. **HĐ mua bán:**
  - File HĐMB (PDF/image) preview
  - Số HĐMB · Ngày ký · Bên bán · Bên mua
- C. **Pháp lý khác:**
  - Free-text "Mô tả pháp lý"
  - Multi-file attachment

**Pháp lý bổ sung khác** (mọi case): textarea note + multi-file.

**State display:**
- View mode (default cho mọi role) — read-only
- Edit mode (CTV chủ + status nháp/Chờ xác nhận) — toggle từ btn "Chỉnh sửa" góc phải
- Annotations: nếu có comment phê duyệt từ TP → banner cam ở đầu "TP yêu cầu sửa: ..."

---

## 5. Form bổ sung / chỉnh sửa thông tin xác thực (`/xac-thuc-bds/[id]/edit`)

**Purpose**: CTV nhập/sửa thông tin xác thực BDS (multi-step hoặc single long form).

**Layout**: Single page với section cards (gap 16), sticky save bar bottom.

**Header**: Back + title "Bổ sung thông tin xác thực" + subline "BĐS: <tên>".

**Section 1 — Pháp lý**: Radio chọn case (Bìa đỏ / HĐMB / Khác) → render section riêng.

**Section 2 — Địa điểm**:
- Input "Link Google Map" (validate URL, optional)
- Cascading select: Tỉnh → Quận/Huyện → Phường/Xã (locations grant=2)
- Input "Địa chỉ cụ thể" (số nhà, tên đường…)

**Section 3 — Thông tin giao dịch**:
- Input number "Giá trị hợp đồng" (prefilled từ giá BDS, có thể sửa, format `xx,xx tỷ`)
- Input "Phí môi giới" — radio toggle `VNĐ / %` + input number (cảnh báo nếu >100%)
- Select "Bên chịu thuế" (mặc định null, required) — `Chủ nhà / Khách / Chia 50:50`
- Cặp input "Tỷ lệ TT đặt cọc %" + "Tỷ lệ TT hoàn tất %" — validate sum=100, helper text live

**Section 4 — Liên hệ chủ nhà**:
- Họ tên (required) + SĐT (required, format VN)
- Ảnh CCCD chủ nhà 1 (mặt trước + sau, optional ở section này)
- Btn "+ Thêm chủ nhà" → chủ nhà 2

**Section 5 (case A — Bìa đỏ) — Người trên bìa đỏ**:
- Block per chủ: ảnh CCCD trước + sau (required đủ 2 ảnh) + Họ tên + CCCD/CMND (required ít nhất 1 chủ có đủ tên + CCCD)
- Note "Sau khi upload ảnh, hệ thống có thể quét QR fill tự động" (BE bỏ logic quét)
- Giấy chứng nhận số · Quyển số · Cấp ngày (required all 3)
- Tình trạng hợp đồng (textarea, optional)
- Thông tin pháp lý khác (textarea, optional)

**Section 5 (case B/C)**: theo spec ở §4.

**Validation warnings (modal hoặc inline):**
- "SĐT chủ nhà đã tồn tại với họ tên là <X>. Bạn có muốn sử dụng tên này không?" — `Có (dùng tên DB)` / `Không (giữ tên đã nhập)`
- "Thông tin chủ nhà không trùng với thông tin chủ nhà trong bìa đỏ" — block save
- "Tỷ lệ TT phải bằng 100%"
- "Phí môi giới vượt 100%"

**Sticky footer:**
- Btn "Hủy" (ghost) — confirm dialog nếu dirty
- Btn "Lưu nháp" (secondary)
- Btn "Gửi xác thực" (primary) — chuyển status `Chờ xác nhận`

**States**: idle · validating · saving · success toast → redirect chi tiết · error inline trên field.

---

## 6. Modal — Giao đầu chủ

**Purpose**: Admin VP / TP gán đầu chủ cho BDS đang `Chờ gán`.

**Trigger:** btn "Giao đầu chủ" trên list card hoặc detail footer.

**Content:**
- Title "Giao đầu chủ"
- Subtitle "Chọn CTV có quyền đầu chủ phụ trách BDS này"
- Search input (tìm theo tên / SĐT)
- List CTV đầu chủ (scrollable, max-h 400):
  - Avatar + Họ tên + SĐT + chức vụ + (tag) "Trong VP" / "Đội nhóm của tôi"
  - Radio chọn 1
- Filter quyền:
  - Admin VP → toàn CTV đầu chủ trong VP
  - TP → CTV đầu chủ trong đội nhóm

**Footer:** btn "Hủy" + btn "Giao" (primary, disabled khi chưa chọn).

**After confirm:** Toast "Đã giao đầu chủ <Tên>", record chuyển status `Chờ xác nhận`, gửi notify đầu chủ.

---

## 7. Modal — Gán Trưởng phòng

Tương tự §6 nhưng:
- Chỉ Admin VP thấy
- Source list = TP/GĐK trong VP của Admin
- Sau confirm: Toast "Đã gán quản lý hỗ trợ <Tên>"

---

## 8. Modal — Xác nhận / Phê duyệt / Từ chối

**Trigger** trên detail footer.

**Variants:**

**A. Đầu chủ xác nhận:**
- Title "Xác nhận thông tin BDS"
- Body: tóm tắt key fields (tên BĐS · giá · chủ nhà · pháp lý)
- Checkbox "Tôi đã kiểm tra và xác nhận thông tin chính xác"
- Btn "Hủy" + "Xác nhận" (primary, disabled tới khi check)

**B. Đầu chủ / TP từ chối:**
- Title "Từ chối xác thực"
- Textarea "Lý do từ chối" (required, min 10 chars)
- Btn "Hủy" + "Xác nhận từ chối" (destructive)

**C. TP yêu cầu sửa:**
- Title "Yêu cầu chỉnh sửa"
- Multi-select fields cần sửa (BĐS info / Pháp lý / Chủ nhà / Giao dịch)
- Textarea "Ghi chú cho CTV"
- Btn "Hủy" + "Gửi yêu cầu sửa"
- After confirm: record về `Chờ xác nhận` + notify CTV

**D. TP/GĐK phê duyệt:**
- Title "Phê duyệt xác thực"
- Body: summary
- Btn "Phê duyệt" (primary success)

---

## API mapping (sơ bộ — confirm với BE)

| UI action | Endpoint (suggest) |
|---|---|
| List xác thực | `GET /api_agent/list_verification` (filter: status, assigned_to, manager, office) |
| Chi tiết | `GET /api_agent/get_verification?id=` |
| Tạo / Update form | `POST /api_agent/save_verification` |
| Giao đầu chủ | `POST /api_agent/assign_verification_owner` |
| Gán TP | `POST /api_agent/assign_verification_manager` |
| Đầu chủ xác nhận | `POST /api_agent/confirm_verification` |
| TP phê duyệt | `POST /api_agent/approve_verification` |
| Từ chối / yêu cầu sửa | `POST /api_agent/reject_verification` |
| Upload ảnh CCCD / file pháp lý | shared upload endpoint (multipart) |

---

## Open questions (chờ BE clarify)

1. Endpoint chính thức cho từng action xác thực BDS?
2. Schema record verification (fields, file refs, status transitions)?
3. Quyền role check ở BE đã đầy đủ chưa hay FE tự enforce hidden actions?
4. Logic auto-gán đầu chủ khi người đăng = đầu chủ — BE handle hay FE call?
5. Thông báo (notification) gửi qua kênh nào (push / in-app / cả hai)?
6. Logic quét QR CCCD đã bỏ — confirm BE không cần QR field nữa?
7. `commission_type` trong context xác thực có khác `buyer/seller/shared` không?

---

<a id="docs-superpowers-plans-2026-05-13-consultation-activities-api-md"></a>

## docs/superpowers/plans/2026-05-13-consultation-activities-api.md

# Consultation Activities API — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Wire 6 consultation activities endpoints from `docs/API_Consultation_Activities.md` into the existing consultation detail page — replacing mock data in timeline, TODO stubs in dialogs, and adding status update + comment capabilities.

**Architecture:** Thin API layer in `lib/api/consultation-activities.ts` mirrors the 6 endpoints. Types defined in dedicated schema. TanStack Query hooks in `hooks/use-consultation-activities.ts`. UI wiring replaces `DEMO_EVENTS` hardcode and mock `setTimeout` calls in existing dialogs.

**Tech Stack:** Next.js 15 · TypeScript strict · TanStack Query v5 · Zod · ofetch (via `lib/api/http`)

---

## File Structure

| Action | File | Responsibility |
|--------|------|---------------|
| Create | `src/types/consultation-activity.ts` | Zod schemas + types for Activity, Work, Note, WorkStatus, Comment |
| Create | `src/lib/api/consultation-activities.ts` | 6 API functions calling BE endpoints |
| Create | `src/hooks/use-consultation-activities.ts` | TanStack Query hooks (queries + mutations) |
| Modify | `src/components/nhu-cau/working-bds/working-bds-row-expanded.tsx` | Replace DEMO_EVENTS with real activity data |
| Modify | `src/components/appointments/create-appointment-dialog.tsx` | Wire real BE call replacing mock |
| Modify | `src/components/deposit/create-deposit-dialog.tsx` | Wire real BE call replacing mock |
| Modify | `src/components/nhu-cau/working-bds/working-bds-section.tsx` | Pass `consultationId` to expanded row for activity query |
| Modify | `src/components/nhu-cau/add-note-dialog/index.tsx` | Add optional `note_type` + `related_id` props for BDS-specific notes |

**NOT modified** (out of scope): `consultation-works-tabs-card.tsx`, `consultation-activity-card.tsx`, `consultation-comments-timeline.tsx`, `lib/api/workflow.ts`, `lib/api/comments.ts`

---

### Task 1: Define Types & Zod Schemas

**Files:**
- Create: `src/types/consultation-activity.ts`

- [ ] **Step 1: Create the types file**

Follows project pattern from `src/types/consultation.ts` — Zod schemas with `.passthrough()`, `NumberOrString` union, `nullish()` defaults.

```typescript
import { z } from 'zod';

const NumberOrString = z.union([z.number(), z.string()]);

/* ───────── Work Status ───────── */
export const WorkStatusSchema = z.enum([
  'waiting',
  'in_progress',
  'completed',
  'cancelled',
  'no_show',
  'forfeited',
  'refunded',
]);
export type WorkStatus = z.infer<typeof WorkStatusSchema>;

/* ───────── Work Type ───────── */
export const WorkTypeSchema = z.enum(['appointment', 'deposit', 'note']);
export type WorkType = z.infer<typeof WorkTypeSchema>;

/* ───────── Note Type ───────── */
export const NoteTypeSchema = z.enum(['real_estate', 'customer', 'internal']);
export type NoteType = z.infer<typeof NoteTypeSchema>;

/* ───────── Comment Type ───────── */
export const CommentKindSchema = z.enum([
  'note_real_estate',
  'note_customer',
  'note_internal',
  'call_log',
  'comment',
  'status_update',
]);
export type CommentKind = z.infer<typeof CommentKindSchema>;

/* ───────── User (embedded in comment) ───────── */
export const ActivityUserSchema = z
  .object({
    id: NumberOrString.nullish(),
    name: z.string().nullish(),
    avatar: z.string().nullish(),
    award_title: z.string().nullish(),
  })
  .passthrough();
export type ActivityUser = z.infer<typeof ActivityUserSchema>;

/* ───────── Attachment ───────── */
export const AttachmentSchema = z
  .object({
    key: z.string().nullish(),
    name: z.string().nullish(),
    url: z.string().nullish(),
    type: z.string().nullish(),
  })
  .passthrough();
export type Attachment = z.infer<typeof AttachmentSchema>;

/* ───────── Activity Comment (within a work) ───────── */
export const ActivityCommentSchema = z
  .object({
    id: NumberOrString,
    content: z.string().nullish(),
    comment_type: CommentKindSchema.nullish(),
    user: ActivityUserSchema.nullish(),
    attachments: z.array(AttachmentSchema).nullish(),
    created_at: z.string().nullish(),
  })
  .passthrough();
export type ActivityComment = z.infer<typeof ActivityCommentSchema>;

/* ───────── Activity Work Item (from get_activities_consultation) ───────── */
export const ActivityWorkSchema = z
  .object({
    work_id: NumberOrString,
    work_name: z.string().nullish(),
    work_type: WorkTypeSchema.nullish(),
    template_id: NumberOrString.nullish(),
    started_at: z.string().nullish(),
    status: WorkStatusSchema.nullish(),
    location: z.string().nullish(),
    amount_deposit: NumberOrString.nullish(),
    deposit_type: z.string().nullish(),
    comment_type: CommentKindSchema.nullish(),
    comments: z.array(ActivityCommentSchema).nullish(),
    comment_count: NumberOrString.nullish(),
    assigned_to: NumberOrString.nullish(),
    assigned_to_name: z.string().nullish(),
    real_estate_id: NumberOrString.nullish(),
    customer_id: NumberOrString.nullish(),
    created_at: z.string().nullish(),
  })
  .passthrough();
export type ActivityWork = z.infer<typeof ActivityWorkSchema>;

/* ───────── Activities Response ───────── */
export const ActivitiesSummarySchema = z
  .object({
    total_works: NumberOrString.nullish(),
    total_comments: NumberOrString.nullish(),
    by_type: z
      .object({
        appointment: NumberOrString.nullish(),
        deposit: NumberOrString.nullish(),
        note: NumberOrString.nullish(),
      })
      .passthrough()
      .nullish(),
    by_status: z.record(z.unknown()).nullish(),
  })
  .passthrough();

export const ActivitiesResponseSchema = z
  .object({
    tab: z.string().nullish(),
    tab_id: NumberOrString.nullish(),
    works: z.array(ActivityWorkSchema).default([]),
    summary: ActivitiesSummarySchema.nullish(),
    pagination: z
      .object({
        page: NumberOrString.nullish(),
        limit: NumberOrString.nullish(),
        total: NumberOrString.nullish(),
        pages: NumberOrString.nullish(),
      })
      .passthrough()
      .nullish(),
  })
  .passthrough();
export type ActivitiesResponse = z.infer<typeof ActivitiesResponseSchema>;

/* ───────── Create Work Payload ───────── */
export const CreateWorkPayloadSchema = z.object({
  template_id: z.number(),
  real_estate_id: NumberOrString.optional(),
  customer_id: NumberOrString.optional(),
  consultation_id: NumberOrString.optional(),
  transaction_id: NumberOrString.optional(),
  started_at: z.string().optional(),
  location: z.string().optional(),
  deposit_type: z.enum(['thien_chi', 'coc_chet']).optional(),
  deposit_amount: z.number().optional(),
  note: z.string().optional(),
  assigned_to: NumberOrString.optional(),
  post_office_id: NumberOrString.optional(),
  buyer_agent_id: NumberOrString.optional(),
  owner_agent_id: NumberOrString.optional(),
  documents: z.array(z.unknown()).optional(),
});
export type CreateWorkPayload = z.infer<typeof CreateWorkPayloadSchema>;

/* ───────── Create Note Payload ───────── */
export const CreateNotePayloadSchema = z.object({
  note_type: NoteTypeSchema,
  related_id: NumberOrString.nullish(),
  content: z.string(),
  attachments: z.array(z.unknown()).optional(),
  visibility: z.enum(['public', 'internal']).optional(),
});
export type CreateNotePayload = z.infer<typeof CreateNotePayloadSchema>;

/* ───────── Update Work Status Payload ───────── */
export const UpdateWorkStatusPayloadSchema = z.object({
  work_id: NumberOrString,
  status: WorkStatusSchema,
  result_note: z.string().optional(),
  reason: z.string().optional(),
});
export type UpdateWorkStatusPayload = z.infer<typeof UpdateWorkStatusPayloadSchema>;

/* ───────── Add Work Comment Payload ───────── */
export const AddWorkCommentPayloadSchema = z.object({
  work_id: NumberOrString,
  content: z.string(),
  comment_type: z.string().optional(),
  documents: z.array(z.unknown()).optional(),
});
export type AddWorkCommentPayload = z.infer<typeof AddWorkCommentPayloadSchema>;
```

- [ ] **Step 2: Commit**

```bash
git add src/types/consultation-activity.ts
git commit -m "feat: add consultation activity types & zod schemas"
```

---

### Task 2: API Layer — 6 Endpoint Functions

**Files:**
- Create: `src/lib/api/consultation-activities.ts`

- [ ] **Step 1: Create the API file**

Follows pattern from `lib/api/consultation.ts` — uses `httpClient` from `lib/api/http`, defensive unwrap, Zod parse with passthrough fallback.

```typescript
import type {
  ActivitiesResponse,
  AddWorkCommentPayload,
  CreateNotePayload,
  CreateWorkPayload,
  UpdateWorkStatusPayload,
} from '@/types/consultation-activity';
import { ActivitiesResponseSchema } from '@/types/consultation-activity';
import { httpClient } from './http';

function unwrapData(raw: unknown): unknown {
  if (raw && typeof raw === 'object') {
    const obj = raw as Record<string, unknown>;
    if (obj.data !== undefined) return obj.data;
  }
  return raw;
}

/* ───────── 1. Create Work (appointment / deposit / other) ───────── */
export async function createWork(payload: CreateWorkPayload): Promise<{ work_id: number }> {
  const raw = await httpClient<unknown>('/api_agent/create_work_consultation', {
    method: 'POST',
    body: payload,
  });
  const source = unwrapData(raw) as Record<string, unknown> | null;
  return {
    work_id: Number(source?.work_id ?? source?.work?.id ?? 0),
  };
}

/* ───────── 2. Create Note ───────── */
export async function createNote(payload: CreateNotePayload): Promise<{ work_id: number; comment_id: number }> {
  const raw = await httpClient<unknown>('/api_agent/create_note_consultation', {
    method: 'POST',
    body: payload,
  });
  const source = unwrapData(raw) as Record<string, unknown> | null;
  return {
    work_id: Number(source?.work_id ?? 0),
    comment_id: Number(source?.comment_id ?? 0),
  };
}

/* ───────── 3. Get Activities ───────── */
export interface GetActivitiesParams {
  tab: 'bds' | 'customer' | 'internal';
  tab_id?: number | string;
  activity_type?: 'appointment' | 'deposit' | 'note' | 'all';
  page?: number;
  limit?: number;
}

export async function getActivities(params: GetActivitiesParams): Promise<ActivitiesResponse> {
  const raw = await httpClient<unknown>('/api_agent/get_activities_consultation', {
    method: 'GET',
    params: {
      tab: params.tab,
      ...(params.tab_id != null ? { tab_id: String(params.tab_id) } : {}),
      ...(params.activity_type && params.activity_type !== 'all' ? { activity_type: params.activity_type } : {}),
      ...(params.page ? { page: String(params.page) } : {}),
      ...(params.limit ? { limit: String(params.limit) } : {}),
    },
  });
  const source = unwrapData(raw);
  const parsed = ActivitiesResponseSchema.safeParse(source);
  if (parsed.success) return parsed.data;
  if (process.env.NODE_ENV !== 'production') {
    console.warn('[getActivities] parse failed, passthrough', parsed.error?.issues);
  }
  return source as ActivitiesResponse;
}

/* ───────── 4. Get Appointments List ───────── */
export interface GetAppointmentsParams {
  consultation_id?: number | string;
  real_estate_id?: number | string;
  status?: string | string[];
  date_from?: string;
  date_to?: string;
  search?: string;
  page?: number;
  limit?: number;
}

export async function getAppointments(params: GetAppointmentsParams = {}): Promise<unknown[]> {
  const raw = await httpClient<unknown>('/api_agent/get_list_appointments_consultation', {
    method: 'GET',
    params: {
      ...(params.consultation_id ? { consultation_id: String(params.consultation_id) } : {}),
      ...(params.real_estate_id ? { real_estate_id: String(params.real_estate_id) } : {}),
      ...(params.status ? { status: params.status } : {}),
      ...(params.date_from ? { date_from: params.date_from } : {}),
      ...(params.date_to ? { date_to: params.date_to } : {}),
      ...(params.search ? { search: params.search } : {}),
      ...(params.page ? { page: String(params.page) } : {}),
      ...(params.limit ? { limit: String(params.limit) } : {}),
    },
  });
  const source = unwrapData(raw);
  return Array.isArray(source) ? source : [];
}

/* ───────── 5. Update Work Status ───────── */
export async function updateWorkStatus(payload: UpdateWorkStatusPayload): Promise<{ work_id: number; status: string }> {
  const raw = await httpClient<unknown>('/api_agent/update_work_status_consultation', {
    method: 'POST',
    body: payload,
  });
  const source = unwrapData(raw) as Record<string, unknown> | null;
  return {
    work_id: Number(source?.work_id ?? payload.work_id),
    status: String(source?.status ?? payload.status),
  };
}

/* ───────── 6. Add Work Comment ───────── */
export async function addWorkComment(payload: AddWorkCommentPayload): Promise<{ comment_id: number }> {
  const raw = await httpClient<unknown>('/api_agent/add_work_comment_consultation', {
    method: 'POST',
    body: payload,
  });
  const source = unwrapData(raw) as Record<string, unknown> | null;
  const comment = source?.comment as Record<string, unknown> | undefined;
  return {
    comment_id: Number(comment?.id ?? source?.comment_id ?? 0),
  };
}
```

- [ ] **Step 2: Commit**

```bash
git add src/lib/api/consultation-activities.ts
git commit -m "feat: add consultation activities API layer (6 endpoints)"
```

---

### Task 3: TanStack Query Hooks

**Files:**
- Create: `src/hooks/use-consultation-activities.ts`

- [ ] **Step 1: Create the hooks file**

Follows pattern from `hooks/use-consultations.ts` — query keys factory, `useQuery` for reads, `useMutation` + `useQueryClient` invalidation for writes.

```typescript
'use client';

import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { toast } from 'sonner';
import {
  type AddWorkCommentPayload,
  type CreateNotePayload,
  type CreateWorkPayload,
  type GetActivitiesParams,
  type UpdateWorkStatusPayload,
} from '@/types/consultation-activity';
import {
  addWorkComment,
  createNote,
  createWork,
  getActivities,
  updateWorkStatus,
} from '@/lib/api/consultation-activities';

/* ───────── Query keys ───────── */
const KEYS = {
  activities: (tab: string, tabId?: number | string, activityType?: string) =>
    ['consultation-activities', tab, tabId ?? 'all', activityType ?? 'all'] as const,
};

/* ───────── Queries ───────── */

/** Fetch activities for a tab (bds/customer/internal) */
export function useActivities(params: GetActivitiesParams, enabled = true) {
  return useQuery({
    queryKey: KEYS.activities(params.tab, params.tab_id, params.activity_type),
    queryFn: () => getActivities(params),
    enabled,
    staleTime: 30_000,
  });
}

/* ───────── Mutations ───────── */

/** Create work (appointment=4, deposit=29, other=42) */
export function useCreateWork() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (payload: CreateWorkPayload) => createWork(payload),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['consultation-activities'] });
      qc.invalidateQueries({ queryKey: ['consultations', 'detail'] });
    },
    onError: (err) => toast.error(err instanceof Error ? err.message : 'Tạo công việc thất bại'),
  });
}

/** Create note (BDS/customer/internal) */
export function useCreateNote() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (payload: CreateNotePayload) => createNote(payload),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['consultation-activities'] });
      qc.invalidateQueries({ queryKey: ['comments'] });
    },
    onError: (err) => toast.error(err instanceof Error ? err.message : 'Tạo ghi chú thất bại'),
  });
}

/** Update work status */
export function useUpdateWorkStatus() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (payload: UpdateWorkStatusPayload) => updateWorkStatus(payload),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['consultation-activities'] });
      qc.invalidateQueries({ queryKey: ['consultations', 'detail'] });
    },
    onError: (err) => toast.error(err instanceof Error ? err.message : 'Cập nhật trạng thái thất bại'),
  });
}

/** Add comment to a work */
export function useAddWorkComment() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (payload: AddWorkCommentPayload) => addWorkComment(payload),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['consultation-activities'] });
    },
    onError: (err) => toast.error(err instanceof Error ? err.message : 'Thêm bình luận thất bại'),
  });
}
```

- [ ] **Step 2: Commit**

```bash
git add src/hooks/use-consultation-activities.ts
git commit -m "feat: add TanStack Query hooks for consultation activities"
```

---

### Task 4: Wire Real Timeline into WorkingBdsRowExpanded

**Files:**
- Modify: `src/components/nhu-cau/working-bds/working-bds-row-expanded.tsx`
- Modify: `src/components/nhu-cau/working-bds/working-bds-section.tsx`

This is the core change — replace the hardcoded `DEMO_EVENTS` with real API data from `get_activities_consultation`.

- [ ] **Step 1: Update WorkingBdsRowExpanded to accept consultationId and use real data**

Replace the entire file content. Key changes:
- Accept `consultationId` prop
- Replace `DEMO_EVENTS` with `useActivities` hook calling `get_activities_consultation?tab=bds&tab_id=<bdsId>`
- Map `ActivityWork` items to the existing `TimelineEvent` shape
- Keep the same UI structure and action buttons

```typescript
'use client';

import {
  BriefcaseIcon,
  CalendarDaysIcon,
  CircleDollarSignIcon,
  ClockIcon,
  FileTextIcon,
  PhoneIcon,
  Share2Icon,
  ShieldCheckIcon,
  XCircleIcon,
} from 'lucide-react';
import type { ComponentType, SVGProps } from 'react';
import { useActivities } from '@/hooks/use-consultation-activities';
import { cn } from '@/lib/utils';
import type { ActivityWork } from '@/types/consultation-activity';
import type { WorkingBdsActionKind, WorkingBdsItem } from '@/types/working-bds';

interface WorkingBdsRowExpandedProps {
  item: WorkingBdsItem;
  consultationId: string | number;
  onAction: (kind: WorkingBdsActionKind, item: WorkingBdsItem) => void;
}

/* ───────── Map ActivityWork → TimelineEvent ───────── */

type TimelineEventKind = 'call' | 'appointment' | 'lead' | 'note' | 'deposit' | 'verify';

interface TimelineEvent {
  id: string;
  kind: TimelineEventKind;
  title: string;
  body?: string;
  meta?: string;
  time: string;
  highlight?: 'green' | 'amber';
}

function workTypeToKind(workType: string | null | undefined): TimelineEventKind {
  switch (workType) {
    case 'appointment': return 'appointment';
    case 'deposit': return 'deposit';
    case 'note': return 'note';
    default: return 'note';
  }
}

function statusToHighlight(status: string | null | undefined): 'green' | 'amber' | undefined {
  if (status === 'completed') return 'green';
  if (status === 'waiting' || status === 'in_progress') return 'amber';
  return undefined;
}

function mapWorkToEvent(w: ActivityWork): TimelineEvent {
  const kind = workTypeToKind(w.work_type);
  return {
    id: String(w.work_id),
    kind,
    title: w.work_name ?? 'Hoạt động',
    body: w.comments?.[0]?.content ?? undefined,
    meta: w.status === 'waiting' ? 'Chờ diễn ra'
      : w.status === 'completed' ? 'Hoàn thành'
      : w.status === 'cancelled' ? 'Đã hủy'
      : w.status === 'in_progress' ? 'Đang thực hiện'
      : w.status ?? undefined,
    time: w.created_at ?? '',
    highlight: statusToHighlight(w.status),
  };
}

/* ───────── Actions config (unchanged) ───────── */

interface ActionConfig {
  kind: WorkingBdsActionKind;
  label: string;
  icon: ComponentType<SVGProps<SVGSVGElement>>;
  iconClass: string;
}

const SECONDARY_ACTIONS: ActionConfig[] = [
  { kind: 'request_verify', label: 'Nhắc xác thực', icon: ShieldCheckIcon, iconClass: 'bg-amber-50 text-amber-600' },
  { kind: 'create_appointment', label: 'Hẹn xem', icon: CalendarDaysIcon, iconClass: 'bg-violet-50 text-violet-600' },
  { kind: 'request_deposit', label: 'Đặt cọc', icon: CircleDollarSignIcon, iconClass: 'bg-emerald-50 text-emerald-600' },
  { kind: 'mark_unsuitable', label: 'Không phù hợp', icon: XCircleIcon, iconClass: 'bg-rose-50 text-rose-600' },
];

const KIND_ICON: Record<TimelineEventKind, ComponentType<SVGProps<SVGSVGElement>>> = {
  call: PhoneIcon,
  appointment: CalendarDaysIcon,
  lead: BriefcaseIcon,
  note: FileTextIcon,
  deposit: CircleDollarSignIcon,
  verify: ShieldCheckIcon,
};

const KIND_ICON_CLASS: Record<TimelineEventKind, string> = {
  call: 'bg-emerald-50 text-emerald-600',
  appointment: 'bg-amber-50 text-amber-600',
  lead: 'bg-emerald-50 text-emerald-600',
  note: 'bg-slate-100 text-slate-600',
  deposit: 'bg-emerald-50 text-emerald-600',
  verify: 'bg-amber-50 text-amber-600',
};

/* ───────── Component ───────── */

export function WorkingBdsRowExpanded({ item, consultationId, onAction }: WorkingBdsRowExpandedProps) {
  const bdsId = item.bds.id;
  const { data, isLoading } = useActivities(
    { tab: 'bds', tab_id: Number(bdsId) },
    !!bdsId,
  );
  const works = data?.works ?? [];
  const events = works.map(mapWorkToEvent);

  return (
    <div className="flex flex-col gap-3 bg-muted/20 px-3 py-3 sm:px-4 sm:py-4">
      {/* CTA strip */}
      <div className="flex flex-wrap items-center gap-1.5">
        <span className="mr-auto font-semibold text-[11px] text-muted-foreground uppercase tracking-wide">
          Hoạt động & ghi chú
        </span>
        <button
          type="button"
          onClick={() => onAction('call_owner', item)}
          className="inline-flex h-8 shrink-0 items-center gap-1.5 rounded-md border border-emerald-200 bg-emerald-50 px-3 font-semibold text-[12px] text-emerald-700 hover:bg-emerald-100"
        >
          <PhoneIcon className="size-3.5" aria-hidden="true" />
          Gọi đầu chủ
        </button>
        <button
          type="button"
          onClick={() => onAction('share', item)}
          className="inline-flex h-8 shrink-0 items-center gap-1.5 rounded-md border border-border bg-card px-3 font-semibold text-[12px] text-foreground hover:bg-muted/50"
        >
          <span className="inline-flex size-4 items-center justify-center rounded bg-sky-50 text-sky-600">
            <Share2Icon className="size-3" aria-hidden="true" />
          </span>
          Gửi khách hàng
        </button>
        <button
          type="button"
          onClick={() => onAction('create_work', item)}
          className="inline-flex h-8 shrink-0 items-center gap-1.5 rounded-md border border-border bg-card px-3 font-semibold text-[12px] text-foreground hover:bg-muted/50"
        >
          <span className="inline-flex size-4 items-center justify-center rounded bg-slate-100 text-slate-600">
            <FileTextIcon className="size-3" aria-hidden="true" />
          </span>
          Ghi chú
        </button>
        {SECONDARY_ACTIONS.map((a) => {
          const Icon = a.icon;
          return (
            <button
              key={`${a.kind}-${a.label}`}
              type="button"
              onClick={() => onAction(a.kind, item)}
              className="inline-flex h-8 shrink-0 items-center gap-1.5 rounded-md border border-border bg-card px-2.5 font-medium text-[12px] text-foreground transition-colors hover:bg-muted/50"
            >
              <span className={cn('inline-flex size-4 items-center justify-center rounded', a.iconClass)}>
                <Icon className="size-3" aria-hidden="true" />
              </span>
              {a.label}
            </button>
          );
        })}
      </div>

      {/* Timeline */}
      <div className="rounded-md border border-border bg-card px-3 py-3 sm:px-4 sm:py-4">
        {isLoading ? (
          <div className="flex items-center gap-2 text-[12px] text-muted-foreground">
            <ClockIcon className="size-3.5 animate-pulse" />
            Đang tải hoạt động…
          </div>
        ) : events.length > 0 ? (
          <ul className="flex flex-col">
            {events.map((ev, idx) => (
              <TimelineRow key={ev.id} event={ev} isLast={idx === events.length - 1} />
            ))}
          </ul>
        ) : (
          <div className="flex items-center gap-2 text-[12px] text-muted-foreground">
            <ClockIcon className="size-3.5" aria-hidden="true" />
            Chưa có hoạt động nào cho BDS này
          </div>
        )}
      </div>
    </div>
  );
}

/* ───────── TimelineRow (unchanged) ───────── */

interface TimelineRowProps {
  event: TimelineEvent;
  isLast: boolean;
}

function TimelineRow({ event, isLast }: TimelineRowProps) {
  const Icon = KIND_ICON[event.kind];
  return (
    <li className="relative flex gap-3 pb-4 last:pb-0">
      {!isLast && (
        <span className="absolute top-7 bottom-0 left-3.25 w-px bg-border" aria-hidden="true" />
      )}
      <span
        className={cn(
          'relative z-10 inline-flex size-7 shrink-0 items-center justify-center rounded-full',
          KIND_ICON_CLASS[event.kind],
        )}
      >
        <Icon className="size-3.5" aria-hidden="true" />
      </span>
      <div className="flex min-w-0 flex-1 flex-col gap-1">
        <div className="flex items-start justify-between gap-2">
          <span className="font-semibold text-[13px] text-foreground">{event.title}</span>
          <span className="shrink-0 text-[11px] text-muted-foreground">{event.time}</span>
        </div>
        {event.meta ? (
          <div
            className={cn(
              'inline-flex w-fit items-center rounded px-2 py-1 font-medium text-[12px]',
              event.highlight === 'green' && 'bg-emerald-50 text-emerald-700',
              event.highlight === 'amber' && 'bg-amber-50 text-amber-700',
              !event.highlight && 'bg-muted text-foreground',
            )}
          >
            {event.meta}
          </div>
        ) : null}
        {event.body ? <p className="text-[12px] text-foreground/80">{event.body}</p> : null}
      </div>
    </li>
  );
}
```

- [ ] **Step 2: Pass consultationId from WorkingBdsGroupComponent → WorkingBdsRowExpanded**

In `working-bds-section.tsx`, the `ConsultationActivityCard`, `WorkingBdsGroupComponent`, and `WorkingBdsTable`/`WorkingBdsCard` chain already passes `onAction`. Need to ensure `consultationId` flows through to `WorkingBdsRowExpanded`.

Check `WorkingBdsGroupComponent` and `WorkingBdsTable` to see where `WorkingBdsRowExpanded` is rendered, and add `consultationId` prop to the chain.

Files to modify:
- `src/components/nhu-cau/working-bds/working-bds-group.tsx` — pass `consultationId` through
- `src/components/nhu-cau/working-bds/working-bds-table.tsx` — pass `consultationId` to `WorkingBdsRowExpanded`

In `working-bds-table.tsx`, change `WorkingBdsRowExpanded` usage:
```diff
- <WorkingBdsRowExpanded item={item} onAction={onAction} />
+ <WorkingBdsRowExpanded item={item} consultationId={consultationId} onAction={onAction} />
```

And add `consultationId` to `WorkingBdsTableProps` and both `DesktopRow`/`MobileRow` props.

Similarly update `working-bds-group.tsx` to thread `consultationId` through to the table/card components.

- [ ] **Step 3: Commit**

```bash
git add src/components/nhu-cau/working-bds/working-bds-row-expanded.tsx src/components/nhu-cau/working-bds/working-bds-table.tsx src/components/nhu-cau/working-bds/working-bds-section.tsx
git commit -m "feat: wire real activities timeline into working BDS expanded row"
```

---

### Task 5: Wire CreateAppointmentDialog to Real API

**Files:**
- Modify: `src/components/appointments/create-appointment-dialog.tsx`

- [ ] **Step 1: Replace mock with useCreateWork mutation**

In `create-appointment-dialog.tsx`, the `handleSubmit` currently uses `setTimeout` mock. Replace with `useCreateWork` hook calling `create_work_consultation` with `template_id: 4`.

Key changes in the file:
1. Import `useCreateWork` from `@/hooks/use-consultation-activities`
2. Replace local `submitting` state with mutation's `isPending`
3. In `handleSubmit`, call `mutateAsync` with `{ template_id: 4, real_estate_id, customer_id, started_at, location, note, assigned_to }`
4. Add `consultationId` prop to pass to the payload

```diff
// Add imports
+ import { useCreateWork } from '@/hooks/use-consultation-activities';

// Add consultationId to props
export interface CreateAppointmentDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
+ consultationId?: string | number;
  customer: { ... };
  bds?: { ... };
  ...
}

// Inside the component, replace useState + mock with mutation
- const [submitting, setSubmitting] = useState(false);
+ const { mutateAsync: createWork, isPending } = useCreateWork();

// Replace handleSubmit body
async function handleSubmit() {
  if (!datetime) {
    toast.info('Chọn thời gian hẹn');
    return;
  }
-   setSubmitting(true);
-   try {
-     await new Promise((r) => setTimeout(r, 300));
-     toast.success('Đã tạo lịch hẹn');
-     onCreated?.();
-     onOpenChange(false);
-   } finally {
-     setSubmitting(false);
-   }
+   try {
+     await createWork({
+       template_id: 4,
+       real_estate_id: bds?.id,
+       customer_id: customer.id,
+       ...(consultationId ? { consultation_id: consultationId } : {}),
+       started_at: datetime,
+       location: address || undefined,
+       note: note || undefined,
+     });
+     toast.success('Đã tạo lịch hẹn');
+     onCreated?.();
+     onOpenChange(false);
+   } catch {
+     // Error toast handled by hook
+   }
}

// Replace disabled prop
- disabled={submitting}
+ disabled={isPending}
- {submitting ? 'Đang tạo…' : 'Tạo lịch hẹn'}
+ {isPending ? 'Đang tạo…' : 'Tạo lịch hẹn'}
```

- [ ] **Step 2: Pass consultationId from WorkingBdsSection**

In `working-bds-section.tsx`, update the `CreateAppointmentDialog` usage to pass `consultationId`:

```diff
<CreateAppointmentDialog
  open={appointmentItem != null}
  onOpenChange={(o) => { if (!o) setAppointmentItem(null); }}
+ consultationId={consultationId}
  customer={{...}}
  bds={{...}}
/>
```

- [ ] **Step 3: Commit**

```bash
git add src/components/appointments/create-appointment-dialog.tsx src/components/nhu-cau/working-bds/working-bds-section.tsx
git commit -m "feat: wire create appointment dialog to create_work_consultation API"
```

---

### Task 6: Wire CreateDepositDialog to Real API

**Files:**
- Modify: `src/components/deposit/create-deposit-dialog.tsx`

- [ ] **Step 1: Replace mock with useCreateWork mutation**

Same pattern as Task 5, but `template_id: 29` and include `deposit_type` + `deposit_amount`.

```diff
// Add imports
+ import { useCreateWork } from '@/hooks/use-consultation-activities';

// Add consultationId + depositType to props
export interface CreateDepositDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
+ consultationId?: string | number;
+ depositType?: 'thien_chi' | 'coc_chet';
  customer: { ... };
  bds: { ... };
  onCreated?: () => void;
}

// Replace local submitting state
- const [submitting, setSubmitting] = useState(false);
+ const { mutateAsync: createWork, isPending } = useCreateWork();

// Replace handleSubmit
async function handleSubmit() {
  if (!amount || amount <= 0) {
    toast.info('Nhập số tiền cọc');
    return;
  }
-   setSubmitting(true);
-   try {
-     await new Promise((r) => setTimeout(r, 400));
-     ...
-   } finally {
-     setSubmitting(false);
-   }
+   try {
+     await createWork({
+       template_id: 29,
+       real_estate_id: bds.id,
+       customer_id: customer.id,
+       ...(consultationId ? { consultation_id: consultationId } : {}),
+       deposit_type: depositType ?? 'thien_chi',
+       deposit_amount: amount,
+       note: notes || undefined,
+     });
+     toast.success('Đã tạo đặt cọc');
+     onCreated?.();
+     onOpenChange(false);
+   } catch {
+     // Error toast handled by hook
+   }
}
```

Note: The QR stage is removed for now — it depends on a separate payment flow. The dialog will close on success instead of showing mock QR. The QR feature can be re-added when BE provides the payment endpoint.

Remove the `DepositResult` state and `DepositQrView` rendering — the dialog now closes immediately on success.

- [ ] **Step 2: Pass consultationId from WorkingBdsSection**

In `working-bds-section.tsx`, update `CreateDepositDialog` usage:

```diff
{depositItem ? (
  <CreateDepositDialog
    open={depositItem != null}
    onOpenChange={(o) => { if (!o) setDepositItem(null); }}
+   consultationId={consultationId}
    customer={{...}}
    bds={{...}}
  />
) : null}
```

- [ ] **Step 3: Commit**

```bash
git add src/components/deposit/create-deposit-dialog.tsx src/components/nhu-cau/working-bds/working-bds-section.tsx
git commit -m "feat: wire create deposit dialog to create_work_consultation API"
```

---

### Task 7: Enhance AddNoteDialog for BDS-Specific Notes

**Files:**
- Modify: `src/components/nhu-cau/add-note-dialog/index.tsx`

The current `AddNoteDialog` uses `useCreateComment` (generic `salesman_comments`). For BDS-specific notes within consultation context, it should optionally call `create_note_consultation` when `noteType` prop is provided.

- [ ] **Step 1: Add noteType + relatedId props, conditionally use create_note_consultation**

```diff
+ import { useCreateNote } from '@/hooks/use-consultation-activities';
+ import type { NoteType } from '@/types/consultation-activity';

interface AddNoteDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  consultationId: string | number;
  tablename?: string;
  entityLabel?: string;
+ /** When set, uses create_note_consultation instead of generic comment */
+ noteType?: NoteType;
+ relatedId?: number | string;
  onSuccess?: () => void;
}
```

In both `DesktopVariant` and `MobileVariant`, add conditional logic:

```typescript
const { mutate: createNoteMut, isPending: notePending } = useCreateNote();
const { mutate: createCommentMut, isPending: commentPending } = useCreateComment();
const isPending = noteType ? notePending : commentPending;

function handleSubmit() {
  if (!content.trim()) return;
  if (noteType) {
    createNoteMut(
      {
        note_type: noteType,
        related_id: relatedId ?? null,
        content: content.trim(),
        visibility: 'internal',
      },
      { onSuccess: () => { onSuccess?.(); onOpenChange(false); } },
    );
  } else {
    createCommentMut(
      {
        table_id: consultationId,
        tablename,
        content: content.trim(),
        comment_type: 'note',
        visibility: 'private',
      },
      { onSuccess: () => { onSuccess?.(); onOpenChange(false); } },
    );
  }
}
```

- [ ] **Step 2: Pass noteType from WorkingBdsSection when opening note for a BDS**

In `working-bds-section.tsx`, the `AddNoteDialog` is opened by `create_work` action. When called from a BDS context, pass `noteType="real_estate"` and `relatedId`:

```diff
<AddNoteDialog
  open={noteOpen}
  onOpenChange={setNoteOpen}
  consultationId={consultationId}
+ noteType="real_estate"
+ relatedId={noteTargetBds?.bds.id}
/>
```

This requires tracking which BDS triggered the note dialog (similar to `appointmentItem` pattern):

```diff
+ const [noteTargetBds, setNoteTargetBds] = useState<WorkingBdsItem | null>(null);

// In handleAction, case 'create_work':
- setNoteOpen(true);
+ setNoteTargetBds(item);
+ setNoteOpen(true);
```

- [ ] **Step 3: Commit**

```bash
git add src/components/nhu-cau/add-note-dialog/index.tsx src/components/nhu-cau/working-bds/working-bds-section.tsx
git commit -m "feat: add BDS-specific note support via create_note_consultation"
```

---

### Task 8: Build Check & Integration Verification

**Files:** None new — verification only.

- [ ] **Step 1: Run TypeScript type check**

```bash
npx tsc --noEmit
```

Expected: No errors related to the new files.

- [ ] **Step 2: Run Biome lint**

```bash
npx @biomejs/biome check src/types/consultation-activity.ts src/lib/api/consultation-activities.ts src/hooks/use-consultation-activities.ts src/components/nhu-cau/working-bds/working-bds-row-expanded.tsx src/components/appointments/create-appointment-dialog.tsx src/components/deposit/create-deposit-dialog.tsx src/components/nhu-cau/add-note-dialog/index.tsx
```

Expected: No errors.

- [ ] **Step 3: Run dev server and verify**

```bash
npm run dev
```

Open a consultation detail page (`/nhu-cau/[id]`), expand a BDS row, verify:
- Timeline loads from API (or shows empty state if BE has no data)
- Loading spinner appears while fetching
- Create Appointment dialog submits to real API
- Create Deposit dialog submits to real API
- Add Note dialog uses `create_note_consultation` when opened from BDS context

- [ ] **Step 4: Final commit if any fixes needed**

```bash
git add -A
git commit -m "fix: integration fixes from build check"
```

---

## Self-Review

**1. Spec coverage:**
- `create_work_consultation` → Task 5 (appointment), Task 6 (deposit) ✓
- `create_note_consultation` → Task 7 ✓
- `get_activities_consultation` → Task 4 ✓
- `get_list_appointments_consultation` → API function exists in Task 2, no dedicated UI needed ✓
- `update_work_status_consultation` → API + hook in Tasks 2-3, UI deferred (no current design) ✓
- `add_work_comment_consultation` → API + hook in Tasks 2-3, UI deferred (no current design) ✓

**2. Placeholder scan:** No TBD/TODO found. All steps contain actual code.

**3. Type consistency:**
- `CreateWorkPayload.template_id` = `z.number()` — matches `4`/`29` used in Tasks 5-6
- `GetActivitiesParams.tab_id` = `Number(bdsId)` — matches usage in Task 4
- `ActivityWork.work_type` → `WorkTypeSchema` → maps to `TimelineEventKind` in Task 4
- `NoteType` enum matches `'real_estate'` used in Task 7

**Deferred items** (status update UI + work comment UI):
These have API + hooks ready but no UI design yet. Adding UI for these is a separate task that requires design decisions (where in the timeline, what buttons, etc.).

---

<a id="docs-superpowers-plans-2026-05-21-find-bds-filter-panel-md"></a>

## docs/superpowers/plans/2026-05-21-find-bds-filter-panel.md

# Find BDS Filter Panel Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign FindBdsDialog with editable filter panel — pre-populate from consultation data, allow user to update filters before searching.

**Architecture:** Hook-based decomposition. `useFindBdsFilter` manages draft/applied filter state. `FilterBar` shows chips, `FilterPanel` is a slide-down form. API layer extended to pass `search_filter` JSON to BE.

**Tech Stack:** React hooks, TanStack Query v5, shadcn/ui (Input, Button, Popover), Base UI Combobox, Zod, Vitest

**Spec:** `docs/superpowers/specs/2026-05-21-find-bds-filter-panel-design.md`

---

## File Map

| Action | File | Responsibility |
|--------|------|----------------|
| Create | `src/components/nhu-cau/working-bds/find-bds-dialog/use-find-bds-filter.ts` | Filter state hook (draft/applied/init from consultation) |
| Create | `src/components/nhu-cau/working-bds/find-bds-dialog/filter-bar.tsx` | Chips display + "Bộ lọc" toggle button |
| Create | `src/components/nhu-cau/working-bds/find-bds-dialog/filter-panel.tsx` | Slide-down form with 5 filter fields |
| Modify | `src/lib/api/consultation.ts:242-264` | Add `searchFilter` param to `fetchMatchingProperties` |
| Modify | `src/hooks/use-consultations.ts:118-146` | Add `searchFilter` to `useInfiniteMatchingProperties` |
| Modify | `src/components/nhu-cau/working-bds/find-bds-dialog/index.tsx` | Replace CriteriaSummary with FilterBar + FilterPanel + hook wiring |
| Delete | `src/components/nhu-cau/working-bds/find-bds-dialog/criteria-summary.tsx` | Replaced by FilterBar |

---

### Task 1: API layer — add `searchFilter` to `fetchMatchingProperties`

**Files:**
- Modify: `src/lib/api/consultation.ts:242-264`

- [ ] **Step 1: Update `MatchingPropertiesQuery` interface and `fetchMatchingProperties` function**

```typescript
// src/lib/api/consultation.ts — replace lines 242-264

/* ───────── Matching Properties (BDS phù hợp) ───────── */
export interface MatchingPropertiesQuery {
  page?: number;
  limit?: number;
  searchFilter?: Record<string, unknown>;
}

export async function fetchMatchingProperties(
  consultationId: string | number,
  query: MatchingPropertiesQuery = {},
): Promise<MatchingPropertiesResponse> {
  const params: Record<string, string> = {
    id: String(consultationId),
    page: String(query.page ?? 1),
    limit: String(query.limit ?? 20),
  };
  if (query.searchFilter && Object.keys(query.searchFilter).length > 0) {
    params.search_filter = JSON.stringify(query.searchFilter);
  }
  const raw = await httpClient<unknown>('/api_agent/get_matching_properties.json', {
    method: 'GET',
    params,
  });
  const source = unwrapData(raw);
  const parsed = MatchingPropertiesResponseSchema.safeParse(source);
  return parsed.success
    ? parsed.data
    : { agent_properties: [], total_kho: null, pagination: null, caps: null };
}
```

- [ ] **Step 2: Verify TypeScript compiles**

Run: `npx tsc --noEmit --pretty 2>&1 | head -30`
Expected: No errors related to `consultation.ts`

- [ ] **Step 3: Commit**

```bash
git add src/lib/api/consultation.ts
git commit -m "feat(find-bds): add searchFilter param to fetchMatchingProperties"
```

---

### Task 2: Hook layer — add `searchFilter` to `useInfiniteMatchingProperties`

**Files:**
- Modify: `src/hooks/use-consultations.ts:118-146`

- [ ] **Step 1: Update `useInfiniteMatchingProperties` to accept and pass `searchFilter`**

```typescript
// src/hooks/use-consultations.ts — replace lines 118-146

export function useInfiniteMatchingProperties(
  consultationId: string | number | undefined,
  limit = 20,
  enabled = true,
  searchFilter?: Record<string, unknown>,
) {
  const filterKey = searchFilter ? JSON.stringify(searchFilter) : '';
  return useInfiniteQuery<MatchingPropertiesResponse>({
    queryKey: [
      'consultations',
      'matching-properties-infinite',
      String(consultationId ?? ''),
      limit,
      filterKey,
    ] as const,
    queryFn: ({ pageParam }) =>
      fetchMatchingProperties(consultationId as string | number, {
        page: pageParam as number,
        limit,
        searchFilter,
      }),
    initialPageParam: 1,
    getNextPageParam: (lastPage, allPages) => {
      const cap = Number(lastPage.caps?.max_props_total ?? 40) || 40;
      const returned = Number(lastPage.pagination?.returned_properties_total ?? 0);
      if (!returned || returned < cap) return undefined;
      const nextPage = Number(lastPage.pagination?.page ?? allPages.length) + 1;
      return nextPage;
    },
    enabled: enabled && consultationId != null && consultationId !== '',
    staleTime: 60_000,
  });
}
```

- [ ] **Step 2: Verify TypeScript compiles**

Run: `npx tsc --noEmit --pretty 2>&1 | head -30`
Expected: No errors related to `use-consultations.ts`

- [ ] **Step 3: Commit**

```bash
git add src/hooks/use-consultations.ts
git commit -m "feat(find-bds): pass searchFilter through useInfiniteMatchingProperties"
```

---

### Task 3: Create `use-find-bds-filter.ts` hook

**Files:**
- Create: `src/components/nhu-cau/working-bds/find-bds-dialog/use-find-bds-filter.ts`

- [ ] **Step 1: Write the hook file**

```typescript
// src/components/nhu-cau/working-bds/find-bds-dialog/use-find-bds-filter.ts

import { useCallback, useMemo, useRef, useState } from 'react';
import type { DemandDetail } from '@/types/consultation';

export interface FindBdsFilter {
  property_type: number[];
  price_min: number | null;
  price_max: number | null;
  area_min: number | null;
  area_max: number | null;
  house_direction: string[];
  city_id: string[];
  district_id: string[];
}

function num(v: unknown): number | null {
  if (v == null || v === '') return null;
  const n = Number(v);
  return Number.isFinite(n) && n > 0 ? n : null;
}

function toStringArray(v: unknown): string[] {
  if (Array.isArray(v)) return v.map(String).filter(Boolean);
  if (v != null && v !== '') return [String(v)];
  return [];
}

function toNumberArray(v: unknown): number[] {
  if (Array.isArray(v)) {
    return v
      .map((item) => {
        if (typeof item === 'object' && item !== null) {
          return num((item as { id?: unknown }).id ?? (item as { value?: unknown }).value);
        }
        return num(item);
      })
      .filter((n): n is number => n !== null);
  }
  const n = num(v);
  return n !== null ? [n] : [];
}

export function toInitialFilter(consultation: DemandDetail): FindBdsFilter {
  const raw = consultation as Record<string, unknown>;
  const pr = raw.property_requirements as
    | { budget_range?: { min?: unknown; max?: unknown }; area_range?: { min?: unknown; max?: unknown } }
    | null
    | undefined;

  const prefs = raw.preferences as { preferred_directions?: unknown } | null | undefined;

  // Property type: from property_requirements.property_type or flat property_type
  const prPt = (pr as { property_type?: unknown } | null)?.property_type;
  const propertyType = prPt ? toNumberArray(prPt) : toNumberArray(raw.property_type);

  // Price range
  const priceMin =
    num((pr as { budget_range?: { min?: unknown } | null })?.budget_range?.min) ??
    num(raw.budget_min) ??
    num(raw.min_price);
  const priceMax =
    num((pr as { budget_range?: { max?: unknown } | null })?.budget_range?.max) ??
    num(raw.budget_max) ??
    num(raw.max_price);

  // Area range
  const areaMin =
    num((pr as { area_range?: { min?: unknown } | null })?.area_range?.min) ??
    num(raw.area_min) ??
    num(raw.min_area);
  const areaMax =
    num((pr as { area_range?: { max?: unknown } | null })?.area_range?.max) ??
    num(raw.area_max) ??
    num(raw.max_area);

  // House direction
  const directions = toStringArray(prefs?.preferred_directions);

  // Location IDs from location_preferences (SearchItem with boundaries) or flat fields
  const cityIds: string[] = [];
  const districtIds: string[] = [];

  const lp = raw.location_preferences;
  if (Array.isArray(lp)) {
    for (const item of lp as Array<{ boundaries?: Array<{ id?: unknown; type?: unknown }> }>) {
      const boundaries = item.boundaries ?? [];
      for (const b of boundaries) {
        const id = b.id != null ? String(b.id) : null;
        const type = (b as { type?: unknown }).type;
        if (!id) continue;
        const t = String(type ?? '').toLowerCase();
        if (t.includes('city') || t.includes('tinh') || t.includes('province')) cityIds.push(id);
        else if (t.includes('district') || t.includes('huyen') || t.includes('quan'))
          districtIds.push(id);
      }
    }
  }

  // Fallback to flat interested_cities / interested_districts
  if (cityIds.length === 0) {
    const ic = raw.interested_cities;
    if (Array.isArray(ic)) {
      for (const c of ic) {
        if (typeof c === 'object' && c !== null) {
          const id = String((c as { id?: unknown }).id ?? '');
          if (id) cityIds.push(id);
        }
      }
    }
  }
  if (districtIds.length === 0) {
    const id = raw.interested_districts;
    if (Array.isArray(id)) {
      for (const d of id) {
        if (typeof d === 'object' && d !== null) {
          const did = String((d as { id?: unknown }).id ?? '');
          if (did) districtIds.push(did);
        }
      }
    }
  }

  return {
    property_type: propertyType,
    price_min: priceMin,
    price_max: priceMax,
    area_min: areaMin,
    area_max: areaMax,
    house_direction: directions,
    city_id: cityIds,
    district_id: districtIds,
  };
}

export function useFindBdsFilter(consultation: DemandDetail) {
  const initialRef = useRef<FindBdsFilter | null>(null);
  if (initialRef.current === null) {
    initialRef.current = toInitialFilter(consultation);
  }
  const initial = initialRef.current;

  const [draftFilter, setDraftFilter] = useState<FindBdsFilter>(initial);
  const [appliedFilter, setAppliedFilter] = useState<FindBdsFilter>(initial);
  const [isPanelOpen, setIsPanelOpen] = useState(false);

  const updateDraft = useCallback(<K extends keyof FindBdsFilter>(key: K, value: FindBdsFilter[K]) => {
    setDraftFilter((prev) => {
      const next = { ...prev, [key]: value };
      // Cascade: reset district_id when city_id changes
      if (key === 'city_id') {
        next.district_id = [];
      }
      return next;
    });
  }, []);

  const applyFilter = useCallback(() => {
    setAppliedFilter(draftFilter);
    setIsPanelOpen(false);
  }, [draftFilter]);

  const resetDraft = useCallback(() => {
    setDraftFilter(initial);
  }, [initial]);

  const togglePanel = useCallback(() => {
    setIsPanelOpen((prev) => !prev);
  }, []);

  // Serialize appliedFilter for API (strip empty arrays/nulls)
  const searchFilter = useMemo<Record<string, unknown>>(() => {
    const result: Record<string, unknown> = {};
    if (appliedFilter.property_type.length > 0) {
      result.property_type =
        appliedFilter.property_type.length === 1
          ? appliedFilter.property_type[0]
          : appliedFilter.property_type;
    }
    if (appliedFilter.price_min != null) result.price_min = appliedFilter.price_min;
    if (appliedFilter.price_max != null) result.price_max = appliedFilter.price_max;
    if (appliedFilter.area_min != null) result.area_min = appliedFilter.area_min;
    if (appliedFilter.area_max != null) result.area_max = appliedFilter.area_max;
    if (appliedFilter.house_direction.length > 0) {
      result.house_direction =
        appliedFilter.house_direction.length === 1
          ? appliedFilter.house_direction[0]
          : appliedFilter.house_direction;
    }
    if (appliedFilter.city_id.length > 0) result.city_id = appliedFilter.city_id;
    if (appliedFilter.district_id.length > 0) result.district_id = appliedFilter.district_id;
    return result;
  }, [appliedFilter]);

  // Whether draft has changes compared to applied
  const hasDraftChanges = useMemo(() => {
    return JSON.stringify(draftFilter) !== JSON.stringify(appliedFilter);
  }, [draftFilter, appliedFilter]);

  return {
    draftFilter,
    appliedFilter,
    isPanelOpen,
    searchFilter,
    hasDraftChanges,
    updateDraft,
    applyFilter,
    resetDraft,
    togglePanel,
  };
}
```

- [ ] **Step 2: Verify TypeScript compiles**

Run: `npx tsc --noEmit --pretty 2>&1 | head -30`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add src/components/nhu-cau/working-bds/find-bds-dialog/use-find-bds-filter.ts
git commit -m "feat(find-bds): add useFindBdsFilter hook with draft/applied state"
```

---

### Task 4: Create `filter-bar.tsx`

**Files:**
- Create: `src/components/nhu-cau/working-bds/find-bds-dialog/filter-bar.tsx`

- [ ] **Step 1: Write the FilterBar component**

This replaces `CriteriaSummary`. Shows chips from applied filter + a "Bộ lọc" toggle button.

```tsx
// src/components/nhu-cau/working-bds/find-bds-dialog/filter-bar.tsx

'use client';

import { SlidersHorizontalIcon } from 'lucide-react';
import { Button } from '@/components/ui/button';
import type { FindBdsFilter } from './use-find-bds-filter';

function Chip({ label }: { label: string }) {
  return (
    <span className="inline-flex h-6 items-center rounded-full bg-muted px-2 text-[11px] font-medium text-muted-foreground">
      {label}
    </span>
  );
}

function formatPrice(val: number | null): string | null {
  if (val == null) return null;
  if (val >= 1_000_000_000) return `${(val / 1_000_000_000).toFixed(1).replace('.0', '')} tỷ`;
  if (val >= 1_000_000) return `${(val / 1_000_000).toFixed(0)} tr`;
  return val.toLocaleString('vi-VN');
}

interface FilterBarProps {
  appliedFilter: FindBdsFilter;
  isPanelOpen: boolean;
  onTogglePanel: () => void;
}

export function FilterBar({ appliedFilter, isPanelOpen, onTogglePanel }: FilterBarProps) {
  const chips: string[] = [];

  // Property type — show count if multiple
  if (appliedFilter.property_type.length > 0) {
    chips.push(appliedFilter.property_type.length === 1 ? '1 loại BDS' : `${appliedFilter.property_type.length} loại BDS`);
  }

  // Price range
  const minLabel = formatPrice(appliedFilter.price_min);
  const maxLabel = formatPrice(appliedFilter.price_max);
  if (minLabel && maxLabel) chips.push(`${minLabel} – ${maxLabel}`);
  else if (minLabel) chips.push(`Từ ${minLabel}`);
  else if (maxLabel) chips.push(`Đến ${maxLabel}`);

  // Area range
  const aMin = appliedFilter.area_min;
  const aMax = appliedFilter.area_max;
  if (aMin != null && aMax != null) chips.push(`${aMin} – ${aMax}m²`);
  else if (aMin != null) chips.push(`Từ ${aMin}m²`);
  else if (aMax != null) chips.push(`Đến ${aMax}m²`);

  // Direction
  if (appliedFilter.house_direction.length > 0) {
    chips.push(`Hướng ${appliedFilter.house_direction.join(', ')}`);
  }

  // Location
  const locCount = appliedFilter.city_id.length + appliedFilter.district_id.length;
  if (locCount > 0) chips.push(`${locCount} khu vực`);

  return (
    <div className="flex items-center gap-2">
      <div className="flex flex-1 flex-wrap items-center gap-1.5">
        {chips.length > 0 ? (
          chips.map((c) => <Chip key={c} label={c} />)
        ) : (
          <span className="text-[12px] text-muted-foreground">
            Chưa có tiêu chí — bấm Bộ lọc để chọn
          </span>
        )}
      </div>
      <Button
        type="button"
        variant={isPanelOpen ? 'secondary' : 'outline'}
        size="sm"
        onClick={onTogglePanel}
        className="h-7 shrink-0 gap-1.5 px-2.5 text-[12px]"
      >
        <SlidersHorizontalIcon className="size-3.5" />
        Bộ lọc
      </Button>
    </div>
  );
}
```

- [ ] **Step 2: Verify TypeScript compiles**

Run: `npx tsc --noEmit --pretty 2>&1 | head -30`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add src/components/nhu-cau/working-bds/find-bds-dialog/filter-bar.tsx
git commit -m "feat(find-bds): add FilterBar component with chips and toggle"
```

---

### Task 5: Create `filter-panel.tsx`

**Files:**
- Create: `src/components/nhu-cau/working-bds/find-bds-dialog/filter-panel.tsx`

- [ ] **Step 1: Write the FilterPanel component**

Slide-down form with 5 filter fields. Uses existing `MultiSelectCombobox` and `Input` from shadcn/ui.

```tsx
// src/components/nhu-cau/working-bds/find-bds-dialog/filter-panel.tsx

'use client';

import { Loader2Icon } from 'lucide-react';
import { useCallback, useEffect, useState } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { MultiSelectCombobox } from '@/components/form/multi-select-combobox';
import { fetchProvinces, fetchLocations } from '@/lib/api/location';
import { FALLBACK_FILTER_CONFIG } from '@/types/filter-config';
import type { FindBdsFilter } from './use-find-bds-filter';

const HOUSE_DIRECTIONS = FALLBACK_FILTER_CONFIG.sections.find((s) => s.key === 'house_direction')
  ?.options?.map((o) => ({ value: String(o.value), label: o.label })) ?? [
  { value: 'Đông', label: 'Đông' },
  { value: 'Tây', label: 'Tây' },
  { value: 'Nam', label: 'Nam' },
  { value: 'Bắc', label: 'Bắc' },
  { value: 'Đông Bắc', label: 'Đông Bắc' },
  { value: 'Đông Nam', label: 'Đông Nam' },
  { value: 'Tây Bắc', label: 'Tây Bắc' },
  { value: 'Tây Nam', label: 'Tây Nam' },
];

const PROPERTY_TYPES = FALLBACK_FILTER_CONFIG.sections.find((s) => s.key === 'property_types')
  ?.options?.map((o) => ({ value: String(o.value), label: o.label })) ?? [
  { value: 'chung-cu', label: 'Căn hộ chung cư' },
  { value: 'nha-pho', label: 'Nhà phố' },
  { value: 'biet-thu', label: 'Biệt thự' },
  { value: 'dat-nen', label: 'Đất nền' },
  { value: 'van-phong', label: 'Văn phòng' },
];

interface FilterPanelProps {
  draft: FindBdsFilter;
  isFetching: boolean;
  onUpdate: <K extends keyof FindBdsFilter>(key: K, value: FindBdsFilter[K]) => void;
  onApply: () => void;
  onReset: () => void;
}

export function FilterPanel({ draft, isFetching, onUpdate, onApply, onReset }: FilterPanelProps) {
  const [cities, setCities] = useState<{ value: string; label: string }[]>([]);
  const [districts, setDistricts] = useState<{ value: string; label: string }[]>([]);

  useEffect(() => {
    fetchProvinces({ grant: 3 })
      .then((provinces) =>
        setCities(provinces.map((p) => ({ value: String(p.id), label: p.name }))),
      )
      .catch(() => setCities([]));
  }, []);

  const loadDistricts = useCallback(async (cityIds: string[]) => {
    if (cityIds.length === 0) {
      setDistricts([]);
      return;
    }
    try {
      const allDistricts: { value: string; label: string }[] = [];
      for (const cityId of cityIds) {
        const items = await fetchLocations({ parentId: cityId, grant: 3 });
        for (const d of items) {
          allDistricts.push({ value: String(d.id), label: d.name });
        }
      }
      setDistricts(allDistricts);
    } catch {
      setDistricts([]);
    }
  }, []);

  // Load districts when city changes
  useEffect(() => {
    loadDistricts(draft.city_id);
  }, [draft.city_id, loadDistricts]);

  function handlePriceMinChange(val: string) {
    const n = val === '' ? null : Number(val);
    onUpdate('price_min', n != null && Number.isFinite(n) ? n : null);
  }

  function handlePriceMaxChange(val: string) {
    const n = val === '' ? null : Number(val);
    onUpdate('price_max', n != null && Number.isFinite(n) ? n : null);
  }

  function handleAreaMinChange(val: string) {
    const n = val === '' ? null : Number(val);
    onUpdate('area_min', n != null && Number.isFinite(n) ? n : null);
  }

  function handleAreaMaxChange(val: string) {
    const n = val === '' ? null : Number(val);
    onUpdate('area_max', n != null && Number.isFinite(n) ? n : null);
  }

  // Validation: price_min <= price_max, area_min <= area_max
  const priceValid =
    draft.price_min == null || draft.price_max == null || draft.price_min <= draft.price_max;
  const areaValid =
    draft.area_min == null || draft.area_max == null || draft.area_min <= draft.area_max;
  const canApply = priceValid && areaValid;

  return (
    <div className="space-y-3 border-t border-border px-1 pt-3">
      {/* Row 1: Property type + Direction */}
      <div className="grid grid-cols-2 gap-3">
        <div className="space-y-1">
          <Label className="text-[12px]">Loại BDS</Label>
          <MultiSelectCombobox
            values={draft.property_type.map(String)}
            onChange={(vals) =>
              onUpdate(
                'property_type',
                vals.map((v) => Number(v)).filter((n) => Number.isFinite(n)),
              )
            }
            options={PROPERTY_TYPES}
            placeholder="Chọn loại BDS"
            ariaLabel="Loại BDS"
          />
        </div>
        <div className="space-y-1">
          <Label className="text-[12px]">Hướng nhà</Label>
          <MultiSelectCombobox
            values={draft.house_direction}
            onChange={(vals) => onUpdate('house_direction', vals)}
            options={HOUSE_DIRECTIONS}
            placeholder="Chọn hướng"
            ariaLabel="Hướng nhà"
          />
        </div>
      </div>

      {/* Row 2: Location */}
      <div className="grid grid-cols-2 gap-3">
        <div className="space-y-1">
          <Label className="text-[12px]">Tỉnh/Thành phố</Label>
          <MultiSelectCombobox
            values={draft.city_id}
            onChange={(vals) => onUpdate('city_id', vals)}
            options={cities}
            placeholder="Chọn tỉnh/thành"
            ariaLabel="Tỉnh/Thành phố"
          />
        </div>
        <div className="space-y-1">
          <Label className="text-[12px]">Quận/Huyện</Label>
          <MultiSelectCombobox
            values={draft.district_id}
            onChange={(vals) => onUpdate('district_id', vals)}
            options={districts}
            placeholder={draft.city_id.length > 0 ? 'Chọn quận/huyện' : 'Chọn tỉnh trước'}
            disabled={draft.city_id.length === 0}
            ariaLabel="Quận/Huyện"
          />
        </div>
      </div>

      {/* Row 3: Price range */}
      <div className="space-y-1">
        <Label className="text-[12px]">
          Giá {priceValid ? '' : '(min phải ≤ max)'}
        </Label>
        <div className="grid grid-cols-2 gap-3">
          <Input
            type="number"
            placeholder="Từ (VNĐ)"
            value={draft.price_min ?? ''}
            onChange={(e) => handlePriceMinChange(e.target.value)}
            aria-label="Giá tối thiểu"
            className={!priceValid ? 'border-destructive' : ''}
          />
          <Input
            type="number"
            placeholder="Đến (VNĐ)"
            value={draft.price_max ?? ''}
            onChange={(e) => handlePriceMaxChange(e.target.value)}
            aria-label="Giá tối đa"
            className={!priceValid ? 'border-destructive' : ''}
          />
        </div>
      </div>

      {/* Row 4: Area range */}
      <div className="space-y-1">
        <Label className="text-[12px]">
          Diện tích (m²) {areaValid ? '' : '(min phải ≤ max)'}
        </Label>
        <div className="grid grid-cols-2 gap-3">
          <Input
            type="number"
            placeholder="Từ (m²)"
            value={draft.area_min ?? ''}
            onChange={(e) => handleAreaMinChange(e.target.value)}
            aria-label="Diện tích tối thiểu"
            className={!areaValid ? 'border-destructive' : ''}
          />
          <Input
            type="number"
            placeholder="Đến (m²)"
            value={draft.area_max ?? ''}
            onChange={(e) => handleAreaMaxChange(e.target.value)}
            aria-label="Diện tích tối đa"
            className={!areaValid ? 'border-destructive' : ''}
          />
        </div>
      </div>

      {/* Row 5: Actions */}
      <div className="flex justify-end gap-2 pt-1">
        <Button type="button" variant="outline" size="sm" onClick={onReset}>
          Đặt lại
        </Button>
        <Button type="button" size="sm" onClick={onApply} disabled={!canApply || isFetching}>
          {isFetching && <Loader2Icon className="mr-1.5 size-3.5 animate-spin" />}
          Áp dụng
        </Button>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Verify TypeScript compiles**

Run: `npx tsc --noEmit --pretty 2>&1 | head -30`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add src/components/nhu-cau/working-bds/find-bds-dialog/filter-panel.tsx
git commit -m "feat(find-bds): add FilterPanel slide-down form with 5 filter fields"
```

---

### Task 6: Wire everything in `index.tsx` — replace CriteriaSummary with hook + FilterBar + FilterPanel

**Files:**
- Modify: `src/components/nhu-cau/working-bds/find-bds-dialog/index.tsx`

- [ ] **Step 1: Rewrite `index.tsx` to use new hook and components**

```tsx
// src/components/nhu-cau/working-bds/find-bds-dialog/index.tsx

'use client';

import { useMemo, useState } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Sheet, SheetContent, SheetHeader, SheetTitle } from '@/components/ui/sheet';
import { useIsMobile } from '@/hooks/use-breakpoint';
import { useInfiniteMatchingProperties } from '@/hooks/use-consultations';
import { useDebounced } from '@/hooks/use-debounced';
import { useAddBdsToWorking } from '@/hooks/use-working-bds';
import { flattenMatchingProperties } from '@/lib/nhu-cau/flatten-matching';
import type { DemandDetail } from '@/types/consultation';
import { FilterBar } from './filter-bar';
import { FilterPanel } from './filter-panel';
import { ResultGrid } from './result-grid';
import { SearchBar } from './search-bar';
import { SelectedBar } from './selected-bar';
import { useFindBdsFilter } from './use-find-bds-filter';

interface FindBdsDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  consultationId: string | number;
  consultation: DemandDetail;
}

function DialogBody({
  consultationId,
  consultation,
  onClose,
}: {
  consultationId: string | number;
  consultation: DemandDetail;
  onClose: () => void;
}) {
  const [selected, setSelected] = useState<number[]>([]);
  const [search, setSearch] = useState('');
  const debouncedSearch = useDebounced(search, 200);
  const addMutation = useAddBdsToWorking();

  const { draftFilter, isPanelOpen, searchFilter, updateDraft, applyFilter, resetDraft, togglePanel } =
    useFindBdsFilter(consultation);

  const { data, isLoading, isError, hasNextPage, isFetchingNextPage, fetchNextPage, isFetching } =
    useInfiniteMatchingProperties(consultationId, 20, true, searchFilter);

  const flattened = useMemo(() => flattenMatchingProperties(data?.pages), [data?.pages]);

  function toggle(id: number) {
    setSelected((prev) => (prev.includes(id) ? prev.filter((x) => x !== id) : [...prev, id]));
  }

  function handleConfirm() {
    const matched = flattened.filter((entry) => selected.includes(Number(entry.bds.id)));
    if (matched.length === 0) return;

    const items = matched.map((entry) => ({
      realEstateId: entry.bds.id,
      salesmanId:
        (entry.bds as { agent_id_seller?: number | string | null }).agent_id_seller ??
        entry.salesmanId,
    }));

    const buyerId = (consultation as { customer_id?: number | string | null }).customer_id ?? null;

    addMutation.mutate(
      { consultationId, items, buyerId },
      {
        onSuccess: (data) => {
          if (data.added > 0) {
            setSelected([]);
            onClose();
          }
        },
      },
    );
  }

  return (
    <>
      {/* Sticky header block */}
      <div className="sticky top-0 z-10 flex flex-col gap-2 bg-background pb-2">
        <FilterBar
          appliedFilter={draftFilter}
          isPanelOpen={isPanelOpen}
          onTogglePanel={togglePanel}
        />
        {isPanelOpen && (
          <FilterPanel
            draft={draftFilter}
            isFetching={isFetching}
            onUpdate={updateDraft}
            onApply={applyFilter}
            onReset={resetDraft}
          />
        )}
        <SearchBar value={search} onChange={setSearch} />
      </div>

      {/* Scrollable list */}
      <div className="flex-1 overflow-y-auto pb-2">
        <ResultGrid
          items={flattened}
          isLoading={isLoading}
          isError={isError}
          search={debouncedSearch}
          selected={selected}
          onToggle={toggle}
          hasNextPage={hasNextPage}
          isFetchingNextPage={isFetchingNextPage}
          onLoadMore={() => fetchNextPage()}
        />
      </div>

      {/* Sticky footer */}
      <SelectedBar
        count={selected.length}
        isPending={addMutation.isPending}
        onCancel={() => {
          setSelected([]);
          onClose();
        }}
        onConfirm={handleConfirm}
      />
    </>
  );
}

export function FindBdsDialog({
  open,
  onOpenChange,
  consultationId,
  consultation,
}: FindBdsDialogProps) {
  const isMobile = useIsMobile();
  const close = () => onOpenChange(false);

  if (isMobile) {
    return (
      <Sheet open={open} onOpenChange={onOpenChange}>
        <SheetContent side="bottom" className="flex h-[92dvh] flex-col gap-0 p-0" showCloseButton>
          <SheetHeader className="shrink-0 border-b border-border px-4 pb-3 pt-4">
            <SheetTitle>Tìm BDS</SheetTitle>
          </SheetHeader>
          <div className="flex flex-1 flex-col overflow-hidden px-4 pt-3">
            <DialogBody
              consultationId={consultationId}
              consultation={consultation}
              onClose={close}
            />
          </div>
        </SheetContent>
      </Sheet>
    );
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent
        className="flex max-w-3xl flex-col gap-0 p-0 lg:max-w-4xl xl:max-w-5xl"
        showCloseButton
      >
        <DialogHeader className="shrink-0 border-b border-border px-6 pb-3 pt-5">
          <DialogTitle>Tìm BDS</DialogTitle>
        </DialogHeader>
        <div className="flex h-[70vh] flex-col overflow-hidden px-6 pt-3">
          <DialogBody consultationId={consultationId} consultation={consultation} onClose={close} />
        </div>
      </DialogContent>
    </Dialog>
  );
}
```

- [ ] **Step 2: Delete `criteria-summary.tsx`**

```bash
rm src/components/nhu-cau/working-bds/find-bds-dialog/criteria-summary.tsx
```

- [ ] **Step 3: Check no other file imports `CriteriaSummary`**

Run: `grep -rn "criteria-summary\|CriteriaSummary" src/`
Expected: No results (all references removed)

- [ ] **Step 4: Verify TypeScript compiles**

Run: `npx tsc --noEmit --pretty 2>&1 | head -30`
Expected: No errors

- [ ] **Step 5: Commit**

```bash
git add src/components/nhu-cau/working-bds/find-bds-dialog/index.tsx
git rm src/components/nhu-cau/working-bds/find-bds-dialog/criteria-summary.tsx
git commit -m "feat(find-bds): wire filter hook + panel into FindBdsDialog, remove CriteriaSummary"
```

---

### Task 7: Manual smoke test

**Files:** None (testing only)

- [ ] **Step 1: Start dev server**

Run: `npm run dev`

- [ ] **Step 2: Open `http://localhost:3000/nhu-cau/2722` in browser**

- [ ] **Step 3: Open "Tìm BDS" dialog — verify:**
  - FilterBar shows chips pre-populated from consultation data
  - "Bộ lọc" button visible on the right
  - SearchBar still works for text filtering

- [ ] **Step 4: Click "Bộ lọc" — verify:**
  - FilterPanel slides down
  - Fields pre-populated with consultation values
  - City selector loads provinces
  - District selector loads districts when city selected

- [ ] **Step 5: Edit a filter (e.g. change price range) — verify:**
  - Draft updates immediately
  - Results NOT yet refreshed (only draft changed)
  - "Đặt lại" button resets to initial values
  - "Áp dụng" button enabled

- [ ] **Step 6: Click "Áp dụng" — verify:**
  - Panel closes
  - API called with `search_filter` param
  - Results refresh
  - Chips update to reflect new filter

- [ ] **Step 7: Test validation — verify:**
  - Set price_min > price_max → "Áp dụng" button disabled
  - Input border turns red

- [ ] **Step 8: Test on mobile viewport — verify:**
  - Sheet opens from bottom
  - FilterPanel works in mobile layout
  - MultiSelectCombobox usable on touch

---

### Task 8: Unit tests for `useFindBdsFilter` hook

**Files:**
- Create: `src/components/nhu-cau/working-bds/find-bds-dialog/__tests__/use-find-bds-filter.test.ts`

- [ ] **Step 1: Write unit tests**

```typescript
// src/components/nhu-cau/working-bds/find-bds-dialog/__tests__/use-find-bds-filter.test.ts

import { renderHook, act } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { toInitialFilter, useFindBdsFilter } from '../use-find-bds-filter';
import type { DemandDetail } from '@/types/consultation';

const mockConsultation = {
  property_requirements: {
    budget_range: { min: 2_000_000_000, max: 5_000_000_000 },
    area_range: { min: 80, max: 150 },
    property_type: [{ id: 15, title: 'Căn hộ chung cư' }],
  },
  preferences: {
    preferred_directions: ['Nam', 'Đông Nam'],
  },
  location_preferences: [
    {
      id: '123',
      name: 'Quận 1',
      boundaries: [
        { id: '456', name: 'TP. HCM', type: 'city' },
        { id: '123', name: 'Quận 1', type: 'district' },
      ],
    },
  ],
} as unknown as DemandDetail;

describe('toInitialFilter', () => {
  it('extracts property_type from property_requirements', () => {
    const filter = toInitialFilter(mockConsultation);
    expect(filter.property_type).toEqual([15]);
  });

  it('extracts budget range from property_requirements', () => {
    const filter = toInitialFilter(mockConsultation);
    expect(filter.price_min).toBe(2_000_000_000);
    expect(filter.price_max).toBe(5_000_000_000);
  });

  it('extracts area range from property_requirements', () => {
    const filter = toInitialFilter(mockConsultation);
    expect(filter.area_min).toBe(80);
    expect(filter.area_max).toBe(150);
  });

  it('extracts preferred directions', () => {
    const filter = toInitialFilter(mockConsultation);
    expect(filter.house_direction).toEqual(['Nam', 'Đông Nam']);
  });

  it('extracts city and district IDs from location_preferences', () => {
    const filter = toInitialFilter(mockConsultation);
    expect(filter.city_id).toContain('456');
    expect(filter.district_id).toContain('123');
  });

  it('returns empty arrays/nulls for empty consultation', () => {
    const filter = toInitialFilter({} as DemandDetail);
    expect(filter.property_type).toEqual([]);
    expect(filter.price_min).toBeNull();
    expect(filter.price_max).toBeNull();
    expect(filter.area_min).toBeNull();
    expect(filter.area_max).toBeNull();
    expect(filter.house_direction).toEqual([]);
    expect(filter.city_id).toEqual([]);
    expect(filter.district_id).toEqual([]);
  });
});

describe('useFindBdsFilter', () => {
  it('initializes draft and applied from consultation', () => {
    const { result } = renderHook(() => useFindBdsFilter(mockConsultation));
    expect(result.current.draftFilter.price_min).toBe(2_000_000_000);
    expect(result.current.appliedFilter.price_min).toBe(2_000_000_000);
  });

  it('togglePanel opens and closes', () => {
    const { result } = renderHook(() => useFindBdsFilter(mockConsultation));
    expect(result.current.isPanelOpen).toBe(false);
    act(() => result.current.togglePanel());
    expect(result.current.isPanelOpen).toBe(true);
    act(() => result.current.togglePanel());
    expect(result.current.isPanelOpen).toBe(false);
  });

  it('updateDraft changes draft but not applied', () => {
    const { result } = renderHook(() => useFindBdsFilter(mockConsultation));
    act(() => result.current.updateDraft('price_min', 3_000_000_000));
    expect(result.current.draftFilter.price_min).toBe(3_000_000_000);
    expect(result.current.appliedFilter.price_min).toBe(2_000_000_000);
  });

  it('applyFilter copies draft to applied and closes panel', () => {
    const { result } = renderHook(() => useFindBdsFilter(mockConsultation));
    act(() => result.current.togglePanel());
    act(() => result.current.updateDraft('price_min', 3_000_000_000));
    act(() => result.current.applyFilter());
    expect(result.current.appliedFilter.price_min).toBe(3_000_000_000);
    expect(result.current.isPanelOpen).toBe(false);
  });

  it('resetDraft reverts draft to initial', () => {
    const { result } = renderHook(() => useFindBdsFilter(mockConsultation));
    act(() => result.current.updateDraft('price_min', 9_000_000_000));
    act(() => result.current.resetDraft());
    expect(result.current.draftFilter.price_min).toBe(2_000_000_000);
  });

  it('searchFilter serializes non-empty values only', () => {
    const { result } = renderHook(() => useFindBdsFilter(mockConsultation));
    const sf = result.current.searchFilter;
    expect(sf.price_min).toBe(2_000_000_000);
    expect(sf.price_max).toBe(5_000_000_000);
    expect(sf.area_min).toBe(80);
    expect(sf.area_max).toBe(150);
    expect(sf).not.toHaveProperty('page');
  });

  it('changing city_id resets district_id', () => {
    const { result } = renderHook(() => useFindBdsFilter(mockConsultation));
    act(() => result.current.updateDraft('district_id', ['999']));
    expect(result.current.draftFilter.district_id).toEqual(['999']);
    act(() => result.current.updateDraft('city_id', ['789']));
    expect(result.current.draftFilter.district_id).toEqual([]);
    expect(result.current.draftFilter.city_id).toEqual(['789']);
  });
});
```

- [ ] **Step 2: Run tests**

Run: `npx vitest run src/components/nhu-cau/working-bds/find-bds-dialog/__tests__/use-find-bds-filter.test.ts`
Expected: All tests pass

- [ ] **Step 3: Commit**

```bash
git add src/components/nhu-cau/working-bds/find-bds-dialog/__tests__/
git commit -m "test(find-bds): add unit tests for useFindBdsFilter hook"
```

---

## Self-Review

**1. Spec coverage:**
- File structure (3 new files, 1 deleted, 2 modified) → Tasks 1-6
- Data flow (draft → applied → API) → Tasks 3, 6
- Filter panel UI (5 fields) → Task 5
- Error handling (validation, cascade reset) → Task 5 (canApply), Task 3 (cascade)
- Testing plan → Task 8
- Manual smoke test → Task 7

**2. Placeholder scan:** No TBD/TODO found. All code blocks contain complete implementation.

**3. Type consistency:**
- `FindBdsFilter` interface defined in Task 3, used consistently in Tasks 4, 5, 6, 8
- `updateDraft<K>(key, value)` generic matches `FindBdsFilter[K]` across all usages
- `searchFilter` returns `Record<string, unknown>` matching `MatchingPropertiesQuery.searchFilter` type
- `property_type` is `number[]` in `FindBdsFilter`, serialized as `number | number[]` in `searchFilter` — matches BE contract
- `house_direction` is `string[]` in `FindBdsFilter`, serialized as `string | string[]` — matches BE `house_direction` param

---

<a id="docs-superpowers-specs-2026-05-21-find-bds-filter-panel-design-md"></a>

## docs/superpowers/specs/2026-05-21-find-bds-filter-panel-design.md

# Design: Find BDS Filter Panel (Nhu cầu detail)

**Date**: 2026-05-21
**Status**: Approved
**Scope**: Redesign popup "Tìm BDS phù hợp" trong trang nhu cầu detail

## Context

Dialog `FindBdsDialog` hiện tại chỉ hiển thị chips đọc-only (`CriteriaSummary`) + text search.
User muốn chỉnh sửa bộ lọc (giá, diện tích, loại BDS, hướng nhà, khu vực) trực tiếp trong dialog
trước khi tìm kiếm, với giá trị mặc định pre-populate từ consultation data.

BE API `get_matching_properties.json` đã hỗ trợ param `search_filter` (JSON string) với đầy đủ
filter fields: `property_type`, `price_min/max`, `area_min/max`, `house_direction`, `city_id`,
`district_id`, `ward_id`, `keyword`, `sort`, `limit`.

## UX Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Filter layout | Chips + expand panel | Gọn, không chiếm space khi collapse |
| Apply mode | Manual (bấm "Áp dụng") | Tránh spam API, user control rõ ràng |
| Panel animation | Slide down | Đẩy kết quả xuống, user vẫn thấy context |
| Chip bar | Thay hoàn toàn CriteriaSummary | Giảm confusion giữa 2 thanh thông tin |

## Architecture: Hook-based (Approach A)

### File structure

```
components/nhu-cau/working-bds/find-bds-dialog/
├── index.tsx              ← FindBdsDialog (edit nhẹ)
├── filter-bar.tsx         ← MỚI: chips + nút "Bộ lọc"
├── filter-panel.tsx       ← MỚI: slide-down form 5 fields
├── use-find-bds-filter.ts ← MỚI: hook quản lý filter state
├── criteria-summary.tsx   ← XÓA
├── search-bar.tsx         ← giữ nguyên
├── result-grid.tsx        ← giữ nguyên
├── result-row.tsx         ← giữ nguyên
├── result-card.tsx        ← giữ nguyên
└── selected-bar.tsx       ← giữ nguyên
```

### Changes in API layer

- `lib/api/consultation.ts`: `fetchMatchingProperties` thêm param
  `searchFilter?: Record<string, unknown>`, serialize sang `search_filter` JSON string
- `hooks/use-consultations.ts`: `useInfiniteMatchingProperties` thêm `searchFilter` vào
  query key + queryFn

## Data Flow

```
consultation (input)
    │
    ▼
toInitialFilter(consultation) → initialFilter
    │
    ▼
State:
  - draftFilter    = initialFilter     ← Mutable form state
  - appliedFilter = initialFilter      ← Immutable, sent to BE
  - isPanelOpen   = false
    │
    ▼
User actions:
  - updateDraftField(key, value)  → mutate draftFilter
  - applyFilter()                → appliedFilter = draftFilter
  - resetFilter()                → draftFilter = initialFilter
  - togglePanel()                → isPanelOpen = !isPanelOpen
    │
    ▼
API: useInfiniteMatchingProperties(id, searchFilter=appliedFilter)
  → queryKey includes appliedFilter
  → fetchMatchingProperties(id, { page, limit, searchFilter })
  → BE: get_matching_properties.json?search_filter={JSON}
```

## Filter Panel UI

```tsx
<form className="space-y-4 p-4 border-t">
  {/* Row 1: Loại BDS + Hướng nhà */}
  <div className="grid grid-cols-2 gap-4">
    <PropertyTypeSelect value={draft.property_type} onChange={...} />
    <HouseDirectionSelect value={draft.house_direction} onChange={...} />
  </div>

  {/* Row 2: Khu vực */}
  <LocationSelect value={draft.city_id/district_id} onChange={...} />

  {/* Row 3: Giá (min-max) */}
  <PriceRangeInput min={draft.price_min} max={draft.price_max} onChange={...} />

  {/* Row 4: Diện tích (min-max) */}
  <AreaRangeInput min={draft.area_min} max={draft.area_max} onChange={...} />

  {/* Row 5: Actions */}
  <div className="flex justify-end gap-2">
    <Button variant="outline" onClick={onReset}>Đặt lại</Button>
    <Button onClick={onApply}>Áp dụng</Button>
  </div>
</form>
```

### Field specs

| Field | Type | Input | Options source |
|-------|------|-------|----------------|
| `property_type` | `number[]` | MultiSelect | `/api_agent/list_property_type.json` hoặc hardcode list V1 |
| `house_direction` | `string` | Select | `["Đông", "Tây", "Nam", "Bắc", "Đông Bắc", "Đông Nam", "Tây Bắc", "Tây Nam"]` |
| `city_id` | `number[]` | MultiSelect | `/api_agent/get_list_city.json` |
| `district_id` | `number[]` | MultiSelect (cascade) | `/api_agent/get_list_district.json?city_id={id}` — reset khi city thay đổi |
| `price_min/max` | `number` | Input số + format tiền | Text input với format "X tỷ Y triệu" |
| `area_min/max` | `number` | Input số m² | Text input |

### Initial filter mapping (consultation → filter)

```typescript
function toInitialFilter(consultation: DemandDetail): FindBdsFilter {
  const pr = consultation.property_requirements;
  const raw = consultation as Record<string, unknown>;
  return {
    property_type: extractPropertyTypeIds(pr, raw),
    price_min: pr?.budget_range?.min ?? raw.budget_min ?? raw.min_price ?? null,
    price_max: pr?.budget_range?.max ?? raw.budget_max ?? raw.max_price ?? null,
    area_min: pr?.area_range?.min ?? raw.area_min ?? raw.min_area ?? null,
    area_max: pr?.area_range?.max ?? raw.area_max ?? raw.max_area ?? null,
    house_direction: extractHouseDirection(pr, raw),
    city_id: extractCityIds(consultation),
    district_id: extractDistrictIds(consultation),
  };
}
```

## Error Handling

| Scenario | Handling |
|----------|----------|
| API error (4xx/5xx) | `WorkingBdsEmpty variant="error"` in ResultGrid (unchanged) |
| Invalid search_filter JSON | BE returns error → catch in fetchMatchingProperties, throw for React Query |
| Empty filter applied | `search_filter={}` → BE falls back to consultation's own criteria |
| Network timeout | React Query default retry (3x) → skeleton/loader displayed |
| Draft filter invalid (price_min > price_max) | Client-side validation → disable "Áp dụng" button |

Loading state: panel stays open, spinner on "Áp dụng" button + skeleton in ResultGrid.

## Testing Plan

| Layer | Test | Priority |
|-------|------|----------|
| `use-find-bds-filter.ts` | `toInitialFilter()` extracts correctly from mock DemandDetail | High |
| `use-find-bds-filter.ts` | `applyFilter()` only updates applied state on explicit call | High |
| `fetchMatchingProperties` | Serializes search_filter to JSON string correctly | High |
| `useInfiniteMatchingProperties` | QueryKey changes when searchFilter changes → refetch | Medium |
| `filter-panel.tsx` | Form edits update draft, no API call until apply | Medium |
| `filter-bar.tsx` | Chips display correct applied filter values | Medium |
| E2E flow | Open dialog → edit filter → apply → results update | Low (manual first) |

## Scope Boundaries

**In scope:**
- 5 filter fields: property_type, price range, area range, house_direction, location
- Pre-populate from consultation data
- Manual apply with slide-down panel
- BE API integration via search_filter param

**Out of scope (future):**
- Additional filters (bedrooms, bathrooms, floors, projects)
- Save filter presets
- Sort options within filter panel

---

<a id="docs-system-architecture-md"></a>

## docs/system-architecture.md

---
title: System Architecture — tongkhobds_web_agent
type: architecture-doc
status: living
stack: nextjs-15
created: 2026-04-25
updated: 2026-04-25
---

# System Architecture — Web Agent (Next.js FE)

Tổng hợp kiến trúc thực tế của repo `tongkhobds_web_agent`. Source of truth = code; doc này phản ánh state hiện tại + decisions đã chốt.

> Cross-ref: [README](./README.md) · [01-brainstorm](./01-brainstorm.md) (decisions log) · [02-api-catalog](./02-api-catalog.md) · [03-be-questions](./03-be-questions.md) · [04-api-by-screen](./04-api-by-screen.md) · [CLAUDE.md](../CLAUDE.md)

---

## 1. Context Diagram

```
┌────────────┐   HTTPS    ┌───────────────────────────────┐   HTTPS    ┌───────────────┐
│  Browser   │ ─────────▶ │  Next.js 15 (App Router)      │ ─────────▶ │ Web2py V1 BE  │
│ (Agent UA) │ ◀───────── │  - Middleware (auth gate)     │ ◀───────── │ quanly.tongkho│
│            │            │  - Route Handler proxy /api/* │            │ bds.com/tongkho│
└────────────┘            │  - RSC + Client Components    │            └───────────────┘
                          │  - TanStack Query / Zustand   │
                          └──────────┬────────────────────┘
                                     │
                            ┌────────┴────────┐
                            │ Cookie store    │ httpOnly tkbds_token (Bearer)
                            │ localStorage    │ persisted query cache + UI state
                            └─────────────────┘
```

- **Single-origin deploy**: FE + proxy cùng domain → không CORS, không cookie cross-site.
- **BE V1 untouched**: Web2py giữ nguyên, FE reverse Dio calls từ Flutter `tongkhobds_agent`.
- **Map**: Google Maps JS API native (`@vis.gl/react-google-maps`) — đã refactor khỏi webview embed của brainstorm v1.

---

## 2. Tech Stack (locked)

| Layer | Choice | Notes |
|---|---|---|
| Framework | Next.js 15 App Router + Turbopack | RSC + Route Handler |
| Language | TypeScript strict | 0 `any` policy |
| UI | shadcn/ui + Radix + Tailwind v4 | + `@base-ui/react` cho primitives nâng cao |
| Server state | TanStack Query v5 | + `query-sync-storage-persister` cho cache hydrate |
| Client state | Zustand | filter, header visibility, chip labels, notification |
| URL state | nuqs | filter sync URL |
| Form | React Hook Form + Zod | validation chung qua `lib/validation/` |
| Table | TanStack Table v8 | bảng hàng, transactions, KYC |
| HTTP | ofetch + interceptor wrapper | `lib/api/http.ts` + `http-interceptor.ts` |
| Auth | Bearer token cookie (httpOnly) | TTL 24h, no refresh — re-login on 401 |
| Map | `@vis.gl/react-google-maps` + MarkerClusterer | client-side cluster, radius filter |
| Editor | Tiptap v3 | description rich text |
| Image | `browser-image-compression` + `react-dropzone` | client compress trước upload |
| Sanitize | DOMPurify | rich-text render |
| Icons | lucide-react | |
| Lint/Format | Biome | |
| Test | Vitest (unit) + Playwright (E2E, deferred) | 101+ unit tests pass |
| Deploy | Docker standalone + Coolify/Dokploy | |

---

## 3. Source Layout

```
src/
├── app/
│   ├── (auth)/                    # login, forgot-password — public
│   ├── (dashboard)/               # protected routes (middleware-gated)
│   │   ├── bds/        projects/  sale-projects (implied via /projects)
│   │   ├── giao-dich/  dat-coc/
│   │   ├── nhu-cau/    khach-hang/
│   │   ├── doi-nhom/   team/      rank/
│   │   ├── appointments/  contracts/
│   │   ├── map/        notifications/  profile/
│   │   ├── layout.tsx             # sidebar + topbar shell
│   │   └── page.tsx               # home
│   ├── api/
│   │   ├── [...path]/route.ts     # universal proxy → Web2py
│   │   └── health/                # liveness probe
│   ├── layout.tsx                 # Providers (Query, Theme, Toast)
│   ├── error.tsx / global-error.tsx / not-found.tsx
│   └── globals.css                # Tailwind v4 tokens
├── components/                    # feature + UI components
│   ├── ui/                        # shadcn primitives
│   ├── layout/                    # sidebar, topbar, user card
│   ├── bds/  project/  sale-project/
│   ├── nhu-cau/  customer/
│   ├── team-management/  sales/
│   ├── map/  kyc/  form/  features/  common/  debug/
├── hooks/                         # use-<resource> TanStack hooks + UI hooks
├── stores/                        # Zustand: filter-drawer, header-visibility, chips, notification
├── lib/
│   ├── api/                       # API clients per module (bds, consultation, project, …)
│   │   ├── http.ts + http-interceptor.ts
│   │   ├── response-envelope.ts   # defensive parse (success/data/data.data variants)
│   │   ├── upload/                # avatar, bds image/video/legal-doc, contract pdf, kyc
│   │   ├── team-management/       # tree, members, activity-log, normalize
│   │   └── commission/  constants/
│   ├── auth/                      # token-storage, login/logout server actions, capabilities
│   ├── providers/                 # QueryProvider + persister
│   ├── monitoring/                # proxy-logger
│   ├── validation/                # Zod schemas
│   ├── env.ts                     # serverEnv (BACKEND_URL) — typed
│   ├── be-media-url.ts            # rewrite BE asset host
│   ├── team-tree-layout.ts        # d3-hierarchy layout
│   └── utils.ts text/ map/ deposit/ nhu-cau/
├── types/                         # API DTO types per module
└── middleware.ts                  # auth gate
```

Convention strict: kebab-case filenames, PascalCase exports, files <200 LOC.

---

## 4. Routing & Layout

- **App Router groups**:
  - `(auth)` → public, `layout.tsx` minimal centered shell.
  - `(dashboard)` → protected, `layout.tsx` = sidebar + topbar + content slot.
- **Public list**: `/login`, `/forgot-password`.
- **Middleware** ([src/middleware.ts](../src/middleware.ts)): kiểm tra cookie `tkbds_token`; miss → redirect `/login?next=<path>`. Matcher loại `_next/*`, `/api/*`, static assets.
- **Build output**: 40+ routes, FLJS shared ~250KB.

---

## 5. Auth Architecture

```
Login form ─▶ Server Action (lib/auth/login-action.ts)
              │   POST /api/[...path] → /sign_in.json
              ▼
       cookies().set('tkbds_token', token, { httpOnly, secure, sameSite=lax })
              │
              ▼
       redirect(next ?? '/')
```

- **Token vector**: Bearer token in **httpOnly cookie** (server-readable only). Client JS không bao giờ chạm token.
- **Proxy injection**: route handler đọc cookie qua `getToken()` → set `Authorization: Bearer ${token}` lên upstream. Header `Cookie`/`Authorization` từ browser **bị strip** trước khi forward.
- **TTL**: 24h, **không có refresh** (BE limitation). 401 từ upstream → proxy `clearToken()` → client interceptor redirect `/login`.
- **Logout**: server action gọi `/logout` (xoá `equipment_token`/FCM upstream) + clear cookie local.
- **Multi-device**: BE allow concurrent sessions.
- **Role inference**: `lib/auth/infer-role.ts` derive từ `step` / `salesman_id` / `checking_staff` (BE không trả `permissions[]`). Capability gating qua `lib/auth/capabilities.ts` + `use-capabilities.ts`.

---

## 6. API Proxy ([src/app/api/[...path]/route.ts](../src/app/api/[...path]/route.ts))

| Concern | Implementation |
|---|---|
| Method coverage | `GET POST PUT PATCH DELETE` (single handler) |
| URL build | `${BACKEND_URL}/${path.join('/')}?<searchParams>` |
| Auth | inject `Authorization: Bearer <token>` từ cookie |
| Strip request | `cookie`, `authorization` (browser-side never trusted) |
| Strip response | `set-cookie`, `content-encoding`, `content-length` |
| Encoding | force `Accept-Encoding: identity` upstream — Cloudflare zstd/br phá Node undici |
| Body | buffer via `arrayBuffer()` cả 2 chiều — fix gzipped binary leak |
| Redirect | `manual` |
| Cache | `no-store` |
| Failure modes | 401 → `clearToken()`; ≥400 logged via `proxy-logger`; throw → 502 JSON |
| Slow-call telemetry | `logSlowProxyCall` (threshold trong monitoring module) |

Kết quả: client gọi `/api/<endpoint>.json` → no CORS, no token leak, no header smuggling.

---

## 7. Data Layer (Server State)

- **HTTP client**: `lib/api/http.ts` wrap ofetch với base `/api`, JSON parse, throw `ApiError` qua `http-interceptor.ts`.
- **Envelope parser** ([response-envelope.ts](../src/lib/api/response-envelope.ts)): defensive cho variants `data` | `data.data` | `data.url` | `data.urls` | `media_upload_id[s]`.
- **API modules** per domain trong `lib/api/`:
  - `auth.ts bds.ts project.ts sale-project.ts consultation.ts comments.ts tags.ts`
  - `favorite.ts interest.ts location.ts province-commission.ts type-search.ts`
  - `home-config.ts filter-config.ts property-type-fields.ts search-history.ts`
  - `profile-kyc.ts upload/* team-management/* commission/*`
  - `ai-generate-content.ts workflow.ts`
- **TanStack Query**:
  - Provider: `lib/providers/query-provider.tsx` + `query-persister.ts` (sync-storage cache hydrate).
  - Hook convention `hooks/use-<resource>.ts` (e.g., `use-bds-list`, `use-consultations`, `use-favorites`).
  - **Polling**: notification `refetchInterval: 30_000`.
  - **Infinite scroll**: `use-bds-infinite-list` + defensive page-boundary detection.
  - **Mutations**: optimistic toggle (favorites, tags), invalidate-on-settle.

---

## 8. Client State (Zustand)

| Store | Purpose |
|---|---|
| `bds-filter-drawer-store` | drawer open + draft filter state (BDS filter mobile) |
| `bds-header-visibility-store` | scroll-driven collapse filter chrome |
| `bds-chip-labels-store` | resolve labels async cho filter chips |
| `notification-store` | unread count + tab focus pause |

Persistence: `lib/api/use-persisted-state.ts` SSR-safe localStorage wrapper.

---

## 9. Forms

- React Hook Form + Zod resolvers.
- Schemas centralized in `lib/validation/`.
- Multi-step flows: `create_news` (BDS create wizard), `make_deposit`, contract upload, KYC.
- Upload pipeline: `react-dropzone` → `browser-image-compression` (5MB cap, BE limit) → multipart POST qua proxy → defensive envelope parse.

---

## 10. Map (post-MVP refactor)

- Native Google Maps JS via `@vis.gl/react-google-maps`.
- Endpoint `/real_estate_map.json` wrapper `{properties, total, page, limit, total_pages}`.
- Filter: `latlng=lat,lng` + `radius` (BE không support bbox).
- Cluster client-side via `@googlemaps/markerclusterer`, default `limit=50`.
- Brainstorm v1 webview embed → đã thay thế.

---

## 11. Notification

- Type code: `1=Giao dịch`, `2=Hệ thống` (BE answer).
- Polling 30s qua TanStack Query, tab inactive auto-pause.
- Unread count tự đếm FE (BE không có endpoint riêng).
- Badge ở topbar + list page chi tiết.

---

## 12. Cross-cutting

| Concern | Implementation |
|---|---|
| Theming | `next-themes` + Tailwind v4 tokens (`globals.css`) |
| Toast | `sonner` |
| Logging | `lib/monitoring/proxy-logger.ts` (failures + slow calls) |
| Error boundary | `app/error.tsx` + `global-error.tsx` |
| Health | `/api/health` |
| i18n | Vietnamese only (V1); copy hard-coded |
| Mobile-first | base compact `p-3` + stack vertical, scale via `sm:`/`lg:` (memory rule) |
| Display text | Title Case người/khách/địa chỉ ở render layer |

---

## 13. Build, Test, Deploy

- **Dev**: `pnpm dev` (Turbopack).
- **Build**: `pnpm build` standalone output.
- **Quality**: `pnpm typecheck && pnpm lint && pnpm test` — 101+ unit tests (37+ consultation).
- **Bundle**: 40+ routes, FLJS ~250KB shared. `pnpm build:analyze` (cross-env ANALYZE=1).
- **Deploy**: Docker → Coolify/Dokploy self-host. Env: `BACKEND_URL` server-only.
- **CI**: pre-commit lint + test. Playwright E2E suite **deferred**.

---

## 14. Security Boundaries

1. **Token never reaches client JS** — httpOnly cookie + server-side proxy injection.
2. **Browser headers stripped** — `cookie`, `authorization` không forward upstream (avoid smuggling).
3. **Upstream `set-cookie` dropped** — Web2py session cookies không leak về browser.
4. **Server actions only for auth state mutation** — login/logout không call BE từ client trực tiếp.
5. **Rich text** sanitized via DOMPurify trước render.
6. **Upload size capped** client-side (image compression) trước proxy.
7. **Env split**: `serverEnv` (BACKEND_URL) chỉ tồn tại server; client never imports.

---

## 15. Known Trade-offs & Constraints

| Item | Trade-off |
|---|---|
| No refresh token | UX gián đoạn 24h/lần — chấp nhận |
| BE response shape heterogenous | Defensive `response-envelope.ts` gánh; rủi ro silent miss khi BE thêm shape mới |
| No SSE/WS | Polling 30s — OK cho notification, không real-time |
| Client-side cluster | Khi BDS marker >5k cùng radius, perf drop — chưa hit |
| Solo dev, 36 màn, 4 tháng | Risk schedule (đã chấp nhận); MVP đã ship 2026-04-18 |
| Playwright deferred | Regression risk — manual UAT compensate |

---

## 16. Roadmap Anchors

- **MVP shipped**: 2026-04-18 (36 màn).
- **Post-MVP**: phase 08 `/doi-nhom`, phase 09 Nhu cầu/Consultation (9 endpoints), favorites multi-group, BDS filter 2-cấp/3-cấp, infinite scroll.
- **Phase 2 backlog**: tree viz, avatar crop, calendar, contract upload, autocomplete, reconciliation, demand match, edit wizards, Wallet/Loan/Events/Rose/Chat, QR scan, camera capture.

---

## Unresolved questions

- Khi BE thêm endpoint mới có shape envelope khác, có cơ chế contract test nào không? (hiện chỉ defensive parse)
- E2E Playwright suite resume khi nào — block release tiếp theo?
- Capability rules `lib/auth/capability-rules.ts` cần BE confirm matrix role → action chính thức (hiện inferred).

---

<a id="docs-user-guide-md"></a>

## docs/user-guide.md

---
title: User Guide — Webapp Agent (Tổng Kho BDS)
audience: end-user (Agent / NVKD BĐS)
language: vi
last_updated: 2026-04-28
related:
  - README.md
  - 02-api-catalog.md
  - screens/
status: matches MVP shipped 2026-04-18 + Post-MVP updates đến 2026-04-25
---

# Hướng dẫn sử dụng — Webapp Agent

Tài liệu hướng dẫn người dùng cuối (Agent / NVKD BĐS) sử dụng các tính năng đã triển khai trên Webapp Tổng Kho BDS. Mỗi mục mô tả: vị trí truy cập, mục đích, thao tác chính, mẹo sử dụng.

> **Quy ước**: tên menu/màn theo sidebar tiếng Việt. Ảnh tham chiếu wireframe: xem `docs/screens/`.

---

## 1. Đăng nhập & xác thực

### 1.1 Đăng nhập (`/login`)

- **Mục đích**: Truy cập hệ thống bằng tài khoản Agent V1 (tương thích app Flutter).
- **Thao tác**:
  1. Nhập **Số điện thoại** + **Mật khẩu**.
  2. Nhấn **Đăng nhập**.
  3. Hệ thống xác thực qua BE V1, lưu token (cookie httpOnly) và chuyển vào dashboard.
- **Lưu ý**:
  - Token có hiệu lực **24 giờ** → hết hạn sẽ tự logout, đăng nhập lại.
  - Cho phép đăng nhập song song nhiều thiết bị (web + app Flutter).
  - Quên mật khẩu: nhấn link **Quên mật khẩu** ở form đăng nhập (`/forgot-password`).

### 1.2 Quên mật khẩu (`/forgot-password`)

- Nhập số điện thoại đã đăng ký → BE gửi mã/khôi phục theo flow V1.

### 1.3 Đăng xuất

- Mở avatar dropdown (góc phải sidebar / topbar) → **Đăng xuất**.
- Hệ thống xoá token cục bộ + huỷ FCM device token. (BE V1 không revoke token phía server).

---

## 2. Bố cục chung & điều hướng

- **Sidebar trái**: gom theo nhóm **Nghiệp vụ / Giao dịch / Quản lý**.
- **Topbar**: breadcrumb (đường dẫn động), nút thông báo, avatar profile.
- **Mobile**: sidebar ẩn, mở qua icon menu; layout compact, các action chuyển xuống bottom sheet hoặc nút sticky.
- **Trang chủ (`/`)**: dashboard tổng quan (chào mừng + số liệu cá nhân nhanh — link tới các module).

---

## 3. Kho hàng thứ cấp (BDS)

Module quản lý BDS thứ cấp: nhà phố, đất nền, căn hộ, lô dự án thứ cấp.

### 3.1 Kho hàng tổng — danh sách BDS (`/bds`)

- **Tabs phân loại**: **Mua bán** (`/bds/mua-ban`) · **Cho thuê** (`/bds/cho-thue`).
- **Bộ lọc** (sidebar phải/trái + topbar):
  - **Loại BDS**: chọn nhiều (đa lựa chọn).
  - **Khoảng giá**, **Khoảng diện tích**: dropdown range hoặc nhập tay.
  - **Địa chỉ** (cascade):
    - Tỉnh/Thành (multi-select).
    - Quận/Huyện (multi-select, search keyword).
    - Phường/Xã (multi-select).
    - Hỗ trợ **2-cấp** (tỉnh → xã, hệ địa giới mới) hoặc **3-cấp** (tỉnh → huyện → xã).
    - Nút **Chọn chi tiết** mở dialog AddressPicker để chọn nhanh nhiều cấp.
  - **Tên đường, Dự án**: autocomplete khi đã chọn tỉnh.
  - **Tag**: chọn tag từ danh mục → lọc BDS theo tag.
- **Hiển thị**:
  - Card view + bảng view (toggle). Card hỗ trợ ảnh, giá format gọn (vd `2,5 tỷ`), tag chips.
  - **Active filter chips** ở đầu danh sách: bấm `×` từng chip để gỡ; **Xoá tất cả** để reset.
  - **Infinite scroll** (cuộn để tải thêm), mặc định trang đầu 20 mục.
  - **Header collapse**: cuộn xuống → bộ lọc thu gọn để xem nhiều BDS.
- **Thao tác trên card**:
  - Nhấn card → vào Chi tiết.
  - Nút **❤ Yêu thích** → mở dialog chọn nhóm yêu thích để thêm/xoá (multi-group).
  - Nút **Tag** → mở picker chọn/đổi tag cho BDS.

### 3.2 Chi tiết BDS (`/bds/[id]`)

- **Hero**: ảnh chính + slideshow ảnh phụ.
- **Thông tin chính**: tiêu đề, địa chỉ, giá, diện tích, hướng, pháp lý, mô tả.
- **Tags + chips trạng thái**.
- **Liên hệ chủ nhà / agent đăng tin**: nút gọi/copy SĐT (theo phân quyền).
- **Action**: thêm vào yêu thích, gắn tag, chia sẻ (copy link).

### 3.3 Tạo BDS mới (`/bds/new`) — Wizard 4 bước

1. **Bước 1 — Phân loại**: chọn `Mua bán` / `Cho thuê`, loại BDS (nhà / đất / căn hộ / shophouse...).
2. **Bước 2 — Địa chỉ**: nhập tỉnh → quận/huyện (3-cấp) hoặc bỏ qua quận khi 2-cấp → xã/phường → đường, dự án (autocomplete). Có toggle **2-cấp / 3-cấp**.
3. **Bước 3 — Thông tin BDS**: diện tích, giá, hướng, số phòng, pháp lý, mô tả, ảnh upload (≤ 5MB/ảnh).
4. **Bước 4 — Hoa hồng & xác nhận**: chọn loại hoa hồng (mua/bán/chia), % hoặc số tiền cố định. Validate trước khi lưu. Nhấn **Lưu** → BDS xuất hiện trong **Kho hàng cá nhân**.
- **Lưu ý**: Validate cứng theo bước. Có thể **Lưu nháp** (nếu BE hỗ trợ) hoặc **Quay lại** chỉnh bước trước.

### 3.4 Kho hàng cá nhân (`/bds/my`)

- Tab phân loại theo **trạng thái**: Đang đăng / Chờ duyệt / Bị từ chối / Đã ẩn / Đã bán.
- Mỗi tab hiển thị **count** cập nhật song song.
- Layout grid 5 cột (desktop) → stack mobile.
- Action mỗi card: xem chi tiết, ẩn/đăng lại (theo trạng thái), gắn tag.

### 3.5 Bạn quan tâm — Yêu thích (`/bds/favorites`)

- Hiển thị các **nhóm yêu thích** đã tạo (chip tab).
- Mỗi nhóm liệt kê BDS đã thêm. Bấm `×` trên BDS để gỡ; **Tạo nhóm mới** ở action toolbar.
- Cùng BDS có thể nằm trong **nhiều nhóm**.

---

## 4. Bản đồ BDS (`/map`)

- **Mục đích**: xem BDS trên bản đồ Google Maps gốc (native).
- **Thao tác**:
  - Pan/zoom bản đồ → tự động fetch BDS trong **bán kính** (radius) quanh tâm view.
  - Nhấn marker → popup tóm tắt + link sang chi tiết BDS.
  - **Bộ lọc rút gọn** ở topbar: loại BDS, khoảng giá. Default `limit=50` markers, không cluster.
- **Lưu ý**: Geofilter dùng `latlng + radius` (không bbox). Chỉ list BDS đã có toạ độ.

---

## 5. Kho hàng Sơ cấp (Dự án)

### 5.1 Kho dữ liệu dự án (`/projects`)

- Danh sách dự án sơ cấp (chủ đầu tư, vị trí, tên dự án).
- Bộ lọc: tỉnh/thành, loại dự án (chung cư, đất nền, biệt thự...), trạng thái mở bán.
- Card dự án hiển thị logo CDT, tên, khu vực, tổng số sản phẩm.

### 5.2 Chi tiết dự án (`/projects/[id]`)

- Thông tin tổng quan: vị trí, quy mô, CDT, tiến độ, mặt bằng phân khu.
- Tab **Bảng hàng** (`/projects/[id]/bang-hang`): danh sách sản phẩm sơ cấp của dự án (block / sản phẩm). *Một số action thao tác thực vẫn chờ BE — UI hiển thị disabled khi chưa khả dụng.*

### 5.3 Bảng hàng Tổng kho (`/projects/bang-hang`)

- Bảng tổng hợp **tất cả sản phẩm sơ cấp** xuyên dự án (chế độ duyệt nhanh).

---

## 6. Khách hàng (`/khach-hang`)

### 6.1 Danh sách khách

- Hiển thị KH viewer được giao (`self`) hoặc liên quan (`linked` — KH gắn nhu cầu / giao dịch / lịch hẹn của viewer).
- **Bộ lọc**: trạng thái, ngày tạo, người phụ trách, search theo tên / SĐT.
- **Phân trang** (Next/Prev). Tên hiển thị **Capitalize** từng từ.

### 6.2 Chi tiết khách hàng (`/khach-hang/[id]`)

- Thông tin: tên, SĐT, email, nguồn, ngày sinh, ghi chú.
- **Tabs liên quan**: Nhu cầu của KH · Giao dịch · Lịch hẹn · Đặt cọc · Watchlist (BDS quan tâm).
- Action: chỉnh sửa thông tin, gắn tag, thêm note.

---

## 7. Nhu cầu (Consultation) (`/nhu-cau`)

Module quản lý nhu cầu mua/thuê của khách. Thay thế module "Demand" V1.

### 7.1 Danh sách nhu cầu

- **Tabs trạng thái** (count badge song song): Mới / Đang xử lý / Hoàn thành / Đã đóng...
- **View**: Card (mobile-first) hoặc Bảng (desktop).
- **Bộ lọc** (bottom sheet trên mobile, sidebar trên desktop):
  - Văn phòng (`office`), nhân viên (`sales_off`), người tạo (`created_by`).
  - Thời gian (`start_date` / `end_date`).
  - Khu vực (city/district/ward).
  - **Tag** (multi-select), điều kiện AND/OR (`or_and`).
- **Active chips** ở đầu list — gỡ từng tiêu chí dễ dàng.

### 7.2 Tạo / sửa nhu cầu (`/nhu-cau/create`)

- Form RHF + Zod validation.
- **Bắt buộc**: chọn KH có sẵn **HOẶC** nhập `Tên + SĐT` mới.
- **Yêu cầu BDS** (nested):
  - Loại BDS, khoảng giá (`budget_range`), khoảng diện tích.
  - **Khu vực mong muốn** (multi-select location items).
  - Yêu cầu khác: số phòng, hướng, pháp lý.
- **Cài đặt thông báo**: bật push / SMS, giới hạn số gợi ý/ngày.
- Submit → trở về list, badge tabs cập nhật.

### 7.3 Chi tiết nhu cầu (`/nhu-cau/[id]`)

- **Customer card**: thông tin KH + nút gọi.
- **Property requirements card**: yêu cầu (giá, diện tích, loại) — format từ schema lồng.
- **Location chips**: vùng mong muốn.
- **Suggested BDS**: panel BDS phù hợp (BE auto-match) — bấm để xem chi tiết, đánh dấu liên hệ.
- **Tag picker** (dialog desktop / bottom sheet mobile): chọn tag từ nhóm có sẵn, gán nhanh; replace toàn bộ tag hoặc thêm thêm.
- **Note timeline**: lịch sử ghi chú; nút **Thêm ghi chú** mở dialog (chọn `note_type` + nội dung).
- **Actions**:
  - **Đóng nhu cầu** → set `status=completed`, lưu lý do (nếu có).
  - **Sửa** → mở lại form create với pre-fill.

### 7.4 Vai trò hiển thị (`inferRole`)

UI tự suy ra vai trò viewer (KH / CTV / TP / GĐK) dựa trên `checking_staff`, `salesman_type`, `auth_group` để hiển thị quyền tương ứng (ai được sửa, đóng nhu cầu).

---

## 8. Lịch hẹn (`/appointments`)

### 8.1 Danh sách

- Lịch hẹn của Agent: tabs theo trạng thái (Sắp tới / Đã xong / Huỷ).
- Bộ lọc theo ngày, KH liên quan.
- Card hiện: thời gian, KH, BDS gắn kèm, địa điểm.

### 8.2 Tạo lịch hẹn (`/appointments/new`)

- Form: chọn KH, chọn BDS (optional), thời gian (date + time), địa điểm, ghi chú.
- Submit → hiển thị trong list. Tự động link sang KH/BDS chi tiết.

### 8.3 Chi tiết (`/appointments/[id]`)

- Thông tin lịch hẹn + actions: **Đánh dấu hoàn thành**, **Huỷ lịch**, **Sửa**.

---

## 9. Đặt cọc (`/dat-coc`)

### 9.1 Danh sách

- Liệt kê đơn đặt cọc liên quan Agent: tabs trạng thái (Đang xử lý / Đã thanh toán / Huỷ).
- Cột: KH, BDS, số tiền cọc, ngày tạo, trạng thái.

### 9.2 Tạo đặt cọc (`/dat-coc/create`)

- Form: chọn KH, BDS, số tiền cọc, ngày, ghi chú, upload chứng từ (nếu có).

### 9.3 Chi tiết (`/dat-coc/[id]`)

- Thông tin đầy đủ + lịch sử cập nhật trạng thái + nút **Cập nhật trạng thái** (xác nhận thanh toán / huỷ).

---

## 10. Giao dịch (`/giao-dich`)

### 10.1 Danh sách

- Quản lý giao dịch BDS: tabs trạng thái (Khởi tạo / Đang xử lý / Hoàn thành / Huỷ).
- Cột: mã GD, KH, BDS, giá trị, ngày, agent phụ trách, trạng thái.

### 10.2 Tạo giao dịch (`/giao-dich/create`)

- Form: chọn KH, BDS, loại giao dịch (mua / bán / cho thuê), giá trị, ngày, hoa hồng (`buyer` / `seller` / `shared` — V1 mặc định `buyer`), ghi chú.

### 10.3 Chi tiết giao dịch (`/giao-dich/[id]`)

- Thông tin GD + timeline trạng thái + thông tin hoa hồng + KH/BDS liên quan.
- Action: cập nhật trạng thái, gắn note, chuyển sang hợp đồng.

---

## 11. Hợp đồng (`/contracts`)

### 11.1 Danh sách

- Hợp đồng dịch vụ / mua bán Agent đang theo dõi: filter theo trạng thái, ngày tạo, KH.

### 11.2 Chi tiết (`/contracts/[id]`)

- Xem thông tin hợp đồng, các bên liên quan, trạng thái, file đính kèm.
- *Upload contract PDF: phase 2 (chưa khả dụng — UI placeholder).*

---

## 12. Đội nhóm (`/doi-nhom`)

### 12.1 Tổng quan (`/doi-nhom`)

- **Hero gradient cam** + thông tin Agent đang xem (avatar, vai trò, văn phòng).
- **Stat cards**: tổng thành viên, hoạt động, doanh số nhóm, deal đã chốt — bấm card để filter list bên dưới.
- **Member list**: thành viên theo phân cấp (referral tree / org tree).

### 12.2 Danh sách thành viên (`/doi-nhom/danh-sach`)

- Bảng đầy đủ: tên, vai trò, văn phòng, ngày active gần nhất, số deal.
- Filter trạng thái hoạt động (🟢 Active / 🟡 Medium / 🟠 Low / 🔴 Danger theo ngưỡng ngày).

### 12.3 Sơ đồ (`/doi-nhom/so-do`)

- *Đang phát triển* — UI placeholder, dự kiến phase 2 (cây tree visualization).

### 12.4 Chi tiết thành viên (`/doi-nhom/[salesmanId]`)

- Profile thành viên + stat cards (deal, doanh số, F1 count) — cards filter list bên dưới.
- List liên quan: BDS đăng, giao dịch, KH phụ trách (theo tab).

---

## 13. Xếp hạng (`/rank`)

- Bảng xếp hạng Agent theo doanh số / số deal trong kỳ (tháng / quý / năm).
- Hiển thị top theo văn phòng và toàn hệ thống.
- Filter kỳ thời gian.

---

## 14. Thông báo (`/notifications`)

- Danh sách thông báo theo loại:
  - **Type 1 — Giao dịch**: cập nhật giao dịch / nhu cầu / lịch hẹn.
  - **Type 2 — Hệ thống**: bảo trì, thông báo chung.
- **Polling** mỗi 30 giây → cập nhật badge số chưa đọc trên topbar.
- Bấm thông báo → đánh dấu đã đọc + chuyển tới entity gốc (BDS/GD/...).
- *Lưu ý*: BE không có endpoint riêng cho unread count → FE tự đếm từ list.

---

## 15. Hồ sơ cá nhân

### 15.1 Xem hồ sơ (`/profile`)

- Avatar, tên, SĐT, email, mã nhân viên, văn phòng, vai trò, ngày tham gia.
- Stat: tổng BDS đăng, deal hoàn thành, KH phụ trách.

### 15.2 Chỉnh sửa hồ sơ (`/profile/edit`)

- Sửa: avatar (upload ≤ 5MB), họ tên, email, ngân hàng, địa chỉ liên hệ.
- *Crop avatar: phase 2.*

### 15.3 KYC — Xác thực BDS (`/profile/kyc`)

- 3 bước trạng thái:
  - **Chưa gửi** (step 0–1): nhập thông tin CMND/CCCD, upload ảnh mặt trước/sau (≤ 5MB).
  - **Chờ duyệt** (step 2): màu vàng, đợi BE xét duyệt.
  - **Đã duyệt** (step ≥ 3): màu xanh, mở khoá đầy đủ tính năng BDS.
- Có thể cập nhật lại nếu bị từ chối.

---

## 16. Mẹo & quy ước chung

- **Hiển thị tên / địa chỉ**: hệ thống tự **viết hoa ký tự đầu mỗi từ** ở UI để chuẩn hoá.
- **Format giá**: hệ thống rút gọn (vd `1,2 tỷ`, `850 triệu`) ở list; chi tiết hiển thị đầy đủ.
- **Tag**: dùng chung qua endpoint `list_tags` → một tag có thể gắn vào BDS, Nhu cầu, KH.
- **Yêu thích & nhóm yêu thích**: chỉ áp dụng cho BDS thứ cấp.
- **Mobile-first**: layout co rút compact, sticky tabs/header, action chuyển bottom sheet.
- **Cookie session**: token lưu cookie `tkbds_token` httpOnly. Đăng xuất khi thấy lỗi 401.
- **Đa thiết bị**: cùng tài khoản đăng nhập web + app cùng lúc OK; logout 1 nơi không ảnh hưởng nơi khác.

---

## 17. Tính năng phase 2 (chưa khả dụng)

Hiển thị placeholder hoặc disabled trong UI hiện tại:

- Sơ đồ đội nhóm (tree visualization).
- Crop avatar khi upload.
- Upload PDF hợp đồng.
- Calendar widget cho lịch hẹn (hiện dùng date+time input).
- Autocomplete nâng cao một số form.
- Demand-match suggestion 2 chiều.
- Sửa Wizard BDS sau khi đăng (hiện chỉ tạo).
- Module Chat / Wallet / Loan / Events / Rose / QR scan / Camera.

---

## Câu hỏi mở

- Hoa hồng `seller` / `shared`: hiện FE V1 mặc định `buyer` — chờ design BE confirm khi nào hiển thị 3 lựa chọn cho Agent.
- BE chưa trả `office_position.name_code` cho `sales_off_users` → một số filter "Chức danh" tạm fallback.
- `is_2_tier` flag tường minh ở payload BDS create (hiện workaround `district_id=ward_id`).

# Auth pages parity vs v1 — sign in / sign up / forgot / OTP

Compared new repo `lib/features/auth/**` against old `tongkhobds_agent` (GetX v1). Framework differs (Riverpod vs GetX) — only **logic + models + API contract** compared.

Old refs: `features/auth/*/_controller.dart`, `domain/client/api_client.dart`, `domain/data/models/user_model.dart`, `utils/validators/auth_validator.dart`.

## What matches ✓
- **Validators** (`core/utils/auth_validators.dart`): phone regex + password regex byte-identical to v1 `AuthValidator`.
- **Domain switcher**: 10-tap "Hoặc" trigger + 3 preset domains identical (`AppConfig.domains`).
- **Endpoints** (login, send_otp, login_otp, register, get_user_profile, create_new_password): paths + query/body keys match v1, all under `/api_agent`.
- **Forgot flow** (`forgot_password_screen.dart`): faithful — phone-format check, OTP len-6 check, password-format check, confirm-match, `create_new_password` with explicit OTP bearer token. Most accurate of the four.

## Mismatches (actual divergence)

### REGISTER — most divergent
| # | Issue | v1 | new | Sev |
|---|---|---|---|---|
| R1 | **Birthday format sent to API** | `dd/MM/yyyy` (`_formatBirthdayForApi`) | `yyyy-MM-dd` (`_toApiBirthday`) | HIGH |
| R2 | **`yoe` field dropped** | payload includes `yoe` (int) | not sent | MED |
| R3 | **Password validation weaker** | `validatePassword`: 6–15, letter+digit, no space | only `length < 6` (no max, no letter+digit) | HIGH |
| R4 | **Phone not format-validated** | `isValidPhoneNumber` gate | only non-empty | MED |
| R5 | **Phone duplicate state machine absent** | debounced `checkPhoneRegister` → `available/existsAgent/existsTongKhoUpdate`, blocks dup, routes `needsUpdate`→OTP-login | none — submits blind | MED |
| R6 | `ward_id` | sent when 2-level address off | sent only if `_location.wardId != null` | LOW (ok) |

`isValidPassword`/`isValidVietnamPhone` exist in repo but register screen doesn't call them.

### OTP (login screen `otp_screen.dart`)
| # | Issue | v1 | new | Sev |
|---|---|---|---|---|
| O1 | **OTP length check** | rejects `code.length != 6` | only non-empty | MED |
| O2 | **Phone format check before send** | `isValidPhoneNumber` | only non-empty | MED |
| O3 | **Resend countdown / ttl** | timer from `ttl_seconds` resp, resend gated | no countdown, resend always on | MED |
| O4 | **Device id** | real `AppUtil.getDeviceId()` | hardcoded `'flutter_agent_app'` | MED — backend may bind OTP to device |
| O5 | **Signup handoff** | register navigates w/ phone arg + type=signup + auto-send OTP + "Đăng kí thành công" | register `push('/otp')` → user re-types phone, re-sends, no signup msg | MED UX |

### LOGIN (`login_screen.dart`)
| # | Issue | v1 | new | Sev |
|---|---|---|---|---|
| L1 | OTP-login precheck | `checkDuplicatePhone` (phone must be registered) before OTP | none | LOW |
| L2 | Password-login validation | strict phone + password format (skipped only in debug) | non-empty only | LOW — field is "Tài khoản / SĐT", may be intentional |
| L3 | "unverified" handling | specific msg "Tài khoản chưa xác thực. Vui lòng đăng nhập bằng OTP." | raw backend message | LOW |

### FORGOT
| # | Issue | v1 | new | Sev |
|---|---|---|---|---|
| F1 | Phone-registered precheck | `checkDuplicatePhone` → "Số điện thoại chưa được đăng ký" | skipped, sends OTP directly | LOW |
| F2 | Countdown source | `ttl_seconds` from response | fixed 60s | LOW |

## MODEL differences (`User` vs `UserModel`)
- **`cityId` / `districtId` type**: new `int?` vs v1 `String?`. If backend returns non-numeric these go null. ⚠ verify backend.
- **Dropped fields** used by v1 auth side-effects (outside these 4 screens, but lost): `checkingStaff` (drives biometric-staff prompt), `requireUpdate` (force profile-update), plus `yoe, salesman, rocket_chat, mem, token/expiration/issuedAt, citizenIdFront/Back, taxCode, contractPdf, contractVerify, cityName, districtName, idDay, isPopupSupport, userName, isPassword, firstName, lastName`.
- **Added**: `code` (name_code), `position` (position_name_code).
- **`isVerified`**: new = `step >= 3`. v1 had no such getter — confirm 3 is correct KYC threshold.
- New design intentionally slims model; OK for these screens, but `requireUpdate`/`checkingStaff` loss removes v1 post-login behaviors.

## Namespace note
v1 `apiCommon` = `/api` (NOT `/api_common`). New `AppConfig.common = /api_common`, `public = /api`. If reintroducing `check_phone_register` / `checkPhoneRegister`, use **`/api`** (`AppConfig.public`) + `/api_agent` respectively to match v1.

## Recommended priority fixes
1. **R1 birthday format** + **R3 password rule** + **R4 phone validation** in register (use existing validators).
2. **O1/O2** add len-6 + phone-format guards to OTP login screen.
3. **O5** register→OTP: pass phone, auto-send, show signup success.
4. **O4** device id — confirm backend tolerance for static id.
5. Decide whether **R5** phone state-machine + **L1/F1** prechecks are intentionally cut.

## Unresolved questions
- Is the slim `User` model intentional, or should `checkingStaff`/`requireUpdate`/`yoe` be restored?
- `cityId`/`districtId` — does backend guarantee numeric? (v1 kept String.)
- Was register's phone duplicate-check state machine deliberately dropped for v2?
- Is login meant to accept account-name (not just phone)? Affects L2.
- Does `login_otp.json` response carry the `{status,message,data}` envelope (so EnvelopeInterceptor unwrap yields top-level `token`)? v1 read `token` directly off raw response.

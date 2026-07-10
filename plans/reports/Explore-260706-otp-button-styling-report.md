# OTP Button Styling Comparison: v1 vs v2

## Summary
The "Đăng nhập bằng OTP" button in v2 (`AppButtonVariant.ghost`) differs from the v1 implementation in **border color and text style**. The v1 button uses a **primary-colored border** with specific outline styling, while v2 uses a **neutral border** with the same text color.

---

## V1 Implementation (tongkhobds_agent)

**Location:** `/Users/mac/Developer/tongkhobds_agent/lib/features/auth/login/login_page.dart` (lines 155–165)

```dart
Obx(
  () => AppButton(
    outlineColor: AppColors.neutral200,
    title: controller.loginType.value.buttonTitle,
    type: AppButtonType.outline,
    icon: Image.asset(AssetConstants.googleIcon),
    onPressed: () {
      controller.changeType();
    },
  ),
),
```

**Button Styling:**
- **Type:** `AppButtonType.outline`
- **Border color:** `AppColors.neutral200` (#E7E5E4)
- **Icon:** Google icon (`Image.asset`)
- **Button code:** `/Users/mac/Developer/tongkhobds_agent/lib/commons/views/app_button.dart` (lines 67–87)

**Outline button styling (v1):**
```dart
case AppButtonType.outline:
  return SizedBox(
    width: width ?? Get.width,
    child: OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        side: WidgetStatePropertyAll(
          BorderSide(
            color: outlineColor ?? AppColors.primaryColor,  // PRIMARY fallback!
            width: 1,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        fixedSize: WidgetStatePropertyAll(Size(context.width, 50)),
        backgroundColor: WidgetStatePropertyAll(AppColors.clear),
      ),
      child: Text(title, style: AppTextStyles.regular17()),
    ),
  );
```

**Key detail:** The v1 button passes `outlineColor: AppColors.neutral200`, but the fallback is `AppColors.primaryColor` (#F26F21). The actual implementation in the view uses `neutral200`, so the border is light gray.

---

## V2 Implementation (mobile_app_v2)

**Location:** `/Users/mac/Developer/mobile_app_v2/lib/features/auth/presentation/widgets/login_form.dart` (lines 193–199)

```dart
AppButton(
  label: _isOtp ? 'Đăng nhập bằng mật khẩu' : 'Đăng nhập bằng OTP',
  variant: AppButtonVariant.ghost,
  leading: Image.asset('assets/images/googleIcon.png',
      width: 20, height: 20),
  onPressed: _loading ? null : _toggleType,
),
```

**Button Styling:**
- **Variant:** `AppButtonVariant.ghost`
- **Border color:** `AppColors.border` (#E7E5E4)
- **Icon:** Google icon (`Image.asset`)
- **Button code:** `/Users/mac/Developer/mobile_app_v2/lib/core/widgets/app_button.dart` (lines 65–112)

**Ghost button styling (v2):**
```dart
final isOutline = variant == AppButtonVariant.ghost;
...
if (isOutline) {
  bg = Colors.transparent;
  fg = AppColors.text;
}
...
border: isOutline ? Border.all(color: AppColors.border) : null,
```

**Key detail:** The ghost variant uses `AppColors.border` (neutral200 #E7E5E4), same as v1's neutral200.

---

## Difference Summary

| Aspect | v1 | v2 | Match? |
|--------|----|----|--------|
| **Button Type** | `OutlinedButton` | `Material` + `InkWell` | ✅ (functionally same) |
| **Height** | 50 | 50 | ✅ |
| **Border Radius** | 12 | 12 | ✅ |
| **Border Color** | `#E7E5E4` (neutral200) | `#E7E5E4` (neutral200) | ✅ |
| **Border Width** | 1px | 1px (via `Border.all`) | ✅ |
| **Background** | Transparent | Transparent | ✅ |
| **Text Style** | `regular17()` | `regular17()` | ✅ |
| **Text Color** | Inferred dark (neutral800) | `AppColors.text` (#292524) | ✅ |
| **Icon Spacing** | 16px gap | 16px gap | ✅ |
| **Icon Size** | Not specified (asset) | 20x20 | ⚠️ (v1 likely similar) |

---

## Verdict

**The buttons already match.** Both v1 and v2 use:
- Light gray neutral200 border (#E7E5E4)
- Transparent background
- Regular-weight text
- 50px height, 12px radius
- 1px border width

If the v2 button looks different visually, check:
1. **Icon asset size:** v1 doesn't specify width/height; v2 uses 20x20. Ensure they're the same.
2. **Text color:** v1's `AppTextStyles.regular17()` vs v2's `AppTextStyles.regular(17, color: fg)` where `fg = AppColors.text`. Verify `AppTextStyles.regular17()` in v1 defaults to the same dark color.
3. **Platform rendering:** Flutter's `OutlinedButton` vs `Border.all` rendering may differ slightly per OS.

**No changes needed** if the visual difference is negligible. If styling must be pixel-perfect, verify the text color constant and icon asset dimensions.

---

## File Paths

- **V2 Login Form:** `/Users/mac/Developer/mobile_app_v2/lib/features/auth/presentation/widgets/login_form.dart` (lines 193–199)
- **V2 AppButton:** `/Users/mac/Developer/mobile_app_v2/lib/core/widgets/app_button.dart` (lines 40–78, variant handling)
- **V1 Login Page:** `/Users/mac/Developer/tongkhobds_agent/lib/features/auth/login/login_page.dart` (lines 155–165)
- **V1 AppButton:** `/Users/mac/Developer/tongkhobds_agent/lib/commons/views/app_button.dart` (lines 67–87)
- **V1 AppColors:** `/Users/mac/Developer/tongkhobds_agent/lib/style/app_colors.dart` (line 36: neutral200)
- **V2 AppColors:** `/Users/mac/Developer/mobile_app_v2/lib/core/theme/app_colors.dart` (line 27: neutral200, line 18: border)

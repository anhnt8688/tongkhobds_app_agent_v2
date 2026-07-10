import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../config/app_config.dart';

/// The source rect the iOS/iPad share popover anchors to. iOS throws if this is
/// missing or zero-sized, so derive it from the widget that triggered the share.
Rect? shareOrigin(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  if (box == null || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero) & box.size;
}

/// Builds a human-friendly share message for a property and opens the OS
/// share sheet. Pass [context] (or a precomputed [sharePositionOrigin]) so the
/// iOS popover has a valid anchor.
Future<void> sharePropertyInfo({
  required String title,
  String? priceText,
  String? address,
  String? code,
  String? slug,
  BuildContext? context,
  Rect? sharePositionOrigin,
}) async {
  final lines = <String>[
    title,
    if (priceText != null && priceText.isNotEmpty) '💰 Giá: $priceText',
    if (address != null && address.isNotEmpty) '📍 $address',
    if (code != null && code.isNotEmpty) 'Mã BĐS: $code',
    if (slug != null && slug.isNotEmpty) '${AppConfig.webBase}/tin/$slug',
  ];
  final origin =
      sharePositionOrigin ?? (context != null ? shareOrigin(context) : null);
  await Share.share(
    lines.join('\n'),
    subject: title,
    sharePositionOrigin: origin,
  );
}

/// Shares a project (dự án) link `webBase/duan/{slug}` + its title. Mirrors v1
/// `detail_project_controller.onShare`.
Future<void> shareProject({
  required String title,
  String? slug,
  BuildContext? context,
  Rect? sharePositionOrigin,
}) async {
  final origin =
      sharePositionOrigin ?? (context != null ? shareOrigin(context) : null);
  final text = (slug != null && slug.isNotEmpty)
      ? '$title\n${AppConfig.webBase}/duan/$slug'
      : title;
  await Share.share(text, subject: title, sharePositionOrigin: origin);
}

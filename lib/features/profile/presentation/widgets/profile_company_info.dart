import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/profile_api.dart';

/// Company-info HTML block rendered at the bottom of the profile (v1 news id=248).
/// Stays collapsed while loading, on error, or when empty.
class ProfileCompanyInfo extends ConsumerWidget {
  const ProfileCompanyInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final html = ref.watch(companyInfoProvider).valueOrNull ?? '';
    if (html.trim().isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      child: HtmlWidget(
        html,
        textStyle: const TextStyle(
          fontSize: 13,
          height: 1.4,
          color: AppColors.text,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/models/award.dart';
import '../data/profile_api.dart';

/// "Quyền lợi" — renders the award's HTML benefits.
class AwardBenefitsScreen extends ConsumerWidget {
  const AwardBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final award = ref.watch(awardProvider);
    return CustomScreen(
      title: 'Quyền lợi',
      child: AsyncView<AwardDetail?>(
        value: award,
        onRetry: () => ref.invalidate(awardProvider),
        data: (a) {
          if (a == null) {
            return const Center(child: Text('Chưa có thông tin quyền lợi'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(a.name ?? '', style: AppTypography.heading),
              if ((a.description ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(a.description!, style: AppTypography.body),
              ],
              const SizedBox(height: 16),
              if ((a.htmlContent ?? '').trim().isNotEmpty)
                HtmlWidget(a.htmlContent!),
            ],
          );
        },
      ),
    );
  }
}

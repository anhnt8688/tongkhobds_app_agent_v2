import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/chat_room.dart';

/// A single conversation row in the inbox: avatar, name, last-message preview,
/// time, and an unread badge (matches v1 ChatMessageItem).
class ConversationTile extends StatelessWidget {
  const ConversationTile({super.key, required this.room, required this.onTap});

  final ChatRoom room;
  final VoidCallback onTap;

  bool get _unread => room.countMiss > 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _avatar(),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child: AppNetworkImage(
            url: AppConfig.imageUrl(room.image),
            width: 48,
            height: 48,
            placeholder: _avatarFallback(),
            errorWidget: _avatarFallback(),
          ),
        ),
        if (_unread)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              constraints: const BoxConstraints(minWidth: 18),
              decoration: BoxDecoration(
                color: AppColors.danger,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                border: Border.all(color: AppColors.surface, width: 1.5),
              ),
              child: Text(
                _badge(room.countMiss),
                textAlign: TextAlign.center,
                style: AppTypography.micro
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
      ],
    );
  }

  Widget _avatarFallback() => Container(
        width: 48,
        height: 48,
        color: AppColors.primarySoft,
        child: const Icon(Icons.person, color: AppColors.primary),
      );

  Widget _body() {
    final weight = _unread ? FontWeight.w700 : FontWeight.w600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                room.name ?? 'Hội thoại',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body.copyWith(fontWeight: weight),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(_formatTime(room.messageTime),
                style: AppTypography.micro
                    .copyWith(color: AppColors.textMute)),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          room.messageContent ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.caption.copyWith(
            color: _unread ? AppColors.text : AppColors.textSecondary,
            fontWeight: _unread ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  static String _badge(int n) => n > 99 ? '99+' : (n > 5 ? '5+' : '$n');

  /// Relative time: HH:mm today, else dd/MM.
  static String _formatTime(String? iso) {
    final t = iso == null ? null : DateTime.tryParse(iso)?.toLocal();
    if (t == null) return '';
    final now = DateTime.now();
    final sameDay = t.year == now.year && t.month == now.month && t.day == now.day;
    return DateFormat(sameDay ? 'HH:mm' : 'dd/MM').format(t);
  }
}

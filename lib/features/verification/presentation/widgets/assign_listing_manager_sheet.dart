import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../data/models/listing_manager_models.dart';
import '../../data/models/verification_models.dart';
import '../../data/verification_api.dart';
import '../../data/verification_providers.dart';
import 'verification_widgets.dart';

/// "Giao đầu chủ" — pick a listing manager from the tree and assign it.
/// Pops the selected name on success.
class AssignListingManagerSheet extends ConsumerStatefulWidget {
  const AssignListingManagerSheet({super.key, required this.item});
  final VerificationItem item;
  @override
  ConsumerState<AssignListingManagerSheet> createState() =>
      _AssignListingManagerSheetState();
}

class _AssignListingManagerSheetState
    extends ConsumerState<AssignListingManagerSheet> {
  final _search = TextEditingController();
  int? _selectedId;
  bool _submitting = false;

  static const _avatarTones = [
    [Color(0xFFFEF3C7), Color(0xFF92400E)],
    [Color(0xFFDBEAFE), Color(0xFF1E40AF)],
    [Color(0xFFFEE2E2), Color(0xFF991B1B)],
    [Color(0xFFD1FAE5), Color(0xFF065F46)],
    [Color(0xFFFCE7F3), Color(0xFF9D174D)],
    [Color(0xFFE0E7FF), Color(0xFF3730A3)],
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _submit(ListingManagerItemViewModel m) async {
    setState(() => _submitting = true);
    final res = await ref.read(verificationApiProvider).assignListingManager(
          realEstateSalesmanId: widget.item.id,
          listingManagerId: m.effectiveId,
        );
    if (!mounted) return;
    if (res.success) {
      AppToast.success(context,
          res.message.isNotEmpty ? res.message : 'Giao đầu chủ thành công');
      Navigator.pop(context, m.name);
    } else {
      AppToast.error(context, res.message);
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(listingManagersProvider);
    final maxH = MediaQuery.of(context).size.height * 0.84;
    final q = _search.text.trim().toLowerCase();

    return SizedBox(
      height: maxH,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Center(child: VSheetHandle()),
          const SizedBox(height: 10),
          _Header(title: 'Giao đầu chủ', subtitle: 'BĐS: ${widget.item.title}'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Tìm theo tên, SĐT...',
                prefixIcon: const Icon(Icons.search, color: VColors.n400),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: VColors.orange)),
              error: (_, __) => _ErrorState(
                  onRetry: () => ref.invalidate(listingManagersProvider)),
              data: (resp) {
                final all = resp.items.where((e) => e.isListingManager).toList();
                final list = all
                    .where((m) =>
                        q.isEmpty ||
                        m.name.toLowerCase().contains(q) ||
                        m.phone.toLowerCase().contains(q) ||
                        m.role.toLowerCase().contains(q) ||
                        m.teamLabel.toLowerCase().contains(q))
                    .toList();
                if (list.isEmpty) {
                  return _EmptyState(
                      message: q.isNotEmpty
                          ? 'Không tìm thấy đầu chủ phù hợp'
                          : 'Chưa có dữ liệu đầu chủ');
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final m = list[i];
                    return _Tile(
                      name: m.name,
                      subtitle: [
                        if (m.phone.isNotEmpty) m.phone,
                        if (m.role.isNotEmpty) m.role,
                        if (m.teamLabel.isNotEmpty) m.teamLabel,
                      ].join(' · '),
                      avatar: m.avatar,
                      tone: _avatarTones[m.effectiveId % _avatarTones.length],
                      selected: _selectedId == m.effectiveId,
                      selectedLabel: 'Đầu chủ',
                      onTap: () => setState(() => _selectedId = m.effectiveId),
                    );
                  },
                );
              },
            ),
          ),
          _ConfirmBar(
            enabled: _selectedId != null && !_submitting,
            submitting: _submitting,
            onConfirm: () {
              final resp = async.value;
              if (resp == null) return;
              final m = resp.items.firstWhere(
                  (e) => e.effectiveId == _selectedId,
                  orElse: () => resp.items.first);
              _submit(m);
            },
          ),
        ],
      ),
    );
  }
}

// ── shared sheet pieces (also used by AssignManagerSheet) ──

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
                color: Color(0xFFFFEDD5), shape: BoxShape.circle),
            child: const Icon(Icons.person_add_alt_1_rounded,
                color: VColors.orange, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: vText(20, FontWeight.w700, VColors.n800)),
                const SizedBox(height: 2),
                Text(subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: vText(13, FontWeight.w400, VColors.n500)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, color: VColors.n500),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.name,
    required this.subtitle,
    required this.avatar,
    required this.tone,
    required this.selected,
    required this.onTap,
    required this.selectedLabel,
  });
  final String name;
  final String subtitle;
  final String avatar;
  final List<Color> tone;
  final bool selected;
  final VoidCallback onTap;
  final String selectedLabel;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF6E8) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected ? VColors.orange : VColors.line,
              width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            ClipOval(
              child: SizedBox(
                width: 44,
                height: 44,
                child: avatar.isNotEmpty
                    ? AppNetworkImage(url: avatar, width: 44, height: 44)
                    : Container(
                        color: tone[0],
                        alignment: Alignment.center,
                        child: Text(_initials,
                            style: vText(14, FontWeight.w700, tone[1])),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: vText(16, FontWeight.w700, VColors.n800)),
                      ),
                      if (selected) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                              color: VColors.orangePale,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: VColors.orangeBorder)),
                          child: Text(selectedLabel,
                              style: vText(10, FontWeight.w600, VColors.orange)),
                        ),
                      ],
                    ],
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: vText(13, FontWeight.w400, VColors.n500)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? VColors.orange : VColors.n300,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar(
      {required this.enabled,
      required this.submitting,
      required this.onConfirm});
  final bool enabled;
  final bool submitting;
  final VoidCallback onConfirm;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 50,
          child: FilledButton(
            onPressed: enabled ? onConfirm : null,
            style: FilledButton.styleFrom(
              backgroundColor: VColors.orange,
              disabledBackgroundColor: VColors.n300,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white)))
                : Text('Xác nhận',
                    style: vText(16, FontWeight.w700, Colors.white)),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 36, color: VColors.n400),
            const SizedBox(height: 8),
            Text('Không tải được dữ liệu',
                style: vText(13, FontWeight.w400, VColors.n500)),
            const SizedBox(height: 10),
            TextButton(
                onPressed: onRetry,
                child: Text('Thử lại',
                    style: vText(14, FontWeight.w600, VColors.orange))),
          ],
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 36, color: VColors.n400),
            const SizedBox(height: 8),
            Text(message, style: vText(13, FontWeight.w400, VColors.n500)),
          ],
        ),
      );
}

// Exposed for reuse by AssignManagerSheet.
class AssignSheetParts {
  static Widget header(BuildContext context,
          {required String title, required String subtitle}) =>
      _Header(title: title, subtitle: subtitle);
  static Widget confirmBar(
          {required bool enabled,
          required bool submitting,
          required VoidCallback onConfirm}) =>
      _ConfirmBar(enabled: enabled, submitting: submitting, onConfirm: onConfirm);
  static Widget errorState(VoidCallback onRetry) => _ErrorState(onRetry: onRetry);
  static Widget emptyState(String message) => _EmptyState(message: message);
  static Widget tile({
    required String name,
    required String subtitle,
    required String avatar,
    required List<Color> tone,
    required bool selected,
    required VoidCallback onTap,
    String selectedLabel = 'Đã chọn',
  }) =>
      _Tile(
        name: name,
        subtitle: subtitle,
        avatar: avatar,
        tone: tone,
        selected: selected,
        onTap: onTap,
        selectedLabel: selectedLabel,
      );
}

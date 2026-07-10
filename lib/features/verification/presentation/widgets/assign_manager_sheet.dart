import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/app_toast.dart';
import '../../data/models/verification_models.dart';
import '../../data/verification_api.dart';
import '../../data/verification_providers.dart';
import 'assign_listing_manager_sheet.dart';
import 'verification_widgets.dart';

/// "Gán Trưởng phòng" — pick an office + a sale-off member, then assign both
/// (office + sale-off member). Pops the selected manager name on success.
class AssignManagerSheet extends ConsumerStatefulWidget {
  const AssignManagerSheet({super.key, required this.item});
  final VerificationItem item;
  @override
  ConsumerState<AssignManagerSheet> createState() => _AssignManagerSheetState();
}

class _AssignManagerSheetState extends ConsumerState<AssignManagerSheet> {
  final _search = TextEditingController();
  int? _officeId;
  int? _managerId;
  bool _submitting = false;

  static const _tones = [
    [Color(0xFFDBEAFE), Color(0xFF1E40AF)],
    [Color(0xFFFEF3C7), Color(0xFF92400E)],
    [Color(0xFFD1FAE5), Color(0xFF065F46)],
    [Color(0xFFFCE7F3), Color(0xFF9D174D)],
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _submit(VerificationSalesUserOption m) async {
    setState(() => _submitting = true);
    final api = ref.read(verificationApiProvider);
    final results = await Future.wait([
      if (_officeId != null)
        api.assignRealEstateSalesmanOffice(
            realEstateSalesmanId: widget.item.id, postOfficeId: _officeId!),
      api.assignSaleOffMember(
          realEstateSalesmanId: widget.item.id, saleOffMemberId: m.id),
    ]);
    if (!mounted) return;
    final ok = results.every((r) => r.success);
    if (ok) {
      AppToast.success(context, 'Gán trưởng phòng thành công');
      Navigator.pop(context, m.name);
    } else {
      final msg = results.firstWhere((r) => !r.success).message;
      AppToast.error(context, msg.isNotEmpty ? msg : 'Gán trưởng phòng thất bại');
      setState(() => _submitting = false);
    }
  }

  Future<void> _pickOffice(List<VerificationOfficeOption> offices) async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _OfficePicker(offices: offices, selected: _officeId),
    );
    if (picked != null) setState(() => _officeId = picked);
  }

  @override
  Widget build(BuildContext context) {
    final officesAsync = ref.watch(verificationOfficesProvider);
    final usersAsync = ref.watch(verificationSalesUsersProvider);
    final maxH = MediaQuery.of(context).size.height * 0.84;
    final q = _search.text.trim().toLowerCase();

    final offices = officesAsync.value ?? const <VerificationOfficeOption>[];
    final selectedOffice =
        offices.where((o) => o.id == _officeId).cast<VerificationOfficeOption?>().firstOrNull;
    final users = usersAsync.value ?? const <VerificationSalesUserOption>[];
    final managers = users.where((u) {
      if (_officeId != null && u.officeId != _officeId) return false;
      if (q.isEmpty) return true;
      return u.name.toLowerCase().contains(q) ||
          u.phone.toLowerCase().contains(q) ||
          u.titleName.toLowerCase().contains(q) ||
          u.officeName.toLowerCase().contains(q);
    }).toList();

    return SizedBox(
      height: maxH,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Center(child: VSheetHandle()),
          const SizedBox(height: 10),
          AssignSheetParts.header(context,
              title: 'Gán Trưởng phòng', subtitle: 'BĐS: ${widget.item.title}'),
          // office selector
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: GestureDetector(
              onTap: offices.isEmpty ? null : () => _pickOffice(offices),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: _officeId != null ? VColors.orange : VColors.line),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.business_center_outlined,
                        color: VColors.orange, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        selectedOffice?.fullName ?? 'Chọn văn phòng',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: vText(14, FontWeight.w600,
                            selectedOffice == null ? VColors.n500 : VColors.n800),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: VColors.n400),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Tìm Trưởng phòng theo tên, SĐT...',
                prefixIcon: const Icon(Icons.search, color: VColors.n400),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: (officesAsync.isLoading || usersAsync.isLoading) &&
                    managers.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: VColors.orange))
                : managers.isEmpty
                    ? AssignSheetParts.emptyState(q.isNotEmpty
                        ? 'Không tìm thấy Trưởng phòng phù hợp'
                        : 'Chưa có Trưởng phòng')
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: managers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final m = managers[i];
                          return AssignSheetParts.tile(
                            name: m.name,
                            subtitle: [
                              if (m.titleName.isNotEmpty) m.titleName,
                              if (m.phone.isNotEmpty) m.phone,
                              if (m.officeName.isNotEmpty) m.officeName,
                            ].join(' · '),
                            avatar: '',
                            tone: _tones[m.id % _tones.length],
                            selected: _managerId == m.id,
                            selectedLabel: 'Trưởng phòng',
                            onTap: () => setState(() => _managerId = m.id),
                          );
                        },
                      ),
          ),
          AssignSheetParts.confirmBar(
            enabled: _managerId != null && !_submitting,
            submitting: _submitting,
            onConfirm: () {
              final m = users.firstWhere((e) => e.id == _managerId,
                  orElse: () => users.first);
              _submit(m);
            },
          ),
        ],
      ),
    );
  }
}

class _OfficePicker extends StatelessWidget {
  const _OfficePicker({required this.offices, required this.selected});
  final List<VerificationOfficeOption> offices;
  final int? selected;
  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.of(context).size.height * 0.6;
    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Center(child: VSheetHandle()),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Text('Chọn văn phòng',
                    style: vText(18, FontWeight.w700, VColors.n800)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded, color: VColors.n500),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: offices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final o = offices[i];
                final sel = o.id == selected;
                return GestureDetector(
                  onTap: () => Navigator.pop(context, o.id),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: sel ? VColors.orangePale : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: sel ? VColors.orange : VColors.line),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.business_outlined,
                            color: VColors.orange, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(o.fullName,
                                style:
                                    vText(14, FontWeight.w600, VColors.n800))),
                        Icon(
                          sel
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: sel ? VColors.orange : VColors.n300,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

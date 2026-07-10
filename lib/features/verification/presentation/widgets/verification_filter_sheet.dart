import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/verification_models.dart';
import '../../data/verification_providers.dart';
import 'verification_widgets.dart';

/// Full filter bottom sheet (status, date, agent scope/search, verifying agents,
/// created type, tags + and/or). Applies via the list controller.
class VerificationFilterSheet extends ConsumerStatefulWidget {
  const VerificationFilterSheet({super.key});
  @override
  ConsumerState<VerificationFilterSheet> createState() =>
      _VerificationFilterSheetState();
}

class _VerificationFilterSheetState
    extends ConsumerState<VerificationFilterSheet> {
  late VerificationListFilterState _draft;
  final _searchController = TextEditingController();
  bool _showAllAgents = false;
  static const _agentPreviewLimit = 3;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(verificationListControllerProvider).filters;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _draft = const VerificationListFilterState();
      _searchController.clear();
      _showAllAgents = false;
    });
  }

  int get _activeCount {
    var c = 0;
    if (_draft.statusIds.isNotEmpty) c++;
    if (_draft.datePreset != VerificationDatePreset.all) c++;
    if (_draft.hasCustomDateRange) c++;
    if (_draft.verifyingAgentIds.isNotEmpty) c++;
    if (_draft.createdType != null) c++;
    if (_draft.tagIds.isNotEmpty) c++;
    if (_draft.tagOperator.toLowerCase() == 'and') c++;
    return c;
  }

  void _toggleStatus(int id) {
    final ids = [..._draft.statusIds];
    ids.contains(id) ? ids.remove(id) : ids.add(id);
    setState(() => _draft = _draft.copyWith(statusIds: ids));
  }

  Future<void> _setDatePreset(VerificationDatePreset p) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (p) {
      case VerificationDatePreset.today:
        setState(() => _draft = _draft.copyWith(
            datePreset: p, dateFrom: today, dateTo: today));
        break;
      case VerificationDatePreset.sevenDays:
        setState(() => _draft = _draft.copyWith(
            datePreset: p,
            dateFrom: today.subtract(const Duration(days: 6)),
            dateTo: today));
        break;
      case VerificationDatePreset.thirtyDays:
        setState(() => _draft = _draft.copyWith(
            datePreset: p,
            dateFrom: today.subtract(const Duration(days: 29)),
            dateTo: today));
        break;
      case VerificationDatePreset.custom:
        setState(() => _draft = _draft.copyWith(datePreset: p));
        await _pickCustomRange();
        break;
      case VerificationDatePreset.all:
        setState(() => _draft = _draft.copyWith(
            datePreset: p, clearDateFrom: true, clearDateTo: true));
        break;
    }
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final from = await showDatePicker(
      context: context,
      initialDate: _draft.dateFrom ?? now,
      firstDate: DateTime(2018),
      lastDate: DateTime(now.year + 1),
      helpText: 'Từ ngày',
    );
    if (from == null || !mounted) return;
    final to = await showDatePicker(
      context: context,
      initialDate: _draft.dateTo ?? from,
      firstDate: from,
      lastDate: DateTime(now.year + 1),
      helpText: 'Đến ngày',
    );
    if (to == null || !mounted) return;
    setState(() => _draft = _draft.copyWith(
        datePreset: VerificationDatePreset.custom, dateFrom: from, dateTo: to));
  }

  void _toggleScope(VerificationAgentScope s) {
    if (_draft.createdType != null) return;
    setState(() => _draft = _draft.copyWith(agentScope: s));
  }

  void _toggleAgent(int id) {
    final ids = [..._draft.verifyingAgentIds];
    ids.contains(id) ? ids.remove(id) : ids.add(id);
    setState(() => _draft = _draft.copyWith(verifyingAgentIds: ids));
  }

  void _toggleCreatedType(VerificationCreatedType t) {
    setState(() => _draft = _draft.createdType == t
        ? _draft.copyWith(clearCreatedType: true)
        : _draft.copyWith(createdType: t));
  }

  void _removeTag(int id) {
    setState(() =>
        _draft = _draft.copyWith(tagIds: [..._draft.tagIds]..remove(id)));
  }

  String _fmt(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verificationListControllerProvider);
    final salesUsersAsync = ref.watch(verificationSalesUsersProvider);
    final tagsAsync = ref.watch(verificationTagsProvider);
    final maxH = MediaQuery.of(context).size.height * 0.9;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // agent list filtered by query + scope
    final allUsers = salesUsersAsync.value ?? const <VerificationSalesUserOption>[];
    final query = _searchController.text.trim().toLowerCase();
    final filteredAgents = allUsers.where((u) {
      if (query.isEmpty) return true;
      return u.name.toLowerCase().contains(query) ||
          u.phone.toLowerCase().contains(query) ||
          u.officeName.toLowerCase().contains(query) ||
          u.managerCode.toLowerCase().contains(query);
    }).toList();
    final previewAgents =
        _showAllAgents ? filteredAgents : filteredAgents.take(_agentPreviewLimit).toList();
    final hiddenCount = filteredAgents.length - previewAgents.length;

    final allTags = tagsAsync.value ?? const <VerificationTagOption>[];
    final selectedTags = allTags.where((t) => _draft.tagIds.contains(t.id)).toList();

    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      decoration: const BoxDecoration(
        color: VColors.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Center(child: VSheetHandle()),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Text('Bộ lọc', style: vText(20, FontWeight.w700, VColors.n800)),
                const Spacer(),
                GestureDetector(
                  onTap: _reset,
                  child: Text('Đặt lại',
                      style: vText(14, FontWeight.w600, VColors.orange)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // status
                  _FilterGroup(
                    title: 'Trạng thái',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final s in state.statusFilters.where((e) => e.id != 0))
                          _Chip(
                            label: s.name,
                            active: _draft.statusIds.contains(s.id),
                            onTap: () => _toggleStatus(s.id),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // date
                  _FilterGroup(
                    title: 'Ngày tạo xác thực',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final p in [
                              VerificationDatePreset.today,
                              VerificationDatePreset.sevenDays,
                              VerificationDatePreset.thirtyDays,
                            ])
                              _Chip(
                                label: p.label,
                                active: _draft.datePreset == p,
                                onTap: () => _setDatePreset(p),
                              ),
                            _Chip(
                              label: 'Tùy chọn',
                              icon: Icons.calendar_today_outlined,
                              active: _draft.datePreset == VerificationDatePreset.custom,
                              onTap: () => _setDatePreset(VerificationDatePreset.custom),
                            ),
                          ],
                        ),
                        if (_draft.hasCustomDateRange) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                  child: _DatePill(
                                      label: 'Từ ngày',
                                      value: _fmt(_draft.dateFrom!),
                                      onTap: _pickCustomRange)),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: _DatePill(
                                      label: 'Đến ngày',
                                      value: _fmt(_draft.dateTo!),
                                      onTap: _pickCustomRange)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // agent search + scope
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Tìm đầu chủ theo tên, SĐT, đội...',
                      hintStyle: vText(14, FontWeight.w400, VColors.n400),
                      prefixIcon: const Icon(Icons.search, color: VColors.n400),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: VColors.line),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: VColors.line),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _Chip(
                        label: VerificationAgentScope.office.label,
                        active: _draft.agentScope == VerificationAgentScope.office,
                        enabled: _draft.createdType == null,
                        onTap: () => _toggleScope(VerificationAgentScope.office),
                      ),
                      const SizedBox(width: 8),
                      _Chip(
                        label: VerificationAgentScope.team.label,
                        active: _draft.agentScope == VerificationAgentScope.team,
                        enabled: _draft.createdType == null,
                        onTap: () => _toggleScope(VerificationAgentScope.team),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // verifying agents
                  _FilterGroup(
                    title: 'Đơn vị',
                    child: salesUsersAsync.isLoading && allUsers.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                                child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: VColors.orange))))
                        : previewAgents.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text('Chưa có đầu chủ phù hợp',
                                    style: vText(13, FontWeight.w400, VColors.n500)))
                            : Column(
                                children: [
                                  for (var i = 0; i < previewAgents.length; i++) ...[
                                    _AgentTile(
                                      option: previewAgents[i],
                                      selected: _draft.verifyingAgentIds
                                          .contains(previewAgents[i].id),
                                      onTap: () => _toggleAgent(previewAgents[i].id),
                                    ),
                                    if (i != previewAgents.length - 1)
                                      const SizedBox(height: 10),
                                  ],
                                  if (hiddenCount > 0 || _showAllAgents) ...[
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () => setState(
                                          () => _showAllAgents = !_showAllAgents),
                                      child: Center(
                                        child: Text(
                                          _showAllAgents
                                              ? 'Thu gọn danh sách'
                                              : 'Xem thêm $hiddenCount đầu chủ',
                                          style: vText(
                                              13, FontWeight.w600, VColors.orange),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                  ),
                  const SizedBox(height: 12),
                  // created type
                  _FilterGroup(
                    title: 'Loại tạo',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final t in VerificationCreatedType.values)
                          _Chip(
                            label: t.label,
                            active: _draft.createdType == t,
                            onTap: () => _toggleCreatedType(t),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // tags
                  _FilterGroup(
                    title: 'Thẻ tag',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _Chip(
                              label: 'HOẶC',
                              active: _draft.tagOperator.toLowerCase() == 'or',
                              onTap: () => setState(
                                  () => _draft = _draft.copyWith(tagOperator: 'or')),
                            ),
                            const SizedBox(width: 8),
                            _Chip(
                              label: 'VÀ',
                              active: _draft.tagOperator.toLowerCase() == 'and',
                              onTap: () => setState(
                                  () => _draft = _draft.copyWith(tagOperator: 'and')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final tag in selectedTags)
                              _TagChip(
                                label: tag.name,
                                active: true,
                                onRemove: () => _removeTag(tag.id),
                              ),
                            _TagChip(
                              label: 'Chọn thêm thẻ',
                              active: false,
                              onTap: () => _openTagSelector(allTags),
                            ),
                          ],
                        ),
                        if (allTags.isEmpty && tagsAsync.isLoading)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('Đang tải thẻ...',
                                style: vText(12, FontWeight.w400, VColors.n400)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: const BorderSide(color: VColors.n300),
                      foregroundColor: VColors.n700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      ref
                          .read(verificationListControllerProvider.notifier)
                          .applyFilters(_draft);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: VColors.orange,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Áp dụng ($_activeCount)'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openTagSelector(List<VerificationTagOption> tags) async {
    final result = await showModalBottomSheet<List<int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _TagSelectionSheet(
          tags: tags, initial: _draft.tagIds.toSet()),
    );
    if (result != null) {
      setState(() => _draft = _draft.copyWith(tagIds: result));
    }
  }
}

// ── small components ──

class _FilterGroup extends StatelessWidget {
  const _FilterGroup({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: VColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: vText(13, FontWeight.w600, VColors.n800)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.active,
    this.onTap,
    this.icon,
    this.enabled = true,
  });
  final String label;
  final bool active;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final fg = active ? VColors.orange : VColors.n500;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: active ? VColors.orangePale : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: active ? VColors.orangeBorder : VColors.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: fg),
                const SizedBox(width: 4),
              ],
              Text(label, style: vText(13, FontWeight.w600, fg)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill(
      {required this.label, required this.value, required this.onTap});
  final String label;
  final String value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: VColors.n50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: VColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: vText(12, FontWeight.w400, VColors.n500)),
            const SizedBox(height: 3),
            Text(value, style: vText(13, FontWeight.w600, VColors.n800)),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip(
      {required this.label, required this.active, this.onTap, this.onRemove});
  final String label;
  final bool active;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  static const green = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? green : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: green),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!active) ...[
              const Icon(Icons.add_circle_outline_rounded, size: 14, color: green),
              const SizedBox(width: 4),
            ],
            Text(label,
                style: vText(13, FontWeight.w600, active ? Colors.white : green)),
            if (active && onRemove != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AgentTile extends StatelessWidget {
  const _AgentTile(
      {required this.option, required this.selected, required this.onTap});
  final VerificationSalesUserOption option;
  final bool selected;
  final VoidCallback onTap;

  String get _initials {
    final parts = option.name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = option.officeName.isNotEmpty
        ? option.officeName
        : (option.phone.isNotEmpty ? option.phone : 'Chưa có SĐT');
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
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFFFEDD5) : VColors.line,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(_initials,
                  style: vText(12, FontWeight.w600,
                      selected ? VColors.orange : VColors.n500)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: vText(14, FontWeight.w600, VColors.n800)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: vText(12, FontWeight.w400, VColors.n500)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              selected
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              color: selected ? VColors.orange : VColors.n300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _TagSelectionSheet extends StatefulWidget {
  const _TagSelectionSheet({required this.tags, required this.initial});
  final List<VerificationTagOption> tags;
  final Set<int> initial;
  @override
  State<_TagSelectionSheet> createState() => _TagSelectionSheetState();
}

class _TagSelectionSheetState extends State<_TagSelectionSheet> {
  late final Set<int> _selected = {...widget.initial};
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim().toLowerCase();
    final tags = widget.tags
        .where((t) => q.isEmpty || t.name.toLowerCase().contains(q))
        .toList();
    final maxH = MediaQuery.of(context).size.height * 0.82;
    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Center(child: VSheetHandle()),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Text('Chọn thẻ tag',
                    style: vText(18, FontWeight.w700, VColors.n800)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded, color: VColors.n500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Tìm thẻ tag',
                prefixIcon: const Icon(Icons.search, color: VColors.n400),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: tags.isEmpty
                ? Center(
                    child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Không có thẻ tag phù hợp',
                            style: vText(13, FontWeight.w400, VColors.n500))))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: tags.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final t = tags[i];
                      final sel = _selected.contains(t.id);
                      return GestureDetector(
                        onTap: () => setState(() =>
                            sel ? _selected.remove(t.id) : _selected.add(t.id)),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: sel ? const Color(0xFFEAFBF2) : VColors.n50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: sel
                                    ? const Color(0xFF22C55E)
                                    : VColors.line),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(t.name,
                                      style: vText(
                                          14, FontWeight.w600, VColors.n800))),
                              Icon(
                                sel
                                    ? Icons.check_circle_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: sel
                                    ? const Color(0xFF16A34A)
                                    : VColors.n300,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        side: const BorderSide(color: VColors.n300),
                        foregroundColor: VColors.n700,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, _selected.toList()),
                    style: FilledButton.styleFrom(
                        backgroundColor: VColors.orange,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14))),
                    child: Text('Áp dụng (${_selected.length})'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/team_api.dart';
import 'widgets/team_detail_widgets.dart';

/// "Lịch sử hoạt động" — mirrors v1 `TeamActivityHistoryPage`. Personal log loads
/// eagerly; the team log lazy-loads when its tab is first opened.
class TeamActivityHistoryScreen extends ConsumerStatefulWidget {
  const TeamActivityHistoryScreen({super.key, required this.salesmanId});
  final int salesmanId;

  @override
  ConsumerState<TeamActivityHistoryScreen> createState() =>
      _TeamActivityHistoryScreenState();
}

class _TeamActivityHistoryScreenState
    extends ConsumerState<TeamActivityHistoryScreen> {
  TeamApi get _api => ref.read(teamApiProvider);

  int _tabIndex = 0;
  bool _loading = true;
  bool _loadingTeam = false;
  String? _error;
  List<Map> _personalLogs = const [];
  List<Map> _teamLogs = const [];

  @override
  void initState() {
    super.initState();
    _loadPersonal();
  }

  Future<void> _loadPersonal() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final logs = await _api.memberActivityLog(widget.salesmanId);
      if (!mounted) return;
      setState(() {
        _personalLogs = logs;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Không tải được lịch sử hoạt động';
      });
    }
  }

  Future<void> _loadTeam() async {
    if (_loadingTeam) return;
    setState(() {
      _loadingTeam = true;
      _error = null;
    });
    try {
      final logs = await _api.teamActivityLog(widget.salesmanId);
      if (!mounted) return;
      setState(() => _teamLogs = logs);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Không tải được lịch sử hoạt động đội nhóm');
    } finally {
      if (mounted) setState(() => _loadingTeam = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Lịch sử hoạt động',
      child: Column(
        children: [
          _buildTabs(),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _loadPersonal,
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary))
                  : _error != null
                      ? _buildError()
                      : _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Material(
      color: AppColors.surface,
      child: Row(
        children: [_tabItem('Cá nhân', 0), _tabItem('Đội nhóm', 1)],
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    final selected = _tabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _tabIndex = index);
          if (index == 1 && _teamLogs.isEmpty && !_loadingTeam) _loadTeam();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: selected
              ? const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColors.primary, width: 2)))
              : null,
          child: Center(
            child: Text(title,
                style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: selected ? AppColors.primary : AppColors.textMute)),
          ),
        ),
      ),
    );
  }

  Widget _buildError() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 60),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!, style: AppTypography.body),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: _loadPersonal, child: const Text('Thử lại')),
              ],
            ),
          ),
        ],
      );

  Widget _buildBody() {
    final logs = _tabIndex == 0 ? _personalLogs : _teamLogs;
    if (_tabIndex == 1 && _loadingTeam) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (logs.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 24),
          Center(
            child: Text(
              _tabIndex == 0
                  ? 'Không có hoạt động (7 ngày)'
                  : 'Không có hoạt động đội nhóm (7 ngày)',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      itemCount: logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _logItem(logs[i]),
    );
  }

  Widget _logItem(Map item) {
    final date =
        readMapStr(item, ['date_display', 'date', 'timestamp']);
    final time = readMapStr(item, ['time']);
    final description = readMapStr(item, ['description']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(time.isEmpty ? (date.isEmpty ? '--' : date) : '$time $date',
            style:
                AppTypography.caption.copyWith(color: AppColors.textMute)),
        const SizedBox(height: 4),
        Text(description.isEmpty ? '--' : description,
            style: AppTypography.body
                .copyWith(color: AppColors.text, height: 1.25)),
      ],
    );
  }
}

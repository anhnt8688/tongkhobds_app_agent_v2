import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/team_api.dart';
import 'widgets/team_detail_widgets.dart';

/// "Thông tin đội nhóm" — mirrors v1 `TeamMemberDetailPage`. Used both for the
/// current agent (`/team`) and any member (`/team/member/:id`), recursively.
class TeamMemberDetailScreen extends ConsumerStatefulWidget {
  const TeamMemberDetailScreen({super.key, required this.salesmanId});
  final int salesmanId;

  @override
  ConsumerState<TeamMemberDetailScreen> createState() =>
      _TeamMemberDetailScreenState();
}

class _TeamMemberDetailScreenState
    extends ConsumerState<TeamMemberDetailScreen> {
  static const int _inventoryPageSize = 20;
  static const int _memberPageSize = 10;

  TeamApi get _api => ref.read(teamApiProvider);

  int _tabIndex = 0; // 0 = Cá nhân, 1 = Đội nhóm
  int _personalTabIndex = 0; // 0 = Giao dịch, 1 = Nguồn hàng, 2 = Thành viên
  int _teamTabIndex = 0;

  bool _loading = true;
  bool _contentLoading = true;
  String? _error;
  String? _contentError;
  int _loadToken = 0;

  Map _detail = const {};
  Map _overview = const {};

  List<Map> _transactions = const [];
  List<Map> _inventory = const [];
  List<TeamMemberItem> _subordinates = const [];
  List<Map> _teamTransactions = const [];
  List<Map> _teamInventory = const [];
  List<TeamMemberItem> _teamMembers = const [];

  int _personalInventoryVisible = _inventoryPageSize;
  int _teamInventoryVisible = _inventoryPageSize;
  int _personalMemberVisible = _memberPageSize;
  int _teamMemberVisible = _memberPageSize;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _loading = true;
      _error = null;
      _contentError = null;
      _contentLoading = true;
    });
    try {
      final results = await Future.wait([
        _api.memberDetail(widget.salesmanId),
        _api.overviewRaw(widget.salesmanId),
      ]);
      if (!mounted) return;
      setState(() {
        _detail = results[0];
        _overview = results[1];
      });
      await _loadFocusedSection();
      if (!mounted) return;
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Không tải được chi tiết thành viên';
      });
    }
  }

  Future<void> _loadFocusedSection() async {
    final token = ++_loadToken;
    if (!mounted) return;
    setState(() {
      _contentError = null;
      _contentLoading = true;
    });
    try {
      if (_tabIndex == 0) {
        await _loadPersonalSection();
      } else {
        await _loadTeamSection();
      }
      if (!mounted || token != _loadToken) return;
      setState(() => _contentLoading = false);
    } catch (_) {
      if (!mounted || token != _loadToken) return;
      setState(() {
        _contentLoading = false;
        _contentError = 'Không tải được dữ liệu tab hiện tại';
      });
    }
  }

  Future<void> _loadPersonalSection() async {
    final id = widget.salesmanId;
    switch (_personalTabIndex) {
      case 1:
        final inv = await _api.memberInventory(id);
        if (!mounted) return;
        setState(() {
          _inventory = inv;
          _personalInventoryVisible = _inventoryPageSize;
        });
        return;
      case 2:
        final subs = await _api.memberSubordinates(id);
        if (!mounted) return;
        setState(() {
          _subordinates = subs;
          _personalMemberVisible = _memberPageSize;
        });
        return;
      default:
        final tx = await _api.memberTransactions(id);
        if (!mounted) return;
        setState(() => _transactions = tx);
        return;
    }
  }

  Future<void> _loadTeamSection() async {
    final id = widget.salesmanId;
    switch (_teamTabIndex) {
      case 1:
        final inv = await _api.teamInventory(id);
        if (!mounted) return;
        setState(() {
          _teamInventory = inv;
          _teamInventoryVisible = _inventoryPageSize;
        });
        return;
      case 2:
        final members = await _api.subMembers(salesmanId: id);
        if (!mounted) return;
        setState(() {
          _teamMembers = members;
          _teamMemberVisible = _memberPageSize;
        });
        return;
      default:
        final tx = await _api.teamTransactions(id);
        if (!mounted) return;
        setState(() => _teamTransactions = tx);
        return;
    }
  }

  Future<void> _switchTopTab(int index) async {
    if (_tabIndex == index) return;
    setState(() {
      _tabIndex = index;
      _contentError = null;
    });
    await _loadFocusedSection();
  }

  String _sanitizePhone(String raw) =>
      raw.trim().replaceAll(RegExp(r'[^\d+]'), '');

  Future<void> _openCall(String raw) async {
    final phone = _sanitizePhone(raw);
    if (phone.isEmpty) {
      AppToast.warning(context, 'Thành viên chưa có số điện thoại.');
      return;
    }
    await launchUrl(Uri.parse('tel:$phone'));
  }

  Future<void> _openZalo(String raw) async {
    final phone = _sanitizePhone(raw);
    if (phone.isEmpty) {
      AppToast.warning(context, 'Thành viên chưa có số điện thoại.');
      return;
    }
    await launchUrl(Uri.parse('https://zalo.me/$phone'),
        mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Thông tin đội nhóm',
      action: IconButton(
        tooltip: 'Lịch sử hoạt động',
        onPressed: () => context.push('/team/activity/${widget.salesmanId}'),
        icon: const Icon(Icons.history),
      ),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: AppTypography.body),
            const SizedBox(height: 10),
            TextButton(onPressed: _loadInitialData, child: const Text('Thử lại')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        final results = await Future.wait([
          _api.memberDetail(widget.salesmanId),
          _api.overviewRaw(widget.salesmanId),
        ]);
        if (!mounted) return;
        setState(() {
          _detail = results[0];
          _overview = results[1];
        });
        await _loadFocusedSection();
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _buildProfileCard(),
          const SizedBox(height: 12),
          _buildTopTabs(),
          const SizedBox(height: 12),
          _tabIndex == 0 ? _buildPersonalTab() : _buildTeamTab(),
        ],
      ),
    );
  }

  // ── Profile card ────────────────────────────────────────────────────────────

  Widget _buildProfileCard() {
    final name = readMapStr(_detail, ['name', 'full_name']);
    final titleName = readMapStr(_detail, ['title_name', 'title_code']);
    final phone = readMapStr(_detail, ['phone', 'mobile']);
    final avatar = readMapStr(_detail, ['image', 'avatar']);
    final progressText = readMapStr(_detail, ['title_progress_text']);
    final verified = readMapNum(_detail, ['step']).toInt() == 3;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () => context.push('/team/tree/${widget.salesmanId}'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Sơ đồ đội nhóm',
                        style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 4),
                    const Icon(Icons.account_tree_outlined,
                        size: 15, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          _avatar(avatar, name, verified),
          const SizedBox(height: 10),
          Text(name.isEmpty ? '--' : name,
              textAlign: TextAlign.center,
              style: AppTypography.heading.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              if (titleName.isNotEmpty)
                teamChip(titleName,
                    background: AppColors.primarySoft,
                    foreground: AppColors.primary),
              if (progressText.isNotEmpty)
                teamChip(progressText,
                    background: const Color(0xFFEFFAF1),
                    foreground: const Color(0xFF3A9A58)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    onPressed: () => _openZalo(phone),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline,
                        size: 16, color: Colors.white),
                    label: Text('Nhắn tin',
                        style: AppTypography.body.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: phone.isEmpty ? null : () => _openCall(phone),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 46,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Icon(Icons.phone_outlined,
                      color:
                          phone.isEmpty ? AppColors.textMute : AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatar(String avatar, String name, bool verified) {
    final url = AppConfig.imageUrl(avatar);
    final initial = name.isEmpty ? '?' : name.characters.first.toUpperCase();
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        children: [
          ClipOval(
            child: (url == null || url.isEmpty)
                ? Container(
                    width: 62,
                    height: 62,
                    color: AppColors.primarySoft,
                    alignment: Alignment.center,
                    child: Text(initial,
                        style: AppTypography.heading
                            .copyWith(color: AppColors.primary)),
                  )
                : AppNetworkImage(
                    url: url, width: 62, height: 62, fit: BoxFit.cover),
          ),
          if (verified)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.check, size: 11, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopTabs() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [_topTabItem('Cá nhân', 0), _topTabItem('Đội nhóm', 1)],
      ),
    );
  }

  Widget _topTabItem(String title, int index) {
    final selected = _tabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _switchTopTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: selected
              ? const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColors.primary, width: 2)))
              : null,
          child: Center(
            child: Text(title,
                style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        selected ? AppColors.primary : AppColors.textMute)),
          ),
        ),
      ),
    );
  }

  // ── Personal / Team tabs ────────────────────────────────────────────────────

  Widget _buildPersonalTab() {
    final revenue = _overviewNum(
        ['personal_revenue_total', 'personal_revenue_3m']);
    final txCount = _overviewInt(
        ['personal_deals_total', 'personal_deals_won', 'personal_deals_3m']);
    final invCount = _overviewInt([
      'personal_listings_total',
      'personal_listings_verified',
      'personal_listings_3m'
    ]);
    final memberCount = _overviewInt(
        ['f1_count', 'direct_ctv', 'total_ctv', 'total_descendants']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeamRevenueCard(revenue: revenue),
        const SizedBox(height: 12),
        TeamSummaryTabs(
          activeIndex: _personalTabIndex,
          onChanged: (v) async {
            if (_personalTabIndex == v) return;
            setState(() => _personalTabIndex = v);
            await _loadFocusedSection();
          },
          transactionCount: txCount,
          inventoryCount: invCount,
          memberCount: memberCount,
        ),
        const SizedBox(height: 12),
        _buildSectionContent(personal: true),
      ],
    );
  }

  Widget _buildTeamTab() {
    final revenue = _overviewNum(
        ['team_revenue_total', 'team_revenue_3m', 'total_revenue']);
    final txCount = _overviewInt(
        ['team_deals_total', 'team_deals_won', 'team_deals_3m']);
    final invCount = _overviewInt(
        ['team_listings_total', 'team_listings_3m', 'total_listings']);
    final memberCount =
        _overviewInt(['total_descendants', 'total_ctv', 'direct_ctv']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeamRevenueCard(revenue: revenue),
        const SizedBox(height: 12),
        TeamSummaryTabs(
          activeIndex: _teamTabIndex,
          onChanged: (v) async {
            if (_teamTabIndex == v) return;
            setState(() => _teamTabIndex = v);
            await _loadFocusedSection();
          },
          transactionCount: txCount,
          inventoryCount: invCount,
          memberCount: memberCount,
        ),
        const SizedBox(height: 12),
        _buildSectionContent(personal: false),
      ],
    );
  }

  Widget _buildSectionContent({required bool personal}) {
    if (_contentLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }
    if (_contentError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_contentError!,
                  style: AppTypography.body, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: _loadFocusedSection, child: const Text('Thử lại')),
            ],
          ),
        ),
      );
    }
    final subTab = personal ? _personalTabIndex : _teamTabIndex;
    switch (subTab) {
      case 1:
        return _inventorySection(
          items: personal ? _inventory : _teamInventory,
          visible: personal ? _personalInventoryVisible : _teamInventoryVisible,
          onLoadMore: () => setState(() {
            if (personal) {
              _personalInventoryVisible += _inventoryPageSize;
            } else {
              _teamInventoryVisible += _inventoryPageSize;
            }
          }),
        );
      case 2:
        return _memberSection(
          items: personal ? _subordinates : _teamMembers,
          emptyText: personal
              ? 'Chưa có cấp dưới trực tiếp'
              : 'Chưa có thành viên trong đội',
          visible: personal ? _personalMemberVisible : _teamMemberVisible,
          onLoadMore: () => setState(() {
            if (personal) {
              _personalMemberVisible += _memberPageSize;
            } else {
              _teamMemberVisible += _memberPageSize;
            }
          }),
        );
      default:
        return _transactionSection(
            personal ? _transactions : _teamTransactions);
    }
  }

  Widget _transactionSection(List<Map> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        teamSectionHeader('Danh sách giao dịch'),
        const SizedBox(height: 10),
        if (items.isEmpty)
          teamEmptyCard('Không có giao dịch')
        else
          ...items.take(5).map(teamTransactionCard),
      ],
    );
  }

  Widget _inventorySection({
    required List<Map> items,
    required int visible,
    required VoidCallback onLoadMore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        teamSectionHeader('Danh sách nguồn hàng'),
        const SizedBox(height: 10),
        if (items.isEmpty)
          teamEmptyCard('Không có nguồn hàng')
        else ...[
          ...items.take(visible).map(teamInventoryCard),
          if (visible < items.length) _loadMoreButton(onLoadMore),
        ],
      ],
    );
  }

  Widget _memberSection({
    required List<TeamMemberItem> items,
    required String emptyText,
    required int visible,
    required VoidCallback onLoadMore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        teamSectionHeader('Danh sách thành viên'),
        const SizedBox(height: 10),
        if (items.isEmpty)
          teamEmptyCard(emptyText)
        else ...[
          ...items.take(visible).map((m) => teamMemberCard(
                m,
                onTap: m.salesmanId == 0
                    ? null
                    : () => context.push('/team/member/${m.salesmanId}'),
              )),
          if (visible < items.length) _loadMoreButton(onLoadMore),
        ],
      ],
    );
  }

  Widget _loadMoreButton(VoidCallback onTap) => Center(
        child: TextButton(
          onPressed: onTap,
          child: Text('Xem thêm',
              style: AppTypography.caption.copyWith(color: AppColors.primary)),
        ),
      );

  int _overviewInt(List<String> keys) => readMapNum(_overview, keys).toInt();
  num _overviewNum(List<String> keys) => readMapNum(_overview, keys);
}

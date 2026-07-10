import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/team_api.dart';

const double _kNodeCardWidth = 340;
const double _kTreeCanvasWidth = 900;
const double _kInitialTreeScale = 0.8;

const _neutral50 = Color(0xFFFAFAFA);
const _neutral100 = Color(0xFFF5F5F5);
const _neutral200 = Color(0xFFE5E5E5);
const _neutral300 = Color(0xFFD4D4D4);

/// "Sơ đồ đội nhóm" — mirrors v1 `TeamTreePage`. Two trees: title hierarchy and
/// referral (lifecycle) hierarchy, rendered in a pannable/zoomable canvas.
class TeamTreeScreen extends ConsumerStatefulWidget {
  const TeamTreeScreen({super.key, required this.salesmanId});
  final int salesmanId;

  @override
  ConsumerState<TeamTreeScreen> createState() => _TeamTreeScreenState();
}

class _TeamTreeScreenState extends ConsumerState<TeamTreeScreen> {
  final TransformationController _transform = TransformationController();

  int _selectedTab = 0; // 0 = Sơ đồ danh hiệu, 1 = Sơ đồ vòng đời
  bool _loading = true;
  String? _error;
  TreeNode? _tree;
  final Set<String> _expanded = <String>{};
  bool _shouldFocusRoot = true;

  @override
  void initState() {
    super.initState();
    _transform.value = Matrix4.identity()
      ..scaleByDouble(_kInitialTreeScale, _kInitialTreeScale, 1, 1);
    _loadTree();
  }

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  Future<void> _loadTree() async {
    if (widget.salesmanId == 0) {
      setState(() {
        _loading = false;
        _error = 'Không tìm thấy salesman_id';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = ref.read(teamApiProvider);
      final tree = _selectedTab == 0
          ? await api.titleTree(widget.salesmanId)
          : await api.fullTree(widget.salesmanId);
      if (!mounted) return;
      setState(() {
        _tree = tree;
        _expanded
          ..clear()
          ..addAll(_defaultExpandedKeys(tree));
        _shouldFocusRoot = true;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Không tải được sơ đồ đội nhóm';
      });
    }
  }

  Set<String> _defaultExpandedKeys(TreeNode? root) {
    final keys = <String>{};
    if (root == null) return keys;
    void visit(TreeNode node, int depth) {
      if (node.children.isNotEmpty && depth < 1) keys.add(node.nodeKey);
      for (final c in node.children) {
        visit(c, depth + 1);
      }
    }

    visit(root, 0);
    return keys;
  }

  void _toggleNode(String nodeKey) {
    setState(() {
      if (_expanded.contains(nodeKey)) {
        _expanded.remove(nodeKey);
      } else {
        _expanded.add(nodeKey);
      }
    });
  }

  void _zoom(double factor) {
    final matrix = _transform.value.clone();
    final current = matrix.getMaxScaleOnAxis();
    final next = (current * factor).clamp(0.6, 2.6);
    final delta = next / current;
    _transform.value = matrix..scaleByDouble(delta, delta, 1, 1);
  }

  void _resetView() {
    _shouldFocusRoot = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = context.size;
      if (size == null || size.width <= 0 || size.height <= 0) return;
      _focusRoot(size.width, size.height);
    });
  }

  void _focusRoot(double w, double h) {
    const rootLeftPad = 16.0;
    final rootCenterX = rootLeftPad + (_kNodeCardWidth / 2);
    final tx = (w / 2) - (rootCenterX * _kInitialTreeScale) - 18.0;
    final ty = (h * 0.08).clamp(12.0, 56.0);
    _transform.value = Matrix4.identity()
      ..translateByDouble(tx, ty, 0, 1)
      ..scaleByDouble(_kInitialTreeScale, _kInitialTreeScale, 1, 1);
    _shouldFocusRoot = false;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Sơ đồ đội nhóm',
      action: IconButton(
        tooltip: 'Tải lại',
        onPressed: _loadTree,
        icon: const Icon(Icons.refresh),
      ),
      child: Container(
        color: AppColors.surface,
        child: Column(
          children: [
            _buildTabSelector(),
            const SizedBox(height: 12),
            Text('Cấu trúc trực thuộc',
                style:
                    AppTypography.subtitle.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text('Chạm vào thành viên để xem chi tiết',
                style:
                    AppTypography.caption.copyWith(color: AppColors.textMute)),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.surface,
                        border: Border.all(color: _neutral200),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x10000000),
                              blurRadius: 12,
                              offset: Offset(0, 5)),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(painter: _TreeAxisPainter()),
                            ),
                          ),
                          _buildTreeBody(),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 14,
                      child: Column(
                        children: [
                          _ControlButton(
                              icon: Icons.add, onTap: () => _zoom(1.16)),
                          const SizedBox(height: 10),
                          _ControlButton(
                              icon: Icons.remove, onTap: () => _zoom(0.86)),
                          const SizedBox(height: 10),
                          _ControlButton(
                              icon: Icons.fullscreen, onTap: _resetView),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreeBody() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: AppTypography.body),
            const SizedBox(height: 10),
            TextButton(onPressed: _loadTree, child: const Text('Thử lại')),
          ],
        ),
      );
    }
    if (_tree == null) {
      return Center(
        child: Text('Không có dữ liệu cây',
            style: AppTypography.body.copyWith(color: AppColors.textMute)),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_shouldFocusRoot) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _focusRoot(constraints.maxWidth, constraints.maxHeight);
          });
        }
        return InteractiveViewer(
          transformationController: _transform,
          minScale: 0.6,
          maxScale: 2.6,
          boundaryMargin: const EdgeInsets.all(180),
          constrained: false,
          child: SizedBox(
            width: _kTreeCanvasWidth,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _TreeNodeWidget(
                node: _tree!,
                depth: 0,
                expanded: _expanded,
                onToggle: _toggleNode,
                onOpen: (id) => context.push('/team/member/$id'),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _neutral200)),
      ),
      child: Row(
        children: [
          _tabItem('Sơ đồ danh hiệu', 0),
          _tabItem('Sơ đồ vòng đời', 1),
        ],
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    final selected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          if (_selectedTab == index) return;
          setState(() => _selectedTab = index);
          _loadTree();
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 12, bottom: 10),
          decoration: selected
              ? const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColors.primary, width: 2.4)))
              : null,
          child: Text(title,
              style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.primary : AppColors.textMute)),
        ),
      ),
    );
  }
}

class _TreeNodeWidget extends StatelessWidget {
  const _TreeNodeWidget({
    required this.node,
    required this.depth,
    required this.expanded,
    required this.onToggle,
    required this.onOpen,
  });

  final TreeNode node;
  final int depth;
  final Set<String> expanded;
  final ValueChanged<String> onToggle;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final hasChildren = node.children.isNotEmpty;
    final isExpanded = expanded.contains(node.nodeKey);
    final isRoot = depth == 0;
    final branchColor = depth == 0
        ? AppColors.primary
        : depth.isEven
            ? const Color(0xFF7C3AED)
            : const Color(0xFF2563EB);

    return Padding(
      padding: EdgeInsets.only(left: (depth * 16).toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _nodeCard(context, isRoot: isRoot),
          if (hasChildren) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                width: 36,
                height: 36,
                child: _TreeToggleButton(
                  expanded: isExpanded,
                  onTap: () => onToggle(node.nodeKey),
                  color: branchColor,
                ),
              ),
            ),
          ],
          if (hasChildren && isExpanded) ...[
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.only(left: 23),
              child: SizedBox(
                width: 8,
                height: 16,
                child: CustomPaint(painter: _VerticalArrowPainter()),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              decoration: BoxDecoration(
                color: _neutral50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: branchColor.withValues(alpha: 0.20), width: 1.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: branchColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text('Nhánh cấp ${depth + 1}',
                            style: AppTypography.caption.copyWith(
                                color: branchColor,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  ...node.children.map(
                    (child) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 18,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CustomPaint(
                                painter: _HorizontalArrowPainter(
                                    color:
                                        branchColor.withValues(alpha: 0.9)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10, bottom: 8),
                            child: _TreeNodeWidget(
                              node: child,
                              depth: depth + 1,
                              expanded: expanded,
                              onToggle: onToggle,
                              onOpen: onOpen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _nodeCard(BuildContext context, {required bool isRoot}) {
    final nameStyle = AppTypography.subtitle.copyWith(
        fontWeight: FontWeight.w600,
        color: isRoot ? Colors.white : AppColors.text);
    final subStyle = AppTypography.caption.copyWith(
        color: isRoot ? Colors.white.withValues(alpha: 0.88) : AppColors.textMute);
    final titleStyle = AppTypography.body.copyWith(
        fontWeight: FontWeight.w600,
        color: isRoot ? Colors.white : const Color(0xFFE04A9A));

    return InkWell(
      onTap: () => onOpen(node.salesmanId),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: _kNodeCardWidth,
        constraints: const BoxConstraints(minHeight: 92),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          gradient: isRoot
              ? const LinearGradient(
                  colors: [Color(0xFF8BD5F3), Color(0xFF9AD7E7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: isRoot ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isRoot ? const Color(0xFF5967F6) : _neutral200,
              width: isRoot ? 2 : 1.2),
          boxShadow: const [
            BoxShadow(
                color: Color(0x12000000), blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                    color: Color(0xFF15BCD5), shape: BoxShape.circle),
                child: const Center(
                    child: Icon(Icons.star, size: 10, color: Colors.white)),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(node.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: nameStyle),
                const SizedBox(height: 4),
                Text(node.codeText,
                    textAlign: TextAlign.center, style: subStyle),
                const SizedBox(height: 4),
                Text(node.titleName.toUpperCase(),
                    textAlign: TextAlign.center, style: titleStyle),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_alt_rounded,
                        size: 14,
                        color: isRoot
                            ? Colors.white.withValues(alpha: 0.9)
                            : AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('${node.childrenCount}', style: subStyle),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TreeToggleButton extends StatelessWidget {
  const _TreeToggleButton(
      {required this.expanded, required this.onTap, required this.color});
  final bool expanded;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border:
                Border.all(color: color.withValues(alpha: 0.25), width: 1.2),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x12000000), blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          child: Icon(expanded ? Icons.remove : Icons.add, size: 18, color: color),
        ),
      ),
    );
  }
}

class _VerticalArrowPainter extends CustomPainter {
  const _VerticalArrowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final color = _neutral300.withValues(alpha: 0.9);
    final stroke = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final x = size.width / 2;
    canvas.drawLine(Offset(x, 0), Offset(x, size.height - 6), stroke);
    final arrow = Path()
      ..moveTo(x - 4, size.height - 7)
      ..lineTo(x + 4, size.height - 7)
      ..lineTo(x, size.height - 2)
      ..close();
    canvas.drawPath(arrow, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HorizontalArrowPainter extends CustomPainter {
  const _HorizontalArrowPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * 0.6;
    final stroke = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, y), Offset(size.width - 6, y), stroke);
    final arrow = Path()
      ..moveTo(size.width - 7, y - 4)
      ..lineTo(size.width - 7, y + 4)
      ..lineTo(size.width - 2, y)
      ..close();
    canvas.drawPath(arrow, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _HorizontalArrowPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _neutral200),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x15000000), blurRadius: 8, offset: Offset(0, 4)),
            ],
          ),
          child: Icon(icon, size: 20, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _TreeAxisPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final axis = Paint()
      ..color = _neutral100.withValues(alpha: 0.9)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final tick = Paint()
      ..color = _neutral100.withValues(alpha: 0.75)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    const axisX = 34.0;
    canvas.drawLine(
        const Offset(axisX, 18), Offset(axisX, size.height - 18), axis);
    for (double y = 34; y < size.height - 20; y += 56) {
      canvas.drawLine(Offset(axisX, y), Offset(axisX + 8, y), tick);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

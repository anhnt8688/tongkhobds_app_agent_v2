import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/async_view.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/customers_api.dart';
import '../data/models/customer.dart';

/// v1 `AppColors.red` for the delete swipe action (distinct from v2 danger).
const _v1Red = Color(0xFFFF3B30);

/// "Khách hàng" — agent's customer list, rebuilt to match v1
/// `customer_support_page` exactly: `CustomScreen` shell (thin orange gradient
/// edge + rounded-top body), inline search, avatar rows with a bottom divider,
/// swipe Xoá/Sửa, and a circular add FAB. Logic/providers unchanged.
class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(customerSearchProvider.notifier).state = v.trim();
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(customersProvider);
    await ref.read(customersProvider.future);
  }

  Future<void> _openForm(String route, {Customer? customer}) async {
    final ok = await context.push<bool>(route, extra: customer);
    if (ok == true) ref.invalidate(customersProvider);
  }

  Future<void> _delete(Customer c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xoá khách hàng?'),
        content: Text('Bạn có chắc muốn xoá "${c.name}" không?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Huỷ')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xoá', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(customersApiProvider).delete(c.id);
      if (mounted) AppToast.success(context, 'Đã xoá khách hàng');
      ref.invalidate(customersProvider);
    } on ApiException catch (e) {
      if (mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (mounted) AppToast.error(context, 'Xoá khách hàng thất bại');
    }
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersProvider);
    return CustomScreen(
      title: 'Khách hàng',
      floatingActionButton: FloatingActionButton(
        heroTag: 'customers_add_fab',
        backgroundColor: AppColors.primary,
        onPressed: () => _openForm('/customers/add'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _searchField(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _refresh,
                child: AsyncView<List<Customer>>(
                  value: customers,
                  onRetry: () => ref.invalidate(customersProvider),
                  data: (list) => list.isEmpty ? _empty() : _list(list),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    const radius = BorderRadius.all(Radius.circular(12));
    return TextField(
      controller: _searchCtrl,
      textInputAction: TextInputAction.search,
      onChanged: _onSearchChanged,
      cursorColor: AppColors.primary,
      style: AppTextStyles.semibold(15),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.neutral100,
        hintText: 'Tìm kiếm theo tên, SĐT, Email...',
        hintStyle: AppTextStyles.semibold(15, color: AppColors.neutral400),
        prefixIcon: const Icon(Icons.search, color: AppColors.text),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        border: const OutlineInputBorder(
            borderRadius: radius, borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(
            borderRadius: radius, borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _list(List<Customer> list) => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: list.length,
        itemBuilder: (_, i) => _CustomerRow(
          customer: list[i],
          isLast: i == list.length - 1,
          onTap: () => _openForm('/customers/detail', customer: list[i]),
          onEdit: () => _openForm('/customers/edit', customer: list[i]),
          onDelete: () => _delete(list[i]),
        ),
      );

  Widget _empty() => ListView(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                Image.asset('assets/images/img_no_data.png',
                    width: 150, height: 120),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Text('Không có dữ liệu',
                      style: AppTextStyles.regular(15)),
                ),
              ],
            ),
          ),
        ],
      );
}

/// One customer row (v1 `itemCustomer`): 48px avatar, name + phone stacked with
/// a bottom divider (except the last), and a trailing chevron. Swipe reveals
/// Xoá (red) then Sửa (primary).
class _CustomerRow extends StatelessWidget {
  const _CustomerRow({
    required this.customer,
    required this.isLast,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Customer customer;
  final bool isLast;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(customer.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            icon: Icons.delete,
            backgroundColor: _v1Red,
            foregroundColor: Colors.white,
            autoClose: true,
          ),
          SlidableAction(
            onPressed: (_) => onEdit(),
            icon: Icons.edit,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            autoClose: true,
          ),
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/avatar_default.png',
                width: 48, height: 48),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : const Border(
                          bottom: BorderSide(color: AppColors.neutral200)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.name.isEmpty ? 'N/A' : customer.name,
                        style: AppTextStyles.semibold(15)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.phone,
                            size: 20, color: AppColors.neutral400),
                        const SizedBox(width: 8),
                        Text(customer.phone.isEmpty ? 'N/A' : customer.phone,
                            style: AppTextStyles.regular(13,
                                color: AppColors.neutral400)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_outlined,
                size: 12, color: AppColors.neutral400),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../consultation_sell/data/consultation_sell_api.dart';
import 'post_controller.dart';
import 'steps/step_info.dart';
import 'steps/step_media.dart';
import 'steps/step_review.dart';

/// 3-step "Đăng tin BĐS" wizard: Thông tin → Hình ảnh → Xác nhận.
///
/// [sellLeadId] is set when pushed from a nhu-cầu-bán's "Tin đăng" task — on
/// successful submit the new listing is linked back to that lead and the wizard
/// pops back to its detail screen instead of going to `/home`.
class PostListingScreen extends ConsumerStatefulWidget {
  const PostListingScreen({super.key, this.sellLeadId});
  final int? sellLeadId;

  @override
  ConsumerState<PostListingScreen> createState() => _PostListingScreenState();
}

class _PostListingScreenState extends ConsumerState<PostListingScreen> {
  int _step = 0;
  static const _lastStep = 2;
  // v1 step captions shown in the gradient header.
  static const _titles = [
    'Bước 1: Thông tin BĐS',
    'Bước 2: Đăng hình ảnh, Video',
    'Bước 3: Xác nhận thông tin',
  ];

  @override
  void initState() {
    super.initState();
    final leadId = widget.sellLeadId;
    if (leadId != null) {
      // Deferred: avoid mutating provider state during the first build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(postControllerProvider.notifier).startFromSellLead(leadId);
        }
      });
    }
  }

  void _next() {
    final d = ref.read(postControllerProvider);
    if (_step == 0 && !d.step1Valid) {
      AppToast.warning(context, 'Vui lòng nhập đủ thông tin bắt buộc');
      return;
    }
    if (_step == 1 && !d.step2Valid) {
      AppToast.warning(context, 'Vui lòng đăng tối thiểu 4 hình ảnh');
      return;
    }
    if (_step < _lastStep) setState(() => _step++);
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  Future<void> _submit({required String status}) async {
    final d = ref.read(postControllerProvider);
    // Prefer the widget's own param (set at push time) so linking never depends
    // on the deferred startFromSellLead having run.
    final sellLeadId = widget.sellLeadId ?? d.sellLeadId;
    try {
      final res =
          await ref.read(postControllerProvider.notifier).submit(status: status);
      final id = res.id;
      final salesmanId = res.salesmanId;
      // Gán tin vào nhu cầu bán that launched this wizard (skip for draft —
      // nothing real to link yet). Failure here doesn't block the flow, only
      // softens the success message below (AppToast shows one at a time).
      var linkFailed = false;
      if (sellLeadId != null && status != 'DRAFT' && id > 0) {
        try {
          await ref
              .read(consultationSellApiProvider)
              .linkRealEstate(sellLeadId, id, realEstateSalesmanId: salesmanId);
          ref.invalidate(sellDetailProvider(sellLeadId));
        } catch (_) {
          linkFailed = true;
        }
      }
      if (!mounted) return;
      final okMsg = status == 'DRAFT'
          ? 'Đã lưu bản nháp'
          : d.isEdit
              ? 'Cập nhật thành công'
              : 'Đăng tin thành công${id > 0 ? ' (#$id)' : ''}';
      if (linkFailed) {
        AppToast.warning(context, '$okMsg, nhưng chưa gán được vào nhu cầu');
      } else {
        AppToast.success(context, okMsg);
      }
      // Clear the wizard so re-opening the tab (kept alive by the shell) starts
      // blank instead of showing the post just submitted.
      ref.read(postControllerProvider.notifier).reset();
      setState(() => _step = 0);
      if (sellLeadId != null) {
        // Launched from a lead's "Tin đăng" task — return to its detail
        // instead of the home tab.
        context.canPop() ? context.pop() : context.go('/nhu-cau-ban/$sellLeadId');
      } else {
        context.go('/home');
      }
    } on ApiException catch (e) {
      if (mounted) AppToast.error(context, e.message);
    } catch (_) {
      if (mounted) AppToast.error(context, 'Đăng tin thất bại, thử lại');
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(postControllerProvider);
    return SafeArea(
      top: false,
      bottom: false,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.neutral100, // v1 create page bg
          body: Column(
            children: [
              _GradientHeader(
                pageTitle: draft.isEdit ? 'Sửa tin' : 'Đăng tin',
                step: _step,
                stepTitles: _titles,
                onBack: _back,
              ),
              Expanded(
                child: switch (_step) {
                  0 => const StepInfo(),
                  1 => const StepMedia(),
                  _ => const StepReview(),
                },
              ),
            ],
          ),
          bottomNavigationBar: _Footer(
            step: _step,
            submitting: draft.submitting,
            onSaveDraft: () => _submit(status: 'DRAFT'),
            onNext: _next,
            onSubmit: () => _submit(status: 'PENDING_APPROVAL'),
          ),
        ),
      ),
    );
  }
}

/// v1 `create_news` header: orange gradient holding the centred page title, a
/// rounded back button, the "Bước N: …" caption and a segmented progress bar.
class _GradientHeader extends StatelessWidget {
  const _GradientHeader({
    required this.pageTitle,
    required this.step,
    required this.stepTitles,
    required this.onBack,
  });

  final String pageTitle;
  final int step;
  final List<String> stepTitles;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFF1913D), Color(0xFFF3802F), AppColors.primary],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(pageTitle,
                      style: AppTextStyles.semibold(17, color: Colors.white)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: GestureDetector(
                        onTap: onBack,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFAF9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: FaIcon(FontAwesomeIcons.arrowLeft,
                                size: 16, color: AppColors.text),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stepTitles[step],
                      style: AppTextStyles.semibold(13, color: Colors.white)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      for (var i = 0; i < stepTitles.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: i == step
                                  ? const Color(0xFFFAFAF9)
                                  : const Color(0xFFFAFAF9).withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.step,
    required this.submitting,
    required this.onSaveDraft,
    required this.onNext,
    required this.onSubmit,
  });
  final int step;
  final bool submitting;
  final VoidCallback onSaveDraft;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isLast = step == 2;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      color: AppColors.bg, // v1 footer bg #FAFAF9, no top border
      child: SafeArea(
        top: false,
        child: isLast
            ? AppButton(
                label: 'Đăng tin',
                loading: submitting,
                onPressed: onSubmit,
              )
            : Row(children: [
                Expanded(
                  child: AppButton(
                    label: 'Lưu nháp & thoát',
                    variant: AppButtonVariant.ghost,
                    loading: submitting,
                    onPressed: onSaveDraft,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: AppButton(label: 'Tiếp tục', onPressed: onNext)),
              ]),
      ),
    );
  }
}

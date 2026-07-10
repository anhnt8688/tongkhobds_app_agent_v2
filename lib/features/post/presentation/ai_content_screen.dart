import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/post_api.dart';
import 'post_controller.dart';

/// "Tạo nội dung tự động" — dedicated AI-generation page (parity with v1's
/// `CreateAiPage`). The agent enters a hint + picks length/tone, generates, then
/// edits and taps "Sử dụng" to commit the result back into the listing draft.
class AiContentScreen extends ConsumerStatefulWidget {
  const AiContentScreen({super.key});

  @override
  ConsumerState<AiContentScreen> createState() => _AiContentScreenState();
}

class _AiContentScreenState extends ConsumerState<AiContentScreen> {
  // Option values mirror v1's Length/Tone enums.
  static const _lengths = [
    ('auto', 'Tự động'),
    ('short', 'Ngắn'),
    ('medium', 'Trung bình'),
    ('long', 'Dài'),
  ];
  static const _tones = [
    ('auto', 'Tự động'),
    ('friendly', 'Thân thiện'),
    ('normal', 'Thông thường'),
    ('casual', 'Bạn bè'),
    ('humorous', 'Hóm hỉnh'),
    ('formal', 'Trang trọng'),
    ('complimentary', 'Khen ngợi'),
  ];

  final _hint = TextEditingController();
  final _desc = TextEditingController();
  String _length = 'auto';
  String _tone = 'auto';
  String _html = '';
  bool _hasResult = false;

  @override
  void initState() {
    super.initState();
    _hint.text = ref.read(postControllerProvider).title;
  }

  @override
  void dispose() {
    _hint.dispose();
    _desc.dispose();
    super.dispose();
  }

  PostController get _n => ref.read(postControllerProvider.notifier);

  Future<void> _generate() async {
    final generating = ref.read(postControllerProvider).generating;
    if (generating) return;
    // v1 only requires length/tone (both default to "auto") — the hint is
    // optional, so don't block generation when it's empty.
    AiDescription ai;
    try {
      ai = await _n.generateContent(
        hint: _hint.text.trim(),
        length: _length,
        tone: _tone,
      );
    } on ApiException catch (e) {
      if (mounted) AppToast.error(context, e.message);
      return;
    } catch (e) {
      if (mounted) AppToast.error(context, 'Lỗi tạo nội dung: $e');
      return;
    }
    if (!mounted) return;
    final plain = ai.plainText;
    if (plain.isEmpty) {
      AppToast.warning(context, 'Chưa tạo được nội dung, vui lòng thử lại sau');
      return;
    }
    setState(() {
      _desc.text = plain;
      _html = ai.html;
      _hasResult = true;
      if (ai.title.isNotEmpty) _hint.text = ai.title;
    });
  }

  void _use() {
    _n.applyGeneratedContent(
      plain: _desc.text.trim(),
      html: _html,
      title: _hint.text.trim(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final generating = ref.watch(
        postControllerProvider.select((d) => d.generating));
    return CustomScreen(
      title: 'Tạo nội dung tự động',
      backgroundColor: AppColors.bg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Gợi ý mong muốn của bạn'),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _hint,
                          decoration: const InputDecoration(
                              hintText: 'Nhập gợi ý mong muốn của bạn'),
                        ),
                        const SizedBox(height: 16),
                        if (_hasResult) _resultEditor() else _options(),
                        const SizedBox(height: 16),
                        _generateButton(generating),
                      ],
                    ),
                  ),
                ),
              ),
              if (_hasResult) ...[
                const SizedBox(height: 12),
                AppButton(label: 'Sử dụng', onPressed: _use),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Mô tả chi tiết'),
        const SizedBox(height: 6),
        TextField(
          controller: _desc,
          maxLines: 9,
          decoration:
              const InputDecoration(hintText: 'Nội dung cần viết'),
        ),
      ],
    );
  }

  Widget _options() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Độ dài'),
        const SizedBox(height: 8),
        _chips(_lengths, _length, (v) => setState(() => _length = v)),
        const SizedBox(height: 16),
        _label('Tone'),
        const SizedBox(height: 8),
        _chips(_tones, _tone, (v) => setState(() => _tone = v)),
      ],
    );
  }

  Widget _chips(List<(String, String)> options, String selected,
      ValueChanged<String> onTap) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final (value, label) in options)
          GestureDetector(
            onTap: () => onTap(value),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: value == selected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : const Color(0xFFF5F5F4),
              ),
              child: Text(label,
                  style: AppTextStyles.semibold(15,
                      color: value == selected
                          ? AppColors.primary
                          : AppColors.textSecondary)),
            ),
          ),
      ],
    );
  }

  Widget _generateButton(bool generating) {
    final reWrite = _hasResult;
    return GestureDetector(
      onTap: generating
          ? null
          : (reWrite ? () => setState(() => _hasResult = false) : _generate),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: generating
              ? null
              : const LinearGradient(
                  colors: [Color(0xFFFF5858), Color(0xFFF09819)]),
          color: generating ? AppColors.border : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              reWrite
                  ? 'Viết lại'
                  : (generating ? 'Đang tạo...' : 'Tạo tự động'),
              style: AppTextStyles.semibold(17, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Image.asset('assets/images/ic_ai.png', width: 24, height: 24),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: AppTextStyles.semibold(15));
}

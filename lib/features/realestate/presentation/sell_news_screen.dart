import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/share_util.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/custom_screen.dart';
import '../data/models/sell_news_post.dart';
import '../data/realestate_api.dart';
import 'widgets/sell_news_image_grid.dart';

/// "Đăng bán": fetches per-listing post templates, lets the agent pick a post,
/// edit its content and choose images, then share content + images. Mirrors v1
/// `SellNewsPage`.
class SellNewsScreen extends ConsumerStatefulWidget {
  const SellNewsScreen({
    super.key,
    required this.realEstateId,
    this.fallbackImages = const [],
  });

  final int realEstateId;
  final List<String> fallbackImages;

  @override
  ConsumerState<SellNewsScreen> createState() => _SellNewsScreenState();
}

class _SellNewsScreenState extends ConsumerState<SellNewsScreen> {
  bool _loading = true;
  String? _error;
  List<SellNewsPost> _posts = const [];
  int _index = 0;

  /// Selected image URLs per postId (defaults to all of the post's images).
  final Map<String, Set<String>> _selected = {};

  quill.QuillController _controller = quill.QuillController.basic();
  final _focus = FocusNode();
  final _scroll = ScrollController();
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _bind(_controller);
    _fetch();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final raw = await ref.read(realEstateApiProvider).newsByRealEstate(
            widget.realEstateId,
          );
      final posts = raw
          .map((post) =>
              post.copyWith(images: post.resolvedImages(widget.fallbackImages)))
          .toList();
      _selected
        ..clear()
        ..addEntries(posts.map((p) => MapEntry(p.postId, p.images.toSet())));
      setState(() {
        _posts = posts;
        _index = 0;
        _loading = false;
      });
      _setContent(posts.isEmpty ? '' : posts.first.content);
    } catch (_) {
      setState(() {
        _posts = const [];
        _error = 'Không tải được dữ liệu đăng bán';
        _loading = false;
      });
    }
  }

  // ── editor sync (HTML ⇄ delta) ──

  void _bind(quill.QuillController c) {
    c.addListener(() {
      if (_syncing) return;
      if (_index < 0 || _index >= _posts.length) return;
      final plain = c.document.toPlainText().trimRight();
      final html = plain.isEmpty
          ? ''
          : QuillDeltaToHtmlConverter(c.document.toDelta().toJson()).convert();
      _posts = List.of(_posts)..[_index] = _posts[_index].copyWith(content: html);
    });
  }

  void _setContent(String content) {
    final safe = content.trim();
    quill.Document doc;
    if (safe.isEmpty) {
      doc = quill.Document();
    } else if (RegExp(r'<[^>]+>').hasMatch(safe)) {
      try {
        doc = quill.Document.fromDelta(HtmlToDelta().convert(safe));
      } catch (_) {
        doc = quill.Document()..insert(0, _htmlToText(safe));
      }
    } else {
      doc = quill.Document()..insert(0, safe);
    }
    _syncing = true;
    final old = _controller;
    _controller = quill.QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
    _bind(_controller);
    old.dispose();
    if (mounted) setState(() {});
    _syncing = false;
  }

  String _htmlToText(String html) => html
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</(p|div|h[1-6]|li)\s*>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();

  void _selectPost(int index) {
    if (index == _index || index < 0 || index >= _posts.length) return;
    setState(() => _index = index);
    _setContent(_posts[index].content);
  }

  Future<void> _copyHtml() async {
    if (_index < 0 || _index >= _posts.length) return;
    final html = _posts[_index].content.trim();
    if (html.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: html));
    if (mounted) AppToast.success(context, 'Đã sao chép nội dung');
  }

  void _toggleImage(String postId, String url) {
    setState(() {
      final set = _selected[postId] ??= <String>{};
      set.contains(url) ? set.remove(url) : set.add(url);
    });
  }

  // ── share ──

  Future<List<XFile>> _downloadSelected(SellNewsPost post) async {
    final urls = (_selected[post.postId] ?? const <String>{}).toList()..sort();
    final dir = await getTemporaryDirectory();
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      responseType: ResponseType.bytes,
      headers: const {'accept': '*/*'},
    ));
    final files = <XFile>[];
    for (final url in urls) {
      try {
        final res = await dio.get<List<int>>(url);
        final bytes = res.data;
        if (bytes == null || bytes.isEmpty) continue;
        final ext = p.extension(Uri.tryParse(url)?.path ?? '');
        final name =
            'sell_${post.postId}_${url.hashCode}${ext.isEmpty ? '.jpg' : ext}';
        final file = File(p.join(dir.path, name));
        await file.writeAsBytes(bytes, flush: true);
        files.add(XFile(file.path));
      } catch (_) {
        // skip a failed image
      }
    }
    return files;
  }

  Future<void> _share() async {
    if (_index < 0 || _index >= _posts.length) return;
    final post = _posts[_index];
    final text = _htmlToText(post.content).trim();
    try {
      final files = await _downloadSelected(post);
      if (text.isEmpty && files.isEmpty) {
        if (mounted) {
          AppToast.warning(context, 'Không có nội dung hoặc ảnh để chia sẻ');
        }
        return;
      }
      final subject = post.menuName.isEmpty ? 'Đăng bán' : post.menuName;
      final origin = mounted ? shareOrigin(context) : null;
      if (files.isEmpty) {
        await Share.share(
          text,
          subject: subject,
          sharePositionOrigin: origin,
        );
      } else {
        if (Platform.isAndroid && text.isNotEmpty) {
          await Clipboard.setData(ClipboardData(text: text));
        }
        await Share.shareXFiles(
          files,
          text: text.isEmpty ? null : text,
          subject: subject,
          sharePositionOrigin: origin,
        );
      }
    } catch (_) {
      if (mounted) AppToast.error(context, 'Không thể chia sẻ nội dung');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CustomScreen(
        title: 'Đăng bán',
        backgroundColor: AppColors.bg,
        bottomNavigationBar: _posts.isEmpty
            ? null
            : Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: SafeArea(
                    top: false,
                    child: AppButton(label: 'Chia sẻ', onPressed: _share)),
              ),
        child: _body(),
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(_error!, textAlign: TextAlign.center, style: AppTypography.body),
            const SizedBox(height: 12),
            AppButton(label: 'Thử lại', onPressed: _fetch),
          ]),
        ),
      );
    }
    if (_posts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Chưa có nội dung đăng bán cho bất động sản này.',
              textAlign: TextAlign.center, style: AppTypography.body),
        ),
      );
    }
    final post = _posts[_index];
    return Column(
      children: [
        const SizedBox(height: 16),
        _tabs(),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                      child: Text('Nội dung',
                          style: AppTypography.title.copyWith(fontSize: 16))),
                  TextButton(
                    onPressed: _copyHtml,
                    child: Text('Sao chép',
                        style: AppTypography.body.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                ]),
                _editor(),
                const SizedBox(height: 16),
                Text('Ảnh đi kèm',
                    style: AppTypography.title.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text('Chọn những ảnh muốn chia sẻ. Mặc định đang chọn tất cả.',
                    style: AppTypography.caption),
                const SizedBox(height: 12),
                SellNewsImageGrid(
                  images: post.images,
                  selected: _selected[post.postId] ?? const <String>{},
                  onToggle: (url) => _toggleImage(post.postId, url),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabs() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _posts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final selected = i == _index;
          final name =
              _posts[i].menuName.isEmpty ? 'Mẫu ${i + 1}' : _posts[i].menuName;
          return GestureDetector(
            onTap: () => _selectPost(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              constraints: const BoxConstraints(minWidth: 120),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border),
              ),
              child: Text(name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body.copyWith(
                      color: selected ? Colors.white : AppColors.text,
                      fontWeight: FontWeight.w600)),
            ),
          );
        },
      ),
    );
  }

  Widget _editor() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          quill.QuillSimpleToolbar(
            controller: _controller,
            config: const quill.QuillSimpleToolbarConfig(
              multiRowsDisplay: false,
              showAlignmentButtons: false,
              showCodeBlock: false,
              showInlineCode: false,
              showColorButton: false,
              showBackgroundColorButton: false,
              showFontFamily: false,
              showFontSize: false,
              showSearchButton: false,
              showSubscript: false,
              showSuperscript: false,
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          SizedBox(
            height: 360,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: quill.QuillEditor(
                key: ValueKey(_index),
                controller: _controller,
                focusNode: _focus,
                scrollController: _scroll,
                config: const quill.QuillEditorConfig(
                  placeholder: 'Nhập nội dung đăng bán...',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

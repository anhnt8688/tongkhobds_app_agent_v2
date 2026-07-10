import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/custom_screen.dart';

/// In-app preview for a contract-library attachment (mirrors v1 `FilePreview`).
/// PDF renders inline via Syncfusion; DOC/DOCX via the Google Docs web viewer.
/// A download button saves the file with live progress.
class LibraryFilePreviewScreen extends StatefulWidget {
  const LibraryFilePreviewScreen({
    super.key,
    required this.url,
    required this.name,
    this.forcePdf = false,
  });

  final String url;
  final String name;

  /// Render as a PDF regardless of the URL extension. Contract URLs from the
  /// profile endpoint are generated download links without a `.pdf` suffix, so
  /// the extension sniff would otherwise reject them.
  final bool forcePdf;

  @override
  State<LibraryFilePreviewScreen> createState() =>
      _LibraryFilePreviewScreenState();
}

class _LibraryFilePreviewScreenState extends State<LibraryFilePreviewScreen> {
  WebViewController? _webViewController;
  bool _isLoading = true;
  bool _isDownloading = false;
  bool _downloadSuccess = false;
  double _progress = 0;
  CancelToken _cancelToken = CancelToken();

  String get _ext {
    final idx = widget.url.lastIndexOf('.');
    return idx == -1 ? '' : widget.url.substring(idx + 1).toLowerCase();
  }

  bool get _isDoc => !widget.forcePdf && (_ext == 'doc' || _ext == 'docx');

  @override
  void initState() {
    super.initState();
    if (_isDoc) {
      final viewerUrl =
          'https://docs.google.com/gview?embedded=true&url=${Uri.encodeFull(widget.url)}';
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: (_) => _setLoading(true),
          onPageFinished: (_) => _setLoading(false),
          onWebResourceError: (_) => _setLoading(false),
        ))
        ..loadRequest(Uri.parse(viewerUrl));
      // Fallback: stop the spinner if the viewer stalls.
      Future.delayed(const Duration(seconds: 30), () {
        if (mounted && _isLoading) _setLoading(false);
      });
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _setLoading(false);
      });
    }
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  void _setLoading(bool v) {
    if (mounted) setState(() => _isLoading = v);
  }

  Widget _viewer() {
    if (widget.forcePdf || _ext == 'pdf') {
      return SfPdfViewer.network(
        widget.url,
        onDocumentLoaded: (_) => _setLoading(false),
        onDocumentLoadFailed: (_) => _setLoading(false),
      );
    }
    if (_isDoc && _webViewController != null) {
      return WebViewWidget(controller: _webViewController!);
    }
    return const Center(child: Text('Không hỗ trợ định dạng này.'));
  }

  Future<Directory> _saveDir() async {
    if (Platform.isAndroid) {
      final ext = await getExternalStorageDirectory();
      if (ext != null) {
        final dir = Directory('${ext.path}/Agent');
        if (!await dir.exists()) await dir.create(recursive: true);
        return dir;
      }
    }
    return getApplicationDocumentsDirectory();
  }

  String _sanitized(String base) =>
      base.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');

  Future<void> _download() async {
    try {
      final dir = await _saveDir();
      final ext = _ext.isEmpty ? (widget.forcePdf ? 'pdf' : 'bin') : _ext;
      final fileName = '${_sanitized(widget.name)}.$ext';
      final savePath = '${dir.path}/$fileName';

      setState(() {
        _isDownloading = true;
        _downloadSuccess = false;
        _progress = 0;
      });
      _cancelToken = CancelToken();

      await Dio().download(
        widget.url,
        savePath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total > 0) setState(() => _progress = received / total);
        },
      );

      setState(() => _downloadSuccess = true);
      if (mounted) AppToast.success(context, 'Tải về thành công');
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        if (mounted) AppToast.error(context, 'Đã huỷ tải xuống');
      } else {
        if (mounted) AppToast.error(context, 'Lỗi tải xuống');
      }
      setState(() => _downloadSuccess = false);
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  void _cancelDownload() {
    if (_isDownloading) {
      _cancelToken.cancel('Tải xuống đã bị huỷ');
      setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: widget.name,
      child: Stack(
        children: [
          if (_isLoading)
            _LoadingView()
          else
            Positioned.fill(bottom: 88, child: _viewer()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: AppColors.surface,
              child: AppButton(
                label: _downloadSuccess
                    ? 'Đã tải xong'
                    : _isDownloading
                        ? 'Đang tải...'
                        : 'Tải ${widget.name}',
                loading: _isDownloading,
                onPressed:
                    (_isDownloading || _isLoading) ? null : _download,
              ),
            ),
          ),
          if (_isDownloading) _ProgressOverlay(
            progress: _progress,
            success: _downloadSuccess,
            onCancel: _cancelDownload,
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text('Đang tải tài liệu...', style: AppTextStyles.semibold(16)),
        ],
      ),
    );
  }
}

class _ProgressOverlay extends StatelessWidget {
  const _ProgressOverlay({
    required this.progress,
    required this.success,
    required this.onCancel,
  });

  final double progress;
  final bool success;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final pct = progress.clamp(0.0, 1.0);
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: success ? 1.0 : pct,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        success ? AppColors.success : AppColors.primary),
                  ),
                  success
                      ? const Icon(Icons.check, color: AppColors.success)
                      : Text('${(pct * 100).toInt()}%',
                          style: AppTextStyles.semibold(14,
                              color: AppColors.primary)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(success ? 'Tải về thành công!' : 'Đang tải về...',
                style: AppTextStyles.regular(15)),
            if (!success)
              TextButton(
                onPressed: onCancel,
                child: Text('Hủy',
                    style: AppTextStyles.regular(15, color: AppColors.danger)),
              ),
          ],
        ),
      ),
    );
  }
}

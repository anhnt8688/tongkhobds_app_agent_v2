import 'status_pill.dart';

/// Maps a backend status code/label to a [StatusTone] for pills.
StatusTone toneForStatus(Object? status) {
  final s = status?.toString().toLowerCase() ?? '';
  if (s.contains('thành công') ||
      s.contains('hoàn tất') ||
      s.contains('completed') ||
      s.contains('success') ||
      s.contains('đã duyệt') ||
      s.contains('active')) {
    return StatusTone.green;
  }
  if (s.contains('chờ') || s.contains('pending') || s.contains('xử lý')) {
    return StatusTone.amber;
  }
  if (s.contains('huỷ') ||
      s.contains('hủy') ||
      s.contains('cancel') ||
      s.contains('từ chối') ||
      s.contains('reject')) {
    return StatusTone.red;
  }
  if (s.contains('diễn ra') || s.contains('mới') || s.contains('new')) {
    return StatusTone.blue;
  }
  return StatusTone.neutral;
}

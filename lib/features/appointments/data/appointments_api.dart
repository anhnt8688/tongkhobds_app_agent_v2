import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';
import '../../../core/widgets/status_pill.dart';

/// Appointment lifecycle states — mirrors the v1 app's
/// `StatusTypeAppointment` enum (order matters: it drives the tab order).
enum AppointmentStatus {
  pending('pending', 'Chờ duyệt', StatusTone.amber),
  onHold('on_hold', 'Chờ diễn ra', StatusTone.neutral),
  inProgress('in_progress', 'Đang diễn ra', StatusTone.blue),
  completed('completed', 'Hoàn thành', StatusTone.green),
  cancelled('cancelled', 'Huỷ', StatusTone.red);

  const AppointmentStatus(this.api, this.label, this.tone);
  final String api;
  final String label;
  final StatusTone tone;

  static AppointmentStatus? fromApi(String? v) {
    for (final s in values) {
      if (s.api == v) return s;
    }
    return null;
  }
}

/// An appointment ("lịch hẹn") from `real_estate_appointment.json`. The backend
/// wraps it in a generic "work" object; we keep only the fields the UI needs.
class Appointment {
  const Appointment({
    required this.id,
    this.status,
    this.startedAt,
    this.customerName,
    this.customerPhone,
    this.customerId,
    this.propertyTitle,
    this.propertyAddress,
    this.propertyId,
  });

  final int id;
  final String? status;
  final String? startedAt; // "yyyy-MM-dd HH:mm:ss" or "dd/MM/yyyy HH:mm"
  final String? customerName;
  final String? customerPhone;
  final int? customerId;
  final String? propertyTitle;
  final String? propertyAddress;
  final int? propertyId;

  AppointmentStatus? get statusEnum => AppointmentStatus.fromApi(status);

  String get dateText =>
      (startedAt == null || startedAt!.isEmpty) ? '' : startedAt!.split(' ').first;
  String get timeText {
    if (startedAt == null) return '';
    final parts = startedAt!.split(' ');
    return parts.length > 1 ? parts[1] : '';
  }

  factory Appointment.fromJson(Map d) {
    final customer = d['customer'];
    final re = d['real_estate'] ?? d['realEstate'];

    String? composeAddress() {
      if (re is! Map) return null;
      final street = (re['street_address'] ?? '').toString().trim();
      if (street.isNotEmpty) return street;
      final parts = [re['ward'], re['district'], re['city']]
          .map((e) => (e ?? '').toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      return parts.isEmpty ? null : parts.join(', ');
    }

    return Appointment(
      id: asInt(d['id'] ?? d['appointment_id']),
      status: (d['status'] ?? d['appointment_status'])?.toString(),
      startedAt: (d['started_at'] ?? d['appointment_date'] ?? d['deadline'])
          ?.toString(),
      customerName: customer is Map
          ? (customer['name'] ?? customer['full_name'])?.toString()
          : null,
      customerPhone: customer is Map ? customer['phone']?.toString() : null,
      customerId: customer is Map ? asInt(customer['id']) : null,
      propertyTitle: re is Map ? re['title']?.toString() : null,
      propertyAddress: composeAddress(),
      propertyId: re is Map ? asInt(re['id']) : null,
    );
  }
}

/// Result of a create/update/status mutation.
class AppointmentResult {
  const AppointmentResult({required this.success, this.message});
  final bool success;
  final String? message;
}

class AppointmentsApi {
  AppointmentsApi(this._dio);

  final Dio _dio;

  static const _path = '/real_estate_appointment'; // POST/PUT (no .json)
  static String get _jsonPath => '${AppConfig.agent}/real_estate_appointment.json';

  /// List by status — `data.works[]`.
  Future<List<Appointment>> list({
    required AppointmentStatus status,
    int page = 1,
    int limit = 50,
  }) async {
    final res = await _dio.get(_jsonPath, queryParameters: {
      'page': page,
      'limit': limit,
      'status': status.api,
    });
    final data = res.data;
    final List raw;
    if (data is Map) {
      final inner = data['data'] is Map ? data['data'] as Map : data;
      raw = (inner['works'] ?? inner['items'] ?? inner['data'] ?? []) as List;
    } else if (data is List) {
      raw = data;
    } else {
      raw = const [];
    }
    return raw.whereType<Map>().map(Appointment.fromJson).toList();
  }

  /// Single appointment — `data.work`.
  Future<Appointment> detail(int id) async {
    final res = await _dio.get(_jsonPath, queryParameters: {'id': id});
    final data = res.data;
    final Map work;
    if (data is Map) {
      final inner = data['data'] is Map ? data['data'] as Map : data;
      work = (inner['work'] ?? inner) as Map;
    } else {
      work = const {};
    }
    return Appointment.fromJson(work);
  }

  /// Create a new appointment.
  Future<AppointmentResult> create({
    required int tableId,
    required int customerId,
    required String date, // dd/MM/yyyy
    required String time, // HH:mm
    String tableName = 'real_estate',
  }) async {
    final res = await _dio.post('${AppConfig.agent}$_path', data: {
      'table_id': tableId,
      'table_name': tableName,
      'appointment_date': date,
      'appointment_time': time,
      'customer_id': customerId,
    });
    return _result(res.data);
  }

  /// Edit an existing appointment's date/time.
  Future<AppointmentResult> update({
    required int appointmentId,
    required String date,
    required String time,
    String? status,
  }) async {
    final res = await _dio.put('${AppConfig.agent}$_path', data: {
      'appointment_id': appointmentId,
      if (status != null) 'appointment_status': status,
      'appointment_date': date,
      'appointment_time': time,
    });
    return _result(res.data);
  }

  /// Change status (cancel / complete) with an optional note.
  Future<AppointmentResult> updateStatus({
    required int appointmentId,
    required String status,
    String? note,
  }) async {
    final res = await _dio.put(_jsonPath, data: {
      'appointment_id': appointmentId,
      'appointment_status': status,
      if (note != null && note.isNotEmpty) 'note': note,
    });
    return _result(res.data);
  }

  AppointmentResult _result(Object? data) {
    // After the envelope unwrap, `data` is the inner payload, e.g.
    // {success: true, message: "...", data: {appointment_id, ...}}.
    // success/message live at THIS level — do not dig into the nested `data`.
    if (data is! Map) return const AppointmentResult(success: false);
    final hasSuccess = data.containsKey('success');
    final success = data['success'] == true ||
        data['success'] == 1 ||
        !hasSuccess; // some endpoints omit `success` on a 2xx response
    return AppointmentResult(
      success: success,
      message: data['message']?.toString(),
    );
  }
}

final appointmentsApiProvider =
    Provider<AppointmentsApi>((ref) => AppointmentsApi(ref.watch(dioProvider)));

/// List provider keyed by status (loads the first page; pull-to-refresh
/// re-fetches). Matches the v1 per-tab list.
final appointmentListProvider = FutureProvider.autoDispose
    .family<List<Appointment>, AppointmentStatus>((ref, status) {
  return ref.watch(appointmentsApiProvider).list(status: status);
});

/// Detail provider keyed by appointment id.
final appointmentDetailProvider =
    FutureProvider.autoDispose.family<Appointment, int>((ref, id) {
  return ref.watch(appointmentsApiProvider).detail(id);
});

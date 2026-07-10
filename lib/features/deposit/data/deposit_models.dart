import '../../../core/config/app_config.dart';
import '../../../core/utils/json_parse.dart';

enum DepositStatusEnum { pendingPayment, paid, cancelled, forfeited, refunded }

DepositStatusEnum mapDepositCode(String? code) {
  switch ((code ?? '').toLowerCase()) {
    case 'pending':
    case 'waiting':
    case 'pending_payment':
      return DepositStatusEnum.pendingPayment;
    case 'paid':
    case 'in_progress':
    case 'completed':
      return DepositStatusEnum.paid;
    case 'cancel':
    case 'cancelled':
      return DepositStatusEnum.cancelled;
    case 'forfeited':
    case 'lost':
      return DepositStatusEnum.forfeited;
    case 'refunded':
      return DepositStatusEnum.refunded;
    default:
      return DepositStatusEnum.pendingPayment;
  }
}

extension DepositStatusLabel on DepositStatusEnum {
  String get label => switch (this) {
        DepositStatusEnum.pendingPayment => 'Chờ thanh toán',
        DepositStatusEnum.paid => 'Đã thanh toán',
        DepositStatusEnum.cancelled => 'Đã hủy',
        DepositStatusEnum.forfeited => 'Mất cọc',
        DepositStatusEnum.refunded => 'Hoàn cọc',
      };
}

class DepositStatusGroup {
  final String label;
  final String key;
  final dynamic optionsRaw;
  const DepositStatusGroup(
      {required this.label, required this.key, required this.optionsRaw});

  factory DepositStatusGroup.fromJson(Map j) {
    final raw = j['options'];
    final v = asString(j['value']);
    return DepositStatusGroup(
      label: asString(j['label']),
      key: '${v}_#${_hash(raw)}',
      optionsRaw: raw,
    );
  }

  List<String> get optionsList {
    if (optionsRaw == null) return const [];
    if (optionsRaw is String) {
      final s = (optionsRaw as String).trim();
      return s.isEmpty ? const [] : [s];
    }
    if (optionsRaw is List) {
      return (optionsRaw as List)
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return const [];
  }

  static String _hash(dynamic raw) {
    if (raw == null) return 'none';
    if (raw is List) return raw.map((e) => e.toString()).join('_');
    return raw.toString();
  }
}

class DepositRealEstate {
  final int id;
  final String title;
  final String address;
  final int? price;
  final String? code;
  final String? image;
  const DepositRealEstate(
      {required this.id,
      required this.title,
      required this.address,
      this.price,
      this.code,
      this.image});
  factory DepositRealEstate.fromJson(Map j) => DepositRealEstate(
        id: asInt(j['id']),
        title: asString(j['title']),
        address: asString(j['address']),
        price: asIntOrNull(j['price']),
        code: j['code']?.toString(),
        image: AppConfig.imageUrl(j['image']?.toString()),
      );
}

class DepositCustomer {
  final int id;
  final String name;
  final String phone;
  const DepositCustomer({required this.id, required this.name, required this.phone});
  factory DepositCustomer.fromJson(Map j) => DepositCustomer(
      id: asInt(j['id']), name: asString(j['name']), phone: asString(j['phone']));
}

class DepositWork {
  final int id;
  final String code;
  final String name;
  final String rawStatus;
  final String? statusLabel;
  final String? createdAt;
  final DepositRealEstate estate;
  final DepositCustomer? customer;

  const DepositWork({
    required this.id,
    required this.code,
    required this.name,
    required this.rawStatus,
    required this.statusLabel,
    required this.createdAt,
    required this.estate,
    required this.customer,
  });

  DepositStatusEnum get status => mapDepositCode(rawStatus);
  String get statusText => statusLabel ?? status.label;

  factory DepositWork.fromJson(Map j) => DepositWork(
        id: asInt(j['id']),
        code: asString(j['code']),
        name: asString(j['name']),
        rawStatus: asString(j['status']),
        statusLabel: j['status_label']?.toString(),
        createdAt: j['created_at']?.toString(),
        estate: DepositRealEstate.fromJson(
            j['real_estate_info'] is Map ? j['real_estate_info'] : const {}),
        customer: j['customer_info'] is Map
            ? DepositCustomer.fromJson(j['customer_info'])
            : null,
      );
}

class DepositComment {
  final int id;
  final String content;
  final String? createdAt;
  const DepositComment({required this.id, required this.content, this.createdAt});
  factory DepositComment.fromJson(Map j) => DepositComment(
      id: asInt(j['id']),
      content: asString(j['content']),
      createdAt: j['created_at']?.toString());
}

class DepositDetail {
  final int id;
  final String rawStatus;
  final String? statusLabel;
  final int amount;
  final String? typeName;
  final String? createdAt;
  final DepositRealEstate estate;
  final String? customerName;
  final String? customerPhone;
  final String? waitingTime;
  final String? timePayment;
  final String? timeCancel;
  final int? returnAmount;
  final String? reason;
  final String? qrCodeUrl;
  final List<DepositComment> comments;

  const DepositDetail({
    required this.id,
    required this.rawStatus,
    required this.statusLabel,
    required this.amount,
    required this.typeName,
    required this.createdAt,
    required this.estate,
    required this.customerName,
    required this.customerPhone,
    required this.waitingTime,
    required this.timePayment,
    required this.timeCancel,
    required this.returnAmount,
    required this.reason,
    required this.qrCodeUrl,
    required this.comments,
  });

  DepositStatusEnum get status => mapDepositCode(rawStatus);
  String get statusText => statusLabel ?? status.label;
  bool get canCancel => status == DepositStatusEnum.pendingPayment;

  factory DepositDetail.fromJson(Map j) {
    final w = j['work_info'] is Map ? j['work_info'] as Map : const {};
    final d = j['deposit_info'] is Map ? j['deposit_info'] as Map : const {};
    final ci = j['customer_info'] is Map ? j['customer_info'] as Map : const {};
    return DepositDetail(
      id: asInt(w['id']),
      rawStatus: asString(w['status']),
      statusLabel: w['status_label']?.toString(),
      amount: asInt(d['amount']),
      typeName: (d['type_name'] ?? d['type'])?.toString(),
      createdAt: w['created_at']?.toString(),
      estate: DepositRealEstate.fromJson(
          j['real_estate_info'] is Map ? j['real_estate_info'] : const {}),
      customerName: ci['name']?.toString(),
      customerPhone: ci['phone']?.toString(),
      waitingTime: w['waiting_time']?.toString(),
      timePayment: w['time_payment']?.toString(),
      timeCancel: w['time_cancel']?.toString(),
      returnAmount: asIntOrNull(w['return_amount']),
      reason: w['reason']?.toString(),
      qrCodeUrl: w['qrcode']?.toString(),
      comments: (j['comments'] is List)
          ? (j['comments'] as List)
              .whereType<Map>()
              .map(DepositComment.fromJson)
              .toList()
          : const [],
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/json_parse.dart';
import 'models/loan.dart';
import 'models/loan_bank.dart';
import 'models/loan_calculation.dart';
import 'models/loan_customer.dart';
import 'models/loan_mortgage.dart';
import 'models/loan_package.dart';
import 'models/loan_transaction.dart';

/// Paginated loan list (v1 get_list_loan → {data:[...], total, page}).
class PagedLoans {
  const PagedLoans({required this.items, required this.total, required this.page});
  final List<Loan> items;
  final int total;
  final int page;
}

/// All loan (vay vốn) endpoints under `/api_agent`, matching v1 verbatim.
///
/// Envelope handling: the shared EnvelopeInterceptor unwraps `{status,message,
/// data}` to `data` on success. Endpoints whose real payload lives in `message`
/// (schedule/packages/mortgages/detail) and the create endpoint (which returns
/// both an id and an error message) opt out via `rawEnvelope` and read the map.
class LoanApi {
  LoanApi(this._dio);
  final Dio _dio;

  String get _a => AppConfig.agent;
  Options get _raw => Options(extra: const {'rawEnvelope': true});

  Future<List<LoanBank>> banks({bool loanPackageOnly = true}) async {
    final res = await _dio.get('$_a/get_bank.json',
        queryParameters: loanPackageOnly ? {'isLoanPackage': 'true'} : null);
    return _dataList(res.data).map(LoanBank.fromJson).toList();
  }

  Future<List<LoanPackage>> allPackages() async {
    final res = await _dio.get('$_a/get_all_loan_package.json', options: _raw);
    return _messageList(res.data).map(LoanPackage.fromJson).toList();
  }

  Future<List<LoanPackage>> packagesByBank(int bankId) async {
    final res = await _dio.get('$_a/get_loan_package.json',
        queryParameters: {'bank': bankId}, options: _raw);
    return _messageList(res.data).map(LoanPackage.fromJson).toList();
  }

  Future<List<LoanMortgage>> mortgages() async {
    final res = await _dio.get('$_a/get_loan_mortgage.json', options: _raw);
    return _messageList(res.data).map(LoanMortgage.fromJson).toList();
  }

  Future<List<LoanCustomer>> customers() async {
    final res = await _dio.get('$_a/get_list_customer_transaction.json');
    return _dataList(res.data).map(LoanCustomer.fromJson).toList();
  }

  /// v1 wraps each row as `{transaction: {...}}`; unwrap it here.
  Future<List<LoanTransaction>> transactionsByCustomer(int customerId) async {
    final res = await _dio.get('$_a/get_list_transaction_by_customer.json',
        queryParameters: {'customer_id': customerId});
    return _dataList(res.data)
        .map((e) => LoanTransaction.fromJson(
            e['transaction'] is Map ? e['transaction'] as Map : e))
        .toList();
  }

  Future<LoanCalculation> schedule(Map<String, dynamic> payload) async {
    final res = await _dio.post('$_a/loan_schedule.json', data: payload, options: _raw);
    final msg = res.data is Map ? (res.data as Map)['message'] : null;
    if (msg is Map) return LoanCalculation.fromJson(msg);
    throw ApiException(msg?.toString() ?? 'Không tính được khoản vay');
  }

  /// Create or update (payload carries `id` when editing). Returns the created
  /// id (0 on logical failure) plus the backend message for that case.
  Future<({int id, String? message})> save(Map<String, dynamic> payload) async {
    final res = await _dio.post('$_a/loan_create.json', data: payload, options: _raw);
    final map = res.data is Map ? res.data as Map : const {};
    return (id: asInt(map['data']), message: map['message']?.toString());
  }

  Future<PagedLoans> list({int page = 1, int limit = 20, required String status}) async {
    final res = await _dio.get('$_a/get_list_loan.json',
        queryParameters: {'page': page, 'limit': limit, 'status': status});
    final d = res.data;
    final items = (d is Map && d['data'] is List)
        ? (d['data'] as List).whereType<Map>().map(Loan.fromJson).toList()
        : <Loan>[];
    return PagedLoans(
      items: items,
      total: d is Map ? asInt(d['total']) : 0,
      page: d is Map ? asInt(d['page'], fallback: page) : page,
    );
  }

  Future<Loan> detail(int id) async {
    final res =
        await _dio.get('$_a/get_detail_loan.json', queryParameters: {'id': id}, options: _raw);
    final msg = res.data is Map ? (res.data as Map)['message'] : null;
    if (msg is Map) return Loan.fromJson(msg);
    throw ApiException('Không tìm thấy hồ sơ');
  }

  Future<void> delete(int id) async {
    await _dio.delete('$_a/loan_delete.json', data: {'id': id});
  }

  /// Envelope-unwrapped list payload (a bare List, or a Map with a `data` list).
  List<Map> _dataList(Object? d) {
    if (d is List) return d.whereType<Map>().toList();
    if (d is Map && d['data'] is List) {
      return (d['data'] as List).whereType<Map>().toList();
    }
    return const [];
  }

  /// Raw-envelope list payload carried under `message`.
  List<Map> _messageList(Object? d) {
    if (d is Map && d['message'] is List) {
      return (d['message'] as List).whereType<Map>().toList();
    }
    if (d is List) return d.whereType<Map>().toList();
    return const [];
  }
}

final loanApiProvider =
    Provider<LoanApi>((ref) => LoanApi(ref.watch(dioProvider)));

/// Bumped after a create/edit/delete so the profile list + detail refetch
/// (replaces v1's global `LoanEvent` EventBus).
final loanRefreshProvider = StateProvider<int>((ref) => 0);

// Read-only picker/hub data.
final loanBanksProvider = FutureProvider.autoDispose<List<LoanBank>>(
    (ref) => ref.watch(loanApiProvider).banks());
final loanAllPackagesProvider = FutureProvider.autoDispose<List<LoanPackage>>(
    (ref) => ref.watch(loanApiProvider).allPackages());
final loanPackagesByBankProvider =
    FutureProvider.autoDispose.family<List<LoanPackage>, int>(
        (ref, bankId) => ref.watch(loanApiProvider).packagesByBank(bankId));
final loanMortgagesProvider = FutureProvider.autoDispose<List<LoanMortgage>>(
    (ref) => ref.watch(loanApiProvider).mortgages());
final loanCustomersProvider = FutureProvider.autoDispose<List<LoanCustomer>>(
    (ref) => ref.watch(loanApiProvider).customers());
final loanDetailProvider = FutureProvider.autoDispose.family<Loan, int>(
    (ref, id) => ref.watch(loanApiProvider).detail(id));

/// Normalized error type for all API failures.
class ApiException implements Exception {
  ApiException(
    this.message, {
    this.statusCode,
    this.unauthorized = false,
  });

  /// Human-readable message (Vietnamese, from backend when available).
  final String message;

  /// HTTP status code, when applicable.
  final int? statusCode;

  /// True when the failure is an authentication problem (HTTP 401 or an
  /// envelope error indicating the session is invalid/expired).
  final bool unauthorized;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

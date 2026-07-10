/// Global app configuration: backend host, namespaces, timeouts.
class AppConfig {
  AppConfig._();

  /// Default backend base URL (without trailing slash).
  static const String defaultBaseUrl = 'https://quanly.tongkhobds.com/tongkho';

  /// Preset domains shown in the in-app domain switcher (matches v1).
  static const List<String> domains = [
    'https://quanly.tongkhobds.com/tongkho',
    'https://devquanly.tongkhobds.com/tongkho',
    'https://nentang.tongkhobds.com/tongkho',
  ];

  /// Active backend base URL — overridable at runtime via the domain switcher.
  static String _baseUrl = defaultBaseUrl;
  static String get baseUrl => _baseUrl;
  static void setBaseUrl(String url) => _baseUrl = url;

  // API namespaces (appended to [baseUrl]).
  static const String agent = '/api_agent';
  static const String customer = '/api_customer';
  static const String common = '/api_common';
  static const String public = '/api';
  static const String global = '/api_global';

  /// Host that serves uploaded images — derived from the active [baseUrl] origin.
  static String get imageBase => Uri.parse(_baseUrl).origin;

  /// Public website used to build shareable links from a property slug.
  static const String webBase = 'https://tongkhobds.com';

  /// RocketChat host for the messaging feature (separate from the app backend).
  static const String rocketHost = 'https://noxh.tongkhobds.com';
  static const String rocketApi = '$rocketHost/api/v1';
  static const String rocketWs = 'wss://noxh.tongkhobds.com/websocket';

  /// E-learning (LMS) entry point opened in the in-app webview (matches v1).
  static const String eLearningUrl =
      'https://lms.tongkhobds.com/m/lessons/cmmsyly9d000c01oh2oo853u9';

  /// Resolves a possibly-relative image path to an absolute URL.
  static String? imageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return imageBase + (path.startsWith('/') ? path : '/$path');
  }

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Default page size for paginated lists.
  static const int pageSize = 20;
}

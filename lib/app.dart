import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/notifications/notification_deep_link.dart';
import 'core/notifications/push_messaging.dart';
import 'core/router/app_router.dart';
import 'core/services/activity_pinger.dart';
import 'core/theme/app_theme.dart';

class TongkhoApp extends ConsumerStatefulWidget {
  const TongkhoApp({super.key});

  @override
  ConsumerState<TongkhoApp> createState() => _TongkhoAppState();
}

class _TongkhoAppState extends ConsumerState<TongkhoApp> {
  @override
  void initState() {
    super.initState();
    // After the first frame the router is live — start FCM and route any
    // tapped notification through the deep-link handler.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PushMessaging.instance.init((data) {
        NotificationDeepLink.handle(ref.read(routerProvider), data);
      });
      // Start the activity heartbeat (v1 SessionPinger).
      ref.read(activityPingerProvider).boot();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'TongkhoBDS Agent',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
      locale: const Locale('vi'),
      supportedLocales: const [Locale('vi'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
    );
  }
}

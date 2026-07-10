import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Bottom-nav tab routes use `go` (switch tab); everything else is `push`ed
/// on top. Shared by the home screen and its section widgets.
const shellRoutes = {'/home', '/search', '/post', '/notifications', '/profile'};

void navTo(BuildContext context, String route) {
  if (shellRoutes.contains(route)) {
    context.go(route);
  } else {
    context.push(route);
  }
}

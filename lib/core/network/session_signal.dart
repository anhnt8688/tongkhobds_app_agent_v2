import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A monotonically increasing counter bumped whenever an authenticated request
/// fails with 401 / an expired session. The auth layer listens to this and
/// forces a logout, keeping the network layer decoupled from feature code.
final sessionExpiredProvider = StateProvider<int>((ref) => 0);

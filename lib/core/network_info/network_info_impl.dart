import 'package:injectable/injectable.dart';

import 'network_info.dart';

/// Placeholder: wire `connectivity_plus` or similar when needed.
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}

import 'package:injectable/injectable.dart';

import '../../../../core/network/api_envelope.dart';
import '../data_provider/calculator_config_local_data_provider.dart';
import '../data_provider/calculator_config_remote_data_provider.dart';
import '../models/calculator_config.dart';

abstract class CalculatorConfigRepository {
  /// The last config saved on this device, if any.
  Future<CalculatorConfig?> readCached();

  /// Fetches the live config and saves it. Throws [ApiException].
  Future<CalculatorConfig> fetchLatest();
}

@LazySingleton(as: CalculatorConfigRepository)
class CalculatorConfigRepositoryImpl implements CalculatorConfigRepository {
  CalculatorConfigRepositoryImpl(this._remote, this._local);

  final CalculatorConfigRemoteDataProvider _remote;
  final CalculatorConfigLocalDataProvider _local;

  @override
  Future<CalculatorConfig?> readCached() async {
    final json = await _local.readConfig();
    if (json == null) return null;
    try {
      return CalculatorConfig.fromJson(json);
    } on FormatException {
      return null;
    }
  }

  @override
  Future<CalculatorConfig> fetchLatest() async {
    final json = await _remote.fetchConfig();
    final config = await guardApi(() async => CalculatorConfig.fromJson(json));
    await _local.saveConfig(json);
    return config;
  }
}

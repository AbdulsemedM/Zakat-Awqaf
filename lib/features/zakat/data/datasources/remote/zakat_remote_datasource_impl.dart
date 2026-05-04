import 'package:injectable/injectable.dart';

import 'zakat_remote_datasource.dart';

@LazySingleton(as: ZakatRemoteDataSource)
class ZakatRemoteDataSourceImpl implements ZakatRemoteDataSource {
  @override
  Future<Map<String, dynamic>> fetchSummary() async {
    return {'id': 'local', 'amount': 0.0, 'currency': 'SAR'};
  }
}

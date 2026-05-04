import 'package:injectable/injectable.dart';

import 'zakat_local_datasource.dart';

@LazySingleton(as: ZakatLocalDataSource)
class ZakatLocalDataSourceImpl implements ZakatLocalDataSource {}

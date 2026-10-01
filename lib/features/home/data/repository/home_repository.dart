import 'package:injectable/injectable.dart';

import '../data_provider/home_remote_data_provider.dart';
import '../models/home_summary.dart';
import '../models/zakat_al_fitr_season.dart';

abstract class HomeRepository {
  Future<HomeSummary> fetchSummary({required String lang});

  Future<ZakatAlFitrSeason?> fetchCurrentFitrSeason({required String lang});
}

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remote);

  final HomeRemoteDataProvider _remote;

  @override
  Future<HomeSummary> fetchSummary({required String lang}) {
    return _remote.fetchSummary(lang: lang);
  }

  @override
  Future<ZakatAlFitrSeason?> fetchCurrentFitrSeason({required String lang}) {
    return _remote.fetchCurrentFitrSeason(lang: lang);
  }
}

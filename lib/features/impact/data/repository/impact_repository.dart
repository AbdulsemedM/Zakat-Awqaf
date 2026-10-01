import 'package:injectable/injectable.dart';

import '../data_provider/impact_remote_data_provider.dart';
import '../models/impact_model.dart';

abstract class ImpactRepository {
  Future<ImpactSummary> fetchSummary({
    String? regionCode,
    required String lang,
  });

  Future<List<ImpactRegion>> fetchRegions({required String lang});

  Future<List<ImpactStory>> fetchStories({required String lang});

  Future<ImpactStory> fetchStory(String id, {required String lang});
}

@LazySingleton(as: ImpactRepository)
class ImpactRepositoryImpl implements ImpactRepository {
  ImpactRepositoryImpl(this._remote);

  /// Stories shown in the row on the impact screen.
  static const _storiesLimit = 10;

  final ImpactRemoteDataProvider _remote;

  @override
  Future<ImpactSummary> fetchSummary({
    String? regionCode,
    required String lang,
  }) {
    return _remote.fetchSummary(regionCode: regionCode, lang: lang);
  }

  @override
  Future<List<ImpactRegion>> fetchRegions({required String lang}) {
    return _remote.fetchRegions(lang: lang);
  }

  @override
  Future<List<ImpactStory>> fetchStories({required String lang}) {
    return _remote.fetchStories(limit: _storiesLimit, lang: lang);
  }

  @override
  Future<ImpactStory> fetchStory(String id, {required String lang}) {
    return _remote.fetchStory(id, lang: lang);
  }
}

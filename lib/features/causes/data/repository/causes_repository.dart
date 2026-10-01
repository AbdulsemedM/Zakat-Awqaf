import 'package:injectable/injectable.dart';

import '../data_provider/causes_remote_data_provider.dart';
import '../models/cause.dart';

abstract class CausesRepository {
  Future<CausesPage> fetchCauses({
    CauseStatus status,
    bool urgentOnly,
    bool acceptsZakatOnly,
    CauseCategory? category,
    int page,
    int limit,
    required String lang,
  });

  Future<CauseDetail> fetchCause(String id, {required String lang});
}

@LazySingleton(as: CausesRepository)
class CausesRepositoryImpl implements CausesRepository {
  CausesRepositoryImpl(this._remote);

  final CausesRemoteDataProvider _remote;

  @override
  Future<CausesPage> fetchCauses({
    CauseStatus status = CauseStatus.active,
    bool urgentOnly = false,
    bool acceptsZakatOnly = false,
    CauseCategory? category,
    int page = 1,
    int limit = 20,
    required String lang,
  }) {
    return _remote.fetchCauses(
      status: status,
      urgentOnly: urgentOnly,
      acceptsZakatOnly: acceptsZakatOnly,
      category: category,
      page: page,
      limit: limit,
      lang: lang,
    );
  }

  @override
  Future<CauseDetail> fetchCause(String id, {required String lang}) {
    return _remote.fetchCause(id, lang: lang);
  }
}

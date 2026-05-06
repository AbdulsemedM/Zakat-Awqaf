import 'package:injectable/injectable.dart';

import '../data_provider/impact_data_provider.dart';
import '../models/impact_model.dart';
import 'impact_repository.dart';

@LazySingleton(as: ImpactRepository)
class ImpactRepositoryImpl implements ImpactRepository {
  ImpactRepositoryImpl(this._dataProvider);

  final ImpactDataProvider _dataProvider;

  @override
  Future<ImpactModel> loadImpact() => _dataProvider.fetchImpact();
}

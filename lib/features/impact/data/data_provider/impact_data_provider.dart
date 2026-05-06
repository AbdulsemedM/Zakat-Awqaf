import '../models/impact_model.dart';

abstract class ImpactDataProvider {
  Future<ImpactModel> fetchImpact();
}

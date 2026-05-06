import '../models/impact_model.dart';

abstract class ImpactRepository {
  Future<ImpactModel> loadImpact();
}

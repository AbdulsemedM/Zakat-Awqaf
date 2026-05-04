abstract class ImpactRepository {
  Future<List<ImpactItem>> listImpact();
}

class ImpactItem {
  const ImpactItem(this.label);

  final String label;
}

enum AsnafCategory {
  fakir,
  miskin,
  amil,
  muallaf,
  riqab,
  gharimin,
  fisabilillah,
  ibnSabil,
}

extension AsnafCategoryApi on AsnafCategory {
  String get apiValue => switch (this) {
        AsnafCategory.ibnSabil => 'ibn_sabil',
        _ => name,
      };

  String get label => switch (this) {
        AsnafCategory.fakir => 'Fakir',
        AsnafCategory.miskin => 'Miskin',
        AsnafCategory.amil => 'Amil',
        AsnafCategory.muallaf => 'Muallaf',
        AsnafCategory.riqab => 'Riqab',
        AsnafCategory.gharimin => 'Gharimin',
        AsnafCategory.fisabilillah => 'Fisabilillah',
        AsnafCategory.ibnSabil => 'Ibnus Sabil',
      };

  static AsnafCategory? fromApiValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final normalized = value.trim().toLowerCase();
    for (final category in AsnafCategory.values) {
      if (category.apiValue == normalized) {
        return category;
      }
    }
    return null;
  }
}

enum InstitutionSubtype {
  company,
  ngo,
  government,
  cooperative,
  other;

  String get apiValue => name;

  String get label => switch (this) {
        InstitutionSubtype.company => 'Company',
        InstitutionSubtype.ngo => 'NGO',
        InstitutionSubtype.government => 'Government',
        InstitutionSubtype.cooperative => 'Cooperative',
        InstitutionSubtype.other => 'Other',
      };

  static InstitutionSubtype? fromApiValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final normalized = value.trim().toLowerCase();
    for (final subtype in InstitutionSubtype.values) {
      if (subtype.apiValue == normalized) {
        return subtype;
      }
    }
    return null;
  }
}

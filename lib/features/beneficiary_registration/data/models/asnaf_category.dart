enum AsnafCategory {
  poor,
  needy,
  zakatAdministrator,
  muallaf,
  freeingCaptives,
  debtor,
  fiSabilillah,
  strandedTraveler,
}

extension AsnafCategoryApi on AsnafCategory {
  String get apiValue => switch (this) {
        AsnafCategory.poor => 'poor',
        AsnafCategory.needy => 'needy',
        AsnafCategory.zakatAdministrator => 'zakat_administrator',
        AsnafCategory.muallaf => 'muallaf',
        AsnafCategory.freeingCaptives => 'freeing_captives',
        AsnafCategory.debtor => 'debtor',
        AsnafCategory.fiSabilillah => 'fi_sabilillah',
        AsnafCategory.strandedTraveler => 'stranded_traveler',
      };

  String get label => switch (this) {
        AsnafCategory.poor => 'Poor',
        AsnafCategory.needy => 'Needy',
        AsnafCategory.zakatAdministrator => 'Zakat Administrator',
        AsnafCategory.muallaf => 'Muallaf',
        AsnafCategory.freeingCaptives => 'Freeing Captives',
        AsnafCategory.debtor => 'Debtor',
        AsnafCategory.fiSabilillah => 'Fi Sabilillah',
        AsnafCategory.strandedTraveler => 'Stranded Traveler',
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

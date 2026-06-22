/// Selectable option for searchable donation address pickers.
class DonationPickerOption {
  const DonationPickerOption({
    required this.value,
    required this.label,
    this.keywords = const [],
  });

  /// Value sent to the API (e.g. ISO country code or state abbreviation).
  final String value;

  /// Primary display label.
  final String label;

  /// Extra strings matched during search (e.g. abbreviations).
  final List<String> keywords;

  String get searchBlob =>
      '${label.toLowerCase()} ${value.toLowerCase()} ${keywords.join(' ').toLowerCase()}';

  bool matchesQuery(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return searchBlob.contains(q);
  }
}

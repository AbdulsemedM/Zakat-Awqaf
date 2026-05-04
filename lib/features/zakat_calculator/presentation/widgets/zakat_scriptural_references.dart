enum ScripturalSource { quran, hadith }

final class ScripturalReference {
  const ScripturalReference({
    required this.source,
    required this.citation,
    required this.summary,
  });

  final ScripturalSource source;
  final String citation;
  final String summary;
}

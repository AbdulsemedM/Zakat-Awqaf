class InstitutionKycDocument {
  const InstitutionKycDocument({
    required this.code,
    required this.label,
    required this.required,
    required this.uploaded,
  });

  final String code;
  final String label;
  final bool required;
  final bool uploaded;

  factory InstitutionKycDocument.fromJson(Map<String, dynamic> json) {
    return InstitutionKycDocument(
      code: json['code']?.toString() ?? '',
      label: json['label'] as String? ?? '',
      required: json['required'] == true,
      uploaded: json['uploaded'] == true,
    );
  }
}

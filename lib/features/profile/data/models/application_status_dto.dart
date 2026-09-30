/// `GET /api/beneficiaries/v1/me/application`.
///
/// The response shape is not documented yet, so common key names are read
/// defensively. It never contains score, risk or assessment data.
class ApplicationStatusDto {
  const ApplicationStatusDto({
    this.status,
    this.branchName,
    this.submittedAt,
    this.message,
  });

  final String? status;
  final String? branchName;
  final DateTime? submittedAt;
  final String? message;

  factory ApplicationStatusDto.fromJson(Map<String, dynamic> json) {
    String? text(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
      return null;
    }

    final branch = json['branch'];
    final branchName = text(const ['branchName']) ??
        (branch is Map ? branch['name']?.toString() : null);
    final submitted =
        text(const ['submittedAt', 'appliedAt', 'registeredAt', 'createdAt']);

    return ApplicationStatusDto(
      status: text(const [
        'status',
        'applicationStatus',
        'verificationStatus',
        'caseStatus',
      ]),
      branchName: branchName,
      submittedAt: submitted == null ? null : DateTime.tryParse(submitted),
      message: text(const ['message', 'statusMessage', 'description']),
    );
  }
}

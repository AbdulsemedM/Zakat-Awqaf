/// Whether Fayda identity verification is far enough to set a password.
bool isFaydaVerificationReady({
  String? passwordSetupToken,
  String? verificationStatus,
}) {
  final token = passwordSetupToken?.trim() ?? '';
  if (token.isNotEmpty) {
    return true;
  }
  final status = (verificationStatus ?? '').toLowerCase();
  if (status.isEmpty) {
    return true;
  }
  return status == 'verified' ||
      status == 'complete' ||
      status == 'completed' ||
      status == 'success';
}

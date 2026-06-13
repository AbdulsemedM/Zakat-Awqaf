/// Whether Fayda identity verification is far enough to set a password.
bool isFaydaVerificationReady({String? passwordSetupToken}) {
  final token = passwordSetupToken?.trim() ?? '';
  return token.isNotEmpty;
}

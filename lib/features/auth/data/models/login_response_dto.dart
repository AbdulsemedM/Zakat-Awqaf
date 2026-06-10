class LoginResponseDto {
  const LoginResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
    required this.passwordChangeRequired,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 0,
      tokenType: json['tokenType']?.toString() ?? 'Bearer',
      passwordChangeRequired: json['passwordChangeRequired'] == true,
    );
  }

  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;
  final bool passwordChangeRequired;
}

import 'package:equatable/equatable.dart';

/// A row of `GET /api/beneficiaries/v1/payout-banks`. Only [available]
/// banks can be saved; the others are shown as "Coming soon".
class PayoutBank extends Equatable {
  const PayoutBank({
    required this.code,
    required this.name,
    required this.available,
    this.accountNumberPattern,
  });

  /// Sent as `bankCode`, e.g. `coop_bank_of_oromia`.
  final String code;
  final String name;
  final bool available;

  /// e.g. `^\d{6,30}$`, checked after spaces and dashes are removed.
  final String? accountNumberPattern;

  factory PayoutBank.fromJson(Map<String, dynamic> json) {
    final code = json['code']?.toString() ?? '';
    return PayoutBank(
      code: code,
      name: json['name']?.toString() ?? code,
      available: json['available'] == true,
      accountNumberPattern: json['accountNumberPattern']?.toString(),
    );
  }

  /// [input] as the server stores it: spaces and dashes removed.
  static String normalizeAccountNumber(String input) =>
      input.replaceAll(RegExp(r'[\s-]'), '');

  /// Whether [accountNumber] (already normalized) fits this bank's rule. A
  /// missing or malformed pattern is left to the server.
  bool acceptsAccountNumber(String accountNumber) {
    final pattern = accountNumberPattern;
    if (accountNumber.isEmpty) return false;
    if (pattern == null || pattern.isEmpty) return true;
    try {
      return RegExp(pattern).hasMatch(accountNumber);
    } on FormatException {
      return true;
    }
  }

  @override
  List<Object?> get props => [code, name, available, accountNumberPattern];
}

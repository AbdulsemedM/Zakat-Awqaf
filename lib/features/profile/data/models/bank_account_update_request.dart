/// Body of `PUT /api/beneficiaries/v1/me/bank-account`. The bank name comes
/// from [bankCode] on the server.
class BankAccountUpdateRequest {
  const BankAccountUpdateRequest({
    required this.bankCode,
    required this.accountNumber,
  });

  final String bankCode;
  final String accountNumber;

  Map<String, dynamic> toJson() => {
    'bankCode': bankCode,
    'accountNumber': accountNumber,
  };
}

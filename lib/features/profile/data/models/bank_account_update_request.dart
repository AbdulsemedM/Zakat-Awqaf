class BankAccountUpdateRequest {
  const BankAccountUpdateRequest({
    required this.bankName,
    required this.accountNumber,
  });

  final String bankName;
  final String accountNumber;

  Map<String, dynamic> toJson() => {
        'bankName': bankName,
        'accountNumber': accountNumber,
      };
}

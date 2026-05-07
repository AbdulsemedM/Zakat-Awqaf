enum ZakatCheckoutMethod {
  coopBankAlhuda,
  telebirr,
  cbeBirr,
  mPesa,
  cbe,
  zamzamBank,
}

extension ZakatCheckoutMethodLabel on ZakatCheckoutMethod {
  String get label => switch (this) {
    ZakatCheckoutMethod.telebirr => 'Telebirr Quick-Pay',
    ZakatCheckoutMethod.cbeBirr => 'CBE Birr',
    ZakatCheckoutMethod.mPesa => 'M-Pesa',
    ZakatCheckoutMethod.coopBankAlhuda => 'Coop Bank Alhuda',
    ZakatCheckoutMethod.cbe => 'CBE',
    ZakatCheckoutMethod.zamzamBank => 'Zamzam Bank',
  };

  String get subtitle => switch (this) {
    ZakatCheckoutMethod.telebirr => 'Instant mobile wallet transfer.',
    ZakatCheckoutMethod.cbeBirr => 'Direct from Commercial Bank of Ethiopia.',
    ZakatCheckoutMethod.mPesa => 'Safaricom mobile money payment.',
    ZakatCheckoutMethod.coopBankAlhuda => 'Islamic banking channel payment.',
    ZakatCheckoutMethod.cbe => 'Pay directly with CBE account.',
    ZakatCheckoutMethod.zamzamBank => 'Sharia-compliant transfer option.',
  };
}

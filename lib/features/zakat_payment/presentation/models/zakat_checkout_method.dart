enum ZakatCheckoutMethod {
  telebirr,
  cbeBirr,
  mPesa,
}

extension ZakatCheckoutMethodLabel on ZakatCheckoutMethod {
  String get label => switch (this) {
    ZakatCheckoutMethod.telebirr => 'Telebirr Quick-Pay',
    ZakatCheckoutMethod.cbeBirr => 'CBE Birr',
    ZakatCheckoutMethod.mPesa => 'M-Pesa',
  };

  String get subtitle => switch (this) {
    ZakatCheckoutMethod.telebirr => 'Instant mobile wallet transfer.',
    ZakatCheckoutMethod.cbeBirr => 'Direct from Commercial Bank of Ethiopia.',
    ZakatCheckoutMethod.mPesa => 'Safaricom mobile money payment.',
  };
}

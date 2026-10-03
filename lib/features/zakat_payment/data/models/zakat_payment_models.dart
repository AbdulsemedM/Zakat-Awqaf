import 'package:equatable/equatable.dart';

import '../../../../core/network/api_envelope.dart';

/// `GET /api/payments/v1/methods?purpose=zakat`.
class PaymentMethod extends Equatable {
  const PaymentMethod({
    required this.code,
    required this.label,
    this.subtitle,
    this.logoUrl,
    required this.available,
    this.unavailableReason,
    this.minAmountEtb,
    this.maxAmountEtb,
    this.flow,
  });

  final String code;
  final String label;
  final String? subtitle;
  final String? logoUrl;
  final bool available;
  final String? unavailableReason;
  final double? minAmountEtb;
  final double? maxAmountEtb;

  /// `account_otp`: account number, then confirm, then OTP. The only flow
  /// the app supports today.
  final String? flow;

  bool get isAccountOtp => flow == 'account_otp';

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    code: jsonString(json['code']) ?? '',
    label: jsonString(json['label']) ?? jsonString(json['code']) ?? '',
    subtitle: jsonString(json['subtitle']),
    logoUrl: jsonString(json['logoUrl']),
    available: json['available'] == true,
    unavailableReason: jsonString(json['unavailableReason']),
    minAmountEtb: jsonDouble(json['minAmountEtb']),
    maxAmountEtb: jsonDouble(json['maxAmountEtb']),
    flow: jsonString(json['flow']),
  );

  @override
  List<Object?> get props => [
    code,
    label,
    subtitle,
    logoUrl,
    available,
    unavailableReason,
    minAmountEtb,
    maxAmountEtb,
    flow,
  ];
}

/// `zakatType` sent with a payment.
enum ZakatType { wealth, livestock, crops, general, fitr }

enum PaymentStatus { pending, succeeded, failed, cancelled, expired }

/// Which screen a `pending` payment is on. Absent once the payment is final.
enum PaymentStep { confirmAccount, enterOtp, processing }

/// The response of every zakat payment call.
class ZakatPayment extends Equatable {
  const ZakatPayment({
    required this.paymentId,
    required this.status,
    this.step,
    this.zakatType,
    required this.amountEtb,
    this.causeId,
    this.causeTitle,
    this.methodLabel,
    this.accountNumber,
    this.accountHolderName,
    this.otpExpiresAt,
    this.otpAttemptsLeft,
    this.otpResendsLeft,
    this.expiresAt,
    this.createdAt,
    this.guestToken,
    this.providerReference,
    this.paidAt,
    this.certificateId,
    this.failureReason,
  });

  final String paymentId;
  final PaymentStatus status;
  final PaymentStep? step;
  final String? zakatType;
  final double amountEtb;
  final String? causeId;
  final String? causeTitle;
  final String? methodLabel;

  /// Masked, e.g. `*********6789`.
  final String? accountNumber;

  /// Partly masked, e.g. `Yitbarek W*******`.
  final String? accountHolderName;
  final DateTime? otpExpiresAt;
  final int? otpAttemptsLeft;
  final int? otpResendsLeft;

  /// The payment must be finished before this (15 minutes).
  final DateTime? expiresAt;
  final DateTime? createdAt;

  /// Only in the step 1 response, and only for guests.
  final String? guestToken;
  final String? providerReference;
  final DateTime? paidAt;
  final String? certificateId;
  final String? failureReason;

  bool get isFinal => status != PaymentStatus.pending;

  /// This payment with new OTP counts (from an `OTP_*` error's `data`).
  ZakatPayment withOtpCounts({int? attemptsLeft, int? resendsLeft}) {
    return ZakatPayment(
      paymentId: paymentId,
      status: status,
      step: step,
      zakatType: zakatType,
      amountEtb: amountEtb,
      causeId: causeId,
      causeTitle: causeTitle,
      methodLabel: methodLabel,
      accountNumber: accountNumber,
      accountHolderName: accountHolderName,
      otpExpiresAt: otpExpiresAt,
      otpAttemptsLeft: attemptsLeft ?? otpAttemptsLeft,
      otpResendsLeft: resendsLeft ?? otpResendsLeft,
      expiresAt: expiresAt,
      createdAt: createdAt,
      providerReference: providerReference,
      paidAt: paidAt,
      certificateId: certificateId,
      failureReason: failureReason,
    );
  }

  factory ZakatPayment.fromJson(Map<String, dynamic> json) {
    final paymentId = jsonString(json['paymentId']);
    if (paymentId == null) throw const FormatException('Payment without id');
    final account = json['account'];
    final otp = json['otp'];
    final accountMap = account is Map ? account : const {};
    final otpMap = otp is Map ? otp : const {};
    return ZakatPayment(
      paymentId: paymentId,
      status: switch (json['status']) {
        'succeeded' => PaymentStatus.succeeded,
        'failed' => PaymentStatus.failed,
        'cancelled' => PaymentStatus.cancelled,
        'expired' => PaymentStatus.expired,
        _ => PaymentStatus.pending,
      },
      step: switch (json['step']) {
        'confirm_account' => PaymentStep.confirmAccount,
        'enter_otp' => PaymentStep.enterOtp,
        'processing' => PaymentStep.processing,
        _ => null,
      },
      zakatType: jsonString(json['zakatType']),
      amountEtb: jsonDouble(json['amountEtb']) ?? 0,
      causeId: jsonString(json['causeId']),
      causeTitle: jsonString(json['causeTitle']),
      methodLabel: jsonString(json['methodLabel']),
      accountNumber: jsonString(accountMap['accountNumber']),
      accountHolderName: jsonString(accountMap['accountHolderName']),
      otpExpiresAt: jsonDate(otpMap['expiresAt']),
      otpAttemptsLeft: jsonInt(otpMap['attemptsLeft']),
      otpResendsLeft: jsonInt(otpMap['resendsLeft']),
      expiresAt: jsonDate(json['expiresAt']),
      createdAt: jsonDate(json['createdAt']),
      guestToken: jsonString(json['guestToken']),
      providerReference: jsonString(json['providerReference']),
      paidAt: jsonDate(json['paidAt']),
      certificateId: jsonString(json['certificateId']),
      failureReason: jsonString(json['failureReason']),
    );
  }

  @override
  List<Object?> get props => [
    paymentId,
    status,
    step,
    zakatType,
    amountEtb,
    causeId,
    causeTitle,
    methodLabel,
    accountNumber,
    accountHolderName,
    otpExpiresAt,
    otpAttemptsLeft,
    otpResendsLeft,
    expiresAt,
    createdAt,
    guestToken,
    providerReference,
    paidAt,
    certificateId,
    failureReason,
  ];
}

/// Body of `POST /api/payments/v1/zakat-payments` (step 1).
class ZakatPaymentRequest {
  const ZakatPaymentRequest({
    required this.zakatType,
    required this.amountEtb,
    required this.methodCode,
    required this.causeId,
    required this.accountNumber,
    required this.idempotencyKey,
    this.calculation,
  });

  final ZakatType zakatType;
  final double amountEtb;
  final String methodCode;
  final String causeId;
  final String accountNumber;
  final String idempotencyKey;

  /// Sent when the amount came from the calculator or the Fitr card.
  final Map<String, dynamic>? calculation;

  Map<String, dynamic> toJson() => {
    'zakatType': zakatType.name,
    'amountEtb': double.parse(amountEtb.toStringAsFixed(2)),
    'methodCode': methodCode,
    'causeId': causeId,
    'accountNumber': accountNumber,
    'calculation': ?calculation,
    'idempotencyKey': idempotencyKey,
  };
}

/// `GET /api/payments/v1/certificates/{certificateId}`.
class ZakatCertificate extends Equatable {
  const ZakatCertificate({
    required this.certificateId,
    this.payerFullName,
    required this.amountEtb,
    this.zakatType,
    this.causeTitle,
    this.naturalUnitSummary,
    this.methodLabel,
    this.providerReference,
    this.paidAt,
    this.issuedAt,
    this.hijriDate,
    this.issuerName,
    this.issuerLogoUrl,
    this.signatoryName,
    this.signatoryTitle,
    this.verificationUrl,
  });

  final String certificateId;
  final String? payerFullName;
  final double amountEtb;
  final String? zakatType;
  final String? causeTitle;
  final String? naturalUnitSummary;
  final String? methodLabel;
  final String? providerReference;
  final DateTime? paidAt;
  final DateTime? issuedAt;
  final String? hijriDate;
  final String? issuerName;
  final String? issuerLogoUrl;
  final String? signatoryName;
  final String? signatoryTitle;
  final String? verificationUrl;

  factory ZakatCertificate.fromJson(Map<String, dynamic> json) {
    final id = jsonString(json['certificateId']);
    if (id == null) throw const FormatException('Certificate without id');
    final issuer = json['issuer'];
    final issuerMap = issuer is Map ? issuer : const {};
    return ZakatCertificate(
      certificateId: id,
      payerFullName: jsonString(json['payerFullName']),
      amountEtb: jsonDouble(json['amountEtb']) ?? 0,
      zakatType: jsonString(json['zakatType']),
      causeTitle: jsonString(json['causeTitle']),
      naturalUnitSummary: jsonString(json['naturalUnitSummary']),
      methodLabel: jsonString(json['methodLabel']),
      providerReference: jsonString(json['providerReference']),
      paidAt: jsonDate(json['paidAt']),
      issuedAt: jsonDate(json['issuedAt']),
      hijriDate: jsonString(json['hijriDate']),
      issuerName: jsonString(issuerMap['name']),
      issuerLogoUrl: jsonString(issuerMap['logoUrl']),
      signatoryName: jsonString(issuerMap['signatoryName']),
      signatoryTitle: jsonString(issuerMap['signatoryTitle']),
      verificationUrl: jsonString(json['verificationUrl']),
    );
  }

  @override
  List<Object?> get props => [
    certificateId,
    payerFullName,
    amountEtb,
    zakatType,
    causeTitle,
    naturalUnitSummary,
    methodLabel,
    providerReference,
    paidAt,
    issuedAt,
    hijriDate,
    issuerName,
    issuerLogoUrl,
    signatoryName,
    signatoryTitle,
    verificationUrl,
  ];
}

/// A row of `GET /api/payments/v1/me/payments`.
class PaymentHistoryItem extends Equatable {
  const PaymentHistoryItem({
    required this.paymentId,
    this.zakatType,
    required this.amountEtb,
    this.methodLabel,
    this.causeTitle,
    required this.status,
    this.paidAt,
    this.certificateId,
    this.createdAt,
  });

  final String paymentId;
  final String? zakatType;
  final double amountEtb;
  final String? methodLabel;
  final String? causeTitle;
  final PaymentStatus status;
  final DateTime? paidAt;
  final String? certificateId;
  final DateTime? createdAt;

  factory PaymentHistoryItem.fromJson(Map<String, dynamic> json) {
    final payment = ZakatPayment.fromJson(json);
    return PaymentHistoryItem(
      paymentId: payment.paymentId,
      zakatType: payment.zakatType,
      amountEtb: payment.amountEtb,
      methodLabel: payment.methodLabel,
      causeTitle: payment.causeTitle,
      status: payment.status,
      paidAt: payment.paidAt,
      certificateId: payment.certificateId,
      createdAt: jsonDate(json['createdAt']),
    );
  }

  @override
  List<Object?> get props => [
    paymentId,
    zakatType,
    amountEtb,
    methodLabel,
    causeTitle,
    status,
    paidAt,
    certificateId,
    createdAt,
  ];
}

class PaymentHistoryPage extends Equatable {
  const PaymentHistoryPage({
    required this.items,
    required this.page,
    required this.totalPages,
  });

  final List<PaymentHistoryItem> items;
  final int page;
  final int totalPages;

  bool get hasMore => page < totalPages;

  factory PaymentHistoryPage.fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    final pagination = json['pagination'];
    final meta = pagination is Map ? pagination : const {};
    return PaymentHistoryPage(
      items: items is List
          ? [
              for (final item in items)
                if (item is Map)
                  PaymentHistoryItem.fromJson(Map<String, dynamic>.from(item)),
            ]
          : const [],
      page: jsonInt(meta['page']) ?? 1,
      totalPages: jsonInt(meta['totalPages']) ?? 1,
    );
  }

  @override
  List<Object?> get props => [items, page, totalPages];
}

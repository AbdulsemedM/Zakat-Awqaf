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

  /// `qr`: the donor scans a QR code with any bank app. The only flow the
  /// app runs (the Coop account flow was switched off).
  final String? flow;

  bool get isQr => flow == 'qr';

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

/// `purpose` of a payment. Sadaqah has no zakat kind, is QR only, and gets
/// a Sadaqah Receipt instead of a zakat certificate.
enum PaymentPurpose { zakat, sadaqah }

/// `sadaqah` in a payment's or certificate's `purpose`; anything else
/// (including an absent value from an older server) is zakat.
bool isSadaqahPurpose(String? purpose) =>
    purpose == PaymentPurpose.sadaqah.name;

enum PaymentStatus { pending, succeeded, failed, cancelled, expired }

/// Where a `pending` payment is. `scanQr`: waiting for the donor's bank app
/// and the commission's confirmation. `processing`: an older Coop account
/// payment the bank has not answered. Absent once the payment is final.
enum PaymentStep { scanQr, processing }

/// The response of every zakat payment call.
class ZakatPayment extends Equatable {
  const ZakatPayment({
    required this.paymentId,
    required this.status,
    this.step,
    this.purpose,
    this.zakatType,
    required this.amountEtb,
    this.issuedAmountEtb,
    this.causeId,
    this.causeTitle,
    this.methodCode,
    this.methodLabel,
    this.qrPayload,
    this.qrImageBase64,
    this.qrExpiresAt,
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

  /// `zakat` or `sadaqah`; see [isSadaqah].
  final String? purpose;

  /// The zakat kind; always `general` for Sadaqah.
  final String? zakatType;

  /// The amount paid. When the donor paid a different amount than the QR's,
  /// this is the amount received and [issuedAmountEtb] the QR's.
  final double amountEtb;
  final double? issuedAmountEtb;
  final String? causeId;
  final String? causeTitle;
  final String? methodCode;
  final String? methodLabel;

  /// The EthQR string to scan (QR payments). Render it when there is no
  /// [qrImageBase64].
  final String? qrPayload;

  /// PNG of the QR, only in the step 1 response.
  final String? qrImageBase64;
  final DateTime? qrExpiresAt;

  /// The QR must be paid before this (30 minutes). An expired payment that
  /// was paid anyway can still turn `succeeded`.
  final DateTime? expiresAt;
  final DateTime? createdAt;

  /// Only in the step 1 response, and only for guests.
  final String? guestToken;
  final String? providerReference;
  final DateTime? paidAt;
  final String? certificateId;
  final String? failureReason;

  bool get isFinal => status != PaymentStatus.pending;

  bool get isSadaqah => isSadaqahPurpose(purpose);

  bool get isQr => step == PaymentStep.scanQr || methodCode == 'ethqr';

  /// The donor paid a different amount than the QR's.
  bool get paidDifferentAmount =>
      issuedAmountEtb != null && issuedAmountEtb != amountEtb;

  /// How long a QR paid after it expired is still confirmed.
  static const lateConfirmWindow = Duration(hours: 24);

  /// A QR that `check-payment` can still confirm: pending, or expired (a
  /// late payment is confirmed for [lateConfirmWindow]).
  bool get canCheckPayment =>
      isQr &&
      (status == PaymentStatus.pending || status == PaymentStatus.expired);

  factory ZakatPayment.fromJson(Map<String, dynamic> json) {
    final paymentId = jsonString(json['paymentId']);
    if (paymentId == null) throw const FormatException('Payment without id');
    final qr = json['qr'];
    final qrMap = qr is Map ? qr : const {};
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
        'scan_qr' => PaymentStep.scanQr,
        'processing' => PaymentStep.processing,
        _ => null,
      },
      purpose: jsonString(json['purpose']),
      zakatType: jsonString(json['zakatType']),
      amountEtb: jsonDouble(json['amountEtb']) ?? 0,
      issuedAmountEtb: jsonDouble(json['issuedAmountEtb']),
      causeId: jsonString(json['causeId']),
      causeTitle: jsonString(json['causeTitle']),
      methodCode: jsonString(json['methodCode']),
      methodLabel: jsonString(json['methodLabel']),
      qrPayload: jsonString(qrMap['payload']),
      qrImageBase64: jsonString(qrMap['imageBase64']),
      qrExpiresAt: jsonDate(qrMap['expiresAt']),
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
    purpose,
    zakatType,
    amountEtb,
    issuedAmountEtb,
    causeId,
    causeTitle,
    methodCode,
    methodLabel,
    qrPayload,
    qrImageBase64,
    qrExpiresAt,
    expiresAt,
    createdAt,
    guestToken,
    providerReference,
    paidAt,
    certificateId,
    failureReason,
  ];
}

/// Body of `POST /api/payments/v1/zakat-payments`: creates the QR.
class ZakatPaymentRequest {
  const ZakatPaymentRequest({
    this.purpose = PaymentPurpose.zakat,
    required this.zakatType,
    required this.amountEtb,
    required this.methodCode,
    required this.causeId,
    this.payer,
    required this.idempotencyKey,
    this.calculation,
  });

  final PaymentPurpose purpose;

  /// Not sent for Sadaqah (the server would ignore it).
  final ZakatType zakatType;
  final double amountEtb;
  final String methodCode;
  final String causeId;

  /// Required for a guest paying by QR (the name goes on the certificate).
  final PaymentPayer? payer;
  final String idempotencyKey;

  /// Sent when the amount came from the calculator or the Fitr card.
  final Map<String, dynamic>? calculation;

  Map<String, dynamic> toJson() => {
    'purpose': purpose.name,
    if (purpose == PaymentPurpose.zakat) 'zakatType': zakatType.name,
    'amountEtb': double.parse(amountEtb.toStringAsFixed(2)),
    'methodCode': methodCode,
    'causeId': causeId,
    'payer': ?payer?.toJson(),
    'calculation': ?calculation,
    'idempotencyKey': idempotencyKey,
  };
}

/// `payer` of a payment. A guest paying by QR must send [fullName]; a
/// signed-in donor's name comes from the account.
class PaymentPayer {
  const PaymentPayer({this.fullName, this.phone, this.anonymous = false});

  final String? fullName;
  final String? phone;

  /// Prints "Anonymous donor" on the certificate.
  final bool anonymous;

  Map<String, dynamic> toJson() => {
    'fullName': ?fullName,
    'phone': ?phone,
    'anonymous': anonymous,
  };
}

/// `GET /api/payments/v1/certificates/{certificateId}`.
class ZakatCertificate extends Equatable {
  const ZakatCertificate({
    required this.certificateId,
    this.purpose,
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

  /// `sadaqah`: a Sadaqah Receipt rather than a zakat certificate.
  final String? purpose;
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

  bool get isSadaqah => isSadaqahPurpose(purpose);

  factory ZakatCertificate.fromJson(Map<String, dynamic> json) {
    final id = jsonString(json['certificateId']);
    if (id == null) throw const FormatException('Certificate without id');
    final issuer = json['issuer'];
    final issuerMap = issuer is Map ? issuer : const {};
    return ZakatCertificate(
      certificateId: id,
      purpose: jsonString(json['purpose']),
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
    purpose,
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

/// A row of `GET /api/payments/v1/me/payments`: a zakat or Sadaqah QR
/// payment, or an international card donation made while signed in.
class PaymentHistoryItem extends Equatable {
  const PaymentHistoryItem({
    required this.paymentId,
    this.type,
    this.zakatType,
    required this.amountEtb,
    this.amountUsd,
    this.cardPurpose,
    this.methodLabel,
    this.causeTitle,
    required this.status,
    this.reference,
    this.paidAt,
    this.certificateId,
    this.createdAt,
  });

  /// `zp_…`, or the merchant reference of a card donation.
  final String paymentId;

  /// `zakat`, `sadaqah` or `card`.
  final String? type;

  /// The zakat kind; absent for Sadaqah and card donations.
  final String? zakatType;
  final double amountEtb;

  /// Card donations only.
  final double? amountUsd;

  /// Card donations only: `zakat` or `waqf`.
  final String? cardPurpose;
  final String? methodLabel;
  final String? causeTitle;
  final PaymentStatus status;

  /// The bank or card gateway's reference once paid.
  final String? reference;
  final DateTime? paidAt;
  final String? certificateId;
  final DateTime? createdAt;

  bool get isCard => type == 'card';

  bool get isSadaqah => isSadaqahPurpose(type);

  factory PaymentHistoryItem.fromJson(Map<String, dynamic> json) {
    final payment = ZakatPayment.fromJson(json);
    return PaymentHistoryItem(
      paymentId: payment.paymentId,
      type: jsonString(json['type']) ?? payment.purpose,
      zakatType: payment.zakatType,
      amountEtb: payment.amountEtb,
      amountUsd: jsonDouble(json['amountUsd']),
      cardPurpose: jsonString(json['cardPurpose']),
      methodLabel: payment.methodLabel,
      causeTitle: payment.causeTitle,
      status: payment.status,
      reference: jsonString(json['reference']),
      paidAt: payment.paidAt,
      certificateId: payment.certificateId,
      createdAt: jsonDate(json['createdAt']),
    );
  }

  /// [payment]'s new state applied to this row, e.g. after `check-payment`.
  PaymentHistoryItem withPayment(ZakatPayment payment) => PaymentHistoryItem(
    paymentId: paymentId,
    type: type,
    zakatType: zakatType,
    amountEtb: payment.amountEtb,
    methodLabel: payment.methodLabel ?? methodLabel,
    causeTitle: payment.causeTitle ?? causeTitle,
    status: payment.status,
    reference: payment.providerReference ?? reference,
    paidAt: payment.paidAt,
    certificateId: payment.certificateId,
    createdAt: createdAt,
  );

  /// A QR payment not settled and still confirmable: pending, or expired
  /// within [ZakatPayment.lateConfirmWindow] of its start. Never a card
  /// donation.
  bool canCheckPayment(DateTime now) =>
      !isCard &&
      switch (status) {
        PaymentStatus.pending => true,
        PaymentStatus.expired =>
          createdAt != null &&
              now.difference(createdAt!) <
                  ZakatPayment.lateConfirmWindow + const Duration(hours: 1),
        _ => false,
      };

  @override
  List<Object?> get props => [
    paymentId,
    type,
    zakatType,
    amountEtb,
    amountUsd,
    cardPurpose,
    methodLabel,
    causeTitle,
    status,
    reference,
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

/// `GET /api/payments/v1/me/giving-summary` (signed-in donor): succeeded
/// payments (Zakat al-Fitr included, linked guest payments too) in the
/// current Hijri year, plus all time. Zakat and Sadaqah are totalled
/// apart; card donations are not counted.
class GivingSummary extends Equatable {
  const GivingSummary({
    this.periodLabel,
    this.totalZakatPaidEtb,
    this.totalSadaqahEtb,
    this.paymentsCount,
    this.beneficiariesHelped,
    this.causesSupported,
    this.allTimeZakatPaidEtb,
    this.allTimeSadaqahEtb,
    this.allTimePaymentsCount,
  });

  /// e.g. `1448 AH`.
  final String? periodLabel;
  final double? totalZakatPaidEtb;
  final double? totalSadaqahEtb;

  /// Zakat and Sadaqah payments.
  final int? paymentsCount;

  /// `null` until disbursements are recorded: hide it.
  final int? beneficiariesHelped;
  final int? causesSupported;
  final double? allTimeZakatPaidEtb;
  final double? allTimeSadaqahEtb;
  final int? allTimePaymentsCount;

  factory GivingSummary.fromJson(Map<String, dynamic> json) {
    final period = json['period'];
    final allTime = json['allTime'];
    final allTimeMap = allTime is Map ? allTime : const {};
    return GivingSummary(
      periodLabel: period is Map ? jsonString(period['label']) : null,
      totalZakatPaidEtb: jsonDouble(json['totalZakatPaidEtb']),
      totalSadaqahEtb: jsonDouble(json['totalSadaqahEtb']),
      paymentsCount: jsonInt(json['paymentsCount']),
      beneficiariesHelped: jsonInt(json['beneficiariesHelped']),
      causesSupported: jsonInt(json['causesSupported']),
      allTimeZakatPaidEtb: jsonDouble(allTimeMap['totalZakatPaidEtb']),
      allTimeSadaqahEtb: jsonDouble(allTimeMap['totalSadaqahEtb']),
      allTimePaymentsCount: jsonInt(allTimeMap['paymentsCount']),
    );
  }

  @override
  List<Object?> get props => [
    periodLabel,
    totalZakatPaidEtb,
    totalSadaqahEtb,
    paymentsCount,
    beneficiariesHelped,
    causesSupported,
    allTimeZakatPaidEtb,
    allTimeSadaqahEtb,
    allTimePaymentsCount,
  ];
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/zakat_payment_models.dart';

/// What the app remembers about a payment made on this device: enough to
/// list it and to resume it. Not secret: the guest token stays in
/// [GuestPaymentTokenStore].
class DevicePayment {
  const DevicePayment({
    required this.paymentId,
    required this.amountEtb,
    required this.status,
    this.step,
    this.zakatType,
    this.causeTitle,
    this.expiresAt,
    required this.createdAt,
    this.certificateId,
  });

  final String paymentId;
  final double amountEtb;
  final PaymentStatus status;
  final PaymentStep? step;
  final String? zakatType;
  final String? causeTitle;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final String? certificateId;

  /// Waiting for the donor and not expired yet: can be resumed.
  bool isOpen(DateTime now) =>
      status == PaymentStatus.pending &&
      step != PaymentStep.processing &&
      (expiresAt == null || now.isBefore(expiresAt!));

  /// The bank has not answered; the result is still coming.
  bool get isProcessing =>
      status == PaymentStatus.pending && step == PaymentStep.processing;

  factory DevicePayment.from(ZakatPayment payment, {DevicePayment? previous}) {
    return DevicePayment(
      paymentId: payment.paymentId,
      amountEtb: payment.amountEtb,
      status: payment.status,
      step: payment.step,
      zakatType: payment.zakatType ?? previous?.zakatType,
      causeTitle: payment.causeTitle ?? previous?.causeTitle,
      expiresAt: payment.expiresAt ?? previous?.expiresAt,
      createdAt: payment.createdAt ?? previous?.createdAt ?? DateTime.now(),
      certificateId: payment.certificateId ?? previous?.certificateId,
    );
  }

  Map<String, dynamic> toJson() => {
    'paymentId': paymentId,
    'amountEtb': amountEtb,
    'status': status.name,
    'step': ?step?.name,
    'zakatType': ?zakatType,
    'causeTitle': ?causeTitle,
    'expiresAt': ?expiresAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'certificateId': ?certificateId,
  };

  static DevicePayment? tryParse(Object? json) {
    if (json is! Map) return null;
    final id = json['paymentId'];
    final created = DateTime.tryParse(json['createdAt']?.toString() ?? '');
    if (id is! String || created == null) return null;
    return DevicePayment(
      paymentId: id,
      amountEtb: (json['amountEtb'] as num?)?.toDouble() ?? 0,
      status:
          PaymentStatus.values.asNameMap()[json['status']] ??
          PaymentStatus.pending,
      step: PaymentStep.values.asNameMap()[json['step']],
      zakatType: json['zakatType']?.toString(),
      causeTitle: json['causeTitle']?.toString(),
      expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? ''),
      createdAt: created,
      certificateId: json['certificateId']?.toString(),
    );
  }
}

/// Zakat payments started on this device, newest first, kept up to date
/// with every payment response. Backs "Recent payments on this device" and
/// "Continue your payment".
@lazySingleton
class DevicePaymentsStore extends ChangeNotifier {
  DevicePaymentsStore() {
    _load();
  }

  static const _key = 'zakat_device_payments_v1';
  static const maxEntries = 20;

  List<DevicePayment> _payments = const [];
  bool _loaded = false;
  Future<void>? _loading;

  List<DevicePayment> get payments => _payments;

  bool get loaded => _loaded;

  /// The newest payment that can still be resumed or is being confirmed.
  DevicePayment? unfinished(DateTime now) {
    for (final payment in _payments) {
      if (payment.isOpen(now) || payment.isProcessing) return payment;
    }
    return null;
  }

  Future<void> _load() => _loading ??= () async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    final parsed = <DevicePayment>[];
    if (raw != null) {
      try {
        final list = jsonDecode(raw);
        if (list is List) {
          parsed.addAll(
            list.map(DevicePayment.tryParse).whereType<DevicePayment>(),
          );
        }
      } on FormatException {
        // Start over with an empty list.
      }
    }
    _payments = parsed;
    _loaded = true;
    notifyListeners();
  }();

  /// Tells listeners to look again, e.g. when an open payment's time has
  /// run out and it no longer counts as unfinished.
  void recheck() => notifyListeners();

  /// Adds or updates [payment] from a payment API response.
  Future<void> record(ZakatPayment payment) async {
    await _load();
    final index = _payments.indexWhere((p) => p.paymentId == payment.paymentId);
    final previous = index == -1 ? null : _payments[index];
    final entry = DevicePayment.from(payment, previous: previous);
    final updated = [..._payments];
    if (index == -1) {
      updated.insert(0, entry);
    } else {
      updated[index] = entry;
    }
    _payments = updated.take(maxEntries).toList();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode([for (final p in _payments) p.toJson()]),
    );
  }
}

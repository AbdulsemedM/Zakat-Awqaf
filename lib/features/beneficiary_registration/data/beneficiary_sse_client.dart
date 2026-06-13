import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'fayda_verification_status.dart';

/// Subscribes to `GET .../sse/beneficiary/{id}`.
///
/// SSE subscribers are in-memory on one service instance; behind multiple
/// replicas without sticky sessions the client may miss events.
@lazySingleton
class BeneficiarySseClient {
  BeneficiarySseClient(this._dio);

  final Dio _dio;

  static const _pathPrefix = 'api/beneficiaries/v1/sse/beneficiary/';

  Stream<BeneficiarySseVerificationEvent> watchBeneficiaryVerification(
    String beneficiaryId,
  ) {
    return _watchBeneficiaryVerification(beneficiaryId);
  }

  Stream<BeneficiarySseVerificationEvent> _watchBeneficiaryVerification(
    String beneficiaryId,
  ) async* {
    final path = '$_pathPrefix$beneficiaryId';
    try {
      final response = await _dio.get<ResponseBody>(
        path,
        options: Options(
          responseType: ResponseType.stream,
          headers: {'Accept': 'text/event-stream'},
          receiveTimeout: Duration.zero,
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final body = response.data;
      if (body == null) {
        return;
      }

      final lineStream =
          utf8.decoder.bind(body.stream).transform(const LineSplitter());
      var currentEvent = '';
      await for (final line in lineStream) {
        final trimmed = line.trimRight();
        if (trimmed.isEmpty) {
          currentEvent = '';
          continue;
        }
        if (trimmed.startsWith('event:')) {
          currentEvent = trimmed.substring(6).trim();
          continue;
        }
        if (trimmed.startsWith('data:')) {
          final payload = trimmed.substring(5).trim();
          if (currentEvent == 'VERIFICATION_COMPLETE' && payload.isNotEmpty) {
            try {
              final map = jsonDecode(payload) as Map<String, dynamic>;
              yield BeneficiarySseVerificationEvent.fromJson(map);
            } catch (_) {
              // ignore malformed payloads
            }
          }
        }
      }
    } on DioException catch (e, stackTrace) {
      Error.throwWithStackTrace(e, stackTrace);
    }
  }
}

class BeneficiarySseVerificationEvent {
  const BeneficiarySseVerificationEvent({
    required this.beneficiaryId,
    required this.verificationStatus,
    this.passwordSetupToken,
  });

  factory BeneficiarySseVerificationEvent.fromJson(Map<String, dynamic> json) {
    return BeneficiarySseVerificationEvent(
      beneficiaryId: json['beneficiaryId']?.toString() ?? '',
      verificationStatus: json['verificationStatus']?.toString() ?? '',
      passwordSetupToken: json['passwordSetupToken'] as String?,
    );
  }

  final String beneficiaryId;
  final String verificationStatus;
  final String? passwordSetupToken;

  bool get isVerificationComplete =>
      isFaydaVerificationReady(passwordSetupToken: passwordSetupToken);
}

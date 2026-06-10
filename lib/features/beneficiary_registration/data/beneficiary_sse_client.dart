import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

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
  ) async* {
    final path = '$_pathPrefix$beneficiaryId';
    final response = await _dio.get<ResponseBody>(
      path,
      options: Options(
        responseType: ResponseType.stream,
        headers: {'Accept': 'text/event-stream'},
        receiveTimeout: const Duration(minutes: 3),
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
  }
}

class BeneficiarySseVerificationEvent {
  const BeneficiarySseVerificationEvent({
    required this.beneficiaryId,
    required this.verificationStatus,
  });

  factory BeneficiarySseVerificationEvent.fromJson(Map<String, dynamic> json) {
    return BeneficiarySseVerificationEvent(
      beneficiaryId: json['beneficiaryId']?.toString() ?? '',
      verificationStatus: json['verificationStatus']?.toString() ?? '',
    );
  }

  final String beneficiaryId;
  final String verificationStatus;

  bool get isVerificationComplete {
    final status = verificationStatus.toLowerCase();
    if (status.isEmpty) {
      return true;
    }
    return status == 'verified' ||
        status == 'complete' ||
        status == 'completed' ||
        status == 'success';
  }
}

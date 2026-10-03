import 'dart:ui';

import 'package:dio/dio.dart';

/// Failure from the gateway's `{ success, data, message, errors }` envelope.
class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.code,
    this.data = const {},
    this.fieldErrors = const {},
    this.noResponse = false,
  });

  final String message;
  final int? statusCode;

  /// Machine-readable error, e.g. `OTP_WRONG` (payments API).
  final String? code;

  /// Error details, e.g. `{ "attemptsLeft": 3 }`.
  final Map<String, dynamic> data;

  /// `errors[]` by field name.
  final Map<String, String> fieldErrors;

  /// No response arrived (timeout, connection lost): the request may or may
  /// not have reached the server.
  final bool noResponse;

  bool get isNotFound => statusCode == 404;

  @override
  String toString() => 'ApiException($statusCode, $code): $message';
}

/// Languages the public zakat endpoints accept in `?lang=`.
const _apiLanguages = {'en', 'am', 'ar', 'om', 'so'};

/// The `lang` query value for [locale], defaulting to English.
String apiLang(Locale locale) =>
    _apiLanguages.contains(locale.languageCode) ? locale.languageCode : 'en';

/// Returns the envelope's `data`, or `null` when the key is absent
/// (`{ "success": true }` means "nothing to show").
Object? unwrapApiData(Response<dynamic> response) {
  final body = response.data;
  if (body is! Map) {
    throw ApiException(
      'Unexpected response body',
      statusCode: response.statusCode,
    );
  }
  if (body['success'] != true) {
    throw ApiException(
      body['message']?.toString() ?? 'Request was not successful',
      statusCode: response.statusCode,
    );
  }
  return body['data'];
}

/// Like [unwrapApiData] but requires `data` to be a JSON object.
Map<String, dynamic> unwrapApiObject(Response<dynamic> response) {
  final data = unwrapApiData(response);
  if (data is! Map) {
    throw ApiException('Response has no data', statusCode: response.statusCode);
  }
  return Map<String, dynamic>.from(data);
}

ApiException apiExceptionFromDio(DioException e) {
  final body = e.response?.data;
  if (body is! Map) {
    return ApiException(
      e.message ?? 'Network error',
      statusCode: e.response?.statusCode,
      noResponse: e.response == null,
    );
  }
  final data = body['data'];
  final errors = body['errors'];
  return ApiException(
    body['message']?.toString() ?? e.message ?? 'Request failed',
    statusCode: e.response?.statusCode,
    code: body['code']?.toString(),
    data: data is Map ? Map<String, dynamic>.from(data) : const {},
    fieldErrors: {
      if (errors is List)
        for (final error in errors)
          if (error is Map && error['field'] != null)
            error['field'].toString(): error['message']?.toString() ?? '',
    },
  );
}

/// Runs [request] and maps Dio and parsing failures to [ApiException].
Future<T> guardApi<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on ApiException {
    rethrow;
  } on DioException catch (e) {
    throw apiExceptionFromDio(e);
  } on FormatException catch (e) {
    throw ApiException('Unexpected response: ${e.message}');
  } on TypeError catch (e) {
    throw ApiException('Unexpected response: $e');
  }
}

double? jsonDouble(Object? value) => value is num ? value.toDouble() : null;

int? jsonInt(Object? value) => value is num ? value.toInt() : null;

String? jsonString(Object? value) => value?.toString();

DateTime? jsonDate(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

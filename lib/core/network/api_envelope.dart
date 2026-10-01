import 'dart:ui';

import 'package:dio/dio.dart';

/// Failure from the gateway's `{ success, data, message, errors }` envelope.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isNotFound => statusCode == 404;

  @override
  String toString() => 'ApiException($statusCode): $message';
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
  final message = body is Map ? body['message']?.toString() : null;
  return ApiException(
    message ?? e.message ?? 'Network error',
    statusCode: e.response?.statusCode,
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

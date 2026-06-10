import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dio_log_colors.dart';

/// Logs every Dio request/response to the debug console with ANSI colors.
class DioLoggingInterceptor extends Interceptor {
  DioLoggingInterceptor({
    this.logRequestHeaders = true,
    this.logRequestBody = true,
    this.logResponseHeaders = true,
    this.logResponseBody = true,
    this.logOnError = true,
    this.maxBodyLength = 8000,
    this.sensitiveHeaderKeys = const {
      'authorization',
      'cookie',
      'set-cookie',
      'x-api-key',
    },
  });

  final bool logRequestHeaders;
  final bool logRequestBody;
  final bool logResponseHeaders;
  final bool logResponseBody;
  final bool logOnError;
  final int maxBodyLength;
  final Set<String> sensitiveHeaderKeys;

  static int _requestCounter = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) {
      handler.next(options);
      return;
    }

    final id = ++_requestCounter;
    options.extra['_dio_log_id'] = id;
    options.extra['_dio_log_start'] = DateTime.now().millisecondsSinceEpoch;

    final buffer = StringBuffer()
      ..writeln(_divider('REQUEST', DioLogColors.cyan))
      ..writeln(
        '${DioLogColors.paint('[$id]', DioLogColors.bold)} '
        '${DioLogColors.paint(options.method.toUpperCase(), DioLogColors.cyan)} '
        '${DioLogColors.paint(_fullUri(options), DioLogColors.white)}',
      );

    if (options.queryParameters.isNotEmpty) {
      buffer.writeln(
        '${DioLogColors.paint('Query', DioLogColors.yellow)}: '
        '${_formatData(options.queryParameters)}',
      );
    }

    if (logRequestHeaders && options.headers.isNotEmpty) {
      buffer.writeln(DioLogColors.paint('Headers', DioLogColors.yellow));
      buffer.write(_formatHeaders(options.headers));
    }

    if (logRequestBody && options.data != null) {
      buffer.writeln(DioLogColors.paint('Body', DioLogColors.yellow));
      buffer.writeln(_formatBody(options.data, options.contentType));
    }

    if (options.responseType == ResponseType.stream) {
      buffer.writeln(
        DioLogColors.paint(
          'Response type: stream (body not logged on response)',
          DioLogColors.gray,
        ),
      );
    }

    buffer.writeln(_divider(null, DioLogColors.cyan));
    debugPrint(buffer.toString());

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (!kDebugMode) {
      handler.next(response);
      return;
    }

    final options = response.requestOptions;
    final id = options.extra['_dio_log_id'] ?? '?';
    final elapsed = _elapsedMs(options);
    final status = response.statusCode ?? 0;
    final statusColor = _statusColor(status);

    final buffer = StringBuffer()
      ..writeln(_divider('RESPONSE', statusColor))
      ..writeln(
        '${DioLogColors.paint('[$id]', DioLogColors.bold)} '
        '${DioLogColors.paint(status.toString(), statusColor)} '
        '${DioLogColors.paint(options.method.toUpperCase(), DioLogColors.cyan)} '
        '${DioLogColors.paint(_fullUri(options), DioLogColors.white)} '
        '${DioLogColors.paint('(${elapsed}ms)', DioLogColors.gray)}',
      );

    if (logResponseHeaders && response.headers.map.isNotEmpty) {
      buffer.writeln(DioLogColors.paint('Headers', DioLogColors.yellow));
      buffer.write(_formatHeaders(response.headers.map));
    }

    if (logResponseBody && options.responseType != ResponseType.stream) {
      buffer.writeln(DioLogColors.paint('Body', DioLogColors.yellow));
      buffer.writeln(_formatBody(response.data, response.headers.value('content-type')));
    }

    buffer.writeln(_divider(null, statusColor));
    debugPrint(buffer.toString());

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode || !logOnError) {
      handler.next(err);
      return;
    }

    final options = err.requestOptions;
    final id = options.extra['_dio_log_id'] ?? '?';
    final elapsed = _elapsedMs(options);
    final status = err.response?.statusCode;

    final buffer = StringBuffer()
      ..writeln(_divider('ERROR', DioLogColors.red))
      ..writeln(
        '${DioLogColors.paint('[$id]', DioLogColors.bold)} '
        '${DioLogColors.paint(err.type.name, DioLogColors.red)} '
        '${DioLogColors.paint(options.method.toUpperCase(), DioLogColors.cyan)} '
        '${DioLogColors.paint(_fullUri(options), DioLogColors.white)} '
        '${DioLogColors.paint('(${elapsed}ms)', DioLogColors.gray)}',
      );

    if (status != null) {
      buffer.writeln(
        '${DioLogColors.paint('Status', DioLogColors.yellow)}: '
        '${DioLogColors.paint(status.toString(), _statusColor(status))}',
      );
    }

    buffer.writeln(
      '${DioLogColors.paint('Message', DioLogColors.yellow)}: ${err.message}',
    );

    final response = err.response;
    if (response != null) {
      if (logResponseHeaders && response.headers.map.isNotEmpty) {
        buffer.writeln(DioLogColors.paint('Headers', DioLogColors.yellow));
        buffer.write(_formatHeaders(response.headers.map));
      }
      if (logResponseBody && response.data != null) {
        buffer.writeln(DioLogColors.paint('Body', DioLogColors.yellow));
        buffer.writeln(
          _formatBody(response.data, response.headers.value('content-type')),
        );
      }
    }

    buffer.writeln(_divider(null, DioLogColors.red));
    debugPrint(buffer.toString());

    handler.next(err);
  }

  String _divider(String? label, String color) {
    const line = '────────────────────────────────────────────────────────';
    if (label == null) {
      return DioLogColors.paint(line, color);
    }
    final padded = ' $label ';
    final side = ((line.length - padded.length) ~/ 2).clamp(4, 40);
    final bar = '${'─' * side}$padded${'─' * side}';
    return DioLogColors.paint(bar, color);
  }

  String _fullUri(RequestOptions options) {
    final base = options.baseUrl;
    final path = options.path;
    if (base.isEmpty) {
      return options.uri.toString();
    }
    final normalizedBase = base.endsWith('/') ? base : '$base/';
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return '$normalizedBase$normalizedPath';
  }

  int _elapsedMs(RequestOptions options) {
    final start = options.extra['_dio_log_start'];
    if (start is! int) {
      return 0;
    }
    return DateTime.now().millisecondsSinceEpoch - start;
  }

  String _statusColor(int status) {
    if (status >= 200 && status < 300) {
      return DioLogColors.green;
    }
    if (status >= 300 && status < 400) {
      return DioLogColors.blue;
    }
    if (status >= 400 && status < 500) {
      return DioLogColors.yellow;
    }
    return DioLogColors.red;
  }

  String _formatHeaders(Map<String, dynamic> headers) {
    final buffer = StringBuffer();
    for (final entry in headers.entries) {
      final key = entry.key;
      final value = entry.value;
      final display = _redactIfSensitive(key, value);
      buffer.writeln('  ${DioLogColors.paint(key, DioLogColors.magenta)}: $display');
    }
    return buffer.toString();
  }

  String _redactIfSensitive(String key, dynamic value) {
    if (!sensitiveHeaderKeys.contains(key.toLowerCase())) {
      return value.toString();
    }
    final raw = value.toString();
    if (raw.length <= 8) {
      return '***';
    }
    return '${raw.substring(0, 4)}…${raw.substring(raw.length - 4)}';
  }

  String _formatData(dynamic data) {
    if (data == null) {
      return DioLogColors.paint('null', DioLogColors.gray);
    }
    if (data is Map || data is List) {
      return _prettyJson(data);
    }
    return _truncate(data.toString());
  }

  String _formatBody(dynamic data, String? contentType) {
    if (data == null) {
      return DioLogColors.paint('(empty)', DioLogColors.gray);
    }

    if (data is ResponseBody) {
      return DioLogColors.paint('(stream body)', DioLogColors.gray);
    }

    if (data is FormData) {
      final fields = data.fields.map((e) => '  ${e.key}: ${e.value}').join('\n');
      final files = data.files
          .map((e) => '  ${e.key}: ${e.value.filename ?? 'file'}')
          .join('\n');
      return _truncate(
        '${DioLogColors.paint('multipart fields', DioLogColors.gray)}\n$fields\n'
        '${DioLogColors.paint('multipart files', DioLogColors.gray)}\n$files',
      );
    }

    if (data is Map || data is List) {
      return _prettyJson(data);
    }

    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        try {
          return _prettyJson(jsonDecode(trimmed));
        } catch (_) {
          return _truncate(data);
        }
      }
      return _truncate(data);
    }

    if (contentType != null && contentType.contains('json')) {
      try {
        return _prettyJson(data);
      } catch (_) {
        return _truncate(data.toString());
      }
    }

    return _truncate(data.toString());
  }

  String _prettyJson(dynamic data) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return _truncate(encoder.convert(data));
    } catch (_) {
      return _truncate(data.toString());
    }
  }

  String _truncate(String text) {
    if (text.length <= maxBodyLength) {
      return text;
    }
    final suffix = DioLogColors.paint(
      '\n… [truncated ${text.length - maxBodyLength} chars]',
      DioLogColors.gray,
    );
    return '${text.substring(0, maxBodyLength)}$suffix';
  }
}

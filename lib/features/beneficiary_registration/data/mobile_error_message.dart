/// Parses [MobileErrorResponse] shape from the beneficiary API.
String? parseMobileErrorMessage(Object? data) {
  if (data is! Map) {
    return null;
  }
  final map = Map<String, dynamic>.from(data);
  final message = map['message']?.toString();
  final errors = map['errors'];
  final parts = <String>[];
  if (message != null && message.trim().isNotEmpty) {
    parts.add(message.trim());
  }
  if (errors is List) {
    for (final e in errors) {
      if (e is Map) {
        final field = e['field']?.toString();
        final msg = e['message']?.toString();
        if (field != null &&
            field.isNotEmpty &&
            msg != null &&
            msg.isNotEmpty) {
          parts.add('$field: $msg');
        } else if (msg != null && msg.isNotEmpty) {
          parts.add(msg);
        }
      }
    }
  }
  if (parts.isEmpty) {
    return null;
  }
  return parts.join('\n');
}

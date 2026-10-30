import 'package:equatable/equatable.dart';

/// `GET /api/zakat/v1/support`: where users get help. Set by an admin, so
/// any field may be `null`; show only those with a value.
class SupportContact extends Equatable {
  const SupportContact({this.phone, this.email, this.webUrl, this.hours});

  final String? phone;
  final String? email;
  final String? webUrl;

  /// e.g. "Monday to Friday, 8:30 to 17:30".
  final String? hours;

  /// Nothing to show: hide the support entry.
  bool get isEmpty =>
      phone == null && email == null && webUrl == null && hours == null;

  factory SupportContact.fromJson(Map<String, dynamic> json) {
    String? text(String key) {
      final value = json[key];
      return value is String && value.trim().isNotEmpty ? value.trim() : null;
    }

    return SupportContact(
      phone: text('phone'),
      email: text('email'),
      webUrl: text('webUrl'),
      hours: text('hours'),
    );
  }

  @override
  List<Object?> get props => [phone, email, webUrl, hours];
}

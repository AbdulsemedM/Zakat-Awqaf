import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/core/config/app_env.dart';
import 'package:mejlis_digital_hub/core/network/pinned_certificates.dart';

void main() {
  test('the API URL is https', () {
    expect(Uri.parse(AppEnv.apiBaseUrl).scheme, 'https');
  });

  test('every pinned root loads as a trust anchor', () {
    expect(PinnedCertificates.pem, isNotEmpty);
    for (final pem in PinnedCertificates.pem) {
      final context = SecurityContext(withTrustedRoots: false);
      expect(
        () => context.setTrustedCertificatesBytes(utf8.encode(pem)),
        returnsNormally,
      );
    }
  });

  test('Android pins the same host the app calls', () {
    final config = File(
      'android/app/src/main/res/xml/network_security_config.xml',
    ).readAsStringSync();
    final host = Uri.parse(AppEnv.apiBaseUrl).host;
    expect(config, contains('<domain includeSubdomains="false">$host</domain>'));
    expect(
      RegExp('<pin digest="SHA-256">').allMatches(config).length,
      PinnedCertificates.pem.length,
    );
  });
}

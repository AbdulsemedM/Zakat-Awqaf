/// The only certificates the API clients trust (certificate pinning): a
/// connection to any other certificate fails, even one signed by a CA the
/// device trusts (e.g. an intercepting proxy's). Hostname checks still apply.
///
/// When empty, the clients use the platform's trusted CAs instead. Replace
/// these when the server's certificate changes, or the app can't connect.
abstract final class PinnedCertificates {
  /// UAT, 196.188.249.232 (self-signed, IP SAN). Valid until 2028-11-12.
  /// SHA-256: c030259344c42e944bbb0cf981c66aff3896f409da05768f335a3970bcfaaed1
  static const List<String> pem = [
    '''
-----BEGIN CERTIFICATE-----
MIIDeDCCAmCgAwIBAgIUBh3ZnSCVGHFYwcTu3DsQm+kbELAwDQYJKoZIhvcNAQEL
BQAwQzEYMBYGA1UEAwwPMTk2LjE4OC4yNDkuMjMyMRkwFwYDVQQKDBBFdGhpbyBa
YWthdCBXYXFmMQwwCgYDVQQLDANVQVQwHhcNMjYwODEwMTg1NjI5WhcNMjgxMTEy
MTg1NjI5WjBDMRgwFgYDVQQDDA8xOTYuMTg4LjI0OS4yMzIxGTAXBgNVBAoMEEV0
aGlvIFpha2F0IFdhcWYxDDAKBgNVBAsMA1VBVDCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAK4iNjt88F7vMwICi4SDTKWMKNwpgZG8BxGRl8IjahUkx4cw
WfOHLR3KmRv+78QBbzbN/w3zkMJZv8vQgllHjjv74O/0lKfbqUcrPtTiNNkAroVO
LvMadSpFfjkyyNl3VuHZn8mmtPQFcqru0gMre5yTSB2+VIGcZ136uTWMxKzOzG8L
Shr5pFO+kRiS8lfSjqhh+3Va2VqVU/mWy5JNTmJBo5CIfPC1FwHdqdEAXA5iiHkb
5QOi8uDBTKo3oZ4FDE9jDXNQoZIlZmprswWu5HZ0e2+X/jYHYAOh5YjnZyCVuzmE
16es8kIw83haw2oyv3/uuCkwjhTKgE0v73a0wXMCAwEAAaNkMGIwHQYDVR0OBBYE
FG0fWOmrJNOE9stfiKb9RIl74vG9MB8GA1UdIwQYMBaAFG0fWOmrJNOE9stfiKb9
RIl74vG9MA8GA1UdEwEB/wQFMAMBAf8wDwYDVR0RBAgwBocExLz56DANBgkqhkiG
9w0BAQsFAAOCAQEAlGlWkIh+uYCDr1x5iWhyLCS1za4Ev7e1qCjcy0RNFKG2yvMo
ycUehDnoLNjT2eg1SjLUOF0K8AbI3TC1fyNQpW9e+QX0Ymz0xPXlub6icRtQ9jqX
fP2p6K7UnwRy1SbV5O8k7F2cyqxThCaz3cWVa3D0deSJA3LDgoPo926hSgwGlhk8
fmLoKiUz2OhzEGsa4uPAEBoWRJkwIZnD/V9C5K0Ct5ECqvyL6wvZhKp3IpevYAkj
sgzOljofONBT9+rnqhq2hZXma3Nlqi6GbPhS7NgXJiOkAaq7If84A3WDPX+YTn4/
BhqdOWsRBItXicALWZwJd5vSXn+OW0/vaC+rZA==
-----END CERTIFICATE-----
''',
  ];
}

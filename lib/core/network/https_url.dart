/// [url] when it is an absolute `https` URL, else `null`. Image URLs come
/// from the API and are loaded by Dart's HTTP client, which the platforms'
/// cleartext rules don't cover, so anything else is not loaded.
String? httpsUrl(String? url) {
  final uri = url == null ? null : Uri.tryParse(url.trim());
  if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) return null;
  return uri.toString();
}

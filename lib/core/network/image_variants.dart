import 'api_envelope.dart';

/// Smaller copies of a published image (`imageVariants` / `variants`:
/// `{"thumbnail": url, "medium": url, "large": url}`, 400 / 800 / 1600 px).
/// A size the server doesn't have serves the original, so every URL works.
class ImageVariants {
  const ImageVariants({this.thumbnail, this.medium, this.large});

  /// For lists and avatars.
  final String? thumbnail;

  /// For detail screens.
  final String? medium;
  final String? large;

  static const none = ImageVariants();

  factory ImageVariants.fromJson(Object? json) {
    if (json is! Map) return none;
    return ImageVariants(
      thumbnail: jsonString(json['thumbnail']),
      medium: jsonString(json['medium']),
      large: jsonString(json['large']),
    );
  }

  /// The thumbnail, else [original].
  String? thumbnailOr(String? original) => thumbnail ?? medium ?? original;

  /// The medium size, else [original].
  String? mediumOr(String? original) => medium ?? original;

  @override
  bool operator ==(Object other) =>
      other is ImageVariants &&
      other.thumbnail == thumbnail &&
      other.medium == medium &&
      other.large == large;

  @override
  int get hashCode => Object.hash(thumbnail, medium, large);
}

/// A detail gallery image (`gallery: [{url, altText, variants}]`).
class GalleryImage {
  const GalleryImage({
    required this.url,
    this.altText,
    this.variants = ImageVariants.none,
  });

  final String url;

  /// For screen readers.
  final String? altText;
  final ImageVariants variants;

  static GalleryImage? tryParse(Object? json) {
    if (json is! Map) return null;
    final url = jsonString(json['url']);
    if (url == null || url.isEmpty) return null;
    return GalleryImage(
      url: url,
      altText: jsonString(json['altText']),
      variants: ImageVariants.fromJson(json['variants']),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GalleryImage &&
      other.url == url &&
      other.altText == altText &&
      other.variants == variants;

  @override
  int get hashCode => Object.hash(url, altText, variants);
}

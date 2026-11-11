import 'package:equatable/equatable.dart';

import '../../../../core/network/api_envelope.dart';
import '../../../../core/network/image_variants.dart';

enum CauseBadge { essential, urgent }

enum CauseStatus { active, closed }

/// Categories the API filters by; unknown values from the server show as
/// [general].
enum CauseCategory {
  education,
  water,
  health,
  food,
  shelter,
  livelihood,
  emergency,
  general;

  static CauseCategory parse(String? value) => CauseCategory.values.firstWhere(
    (c) => c.name == value,
    orElse: () => CauseCategory.general,
  );
}

/// A cause / urgent need (`GET /api/zakat/v1/causes`).
class Cause extends Equatable {
  const Cause({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    this.badge,
    this.imageUrl,
    this.goalEtb,
    this.raisedEtb,
    this.progress,
    this.region,
    this.endsOn,
    required this.acceptsZakat,
    this.status = CauseStatus.active,
    this.closedAt,
    this.imageAltText,
    this.imageVariants = ImageVariants.none,
    this.regionCode,
  });

  /// The permanent general zakat fund, always first in `acceptsZakat=true`.
  static const generalFundId = 'general';

  final String id;
  final String title;
  final String? description;
  final CauseCategory category;
  final CauseBadge? badge;
  final String? imageUrl;
  final double? goalEtb;

  /// `null` when not tracked (e.g. the general fund).
  final double? raisedEtb;

  /// `raisedEtb ÷ goalEtb`; `null` without a goal.
  final double? progress;
  final String? region;
  final DateTime? endsOn;
  final bool acceptsZakat;

  /// Causes close by themselves after their end date.
  final CauseStatus status;
  final DateTime? closedAt;

  /// Describes [imageUrl] for screen readers.
  final String? imageAltText;

  /// Smaller copies of [imageUrl]: thumbnail in lists, medium on detail.
  final ImageVariants imageVariants;

  /// Same codes as `GET /impact/regions`.
  final String? regionCode;

  bool get isGeneralFund => id == generalFundId;

  bool get isClosed => status == CauseStatus.closed;

  /// Shows the Give button: accepts zakat and is not closed.
  bool get canGive => acceptsZakat && !isClosed;

  factory Cause.fromJson(Map<String, dynamic> json) {
    final id = jsonString(json['id']);
    if (id == null) throw const FormatException('Cause without id');
    return Cause(
      id: id,
      title: jsonString(json['title']) ?? '',
      description: jsonString(json['description']),
      category: CauseCategory.parse(jsonString(json['category'])),
      badge: switch (json['badge']) {
        'urgent' => CauseBadge.urgent,
        'essential' => CauseBadge.essential,
        _ => null,
      },
      imageUrl: jsonString(json['imageUrl']),
      goalEtb: jsonDouble(json['goalEtb']),
      raisedEtb: jsonDouble(json['raisedEtb']),
      progress: jsonDouble(json['progress']),
      region: jsonString(json['region']),
      endsOn: jsonDate(json['endsOn']),
      acceptsZakat: json['acceptsZakat'] == true,
      status: json['status'] == 'closed'
          ? CauseStatus.closed
          : CauseStatus.active,
      closedAt: jsonDate(json['closedAt']),
      imageAltText: jsonString(json['imageAltText']),
      imageVariants: ImageVariants.fromJson(json['imageVariants']),
      regionCode: jsonString(json['regionCode']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    badge,
    imageUrl,
    goalEtb,
    raisedEtb,
    progress,
    region,
    endsOn,
    acceptsZakat,
    status,
    closedAt,
    imageAltText,
    imageVariants,
    regionCode,
  ];
}

/// `GET /api/zakat/v1/causes/{id}`: the list item plus long text and images.
class CauseDetail extends Equatable {
  const CauseDetail({
    required this.cause,
    this.body,
    this.images = const [],
    this.gallery = const [],
  });

  final Cause cause;
  final String? body;

  /// Absolute image URLs, possibly empty.
  final List<String> images;

  /// The images with alt text and sizes; built from [images] when the
  /// server sends no `gallery`.
  final List<GalleryImage> gallery;

  factory CauseDetail.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final images = rawImages is List
        ? [
            for (final url in rawImages)
              if (url is String) url,
          ]
        : const <String>[];
    final rawGallery = json['gallery'];
    final gallery = rawGallery is List
        ? rawGallery.map(GalleryImage.tryParse).nonNulls.toList()
        : const <GalleryImage>[];
    return CauseDetail(
      cause: Cause.fromJson(json),
      body: jsonString(json['body']),
      images: images,
      gallery: gallery.isNotEmpty
          ? gallery
          : [for (final url in images) GalleryImage(url: url)],
    );
  }

  @override
  List<Object?> get props => [cause, body, images, gallery];
}

class CausesPage extends Equatable {
  const CausesPage({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.totalItems,
  });

  final List<Cause> items;
  final int page;
  final int totalPages;
  final int totalItems;

  bool get hasMore => page < totalPages;

  factory CausesPage.fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    final pagination = json['pagination'];
    final meta = pagination is Map ? pagination : const {};
    return CausesPage(
      items: items is List
          ? [
              for (final item in items)
                if (item is Map)
                  Cause.fromJson(Map<String, dynamic>.from(item)),
            ]
          : const [],
      page: jsonInt(meta['page']) ?? 1,
      totalPages: jsonInt(meta['totalPages']) ?? 1,
      totalItems: jsonInt(meta['totalItems']) ?? 0,
    );
  }

  @override
  List<Object?> get props => [items, page, totalPages, totalItems];
}

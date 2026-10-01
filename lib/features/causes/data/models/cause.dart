import 'package:equatable/equatable.dart';

import '../../../../core/network/api_envelope.dart';

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

  bool get isGeneralFund => id == generalFundId;

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
  ];
}

/// `GET /api/zakat/v1/causes/{id}`: the list item plus long text and images.
class CauseDetail extends Equatable {
  const CauseDetail({required this.cause, this.body, this.images = const []});

  final Cause cause;
  final String? body;

  /// Absolute image URLs, possibly empty.
  final List<String> images;

  factory CauseDetail.fromJson(Map<String, dynamic> json) {
    final images = json['images'];
    return CauseDetail(
      cause: Cause.fromJson(json),
      body: jsonString(json['body']),
      images: images is List
          ? [
              for (final url in images)
                if (url is String) url,
            ]
          : const [],
    );
  }

  @override
  List<Object?> get props => [cause, body, images];
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

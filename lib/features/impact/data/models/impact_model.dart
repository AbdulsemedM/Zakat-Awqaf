import 'package:equatable/equatable.dart';

import '../../../../core/network/api_envelope.dart';
import '../../../beneficiary_registration/data/models/asnaf_category.dart';
import '../../../causes/data/models/cause.dart';

/// `GET /api/zakat/v1/impact/summary?region=`: national figures, or one
/// region's when `region` is given. Any figure can be `null`; hide it.
class ImpactSummary extends Equatable {
  const ImpactSummary({
    this.scope,
    this.regionName,
    this.distributedFundsEtb,
    this.livesTouched,
    this.activeProjects,
    this.beneficiariesByAsnaf = const [],
    this.asOf,
  });

  /// "Live" only while the figures are fresher than this.
  static const liveWindow = Duration(hours: 1);

  /// `national` or `region`.
  final String? scope;
  final String? regionName;
  final double? distributedFundsEtb;
  final int? livesTouched;
  final int? activeProjects;
  final List<AsnafCount> beneficiariesByAsnaf;
  final DateTime? asOf;

  bool isLive(DateTime now) {
    final asOf = this.asOf;
    return asOf != null && now.difference(asOf) < liveWindow;
  }

  factory ImpactSummary.fromJson(Map<String, dynamic> json) {
    final asnaf = json['beneficiariesByAsnaf'];
    return ImpactSummary(
      scope: jsonString(json['scope']),
      regionName: jsonString(json['regionName']),
      distributedFundsEtb: jsonDouble(json['distributedFundsEtb']),
      livesTouched: jsonInt(json['livesTouched']),
      activeProjects: jsonInt(json['activeProjects']),
      beneficiariesByAsnaf: asnaf is List
          ? [
              for (final row in asnaf)
                if (row is Map && jsonInt(row['count']) != null)
                  AsnafCount(
                    asnaf: jsonString(row['asnaf']) ?? '',
                    count: jsonInt(row['count'])!,
                  ),
            ]
          : const [],
      asOf: jsonDate(json['asOf']),
    );
  }

  @override
  List<Object?> get props => [
    scope,
    regionName,
    distributedFundsEtb,
    livesTouched,
    activeProjects,
    beneficiariesByAsnaf,
    asOf,
  ];
}

class AsnafCount extends Equatable {
  const AsnafCount({required this.asnaf, required this.count});

  /// API value, e.g. `poor`, `fi_sabilillah`.
  final String asnaf;
  final int count;

  /// The category's label, or the raw value for one the app does not know.
  String get label => AsnafCategoryApi.fromApiValue(asnaf)?.label ?? asnaf;

  @override
  List<Object?> get props => [asnaf, count];
}

/// A map marker (`GET /api/zakat/v1/impact/regions`).
class ImpactRegion extends Equatable {
  const ImpactRegion({
    required this.code,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.distributedFundsEtb,
    this.beneficiaries,
    this.activeProjects,
  });

  /// Sent as `?region=` to the summary.
  final String code;
  final String name;
  final double latitude;
  final double longitude;
  final double? distributedFundsEtb;
  final int? beneficiaries;
  final int? activeProjects;

  /// `null` for a row without a code or coordinates (it can't be placed).
  static ImpactRegion? tryParse(Map<String, dynamic> json) {
    final code = jsonString(json['code']);
    final latitude = jsonDouble(json['latitude']);
    final longitude = jsonDouble(json['longitude']);
    if (code == null || latitude == null || longitude == null) return null;
    return ImpactRegion(
      code: code,
      name: jsonString(json['name']) ?? code,
      latitude: latitude,
      longitude: longitude,
      distributedFundsEtb: jsonDouble(json['distributedFundsEtb']),
      beneficiaries: jsonInt(json['beneficiaries']),
      activeProjects: jsonInt(json['activeProjects']),
    );
  }

  @override
  List<Object?> get props => [
    code,
    name,
    latitude,
    longitude,
    distributedFundsEtb,
    beneficiaries,
    activeProjects,
  ];
}

/// A Baraka story (`GET /api/zakat/v1/impact/stories`, `…/stories/{id}`).
/// Published only with the beneficiary's consent; carries no beneficiary id.
class ImpactStory extends Equatable {
  const ImpactStory({
    required this.id,
    required this.title,
    this.summary,
    this.body,
    required this.category,
    this.region,
    this.imageUrl,
    this.publishedAt,
  });

  final String id;
  final String title;
  final String? summary;

  /// Long text; usually only in the detail response.
  final String? body;

  /// Same categories as causes; used for the fallback icon and colours.
  final CauseCategory category;
  final String? region;
  final String? imageUrl;
  final DateTime? publishedAt;

  factory ImpactStory.fromJson(Map<String, dynamic> json) {
    final id = jsonString(json['id']);
    if (id == null) throw const FormatException('Story without id');
    return ImpactStory(
      id: id,
      title: jsonString(json['title']) ?? '',
      summary: jsonString(json['summary']),
      body: jsonString(json['body']),
      category: CauseCategory.parse(jsonString(json['category'])),
      region: jsonString(json['region']),
      imageUrl: jsonString(json['imageUrl']),
      publishedAt: jsonDate(json['publishedAt']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    summary,
    body,
    category,
    region,
    imageUrl,
    publishedAt,
  ];
}

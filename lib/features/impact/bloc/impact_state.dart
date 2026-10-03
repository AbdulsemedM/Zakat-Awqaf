import 'package:equatable/equatable.dart';

import '../data/models/impact_model.dart';

/// `unavailable`: the impact API is not deployed yet (B4 is "Later"); the
/// gateway answers unknown routes with 401, so 401/404 mean "coming soon".
enum ImpactLoadStatus { loading, loaded, failed, unavailable }

/// Summary, regions and stories load on their own. The screen fails only
/// when no summary could be loaded; empty regions or stories just hide
/// their section.
class ImpactState extends Equatable {
  const ImpactState({
    this.lang = 'en',
    this.status = ImpactLoadStatus.loading,
    this.summary,
    this.regions = const [],
    this.stories = const [],
    this.selectedRegionCode,
    this.isRegionLoading = false,
  });

  final String lang;
  final ImpactLoadStatus status;

  /// National, or [selectedRegionCode]'s once loaded.
  final ImpactSummary? summary;
  final List<ImpactRegion> regions;
  final List<ImpactStory> stories;
  final String? selectedRegionCode;
  final bool isRegionLoading;

  ImpactRegion? get selectedRegion {
    for (final region in regions) {
      if (region.code == selectedRegionCode) return region;
    }
    return null;
  }

  ImpactState copyWith({
    String? lang,
    ImpactLoadStatus? status,
    ImpactSummary? summary,
    List<ImpactRegion>? regions,
    List<ImpactStory>? stories,
    String? Function()? selectedRegionCode,
    bool? isRegionLoading,
  }) {
    return ImpactState(
      lang: lang ?? this.lang,
      status: status ?? this.status,
      summary: summary ?? this.summary,
      regions: regions ?? this.regions,
      stories: stories ?? this.stories,
      selectedRegionCode: selectedRegionCode != null
          ? selectedRegionCode()
          : this.selectedRegionCode,
      isRegionLoading: isRegionLoading ?? this.isRegionLoading,
    );
  }

  @override
  List<Object?> get props => [
    lang,
    status,
    summary,
    regions,
    stories,
    selectedRegionCode,
    isRegionLoading,
  ];
}

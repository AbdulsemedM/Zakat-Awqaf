import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AwqafStatus { planning, construction, completed }

extension AwqafStatusX on AwqafStatus {
  String get label {
    switch (this) {
      case AwqafStatus.planning:
        return 'Planning';
      case AwqafStatus.construction:
        return 'Construction';
      case AwqafStatus.completed:
        return 'Completed';
    }
  }
}

class MapRegion extends Equatable {
  const MapRegion({
    required this.name,
    required this.xPercent,
    required this.yPercent,
    this.isLabeled = false,
  });

  final String name;

  /// 0..1 horizontal position inside the map box.
  final double xPercent;

  /// 0..1 vertical position inside the map box.
  final double yPercent;

  /// When true, the region's name is rendered next to its pin.
  final bool isLabeled;

  @override
  List<Object?> get props => [name, xPercent, yPercent, isLabeled];
}

class BarakaStory extends Equatable {
  const BarakaStory({
    required this.name,
    required this.fallbackIcon,
    required this.accent,
    this.imageAsset,
  });

  final String name;
  final IconData fallbackIcon;
  final Color accent;
  final String? imageAsset;

  @override
  List<Object?> get props => [name, fallbackIcon, accent, imageAsset];
}

class AwqafProject extends Equatable {
  const AwqafProject({
    required this.title,
    required this.status,
    required this.fundedPercent,
    required this.etbLeft,
    this.imageAsset,
  });

  final String title;
  final AwqafStatus status;
  final double fundedPercent;
  final int etbLeft;
  final String? imageAsset;

  @override
  List<Object?> get props => [title, status, fundedPercent, etbLeft, imageAsset];
}

class ImpactModel extends Equatable {
  const ImpactModel({
    required this.distributedFundsEtb,
    required this.livesTouched,
    required this.activeProjects,
    required this.regionName,
    required this.regions,
    required this.barakaStories,
    required this.awqafProjects,
  });

  final double distributedFundsEtb;
  final int livesTouched;
  final int activeProjects;
  final String regionName;
  final List<MapRegion> regions;
  final List<BarakaStory> barakaStories;
  final List<AwqafProject> awqafProjects;

  ImpactModel copyWith({
    double? distributedFundsEtb,
    int? livesTouched,
    int? activeProjects,
    String? regionName,
    List<MapRegion>? regions,
    List<BarakaStory>? barakaStories,
    List<AwqafProject>? awqafProjects,
  }) {
    return ImpactModel(
      distributedFundsEtb: distributedFundsEtb ?? this.distributedFundsEtb,
      livesTouched: livesTouched ?? this.livesTouched,
      activeProjects: activeProjects ?? this.activeProjects,
      regionName: regionName ?? this.regionName,
      regions: regions ?? this.regions,
      barakaStories: barakaStories ?? this.barakaStories,
      awqafProjects: awqafProjects ?? this.awqafProjects,
    );
  }

  @override
  List<Object?> get props => [
        distributedFundsEtb,
        livesTouched,
        activeProjects,
        regionName,
        regions,
        barakaStories,
        awqafProjects,
      ];
}

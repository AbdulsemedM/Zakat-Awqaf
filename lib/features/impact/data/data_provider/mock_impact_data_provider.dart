import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../models/impact_model.dart';
import 'impact_data_provider.dart';

@LazySingleton(as: ImpactDataProvider)
class MockImpactDataProvider implements ImpactDataProvider {
  @override
  Future<ImpactModel> fetchImpact() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return const ImpactModel(
      distributedFundsEtb: 42550000,
      livesTouched: 142500,
      activeProjects: 84,
      regionName: 'Ethiopia',
      regions: [
        MapRegion(
          name: 'Addis Ababa',
          xPercent: 0.45,
          yPercent: 0.62,
          isLabeled: true,
        ),
        MapRegion(name: 'Mekelle', xPercent: 0.78, yPercent: 0.22),
        MapRegion(name: 'Bahir Dar', xPercent: 0.40, yPercent: 0.32),
        MapRegion(name: 'Harar', xPercent: 0.86, yPercent: 0.55),
      ],
      barakaStories: [
        BarakaStory(
          name: "Ahmed's Shop",
          fallbackIcon: Icons.storefront_rounded,
          accent: Color(0xFF016D0C),
        ),
        BarakaStory(
          name: "Sara's Degree",
          fallbackIcon: Icons.school_rounded,
          accent: Color(0xFFD97706),
        ),
        BarakaStory(
          name: "Zubeida's Clinic",
          fallbackIcon: Icons.medical_services_rounded,
          accent: Color(0xFF0E7490),
        ),
      ],
      awqafProjects: [
        AwqafProject(
          title: 'Bilal Primary School',
          status: AwqafStatus.construction,
          fundedPercent: 0.75,
          etbLeft: 1250000,
        ),
        AwqafProject(
          title: 'Harar Borehole Project',
          status: AwqafStatus.planning,
          fundedPercent: 0.40,
          etbLeft: 800000,
        ),
      ],
    );
  }
}

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
          latitude: 8.9806,
          longitude: 38.7578,
          isLabeled: true,
        ),
        MapRegion(name: 'Mekelle', latitude: 13.4967, longitude: 39.4753),
        MapRegion(name: 'Bahir Dar', latitude: 11.5742, longitude: 37.3614),
        MapRegion(name: 'Harar', latitude: 9.3139, longitude: 42.1182),
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
          accent: Color(0xFFE28F35),
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

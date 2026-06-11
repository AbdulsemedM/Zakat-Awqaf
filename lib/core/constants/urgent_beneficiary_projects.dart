import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../app/theme/app_colors.dart';

/// Urgent beneficiary need projects (shared by home + zakat payment).
class UrgentNeedModel {
  const UrgentNeedModel({
    required this.badge,
    required this.title,
    required this.description,
    required this.bannerColors,
    required this.progress,
    required this.icon,
  });

  final String badge;
  final String title;
  final String description;
  final List<Color> bannerColors;
  final double progress;
  final IconData icon;
}

const homeUrgentNeeds = <UrgentNeedModel>[
  UrgentNeedModel(
    badge: 'ESSENTIAL',
    title: 'Education Support',
    description:
        'Support annual tuition and school supplies for vulnerable students.',
    bannerColors: [AppColors.forestMid, AppColors.forestLight],
    progress: 0.65,
    icon: TablerIcons.book,
  ),
  UrgentNeedModel(
    badge: 'URGENT',
    title: 'Clean Water',
    description:
        'Provide immediate clean water access to drought-affected communities.',
    bannerColors: [AppColors.waterGradientStart, AppColors.waterGradientEnd],
    progress: 0.42,
    icon: TablerIcons.droplet,
  ),
];

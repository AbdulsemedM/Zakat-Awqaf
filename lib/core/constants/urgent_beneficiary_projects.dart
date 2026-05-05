import 'package:flutter/material.dart';

/// Urgent beneficiary need projects (shared by home + zakat payment).
class UrgentNeedModel {
  const UrgentNeedModel({
    required this.badge,
    required this.title,
    required this.description,
    required this.bannerColors,
  });

  final String badge;
  final String title;
  final String description;
  final List<Color> bannerColors;
}

const homeUrgentNeeds = <UrgentNeedModel>[
  UrgentNeedModel(
    badge: 'URGENT',
    title: 'Drought Relief in Afar',
    description:
        'Provide immediate clean water and food supplies to pastoralist families.',
    bannerColors: [Color(0xFF8D6E63), Color(0xFFD7CCC8)],
  ),
  UrgentNeedModel(
    badge: 'ESSENTIAL',
    title: 'Education Support',
    description:
        'Support annual tuition and school supplies for vulnerable students.',
    bannerColors: [Color(0xFF455A64), Color(0xFF90A4AE)],
  ),
];

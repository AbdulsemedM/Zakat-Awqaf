import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/urgent_beneficiary_projects.dart';
import '../widgets/home_about_card.dart';
import '../widgets/home_hero_section.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/home_register_cta.dart';
import '../widgets/home_sadaqah_card.dart';
import '../widgets/home_urgent_causes_section.dart';
import '../widgets/home_zakat_reminder_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _statusBarStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusBarStyle,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeHeroSection(),
              Transform.translate(
                offset: const Offset(0, -kHomeHeroOverlap),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const HomeQuickActions(),
                      const SizedBox(height: 20),
                      const RegisterZakatCta(),
                      const SizedBox(height: 28),
                      UrgentCausesSection(causes: homeUrgentNeeds),
                      const SizedBox(height: 28),
                      const ZakatReminderCard(),
                      const SizedBox(height: 20),
                      const AboutCommissionSection(),
                      const SizedBox(height: 20),
                      const DonateSadaqahCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

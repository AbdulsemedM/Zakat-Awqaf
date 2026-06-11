import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/urgent_beneficiary_projects.dart';
import '../widgets/home_about_card.dart';
import '../widgets/home_hero_section.dart';
import '../widgets/home_register_cta.dart';
import '../widgets/home_sadaqah_card.dart';
import '../widgets/home_urgent_causes_section.dart';
import '../widgets/home_zakat_reminder_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _statusBarStyle = SystemUiOverlayStyle(
    statusBarColor: AppColors.forestGreen,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusBarStyle,
      child: Scaffold(
        backgroundColor: AppColors.parchment,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeHeroSection(),
              Container(
                color: AppColors.parchment,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const RegisterZakatCta(),
                    const SizedBox(height: 16),
                    UrgentCausesSection(causes: homeUrgentNeeds),
                    const SizedBox(height: 16),
                    const ZakatReminderCard(),
                    const SizedBox(height: 16),
                    const AboutCommissionSection(),
                    const SizedBox(height: 14),
                    const DonateSadaqahCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

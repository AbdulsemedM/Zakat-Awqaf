import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../bloc/home_bloc.dart';
import '../widgets/home_about_card.dart';
import '../widgets/home_hero_section.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/home_register_cta.dart';
import '../widgets/home_sadaqah_card.dart';
import '../widgets/home_urgent_causes_section.dart';
import '../widgets/home_zakat_reminder_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _statusBarStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  final _bloc = getIt<HomeBloc>();
  String? _lang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = apiLang(context.contentLocale);
    if (lang != _lang) {
      _lang = lang;
      _bloc.add(HomeLoadRequested(lang));
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _refresh() {
    final done = Completer<void>();
    _bloc.add(HomeLoadRequested(_lang ?? 'en', done: done));
    return done.future;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _statusBarStyle,
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          bloc: _bloc,
          builder: (context, state) {
            final fitrSeason = state.fitrSeason;
            return RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HomeHeroSection(summary: state.summary),
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
                            if (state.urgentCauses.isNotEmpty) ...[
                              const SizedBox(height: 28),
                              UrgentCausesSection(causes: state.urgentCauses),
                            ],
                            if (fitrSeason != null) ...[
                              const SizedBox(height: 28),
                              ZakatReminderCard(season: fitrSeason),
                            ],
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
            );
          },
        ),
      ),
    );
  }
}

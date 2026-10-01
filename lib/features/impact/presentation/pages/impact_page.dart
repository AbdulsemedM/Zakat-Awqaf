import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../app/widgets/app_logo.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/number_format.dart';
import '../../../causes/presentation/widgets/cause_visuals.dart';
import '../../../home/presentation/widgets/home_shared.dart';
import '../../bloc/impact_bloc.dart';
import '../../bloc/impact_event.dart';
import '../../bloc/impact_state.dart';
import '../../data/models/impact_model.dart';

part '../widgets/impact_content_widgets.dart';

class ImpactPage extends StatefulWidget {
  const ImpactPage({super.key});

  @override
  State<ImpactPage> createState() => _ImpactPageState();
}

class _ImpactPageState extends State<ImpactPage> {
  String? _lang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = apiLang(context.contentLocale);
    if (lang != _lang) {
      _lang = lang;
      context.read<ImpactBloc>().add(ImpactStarted(lang));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: BlocBuilder<ImpactBloc, ImpactState>(
          builder: (context, state) {
            return switch (state.status) {
              ImpactLoadStatus.loading => const Column(
                children: [
                  _ImpactHeader(summary: null),
                  Expanded(child: Center(child: CircularProgressIndicator())),
                ],
              ),
              ImpactLoadStatus.failed => const Column(
                children: [
                  _ImpactHeader(summary: null),
                  Expanded(child: _ErrorView()),
                ],
              ),
              ImpactLoadStatus.loaded => RefreshIndicator(
                color: AppColors.warmGold,
                onRefresh: () {
                  final done = Completer<void>();
                  context.read<ImpactBloc>().add(
                    ImpactRefreshRequested(done: done),
                  );
                  return done.future;
                },
                child: _ImpactContent(state: state),
              ),
            };
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              context.l10n.impactCouldNotLoad,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.read<ImpactBloc>().add(
                const ImpactRefreshRequested(),
              ),
              child: Text(context.l10n.profileTryAgain),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImpactContent extends StatelessWidget {
  const _ImpactContent({required this.state});

  final ImpactState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summary = state.summary;
    final regionLabel = state.selectedRegion?.name ?? summary?.regionName;
    final asnaf = summary?.beneficiariesByAsnaf ?? const <AsnafCount>[];
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ImpactHeader(summary: summary),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.regions.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ZakatSectionHeader(
                          title: l10n.impactGeographicReach,
                        ),
                      ),
                      if (regionLabel != null)
                        _RegionChip(
                          label: regionLabel,
                          loading: state.isRegionLoading,
                          onClear: state.selectedRegionCode == null
                              ? null
                              : () => context.read<ImpactBloc>().add(
                                  const ImpactRegionSelected(null),
                                ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _ImpactMapCard(state: state),
                  const SizedBox(height: 28),
                ],
                if (asnaf.isNotEmpty) ...[
                  ZakatSectionHeader(title: l10n.impactBeneficiariesByAsnaf),
                  const SizedBox(height: 14),
                  _AsnafBreakdownCard(rows: asnaf),
                  const SizedBox(height: 28),
                ],
                if (state.stories.isNotEmpty) ...[
                  ZakatSectionHeader(title: l10n.impactBarakaStories),
                  const SizedBox(height: 14),
                  _StoriesRow(stories: state.stories),
                  const SizedBox(height: 28),
                ],
                const _PersonalBarakaCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

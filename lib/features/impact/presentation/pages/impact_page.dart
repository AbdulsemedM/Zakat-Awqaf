import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../app/widgets/app_logo.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/number_format.dart';
import '../../bloc/impact_bloc.dart';
import '../../bloc/impact_event.dart';
import '../../bloc/impact_state.dart';
import '../../data/models/impact_model.dart';

part '../widgets/impact_content_widgets.dart';

class ImpactPage extends StatelessWidget {
  const ImpactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: BlocBuilder<ImpactBloc, ImpactState>(
          builder: (context, state) {
            return switch (state) {
              ImpactInitial() || ImpactLoading() => const Column(
                  children: [
                    _ImpactHeader(model: null),
                    Expanded(child: Center(child: CircularProgressIndicator())),
                  ],
                ),
              ImpactError(:final message) => Column(
                  children: [
                    const _ImpactHeader(model: null),
                    Expanded(child: _ErrorView(message: message)),
                  ],
                ),
              ImpactLoaded(:final model) => RefreshIndicator(
                  color: AppColors.warmGold,
                  onRefresh: () async {
                    context
                        .read<ImpactBloc>()
                        .add(const ImpactRefreshRequested());
                  },
                  child: _ImpactContent(model: model),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.impactCouldNotLoad,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context
                  .read<ImpactBloc>()
                  .add(const ImpactRefreshRequested()),
              child: Text(context.l10n.profileTryAgain),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImpactContent extends StatelessWidget {
  const _ImpactContent({required this.model});

  final ImpactModel model;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ImpactHeader(model: model),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ZakatSectionHeader(title: l10n.impactGeographicReach),
                    ),
                    _RegionChip(label: model.regionName),
                  ],
                ),
                const SizedBox(height: 14),
                _ImpactMapCard(model: model),
                const SizedBox(height: 28),
                ZakatSectionHeader(title: l10n.impactBarakaStories),
                const SizedBox(height: 14),
                _StoriesRow(stories: model.barakaStories),
                const SizedBox(height: 28),
                ZakatSectionHeader(
                  title: l10n.impactActiveAwqafProjects,
                  actionLabel: l10n.viewAll,
                  onAction: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.impactAllProjectsComingSoon)),
                    );
                  },
                ),
                const SizedBox(height: 14),
                for (var i = 0; i < model.awqafProjects.length; i++) ...[
                  _ProjectCard(project: model.awqafProjects[i]),
                  if (i != model.awqafProjects.length - 1)
                    const SizedBox(height: 14),
                ],
                const SizedBox(height: 24),
                const _PersonalBarakaCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

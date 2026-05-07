import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/primary_hero.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.impactNationalImpact),
        actions: [
          IconButton(
            tooltip: context.l10n.impactNotifications,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.profileNoNewNotifications)),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          // const Padding(
          //   padding: EdgeInsets.only(right: 12),
          //   child: CircleAvatar(
          //     radius: 14,
          //     child: Icon(Icons.person, size: 16),
          //   ),
          // ),
        ],
      ),
      body: BlocBuilder<ImpactBloc, ImpactState>(
        builder: (context, state) {
          return switch (state) {
            ImpactInitial() || ImpactLoading() =>
              const Center(child: CircularProgressIndicator()),
            ImpactError(:final message) => _ErrorView(message: message),
            ImpactLoaded(:final model) => RefreshIndicator(
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LiveImpactCard(theme: theme, model: model),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  context.l10n.impactGeographicReach,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  model.regionName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _GeographicCard(theme: theme, model: model),
          const SizedBox(height: 14),
          Text(
            context.l10n.impactBarakaStories,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _StoriesRow(stories: model.barakaStories),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  context.l10n.impactActiveAwqafProjects,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.l10n.impactAllProjectsComingSoon)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Text(
                      context.l10n.viewAll,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          for (var i = 0; i < model.awqafProjects.length; i++) ...[
            _ProjectCard(theme: theme, project: model.awqafProjects[i]),
            if (i != model.awqafProjects.length - 1)
              const SizedBox(height: 12),
          ],
          const SizedBox(height: 14),
          _PersonalBarakaCard(theme: theme),
        ],
      ),
    );
  }
}

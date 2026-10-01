import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../app/widgets/zakat_page_header.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_envelope.dart';
import '../../bloc/causes_list_bloc.dart';
import '../../bloc/causes_list_event.dart';
import '../../bloc/causes_list_state.dart';
import '../../data/models/cause.dart';
import '../widgets/cause_card.dart';
import '../widgets/cause_visuals.dart';

/// All causes: active / closed, filtered by category, paged.
class CausesScreen extends StatefulWidget {
  const CausesScreen({super.key});

  @override
  State<CausesScreen> createState() => _CausesScreenState();
}

class _CausesScreenState extends State<CausesScreen> {
  final _bloc = getIt<CausesListBloc>();
  String? _lang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = apiLang(context.contentLocale);
    if (lang != _lang) {
      _lang = lang;
      _bloc.add(CausesListStarted(lang));
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.extentAfter < 400) {
      _bloc.add(const CausesNextPageRequested());
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: BlocBuilder<CausesListBloc, CausesListState>(
          builder: (context, state) {
            return NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: RefreshIndicator(
                onRefresh: () async => _bloc.add(CausesListStarted(state.lang)),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: ZakatPageHeader(
                        title: l10n.causesTitle,
                        subtitle: l10n.causesSubtitle,
                        leadingIcon: TablerIcons.heart_handshake,
                        bottom: _StatusTabs(selected: state.status),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _CategoryChips(selected: state.category),
                    ),
                    ..._body(context, state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _body(BuildContext context, CausesListState state) {
    final l10n = context.l10n;
    switch (state.loadStatus) {
      case CausesLoadStatus.loading:
        return const [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ];
      case CausesLoadStatus.failed:
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: CausesMessage(
              icon: Icons.cloud_off_outlined,
              message: l10n.causesLoadError,
              onRetry: () => _bloc.add(CausesListStarted(state.lang)),
            ),
          ),
        ];
      case CausesLoadStatus.loaded:
        if (state.items.isEmpty) {
          return [
            SliverFillRemaining(
              hasScrollBody: false,
              child: CausesMessage(
                icon: TablerIcons.mood_empty,
                message: l10n.causesEmpty,
              ),
            ),
          ];
        }
        return [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            sliver: SliverList.separated(
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) => SizedBox(
                height: 272,
                child: CauseCard(cause: state.items[index]),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: state.isLoadingMore
                  ? const Center(child: CircularProgressIndicator())
                  : state.loadMoreFailed
                  ? Center(
                      child: TextButton.icon(
                        onPressed: () =>
                            _bloc.add(const CausesNextPageRequested()),
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.commonRetry),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ];
    }
  }
}

class _StatusTabs extends StatelessWidget {
  const _StatusTabs({required this.selected});

  final CauseStatus selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tabs = [
      (CauseStatus.active, l10n.causesActive),
      (CauseStatus.closed, l10n.causesClosed),
    ];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.emeraldNight.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.goldLight.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          for (final (status, label) in tabs)
            Expanded(
              child: Semantics(
                button: true,
                selected: status == selected,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.read<CausesListBloc>().add(
                    CausesStatusChanged(status),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: status == selected
                          ? PrimaryHero.goldButtonGradient
                          : null,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTypography.body(
                        fontSize: 13,
                        color: status == selected
                            ? AppColors.onSecondary
                            : AppColors.mintGreen,
                        fontWeight: status == selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.selected});

  final CauseCategory? selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<CausesListBloc>();
    final options = <(CauseCategory?, String)>[
      (null, l10n.causesAllCategories),
      for (final category in CauseCategory.values)
        (category, category.label(l10n)),
    ];
    return SizedBox(
      height: 64,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (category, label) = options[index];
          return ChoiceChip(
            label: Text(label),
            selected: category == selected,
            onSelected: (_) => bloc.add(CausesCategoryChanged(category)),
          );
        },
      ),
    );
  }
}

/// Centered icon, message and optional retry, for empty and error states.
class CausesMessage extends StatelessWidget {
  const CausesMessage({
    super.key,
    required this.icon,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: scheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.body(
              fontSize: 14,
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.commonRetry),
            ),
          ],
        ],
      ),
    );
  }
}

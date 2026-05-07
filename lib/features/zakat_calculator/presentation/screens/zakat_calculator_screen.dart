import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/primary_hero.dart';
import '../../../../core/common/utils/money_formatter.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../zakat_payment/presentation/models/zakat_payment_args.dart';
import '../../bloc/zakat_calculator_bloc.dart';
import '../../bloc/zakat_calculator_event.dart';
import '../../bloc/zakat_calculator_state.dart';
import '../zakat_calculator_strings.dart';

class ZakatCalculatorScreen extends StatelessWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ZakatCalculatorBloc()..add(const ZakatCalculatorStarted()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.calcAppBarTitle)),
        body: BlocBuilder<ZakatCalculatorBloc, ZakatCalculatorState>(
          builder: (context, state) {
            final s = state as ZakatCalculatorInitial;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: s.isPricingLoading ? const _Step1Shimmer() : _Step1Card(state: s),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _CategoryTabs(activeTab: s.activeTab),
                  const SizedBox(height: 12),
                  _CategoryPanel(state: s),
                  const SizedBox(height: 12),
                  _TabOverviewCard(state: s),
                  if (s.activeTab == ZakatCategoryTab.livestock) ...[
                    const SizedBox(height: 12),
                    _LivestockPostOverviewSection(state: s),
                  ],
                  if (s.activeTab == ZakatCategoryTab.crops) ...[
                    const SizedBox(height: 12),
                    _CropPostOverviewSection(state: s),
                  ],
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => context.push(
                      '/zakat/payment',
                      extra: ZakatPaymentArgs.fromCalculator(context.l10n, s),
                    ),
                    icon: const Icon(Icons.volunteer_activism_outlined),
                    label: Text(context.l10n.calcPayYourZakat),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({required this.activeTab});
  final ZakatCategoryTab activeTab;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Center(
              child: SegmentedButton<ZakatCategoryTab>(
                segments: [
                  ButtonSegment(value: ZakatCategoryTab.wealth, label: Text(l10n.calcTabWealth)),
                  ButtonSegment(value: ZakatCategoryTab.livestock, label: Text(l10n.calcTabLivestock)),
                  ButtonSegment(value: ZakatCategoryTab.crops, label: Text(l10n.calcTabCrops)),
                ],
                selected: {activeTab},
                onSelectionChanged: (value) => context.read<ZakatCalculatorBloc>().add(
                  ZakatCategoryTabChanged(value.first),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryPanel extends StatelessWidget {
  const _CategoryPanel({required this.state});
  final ZakatCalculatorInitial state;

  @override
  Widget build(BuildContext context) {
    switch (state.activeTab) {
      case ZakatCategoryTab.wealth:
        return _WealthPanel(state: state);
      case ZakatCategoryTab.livestock:
        return _LivestockPanel(state: state);
      case ZakatCategoryTab.crops:
        return _CropsPanel(state: state);
    }
  }
}

class _Step1Card extends StatelessWidget {
  const _Step1Card({required this.state});

  final ZakatCalculatorInitial state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    switch (state.activeTab) {
      case ZakatCategoryTab.wealth:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.calcStep1NisabTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              l10n.calcStep1NisabBody,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.calcNisabGoldFormula(
                '85',
                _money(state.platformGoldPricePerGram24kEtb),
                _money(state.nisabThresholdEtb),
              ),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${ZakatCalculatorStrings.fxStatus(l10n, state.rateSource)} • ${l10n.calcUsdEtb} ${state.usdToEtbRate.toStringAsFixed(6)} • ${ZakatCalculatorStrings.formatRateTimestamp(context.contentLocale, l10n, state.rateTimestamp)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.calcNisabThresholdBanner(_money(state.nisabThresholdEtb)),
                style: theme.textTheme.titleSmall,
              ),
            ),
          ],
        );
      case ZakatCategoryTab.livestock:
        final advisory = ZakatCalculatorStrings.livestockAdvisory(l10n, state);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.calcStep1LivestockTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              l10n.calcStep1LivestockBody,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.calcStep1LivestockNisabNote,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (advisory.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                l10n.calcAdvisoryPrefix(advisory),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 8),
            _ArabicTermsDefinitionsCard(
              title: l10n.calcArabicTermDefinitionsTitle,
              compact: true,
            ),
          ],
        );
      case ZakatCategoryTab.crops:
        final isAboveNisab = state.cropKg >= ZakatCalculatorStrings.cropNisabKg;
        final ratePercent = (state.cropEffectiveRate * 100).toStringAsFixed(2);
        final formulaInner =
            '${state.cropKg.toStringAsFixed(2)} × $ratePercent% = ${state.cropZakatDueKg.toStringAsFixed(2)}kg';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.calcStep1CropTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              l10n.calcStep1CropBody,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${l10n.calcCropLineThreshold(state.cropKg.toStringAsFixed(2), isAboveNisab ? l10n.calcRelationGte : l10n.calcRelationLt)}\n'
                '${l10n.calcCropLineIrrigation(ZakatCalculatorStrings.cropModeLabel(l10n, state.cropIrrigationMode))}\n'
                '${l10n.calcCropLineEffectiveRate(ratePercent)}\n'
                '${l10n.calcCropLineFormula(formulaInner)}',
                style: theme.textTheme.titleSmall,
              ),
            ),
          ],
        );
    }
  }
}

class _TabOverviewCard extends StatelessWidget {
  const _TabOverviewCard({required this.state});

  final ZakatCalculatorInitial state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final livestockCount = state.sheepOrGoats + state.cattle + state.camels;
    final cropAboveNisab = state.cropKg >= ZakatCalculatorStrings.cropNisabKg;
    final livestockHasDue =
        state.sheepZakatDueCount > 0 ||
        state.cattleTabiDueCount > 0 ||
        state.cattleMusinnahDueCount > 0 ||
        ZakatCalculatorStrings.camelHasDue(state);

    final (title, badge, badgeActive, primaryValue, dueLabel, dueValue) = switch (state.activeTab) {
      ZakatCategoryTab.wealth => (
        l10n.calcOverviewNetWorthTitle,
        state.aboveNisab ? l10n.calcBadgeAboveNisab : l10n.calcBadgeBelowNisab,
        state.aboveNisab,
        _money(state.netWealthEtb),
        l10n.calcZakatDueLabel,
        _money(state.estimatedZakatDueEtb),
      ),
      ZakatCategoryTab.livestock => (
        l10n.calcOverviewLivestockTitle,
        livestockHasDue ? l10n.calcBadgeZakatDue : l10n.calcBadgeNoDue,
        livestockHasDue,
        l10n.calcAnimalsCount(livestockCount),
        l10n.calcLivestockDueLabel,
        ZakatCalculatorStrings.livestockSummary(l10n, state),
      ),
      ZakatCategoryTab.crops => (
        l10n.calcOverviewCropTitle,
        cropAboveNisab ? l10n.calcBadgeAboveNisab : l10n.calcBadgeBelowNisab,
        cropAboveNisab,
        l10n.calcKgHarvest(state.cropKg.toStringAsFixed(2)),
        l10n.calcCropZakatDueLabel,
        '${state.cropZakatDueKg.toStringAsFixed(2)} kg',
      ),
    };

    return Container(
      decoration: BoxDecoration(
        gradient: PrimaryHero.gradient(scheme),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: AppColors.textOnPrimary.withValues(alpha: 0.22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  badgeActive ? Icons.workspace_premium : Icons.shield_outlined,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeActive
                        ? AppColors.secondary.withValues(alpha: 0.28)
                        : AppColors.textOnPrimary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: badgeActive
                          ? AppColors.onSecondary
                          : AppColors.textOnPrimary.withValues(alpha: 0.78),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              primaryValue,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textOnPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dueLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dueValue,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: badgeActive
                          ? AppColors.primary
                          : scheme.onSurfaceVariant,
                    ),
                  ),
                  if (state.activeTab == ZakatCategoryTab.livestock) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.calcLivestockTermsFootnote,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WealthPanel extends StatelessWidget {
  const _WealthPanel({required this.state});
  final ZakatCalculatorInitial state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ZakatCalculatorBloc>();
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.calcStep2EnterAssets, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(l10n.calcStep2EnterAssetsBody, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Text(l10n.calcCashBankSavings, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _NumberField(
                    label: l10n.calcCashOnHand,
                    value: state.cashOnHand,
                    onChanged: (v) => bloc.add(WealthFieldsUpdated(cashOnHand: v)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _NumberField(
                    label: l10n.calcBankBalance,
                    value: state.bankBalance,
                    onChanged: (v) => bloc.add(WealthFieldsUpdated(bankBalance: v)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _NumberField(
                    label: l10n.calcMobileWallet,
                    value: state.mobileWallet,
                    onChanged: (v) => bloc.add(WealthFieldsUpdated(mobileWallet: v)),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 14),
            Text(l10n.calcBusinessAssets, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            ...List.generate(state.businessAssets.length, (index) {
              final item = state.businessAssets[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            initialValue: item.description,
                            decoration: InputDecoration(labelText: l10n.calcFieldDescription),
                            onChanged: (v) => bloc.add(
                              BusinessAssetUpdated(index: index, description: v),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<BusinessAssetType>(
                            initialValue: item.type,
                            isExpanded: true,
                            decoration: InputDecoration(labelText: l10n.calcFieldType),
                            items: BusinessAssetType.values
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(
                                      _assetTypeLabel(l10n, t),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => bloc.add(
                              BusinessAssetUpdated(index: index, type: v),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _NumberField(
                            label: l10n.calcAmountEtb,
                            value: item.amount,
                            onChanged: (v) => bloc.add(
                              BusinessAssetUpdated(index: index, amount: v),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => bloc.add(BusinessAssetRemoved(index)),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            OutlinedButton.icon(
              onPressed: () => bloc.add(const BusinessAssetAdded()),
              icon: const Icon(Icons.add),
              label: Text(l10n.calcAddBusinessAsset),
            ),
            const SizedBox(height: 14),
            Text(l10n.calcGoldSilver, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _NumberField(
                    label: l10n.calcGoldGrams,
                    value: state.goldGrams,
                    onChanged: (v) => bloc.add(WealthFieldsUpdated(goldGrams: v)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<GoldKarat>(
                    initialValue: state.goldKarat,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.calcGoldKarat),
                    items: GoldKarat.values
                        .map(
                          (k) => DropdownMenuItem(
                            value: k,
                            child: Text(
                              k.localizedLabel(l10n),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => bloc.add(WealthFieldsUpdated(goldKarat: v)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _NumberField(
                    label: l10n.calcSilverGrams,
                    value: state.silverGrams,
                    onChanged: (v) => bloc.add(WealthFieldsUpdated(silverGrams: v)),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 14),
            Text(l10n.calcLiabilities, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            ...List.generate(state.liabilities.length, (index) {
              final item = state.liabilities[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            initialValue: item.description,
                            decoration: InputDecoration(labelText: l10n.calcFieldDescription),
                            onChanged: (v) =>
                                bloc.add(LiabilityUpdated(index: index, description: v)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<LiabilityType>(
                            initialValue: item.type,
                            isExpanded: true,
                            decoration: InputDecoration(labelText: l10n.calcFieldType),
                            items: LiabilityType.values
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(
                                      _liabilityTypeLabel(l10n, t),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => bloc.add(
                              LiabilityUpdated(index: index, type: v),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _NumberField(
                            label: l10n.calcAmountEtb,
                            value: item.amount,
                            onChanged: (v) =>
                                bloc.add(LiabilityUpdated(index: index, amount: v)),
                          ),
                        ),
                        IconButton(
                          onPressed: () => bloc.add(LiabilityRemoved(index)),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            OutlinedButton.icon(
              onPressed: () => bloc.add(const LiabilityAdded()),
              icon: const Icon(Icons.add),
              label: Text(l10n.calcAddLiability),
            ),
          ],
        ),
      ),
    );
  }
}

class _LivestockPanel extends StatelessWidget {
  const _LivestockPanel({required this.state});
  final ZakatCalculatorInitial state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ZakatCalculatorBloc>();
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IntField(
              label: l10n.calcLivestockSheepGoats,
              value: state.sheepOrGoats,
              onChanged: (v) => bloc.add(LivestockFieldsUpdated(sheepOrGoats: v)),
            ),
            const SizedBox(height: 8),
            _IntField(
              label: l10n.calcLivestockCattle,
              value: state.cattle,
              onChanged: (v) => bloc.add(LivestockFieldsUpdated(cattle: v)),
            ),
            const SizedBox(height: 8),
            _IntField(
              label: l10n.calcLivestockCamels,
              value: state.camels,
              onChanged: (v) => bloc.add(LivestockFieldsUpdated(camels: v)),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: state.isPastureFedMostOfYear,
              title: Text(l10n.calcPastureFedTitle),
              subtitle: Text(l10n.calcPastureFedSubtitle),
              onChanged: (v) => bloc.add(
                LivestockFieldsUpdated(isPastureFedMostOfYear: v),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: state.completedHawl,
              title: Text(l10n.calcHawlTitle),
              subtitle: Text(l10n.calcHawlSubtitle),
              onChanged: (v) => bloc.add(
                LivestockFieldsUpdated(completedHawl: v),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: state.usedForWork,
              title: Text(l10n.calcWorkAnimalsTitle),
              subtitle: Text(l10n.calcWorkAnimalsSubtitle),
              onChanged: (v) => bloc.add(
                LivestockFieldsUpdated(usedForWork: v),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LivestockPostOverviewSection extends StatelessWidget {
  const _LivestockPostOverviewSection({required this.state});

  final ZakatCalculatorInitial state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.calcLivestockSummaryHeading,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                ZakatCalculatorStrings.livestockSummary(l10n, state),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            ZakatCalculatorStrings.livestockTransparency(l10n, state),
            style: theme.textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 10),
        _ArabicTermsDefinitionsCard(title: l10n.calcArabicTermDefinitionsTitle),
      ],
    );
  }
}

class _CropsPanel extends StatelessWidget {
  const _CropsPanel({required this.state});
  final ZakatCalculatorInitial state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ZakatCalculatorBloc>();
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NumberField(
              label: l10n.calcCropWeightKg,
              value: state.cropKg,
              onChanged: (v) => bloc.add(CropFieldsUpdated(cropKg: v)),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<CropIrrigationMode>(
                segments: [
                  ButtonSegment(
                    value: CropIrrigationMode.rainFed,
                    label: Text(l10n.calcCropModeRainFed),
                  ),
                  ButtonSegment(
                    value: CropIrrigationMode.irrigated,
                    label: Text(l10n.calcCropModeIrrigated),
                  ),
                  ButtonSegment(
                    value: CropIrrigationMode.mixed,
                    label: Text(l10n.calcCropModeMixed),
                  ),
                ],
                selected: {state.cropIrrigationMode},
                onSelectionChanged: (value) => bloc.add(
                  CropFieldsUpdated(cropIrrigationMode: value.first),
                ),
              ),
            ),
            if (state.cropIrrigationMode == CropIrrigationMode.mixed) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _NumberField(
                      label: l10n.calcRainFedSharePct,
                      value: state.rainSharePercent,
                      onChanged: (v) => bloc.add(CropFieldsUpdated(rainSharePercent: v)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _NumberField(
                      label: l10n.calcIrrigatedSharePct,
                      value: state.irrigatedSharePercent,
                      onChanged: (v) => bloc.add(CropFieldsUpdated(irrigatedSharePercent: v)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CropPostOverviewSection extends StatelessWidget {
  const _CropPostOverviewSection({required this.state});

  final ZakatCalculatorInitial state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.calcCropNisabHeading,
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.calcEffectiveCropRateLine(
                  (state.cropEffectiveRate * 100).toStringAsFixed(2),
                ),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 2),
              Text(
                l10n.calcCropZakatDueKgLine(state.cropZakatDueKg.toStringAsFixed(2)),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.calcHowCropZakatWorksTitle,
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.calcHowCropZakatWorksBody,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.calcHowCropZakatNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            ZakatCalculatorStrings.cropTransparency(l10n, state),
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value == 0 ? '0' : value.toStringAsFixed(2),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
      onChanged: (v) => onChanged(double.tryParse(v) ?? 0),
    );
  }
}

class _IntField extends StatelessWidget {
  const _IntField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      onChanged: (v) => onChanged(int.tryParse(v) ?? 0),
    );
  }
}

class _ArabicTermsDefinitionsCard extends StatelessWidget {
  const _ArabicTermsDefinitionsCard({
    required this.title,
    this.compact = false,
  });

  final String title;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (compact) {
      return ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        children: [
          _ArabicTermsDefinitionBody(compact: compact),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          _ArabicTermsDefinitionBody(),
        ],
      ),
    );
  }
}

class _ArabicTermsDefinitionBody extends StatelessWidget {
  const _ArabicTermsDefinitionBody({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ZakatCalculatorStrings.arabicTermEntries(l10n)
          .map(
            (entry) => Padding(
              padding: EdgeInsets.only(bottom: compact ? 4 : 6),
              child: Text(
                '${entry.key}: ${entry.value}',
                style: theme.textTheme.bodySmall,
              ),
            ),
          )
          .toList(),
    );
  }
}

String _assetTypeLabel(AppLocalizations l, BusinessAssetType type) {
  switch (type) {
    case BusinessAssetType.inventory:
      return l.calcAssetInventory;
    case BusinessAssetType.receivable:
      return l.calcAssetReceivable;
    case BusinessAssetType.other:
      return l.calcAssetOther;
  }
}

String _liabilityTypeLabel(AppLocalizations l, LiabilityType type) {
  switch (type) {
    case LiabilityType.shortTermDebt:
      return l.calcLiabilityShortTermDebt;
    case LiabilityType.payable:
      return l.calcLiabilityPayable;
    case LiabilityType.other:
      return l.calcLiabilityOther;
  }
}

String _money(double value) => MoneyFormatter.etb(value);

class _Step1Shimmer extends StatefulWidget {
  const _Step1Shimmer();

  @override
  State<_Step1Shimmer> createState() => _Step1ShimmerState();
}

class _Step1ShimmerState extends State<_Step1Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surface;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final width = bounds.width;
            final progress = _controller.value;
            return LinearGradient(
              begin: Alignment(-1.0 + (2.0 * progress), 0),
              end: Alignment(-0.2 + (2.0 * progress), 0),
              colors: [base, highlight, base],
              stops: const [0.1, 0.45, 0.9],
            ).createShader(Rect.fromLTWH(0, 0, width, bounds.height));
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _ShimmerBox(height: 18, widthFactor: 0.42),
          SizedBox(height: 8),
          _ShimmerBox(height: 12, widthFactor: 0.95),
          SizedBox(height: 6),
          _ShimmerBox(height: 12, widthFactor: 0.88),
          SizedBox(height: 10),
          _ShimmerBox(height: 12, widthFactor: 0.75),
          SizedBox(height: 12),
          _ShimmerBox(height: 44, widthFactor: 1),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.height, required this.widthFactor});

  final double height;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

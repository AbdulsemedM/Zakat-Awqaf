import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/utils/money_formatter.dart';
import '../../../zakat_payment/presentation/models/zakat_payment_args.dart';
import '../../bloc/zakat_calculator_bloc.dart';
import '../../bloc/zakat_calculator_event.dart';
import '../../bloc/zakat_calculator_state.dart';

const Map<String, String> kLivestockArabicTermDefinitions = {
  "tabi'": 'one-year-old calf',
  'musinnah': 'two-year-old cow',
  'bint makhad': 'one-year-old she-camel',
  'bint labun': 'two-year-old she-camel',
  'hiqqah': 'three-year-old she-camel',
  'jadhah': 'four-year-old she-camel',
};

class ZakatCalculatorScreen extends StatelessWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ZakatCalculatorBloc()..add(const ZakatCalculatorStarted()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Zakat Calculator')),
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
                      extra: ZakatPaymentArgs.fromCalculator(s),
                    ),
                    icon: const Icon(Icons.volunteer_activism_outlined),
                    label: const Text('Pay Your Zakat'),
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
    return SegmentedButton<ZakatCategoryTab>(
      segments: const [
        ButtonSegment(value: ZakatCategoryTab.wealth, label: Text('Wealth')),
        ButtonSegment(value: ZakatCategoryTab.livestock, label: Text('Livestock')),
        ButtonSegment(value: ZakatCategoryTab.crops, label: Text('Crops')),
      ],
      selected: {activeTab},
      onSelectionChanged: (value) => context.read<ZakatCalculatorBloc>().add(
        ZakatCategoryTabChanged(value.first),
      ),
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
    switch (state.activeTab) {
      case ZakatCategoryTab.wealth:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step 1: Nisab threshold', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Zakat is due if your net wealth exceeds the threshold. '
              'Nisab is based on 85g of platform 24k gold price.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              '85 × ${_money(state.platformGoldPricePerGram24kEtb)} = ${_money(state.nisabThresholdEtb)}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${state.pricingStatusText} • USD/ETB ${state.usdToEtbRate.toStringAsFixed(6)} • ${_formatTimestamp(state.rateTimestamp)}',
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
                'Nisab threshold (platform rate, 85g gold equivalent): ${_money(state.nisabThresholdEtb)}',
                style: theme.textTheme.titleSmall,
              ),
            ),
          ],
        );
      case ZakatCategoryTab.livestock:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step 1: Livestock scale method', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Livestock Zakat is calculated by physical head-count scales (not % of value).',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Nisab thresholds: Sheep/Goats 40, Cattle 30, Camels 5. '
              'Cattle uses 30/40 combinations; camels follow tier ranges.',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (state.livestockAdvisoryText.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Advisory: ${state.livestockAdvisoryText}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 8),
            _ArabicTermsDefinitionsCard(
              title: 'Arabic Term Definitions',
              compact: true,
            ),
          ],
        );
      case ZakatCategoryTab.crops:
        final isAboveNisab = state.cropKg >= 653;
        final ratePercent = (state.cropEffectiveRate * 100).toStringAsFixed(2);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step 1: Crop (Ushr) calculation', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Crop Zakat is due at harvest. Nisab is 653kg. '
              'Rate is 10% (rain-fed), 5% (irrigated), or weighted for mixed.',
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
                'Threshold check: ${state.cropKg.toStringAsFixed(2)}kg ${isAboveNisab ? ">=" : "<"} 653kg'
                '\nIrrigation mode: ${_cropModeLabel(state.cropIrrigationMode)}'
                '\nEffective rate: $ratePercent%'
                '\nFormula: ${state.cropKg.toStringAsFixed(2)} × $ratePercent% = ${state.cropZakatDueKg.toStringAsFixed(2)}kg',
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
    final livestockCount = state.sheepOrGoats + state.cattle + state.camels;
    final cropAboveNisab = state.cropKg >= 653;

    final (title, badge, badgeActive, primaryValue, dueLabel, dueValue) = switch (state.activeTab) {
      ZakatCategoryTab.wealth => (
        'Net Worth Overview',
        state.aboveNisab ? 'Above Nisab' : 'Below Nisab',
        state.aboveNisab,
        _money(state.netWealthEtb),
        'Zakat Due',
        _money(state.estimatedZakatDueEtb),
      ),
      ZakatCategoryTab.livestock => (
        'Livestock Overview',
        (state.sheepZakatDueCount > 0 ||
                state.cattleTabiDueCount > 0 ||
                state.cattleMusinnahDueCount > 0 ||
                state.camelZakatDueDescription != 'No due')
            ? 'Zakat Due'
            : 'No Due',
        state.sheepZakatDueCount > 0 ||
            state.cattleTabiDueCount > 0 ||
            state.cattleMusinnahDueCount > 0 ||
            state.camelZakatDueDescription != 'No due',
        '$livestockCount animals',
        'Livestock Due',
        state.livestockSummaryText,
      ),
      ZakatCategoryTab.crops => (
        'Crop Overview',
        cropAboveNisab ? 'Above Nisab' : 'Below Nisab',
        cropAboveNisab,
        '${state.cropKg.toStringAsFixed(2)} kg harvest',
        'Crop Zakat Due',
        '${state.cropZakatDueKg.toStringAsFixed(2)} kg',
      ),
    };

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.65),
            theme.colorScheme.secondaryContainer.withValues(alpha: 0.45),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
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
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeActive
                        ? theme.colorScheme.primary.withValues(alpha: 0.16)
                        : theme.colorScheme.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: badgeActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
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
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dueLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dueValue,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: badgeActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (state.activeTab == ZakatCategoryTab.livestock) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Terms like tabi\', musinnah, bint makhad, bint labun, hiqqah, and jadhah are explained below in Livestock details.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step 2: Enter Your Assets', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Enter the value of your assets in ETB', style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Text('Cash & Bank Savings', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _NumberField(
                    label: 'Cash on Hand',
                    value: state.cashOnHand,
                    onChanged: (v) => bloc.add(WealthFieldsUpdated(cashOnHand: v)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _NumberField(
                    label: 'Bank Balance',
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
                    label: 'Mobile Wallet',
                    value: state.mobileWallet,
                    onChanged: (v) => bloc.add(WealthFieldsUpdated(mobileWallet: v)),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 14),
            Text('Business Assets', style: theme.textTheme.titleSmall),
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
                            decoration: const InputDecoration(labelText: 'Description'),
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
                            decoration: const InputDecoration(labelText: 'Type'),
                            items: BusinessAssetType.values
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(
                                      _assetTypeLabel(t),
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
                            label: 'Amount (ETB)',
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
              label: const Text('Add business asset'),
            ),
            const SizedBox(height: 14),
            Text('Gold & Silver', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _NumberField(
                    label: 'Gold (grams)',
                    value: state.goldGrams,
                    onChanged: (v) => bloc.add(WealthFieldsUpdated(goldGrams: v)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<GoldKarat>(
                    initialValue: state.goldKarat,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Gold Karat'),
                    items: GoldKarat.values
                        .map(
                          (k) => DropdownMenuItem(
                            value: k,
                            child: Text(k.label, overflow: TextOverflow.ellipsis),
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
                    label: 'Silver (grams)',
                    value: state.silverGrams,
                    onChanged: (v) => bloc.add(WealthFieldsUpdated(silverGrams: v)),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 14),
            Text('Liabilities', style: theme.textTheme.titleSmall),
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
                            decoration: const InputDecoration(labelText: 'Description'),
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
                            decoration: const InputDecoration(labelText: 'Type'),
                            items: LiabilityType.values
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(
                                      _liabilityTypeLabel(t),
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
                            label: 'Amount (ETB)',
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
              label: const Text('Add liability'),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IntField(
              label: 'Sheep / Goats',
              value: state.sheepOrGoats,
              onChanged: (v) => bloc.add(LivestockFieldsUpdated(sheepOrGoats: v)),
            ),
            const SizedBox(height: 8),
            _IntField(
              label: 'Cattle',
              value: state.cattle,
              onChanged: (v) => bloc.add(LivestockFieldsUpdated(cattle: v)),
            ),
            const SizedBox(height: 8),
            _IntField(
              label: 'Camels',
              value: state.camels,
              onChanged: (v) => bloc.add(LivestockFieldsUpdated(camels: v)),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: state.isPastureFedMostOfYear,
              title: const Text('Pasture-fed most of the year'),
              subtitle: const Text('Advisory only; does not block calculation'),
              onChanged: (v) => bloc.add(
                LivestockFieldsUpdated(isPastureFedMostOfYear: v),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: state.completedHawl,
              title: const Text('Completed one lunar year (hawl)'),
              subtitle: const Text('Advisory only; does not block calculation'),
              onChanged: (v) => bloc.add(
                LivestockFieldsUpdated(completedHawl: v),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: state.usedForWork,
              title: const Text('Used for work (plowing/transport)'),
              subtitle: const Text('Advisory only; does not block calculation'),
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
                'Livestock summary',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                state.livestockSummaryText,
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
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            state.livestockTransparencyText,
            style: theme.textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 10),
        const _ArabicTermsDefinitionsCard(title: 'Arabic Term Definitions'),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NumberField(
              label: 'Crop Weight (kg)',
              value: state.cropKg,
              onChanged: (v) => bloc.add(CropFieldsUpdated(cropKg: v)),
            ),
            const SizedBox(height: 8),
            SegmentedButton<CropIrrigationMode>(
              segments: const [
                ButtonSegment(
                  value: CropIrrigationMode.rainFed,
                  label: Text('Rain-fed'),
                ),
                ButtonSegment(
                  value: CropIrrigationMode.irrigated,
                  label: Text('Irrigated'),
                ),
                ButtonSegment(
                  value: CropIrrigationMode.mixed,
                  label: Text('Mixed'),
                ),
              ],
              selected: {state.cropIrrigationMode},
              onSelectionChanged: (value) => bloc.add(
                CropFieldsUpdated(cropIrrigationMode: value.first),
              ),
            ),
            if (state.cropIrrigationMode == CropIrrigationMode.mixed) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _NumberField(
                      label: 'Rain-fed share %',
                      value: state.rainSharePercent,
                      onChanged: (v) => bloc.add(CropFieldsUpdated(rainSharePercent: v)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _NumberField(
                      label: 'Irrigated share %',
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
                'Nisab & crop due',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Effective crop rate: ${(state.cropEffectiveRate * 100).toStringAsFixed(2)}%',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 2),
              Text(
                'Crop Zakat due: ${state.cropZakatDueKg.toStringAsFixed(2)} kg',
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
                'How crop Zakat works',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Nisab: 653kg. Rates: rain-fed 10%, irrigated 5%, mixed = weighted split. '
                'Zakat is due at harvest (no annual hawl for crops).',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Note: App applies these rules broadly for simplicity. Scholarly positions differ '
                'on crop-type scope and expense deductions; consult qualified scholars for specific cases.',
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
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            state.cropTransparencyText,
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
          const _ArabicTermsDefinitionBody(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: kLivestockArabicTermDefinitions.entries
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

String _assetTypeLabel(BusinessAssetType type) {
  switch (type) {
    case BusinessAssetType.inventory:
      return 'Inventory';
    case BusinessAssetType.receivable:
      return 'Receivable';
    case BusinessAssetType.other:
      return 'Other';
  }
}

String _liabilityTypeLabel(LiabilityType type) {
  switch (type) {
    case LiabilityType.shortTermDebt:
      return 'Short-term debt';
    case LiabilityType.payable:
      return 'Payable';
    case LiabilityType.other:
      return 'Other';
  }
}

String _cropModeLabel(CropIrrigationMode mode) {
  switch (mode) {
    case CropIrrigationMode.rainFed:
      return 'Rain-fed';
    case CropIrrigationMode.irrigated:
      return 'Irrigated';
    case CropIrrigationMode.mixed:
      return 'Mixed';
  }
}

String _money(double value) => MoneyFormatter.etb(value);

String _formatTimestamp(DateTime? timestamp) {
  if (timestamp == null) return 'timestamp unavailable';
  final local = timestamp.toLocal();
  final y = local.year.toString().padLeft(4, '0');
  final m = local.month.toString().padLeft(2, '0');
  final d = local.day.toString().padLeft(2, '0');
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  return '$y-$m-$d $hh:$mm';
}

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

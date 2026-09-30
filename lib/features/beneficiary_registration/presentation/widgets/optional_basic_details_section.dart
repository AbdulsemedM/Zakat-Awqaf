import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/beneficiary_registration_bloc.dart';
import '../../bloc/beneficiary_registration_event.dart';
import '../../bloc/beneficiary_registration_state.dart';
import '../../data/models/basic_detail_options.dart';

/// Collapsible optional basic details for manual registration. The field
/// officer completes anything left empty before the assessment is submitted.
class OptionalBasicDetailsSection extends StatelessWidget {
  const OptionalBasicDetailsSection({required this.state, super.key});

  final BeneficiaryRegistrationState state;

  static String maritalLabel(AppLocalizations l10n, MaritalStatus v) =>
      switch (v) {
        MaritalStatus.single => l10n.regMaritalSingle,
        MaritalStatus.married => l10n.regMaritalMarried,
        MaritalStatus.widowed => l10n.regMaritalWidowed,
        MaritalStatus.divorced => l10n.regMaritalDivorced,
        MaritalStatus.separated => l10n.regMaritalSeparated,
      };

  static String languageLabel(AppLocalizations l10n, PrimaryLanguage v) =>
      switch (v) {
        PrimaryLanguage.amharic => l10n.regLangAmharic,
        PrimaryLanguage.afaanOromo => l10n.regLangAfaanOromo,
        PrimaryLanguage.tigrinya => l10n.regLangTigrinya,
        PrimaryLanguage.somali => l10n.regLangSomali,
        PrimaryLanguage.afar => l10n.regLangAfar,
        PrimaryLanguage.other => l10n.regLangOther,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    const gap = SizedBox(height: 10);

    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        maintainState: true,
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: 8),
        title: Text(l10n.regMoreDetailsTitle, style: theme.textTheme.titleMedium),
        subtitle: Text(
          l10n.regMoreDetailsSubtitle,
          style: theme.textTheme.bodySmall,
        ),
        children: [
          // National ID is disabled for now; the field officer records it.
          // TextFormField(
          //   initialValue: state.nationalId,
          //   onChanged: (v) => bloc.add(NationalIdUpdated(v)),
          //   decoration: InputDecoration(labelText: l10n.regNationalId),
          // ),
          // gap,
          DropdownButtonFormField<MaritalStatus?>(
            initialValue: state.maritalStatus,
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.regNotSpecified)),
              for (final v in MaritalStatus.values)
                DropdownMenuItem(value: v, child: Text(maritalLabel(l10n, v))),
            ],
            onChanged: (v) => bloc.add(MaritalStatusUpdated(v)),
            decoration: InputDecoration(labelText: l10n.regMaritalStatus),
          ),
          gap,
          DropdownButtonFormField<PrimaryLanguage?>(
            initialValue: state.primaryLanguage,
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.regNotSpecified)),
              for (final v in PrimaryLanguage.values)
                DropdownMenuItem(value: v, child: Text(languageLabel(l10n, v))),
            ],
            onChanged: (v) => bloc.add(PrimaryLanguageUpdated(v)),
            decoration: InputDecoration(labelText: l10n.regPrimaryLanguage),
          ),
          if (state.primaryLanguage == PrimaryLanguage.other) ...[
            gap,
            TextFormField(
              initialValue: state.primaryLanguageOther,
              onChanged: (v) => bloc.add(PrimaryLanguageOtherUpdated(v)),
              decoration: InputDecoration(
                labelText: l10n.regPrimaryLanguageOther,
              ),
            ),
          ],
          gap,
          TextFormField(
            initialValue: state.religion,
            onChanged: (v) => bloc.add(ReligionUpdated(v)),
            decoration: InputDecoration(labelText: l10n.regReligion),
          ),
          gap,
          TextFormField(
            initialValue: state.kebele,
            onChanged: (v) => bloc.add(KebeleUpdated(v)),
            decoration: InputDecoration(labelText: l10n.regKebele),
          ),
          gap,
          TextFormField(
            initialValue: state.address,
            onChanged: (v) => bloc.add(AddressUpdated(v)),
            decoration: InputDecoration(labelText: l10n.regAddressLine),
          ),
        ],
      ),
    );
  }
}

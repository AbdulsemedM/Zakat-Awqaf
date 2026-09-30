import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../bloc/beneficiary_registration_bloc.dart';
import '../../bloc/beneficiary_registration_event.dart';
import '../../bloc/beneficiary_registration_state.dart';

/// Registration code input with a Verify action. Once the code is accepted,
/// shows the branch it belongs to so the applicant can confirm it.
class RegistrationCodeField extends StatelessWidget {
  const RegistrationCodeField({required this.state, super.key});

  final BeneficiaryRegistrationState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final bloc = context.read<BeneficiaryRegistrationBloc>();
    final verified = state.isRegistrationCodeVerified;
    final validation = state.codeValidation;

    final Widget suffix;
    if (state.isValidatingCode) {
      suffix = const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else if (verified) {
      suffix = Icon(Icons.verified_rounded, color: theme.colorScheme.primary);
    } else {
      suffix = TextButton(
        onPressed: state.registrationCode.trim().isEmpty
            ? null
            : () => bloc.add(const RegistrationCodeValidationRequested()),
        child: Text(l10n.regVerifyCode),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          initialValue: state.registrationCode,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.done,
          onChanged: (v) => bloc.add(RegistrationCodeUpdated(v)),
          onFieldSubmitted: (_) =>
              bloc.add(const RegistrationCodeValidationRequested()),
          decoration: InputDecoration(
            labelText: l10n.regRegistrationCodeLabel,
            hintText: l10n.regRegistrationCodeHint,
            suffixIcon: suffix,
          ),
        ),
        if (verified && validation != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.account_balance_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.regCodeBranchLabel(validation.branchName ?? '-'),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (validation.locationLine.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          validation.locationLine,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        l10n.regCodeBranchConfirm,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

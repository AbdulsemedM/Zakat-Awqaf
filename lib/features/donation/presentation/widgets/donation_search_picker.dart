import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/l10n/l10n.dart';
import '../../data/donation_picker_option.dart';

/// Opens a searchable bottom sheet and returns the selected [DonationPickerOption].
Future<DonationPickerOption?> showDonationSearchPicker({
  required BuildContext context,
  required String title,
  required String searchHint,
  required List<DonationPickerOption> options,
  String Function(DonationPickerOption option)? itemSubtitle,
}) {
  return showModalBottomSheet<DonationPickerOption>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _DonationSearchPickerSheet(
      title: title,
      searchHint: searchHint,
      options: options,
      itemSubtitle: itemSubtitle,
    ),
  );
}

class DonationSearchPickerField extends StatelessWidget {
  const DonationSearchPickerField({
    required this.label,
    required this.hintText,
    required this.displayText,
    required this.onTap,
    super.key,
  });

  final String label;
  final String hintText;
  final String? displayText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = displayText != null && displayText!.trim().isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: theme.colorScheme.surface,
        ),
        child: Text(
          hasValue ? displayText! : hintText,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: hasValue
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _DonationSearchPickerSheet extends StatefulWidget {
  const _DonationSearchPickerSheet({
    required this.title,
    required this.searchHint,
    required this.options,
    this.itemSubtitle,
  });

  final String title;
  final String searchHint;
  final List<DonationPickerOption> options;
  final String Function(DonationPickerOption option)? itemSubtitle;

  @override
  State<_DonationSearchPickerSheet> createState() =>
      _DonationSearchPickerSheetState();
}

class _DonationSearchPickerSheetState extends State<_DonationSearchPickerSheet> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<DonationPickerOption> get _filtered {
    return widget.options.where((o) => o.matchesQuery(_query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final filtered = _filtered;

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 12 + bottomInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _search,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: widget.searchHint,
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                        ),
                        onChanged: (value) => setState(() => _query = value),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: filtered.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            l10n.donationNoMatchesFound,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.5),
                          ),
                          itemBuilder: (context, index) {
                            final option = filtered[index];
                            final subtitle = widget.itemSubtitle?.call(option);
                            return ListTile(
                              title: Text(option.label),
                              subtitle: subtitle != null
                                  ? Text(
                                      subtitle,
                                      style: TextStyle(
                                        color: AppColors.mutedText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : null,
                              trailing: Text(
                                option.value,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: AppColors.awqafPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onTap: () =>
                                  Navigator.of(context).pop(option),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

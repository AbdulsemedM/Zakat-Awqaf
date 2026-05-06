import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';

class ZakatMethodologySheet extends StatelessWidget {
  const ZakatMethodologySheet({super.key});

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => const ZakatMethodologySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(context.l10n.calcMethodologyPlaceholder),
    );
  }
}

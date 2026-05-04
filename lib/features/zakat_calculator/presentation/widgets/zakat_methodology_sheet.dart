import 'package:flutter/material.dart';

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
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Zakat methodology content placeholder.'),
    );
  }
}

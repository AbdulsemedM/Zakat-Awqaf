import 'package:flutter/material.dart';

import '../theme/zakat_theme.dart';

/// Applies Zakat typography (Inter + Playfair) to [child] without affecting Awqaf.
class ZakatThemed extends StatelessWidget {
  const ZakatThemed({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(data: ZakatTheme.of(context), child: child);
  }
}

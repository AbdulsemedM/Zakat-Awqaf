import 'package:flutter/material.dart';

import '../../../../app/widgets/islamic_ornaments.dart';

/// Registration form surface; matches the premium cards used across Zakat.
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(padding: padding, child: child);
  }
}

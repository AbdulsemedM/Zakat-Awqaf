import 'package:flutter/widgets.dart';

import '../../core/auth/payer_access.dart';
import '../../core/di/injection.dart';

/// Shows [child] only to people who may pay zakat (guests and donors);
/// beneficiaries see [fallback].
class PayerOnly extends StatelessWidget {
  const PayerOnly({
    super.key,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  final Widget child;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    final access = getIt<PayerAccess>();
    return ListenableBuilder(
      listenable: access,
      builder: (context, _) => access.canPay ? child : fallback,
    );
  }
}

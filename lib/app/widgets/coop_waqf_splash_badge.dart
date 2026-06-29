import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/l10n/l10n.dart';
import '../theme/app_colors.dart';

/// Bottom-left partner mark on the custom startup splash.
class CoopWaqfSplashBadge extends StatelessWidget {
  const CoopWaqfSplashBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final width = MediaQuery.sizeOf(context).width;
    final logoWidth = width < 360 ? 118.0 : 138.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF081510).withValues(alpha: 0.42),
        border: Border.all(
          color: AppColors.warmGold.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.splashWaqfByLabel,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.1,
                color: AppColors.mintGreen.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 6),
            Image.asset(
              AppAssets.coopBankAlhudaLogo,
              width: logoWidth,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/widgets/home_shared.dart';
import '../../data/models/cause.dart';

extension CauseCategoryVisuals on CauseCategory {
  String label(AppLocalizations l) => switch (this) {
    CauseCategory.education => l.causeCategoryEducation,
    CauseCategory.water => l.causeCategoryWater,
    CauseCategory.health => l.causeCategoryHealth,
    CauseCategory.food => l.causeCategoryFood,
    CauseCategory.shelter => l.causeCategoryShelter,
    CauseCategory.livelihood => l.causeCategoryLivelihood,
    CauseCategory.emergency => l.causeCategoryEmergency,
    CauseCategory.general => l.causeCategoryGeneral,
  };

  IconData get icon => switch (this) {
    CauseCategory.education => TablerIcons.book,
    CauseCategory.water => TablerIcons.droplet,
    CauseCategory.health => TablerIcons.heartbeat,
    CauseCategory.food => TablerIcons.bowl,
    CauseCategory.shelter => TablerIcons.home,
    CauseCategory.livelihood => TablerIcons.briefcase,
    CauseCategory.emergency => TablerIcons.alert_triangle,
    CauseCategory.general => TablerIcons.heart_handshake,
  };

  /// Banner gradient used when a cause has no image.
  List<Color> get bannerColors => switch (this) {
    CauseCategory.education => const [
      AppColors.forestMid,
      AppColors.forestLight,
    ],
    CauseCategory.water => const [
      AppColors.waterGradientStart,
      AppColors.waterGradientEnd,
    ],
    CauseCategory.health => const [
      AppColors.healthGradientStart,
      AppColors.healthGradientEnd,
    ],
    CauseCategory.food => const [AppColors.goldDeep, AppColors.warmGold],
    CauseCategory.shelter => const [AppColors.forestGreen, AppColors.forestMid],
    CauseCategory.livelihood => const [
      AppColors.sadaqahGradientStart,
      AppColors.goldDeep,
    ],
    CauseCategory.emergency => const [
      AppColors.emergencyGradientStart,
      AppColors.emergencyGradientEnd,
    ],
    CauseCategory.general => const [
      AppColors.emeraldNight,
      AppColors.forestLight,
    ],
  };
}

String causeBadgeLabel(AppLocalizations l, CauseBadge badge) => switch (badge) {
  CauseBadge.urgent => l.causeBadgeUrgent,
  CauseBadge.essential => l.causeBadgeEssential,
};

String formatCauseDate(Locale locale, DateTime date) =>
    DateFormat.yMMMd(locale.toString()).format(date);

/// A cause's image, or its category gradient and icon when it has none
/// (or the image fails to load), with the badge on top.
class CauseBanner extends StatelessWidget {
  const CauseBanner({
    super.key,
    required this.cause,
    required this.l10n,
    this.imageUrl,
    this.iconSize = 22,
  });

  final Cause cause;
  final AppLocalizations l10n;

  /// Defaults to [Cause.imageUrl].
  final String? imageUrl;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl ?? cause.imageUrl;
    final badge = cause.badge;
    return Stack(
      fit: StackFit.expand,
      children: [
        CauseCategoryBackdrop(category: cause.category, iconSize: iconSize),
        if (url != null)
          Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
            frameBuilder: (context, child, frame, wasSyncLoaded) =>
                wasSyncLoaded
                ? child
                : AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 250),
                    child: child,
                  ),
          ),
        if (badge != null)
          PositionedDirectional(
            top: 12,
            start: 12,
            child: TagPill(
              label: causeBadgeLabel(l10n, badge),
              style: badge == CauseBadge.urgent
                  ? TagStyle.gold
                  : TagStyle.green,
            ),
          ),
      ],
    );
  }
}

/// Category gradient with the Islamic pattern and the category icon.
class CauseCategoryBackdrop extends StatelessWidget {
  const CauseCategoryBackdrop({
    super.key,
    required this.category,
    this.iconSize = 22,
  });

  final CauseCategory category;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: category.bannerColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        const IslamicPatternLayer(
          opacity: 0.22,
          cell: 30,
          color: AppColors.goldLight,
          fadeTo: Alignment.bottomLeft,
        ),
        PositionedDirectional(
          end: 14,
          bottom: 12,
          child: Container(
            width: iconSize * 2,
            height: iconSize * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.16),
              border: Border.all(
                color: AppColors.goldLight.withValues(alpha: 0.6),
              ),
            ),
            child: Icon(category.icon, color: Colors.white, size: iconSize),
          ),
        ),
      ],
    );
  }
}

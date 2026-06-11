import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

/// Semi-transparent gold ring circles for Islamic motif decoration.
class IslamicOrnamentDecoration extends StatelessWidget {
  const IslamicOrnamentDecoration({super.key});

  static const double _width = 110;
  static const double _height = 90;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -20,
            right: -10,
            child: _ornamentRing(size: 80, opacity: 0.25),
          ),
          Positioned(
            top: 10,
            right: 30,
            child: _ornamentRing(size: 50, opacity: 0.18),
          ),
          Positioned(
            top: -5,
            right: 70,
            child: _ornamentRing(size: 35, opacity: 0.12),
          ),
        ],
      ),
    );
  }

  Widget _ornamentRing({required double size, required double opacity}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.warmGold.withValues(alpha: opacity * 4),
          width: 1.5,
        ),
      ),
    );
  }
}

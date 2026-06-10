import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';

/// Full-color logo for splash, onboarding, and inline layouts.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.height = 120,
    this.width,
    this.fit = BoxFit.contain,
    this.borderRadius,
  });

  final double height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      AppAssets.appLogo,
      height: height,
      width: width,
      fit: fit,
      gaplessPlayback: true,
      filterQuality: FilterQuality.high,
    );
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}

/// Compact logo for [AppBar.leading] (Material 3 default toolbar height).
class AppBarBrandLeading extends StatelessWidget {
  const AppBarBrandLeading({super.key, this.height = 26});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10, end: 2),
      child: Center(
        child: AppLogo(height: height, fit: BoxFit.contain),
      ),
    );
  }
}

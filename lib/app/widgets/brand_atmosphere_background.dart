import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Full-bleed layered background matching the startup splash (gradients,
/// arcs, geometry, aurora blobs, vignette). Use under [ClipRRect] or inside
/// [Positioned.fill] with bounded constraints.
class BrandAtmosphereBackground extends StatelessWidget {
  const BrandAtmosphereBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        if (w <= 0 || h <= 0) {
          return const SizedBox.shrink();
        }
        return Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.28, 0.55, 0.82, 1.0],
                  colors: [
                    Color.lerp(AppColors.primary, Colors.black, 0.52)!,
                    Color.lerp(AppColors.primary, Colors.black, 0.38)!,
                    AppColors.primary,
                    Color.lerp(AppColors.primary, Colors.white, 0.06)!,
                    Color.lerp(AppColors.primary, Colors.black, 0.58)!,
                  ],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.85, -0.95),
                  radius: 1.35,
                  colors: [
                    Color.lerp(AppColors.primary, Colors.white, 0.22)!.withValues(alpha: 0.55),
                    Color.lerp(AppColors.primary, Colors.black, 0.42)!.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(1.0, 0.35),
                  radius: 1.15,
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.2, 1.05),
                  radius: 1.0,
                  colors: [
                    Color.lerp(AppColors.primary, Colors.black, 0.35)!.withValues(alpha: 0.35),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: BrandFlowingArcsPainter(),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: BrandGeometricPatternPainter(),
              ),
            ),
            Positioned(
              top: -h * 0.12,
              left: -w * 0.22,
              child: BrandAuroraBlob(
                width: w * 0.95,
                height: w * 0.95,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Positioned(
              top: h * 0.18,
              right: -w * 0.28,
              child: BrandAuroraBlob(
                width: w * 0.78,
                height: w * 0.88,
                color: Color.lerp(AppColors.primary, AppColors.secondary, 0.22)!
                    .withValues(alpha: 0.28),
              ),
            ),
            Positioned(
              bottom: -h * 0.1,
              left: -w * 0.2,
              child: BrandAuroraBlob(
                width: w * 0.75,
                height: w * 0.7,
                color: Color.lerp(AppColors.primary, Colors.black, 0.25)!.withValues(alpha: 0.2),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BrandFlowingArcsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final arc1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..color = Colors.white.withValues(alpha: 0.055);

    final path1 = Path();
    path1.moveTo(-w * 0.08, h * 0.32);
    path1.quadraticBezierTo(w * 0.42, h * 0.02, w * 1.08, h * 0.38);
    canvas.drawPath(path1, arc1);

    final arc2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = AppColors.secondary.withValues(alpha: 0.09);

    final path2 = Path();
    path2.moveTo(w * 0.72, -h * 0.04);
    path2.quadraticBezierTo(w * 0.18, h * 0.52, -w * 0.06, h * 0.78);
    canvas.drawPath(path2, arc2);

    final arc3 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Color.lerp(AppColors.primary, Colors.white, 0.35)!.withValues(alpha: 0.06);

    final path3 = Path();
    path3.moveTo(w * 0.15, h * 1.02);
    path3.quadraticBezierTo(w * 0.55, h * 0.62, w * 1.02, h * 0.22);
    canvas.drawPath(path3, arc3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BrandGeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 28.0;
    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height * 0.45, size.height),
        linePaint,
      );
    }

    final starPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    for (double y = 90; y < size.height; y += 110) {
      for (double x = 34; x < size.width; x += 78) {
        _drawEightPointStar(canvas, Offset(x, y), 6, starPaint);
      }
    }
  }

  void _drawEightPointStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (math.pi / 4) * i;
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
      final crossPoint = Offset(
        center.dx + math.cos(angle + math.pi / 8) * (radius * 0.45),
        center.dy + math.sin(angle + math.pi / 8) * (radius * 0.45),
      );
      path.lineTo(crossPoint.dx, crossPoint.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BrandAuroraBlob extends StatelessWidget {
  const BrandAuroraBlob({
    super.key,
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
          stops: const [0, 1],
        ),
      ),
    );
  }
}

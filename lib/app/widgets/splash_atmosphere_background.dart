import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Splash-only background: deep forest-green radial gradient with faint gold
/// particles. Logo focal rings live in [SplashLogoBackdrop] on the splash screen.
class SplashAtmosphereBackground extends StatelessWidget {
  const SplashAtmosphereBackground({super.key});

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
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.12),
                  radius: 1.2,
                  colors: [
                    AppColors.forestMid,
                    AppColors.forestGreen,
                    const Color(0xFF0D1F16),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _SplashParticlePainter(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SplashParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);
    final dotPaint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 48; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final alpha = 0.08 + random.nextDouble() * 0.14;
      dotPaint.color = AppColors.warmGold.withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), 0.8 + random.nextDouble() * 1.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Gold concentric rings and geometric star centered on the logo.
class SplashLogoBackdrop extends StatelessWidget {
  const SplashLogoBackdrop({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SplashLogoBackdropPainter(),
    );
  }
}

class _SplashLogoBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final base = size.width * 0.5;

    void ring(double factor, double alpha, double strokeWidth) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = AppColors.warmGold.withValues(alpha: alpha);
      canvas.drawCircle(center, base * factor, paint);
    }

    ring(0.72, 0.14, 0.8);
    ring(0.88, 0.10, 0.7);
    ring(1.02, 0.08, 0.6);
    ring(1.16, 0.06, 0.5);

    final starPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..color = AppColors.warmGold.withValues(alpha: 0.10);

    _drawEightPointStar(canvas, center, base * 0.92, starPaint);

    final linePaint = Paint()
      ..color = AppColors.warmGold.withValues(alpha: 0.12)
      ..strokeWidth = 0.6;
    // Logo is ~43.6% of backdrop width; align line with its bottom tip.
    final logoHalfExtent = size.width * 0.218;
    canvas.drawLine(
      Offset(0, center.dy + logoHalfExtent),
      Offset(size.width, center.dy + logoHalfExtent),
      linePaint,
    );
  }

  void _drawEightPointStar(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (math.pi / 4) * i - math.pi / 2;
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
      final crossAngle = angle + math.pi / 8;
      final crossPoint = Offset(
        center.dx + math.cos(crossAngle) * (radius * 0.38),
        center.dy + math.sin(crossAngle) * (radius * 0.38),
      );
      path.lineTo(crossPoint.dx, crossPoint.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/startup_constants.dart';
import '../../../../core/l10n/l10n.dart';

class StartupSplashScreen extends StatefulWidget {
  const StartupSplashScreen({super.key});

  @override
  State<StartupSplashScreen> createState() => _StartupSplashScreenState();
}

class _StartupSplashScreenState extends State<StartupSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _scale = Tween<double>(
      begin: 0.94,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _routeFromSplash());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _routeFromSplash() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool(kWelcomeIntroCompletedKey) ?? false;
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    context.go(hasSeen ? '/' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screen = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.65, -0.75),
            radius: 1.5,
            colors: [
              Color.lerp(AppColors.primary, Colors.white, 0.12)!,
              Color.lerp(AppColors.primary, Colors.teal, 0.42)!,
              Color.lerp(AppColors.primary, Colors.black, 0.38)!,
            ],
            stops: const [0.0, 0.62, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _GeometricPatternPainter(),
                ),
              ),
              Positioned(
                top: -screen.height * 0.12,
                left: -screen.width * 0.22,
                child: _AuroraBlob(
                  width: screen.width * 0.9,
                  height: screen.width * 0.9,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              Positioned(
                top: screen.height * 0.2,
                right: -screen.width * 0.24,
                child: _AuroraBlob(
                  width: screen.width * 0.74,
                  height: screen.width * 0.84,
                  color: Color.lerp(AppColors.primary, Colors.teal, 0.4)!
                      .withValues(alpha: 0.35),
                ),
              ),
              Positioned(
                bottom: -screen.height * 0.08,
                left: -screen.width * 0.18,
                child: _AuroraBlob(
                  width: screen.width * 0.72,
                  height: screen.width * 0.68,
                  color: Color.lerp(AppColors.primary, Colors.black, 0.15)!
                      .withValues(alpha: 0.22),
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
                        Colors.black.withValues(alpha: 0.12),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: ScaleTransition(
                      scale: _scale,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          children: [
                            const Spacer(flex: 2),
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.98),
                                    Colors.white.withValues(alpha: 0.88),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.55),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.22),
                                    blurRadius: 36,
                                    offset: const Offset(0, 16),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/Ethiopian_Islamic_Affairs_Supreme_Council.png',
                                width: screen.width * 0.62,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const Spacer(flex: 2),
                            Text(
                              l10n.appTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.textOnPrimary,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.35,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(alpha: 0.22),
                                        blurRadius: 14,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Powered by',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.93),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.4,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/Coopbank-Alhuda-Logo.png',
                                width: screen.width * 0.52,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuroraBlob extends StatelessWidget {
  const _AuroraBlob({
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

class _GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
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
      ..color = Colors.white.withValues(alpha: 0.14)
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

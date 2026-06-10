import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/widgets/app_logo.dart';
import '../../../../app/widgets/brand_atmosphere_background.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/auth/auth_session_controller.dart';
import '../../../../core/constants/startup_constants.dart';
import '../../../../core/di/injection.dart';
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
    final appMode = prefs.getString('app_mode');
    final authSession = getIt<AuthSessionController>();
    if (!authSession.initialized) {
      await authSession.initialize();
    }
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    if (!hasSeen) {
      context.go('/onboarding');
      return;
    }
    context.go(appMode == 'awqaf' ? '/awqaf' : '/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screen = MediaQuery.sizeOf(context);
    final w = screen.width;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(
            child: BrandAtmosphereBackground(),
          ),
          SafeArea(
            child: Stack(
              children: [
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
                              SizedBox(
                                height: w * 0.52,
                                child: Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    CustomPaint(
                                      size: Size(w * 0.72, w * 0.5),
                                      painter: _LogoOrbitRingsPainter(),
                                    ),
                                    AppLogo(
                                      height: w * 0.34,
                                      width: w * 0.58,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
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
                              const SizedBox(height: 12),
                              Text(
                                l10n.splashSlogan,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.94),
                                      fontWeight: FontWeight.w600,
                                      height: 1.35,
                                      letterSpacing: 0.2,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
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
      ],
    ),
  );
  }
}

/// Thin decorative rings behind the logo focal point.
class _LogoOrbitRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final base = math.min(size.width, size.height) * 0.52;

    void ring(double factor, Color color, double alpha) {
      final p = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.05
        ..color = color.withValues(alpha: alpha);
      canvas.drawCircle(c, base * factor, p);
    }

    ring(0.32, Colors.white, 0.11);
    ring(0.44, AppColors.secondary, 0.15);
    ring(0.56, Colors.white, 0.065);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

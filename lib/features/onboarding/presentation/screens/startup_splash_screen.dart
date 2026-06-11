import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/widgets/app_logo.dart';
import '../../../../app/widgets/splash_atmosphere_background.dart';
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
  late final Animation<double> _contentFade;
  late final Animation<double> _contentScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _contentScale = Tween<double>(
      begin: 0.96,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
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

  (String, String) _splitTitle(String title) {
    const suffix = ' Commission';
    if (title.endsWith(suffix)) {
      return (title.substring(0, title.length - suffix.length), 'Commission');
    }
    final words = title.split(' ');
    if (words.length < 2) {
      return (title, '');
    }
    return (words.sublist(0, words.length - 1).join(' '), words.last);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screen = MediaQuery.sizeOf(context);
    final w = screen.width;
    final backdropSize = w * 0.78;
    final logoSize = w * 0.34;
    final (titleLine1, titleLine2) = _splitTitle(l10n.appTitle);
    const titleColor = Color(0xFFD8F0E4);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(
            child: SplashAtmosphereBackground(),
          ),
          SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, -0.06),
                  child: FadeTransition(
                    opacity: _contentFade,
                    child: ScaleTransition(
                      scale: _contentScale,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: backdropSize,
                              height: backdropSize,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  SplashLogoBackdrop(size: backdropSize),
                                  AppLogo(
                                    height: logoSize,
                                    width: logoSize,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _SplashTitleDivider(width: w * 0.42),
                            const SizedBox(height: 22),
                            Text(
                              titleLine1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: w < 360 ? 28 : 32,
                                fontWeight: FontWeight.w700,
                                color: titleColor,
                                height: 1.15,
                                letterSpacing: 0.2,
                              ),
                            ),
                            if (titleLine2.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                titleLine2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Playfair Display',
                                  fontSize: w < 360 ? 28 : 32,
                                  fontWeight: FontWeight.w700,
                                  color: titleColor,
                                  height: 1.15,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Text(
                              l10n.splashSlogan,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: w < 360 ? 13 : 14,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                color: AppColors.mintGreen.withValues(alpha: 0.85),
                                height: 1.45,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: screen.height * 0.06),
                    child: FadeTransition(
                      opacity: _contentFade,
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.warmGold,
                          borderRadius: BorderRadius.circular(2),
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

class _SplashTitleDivider extends StatelessWidget {
  const _SplashTitleDivider({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 8,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 0.6,
              color: AppColors.warmGold.withValues(alpha: 0.35),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.warmGold.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 0.6,
              color: AppColors.warmGold.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }
}

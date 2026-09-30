import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/widgets/app_logo.dart';
import '../../../../app/widgets/coop_waqf_splash_badge.dart';
import '../../../../app/widgets/islamic_ornaments.dart';
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
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _shimmer;
  late final Animation<double> _contentFade;
  late final Animation<double> _contentScale;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    // Staggered entrance: medallion, then title, then footer.
    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.55, curve: Curves.easeOutCubic),
    );
    _contentScale = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _titleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.85, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.85, curve: Curves.easeOutCubic),
          ),
        );
    _footerFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1, curve: Curves.easeOut),
    );
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _routeFromSplash());
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmer.dispose();
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
          const Positioned.fill(child: SplashAtmosphereBackground()),
          const IslamicPatternLayer(opacity: 0.09, fadeTo: Alignment.center),
          const Positioned(
            top: -20,
            right: -70,
            child: CrescentOrnament(size: 200, opacity: 0.12),
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
                            Text(
                              '\u0628\u0650\u0633\u0652\u0645\u0650 \u0671\u0644\u0644\u0651\u064e\u0670\u0647\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0652\u0645\u064e\u0670\u0646\u0650 \u0671\u0644\u0631\u0651\u064e\u062d\u0650\u064a\u0645\u0650',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: w < 360 ? 17 : 19,
                                color: AppColors.goldLight.withValues(
                                  alpha: 0.9,
                                ),
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: backdropSize,
                              height: backdropSize,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  SplashLogoBackdrop(size: backdropSize),
                                  Container(
                                    width: logoSize * 1.3,
                                    height: logoSize * 1.3,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.goldLight.withValues(
                                          alpha: 0.35,
                                        ),
                                      ),
                                    ),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const RadialGradient(
                                          colors: [
                                            Colors.white,
                                            AppColors.parchment,
                                          ],
                                        ),
                                        border: Border.all(
                                          color: AppColors.warmGold,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.warmGold
                                                .withValues(alpha: 0.30),
                                            blurRadius: 36,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: AppLogo(
                                          height: logoSize * 0.82,
                                          width: logoSize * 0.82,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            _SplashTitleDivider(width: w * 0.42),
                            const SizedBox(height: 22),
                            FadeTransition(
                              opacity: _titleFade,
                              child: SlideTransition(
                                position: _titleSlide,
                                child: Column(
                                  children: [
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
                                        color: AppColors.mintGreen.withValues(
                                          alpha: 0.85,
                                        ),
                                        height: 1.45,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                    const SizedBox(height: 28),
                                    FadeTransition(
                                      opacity: _footerFade,
                                      child: _GoldLoadingBar(animation: _shimmer),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 48),
                    child: FadeTransition(
                      opacity: _footerFade,
                      child: const CoopWaqfSplashBadge(),
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

/// Thin gold track with a light sweep travelling across it.
class _GoldLoadingBar extends StatelessWidget {
  const _GoldLoadingBar({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const width = 96.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        width: width,
        height: 3,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            final t = animation.value;
            return DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1 + 3 * t - 1, 0),
                  end: Alignment(-1 + 3 * t, 0),
                  colors: [
                    AppColors.warmGold.withValues(alpha: 0.25),
                    AppColors.goldLight,
                    AppColors.warmGold.withValues(alpha: 0.25),
                  ],
                  tileMode: TileMode.clamp,
                ),
              ),
            );
          },
        ),
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

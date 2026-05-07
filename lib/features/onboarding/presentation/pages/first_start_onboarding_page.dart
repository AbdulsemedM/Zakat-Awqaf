import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/startup_constants.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class FirstStartOnboardingPage extends StatefulWidget {
  const FirstStartOnboardingPage({super.key});

  @override
  State<FirstStartOnboardingPage> createState() => _FirstStartOnboardingPageState();
}

class _FirstStartOnboardingPageState extends State<FirstStartOnboardingPage> {
  final _pageController = PageController();
  int _index = 0;
  bool _isFinishing = false;

  final List<_OnboardingSlideData> _slides = const [
    _OnboardingSlideData(
      lottieAsset: 'assets/animations/Young Muslims give alms in the charity box.json',
      icon: Icons.volunteer_activism_rounded,
    ),
    _OnboardingSlideData(
      lottieAsset: 'assets/animations/Finance.json',
      icon: Icons.calculate_rounded,
    ),
    _OnboardingSlideData(
      lottieAsset: 'assets/animations/Mobile payment lottie animation.json',
      icon: Icons.payments_rounded,
    ),
    _OnboardingSlideData(
      lottieAsset: 'assets/animations/Faisal Mosque.json',
      icon: Icons.mosque_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    if (_isFinishing) return;
    setState(() => _isFinishing = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kWelcomeIntroCompletedKey, true);
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go('/');
    });
  }

  Future<void> _exitWithoutCompleting() async {
    if (_isFinishing) return;
    setState(() => _isFinishing = true);
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLast = _index == _slides.length - 1;
    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_index > 0) {
          await _pageController.previousPage(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
          );
          return;
        }
        await _exitWithoutCompleting();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.24),
                        ),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_slides[_index].icon, size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            l10n.appTitle,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (!isLast)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: _finishOnboarding,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text(
                              l10n.onboardingSkip,
                              style: const TextStyle(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (value) => setState(() => _index = value),
                    itemBuilder: (context, i) {
                      final slide = _slides[i];
                      return Column(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -20,
                                  left: -10,
                                  child: _DecorCircle(
                                    size: 140,
                                    color: AppColors.primary.withValues(alpha: 0.10),
                                  ),
                                ),
                                Positioned(
                                  right: -18,
                                  bottom: 10,
                                  child: _DecorCircle(
                                    size: 104,
                                    color: AppColors.secondary.withValues(alpha: 0.12),
                                  ),
                                ),
                                Positioned(
                                  top: 60 + (i * 10),
                                  right: i.isEven ? 26 : 42,
                                  child: _DecorCapsule(
                                    color: AppColors.primary.withValues(alpha: 0.14),
                                  ),
                                ),
                                Positioned(
                                  left: i.isEven ? 26 : 12,
                                  bottom: 36 + (i * 6),
                                  child: _DecorDot(
                                    color: AppColors.secondary.withValues(alpha: 0.22),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Lottie.asset(
                                    slide.lottieAsset,
                                    fit: BoxFit.contain,
                                    repeat: true,
                                    animate: _index == i,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _titleForIndex(l10n, i),
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _subtitleForIndex(l10n, i),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (dot) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _index == dot ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _index == dot
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    minimumSize: const Size.fromHeight(52),
                  ),
                  onPressed: _isFinishing
                      ? null
                      : () async {
                          if (isLast) {
                            await _finishOnboarding();
                          } else {
                            await _pageController.nextPage(
                              duration: const Duration(milliseconds: 320),
                              curve: Curves.easeOutCubic,
                            );
                          }
                        },
                  child: Text(
                    isLast ? l10n.onboardingGetStarted : l10n.onboardingNext,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _titleForIndex(AppLocalizations l10n, int index) => switch (index) {
        0 => l10n.onboardingTitleFaithAndPurpose,
        1 => l10n.onboardingTitleTransparentGiving,
        2 => l10n.onboardingTitleEasyPayments,
        _ => l10n.onboardingTitleCompassionInAction,
      };

  String _subtitleForIndex(AppLocalizations l10n, int index) => switch (index) {
        0 => l10n.onboardingSubtitleFaithAndPurpose,
        1 => l10n.onboardingSubtitleTransparentGiving,
        2 => l10n.onboardingSubtitleEasyPayments,
        _ => l10n.onboardingSubtitleCompassionInAction,
      };
}

class _OnboardingSlideData {
  const _OnboardingSlideData({
    required this.lottieAsset,
    required this.icon,
  });

  final String lottieAsset;
  final IconData icon;
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _DecorCapsule extends StatelessWidget {
  const _DecorCapsule({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Transform.rotate(
        angle: -0.28,
        child: Container(
          width: 56,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}

class _DecorDot extends StatelessWidget {
  const _DecorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

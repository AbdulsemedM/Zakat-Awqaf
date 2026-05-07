import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/awqaf/presentation/screens/awqaf_screen.dart';
import '../../features/beneficiary_registration/bloc/beneficiary_registration_bloc.dart';
import '../../features/beneficiary_registration/presentation/screens/beneficiary_registration_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/impact/bloc/impact_bloc.dart';
import '../../features/impact/bloc/impact_event.dart';
import '../../features/impact/presentation/screens/impact_screen.dart';
import '../../features/onboarding/presentation/screens/first_start_onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/startup_splash_screen.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/bloc/profile_event.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/zakat_calculator/presentation/screens/zakat_calculator_screen.dart';
import '../../core/di/injection.dart';
import '../../core/l10n/l10n.dart';
import '../../features/zakat_payment/presentation/models/zakat_certificate_args.dart';
import '../../features/zakat_payment/presentation/models/zakat_payment_args.dart';
import '../../features/zakat_payment/presentation/screens/zakat_certificate_screen.dart';
import '../../features/zakat_payment/presentation/screens/zakat_payment_screen.dart';
import '../pages/main_nav_shell_page.dart';

@module
abstract class AppRouterModule {
  @lazySingleton
  GoRouter router() => GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(
            path: '/splash',
            builder: (context, state) => const StartupSplashScreen(),
          ),
          GoRoute(
            path: '/onboarding',
            builder: (context, state) => const FirstStartOnboardingScreen(),
          ),
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) => MainNavShellPage(
              navigationShell: navigationShell,
            ),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/',
                    builder: (context, state) => const HomeScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/calculator',
                    builder: (context, state) => const ZakatCalculatorScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/impact',
                    builder: (context, state) => BlocProvider(
                      create: (_) =>
                          getIt<ImpactBloc>()..add(const ImpactStarted()),
                      child: const ImpactScreen(),
                    ),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/profile',
                    builder: (context, state) => BlocProvider(
                      create: (_) =>
                          getIt<ProfileBloc>()..add(const ProfileStarted()),
                      child: const ProfileScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(path: '/zakat/summary', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/beneficiary-registration',
            builder: (context, state) => BlocProvider(
              create: (_) => BeneficiaryRegistrationBloc(),
              child: const BeneficiaryRegistrationScreen(),
            ),
          ),
          GoRoute(
            path: '/awqaf',
            builder: (context, state) => const AwqafScreen(),
          ),
          GoRoute(
            path: '/zakat/payment',
            builder: (context, state) {
              final extra = state.extra;
              if (extra is! ZakatPaymentArgs) {
                return Scaffold(
                  body: Center(child: Text(context.l10n.missingPaymentDetails)),
                );
              }
              return ZakatPaymentScreen(args: extra);
            },
          ),
          GoRoute(
            path: '/zakat/certificate',
            builder: (context, state) {
              final extra = state.extra;
              if (extra is! ZakatCertificateArgs) {
                return Scaffold(
                  body: Center(
                    child: Text(context.l10n.missingCertificateDetails),
                  ),
                );
              }
              return ZakatCertificateScreen(args: extra);
            },
          ),
        ],
      );
}

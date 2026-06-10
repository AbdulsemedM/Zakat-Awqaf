import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../core/auth/auth_session_controller.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/beneficiary_registration/bloc/beneficiary_registration_bloc.dart';
import '../../features/beneficiary_registration/bloc/beneficiary_registration_event.dart';
import '../../features/awqaf/create/presentation/screens/awqaf_create_screen.dart';
import '../../features/awqaf/home/presentation/screens/awqaf_home_screen.dart';
import '../../features/awqaf/portfolio/presentation/screens/awqaf_portfolio_screen.dart';
import '../../features/awqaf/profile/presentation/screens/awqaf_profile_screen.dart';
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
  static const _publicRoutes = <String>{'/splash', '/onboarding', '/login'};

  @lazySingleton
  GoRouter router(AuthSessionController authSession) => GoRouter(
    initialLocation: '/splash',
    refreshListenable: authSession,
    redirect: (context, state) {
      final location = state.matchedLocation;
      if (_publicRoutes.contains(location)) {
        if (location == '/login' && authSession.isAuthenticated) {
          return '/';
        }
        return null;
      }
      if (!authSession.isAuthenticated) {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const StartupSplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const FirstStartOnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AuthBloc>(),
          child: const LoginScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainNavShellPage(navigationShell: navigationShell),
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/awqaf',
                builder: (context, state) => const AwqafHomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/awqaf/create',
                builder: (context, state) => const AwqafCreateScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/awqaf/portfolio',
                builder: (context, state) => const AwqafPortfolioScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/awqaf/profile',
                builder: (context, state) => const AwqafProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/zakat/summary',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/beneficiary-registration',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<BeneficiaryRegistrationBloc>()
            ..add(const BeneficiaryRegistrationStarted()),
          child: const BeneficiaryRegistrationScreen(),
        ),
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
              body: Center(child: Text(context.l10n.missingCertificateDetails)),
            );
          }
          return ZakatCertificateScreen(args: extra);
        },
      ),
    ],
  );
}

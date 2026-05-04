import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/awqaf/presentation/screens/awqaf_screen.dart';
import '../../features/beneficiary_registration/bloc/beneficiary_registration_bloc.dart';
import '../../features/beneficiary_registration/presentation/screens/beneficiary_registration_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/impact/presentation/screens/impact_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/zakat_calculator/presentation/screens/zakat_calculator_screen.dart';
import '../pages/main_nav_shell_page.dart';

@module
abstract class AppRouterModule {
  @lazySingleton
  GoRouter router() => GoRouter(
        initialLocation: '/',
        routes: [
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
                    builder: (context, state) => const ImpactScreen(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/profile',
                    builder: (context, state) => const ProfileScreen(),
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
        ],
      );
}

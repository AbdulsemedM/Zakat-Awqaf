import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/awqaf/presentation/pages/awqaf_page.dart';
import '../../features/zakat/presentation/pages/zakat_page.dart';
import '../pages/home_page.dart';

@module
abstract class AppRouterModule {
  @lazySingleton
  GoRouter router() => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/zakat',
            builder: (context, state) => const ZakatPage(),
          ),
          GoRoute(
            path: '/awqaf',
            builder: (context, state) => const AwqafPage(),
          ),
        ],
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/auth/auth_session_controller.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_event.dart';
import 'profile_screen.dart';

class ProfileAuthGateScreen extends StatelessWidget {
  const ProfileAuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authSession = getIt<AuthSessionController>();

    return ListenableBuilder(
      listenable: authSession,
      builder: (context, _) {
        if (!authSession.isAuthenticated) {
          return BlocProvider(
            create: (_) => getIt<AuthBloc>(),
            child: const LoginScreen(embeddedInProfile: true),
          );
        }
        return BlocProvider(
          create: (_) => getIt<ProfileBloc>()..add(const ProfileStarted()),
          child: const ProfileScreen(),
        );
      },
    );
  }
}

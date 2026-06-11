import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/settings/app_settings_controller.dart';
import 'core/auth/auth_session_controller.dart';
import 'core/config/app_env.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.load();
  configureDependencies();
  await getIt<AuthSessionController>().initialize();
  final appSettingsController = await AppSettingsController.create();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppSettingsController>.value(
          value: appSettingsController,
        ),
      ],
      child: const MejlisApp(),
    ),
  );
}

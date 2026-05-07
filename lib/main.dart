import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/settings/app_settings_controller.dart';
import 'core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  configureDependencies();
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

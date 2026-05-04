import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
import 'features/awqaf/bloc/awqaf_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  configureDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AwqafBloc>(
          create: (_) => getIt<AwqafBloc>(),
        ),
      ],
      child: const MejlisApp(),
    ),
  );
}

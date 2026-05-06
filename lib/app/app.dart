import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mejlis_digital_hub/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';
import '../core/di/injection.dart';
import 'l10n/app_content_locale.dart';
import 'settings/app_settings_controller.dart';
import 'theme/app_theme.dart';

/// Locale for Material/Cupertino widgets. App strings use [AppSettingsController.locale]
/// via [AppContentLocale] when this differs from the user's choice.
Locale frameworkUiLocale(Locale preferred) {
  if (GlobalMaterialLocalizations.delegate.isSupported(preferred) &&
      GlobalCupertinoLocalizations.delegate.isSupported(preferred)) {
    return preferred;
  }
  return const Locale('en');
}

class MejlisApp extends StatelessWidget {
  const MejlisApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<GoRouter>();
    final appSettings = context.read<AppSettingsController>();
    return AnimatedBuilder(
      animation: appSettings,
      builder: (context, _) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appTitle,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: appSettings.themeMode,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: frameworkUiLocale(appSettings.locale),
        builder: (context, child) {
          return AppContentLocale(
            locale: appSettings.locale,
            child: child ?? const SizedBox.shrink(),
          );
        },
        routerConfig: router,
      ),
    );
  }
}

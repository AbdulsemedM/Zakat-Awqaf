import 'package:flutter/widgets.dart';

/// The locale used for app copy ([AppLocalizations] via [lookupAppLocalizations]).
///
/// May differ from [MaterialApp.locale] when the user picks a language that
/// Flutter's Material/Cupertino delegates do not ship for (e.g. `om`, `so`).
class AppContentLocale extends InheritedWidget {
  const AppContentLocale({
    super.key,
    required this.locale,
    required super.child,
  });

  final Locale locale;

  static Locale? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppContentLocale>()
        ?.locale;
  }

  @override
  bool updateShouldNotify(AppContentLocale oldWidget) {
    return oldWidget.locale != locale;
  }
}

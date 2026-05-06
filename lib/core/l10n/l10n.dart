import 'package:flutter/widgets.dart';
import 'package:mejlis_digital_hub/app/l10n/app_content_locale.dart';
import 'package:mejlis_digital_hub/l10n/app_localizations.dart';

extension AppL10nX on BuildContext {
  /// Prefer the user-selected content locale (see [AppContentLocale]) so copy
  /// stays correct when [MaterialApp.locale] falls back for framework delegates.
  Locale get contentLocale =>
      AppContentLocale.maybeOf(this) ?? Localizations.localeOf(this);

  AppLocalizations get l10n {
    final content = AppContentLocale.maybeOf(this);
    if (content != null) {
      return lookupAppLocalizations(content);
    }
    return AppLocalizations.of(this)!;
  }
}

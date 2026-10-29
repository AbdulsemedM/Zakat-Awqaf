import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mejlis_digital_hub/features/donation/presentation/widgets/donation_currency_sheet.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/presentation/models/zakat_payment_args.dart';
import 'package:mejlis_digital_hub/l10n/app_localizations_en.dart';
import 'package:mejlis_digital_hub/l10n/app_localizations.dart';

final _l10n = AppLocalizationsEn();

Future<void> _openSheet(WidgetTester tester) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => showDonationCurrencySheet(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/zakat/payment',
        builder: (_, state) => Scaffold(
          body: Text(
            'zakat payment: ${(state.extra! as ZakatPaymentArgs).title}',
          ),
        ),
      ),
      GoRoute(
        path: '/donation/international',
        builder: (_, _) => const Scaffold(body: Text('international form')),
      ),
    ],
  );
  await tester.pumpWidget(
    MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('offers both local and international Sadaqah', (tester) async {
    await _openSheet(tester);

    expect(find.text(_l10n.donationLocalPaymentTitle), findsOneWidget);
    expect(find.text(_l10n.donationInternationalPaymentTitle), findsOneWidget);
  });

  testWidgets('local opens the QR payment steps for Sadaqah', (tester) async {
    await _openSheet(tester);

    await tester.tap(find.text(_l10n.donationLocalPaymentTitle));
    await tester.pumpAndSettle();

    expect(find.text('zakat payment: ${_l10n.donateSadaqah}'), findsOneWidget);
  });

  testWidgets('international opens the card donation form', (tester) async {
    await _openSheet(tester);

    await tester.tap(find.text(_l10n.donationInternationalPaymentTitle));
    await tester.pumpAndSettle();

    expect(find.text('international form'), findsOneWidget);
  });
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/core/auth/auth_session_controller.dart';
import 'package:mejlis_digital_hub/core/auth/auth_token_storage.dart';
import 'package:mejlis_digital_hub/core/auth/payer_access.dart';
import 'package:mejlis_digital_hub/core/auth/token_refresher.dart';
import 'package:mejlis_digital_hub/core/di/injection.dart';
import 'package:mejlis_digital_hub/core/network/api_envelope.dart';
import 'package:mejlis_digital_hub/features/causes/data/models/cause.dart';
import 'package:mejlis_digital_hub/features/causes/data/repository/causes_repository.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/models/zakat_payment_models.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/data/repository/zakat_payment_repository.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/presentation/models/zakat_payment_args.dart';
import 'package:mejlis_digital_hub/features/zakat_payment/presentation/screens/zakat_payment_screen.dart';
import 'package:mejlis_digital_hub/l10n/app_localizations.dart';
import 'package:mejlis_digital_hub/l10n/app_localizations_en.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _ethqr = PaymentMethod(
  code: 'ethqr',
  label: 'QR payment',
  subtitle: 'Scan with any Ethiopian bank app',
  available: true,
  minAmountEtb: 10,
  maxAmountEtb: 1000000,
  flow: 'qr',
);

class _FakePayments implements ZakatPaymentRepository {
  _FakePayments(this.methods);

  final List<PaymentMethod> methods;
  final requests = <ZakatPaymentRequest>[];
  final errors = <ApiException>[];

  @override
  Future<List<PaymentMethod>> fetchMethods() async => methods;

  @override
  Future<ZakatPayment> startPayment(ZakatPaymentRequest request) async {
    requests.add(request);
    throw errors.removeAt(0);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCauses implements CausesRepository {
  @override
  Future<CausesPage> fetchCauses({
    CauseStatus status = CauseStatus.active,
    bool urgentOnly = false,
    bool acceptsZakatOnly = false,
    CauseCategory? category,
    int page = 1,
    int limit = 20,
    required String lang,
  }) async =>
      const CausesPage(items: [], page: 1, totalPages: 1, totalItems: 0);

  @override
  Future<CauseDetail> fetchCause(String id, {required String lang}) =>
      throw UnimplementedError();
}

Future<_FakePayments> _pumpForm(
  WidgetTester tester, {
  List<PaymentMethod> methods = const [_ethqr],
  ZakatPaymentArgs? args,
}) async {
  final payments = _FakePayments(methods);
  await getIt.reset();
  final storage = AuthTokenStorage();
  getIt
    ..registerSingleton<ZakatPaymentRepository>(payments)
    ..registerSingleton<CausesRepository>(_FakeCauses())
    ..registerSingleton<PayerAccess>(
      PayerAccess(
        AuthSessionController(storage, TokenRefresher(Dio(), storage)),
        storage,
      ),
    );
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ZakatPaymentScreen(
        args:
            args ??
            ZakatPaymentArgs.forCause(
              const Cause(
                id: 'general',
                title: 'General Zakat fund',
                category: CauseCategory.general,
                acceptsZakat: true,
              ),
            ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return payments;
}

Finder _field(String label) =>
    find.widgetWithText(TextField, label, skipOffstage: false);

/// Whether the "Pay by QR" button can be pressed.
bool _payEnabled(WidgetTester tester) {
  final button = find.ancestor(
    of: find.text('Pay by QR'),
    matching: find.byWidgetPredicate(
      (w) => w is ButtonStyleButton || w is InkWell,
    ),
  );
  return switch (tester.widget(button.first)) {
    ButtonStyleButton(:final onPressed) => onPressed != null,
    InkWell(:final onTap) => onTap != null,
    _ => false,
  };
}

Future<void> _fillGuest(WidgetTester tester, {String name = 'Amina'}) async {
  await tester.enterText(find.byType(TextField).first, '2500');
  await tester.enterText(_field('Full name'), name);
  await tester.pump();
}

Future<void> _pay(WidgetTester tester) async {
  await tester.tap(find.text('Pay by QR'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
  });
  tearDown(() => getIt.reset());

  testWidgets('a guest needs an amount and a name; no account is asked', (
    tester,
  ) async {
    await _pumpForm(tester);
    expect(find.text('Pay by QR'), findsOneWidget);
    expect(find.textContaining('account number'), findsNothing);
    expect(_payEnabled(tester), isFalse);

    await tester.enterText(find.byType(TextField).first, '2500');
    await tester.pump();
    expect(_payEnabled(tester), isFalse, reason: 'no name yet');
    await tester.enterText(_field('Full name'), 'Amina Hassen');
    await tester.pump();
    expect(_payEnabled(tester), isTrue);
  });

  testWidgets('the request has the payer and the QR method', (tester) async {
    final payments = await _pumpForm(tester);
    payments.errors.add(const ApiException('timeout', noResponse: true));
    await _fillGuest(tester, name: 'Amina Hassen');
    await tester.enterText(_field('Phone number (optional)'), '0911223344');
    await tester.pump();
    await _pay(tester);

    final request = payments.requests.single;
    expect(request.methodCode, 'ethqr');
    expect(request.causeId, 'general');
    expect(request.zakatType, ZakatType.general);
    expect(request.amountEtb, 2500);
    expect(request.payer?.fullName, 'Amina Hassen');
    expect(request.payer?.phone, '+251911223344');
    expect(request.payer?.anonymous, isFalse);
  });

  testWidgets('there is no project choice; zakat goes to the general fund', (
    tester,
  ) async {
    final payments = await _pumpForm(tester);
    expect(find.byType(DropdownButtonFormField<String>), findsNothing);
    expect(find.text('General Zakat fund'), findsNothing);

    payments.errors.add(const ApiException('timeout', noResponse: true));
    await _fillGuest(tester);
    await _pay(tester);
    expect(payments.requests.single.causeId, 'general');
  });

  testWidgets('started from a cause: pays that cause, shown as fixed', (
    tester,
  ) async {
    final payments = await _pumpForm(
      tester,
      args: ZakatPaymentArgs.forCause(
        const Cause(
          id: 'c-42',
          title: 'Clean water for Afar',
          category: CauseCategory.general,
          acceptsZakat: true,
        ),
      ),
    );
    expect(find.byType(DropdownButtonFormField<String>), findsNothing);
    expect(
      find.text('Clean water for Afar', skipOffstage: false),
      findsOneWidget,
    );

    payments.errors.add(const ApiException('timeout', noResponse: true));
    await _fillGuest(tester);
    await _pay(tester);
    expect(payments.requests.single.causeId, 'c-42');
  });

  testWidgets('local Sadaqah uses the QR steps as general zakat', (
    tester,
  ) async {
    final l10n = AppLocalizationsEn();
    final payments = await _pumpForm(
      tester,
      args: ZakatPaymentArgs.forSadaqah(l10n),
    );
    expect(find.text(l10n.donateSadaqah), findsOneWidget);

    payments.errors.add(const ApiException('timeout', noResponse: true));
    await _fillGuest(tester);
    await _pay(tester);
    final request = payments.requests.single;
    expect(request.zakatType, ZakatType.general);
    expect(request.causeId, 'general');
    expect(request.methodCode, 'ethqr');
  });

  testWidgets('a bad phone number is shown under its field', (tester) async {
    final payments = await _pumpForm(tester);
    await _fillGuest(tester);
    await tester.enterText(_field('Phone number (optional)'), '123');
    await tester.pump();
    await _pay(tester);
    expect(
      find.text('Enter a valid phone number, e.g. 0911223344.'),
      findsOneWidget,
    );
    expect(payments.requests, isEmpty);
  });

  testWidgets('an amount out of range shows under the amount', (tester) async {
    final payments = await _pumpForm(tester);
    payments.errors.add(
      const ApiException(
        'Enter an amount between 10 and 1,000,000 ETB',
        statusCode: 400,
        code: 'AMOUNT_OUT_OF_RANGE',
      ),
    );
    await _fillGuest(tester);
    await _pay(tester);
    expect(
      find.text('Enter an amount between 10 and 1,000,000 ETB'),
      findsOneWidget,
    );
  });

  testWidgets('no response keeps the idempotency key for the retry', (
    tester,
  ) async {
    final payments = await _pumpForm(tester);
    payments.errors.addAll([
      const ApiException('timeout', noResponse: true),
      const ApiException('again', noResponse: true),
    ]);
    await _fillGuest(tester);
    await _pay(tester);
    await _pay(tester);

    expect(payments.requests, hasLength(2));
    expect(
      payments.requests[0].idempotencyKey,
      payments.requests[1].idempotencyKey,
    );
  });

  testWidgets('changing the name makes a new attempt (new key)', (
    tester,
  ) async {
    final payments = await _pumpForm(tester);
    payments.errors.addAll([
      const ApiException('timeout', noResponse: true),
      const ApiException('timeout', noResponse: true),
    ]);
    await _fillGuest(tester, name: 'Amina');
    await _pay(tester);
    await tester.enterText(_field('Full name'), 'Amina Hassen');
    await tester.pump();
    await _pay(tester);

    expect(payments.requests, hasLength(2));
    expect(
      payments.requests[0].idempotencyKey,
      isNot(payments.requests[1].idempotencyKey),
    );
  });

  testWidgets('an unavailable method shows its reason and blocks paying', (
    tester,
  ) async {
    await _pumpForm(
      tester,
      methods: const [
        PaymentMethod(
          code: 'ethqr',
          label: 'QR payment',
          available: false,
          unavailableReason: 'QR payments are not set up yet',
          flow: 'qr',
        ),
      ],
    );
    expect(find.text('QR payments are not set up yet'), findsOneWidget);
    await _fillGuest(tester);
    expect(_payEnabled(tester), isFalse);
  });
}

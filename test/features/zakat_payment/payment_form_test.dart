import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

const _coopbank = PaymentMethod(
  code: 'coopbank',
  label: 'Coop Bank',
  available: true,
  minAmountEtb: 10,
  maxAmountEtb: 1000000,
  flow: 'account_otp',
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
  List<PaymentMethod> methods = const [_coopbank],
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
        args: ZakatPaymentArgs.forCause(
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

/// Whether the "Continue" button can be pressed.
bool _continueEnabled(WidgetTester tester) {
  final button = find.ancestor(
    of: find.text('Continue'),
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

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => getIt.reset());

  testWidgets('Continue needs an amount and a valid account number', (
    tester,
  ) async {
    await _pumpForm(tester);
    expect(find.text('Continue'), findsOneWidget);

    Future<void> enter(String label, String text) async {
      await tester.enterText(_field(label), text);
      await tester.pump();
    }

    expect(_continueEnabled(tester), isFalse);
    await enter('Coop Bank account number', '12345');
    expect(_continueEnabled(tester), isFalse);
    await enter('Coop Bank account number', '1000123456789');
    expect(_continueEnabled(tester), isFalse, reason: 'no amount yet');
    await tester.enterText(find.byType(TextField).first, '500');
    await tester.pump();
    expect(_continueEnabled(tester), isTrue);
  });

  testWidgets('bank rejection shows under the account field', (tester) async {
    final payments = await _pumpForm(tester);
    payments.errors.add(
      const ApiException(
        'Account does not exist',
        statusCode: 400,
        code: 'ACCOUNT_NOT_FOUND',
      ),
    );
    await tester.enterText(find.byType(TextField).first, '500');
    await tester.enterText(_field('Coop Bank account number'), '1000123450000');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Account does not exist'), findsOneWidget);
    final request = payments.requests.single;
    expect(request.causeId, 'general');
    expect(request.zakatType, ZakatType.general);
    expect(request.amountEtb, 500);
  });

  testWidgets('no response keeps the idempotency key for the retry', (
    tester,
  ) async {
    final payments = await _pumpForm(tester);
    payments.errors.addAll([
      const ApiException('timeout', noResponse: true),
      const ApiException('again', noResponse: true),
    ]);
    await tester.enterText(find.byType(TextField).first, '500');
    await tester.enterText(_field('Coop Bank account number'), '1000123456789');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(payments.requests, hasLength(2));
    expect(
      payments.requests[0].idempotencyKey,
      payments.requests[1].idempotencyKey,
    );
  });

  testWidgets('an unavailable method shows its reason and blocks Continue', (
    tester,
  ) async {
    await _pumpForm(
      tester,
      methods: const [
        PaymentMethod(
          code: 'coopbank',
          label: 'Coop Bank',
          available: false,
          unavailableReason: 'Not available yet',
          flow: 'account_otp',
        ),
      ],
    );
    expect(find.text('Not available yet'), findsOneWidget);
    expect(_continueEnabled(tester), isFalse);
  });
}

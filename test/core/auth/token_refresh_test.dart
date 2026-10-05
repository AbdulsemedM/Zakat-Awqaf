import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/core/auth/auth_interceptor.dart';
import 'package:mejlis_digital_hub/core/auth/auth_session_controller.dart';
import 'package:mejlis_digital_hub/core/auth/auth_token_storage.dart';
import 'package:mejlis_digital_hub/core/auth/token_refresher.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A JWT whose payload is [claims] (signature not checked by the app).
String _jwt(Map<String, dynamic> claims) {
  String part(Object value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  return '${part({'alg': 'none'})}.${part(claims)}.sig';
}

String _accessToken(String id, {List<String> roles = const ['DONOR']}) => _jwt({
  'jti': id,
  'name': 'Test User',
  'realm_access': {'roles': roles},
});

/// Answers requests by path; counts calls.
class _Server implements HttpClientAdapter {
  final handlers = <String, (int, Object) Function(RequestOptions)>{};
  final calls = <String>[];
  Completer<void>? holdRefresh;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls.add(options.path);
    if (options.path.endsWith('refresh') && holdRefresh != null) {
      await holdRefresh!.future;
    }
    final handler = handlers[options.path];
    final (status, body) = handler == null
        ? (404, {'success': false, 'message': 'not found'})
        : handler(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Map<String, dynamic> _tokens(String id) => {
  'success': true,
  'data': {
    'accessToken': _accessToken(id),
    'refreshToken': 'refresh-$id',
    'expiresIn': 300,
    'tokenType': 'Bearer',
  },
};

Future<AuthTokenStorage> _signedIn({required int expiresInSeconds}) async {
  final storage = AuthTokenStorage();
  await storage.saveSession(
    accessToken: _accessToken('old'),
    refreshToken: 'refresh-old',
    tokenType: 'Bearer',
    expiresInSeconds: expiresInSeconds,
  );
  return storage;
}

Dio _dio(_Server server) =>
    Dio(BaseOptions(baseUrl: 'https://test/'))..httpClientAdapter = server;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('TokenRefresher', () {
    test('a token that is not about to expire is used as is', () async {
      final server = _Server();
      final storage = await _signedIn(expiresInSeconds: 300);
      final refresher = TokenRefresher(_dio(server), storage);

      expect(await refresher.validAccessToken(), _accessToken('old'));
      expect(server.calls, isEmpty);
    });

    test(
      'an expiring token is refreshed; the rotated tokens are stored',
      () async {
        final server = _Server()
          ..handlers['api/auth/v1/refresh'] = (o) {
            expect(o.data, {'refreshToken': 'refresh-old'});
            return (200, _tokens('new'));
          };
        final storage = await _signedIn(expiresInSeconds: 10);
        final refresher = TokenRefresher(_dio(server), storage);

        expect(await refresher.validAccessToken(), _accessToken('new'));
        expect(await storage.readRefreshToken(), 'refresh-new');
      },
    );

    test('simultaneous callers share one refresh', () async {
      final server = _Server()
        ..holdRefresh = Completer<void>()
        ..handlers['api/auth/v1/refresh'] = (_) => (200, _tokens('new'));
      final storage = await _signedIn(expiresInSeconds: 0);
      final refresher = TokenRefresher(_dio(server), storage);

      final results = Future.wait([
        refresher.refresh(),
        refresher.refresh(),
        refresher.refresh(),
      ]);
      await Future<void>.delayed(Duration.zero);
      server.holdRefresh!.complete();
      expect(await results, everyElement(RefreshResult.refreshed));
      expect(server.calls.where((c) => c.endsWith('refresh')), hasLength(1));
    });

    test('SESSION_EXPIRED clears the session', () async {
      final server = _Server()
        ..handlers['api/auth/v1/refresh'] = (_) => (
          401,
          {'success': false, 'code': 'SESSION_EXPIRED', 'message': 'expired'},
        );
      final storage = await _signedIn(expiresInSeconds: 0);
      final refresher = TokenRefresher(_dio(server), storage);

      expect(await refresher.refresh(), RefreshResult.sessionExpired);
      expect(await storage.readAccessToken(), isNull);
      expect(await storage.hasValidSession(), isFalse);
    });

    test('AUTH_UNAVAILABLE keeps the user signed in', () async {
      final server = _Server()
        ..handlers['api/auth/v1/refresh'] = (_) => (
          503,
          {'success': false, 'code': 'AUTH_UNAVAILABLE', 'message': 'down'},
        );
      final storage = await _signedIn(expiresInSeconds: 0);
      final refresher = TokenRefresher(_dio(server), storage);

      expect(await refresher.refresh(), RefreshResult.unavailable);
      expect(await storage.readRefreshToken(), 'refresh-old');
      expect(await storage.hasValidSession(), isTrue);
    });

    test('logout sends the refresh token', () async {
      Object? sent;
      final server = _Server()
        ..handlers['api/auth/v1/logout'] = (o) {
          sent = o.data;
          return (200, {'success': true});
        };
      final storage = await _signedIn(expiresInSeconds: 300);
      await TokenRefresher(_dio(server), storage).logout();
      expect(sent, {'refreshToken': 'refresh-old'});
    });
  });

  group('AuthInterceptor', () {
    Future<(Dio, _Server, AuthTokenStorage, AuthSessionController)> setUpApi({
      required int expiresInSeconds,
    }) async {
      final server = _Server();
      final storage = await _signedIn(expiresInSeconds: expiresInSeconds);
      final refresher = TokenRefresher(_dio(server), storage);
      final session = AuthSessionController(storage, refresher);
      await session.initialize();
      final api = _dio(server)
        ..interceptors.add(AuthInterceptor(storage, session, refresher));
      return (api, server, storage, session);
    }

    test('a 401 refreshes once and retries with the new token', () async {
      final (api, server, _, session) = await setUpApi(expiresInSeconds: 300);
      server.handlers['api/auth/v1/refresh'] = (_) => (200, _tokens('new'));
      server.handlers['api/payments/v1/me/payments'] = (o) =>
          o.headers['Authorization'] == 'Bearer ${_accessToken('new')}'
          ? (200, {'success': true, 'data': 'ok'})
          : (401, {'success': false, 'message': 'expired token'});

      final response = await api.get<dynamic>('api/payments/v1/me/payments');
      expect(response.data['data'], 'ok');
      expect(session.isAuthenticated, isTrue);
    });

    test('an expiring token is refreshed before the request', () async {
      final (api, server, _, _) = await setUpApi(expiresInSeconds: 5);
      String? sentToken;
      server.handlers['api/auth/v1/refresh'] = (_) => (200, _tokens('new'));
      server.handlers['api/payments/v1/me/payments'] = (o) {
        sentToken = o.headers['Authorization']?.toString();
        return (200, {'success': true});
      };

      await api.get<dynamic>('api/payments/v1/me/payments');
      expect(sentToken, 'Bearer ${_accessToken('new')}');
    });

    test('an ended session signs the user out', () async {
      final (api, server, _, session) = await setUpApi(expiresInSeconds: 300);
      server.handlers['api/auth/v1/refresh'] = (_) => (
        401,
        {'success': false, 'code': 'SESSION_EXPIRED', 'message': 'expired'},
      );
      server.handlers['api/payments/v1/me/payments'] = (_) =>
          (401, {'success': false, 'message': 'expired token'});

      await expectLater(
        api.get<dynamic>('api/payments/v1/me/payments'),
        throwsA(isA<DioException>()),
      );
      expect(session.isAuthenticated, isFalse);
    });

    test('a 401 that survives a refresh does not sign out', () async {
      final (api, server, _, session) = await setUpApi(expiresInSeconds: 300);
      server.handlers['api/auth/v1/refresh'] = (_) => (200, _tokens('new'));
      server.handlers['api/zakat/v1/unknown'] = (_) =>
          (401, {'success': false, 'message': 'Authentication required'});

      await expectLater(
        api.post<dynamic>('api/zakat/v1/unknown'),
        throwsA(isA<DioException>()),
      );
      expect(session.isAuthenticated, isTrue);
      expect(server.calls.where((c) => c.endsWith('refresh')), hasLength(1));
    });
  });

  group('Session at startup', () {
    test(
      'an expired access token with a refresh token is still signed in',
      () async {
        final storage = await _signedIn(expiresInSeconds: -60);
        expect(await storage.hasValidSession(), isTrue);
      },
    );

    test(
      'no refresh token and an expired access token is signed out',
      () async {
        final storage = AuthTokenStorage();
        await storage.saveSession(
          accessToken: _accessToken('old'),
          refreshToken: '',
          tokenType: 'Bearer',
          expiresInSeconds: -60,
        );
        expect(await storage.hasValidSession(), isFalse);
      },
    );
  });

  group('Donor role rule', () {
    StoredAuthUser user(List<String> roles) =>
        StoredAuthUser(name: '', email: '', phone: '', roles: roles);

    test('DONOR alone is a donor', () {
      expect(user(['DONOR']).isDonor, isTrue);
      expect(user(['offline_access', 'donor']).isDonor, isTrue);
    });

    test('DONOR with a beneficiary or staff role is not', () {
      expect(user(['DONOR', 'BENEFICIARY']).isDonor, isFalse);
      expect(user(['DONOR', 'ADMIN']).isDonor, isFalse);
      expect(user(['DONOR', 'BRANCH']).isDonor, isFalse);
      expect(user(['DONOR', 'FIELD_OFFICER']).isDonor, isFalse);
      expect(user(['BENEFICIARY']).isDonor, isFalse);
      expect(user([]).isDonor, isFalse);
    });
  });
}

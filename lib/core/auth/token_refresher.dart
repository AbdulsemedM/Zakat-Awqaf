import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'auth_token_storage.dart';

enum RefreshResult {
  /// New tokens are stored.
  refreshed,

  /// The server ended the session (`SESSION_EXPIRED`, or no refresh token):
  /// the user must sign in again. Stored tokens are cleared.
  sessionExpired,

  /// The login server could not be reached (`AUTH_UNAVAILABLE`, network):
  /// keep the user signed in and try again later.
  unavailable,
}

/// Renews the 5-minute access token with the refresh token
/// (`POST /api/auth/v1/refresh`).
///
/// Refresh tokens are single use: every refresh returns a new one and the
/// old one stops working. So only one refresh runs at a time, and callers
/// that arrive meanwhile wait for its result.
///
/// Uses the auth Dio, which has no auth interceptor (refresh and logout are
/// public), so a refresh never triggers another refresh.
@lazySingleton
class TokenRefresher {
  TokenRefresher(@Named('authDio') this._dio, this._storage);

  final Dio _dio;
  final AuthTokenStorage _storage;

  static const _refreshPath = 'api/auth/v1/refresh';
  static const _logoutPath = 'api/auth/v1/logout';

  /// Refresh this long before the access token expires.
  static const expiryMargin = Duration(seconds: 30);

  Future<RefreshResult>? _inFlight;

  /// Refreshes now, or joins the refresh already running.
  Future<RefreshResult> refresh() =>
      _inFlight ??= _refresh().whenComplete(() => _inFlight = null);

  /// An access token valid for at least [expiryMargin], refreshing first if
  /// needed. `null` when the session has ended. When the server can't be
  /// reached, returns the stored token (the request may then get a 401).
  Future<String?> validAccessToken() async {
    final token = await _storage.readAccessToken();
    if (token == null || token.trim().isEmpty) return null;
    final expiresAt = await _storage.readAccessTokenExpiry();
    final expiring =
        expiresAt != null &&
        DateTime.now().add(expiryMargin).isAfter(expiresAt);
    if (!expiring) return token;
    final result = await refresh();
    return switch (result) {
      RefreshResult.refreshed => _storage.readAccessToken(),
      RefreshResult.sessionExpired => null,
      RefreshResult.unavailable => token,
    };
  }

  Future<RefreshResult> _refresh() async {
    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null || refreshToken.trim().isEmpty) {
      await _storage.clear();
      return RefreshResult.sessionExpired;
    }
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _refreshPath,
        data: {'refreshToken': refreshToken},
      );
      final data = response.data?['data'];
      if (response.data?['success'] != true || data is! Map) {
        return RefreshResult.unavailable;
      }
      final accessToken = data['accessToken']?.toString() ?? '';
      final newRefreshToken = data['refreshToken']?.toString() ?? '';
      if (accessToken.isEmpty || newRefreshToken.isEmpty) {
        return RefreshResult.unavailable;
      }
      // Store the rotated refresh token before anything else: the one we
      // sent no longer works.
      await _storage.saveSession(
        accessToken: accessToken,
        refreshToken: newRefreshToken,
        tokenType: data['tokenType']?.toString() ?? 'Bearer',
        expiresInSeconds: switch (data['expiresIn']) {
          final num seconds when seconds > 0 => seconds.toInt(),
          _ => 300,
        },
      );
      return RefreshResult.refreshed;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      // 401 SESSION_EXPIRED: expired, revoked or already used. 400: no
      // usable token. Either way only a new sign-in helps.
      if (status == 401 || status == 400) {
        await _storage.clear();
        return RefreshResult.sessionExpired;
      }
      return RefreshResult.unavailable;
    }
  }

  /// Ends the session on the server (best effort: it always answers 200,
  /// and the caller clears the tokens on the phone whatever happens).
  Future<void> logout() async {
    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null || refreshToken.trim().isEmpty) return;
    try {
      await _dio.post<void>(
        _logoutPath,
        data: {'refreshToken': refreshToken},
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
    } on DioException {
      // Offline or server down: the session still ends on the phone.
    }
  }

  /// Sends [options] again with [accessToken] (after a 401 and a refresh).
  Future<Response<dynamic>> retry(RequestOptions options, String accessToken) {
    final headers = Map<String, dynamic>.from(options.headers)
      ..['Authorization'] = 'Bearer $accessToken';
    return _dio.fetch<dynamic>(
      options.copyWith(
        headers: headers,
        extra: {...options.extra, retriedAfterRefreshKey: true},
      ),
    );
  }

  /// Marks a request already retried once, so a second 401 is not retried.
  static const retriedAfterRefreshKey = 'retriedAfterRefresh';
}

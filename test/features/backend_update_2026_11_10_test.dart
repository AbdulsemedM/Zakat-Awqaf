import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/app/router/app_router_module.dart';
import 'package:mejlis_digital_hub/core/auth/auth_session_controller.dart';
import 'package:mejlis_digital_hub/core/network/api_envelope.dart';
import 'package:mejlis_digital_hub/features/causes/data/models/cause.dart';
import 'package:mejlis_digital_hub/features/home/data/models/home_summary.dart';
import 'package:mejlis_digital_hub/features/impact/data/models/impact_model.dart';
import 'package:mejlis_digital_hub/features/profile/data/models/payout_bank.dart';

/// Only [passwordChangeRequired] matters to the redirect.
class _Session implements AuthSessionController {
  _Session(this.passwordChangeRequired);

  @override
  final bool passwordChangeRequired;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Backend release of 2026-11-10 (MOBILE_APP_UPDATE_2026-11-10.md).
void main() {
  group('Forced password change redirect (section 2)', () {
    test('holds a temporary-password session on the change screen', () {
      final session = _Session(true);
      expect(
        passwordChangeRedirect(session, '/profile'),
        forcedPasswordChangeLocation,
      );
      expect(
        passwordChangeRedirect(session, '/causes/c1'),
        forcedPasswordChangeLocation,
      );
      expect(
        passwordChangeRedirect(session, forcedPasswordChangeLocation),
        isNull,
      );
    });

    test('lets the splash and onboarding finish first', () {
      final session = _Session(true);
      expect(passwordChangeRedirect(session, '/splash'), isNull);
      expect(passwordChangeRedirect(session, '/onboarding'), isNull);
    });

    test('leaves the change screen once the password is changed', () {
      final session = _Session(false);
      expect(
        passwordChangeRedirect(session, forcedPasswordChangeLocation),
        '/profile',
      );
      expect(passwordChangeRedirect(session, '/profile'), isNull);
    });
  });

  group('Error bodies (sections 3, 14)', () {
    DioException error(int status, Object body, {String? headerId}) {
      final options = RequestOptions(path: 'api/auth/v1/me/password');
      return DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: status,
          data: body,
          headers: Headers.fromMap({
            if (headerId != null) 'x-request-id': [headerId],
          }),
        ),
      );
    }

    test('CURRENT_PASSWORD_INVALID is a 400 with its code and requestId', () {
      final e = apiExceptionFromDio(
        error(400, {
          'success': false,
          'code': 'CURRENT_PASSWORD_INVALID',
          'message': 'Current password is incorrect',
          'requestId': 'req-1',
        }),
      );
      expect(e.statusCode, 400);
      expect(e.code, 'CURRENT_PASSWORD_INVALID');
      expect(e.requestId, 'req-1');
      expect(e.toString(), contains('req-1'));
    });

    test('requestId falls back to the X-Request-Id header', () {
      final e = apiExceptionFromDio(error(404, 'Not Found', headerId: 'req-2'));
      expect(e.requestId, 'req-2');
    });
  });

  group('Causes (section 15)', () {
    Map<String, dynamic> json([Map<String, dynamic> extra = const {}]) => {
      'id': 'c1',
      'title': 'Water',
      'category': 'water',
      'acceptsZakat': true,
      ...extra,
    };

    test('a closed cause takes no gifts', () {
      final cause = Cause.fromJson(
        json({'status': 'closed', 'closedAt': '2026-11-01T00:00:00Z'}),
      );
      expect(cause.isClosed, isTrue);
      expect(cause.canGive, isFalse);
      expect(cause.closedAt, DateTime.utc(2026, 11, 1));
    });

    test('an active cause (or one without status) can be given to', () {
      expect(Cause.fromJson(json({'status': 'active'})).canGive, isTrue);
      expect(Cause.fromJson(json()).canGive, isTrue);
    });

    test('image sizes and alt text', () {
      final cause = Cause.fromJson(
        json({
          'imageUrl': 'https://x/media/1',
          'imageAltText': 'A new well',
          'imageVariants': {
            'thumbnail': 'https://x/media/1?size=thumbnail',
            'medium': 'https://x/media/1?size=medium',
            'large': 'https://x/media/1?size=large',
          },
        }),
      );
      expect(cause.imageAltText, 'A new well');
      expect(
        cause.imageVariants.thumbnailOr(cause.imageUrl),
        'https://x/media/1?size=thumbnail',
      );
      expect(
        cause.imageVariants.mediumOr(cause.imageUrl),
        'https://x/media/1?size=medium',
      );
    });

    test('without variants the original image is used', () {
      final cause = Cause.fromJson(json({'imageUrl': 'https://x/media/1'}));
      expect(
        cause.imageVariants.thumbnailOr(cause.imageUrl),
        'https://x/media/1',
      );
    });

    test('detail gallery, or one built from images', () {
      final withGallery = CauseDetail.fromJson(
        json({
          'images': ['https://x/a'],
          'gallery': [
            {
              'url': 'https://x/a',
              'altText': 'Children at the well',
              'variants': {'thumbnail': 'https://x/a?size=thumbnail'},
            },
          ],
        }),
      );
      expect(withGallery.gallery.single.altText, 'Children at the well');
      expect(
        withGallery.gallery.single.variants.thumbnail,
        'https://x/a?size=thumbnail',
      );

      final plain = CauseDetail.fromJson(
        json({
          'images': ['https://x/a', 'https://x/b'],
        }),
      );
      expect(plain.gallery.map((g) => g.url), ['https://x/a', 'https://x/b']);
    });
  });

  test('stories carry alt text and image sizes', () {
    final story = ImpactStory.fromJson({
      'id': 's1',
      'title': 'A story',
      'imageUrl': 'https://x/s',
      'imageAltText': 'A family',
      'imageVariants': {'medium': 'https://x/s?size=medium'},
      'regionCode': 'AA',
    });
    expect(story.imageAltText, 'A family');
    expect(
      story.imageVariants.mediumOr(story.imageUrl),
      'https://x/s?size=medium',
    );
    expect(story.regionCode, 'AA');
  });

  group('Home summary live / offline split (section 15)', () {
    test('parses the new figures', () {
      final summary = HomeSummary.fromJson({
        'totalCollectedEtb': 1500000,
        'liveCollectedEtb': 1000000,
        'offlineCollectedEtb': 500000,
        'liveBeneficiariesSupported': 80,
        'offlineBeneficiariesSupported': 20,
        'offlineAsOfDate': '2026-10-31',
      });
      expect(summary.liveCollectedEtb, 1000000);
      expect(summary.offlineCollectedEtb, 500000);
      expect(summary.offlineBeneficiariesSupported, 20);
      expect(summary.offlineAsOfDate, DateTime(2026, 10, 31));
      expect(summary.hasOfflineCollected, isTrue);
    });

    test('no offline line without offline money', () {
      expect(
        HomeSummary.fromJson({
          'totalCollectedEtb': 10,
          'offlineCollectedEtb': 0,
        }).hasOfflineCollected,
        isFalse,
      );
      expect(
        HomeSummary.fromJson({'totalCollectedEtb': 10}).hasOfflineCollected,
        isFalse,
      );
    });
  });

  group('Payout banks (section 11)', () {
    test('ipsPayable', () {
      final bank = PayoutBank.fromJson({
        'code': 'coop_bank_of_oromia',
        'name': 'Coop',
        'available': true,
        'ipsPayable': true,
      });
      expect(bank.ipsPayable, isTrue);
    });

    test('debub_global is now global_bank', () {
      expect(PayoutBank.canonicalCode('debub_global'), 'global_bank');
      expect(PayoutBank.canonicalCode('global_bank'), 'global_bank');
      expect(
        PayoutBank.fromJson({'code': 'debub_global', 'name': 'x'}).code,
        'global_bank',
      );
    });
  });
}

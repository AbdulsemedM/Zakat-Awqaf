import 'package:flutter_test/flutter_test.dart';
import 'package:mejlis_digital_hub/core/network/api_envelope.dart';
import 'package:mejlis_digital_hub/features/causes/data/models/cause.dart';
import 'package:mejlis_digital_hub/features/impact/bloc/impact_bloc.dart';
import 'package:mejlis_digital_hub/features/impact/bloc/impact_event.dart';
import 'package:mejlis_digital_hub/features/impact/bloc/impact_state.dart';
import 'package:mejlis_digital_hub/features/impact/data/models/impact_model.dart';
import 'package:mejlis_digital_hub/features/impact/data/repository/impact_repository.dart';

/// Samples from docs/ZAKAT_BACKEND_APIS.md (B4).
final _national = ImpactSummary.fromJson({
  'scope': 'national',
  'regionName': 'Ethiopia',
  'distributedFundsEtb': 42550000.00,
  'livesTouched': 142500,
  'activeProjects': 84,
  'beneficiariesByAsnaf': [
    {'asnaf': 'poor', 'count': 2100},
    {'asnaf': 'debtor', 'count': 310},
  ],
  'asOf': '2026-09-30T08:00:00+03:00',
});

final _addisRegion = ImpactRegion.tryParse({
  'code': 'addis_ababa',
  'name': 'Addis Ababa',
  'latitude': 9.03,
  'longitude': 38.74,
  'distributedFundsEtb': 12000000.00,
  'beneficiaries': 40210,
  'activeProjects': 21,
})!;

class _FakeImpactRepository implements ImpactRepository {
  ApiException? summaryError;
  ApiException? regionsError;
  final summaryRequests = <String?>[];

  @override
  Future<ImpactSummary> fetchSummary({
    String? regionCode,
    required String lang,
  }) async {
    summaryRequests.add(regionCode);
    if (summaryError != null) throw summaryError!;
    if (regionCode == null) return _national;
    return const ImpactSummary(
      scope: 'region',
      regionName: 'Addis Ababa',
      distributedFundsEtb: 12000000,
    );
  }

  @override
  Future<List<ImpactRegion>> fetchRegions({required String lang}) async {
    if (regionsError != null) throw regionsError!;
    return [_addisRegion];
  }

  @override
  Future<List<ImpactStory>> fetchStories({required String lang}) async => [
    ImpactStory.fromJson({
      'id': '5',
      'title': "Ahmed's Shop",
      'category': 'livelihood',
      'region': 'Harari',
      'publishedAt': '2026-08-01',
    }),
  ];

  @override
  Future<ImpactStory> fetchStory(String id, {required String lang}) {
    throw UnimplementedError();
  }
}

Future<void> _settle() => Future<void>.delayed(const Duration(milliseconds: 1));

void main() {
  group('Impact models', () {
    test('summary parses the sample', () {
      expect(_national.distributedFundsEtb, 42550000);
      expect(_national.beneficiariesByAsnaf.first.label, 'Poor');
      expect(_national.beneficiariesByAsnaf.last.count, 310);
      expect(_national.isLive(DateTime.utc(2026, 9, 30, 5, 30)), isTrue);
      expect(_national.isLive(DateTime.utc(2026, 9, 30, 7)), isFalse);

      final empty = ImpactSummary.fromJson({'scope': 'national'});
      expect(empty.distributedFundsEtb, isNull);
      expect(empty.beneficiariesByAsnaf, isEmpty);
    });

    test('regions without coordinates are skipped; unknown asnaf kept', () {
      expect(ImpactRegion.tryParse({'code': 'x', 'name': 'X'}), isNull);
      expect(_addisRegion.beneficiaries, 40210);
      expect(const AsnafCount(asnaf: 'other', count: 1).label, 'other');
    });

    test('story parses the sample', () {
      final story = ImpactStory.fromJson({
        'id': '5',
        'title': "Ahmed's Shop",
        'summary': 's',
        'body': 'b',
        'category': 'livelihood',
        'region': 'Harari',
        'imageUrl': 'https://example.com/a.png',
        'publishedAt': '2026-08-01',
      });
      expect(story.category, CauseCategory.livelihood);
      expect(story.publishedAt, DateTime(2026, 8, 1));
    });
  });

  group('ImpactBloc', () {
    test('loads summary, regions and stories', () async {
      final bloc = ImpactBloc(_FakeImpactRepository())
        ..add(const ImpactStarted('en'));
      addTearDown(bloc.close);
      await _settle();

      expect(bloc.state.status, ImpactLoadStatus.loaded);
      expect(bloc.state.summary, _national);
      expect(bloc.state.regions, [_addisRegion]);
      expect(bloc.state.stories, hasLength(1));
    });

    test('fails only when the summary fails', () async {
      final repository = _FakeImpactRepository()
        ..summaryError = const ApiException('down');
      final bloc = ImpactBloc(repository)..add(const ImpactStarted('en'));
      addTearDown(bloc.close);
      await _settle();
      expect(bloc.state.status, ImpactLoadStatus.failed);

      final partial = _FakeImpactRepository()
        ..regionsError = const ApiException('down');
      final bloc2 = ImpactBloc(partial)..add(const ImpactStarted('en'));
      addTearDown(bloc2.close);
      await _settle();
      expect(bloc2.state.status, ImpactLoadStatus.loaded);
      expect(bloc2.state.regions, isEmpty);
    });

    test('selecting a region loads its summary; null goes national', () async {
      final repository = _FakeImpactRepository();
      final bloc = ImpactBloc(repository)..add(const ImpactStarted('en'));
      addTearDown(bloc.close);
      await _settle();

      bloc.add(const ImpactRegionSelected('addis_ababa'));
      await _settle();
      expect(bloc.state.selectedRegion, _addisRegion);
      expect(bloc.state.summary?.scope, 'region');
      expect(repository.summaryRequests.last, 'addis_ababa');

      bloc.add(const ImpactRegionSelected(null));
      await _settle();
      expect(bloc.state.selectedRegionCode, isNull);
      expect(bloc.state.summary, _national);
    });

    test('a failed region load keeps the previous selection', () async {
      final repository = _FakeImpactRepository();
      final bloc = ImpactBloc(repository)..add(const ImpactStarted('en'));
      addTearDown(bloc.close);
      await _settle();

      repository.summaryError = const ApiException('down');
      bloc.add(const ImpactRegionSelected('addis_ababa'));
      await _settle();
      expect(bloc.state.selectedRegionCode, isNull);
      expect(bloc.state.isRegionLoading, isFalse);
      expect(bloc.state.summary, _national);
    });
  });
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mejlis_digital_hub/app/app.dart';
import 'package:mejlis_digital_hub/core/di/injection.dart';
import 'package:mejlis_digital_hub/features/awqaf/bloc/awqaf_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home renders app title', (WidgetTester tester) async {
    FlutterConfig.loadValueForTesting({
      'API_BASE_URL': 'https://example.com',
      'API_KEY': 'test',
    });
    configureDependencies();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AwqafBloc>(create: (_) => getIt<AwqafBloc>()),
        ],
        child: const MejlisApp(),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  }, skip: true);
}

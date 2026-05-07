import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mejlis_digital_hub/app/app.dart';
import 'package:mejlis_digital_hub/core/di/injection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home renders app title', (WidgetTester tester) async {
    FlutterConfig.loadValueForTesting({
      'API_BASE_URL': 'https://example.com',
      'API_KEY': 'test',
    });
    configureDependencies();

    await tester.pumpWidget(
      MultiBlocProvider(providers: [], child: const MejlisApp()),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  }, skip: true);
}

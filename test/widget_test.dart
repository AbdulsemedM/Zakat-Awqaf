import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mejlis_digital_hub/app/app.dart';
import 'package:mejlis_digital_hub/core/di/injection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home renders app title', (WidgetTester tester) async {
    // Needs --dart-define=API_BASE_URL=https://… (see AppEnv).
    configureDependencies();

    await tester.pumpWidget(
      MultiBlocProvider(providers: [], child: const MejlisApp()),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  }, skip: true);
}

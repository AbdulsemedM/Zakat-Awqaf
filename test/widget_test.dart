import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mejlis_digital_hub/app/app.dart';
import 'package:mejlis_digital_hub/core/constants/app_constants.dart';
import 'package:mejlis_digital_hub/core/di/injection.dart';
import 'package:mejlis_digital_hub/features/awqaf/presentation/bloc/awqaf_bloc.dart';
import 'package:mejlis_digital_hub/features/zakat/presentation/bloc/zakat_bloc.dart';

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
          BlocProvider<ZakatBloc>(create: (_) => getIt<ZakatBloc>()),
          BlocProvider<AwqafBloc>(create: (_) => getIt<AwqafBloc>()),
        ],
        child: const MejlisApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppConstants.appTitle), findsOneWidget);
  });
}

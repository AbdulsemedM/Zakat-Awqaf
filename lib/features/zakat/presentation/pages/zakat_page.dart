import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/widgets/loading_indicator.dart';
import '../bloc/zakat_bloc.dart';
import '../bloc/zakat_event.dart';
import '../bloc/zakat_state.dart';

class ZakatPage extends StatelessWidget {
  const ZakatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zakat')),
      body: BlocBuilder<ZakatBloc, ZakatState>(
        builder: (context, state) {
          switch (state) {
            case ZakatInitial():
              return Center(
                child: FilledButton(
                  onPressed: () =>
                      context.read<ZakatBloc>().add(const ZakatStarted()),
                  child: const Text('Load Zakat summary'),
                ),
              );
            case ZakatLoading():
              return const LoadingIndicator();
            case ZakatLoaded(:final summary):
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Zakat (${summary.currency}): ${summary.amount}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            case ZakatError(:final message):
              return Center(child: Text(message));
          }
        },
      ),
    );
  }
}

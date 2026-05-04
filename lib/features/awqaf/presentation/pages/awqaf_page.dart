import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/widgets/loading_indicator.dart';
import '../bloc/awqaf_bloc.dart';
import '../bloc/awqaf_event.dart';
import '../bloc/awqaf_state.dart';

class AwqafPage extends StatelessWidget {
  const AwqafPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Awqaf')),
      body: BlocBuilder<AwqafBloc, AwqafState>(
        builder: (context, state) {
          switch (state) {
            case AwqafInitial():
              return Center(
                child: FilledButton(
                  onPressed: () =>
                      context.read<AwqafBloc>().add(const AwqafStarted()),
                  child: const Text('Initialize Awqaf'),
                ),
              );
            case AwqafLoading():
              return const LoadingIndicator();
            case AwqafLoaded(:final message):
              return Center(child: Text(message));
            case AwqafError(:final message):
              return Center(child: Text(message));
          }
        },
      ),
    );
  }
}

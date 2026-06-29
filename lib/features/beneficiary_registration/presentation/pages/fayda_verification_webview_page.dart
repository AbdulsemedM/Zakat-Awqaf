import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/l10n/l10n.dart';
import '../../bloc/beneficiary_registration_bloc.dart';
import '../../bloc/beneficiary_registration_state.dart';

class FaydaVerificationWebViewPage extends StatefulWidget {
  const FaydaVerificationWebViewPage({required this.url, super.key});

  final Uri url;

  @override
  State<FaydaVerificationWebViewPage> createState() =>
      _FaydaVerificationWebViewPageState();
}

class _FaydaVerificationWebViewPageState
    extends State<FaydaVerificationWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
      listenWhen: (previous, current) =>
          !previous.faydaVerificationComplete &&
          current.faydaVerificationComplete,
      listener: (context, state) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<BeneficiaryRegistrationBloc, BeneficiaryRegistrationState>(
        buildWhen: (previous, current) =>
            previous.awaitingFaydaSse != current.awaitingFaydaSse ||
            previous.faydaVerificationComplete !=
                current.faydaVerificationComplete,
        builder: (context, state) {
          final showWaitingOverlay =
              state.awaitingFaydaSse && !state.faydaVerificationComplete;

          return Scaffold(
            appBar: AppBar(
              title: Text(context.l10n.faydaIdentityVerification),
            ),
            body: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (showWaitingOverlay)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Material(
                      elevation: 4,
                      color: Theme.of(context).colorScheme.surface,
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Waiting for verification confirmation…',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

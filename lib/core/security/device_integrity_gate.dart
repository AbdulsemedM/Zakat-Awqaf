import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safe_device/safe_device.dart';

import '../l10n/l10n.dart';

/// Release builds: on a rooted (Android) or jailbroken (iOS) phone, covers
/// the app with a warning once per launch until the user acknowledges it.
/// Root checks have false positives on some vendor firmware, so this warns
/// rather than blocks; to block, drop the continue button.
class DeviceIntegrityGate extends StatefulWidget {
  const DeviceIntegrityGate({required this.child, super.key});

  final Widget child;

  @override
  State<DeviceIntegrityGate> createState() => _DeviceIntegrityGateState();
}

class _DeviceIntegrityGateState extends State<DeviceIntegrityGate> {
  bool _showWarning = false;

  @override
  void initState() {
    super.initState();
    if (kReleaseMode) _check();
  }

  Future<void> _check() async {
    final compromised = await SafeDevice.isJailBroken;
    if (mounted && compromised) setState(() => _showWarning = true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showWarning)
          Positioned.fill(
            child: _Warning(
              onContinue: () => setState(() => _showWarning = false),
            ),
          ),
      ],
    );
  }
}

class _Warning extends StatelessWidget {
  const _Warning({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.gpp_maybe_outlined,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.deviceIntegrityTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.deviceIntegrityBody,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: onContinue,
                child: Text(l10n.deviceIntegrityContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

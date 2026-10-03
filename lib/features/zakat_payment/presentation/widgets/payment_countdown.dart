import 'dart:async';

import 'package:flutter/material.dart';

/// Rebuilds every second with the time left until [deadline], and calls
/// [onFinished] once when it reaches zero. Uses the device clock against
/// the server's timestamp, so it can be off by the clock difference.
class PaymentCountdown extends StatefulWidget {
  const PaymentCountdown({
    super.key,
    required this.deadline,
    required this.builder,
    this.onFinished,
  });

  final DateTime deadline;
  final Widget Function(BuildContext context, Duration remaining) builder;
  final VoidCallback? onFinished;

  @override
  State<PaymentCountdown> createState() => _PaymentCountdownState();
}

class _PaymentCountdownState extends State<PaymentCountdown> {
  Timer? _timer;
  bool _finished = false;

  Duration get _remaining {
    final left = widget.deadline.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(PaymentCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deadline != widget.deadline) {
      _finished = false;
      _start();
    }
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      if (_remaining == Duration.zero && !_finished) {
        _finished = true;
        _timer?.cancel();
        widget.onFinished?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _remaining);
}

/// `4:05`, or `1:02:05` past an hour.
String formatCountdown(Duration remaining) {
  final hours = remaining.inHours;
  final minutes = remaining.inMinutes.remainder(60);
  final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
  return hours > 0
      ? '$hours:${minutes.toString().padLeft(2, '0')}:$seconds'
      : '$minutes:$seconds';
}

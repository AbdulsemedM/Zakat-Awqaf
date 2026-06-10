import 'dart:math';

/// Generates a placeholder national ID for Fayda fast-track registration.
String generateFaydaNationalId() {
  final random = Random();
  final digits = List.generate(9, (_) => random.nextInt(10)).join();
  return 'ID-$digits';
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_results.g.dart';

class TestResults {
  double maxStrengthLeft = 0.0;
  double maxStrengthRight = 0.0;
  double meanStrengthLeft = 0.0;
  double meanStrengthRight = 0.0;
  double rfdfLeft = 0.0;
  double rfdRight = 0.0;
  double peakForce = 0.0;
  double criticalForce = 0.0;
}

@riverpod
TestResults testResults(TestResultsRef ref) {
  return TestResults();
}
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_results.g.dart';

enum Result {
  maxStrengthLeft,
  maxStrengthRight,
  meanStrengthLeft,
  meanStrengthRight,
  rfdfLeft,
  rfdRight,
  peakForce,
  criticalForce,
}

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

@riverpod

/// Holds the status of all the tests
class TestResults2 extends _$TestResults2 {
  final Map<Result, double> _results = {
    Result.maxStrengthLeft: 0.0,
    Result.maxStrengthRight: 0.0,
    Result.meanStrengthLeft: 0.0,
    Result.meanStrengthRight: 0.0,
    Result.rfdfLeft: 0.0,
    Result.rfdRight: 0.0,
    Result.peakForce: 0.0,
    Result.criticalForce: 0.0,
  };
  @override
  Map<Result, double> build() {
    debugPrint("testResults2Provider created");
    ref.keepAlive();
    ref.onDispose(() => debugPrint("testResults2Provider disposed"));
    return _results;
  }

  setResult(Result test, double result) {
    _results[test] = result;
    state = _results;
  }
}

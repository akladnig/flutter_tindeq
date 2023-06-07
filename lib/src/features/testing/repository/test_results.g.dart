// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_results.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$testResultsHash() => r'8e7358e11578adb30786fe605fcb3e40635db05d';

/// See also [testResults].
@ProviderFor(testResults)
final testResultsProvider = AutoDisposeProvider<TestResults>.internal(
  testResults,
  name: r'testResultsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$testResultsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TestResultsRef = AutoDisposeProviderRef<TestResults>;
String _$testResults2Hash() => r'41c4ee622c40850160697f6fb65e3d09161ea8eb';

/// Holds the status of all the tests
///
/// Copied from [TestResults2].
@ProviderFor(TestResults2)
final testResults2Provider =
    AutoDisposeNotifierProvider<TestResults2, Map<Result, double>>.internal(
  TestResults2.new,
  name: r'testResults2Provider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$testResults2Hash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TestResults2 = AutoDisposeNotifier<Map<Result, double>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'testing_models.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentTestHash() => r'0b1e47c9edbef9a6a3a67302999ffa213e171c2f';

/// See also [CurrentTest].
@ProviderFor(CurrentTest)
final currentTestProvider =
    AutoDisposeNotifierProvider<CurrentTest, (Tests, TestState)>.internal(
  CurrentTest.new,
  name: r'currentTestProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentTestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentTest = AutoDisposeNotifier<(Tests, TestState)>;
String _$allTestsHash() => r'7e858ea242422c68588158d03ac9f416137f39ae';

/// Holds the status of all the tests
///
/// Copied from [AllTests].
@ProviderFor(AllTests)
final allTestsProvider =
    AutoDisposeNotifierProvider<AllTests, Map<Tests, TestState>>.internal(
  AllTests.new,
  name: r'allTestsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTestsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AllTests = AutoDisposeNotifier<Map<Tests, TestState>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions

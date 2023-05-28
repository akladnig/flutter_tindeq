import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results.dart';
import 'package:flutter_tindeq/src/features/testing/testing_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_actions.g.dart';

enum TestState { waiting, start, complete }

class TestStarted {
  bool state = false;
}

@riverpod
TestStarted testStarted(TestStartedRef ref) => TestStarted();

//TODO
maxAction(hand, ref) {
  switch (hand) {
    case Hand.left:
      ref.read(testResultsProvider).maxStrengthLeft = pointListMaxL.maxForce;
    case Hand.right:
      ref.read(testResultsProvider).maxStrengthRight = pointListMaxR.maxForce;
  }
}

//TODO
rfdAction(hand, ref) {
  PointListClass meansList = getCftEdges(pointListCft);
  ref.read(testResultsProvider).peakForce = meansList[0].$2;
  ref.read(testResultsProvider).criticalForce = criticalLoad(meansList);
}

cftAction(ref) {
  PointListClass meansList = getCftEdges(pointListCft);
  ref.read(testResultsProvider).peakForce = meansList[0].$2;
  ref.read(testResultsProvider).criticalForce = criticalLoad(meansList);
  ref.read(testStartedProvider).state = true;
  debugPrint(
      "cftAction: ${ref.watch(testResultsProvider).peakForce.toString()}");
      
}

buttonState(ref) {
  var buttonTextStart = const ButtonText(text: "Start Test");
  var buttonTextWaiting = const ButtonText(text: "Waiting for Progressor");
  var buttonTextComplete = const ButtonText(text: "Test Complete");

  var button =
      ref.read(testStartedProvider).state ? buttonTextStart : buttonTextWaiting;
  return button;
}

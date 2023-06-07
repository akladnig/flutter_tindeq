import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/features/testing/application/countdown_controller.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results.dart';
import 'package:flutter_tindeq/src/features/testing/testing_service.dart';

//TODO
void maxAction(hand, ref) {
  switch (hand) {
    case Hand.left:
      ref
          .read(testResults2Provider.notifier)
          .setResult(Result.maxStrengthLeft, pointListMaxL.maxForce.force);
      ref.read(testResultsProvider).meanStrengthLeft = pointListMaxL.mean.force;
    case Hand.right:
      ref
          .read(testResults2Provider.notifier)
          .setResult(Result.maxStrengthRight, pointListMaxL.maxForce.force);
      ref.read(testResultsProvider).maxStrengthRight =
          pointListMaxR.maxForce.force;
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
  ref.read(startTimerProvider.notifier).start();

  debugPrint(
      "cftAction: ${ref.watch(testResultsProvider).peakForce.toString()}");
}

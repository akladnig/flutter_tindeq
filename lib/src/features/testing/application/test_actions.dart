import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results_provider.dart';
import 'package:flutter_tindeq/src/features/testing/testing_service.dart';

void analyseResults(Tests currentTest, WidgetRef ref) {
  switch (currentTest) {
    case Tests.maxTestLeft || Tests.maxTestRight:
      Future(() => maxAction(currentTest, ref));
    case Tests.rfdTestLeft || Tests.rfdTestRight:
      Future(() => rfdAction(currentTest, ref));
    case Tests.cftTest:
      Future(() => cftAction(ref));
    default:
    //TODO handle this error state
  }
}

//TODO
void maxAction(Tests currentTest, WidgetRef ref) {
  switch (currentTest) {
    case Tests.maxTestLeft:
      ref
          .read(maxResultsProvider.notifier)
          .setResult(Hand.left, pointListMaxL.maxResult);
    case Tests.maxTestRight:
      ref
          .read(maxResultsProvider.notifier)
          .setResult(Hand.right, pointListMaxR.maxResult);
    default:
    //TODO handle this error state
  }
}

//TODO
rfdAction(Tests currentTest, WidgetRef ref) {
  switch (currentTest) {
    case Tests.rfdTestLeft:
      //TODO Make this a single class?
      ref
          .read(rfdResultsProvider.notifier)
          .setResult(Hand.left, pointListRfdL.rfdResult);
    case Tests.rfdTestRight:
      ref
          .read(rfdResultsProvider.notifier)
          .setResult(Hand.right, pointListRfdR.rfdResult);
    default:
  }
}

cftAction(WidgetRef ref) {
  ref.read(cftResultsProvider.notifier).setResult(cftResult);
}

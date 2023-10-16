import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results_provider.dart';
import 'package:flutter_tindeq/src/features/user_details/domain/user.dart';

//
//         Grading is based on the IRCRA scale
//
Map grades = {
  1: 4,
  2: 6,
  3: 7,
  4: 9,
  5: 10,
  6: 12,
  7: 13,
  8: 15,
  9: 16,
  10: 18,
  11: 19,
  12: 19,
  13: 20,
  14: 21,
  15: 22,
  16: 22,
  17: 23,
  18: 24,
  19: 25,
  20: 26,
  21: 27,
  22: 28,
  23: 29,
  24: 30,
  25: 31,
  26: 32,
  27: 33,
  28: 34,
  29: 35,
  30: 36,
};

(int, int) analyseStrength(WidgetRef ref) {
  User user = ref.watch(userProvider);

  var maxTests = ref.watch(maxResultsProvider);

  double meanStrength =
      maxTests[Hand.left].meanStrength + maxTests[Hand.right].meanStrength;
  double strengthDelta = meanStrength - user.weight;
  int ircaMin = 0;
  int ircaMax = 0;

  // These constants come from the research paper
  //"Differences in Upper-Body Peak Force and Rate of Force Development in Male Intermediate, Advanced, and Elite Sport Climbers"
  double irca = (strengthDelta * 9.81 + 59.9) / 28.5;
  ircaMin = irca.round().toInt() - 2;
  ircaMax = irca.round().toInt() + 2;
  debugPrint("analyseStrength $strengthDelta $irca");
  return (grades[ircaMin.clamp(1, 30)], grades[ircaMax.clamp(1, 30)]);
}

(int, int) analyseRfd(WidgetRef ref) {
  var rfdTests = ref.watch(rfdResultsProvider);
//TODO Mean or Peak????
  // double rfdMean = (rfdTests[Hand.left].peak + rfdTests[Hand.right].peak) / 2;
  int ircaMin = 0;
  int ircaMax = 0;

  double rfdMean = (rfdTests[Hand.left].mean + rfdTests[Hand.right].mean) / 2;
  // These constants come from the research paper
  //"Differences in Upper-Body Peak Force and Rate of Force Development in Male Intermediate, Advanced, and Elite Sport Climbers"
  if (rfdMean != 0) {
    double irca = (rfdMean * 9.81 + 798.3) / 117.8;
    ircaMin = irca.round().toInt() - 1;
    ircaMax = irca.round().toInt() + 1;
  }
  return (grades[ircaMin.clamp(1, 30)], grades[ircaMax.clamp(1, 30)]);
}

(int, int) analyseCft(WidgetRef ref) {
  User user = ref.watch(userProvider);

  var cftTests = ref.watch(cftResultsProvider);
  int ircaMin = 0;
  int ircaMax = 0;
  // These constants come from the research paper
  //
  //TODO not convinced that 0.3 is the mean value - maybe it is more like 0.49
  if (cftTests.asymptoticForce != 0) {
    ircaMin = (cftTests.asymptoticForce / user.weight * 100 * 0.41 + 6)
        .round()
        .toInt();
    ircaMax = (cftTests.asymptoticForce / user.weight * 100 * 0.57 + 6)
        .round()
        .toInt();
  }
  debugPrint("analyseCft $ircaMin $ircaMax");

  return (grades[ircaMin.clamp(1, 30)], grades[ircaMax.clamp(1, 30)]);
}

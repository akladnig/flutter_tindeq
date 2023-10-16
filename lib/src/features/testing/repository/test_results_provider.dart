import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_results_provider.g.dart';

//TODO turn this into a class
typedef MaxResult = ({
  double maxStrength,
  double meanStrength,
  Line meanLine,
});

@Riverpod(keepAlive: true)
class MaxResults extends _$MaxResults {
  final Map<Hand, MaxResult> _maxResults = {
    Hand.left: (
      maxStrength: 0.0,
      meanStrength: 0.0,
      meanLine: ((0.0, 0.0), (0.0, 0.0))
    ),
    Hand.right: (
      maxStrength: 0.0,
      meanStrength: 0.0,
      meanLine: ((0.0, 0.0), (0.0, 0.0))
    ),
  };
  @override
  build() {
    return _maxResults;
  }

  setResult(Hand hand, MaxResult result) {
    //Create a new map so that the Map update is notified
    //- updating an internal member does not result in an update to the map itself
    Map<Hand, MaxResult> newMap = Map.of(state);
    newMap[hand] = result;
    state = newMap;
  }
}

typedef RfdResult = ({
  double peak,
  Point peakPoint,
  Line peakLine,
  double mean,
  double timeToPeak,
});

@Riverpod(keepAlive: true)
class RfdResults extends _$RfdResults {
  final Map<Hand, RfdResult> _rfdResults = {
    Hand.left: (
      peak: 0.0,
      peakPoint: (0.0, 0.0),
      peakLine: ((0.0, 0.0), (0.0, 0.0)),
      mean: 0.0,
      timeToPeak: 0.0,
    ),
    Hand.right: (
      peak: 0.0,
      peakPoint: (0.0, 0.0),
      peakLine: ((0.0, 0.0), (0.0, 0.0)),
      mean: 0.0,
      timeToPeak: 0.0,
    ),
  };
  @override
  build() {
    return _rfdResults;
  }

  setResult(Hand hand, RfdResult result) {
    //Create a new map so that the Map update is notified
    //- updating an internal member does not result in an update to the map itself
    Map<Hand, RfdResult> newMap = Map.of(state);
    newMap[hand] = result;
    state = newMap;
  }
}

typedef CftResult = ({
  double peakForce,
  double criticalForce,
  double asymptoticForce,
  PointListClass cftPoints,
  double wPrime,
  double anaerobicFunction,
});

@Riverpod(keepAlive: true)
class CftResults extends _$CftResults {
  final CftResult _cftResults = (
    peakForce: 0.0,
    criticalForce: 0.0,
    asymptoticForce: 0.0,
    cftPoints: PointListClass([]),
    wPrime: 0.0,
    anaerobicFunction: 0.0
  );
  @override
  build() {
    return _cftResults;
  }

//TODO breakout the list of points
  setResult(CftResult result) {
    state = result;
  }
}

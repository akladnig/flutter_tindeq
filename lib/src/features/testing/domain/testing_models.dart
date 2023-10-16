import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'testing_models.g.dart';

typedef Point = (double, double);
// class Point {
//   bool get isInEdge{

//   }
// }
typedef NamedPoint = ({double time, double force});
typedef PointList = List<Point>;

enum EdgeType { rising, falling }

/// A line drawn from point to point
typedef Line = (Point, Point);

typedef Legend = ({String title, Color colour});

enum ListType { time, force }

enum Hand {
  left('Left'),
  right('Right');

  const Hand(this.label);
  final String label;
}

enum TestState { notStarted, inProgress, complete, failed }

//TODO should this be a list?
enum Tests {
  none('none'),
  maxTestLeft('maxTestLeft'),
  maxTestRight('maxTestRight'),
  rfdTestLeft('rfdTestLeft'),
  rfdTestRight('rfdTestRight'),
  cftTest('cftTest');

  const Tests(this.label);
  final String label;
}

// A record to hold the status of each test
typedef TestStatus = (Tests, TestState);

@riverpod
class CurrentTest extends _$CurrentTest {
  (Tests, TestState) _currentTest = (Tests.none, TestState.notStarted);

  @override
  (Tests, TestState) build() => _currentTest;

  setTest(Tests test, TestState testState) {
    _currentTest = (test, testState);
    state = _currentTest;
  }
}

@Riverpod(keepAlive: true)

/// Holds the status of all the tests
class AllTests extends _$AllTests {
  final Map<Tests, TestState> _tests = {
    Tests.maxTestLeft: TestState.notStarted,
    Tests.maxTestRight: TestState.notStarted,
    Tests.rfdTestLeft: TestState.notStarted,
    Tests.rfdTestRight: TestState.notStarted,
    Tests.cftTest: TestState.notStarted,
  };

  @override
  Map<Tests, TestState> build() {
    debugPrint("Alltests Provider");
    ref.onDispose(() {
      debugPrint("Alltests disposed");
    });
    return _tests;
  }

  setTest(Tests test, TestState testState) {
    //Create a new map so that the Map update is notified
    //- updating and internal member does not result in an update to the map itself
    Map<Tests, TestState> newMap = Map.of(state);
    newMap[test] = testState;
    state = newMap;
  }
}

//TODO move all the methods to a controller class
class PointListClass extends ListBase<Point> {
  PointListClass(this.pointList);

  final PointList pointList;

  @override
  set length(int newLength) {
    pointList.length = newLength;
  }

  @override
  int get length => pointList.length;

  @override
  Point operator [](int index) => pointList[index];

  @override
  void operator []=(int index, Point point) {
    pointList[index] = point;
  }

  @override
  PointListClass sublist(int start, [int? end]) {
    PointList sublist = [];
    sublist = pointList.sublist(start, end!);
    return PointListClass(sublist);
  }

  PointList get toFixed {
    PointList fixedList = [];
    for (var point in pointList) {
      Point fixedPoint = (point.$1, (point.$2 * 10).round() / 10);
      fixedList.add(fixedPoint);
    }
    return (fixedList);
  }
}

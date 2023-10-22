import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'testing_models.g.dart';

typedef Point = (double, double);
typedef NamedPoint = ({double time, double force});
typedef Points = List<Point>;

/// A line drawn from point to point
typedef Line = (Point, Point);

enum EdgeType { rising, falling }

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

class IndexList extends ListBase<int> {
  IndexList(this.indexList);

  final List<int> indexList;

  @override
  set length(int newLength) {
    indexList.length = newLength;
  }

  @override
  int get length => indexList.length;

  @override
  int operator [](int index) => indexList[index];

  @override
  void operator []=(int i, int index) {
    indexList[i] = index;
  }

  Points toPointList(PointList pointList, [int? offset]) {
    Points rfdList = [];
    offset = offset ?? 0;
    for (var index in indexList) {
      rfdList.add(pointList[offset + index]);
    }
    return rfdList;
  }
}

class PointList extends ListBase<Point> {
  PointList(this.pointList);

  final Points pointList;

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
  PointList sublist(int start, [int? end]) {
    Points sublist = [];
    //TODO if values are out of range clamp and throw an error or maybe log it??

    start = start.clamp(0, pointList.length);

    end = end ?? pointList.length;
    end = end.clamp(0, pointList.length);
    sublist = pointList.sublist(start, end);
    return PointList(sublist);
  }

  Points get toFixed {
    Points fixedList = [];
    for (var point in pointList) {
      Point fixedPoint = (point.$1, (point.$2 * 10).round() / 10);
      fixedList.add(fixedPoint);
    }
    return (fixedList);
  }
}

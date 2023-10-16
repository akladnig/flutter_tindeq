import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:statistics/statistics.dart';

enum Sequence { increment, decrement }

/// Returns a sub list of List<double> of either force or time between the start and end values.
//TODO check that end >= start

extension CommonTestingService on PointListClass {
// class CommonTestingService extends PointListClass {
//   CommonTestingService(super.pointList);

  List<double> subListByType(
    ListType type, {
    int start = 0,
    int end = 0,
  }) {
    // If no start or end parameters are passed then set end to the last element
    if ((start == 0) && (end == 0)) {
      end = pointList.lastIndex;
    }
    //TODO change this to throw an error if start and end aren't right
    start = start.clamp(0, pointList.length - 1);
    end = end.clamp(0, pointList.length - 1);

    // sublist returns start <= elements < end so add 1 to end
    var subList = pointList.sublist(start, end + 1);

    List<double> forceOrTimeList = [];
    for (var i = 0; i < subList.length; i++) {
      switch (type) {
        case ListType.time:
          forceOrTimeList.add(subList[i].$1);
        case ListType.force:
          forceOrTimeList.add(subList[i].$2);
      }
    }
    return forceOrTimeList;
  }

  /// Get the Minimum and Maximum RFD from a list of data points
  /// Looks for the difference between 5 points which is around 100ms
  /// for a sampling rate of 20ms
  //TODO retun null if an edge is not found?
  (int, int) get getEdges =>
      (getEdgeIndex(EdgeType.rising), getEdgeIndex(EdgeType.falling));

  /// Get the first edge index of either a list of rising or falling points
  int getEdgeIndex(EdgeType edgeType) {
    double diff = 0.0;
    double currentEdge = 0.0;
    int index = 0;

    if (edgeList(edgeType).isNotEmpty) {
      (int, int) firstEdge = edgeList(edgeType)[0];
      PointList edge = sublist(firstEdge.$1, firstEdge.$2 + 1);

      for (var i = sampleInterval; i < edge.length - sampleInterval; i++) {
        int j = i - sampleInterval;
        int k = i + sampleInterval;
        diff = edge[k].$2 - edge[j].$2;
        if (_diffCondition(edgeType, diff, currentEdge)) {
          index = i;
          currentEdge = diff;
        }
      }
      index += firstEdge.$1;
    }
    return index;
  }

  bool _diffCondition(edge, diff, currentEdge) {
    return edge == EdgeType.rising ? diff > currentEdge : diff < currentEdge;
  }

  /// Get the Minimum and Maximum RFD from a list of data points
  /// Looks for the difference between 5 points which is around 100ms
  /// for a sampling rate of 20ms
  //TODO retun null if an edge is not found?
  (int, int) get getEdge {
    double diff = 0.0;
    double risingEdge = 0.0;
    double fallingEdge = 0.0;
    int risingIndex = 0;
    int fallingIndex = 0;

    double maxForce = 0.9 * maxStrength.force;

    // Find edges that are greater than the trigger level and less than 90% of the max
    for (var i = sampleInterval; i < pointList.length - sampleInterval; i++) {
      int j = i - sampleInterval;
      int k = i + sampleInterval;
      //Only process points that are greater than the trigger level and less than 90%
      if (isEdgePoint(pointList[j], maxForce) &&
          isEdgePoint(pointList[k], maxForce)) {
        diff = pointList[k].$2 - pointList[j].$2;
        // Detect a rising edge
        if ((diff > risingEdge) &&
            isSequential(subListByType(ListType.force, start: j, end: k),
                Sequence.increment)) {
          risingIndex = i;
          risingEdge = diff;

          // Detect a falling edge

          //TODO change logic so that falling edge detection is carried out only when a rising edge has been found
        } else if ((diff < fallingEdge) &&
            (i > risingIndex) &&
            isSequential(subListByType(ListType.force, start: j, end: k),
                Sequence.decrement)) {
          fallingIndex = i;
          fallingEdge = diff;
        }
      }
    }
    // risingIndex = risingIndex + (sampleInterval - 1) ~/ 2;
    // fallingIndex == 0 ? fallingIndex : fallingIndex + (sampleInterval - 1) ~/ 2;

    return (risingIndex, fallingIndex);
  }

  //An edge point is greater than the trigger level and less than 90% of max
  bool isEdgePoint(Point point, double maxLevel) =>
      // (point.$2 >= 0) && (point.$2 <= maxLevel);
      (point.$2 >= triggerLevel) && (point.$2 <= maxLevel);

  /// Get the data point with a maximum value from a list of data points
  NamedPoint get maxStrength {
    Point max = (0.0, 0.0);
    for (var point in pointList) {
      max = (point.$2 > max.$2) ? point : max;
    }
    return (time: max.$1, force: max.$2);
  }

  //TODO How do I combine the logic for both of these?
  List<(int, int)> edgeList(EdgeType edge) {
    // return a list of the indexes of rising points that have more than 5 sequential points
    var list = <(int, int)>[];
    // const int minLength = sampleInterval * 2 + 1;

    const int minLength = sampleInterval * 2 + 1;
    int currentLength = 1;
    int startIndex = 0;
    int endIndex = 0;

    for (var i = 0; i < pointList.length - 1; i++) {
      // if the points are increasing keep bumping the index up
      if (_edgeCondition(edge, i) &&
          isOnEdge(pointList[i]) &&
          isOnEdge(pointList[i + 1])) {
        endIndex = i + 1;
        currentLength++;
      } else {
        // when the points stop increasing, check if it satisfies the minimum length and save
        // otherwise reset the indexes
        if (startIndex <= endIndex) {
          if (currentLength >= minLength) {
            list.add((startIndex, endIndex));
            // list.add((startIndex, currentLength));
          }
          startIndex = i + 1;
          endIndex = startIndex;
          currentLength = 1;
        }
      }
    }
    return list;
  }

  bool isOnEdge(Point point) {
    double maxForce = 0.9 * maxStrength.force;
    return (triggerLevel <= point.$2) && (point.$2 <= maxForce);
  }

  bool _edgeCondition(edge, i) {
    bool edgeCondition = false;
    switch (edge) {
      case EdgeType.rising:
        edgeCondition = (pointList[i + 1].$2 > pointList[i].$2);
      case EdgeType.falling:
        edgeCondition = (pointList[i + 1].$2 < pointList[i].$2);
    }
    return edgeCondition;
  }
}

bool isSequential(List<double> points, Sequence sequence) {
  bool isSequential = true;
  for (var i = 0; i < points.length - 1; i++) {
    switch (sequence) {
      case Sequence.increment:
        if (points[i + 1] <= points[i]) {
          isSequential = false;
          break;
        }
      case Sequence.decrement:
        if (points[i + 1] >= points[i]) {
          isSequential = false;
          break;
        }
    }
  }
  return isSequential;
}

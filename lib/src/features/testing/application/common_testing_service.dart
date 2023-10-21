import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/features/testing/application/max_testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:statistics/statistics.dart';

extension CommonTestingService on PointList {
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
  //TODO retun null if an edge is not found? or leave at zero?
  (int, int) get getEdge {
    int risingIndex = rfdIndexList(EdgeType.rising).isEmpty
        ? 0
        : rfdIndexList(EdgeType.rising)[0];
    int fallingIndex = rfdIndexList(EdgeType.falling).isEmpty
        ? 0
        : rfdIndexList(EdgeType.falling)[0];
    return (risingIndex, fallingIndex);
  }

  /// Gets the RFDs from either a list of rising or falling points
  List<int> rfdIndexList(EdgeType edgeType) {
    int index = 0;
    List<int> indexList = [];

    if (edgeIndexList(edgeType).isNotEmpty) {
      for (var edge in edgeIndexList(edgeType)) {
        Points edgePoints = sublist(edge.$1, edge.$2 + 1);

        double diff = 0.0;
        double currentEdge = 0.0;
        index = 0;

        for (var i = sampleInterval;
            i < edgePoints.length - sampleInterval;
            i++) {
          int j = i - sampleInterval;
          int k = i + sampleInterval;
          diff = edgePoints[k].$2 - edgePoints[j].$2;
          if (_diffCondition(edgeType, diff, currentEdge)) {
            index = i;
            currentEdge = diff;
          }
        }
        index += edge.$1;
        indexList.add(index);
      }
    }
    return indexList;
  }

  // return a list of the indexes of rising points that have more than 5 sequential points
  // and lie between the trigger Level and 90% of max Strength
  // also discard any lists that have a diff of less than 3kg
  // TODO using 3kg for now but this should probably be increased -
  // I mean what is the minimum force anyone can pull? or perhaps base this on min RFD?
  List<(int, int)> edgeIndexList(EdgeType edge, [int? offset]) {
    var list = <(int, int)>[];

    const int minLength = sampleInterval * 2 + 1;
    int currentLength = 1;
    int startIndex = 0;
    int endIndex = 0;

    offset = offset ?? 0;

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
          if ((currentLength >= minLength) &&
              _minDiffCondition(edge, startIndex, endIndex)) {
            list.add((offset + startIndex, offset + endIndex));
          }
          startIndex = i + 1;
          endIndex = startIndex;
          currentLength = 1;
        }
      }
    }
    return list;
  }

  bool _diffCondition(edge, diff, currentEdge) {
    return edge == EdgeType.rising ? diff > currentEdge : diff < currentEdge;
  }

  // Checks if the point is on a valid edge - between the trigger level and 90% ofmax strength
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

  bool _minDiffCondition(edge, startIndex, endIndex) {
    bool edgeCondition = false;
    switch (edge) {
      case EdgeType.rising:
        edgeCondition =
            (pointList[endIndex].$2 - pointList[startIndex].$2 > triggerLevel);
      case EdgeType.falling:
        edgeCondition =
            (pointList[startIndex].$2 - pointList[endIndex].$2 > triggerLevel);
    }
    return edgeCondition;
  }

  Point toPoint(int index) => pointList[index];

  Points toPointList(List<int> indexList, [int? startIndex]) {
    Points rfdList = [];
    startIndex = startIndex ?? 0;
    for (var index in indexList) {
      rfdList.add(pointList[startIndex + index]);
    }
    return rfdList;
  }
}

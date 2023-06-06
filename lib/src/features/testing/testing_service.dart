import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:statistics/statistics.dart';

/// Calculate the duration between two points
double getDuration(point1, point2) {
  double duration = point2.$1 - point1.$1;
  return duration;
}

/// Get the rising and falling edges from a list of data points
/// The edges should fall on the boundaries of a hang/rest repeater
/// cycle of 7secs:3secs
PointListClass getCftEdges(PointListClass pointList) {
  List<PointListClass> repList = [];

  // Get a list of points that are above the trigger level and within the hangTime
  // and store that list in the repList
  for (var i = 0; i < cftTimes.reps; i++) {
    double startTime = (i * (cftTimes.hangTime + cftTimes.restTime)).toDouble();
    double endTime = startTime + cftTimes.hangTime;
    PointList newList1 = pointList
        .where((element) => pointInTimeRange(element, startTime, endTime))
        .toList();
    // debugPrint(newList.toString());
    var newList2 = PointListClass(newList1);
    repList.add(newList2);
  }

  return getMeans(repList);
}

// A point is in range if it is within the hangTime interval and the force is above the triggerLevel
bool pointInTimeRange(Point point, double startTime, double endTime) {
  return (point.$1 > startTime) &
      (point.$1 < endTime) &
      (point.$2 > triggerLevel);
}

// A point is in range if it is within the hangTime interval and the force is above the triggerLevel
bool pointInForceRange(Point point, double minForce, double maxForce) {
  return (point.$2 > minForce) & (point.$2 < maxForce);
}

/// Get statistics of a clipped range of data that lies between the rising
/// and falling edge

PointListClass getMeans(List<PointListClass> repsList) {
  PointList meansList = [];
  for (var pointList in repsList) {
    List<double> forceList = pointList.subListByType(ListType.force);

    var statistics = forceList.statistics;
    // Calculate the 1 Sigma mean by deleting those values from the list.
    double minForce = statistics.mean - statistics.standardDeviation;
    double maxForce = statistics.mean + statistics.standardDeviation;

    // List<double> sigmaList = [];
    //TODO tidy this up
    PointList sigmaList = pointList
        .where((element) => pointInForceRange(element, minForce, maxForce))
        .toList();

    var newList = PointListClass(sigmaList);
    double meanForce = newList.subListByType(ListType.force).mean;
    double meanTime = newList.subListByType(ListType.time).mean;
    meansList.add((meanTime, meanForce));
  }
  var newList = PointListClass(meansList);

  return newList;
}

/// Calculate the average mean from the last set of means

double criticalLoad(PointListClass meansList) {
  int listLength = meansList.length;
  double criticalLoad = meansList
      .subListByType(ListType.force, start: listLength - 5, end: listLength - 1)
      .mean;
  return criticalLoad;
}

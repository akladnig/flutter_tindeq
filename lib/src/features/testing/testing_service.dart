import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results_provider.dart';
import 'package:statistics/statistics.dart';

/// Calculate the duration between two points
double getDuration(point1, point2) {
  double duration = point2.$1 - point1.$1;
  return duration;
}

double calcWPrime(PointListClass pointList, double criticalForce) {
  double wPrime = 0.0;
  List<double> forceList = pointList.subListByType(ListType.force);
  List<double> timeList = pointList.subListByType(ListType.time);
  var durationSum = 0.0;
  for (var i = 0; i < timeList.length - 2; i++) {
    var duration = (timeList[i + 1] - timeList[i]);
    durationSum += duration;
  }
  var timeAvg = durationSum / timeList.length;
  debugPrint("timeAvg $timeAvg");
  List<double> wPrimeList =
      forceList.where((force) => force > criticalForce).toList();
  debugPrint("${wPrimeList.length}");

  wPrime = wPrimeList.reduce((value, point) => value + point - criticalForce) *
      timeAvg;

  return wPrime;
}

/// Calculate the mean force and time of each hang based on the
/// rising and falling edges of a list of data points.
/// The edges should fall on the boundaries of a hang/rest repeater
/// cycle of 7secs:3secs
PointListClass cftMeansList(PointListClass pointList) {
  List<PointListClass> repList = [];

  // Get a list of points that are above the trigger level and within 0.5sec on
  //either side of the hangTime and store that list in the repList
  double errorTime = 0.5;
  //TODO tidy names
  for (var i = 0; i < cftTimes.reps; i++) {
    double startTime =
        (i * (cftTimes.hangTime + cftTimes.restTime) - errorTime).toDouble();
    double endTime = startTime + cftTimes.hangTime + 2 * errorTime;
    PointList newList1 = pointList
        .where((point) => isPointInTimeRange(point, startTime, endTime))
        .toList();
    debugPrint('$startTime $endTime');
    var newList2 = PointListClass(newList1);
    repList.add(newList2);
  }

  return calculateMeans(repList);
}

/// Get statistics of a clipped range of data that lies between the rising
/// and falling edge

PointListClass calculateMeans(List<PointListClass> repsList) {
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
        .where((point) => isPointInForceRange(point, minForce, maxForce))
        .toList();

    var newList = PointListClass(sigmaList);
    double meanForce = newList.subListByType(ListType.force).mean;
    double meanTime = newList.subListByType(ListType.time).mean;
    meansList.add((meanTime, meanForce));
  }
  var newList = PointListClass(meansList);

  return newList;
}

/// Calculate the average mean from the last 60secs of means

double criticalForce(PointListClass meansList) {
  int listLength = meansList.length;
  double criticalForce = meansList
      .subListByType(ListType.force, start: listLength - 6, end: listLength - 1)
      .mean;
  return criticalForce;
}

CftResult get cftResult {
  PointListClass meansList = cftMeansList(pointListCft);
  double asymptoticForce = criticalForce(meansList);
  double factor = cftHangTime / (cftHangTime + cftRestTime);
  double wPrime = calcWPrime(pointListCft, asymptoticForce);

  return (
    criticalForce: asymptoticForce,
    // criticalForce: asymptoticForce * factor,
    asymptoticForce: asymptoticForce,
    peakForce: meansList[0].$2,
    cftPoints: meansList,
    wPrime: wPrime,
    anaerobicFunction: 0
  );
}

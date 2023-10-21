import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/application/common_testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results_provider.dart';
import 'package:statistics/statistics.dart';

extension CftTesting on PointList {
  CftResult get cftResult {
    // PointListClass meansList = _cftMeansList(pointListCft);
    PointList meansList = _cftMeanList(_cftHangList);
    double asymptoticForce = meansList._criticalForce;
    double factor = cftHangTime / (cftHangTime + cftRestTime);
    double wPrime = _calcWPrime(asymptoticForce);
    double anaerobicFunction = (wPrime > 0) ? wPrime / asymptoticForce : 0;

    debugPrint('cftResult: ${pointListCft._cftHangList.toString()}');
    debugPrint(
        'cftResult: ${pointListCft._cftMaxList(pointListCft._cftHangList).toString()}');
    debugPrint(
        'cftMean: ${pointListCft._cftMeanList(pointListCft._cftHangList).toString()}');
    return (
      criticalForce: asymptoticForce,
      // criticalForce: asymptoticForce * factor,
      asymptoticForce: asymptoticForce,
      peakForce: meansList[0].$2,
      cftPoints: meansList,
      wPrime: wPrime,
      anaerobicFunction: anaerobicFunction,
    );
  }

  double _calcWPrime(double criticalForce) {
    double wPrime = 0.0;
    List<double> forceList = subListByType(ListType.force);
    List<double> timeList = subListByType(ListType.time);

    var durationSum = 0.0;
    for (var i = 0; i < timeList.length - 2; i++) {
      durationSum += (timeList[i + 1] - timeList[i]);
    }
    var timeAvg = durationSum / timeList.length;

    List<double> wPrimeList =
        forceList.where((force) => force > criticalForce).toList();

    wPrime =
        wPrimeList.reduce((value, point) => value + point - criticalForce) *
            timeAvg;

    return wPrime;
  }

  List<int> _cftMaxList(List<(int, int)> hangList) {
    List<int> maxList = [];
    double max = 0.0;
    int maxPoint = 0;

    for (var subList in hangList) {
      max = 0.0;
      for (var i = subList.$1; i < subList.$2; i++) {
        if (pointList[i].$2 > max) {
          max = pointList[i].$2;
          maxPoint = i;
        }
      }
      maxList.add(maxPoint);
    }
    return maxList;
  }

  PointList _cftMeanList(List<(int, int)> hangList) {
    Points meanList = [];

    for (var subList in hangList) {
      var forceList = PointList(pointList.sublist(subList.$1, subList.$2));
      List<double> fl2 = forceList.subListByType(ListType.force);

      var statistics = fl2.statistics;
      // Calculate the 1 Sigma mean by deleting those values from the list.
      // double minForce = statistics.mean - statistics.standardDeviation;
      double minForce = statistics.mean;
      // double maxForce = statistics.mean + statistics.standardDeviation;
      double maxForce = statistics.max;

      Points sigmaList = pointList
          .where((point) => isPointInForceRange(point, minForce, maxForce))
          .toList();

      var newList = PointList(sigmaList);
      double meanForce = newList.subListByType(ListType.force).mean;
      double meanTime = forceList.subListByType(ListType.time).mean;
      meanList.add((meanTime, meanForce));
    }
    return PointList(meanList);
  }

  /// Gets the hang periods which are points that are above the trigger level.
  /// This is further narrowed down by getting the first rising and last falling edge.
  /// The edges should fall on the boundaries of a hang/rest repeater
  /// cycle of 7secs:3secs
  List<(int, int)> get _cftHangList {
    List<(int, int)> hangListIndex = [];

    int hangStart = 0;
    int hangEnd = 0;

    debugPrint('pointListCft length: ${pointList.length}');
    for (var i = 0; i < pointList.length; i++) {
      if (pointList[i].$2 <= triggerLevel) {
        if (hangStart < hangEnd) {
          hangListIndex.add((hangStart, hangEnd));
        }
        hangStart = i;
        hangEnd = hangStart;
      } else {
        // (pointList[i].$2 > triggerLevel)
        hangEnd = i;
      }
    }
    return hangListIndex;
  }

  /// Calculate the mean force and time of each hang based on the
  /// rising and falling edges of a list of data points.
  /// The edges should fall on the boundaries of a hang/rest repeater
  /// cycle of 7secs:3secs
  PointList _cftMeansList(PointList pointList) {
    List<PointList> repList = [];

    // Get a list of points that are above the trigger level and within 0.5sec on
    //either side of the hangTime and store that list in the repList
    double errorTime = 0.5;
    //TODO tidy names
    for (var i = 0; i < cftTimes.reps; i++) {
      double startTime =
          (i * (cftTimes.hangTime + cftTimes.restTime) - errorTime);
      double endTime = startTime + cftTimes.hangTime + 2 * errorTime;
      Points newList1 = pointList
          .where((point) => isPointInTimeRange(point, startTime, endTime))
          .toList();
      debugPrint('$startTime $endTime');
      var newList2 = PointList(newList1);
      repList.add(newList2);
    }

    return _calculateMeans(repList);
  }

  /// Get statistics of a clipped range of data that lies between the rising
  /// and falling edge

  PointList _calculateMeans(List<PointList> repsList) {
    Points meansList = [];
    for (var pointList in repsList) {
      List<double> forceList = subListByType(ListType.force);

      var statistics = forceList.statistics;
      // Calculate the 1 Sigma mean by deleting those values from the list.
      double minForce = statistics.mean - statistics.standardDeviation;
      double maxForce = statistics.mean + statistics.standardDeviation;

      // List<double> sigmaList = [];
      //TODO tidy this up
      Points sigmaList = pointList
          .where((point) => isPointInForceRange(point, minForce, maxForce))
          .toList();

      var newList = PointList(sigmaList);
      double meanForce = newList.subListByType(ListType.force).mean;
      double meanTime = newList.subListByType(ListType.time).mean;
      meansList.add((meanTime, meanForce));
    }
    var newList = PointList(meansList);

    return newList;
  }

  /// Calculate the average mean from the last 60secs of means

  double get _criticalForce {
    int listLength = pointList.length;
    double criticalForce = subListByType(ListType.force,
            start: listLength - 6, end: listLength - 1)
        .mean;
    return criticalForce;
  }

  // A point is in range if it is within the hangTime interval and the force is above the triggerLevel
  bool isPointInTimeRange(Point point, double startTime, double endTime) {
    return (point.$1 > startTime) &&
        (point.$1 < endTime) &&
        (point.$2 > triggerLevel);
  }

  // A point is in range if it is within the min and max force
  bool isPointInForceRange(Point point, double minForce, double maxForce) {
    return (minForce < point.$2) && (point.$2 < maxForce);
  }
}

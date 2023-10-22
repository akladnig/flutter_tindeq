import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/application/common_testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results_provider.dart';
import 'package:statistics/statistics.dart';

extension CftTesting on PointList {
  CftResult get cftResult {
    // PointListClass meansList = _cftMeansList(pointListCft);
    PointList meansList = cftMeanList;
    double asymptoticForce = meansList._criticalForce;
    double factor = cftHangTime / (cftHangTime + cftRestTime);
    double wPrime = _calcWPrime(asymptoticForce);
    double anaerobicFunction = (wPrime > 0) ? wPrime / asymptoticForce : 0;

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

  // Finds the maximum point of each hang period
  List<int> get cftMaxList {
    List<int> maxList = [];
    double max = 0.0;
    int maxPoint = 0;

    for (var subList in cftHangList) {
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

  PointList get cftMeanList {
    Points meanList = [];

    for (var subList in cftHangList) {
      var forceList = PointList(pointList.sublist(subList.$1, subList.$2));
      List<double> fl2 = forceList.subListByType(ListType.force);

      var statistics = fl2.statistics;
      // Calculate the 1 Sigma mean by deleting those values from the list.
      double minForce = statistics.mean - statistics.standardDeviation;
      // double minForce = statistics.mean;
      double maxForce = statistics.mean + statistics.standardDeviation;
      // double maxForce = statistics.max;

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
  List<(int, int)> get cftHangList {
    List<(int, int)> hangListIndex = [];

    int hangStartIndex = 0;
    int hangEndIndex = 0;

    List<int> rfdStart = rfdIndexList(EdgeType.rising);
    int rfdStartIndex = 0;
    List<int> rfdEnd = rfdIndexList(EdgeType.falling);
    int rfdEndIndex = 0;

    for (var i = 0; i < pointList.length; i++) {
      // The hang period ends when the force drops below the triggerLevel and there's a difference
      // between the start and end of the hang indexes. Otherwise if the start and end indexes are
      // equal it means we are in the rest period
      if (pointList[i].$2 <= triggerLevel) {
        if (hangStartIndex < hangEndIndex) {
          // Narrow range down to the rfd edges
          while ((rfdStart[rfdStartIndex] < hangStartIndex) &&
              (rfdStartIndex < rfdStart.length - 1)) {
            rfdStartIndex++;
          }
          while ((rfdEnd[rfdEndIndex] < hangEndIndex) &&
              (rfdEndIndex < rfdEnd.length - 1)) {
            rfdEndIndex++;
          }
          rfdEndIndex--;

          // Handle the edge case for the very last EndIndex
          if (rfdEnd[rfdEnd.length - 1] < hangEndIndex) {
            rfdEndIndex = rfdEnd.length - 1;
          }

          hangListIndex.add((rfdStart[rfdStartIndex], rfdEnd[rfdEndIndex]));
        }
        hangStartIndex = i;
        hangEndIndex = hangStartIndex;
      } else {
        // The force(pointList[i].$2) > triggerLevel so keep bumping the hangEndIndex
        hangEndIndex = i;
      }
    }
    return hangListIndex;
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

import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/application/common_testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results_provider.dart';
import 'package:statistics/statistics.dart';

extension CftTesting on PointList {
  CftResult get cftResult {
    // PointListClass meansList = _cftMeansList(pointListCft);
    PointList meansList = cftMeanList;
    double asymptoticForce = meansList.criticalForce;
    double factor = cftHangTime / (cftHangTime + cftRestTime);
    double wPrime = _calcWPrime(asymptoticForce);
    double anaerobicFunction = (wPrime > 0) ? wPrime / asymptoticForce : 0;

    return (
      criticalForce: asymptoticForce,
      // criticalForce: asymptoticForce * factor,
      asymptoticForce: asymptoticForce,
      peakForce: meansList[0].$2,
      cftPoints: meansList,
      wPrime: 0,
      // wPrime: wPrime,
      anaerobicFunction: 0,
      // anaerobicFunction: anaerobicFunction,
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
      var list = PointList(pointList.sublist(subList.$1, subList.$2));
      List<double> forceList = list.subListByType(ListType.force);

      var statistics = forceList.statistics;
      // Calculate the 1 Sigma mean by deleting those values from the list.
      double minForce = statistics.mean - statistics.standardDeviation;
      double maxForce = statistics.mean + statistics.standardDeviation;

      List<double> sigmaList = forceList
          .where((force) => (minForce < force) && (force < maxForce))
          .toList();

      double meanForce = sigmaList.mean;
      double meanTime = list.subListByType(ListType.time).mean;
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

    int edgeStartIndex = 0;
    int edgeEndIndex = 0;

    for (var i = 0; i < pointList.length; i++) {
      // The hang period ends when the force drops below the triggerLevel and there's a difference
      // between the start and end of the hang indexes. Otherwise if the start and end indexes are
      // equal it means we are in the rest period
      if (pointList[i].$2 <= triggerLevel) {
        if (hangStartIndex < hangEndIndex) {
          // Narrow range down to the top of the rising and falling edge
          var j = hangStartIndex;
          while (pointList[j + 1].$2 > pointList[j].$2) {
            j++;
          }
          edgeStartIndex = j;

          j = hangEndIndex - 1;
          while (pointList[j - 1].$2 > pointList[j].$2) {
            j--;
          }
          edgeEndIndex = j;
          hangListIndex.add((edgeStartIndex, edgeEndIndex));
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

  double get criticalForce {
    int listLength = pointList.length;
    double criticalForce = subListByType(ListType.force,
            start: listLength - 6, end: listLength - 1)
        .mean;
    return criticalForce;
  }
}

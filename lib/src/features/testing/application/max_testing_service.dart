import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/application/common_testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results_provider.dart';
import 'package:statistics/statistics.dart';

class MaxTesting extends PointListClass {
// class MaxTesting extends CommonTestingService {
  MaxTesting(super.pointList);

  MaxResult get maxResult {
    return (
      maxStrength: maxStrength.force,
      meanStrength: _mean.force,
      meanLine: _meanLine
    );
  }

  // Get the mean of the maximum part of the data - which is clipped to one sigma
  NamedPoint get _mean {
    var (risingIndex, fallingIndex) = getEdge;

    List<double> forceList =
        subListByType(ListType.force, start: risingIndex, end: fallingIndex);

    var statistics = forceList.statistics;
    // Calculate the 1 Sigma mean of the forceList
    double minForce = statistics.mean - statistics.standardDeviation;
    double maxForce = statistics.mean + statistics.standardDeviation;

    // Create a sigmaList by filtering points outside of 1 sigma
    List<double> sigmaList = [];
    sigmaList = forceList
        .where((point) => minForce <= point && point <= maxForce)
        .toList();

    var sigmaStatistics = sigmaList.statistics;

    double meanTime = forceList[risingIndex + sigmaStatistics.medianHighIndex];
    return ((force: sigmaStatistics.mean, time: meanTime));
  }

  /// Create a line that runs through the mean and bounded by the rising and falling edges
  Line get _meanLine {
    var (risingIndex, fallingIndex) = getEdge;

    Point minPoint = (pointList[risingIndex].$1, _mean.force);
    Point maxPoint = (pointList[fallingIndex].$1, _mean.force);
    Line line = (minPoint, maxPoint);
    return line;
  }
}

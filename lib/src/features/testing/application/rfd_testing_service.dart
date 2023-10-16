import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/features/testing/application/common_testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results_provider.dart';

class RfdTesting extends PointListClass {
  RfdTesting(super.pointList);

  /// Get the Maximum RFD from the rising edge of a list of data points
  double get _rfdPeak {
    int risingIndex = 0;
//TODO change this back to pointList.getEdge - extend class or create extension methods?
    (risingIndex, _) = getEdge;
    Point rfdRisingPointStart = pointList[risingIndex - sampleInterval];
    Point rfdRisingPointEnd = pointList[risingIndex + sampleInterval];
    double rfdPeak = (rfdRisingPointEnd.$2 - rfdRisingPointStart.$2) /
        (rfdRisingPointEnd.$1 - rfdRisingPointStart.$1);
    return rfdPeak;
  }

  /// Get the point at which the _rfdPeak occurs

  Point get _rfdPeakPoint => pointList[getEdge.$1];

  /// Create a line that runs from 10% to 90% of the max and running through the
  /// Rfd Max point
  Line get _rfdLine {
    int risingIndex = 0;

    (risingIndex, _) = getEdge;
    var maxValue = maxStrength;
    Point maxRfdPoint1 = pointList[risingIndex];
    Point maxRfdPoint2 = pointList[risingIndex + 1];
    var maxLineParameters = lineParameters(maxRfdPoint1, maxRfdPoint2);
    // Get the 10% x value from x = (y - b)/a
    var xMin =
        (maxValue.force * 0.1 - maxLineParameters.$2) / maxLineParameters.$1;
    var minPoint = (xMin, maxValue.force * 0.1);
    // Get the 90% x value from x = (y - b)/a
    var xMax =
        (maxValue.force * 0.9 - maxLineParameters.$2) / maxLineParameters.$1;
    var maxPoint = (xMax, maxValue.force * 0.9);
    Line line = (minPoint, maxPoint);
    return line;
  }

  /// Calculates the average RFD based on a line that runs through
  /// the 20% and 80% of maxStrength value
  double get _rfdAverage {
    Point maxValue = (maxStrength.time, maxStrength.force);

    Point max20 =
        pointList.firstWhere((point) => point.$2 >= maxValue.$2 * 0.2);
    Point max80 =
        pointList.firstWhere((point) => point.$2 >= maxValue.$2 * 0.8);

    double average = (max80.$2 - max20.$2) / (max80.$1 - max20.$1);

    return average;
  }

  RfdResult get rfdResult {
    return (
      peak: _rfdPeak,
      peakPoint: _rfdPeakPoint,
      peakLine: _rfdLine,
      mean: _rfdAverage,
      //TODO timeToPeak
      timeToPeak: 0.0,
    );
  }
}

/// Calculate the parameters [a, b] of a line running through two points
/// using y = ax + b
/// so: a = (y2 - y1)/(x2-x1)
///     b = y2 - ax2

(double, double) lineParameters(point1, point2) {
  double a = (point2.$2 - point1.$2) / (point2.$1 - point1.$1);
  double b = point2.$2 - a * point2.$1;
  return (a, b);
}

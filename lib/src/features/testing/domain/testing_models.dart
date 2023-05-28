import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:statistics/statistics.dart';

typedef Point = (double, double);
typedef NamedPoint = ({double force, double time});
typedef PointList = List<Point>;

/// A line drawn from point to point
typedef Line = (Point, Point);

typedef Legend = ({String title, Color colour});

enum ListType { time, force }

enum Hand {
  left('Left'),
  right('Right');

  const Hand(this.label);
  final String label;
}

class PointListClass extends ListBase<Point> {
  final List<Point> pointList;
  PointListClass(this.pointList);

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

// Returns a sub list of List<double> of either force or time between the start and end values.
  List<double> subListByType(
    ListType type, {
    int start = 0,
    int end = 0,
  }) {
    if ((start == 0) & (end == 0)) {
      end = pointList.lastIndex;
    }
    // Do some out of bounds error checking
    // TODO is this right?
    start = (start < 0) ? 0 : start;
    start = (start > length - 1) ? length - 1 : start;
    end = (end < 0) ? 0 : end;
    end = (end > length - 1) ? length - 1 : end;

    var dataList = pointList.sublist(start, end);
    List<double> forceList = [];
    for (var i = 0; i < dataList.length; i++) {
      if (type == ListType.time) {
        forceList.add(dataList[i].$1);
      } else if (type == ListType.force) {
        forceList.add(dataList[i].$2);
      }
    }
    return forceList;
  }

  /// Get the Minimum and Maximum RFD from a list of data points
  /// Looks for the difference between 5 points which is around 100ms
  /// for a sampling rate of 20ms
  (int, int) get getEdge {
    int sampleInterval = 5;
    double diff = 0.0;
    double risingEdge = 0.0;
    double fallingEdge = 0.0;
    int risingIndex = 0;
    int fallingIndex = 0;

    for (var i = 0; i < pointList.length - sampleInterval; i++) {
      diff = pointList[i + sampleInterval].$2 - pointList[i].$2;
      // Detect a rising edge
      if (diff > risingEdge) {
        risingIndex = i;
        risingEdge = diff;

        // Detect a falling edge
      } else if ((diff < fallingEdge) && (i > risingIndex)) {
        fallingIndex = i;
        fallingEdge = diff;
      }
    }
    risingIndex = risingIndex + ((sampleInterval - 1) ~/ 2);
    return (risingIndex, fallingIndex);
  }

  /// Get the maximum value from a list of data points
  NamedPoint get maxForce {
    Point max = (0.0, 0.0);
    for (var point in pointList) {
      max = (point.$2 > max.$2) ? point : max;
    }
    return (time: max.$1, force: max.$2);
  }

  // Get the mean of the maximum part of the data - which is clipped to one sigma
  NamedPoint get mean {
    var (risingIndex, fallingIndex) = getEdge;

    List<double> forceList =
        subListByType(ListType.force, start: risingIndex, end: fallingIndex);
    var statistics = forceList.statistics;
    // Calculate the 1 Sigma mean by deleting those values from the list.
    double minForce = statistics.mean - statistics.standardDeviation;
    double maxForce = statistics.mean + statistics.standardDeviation;

    List<double> sigmaList = [];
    for (var i = 0; i < pointList.length - 1; i++) {
      if ((pointList[i].$2 > minForce) && (pointList[i].$2 < maxForce)) {
        sigmaList.add(pointList[i].$2);
      }
    }
    var sigmaStatistics = sigmaList.statistics;

    double meanTime =
        pointList[risingIndex + sigmaStatistics.medianHighIndex].$1;
    return ((force: sigmaStatistics.mean, time: meanTime));
  }

  /// Create a line that runs through the mean and between the rising and falling edges
  Line get meanLine {
    var (risingIndex, fallingIndex) = getEdge;

    var minPoint = (pointList[risingIndex].$1, mean.force);
    var maxPoint = (pointList[fallingIndex].$1, mean.force);
    Line line = (minPoint, maxPoint);
    return line;
  }

  /// Get the Minimum and Maximum RFD from a list of data points

  (double, Point, Point) get rfdMinMax {
    int risingIndex = 0;

    (risingIndex, _) = getEdge;
    Point rfdRisingPointStart = pointList[risingIndex];
    Point rfdRisingPointEnd = pointList[risingIndex + 1];
    double rfdMax = (rfdRisingPointEnd.$2 - rfdRisingPointStart.$2) /
        (pointList[risingIndex + 1].$1 - rfdRisingPointStart.$1);
    return (rfdMax, rfdRisingPointStart, rfdRisingPointEnd);
  }

  /// Create a line that runs from 10% to 90% of the max and running through the
  /// Rfd Max point
  Line get rfdLine {
    var maxValue = maxForce;
    var (_, maxRfdPoint1, maxRfdPoint2) = rfdMinMax;
    var maxLineParameters = lineParameters(maxRfdPoint1, maxRfdPoint2);
    // Get the 10% x value from x = (y - b)/a
    var xMin =
        (maxValue.force * 0.1 - maxLineParameters.$2) / maxLineParameters.$1;
    var minPoint = (xMin, maxValue.force * 0.1);
    // Get the 80% x value from x = (y - b)/a
    var xMax =
        (maxValue.force * 0.8 - maxLineParameters.$2) / maxLineParameters.$1;
    var maxPoint = (xMax, maxValue.force * 0.8);
    Line line = (minPoint, maxPoint);
    return line;
  }

  /// Calculate the parameters [a, b] of a line running through two points
  /// using y = ax + b
  /// so: a = (y2 - y1)/(x2-x1)
  ///     b = y2 - ax2

  (double, double) lineParameters(point1, point2) {
    double a = (point2.$2 - point1.$2) / (point2.$1 - point1.$1);
    double b = point2.$2 - a * point2.$1;
    (double, double) lineParameters = (a, b);
    return lineParameters;
  }

  PointList toFixed() {
    PointList fixedList = [];
    for (var point in pointList) {
      Point fixedPoint = (point.$1, ((point.$2) * 10).round() / 10);
      fixedList.add(fixedPoint);
    }
    return (fixedList);
  }
}

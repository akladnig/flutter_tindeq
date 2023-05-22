import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/features/testing/testing_models.dart';
import 'package:statistics/statistics.dart';

/// Get statistics of a clipped range of data that lies between the rising
/// and falling edge

(Point, double) getStatistics(PointList pointList) {
  var (minIndex, maxIndex) = getEdge(pointList);
  debugPrint("Indexes: $minIndex, $maxIndex");

  List<double> forceList = sliceList(pointList, maxIndex, minIndex);

  var statistics = forceList.statistics;
  // Calculate the 1 Sigma mean by deleting those values from the list.
  double minForce = statistics.mean - statistics.standardDeviation;
  double maxForce = statistics.mean + statistics.standardDeviation;

  List<double> sigmaList = [];
  List<double> timeList = [];
  //TODO tidy this up
  for (var i = 0; i < pointList.lastIndex; i++) {
    if ((pointList[i].$2 > minForce) && (pointList[i].$2 < maxForce)) {
      sigmaList.add(pointList[i].$2);
      timeList.add(pointList[i].$1);
    }
  }
  var sigmaStatistics = sigmaList.statistics;

  double meanTime = pointList[maxIndex + sigmaStatistics.medianHighIndex].$1;
  return ((meanTime, sigmaStatistics.mean), timeList[0]);
}

sliceList(pointList, start, end) {
  var dataList = pointList.sublist(start, end);
  List<double> forceList = [];
  for (var i = 0; i < dataList.length; i++) {
    forceList.add(dataList[i].$2);
  }
  return forceList;
}

/// Get the maximum value from a list of data points
Point maxKg(PointList pointList) {
  Point max = (0.0, 0.0);
  for (var point in pointList) {
    max = (point.$2 > max.$2) ? point : max;
    // if (point.$2 > max.$2) {
    //   max = point;
    // }
  }
  return max;
}

/// Get the mean value from a list of data points based on the means of values
/// between the detected min and max RFD
Point meanKg(PointList pointList) {
  var (mean, _) = getStatistics(pointList);
  return mean;
}

/// Create a line that runs from 10% to 90% of the max and running through the
/// Rfd Max point
Line meanLine(PointList pointList) {
  var (minIndex, maxIndex) = getEdge(pointList);

  var (meanValue, time) = getStatistics(pointList);
  var minPoint = (time, meanValue.$2);
  var maxPoint = (pointList[minIndex].$1, meanValue.$2);
  Line line = (minPoint, maxPoint);
  return line;
}

/// Calculate the force difference between two points
double forceDiff(point1, point2) {
  double diff = point2.$2 - point1.$2;
  return diff;
}

/// Calculate the fduration between two points
double getDuration(point1, point2) {
  double duration = point2.$1 - point1.$1;
  return duration;
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

/// Get the Minimum and Maximum RFD from a list of data points

(double, Point, Point, Point) rfdMinMax(PointList pointList) {
  Point rfdMaxPoint1 = (0.0, 0.0);
  Point rfdMinPoint = (0.0, 0.0);
  int maxIndex = 0;
  int minIndex = 0;

  (minIndex, maxIndex) = getEdge(pointList);
  rfdMaxPoint1 = pointList[maxIndex];
  rfdMinPoint = pointList[minIndex];
  double duration = getDuration(rfdMaxPoint1, rfdMinPoint);
  Point rfdMaxPoint2 = pointList[maxIndex + 1];
  double rfdMax = (rfdMaxPoint2.$2 - rfdMaxPoint1.$2) /
      (pointList[maxIndex + 1].$1 - rfdMaxPoint1.$1);
  return (rfdMax, rfdMinPoint, rfdMaxPoint1, rfdMaxPoint2);
}

/// Get the Minimum and Maximum RFD from a list of data points
/// Looks for the difference between 5 points which is around 100ms
/// for a sampling rate of 20ms
(int, int) getEdge(PointList pointList) {
  int sampleInterval = 5;
  double diff = 0.0;
  double risingEdge = 0.0;
  double fallingEdge = 0.0;
  int maxIndex = 0;
  int minIndex = 0;

  for (var i = 0; i < pointList.length - sampleInterval; i++) {
    diff = forceDiff(pointList[i], pointList[i + sampleInterval]);
    // Detect a rising edge
    if (diff > risingEdge) {
      maxIndex = i;
      risingEdge = diff;

      // Detect a falling edge
    } else if ((diff < fallingEdge) && (i > maxIndex)) {
      minIndex = i;
      fallingEdge = diff;
    }
  }
  maxIndex = maxIndex + ((sampleInterval - 1) ~/ 2);
  return (minIndex, maxIndex);
}

/// Get the rising and falling edges from a list of data points
/// The edges should fall on the boundaries of a hang/rest repeater
/// cycle of 7secs:3secs
(int, int) getCftEdges(PointList pointList) {
  double diff = 0.0;
  double risingEdge = 0.0;
  double fallingEdge = 0.0;
  int maxIndex = 0;
  int minIndex = 0;
  int hang = 7;
  int rest = 3;

  // List of (risingEdge, fallingEdge)
  List<(int, int)> edges = [];
  for (var i = 0; i < pointList.length - 1; i++) {
    diff = forceDiff(pointList[i], pointList[i + 1]);
    //TODO include some hysterisis

    // Detect a rising edge
    if (diff > risingEdge) {
      maxIndex = i;
      risingEdge = diff;
      // Detect a falling edge
    } else if ((diff < fallingEdge) && (i > maxIndex)) {
      minIndex = i;
      fallingEdge = diff;
    }
    edges.add((maxIndex, minIndex));
  }
  return (minIndex, maxIndex);
}

/// Create a line that runs from 10% to 90% of the max and running through the
/// Rfd Max point
Line rfdLine(PointList pointList) {
  var maxValue = maxKg(pointList);
  var (_, _, maxRfdPoint1, maxRfdPoint2) = rfdMinMax(pointList);
  var maxLineParameters = lineParameters(maxRfdPoint1, maxRfdPoint2);
  // Get the 10% x value from x = (y - b)/a
  var xMin = (maxValue.$2 * 0.1 - maxLineParameters.$2) / maxLineParameters.$1;
  var minPoint = (xMin, maxValue.$2 * 0.1);
  // Get the 80% x value from x = (y - b)/a
  var xMax = (maxValue.$2 * 0.8 - maxLineParameters.$2) / maxLineParameters.$1;
  var maxPoint = (xMax, maxValue.$2 * 0.8);
  Line line = (minPoint, maxPoint);
  return line;
}

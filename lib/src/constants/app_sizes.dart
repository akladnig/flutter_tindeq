import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/features/analysis/presentation/grade_gauge.dart';

/// Constant sizes to be used in the app (paddings, gaps, rounded corners etc.)
/// Based on a consistent Ratio of 1.25
///             14      16      20
/// xxsmall     14      16      10.2
/// xsmall      9.0     10.2    12.8
/// small       11.2    12.8    16.0
/// medium      14.0    16.0    20.0
/// large       17.5    20.0    25.0
/// xLarge      21.9    25.0    31.3
/// 2xl         27.3    31.3    39.1
/// 3xl         34.2    39.1    48.8
/// 4xl         42.7    48.8    61.0
class Sizes {
  static const baseFontSize = 20.0;
  static const sizeRatio = 1.25;

  static const double none = 0.0;
  static const double xxSmall = xSmall / sizeRatio;
  static const double xSmall = small / sizeRatio;
  static const double small = medium / sizeRatio;
  static const double medium = baseFontSize;
  static const double large = medium * sizeRatio;
  static const double xLarge = large * sizeRatio;
  static const double x2Large = xLarge * sizeRatio;
  static const double x3Large = x2Large * sizeRatio;
  static const double x4Large = x3Large * sizeRatio;
}

/// Constant gap widths
const gapWXS = SizedBox(width: Sizes.xSmall);
const gapWSML = SizedBox(width: Sizes.small);
const gapWMED = SizedBox(width: Sizes.medium);
const gapWLGE = SizedBox(width: Sizes.large);
const gapWXLG = SizedBox(width: Sizes.xLarge);

/// Constant gap heights
const gapHXS = SizedBox(height: Sizes.xSmall);
const gapHSML = SizedBox(height: Sizes.small);
const gapHMED = SizedBox(height: Sizes.medium);
const gapHLGE = SizedBox(height: Sizes.large);
const gapHXLG = SizedBox(height: Sizes.xLarge);

// Results constans
const resultsViewWidth = 250.0;
// Test View constants
const testResultsHeight = plotHeight;

/// Chart constants
const plotWidth = 800.0;
const plotHeight = 400.0;

// Gauge constants

const double weightGaugeSizeWidth = 1024;
double gradeGaugeSizeWidth =
    gradeRectWidth * (Grade.elite.endGrade - Grade.beginner.startGrade + 1) +
        mainBarHeight;

const double circleRadius = Sizes.medium;
const double legendOffset = Sizes.xxSmall;
const double tickOffset = Sizes.xxSmall;
const double labelOffset = Sizes.medium;

const double mainBarHeight = Sizes.x4Large;
const double rangeBarHeight = Sizes.x3Large;

const double weightBarHeight = Sizes.x4Large;
const double weightBarWidth = Sizes.x4Large * 10;

const double gradeRectWidth = Sizes.large;

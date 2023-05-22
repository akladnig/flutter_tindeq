import 'package:flutter/material.dart';

/// Constant sizes to be used in the app (paddings, gaps, rounded corners etc.)
/// Based on a consistent Ratio of 1.25
///             14      16      20
/// xsmall      9.0     10.2    25
/// small       11.2    12.8    31.3
/// medium      14.0    16.0    39.1
/// large       17.5    20.0    49.
/// extraLarge  21.9    25.0    61.3
/// 2xl         27.3    31.3    76.6
/// 3xl         34.2    39.1    95.7
/// 4xl         42.7    48.8    119.68
class Sizes {
  static const baseFontSize = 20.0;
  static const sizeRatio = 1.25;

  static const double xxSmall = xSmall / sizeRatio;
  static const double xSmall = small / sizeRatio;
  static const double small = medium / sizeRatio;
  static const double medium = baseFontSize;
  static const double large = medium * sizeRatio;
  static const double extraLarge = large * sizeRatio;
  static const double xxLarge = extraLarge * sizeRatio;
  static const double xxxLarge = xxLarge * sizeRatio;
  static const double xxxxLarge = xxxLarge * sizeRatio;
}

/// Constant gap widths
const gapWXS = SizedBox(width: Sizes.xSmall);
const gapWSML = SizedBox(width: Sizes.small);
const gapWMED = SizedBox(width: Sizes.medium);
const gapWLGE = SizedBox(width: Sizes.large);
const gapWXLG = SizedBox(width: Sizes.extraLarge);

/// Constant gap heights
const gapHXS = SizedBox(height: Sizes.xSmall);
const gapHSML = SizedBox(height: Sizes.small);
const gapHMED = SizedBox(height: Sizes.medium);
const gapHLGE = SizedBox(height: Sizes.large);
const gapHXLG = SizedBox(height: Sizes.extraLarge);

/// Chart constants
class Chart {
  static const plotWidth = 800.0;
}

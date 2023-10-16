import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';

import 'common_widgets.dart';

class WeightGaugePainter extends CustomPainter {
  WeightGaugePainter(this.label,
      {required this.strength,
      required this.weight,
      this.showTicks = true,
      this.showPercentages = true});

  final String label;
  final double strength;
  final double weight;
  final bool showTicks;
  final bool showPercentages;

  @override
  void paint(Canvas canvas, Size size) {
    double height =
        (showPercentages) ? weightBarHeight + Sizes.medium : weightBarHeight;
    debugPrint('WeightGauge: $showPercentages, $height');

    size = Size(weightGaugeSizeWidth, height);

    // Draw the weight bar
    var roundedRectangle = RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: const Offset(weightBarWidth / 2, weightBarHeight / 2),
            width: weightBarWidth,
            height: weightBarHeight),
        const Radius.circular(weightBarHeight / 2));
    canvas.drawRRect(roundedRectangle, GaugeStyle.weightBarpaint);

    double prevWidth = 0;
    for (var i = 0; i <= 10; i++) {
      // Draw the ticks
      if (showTicks) {
        canvas.drawLine(
            Offset(weightBarHeight / 2 + prevWidth, 0),
            Offset(weightBarHeight / 2 + prevWidth, mainBarHeight),
            GaugeStyle.tickPaint);
      }

      // Paint the percentages
      if (showPercentages) {
        labelPainter(
          canvas,
          GaugeStyle.legend,
          TextAlign.justify,
          '${(i * 10).toInt().toString()}%',
          size,
          Offset(
              (weightBarHeight - GaugeStyle.legend.fontSize!) / 2 + prevWidth,
              mainBarHeight + tickOffset),
        );
      }

      prevWidth += (weightBarWidth - weightBarHeight) / 10;
    }

    labelPainter(
        canvas,
        TextStyles.bodyHeightSmall,
        TextAlign.left,
        label,
        size,
        Offset(weightBarHeight / 2,
            (weightBarHeight - TextStyles.bodyHeightSmall.fontSize!) / 2));

    double rangeBarWidth =
        strength / weight * (weightBarWidth - weightBarHeight) + rangeBarHeight;

    if (strength != 0) {
      // draw the range bar
      drawRangeBar(canvas, mainBarHeight / 2, rangeBarWidth, 0);
      // Draw the strength circle
      drawNumberCircle(canvas, strength.round().toInt(),
          rangeBarWidth - rangeBarHeight + weightBarHeight / 2, 0);
    }

    if (weight != 0) {
      // Draw the weight circle at the 100% tick
      drawNumberCircle(canvas, weight.round().toInt(),
          weightBarWidth - weightBarHeight / 2, 0);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

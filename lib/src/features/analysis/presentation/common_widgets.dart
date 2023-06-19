// draws a grade inside a circle
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';

void drawNumberCircle(
    Canvas canvas, int grade, double xOffset, double yOffset) {
  // Draw the Circle
  canvas.drawCircle(Offset(xOffset, yOffset + mainBarHeight / 2), circleRadius,
      GaugeStyle.circlePaint);

  // Draw the grade inside the circle
  labelPainter(
      canvas,
      GaugeStyle.number,
      TextAlign.center,
      grade.toString(),
      Size(2 * circleRadius, 2 * circleRadius),
      Offset(xOffset - circleRadius,
          yOffset + (mainBarHeight - GaugeStyle.number.fontSize!) / 2));
}

void labelPainter(Canvas canvas, TextStyle style, TextAlign textAlign,
    String label, Size size, Offset offset) {
  final ParagraphBuilder paragraphBuilder = ParagraphBuilder(
    ParagraphStyle(
      fontSize: style.fontSize,
      fontFamily: style.fontFamily,
      fontStyle: style.fontStyle,
      fontWeight: style.fontWeight,
      textAlign: textAlign,
    ),
  )
    ..pushStyle(style.getTextStyle())
    ..addText(label);
  final Paragraph paragraph = paragraphBuilder.build()
    ..layout(ParagraphConstraints(width: size.width));
  canvas.drawParagraph(paragraph, offset);
}

void drawRangeBar(
    Canvas canvas, double rangeStart, double rangeBarWidth, double yOffset) {
  Offset centre = Offset(rangeStart + rangeBarWidth / 2 - rangeBarHeight / 2,
      yOffset + mainBarHeight / 2);

  var roundedRectangle = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: centre, width: rangeBarWidth, height: rangeBarHeight),
      Radius.circular(rangeBarHeight / 2));
  canvas.drawRRect(roundedRectangle, GaugeStyle.rangeBarPaint);
}

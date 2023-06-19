import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/analysis/presentation/common_widgets.dart';

// The grade rankings, colours and ranges are based on theCrag.com
enum Grade {
  beginner('Beginner', Colors.green, 6, 12),
  intermediate('Intermediate', Colors.yellow, 13, 18),
  experienced('Experienced', Colors.orange, 19, 24),
  expert('Expert', Colors.red, 25, 32),
  elite('Elite', Colors.purple, 33, 39);

  const Grade(this.label, this.color, this.startGrade, this.endGrade);
  final String label;
  final MaterialColor color;
  final double startGrade;
  final double endGrade;
}

double xOrigin = gradeRectWidth / 2;
double yOrigin = legendOffset + labelOffset;
bool displayTicks = false;

class GradeGaugePainter extends CustomPainter {
  GradeGaugePainter(this.gradeMin, this.gradeMax);
  final int gradeMin;
  final int gradeMax;

  @override
  void paint(Canvas canvas, Size size) {
    size = Size(gradeGaugeSizeWidth, 200);
    double prevWidth = 0;
    var paintGrade = Paint()
      ..color = Color(Grade.beginner.color.value)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    var gradeStyle = TextStyle(
        fontSize: Sizes.medium, color: Color(Grade.beginner.color.value));
    // Draw the first tick and grade label
    if (displayTicks) {
      canvas.drawLine(Offset(xOrigin, yOrigin),
          Offset(xOrigin, yOrigin + mainBarHeight + tickOffset), paintGrade);
      labelPainter(
          canvas,
          gradeStyle,
          TextAlign.left,
          Grade.beginner.startGrade.toInt().toString(),
          Size(gradeRectWidth, Sizes.medium),
          Offset(xOrigin - gradeRectWidth / 4,
              yOrigin + mainBarHeight + labelOffset));
    }
    for (var gradeRange in Grade.values) {
      // Draw each of the Grade Range Bars
      paintGrade.color = gradeRange.color;
      double rectWidth =
          (gradeRange.endGrade - gradeRange.startGrade + 1) * gradeRectWidth;
      switch (gradeRange) {
        case Grade.beginner:
          var roundedRectangle = RRect.fromLTRBAndCorners(
              xOrigin - gradeRectWidth / 2,
              yOrigin,
              xOrigin + rectWidth,
              yOrigin + mainBarHeight,
              topLeft: Radius.circular(mainBarHeight),
              bottomLeft: Radius.circular(mainBarHeight));
          canvas.drawRRect(roundedRectangle, paintGrade);
        case Grade.elite:
          var roundedRectangle = RRect.fromLTRBAndCorners(
              xOrigin + prevWidth,
              yOrigin,
              xOrigin + prevWidth + rectWidth + gradeRectWidth / 2,
              yOrigin + mainBarHeight,
              topRight: Radius.circular(mainBarHeight),
              bottomRight: Radius.circular(mainBarHeight));
          canvas.drawRRect(roundedRectangle, paintGrade);
        case Grade.intermediate || Grade.experienced || Grade.expert:
          canvas.drawRect(
              Offset(xOrigin + prevWidth, yOrigin) &
                  Size(rectWidth, mainBarHeight),
              paintGrade);
      }

      // Draw the Legends
      var legendStyle = TextStyle(
          fontSize: Sizes.medium, color: Color(gradeRange.color.value));

      labelPainter(
          canvas,
          legendStyle,
          TextAlign.center,
          gradeRange.label,
          Size(rectWidth, Sizes.medium),
          Offset(xOrigin + prevWidth, yOrigin - Sizes.medium - legendOffset));

      prevWidth += rectWidth;

      // Draw the grade tick marks
      if (displayTicks) {
        drawMainTicksAndLabels(canvas, prevWidth, paintGrade, gradeRange);
      }
    }
    // Draw tick marks and grade for each grade
    var tickPaint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    prevWidth = 0;

    for (var i = Grade.beginner.startGrade; i <= Grade.elite.endGrade; i++) {
      // Draw tick marks for each grade except for the first tick
      if (i != Grade.beginner.startGrade) {
        canvas.drawLine(Offset(xOrigin + prevWidth, yOrigin),
            Offset(xOrigin + prevWidth, yOrigin + mainBarHeight), tickPaint);
      }
      // Draw grade for each grade
      labelPainter(
          canvas,
          TextStyles.grade,
          TextAlign.center,
          i.toInt().toString(),
          Size(gradeRectWidth, mainBarHeight),
          Offset(xOrigin + prevWidth,
              yOrigin + mainBarHeight / 2 - Sizes.medium / 2));

      prevWidth += gradeRectWidth;
    }

    //Draw a range bar to show user grade range
    drawUserBar(canvas, size, gradeMin, gradeMax);
  }

  void drawMainTicksAndLabels(
      Canvas canvas, double prevWidth, Paint paint, Grade gradeRange) {
    canvas.drawLine(
        Offset(prevWidth + xOrigin, yOrigin),
        Offset(prevWidth + xOrigin, yOrigin + mainBarHeight + tickOffset),
        paint);

    // Draw the grade labels
    var style =
        TextStyle(fontSize: Sizes.small, color: Color(gradeRange.color.value));
    labelPainter(
        canvas,
        style,
        TextAlign.center,
        gradeRange.endGrade.toInt().toString(),
        Size(gradeRectWidth, Sizes.medium),
        Offset(xOrigin + prevWidth - gradeRectWidth / 2,
            yOrigin + mainBarHeight + labelOffset));
  }

  drawUserBar(Canvas canvas, Size size, int startGrade, int endGrade) {
    double startGradeOffset = calcGradeOffset(startGrade);
    double endGradeOffset = calcGradeOffset(endGrade);

    double userBarWidth =
        (endGrade - startGrade) * gradeRectWidth + rangeBarHeight;
    if (endGrade > 6) {
      //Draw a range bar to show user grade range
      drawRangeBar(canvas, startGradeOffset, userBarWidth, yOrigin);

      // Draw the circles to display the start and end grades

      drawNumberCircle(canvas, startGrade, startGradeOffset, yOrigin);
      drawNumberCircle(canvas, endGrade, endGradeOffset, yOrigin);
    }
  }

  double calcGradeOffset(int startGrade) {
    double startGradeOffset =
        (startGrade - Grade.beginner.startGrade + 1) * gradeRectWidth +
            xOrigin -
            gradeRectWidth / 2;
    return startGradeOffset;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

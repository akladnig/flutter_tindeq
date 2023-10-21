import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tindeq/src/common_widgets/text.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_chart_view.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';

class TestView extends HookWidget {
  const TestView(
    this.testTitle, {
    super.key,
    required this.dataLeft,
    this.dataRight,
    this.points,
    this.legends,
    this.lines,
    // required this.startButton,
    // this.startButtonRight,
    required this.countdownTime,
    required this.duration,
    this.units = "kg",
    required this.results,
  });
  final PointList dataLeft;
  final PointList? dataRight;
  final PointList? points;
  final List<Legend>? legends;
  final List<(Line, Color)>? lines;
  final String testTitle;
  // final StartButton startButton;
  // final StartButton? startButtonRight;
  final CountDownWidget countdownTime;
  final int duration;
  final String units;
  final Widget results;

  @override
  Widget build(BuildContext context) {
    //TODO get this from a provider
    double mediaWidth = MediaQuery.of(context).size.width;
    debugPrint(mediaWidth.toString());
    // var resultsWidth = mediaWidth * 0.3;
    var plotWidth = mediaWidth * 0.6;
    return ListView(
      padding: const EdgeInsets.symmetric(
          vertical: Sizes.medium, horizontal: Sizes.medium),
      children: <Widget>[
        // Title of the test
        TextPara(testTitle, style: TextStyles.h1Colour, margin: Sizes.medium),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.fromLTRB(Sizes.small, 0, Sizes.xxSmall, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [results],
              ),
            ),
            // Plot the Test Chart
            Expanded(
              child: Container(
                alignment: Alignment.center,
                width: plotWidth,
                // height: plotHeight,
                child: TestChart(
                  legends: legends,
                  dataLeft: dataLeft,
                  dataRight: dataRight,
                  duration: duration,
                  points: points,
                  lines: lines,
                ),
              ),
            )
          ],
        ),
        countdownTime,
      ],
    );
  }
}

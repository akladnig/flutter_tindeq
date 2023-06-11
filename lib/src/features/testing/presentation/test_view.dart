import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
  final PointListClass dataLeft;
  final PointListClass? dataRight;
  final PointListClass? points;
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
    double mediaWidth = MediaQuery.of(context).size.width;
    debugPrint(mediaWidth.toString());
    // var resultsWidth = mediaWidth * 0.3;
    var plotWidth = mediaWidth * 0.6;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: <Widget>[
        const SizedBox(height: 80.0),
        // Title of the test
        Text(testTitle, style: TextStyles.h1Colour),
        Container(
          constraints: const BoxConstraints.expand(height: 600),
          // Row containing the results column and testchart column
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        //  Displays the results
                        children: [results],
                      ),
                      // Displays the count down timer
                      countdownTime,
                    ],
                  ),
                ),
              ),
              // Plot the Test Chart
              Container(
                alignment: Alignment.center,
                width: plotWidth,
                height: 400,
                child: TestChart(
                  legends: legends,
                  dataLeft: dataLeft,
                  dataRight: dataRight,
                  duration: duration,
                  points: points,
                  lines: lines,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
